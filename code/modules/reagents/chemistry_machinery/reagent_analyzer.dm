/obj/structure/machinery/reagent_analyzer
	name = "\improper XRF scanner"
	desc = "A spectrometer that bombards a sample in high energy radiation to detect emitted fluorescent x-ray patterns. By using the emission spectrum of the sample it can identify its chemical composition."
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "reagent_analyzer"
	active_power_usage = 5000 //This is how many watts the big XRF machines usually take

	var/mob/last_used
	var/obj/item/reagent_container/sample = null //Object containing our sample
	var/sample_number = 1 //Just for printing fluff
	var/processing = FALSE
	var/status = 0

/obj/structure/machinery/reagent_analyzer/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("[src] is still processing!"))
		return
	if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/reagent_container/glass/beaker/vial))
		if(sample || status)
			to_chat(user, SPAN_WARNING("Something is already loaded into [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			sample = B
			icon_state = "reagent_analyzer_sample"
			to_chat(user, SPAN_NOTICE("You insert [B] and start configuring [src]."))
			updateUsrDialog()
			if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return
			if(!sample)
				to_chat(user, SPAN_WARNING("Someone else removed the sample. Make up your mind!"))
				return
			processing = TRUE
			if(sample.reagents.total_volume < 30 || length(sample.reagents.reagent_list) > 1)
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
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/reagent_analyzer, reagent_process)), 2 SECONDS)
		return
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/reagent_analyzer, finish_reagent_process)), 4 SECONDS)

/obj/structure/machinery/reagent_analyzer/proc/finish_reagent_process()
	if(!sample || !sample.reagents || sample.reagents.total_volume < 30 || length(sample.reagents.reagent_list) > 1)
		if(!sample || !sample.reagents)
			print_report(0, "SAMPLE EMPTY.")
		else if(sample.reagents.total_volume < 30)
			print_report(0, "SAMPLE SIZE INSUFFICIENT;<BR>\n<I>A sample size of 30 units is required for analysis.</I>")
		else if(length(sample.reagents.reagent_list) > 1)
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
	status = 0
	processing = FALSE

/obj/structure/machinery/reagent_analyzer/attack_hand(mob/user as mob)
	if(processing)
		to_chat(user, SPAN_WARNING("[src] is still processing!"))
		return
	if(!sample)
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return
	to_chat(user, SPAN_NOTICE("You remove [sample] from [src]."))
	user.put_in_active_hand(sample)
	sample = null
	icon_state = "reagent_analyzer"
	return

/obj/structure/machinery/reagent_analyzer/proc/print_report(result, reason)
	var/obj/item/paper/research_report/report = new /obj/item/paper/research_report/(loc)
	if(result)
		var/datum/reagent/S = sample.reagents.reagent_list[1]
		S.print_report(report = report, sample_number = sample_number)
		sample.name = "vial ([S.name])"
		GLOB.chemical_data.save_document(report, "XRF Scans", "[sample_number] - [report.name]")
		if(S.chemclass < CHEM_CLASS_SPECIAL || (S.chemclass >= CHEM_CLASS_SPECIAL && report.completed))
			GLOB.chemical_data.save_new_properties(S.properties)
		if(S.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[S.id])
			if(last_used)
				last_used.count_niche_stat(STATISTICS_NICHE_CHEMS)
			var/datum/chem_property/P = S.get_property(PROPERTY_DNA_DISINTEGRATING)
			if(P)
				if(!GLOB.chemical_data.ddi_discovered && GLOB.chemical_data.reached_x_access)
					P.trigger()
					GLOB.chemical_data.ddi_discovered = TRUE
				else
					return

			GLOB.chemical_data.complete_chemical(S)
	else
		var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
		report.name = "Analysis of ERROR"
		report.info += "<center><img src = [asset.get_url_mappings()["logo_wy.png"]]><HR><I><B>Official Weyland-Yutani Document</B><BR>Reagent Analysis Print</I><HR><H2>Analysis ERROR</H2></center>"
		report.info += "<B>Result:</B><BR>Analysis failed for sample #[sample_number].<BR><BR>\n"
		report.info += "<B>Reason for error:</B><BR><I>[reason]</I><BR>\n"
	report.info += "<BR><HR><font size = \"1\"><I>This report was automatically printed by the A-XRF Scanner.<BR>The [MAIN_SHIP_NAME], [time2text(world.timeofday, "MM/DD")]/[GLOB.game_year], [worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"

/datum/reagent/proc/print_report(turf/loc, obj/item/paper/research_report/report, admin_spawned = FALSE, sample_number = 0)
	if(!report)
		report = new /obj/item/paper/research_report(loc)

	report.name = "Analysis of [name]"
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	report.info += "<center><img src = [asset.get_url_mappings()["logo_wy.png"]]><HR><I><B>Official Weyland-Yutani Document</B><BR>Automated A-XRF Report</I><HR><H2>Analysis of [name]</H2></center>"
	if(sample_number)
		report.info += "<B>Results for sample:</B> #[sample_number]<BR>\n"
	report.generate(GLOB.chemical_reagents_list[id], admin_spawned)
