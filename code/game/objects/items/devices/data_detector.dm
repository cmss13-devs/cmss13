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
	// Remembering our loc == human, opti purposes, don't let it scan without user, just ignore proc
	if(!istype(loc, /mob/living/carbon/human))
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
		return

	var/detected_sound = FALSE
	for(var/obj/object in orange(detector_range, loc))
		if(detect_object(object))
			show_blip(loc, object)
			detected_sound = TRUE
			continue

		if(length(object.contents))
			for(var/obj/nested_object in object.contents_recursive())
				if(!detect_object(nested_object))
					continue

				show_blip(loc, object)
				detected_sound = TRUE

	for(var/mob/creature as anything in GLOB.mob_list)
		if(!creature)
			continue

		if(loc.z != creature.z)
			continue

		if(get_dist(loc, creature) > detector_range)
			continue

		if(creature.stat != DEAD)
			continue

		if(isxeno(creature) || isyautja(creature))
			show_blip(loc, creature)
			detected_sound = TRUE
		else if(ishuman(creature))
			for(var/obj/nested_mob_object in creature.contents_recursive())
				if(!detect_object(nested_mob_object))
					continue

				show_blip(loc, creature)
				detected_sound = TRUE
				break

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)

/obj/item/device/motiondetector/intel/proc/detect_object(obj/target_item)
	for(var/req_type in objects_to_detect)
		if(!istype(target_item, req_type))
			continue

		if(req_type == /obj/item/storage/fancy/vials/random && !length(target_item.contents))
			return

		if(req_type == /obj/item/reagent_container/glass/beaker/vial/random && !target_item.reagents?.total_volume)
			return

		return TRUE
