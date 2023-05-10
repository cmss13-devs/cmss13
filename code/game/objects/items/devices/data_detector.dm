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

	for(var/obj/current_object in orange(detector_range, loc))
		var/detected
		for(var/DT in objects_to_detect)
			if(istype(current_object, DT))
				detected = TRUE
			if(current_object.contents)
				for(var/obj/item/CI in current_object.contents)
					if(istype(CI, DT))
						detected = TRUE
						break
			if(human_user && detected)
				show_blip(human_user, current_object)
			if(detected)
				break

		if(detected)
			detected_sound = TRUE

		CHECK_TICK

	for(var/mob/current_mob in orange(detector_range, loc))
		var/detected
		if(loc == null || current_mob == null) continue
		if(loc.z != current_mob.z) continue
		if(current_mob == loc) continue //device user isn't detected
		if((isxeno(current_mob) || isyautja(current_mob)) && current_mob.stat == DEAD )
			detected = TRUE
		else if(ishuman(current_mob) && current_mob.stat == DEAD && current_mob.contents.len)
			for(var/obj/current_object in current_mob.contents_twice())
				for(var/DT in objects_to_detect)
					if(istype(current_object, DT))
						detected = TRUE
						break
				if(detected)
					break

		if(human_user && detected)
			show_blip(human_user, current_mob)
			if(detected)
				detected_sound = TRUE

		CHECK_TICK

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
	scanning = FALSE
