/obj/structure/machinery/reagent_analyzer/skilless
	name = "\improper intel XRF scanner"
	desc = "A spectrometer that bombards a sample in high energy radiation to detect emitted fluorescent x-ray patterns. By using the emission spectrum of the sample it can identify its chemical composition. This version for intel group."

/obj/structure/machinery/reagent_analyzer/skilless/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("[src] is still processing!"))
		return
	if(!skillcheck(usr, SKILL_INTEL, SKILL_INTEL_TRAINED))
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
