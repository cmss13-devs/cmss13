/obj/item/device/motiondetector/intel
	name = "data detector"
	desc = "A device that detects objects that may be useful for intel gathering. You can switch modes with Alt+Click."
	icon_state = "datadetector"
	item_state = "data_detector"
	blip_type = "data"
	var/objects_to_detect = list(
		/obj/item/document_objective,
		/obj/item/disk/objective,
		/obj/item/device/mass_spectrometer/adv/objective,
		/obj/item/device/reagent_scanner/adv/objective,
		/obj/item/device/healthanalyzer/objective,
		/obj/item/device/autopsy_scanner/objective,
		/obj/item/paper/research_notes,
		/obj/item/reagent_container/glass/beaker/vial/random,
		/obj/item/storage/fancy/vials/random,
		/obj/structure/machinery/computer/objective,
		/obj/item/limb/head/synth,
	)

/obj/item/device/motiondetector/intel/get_help_text()
	. = "Green indicators on your HUD will show the location of intelligence objects detected by the scanner. Has two modes: slow long-range [SPAN_HELPFUL("(14 tiles)")] and fast short-range [SPAN_HELPFUL("(7 tiles)")]."

/obj/item/device/motiondetector/intel/update_icon()
	if (active)
		icon_state = "[initial(icon_state)]_on_[detector_mode]"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/motiondetector/intel/scan()
	set waitfor = 0
	if(scanning)
		return
	scanning = TRUE
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	var/detected_sound = FALSE

	for(var/obj/I in orange(detector_range, loc))
		var/detected
		for(var/DT in objects_to_detect)
			if(istype(I, DT))
				if(istype(I, /obj/item/storage/fancy/vials/random) && !length(I.contents))
					break //We don't need to ping already looted containers
				if(istype(I, /obj/item/reagent_container/glass/beaker/vial/random) && !I.reagents?.total_volume)
					break //We don't need to ping already looted containers
				detected = TRUE
			if(I.contents)
				for(var/obj/item/CI in I.contents)
					if(istype(CI, DT))
						if(istype(CI, /obj/item/storage/fancy/vials/random) && !length(CI.contents))
							break
						if(istype(CI, /obj/item/reagent_container/glass/beaker/vial/random) && !CI.reagents?.total_volume)
							break
						detected = TRUE
			if(human_user && detected)
				show_blip(human_user, I)

		if(detected)
			detected_sound = TRUE

		CHECK_TICK

	for(var/mob/M in orange(detector_range, loc))
		var/detected
		if(loc == null || M == null) continue
		if(loc.z != M.z) continue
		if(M == loc) continue //device user isn't detected
		if((isxeno(M) || isyautja(M)) && M.stat == DEAD )
			detected = TRUE
		else if(ishuman(M) && M.stat == DEAD && M.contents.len)
			for(var/obj/I in M.contents_twice())
				for(var/DT in objects_to_detect)
					if(istype(I, DT))
						if(istype(I, /obj/item/storage/fancy/vials/random) && !length(I.contents))
							break
						if(istype(I, /obj/item/reagent_container/glass/beaker/vial/random) && !I.reagents?.total_volume)
							break
						detected = TRUE

		if(human_user && detected)
			show_blip(human_user, M)
			if(detected)
				detected_sound = TRUE

		CHECK_TICK

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
	scanning = FALSE
