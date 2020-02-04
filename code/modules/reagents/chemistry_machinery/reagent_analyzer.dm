/obj/structure/machinery/reagent_analyzer
	name = "Advanced XRF Scanner"
	desc = "A spectrometer that bombards a sample in high energy radiation to detect emitted fluorescent x-ray patterns. By using the emission spectrum of the sample it can identify its chemical composition."
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "reagent_analyzer"
	active_power_usage = 5000 //This is how many watts the big XRF machines usually take

	var/mob/last_used
	var/obj/item/reagent_container/sample = null //Object containing our sample
	var/clearance_level = 1
	var/sample_number = 1 //Just for printing fluff
	var/processing = FALSE
	var/status = 0

/obj/structure/machinery/reagent_analyzer/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still processing!"))
		return
	if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/reagent_container/glass/beaker/vial))
		if(sample || status)
			to_chat(user, SPAN_WARNING("Something is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			sample = B
			icon_state = "reagent_analyzer_sample"
			to_chat(user, SPAN_NOTICE("You insert [B] and start configuring the [src]."))
			updateUsrDialog()
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return
			processing = TRUE
			if(sample.reagents.total_volume < 30 || sample.reagents.reagent_list.len > 1)
				icon_state = "reagent_analyzer_error"
				reagent_process()
			else
				icon_state = "reagent_analyzer_processing"
				reagent_process()
			last_used = user
		return
	else
		to_chat(user, SPAN_WARNING("[src] only accepts samples in vials."))
		return

/obj/structure/machinery/reagent_analyzer/proc/reagent_process()
	status++
	if(status <= 3)
		add_timer(CALLBACK(src, /obj/structure/machinery/reagent_analyzer/proc/reagent_process), SECONDS_2)
		return
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	status = 0
	processing = FALSE
	add_timer(CALLBACK(src, /obj/structure/machinery/reagent_analyzer/proc/finish_reagent_process), SECONDS_4)

/obj/structure/machinery/reagent_analyzer/proc/finish_reagent_process()
	if(sample && sample.reagents.total_volume < 30 || sample.reagents.reagent_list.len > 1)
		if(sample.reagents.total_volume < 30)
			print_report(0, "SAMPLE SIZE INSUFFICIENT;<BR>\n<I>A sample size of 30 units is required for analysis.</I>")
		else if(sample.reagents.reagent_list.len > 1)
			print_report(0, "SAMPLE CONTAMINATED;<BR>\n<I>A pure sample is required for analysis.</I>")
		else
			print_report(0, "UNKNOWN.")
		icon_state = "reagent_analyzer_failed"
		playsound(loc, 'sound/machines/buzz-two.ogg', 15, 1)
	else
		icon_state = "reagent_analyzer_finished"
		print_report(1)
		playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	sample_number++

/obj/structure/machinery/reagent_analyzer/attack_hand(mob/user as mob)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still processing!"))
		return
	if(!sample)
		to_chat(user, SPAN_WARNING("The [src] is empty."))
		return
	to_chat(user, SPAN_NOTICE("You remove the [sample] from the [src]."))
	user.put_in_active_hand(sample)
	sample = null
	icon_state = "reagent_analyzer"
	return

/obj/structure/machinery/reagent_analyzer/proc/print_report(var/result, var/reason)
	var/obj/item/paper/chem_report/report = new /obj/item/paper/chem_report/(loc)
	report.name = "Analysis of "
	if(result)
		var/datum/reagent/S = sample.reagents.reagent_list[1]
		report.name += "[S.name]"
		report.info += "<center><img src = wylogo.png><HR><I><B>Official Weston-Yamada Document</B><BR>Automated A-XRF Report</I><HR><H2>Analysis of [S.name]</H2></center>"
		report.info += "<B>Results for sample:</B> #[sample_number]<BR>\n"
		report.generate(S)
		sample.name = "vial ([S.name])"
		if(S.chemclass >= CHEM_CLASS_SPECIAL && !chemical_identified_list[S.id])
			if(last_used)
				last_used.count_niche_stat(STATISTICS_NICHE_CHEMS)
			chemical_research_data.update_credits(2)
			chemical_identified_list[S.id] = S.objective_value
			defcon_controller.check_defcon_level()
		chemical_research_data.save_document(report, "XRF Scans", "[sample_number] - [report.name]")
	else
		report.name += "ERROR"
		report.info += "<center><img src = wylogo.png><HR><I><B>Official Weston-Yamada Document</B><BR>Reagent Analysis Print</I><HR><H2>Analysis ERROR</H2></center>"
		report.info += "<B>Result:</B><BR>Analysis failed for sample #[sample_number].<BR><BR>\n"
		report.info += "<B>Reason for error:</B><BR><I>[reason]</I><BR>\n"
	report.info += "<BR><HR><font size = \"1\"><I>This report was automatically printed by the A-XRF Scanner.<BR>The USS Almayer, [time2text(world.timeofday, "MM/DD")]/[game_year], [worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"
