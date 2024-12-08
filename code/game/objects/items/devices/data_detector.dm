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

// In future if youre need opti, just make component or something like that for all atoms that need to be detected, and you know... it's better than running thru all contents, rather than thru list of link to what we need to detect in global list or something like that
/obj/item/device/motiondetector/intel/scan()
	// Remembering our loc == human, opti purposes, don't let it scan without user, just ignore proc
	if(!istype(loc, /mob/living/carbon/human))
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
		return

	var/detected_sound = FALSE
	for(var/turf/scanned_turf in orange(detector_range, loc))
		for(var/atom/scanned_atom in scanned_turf.contents)
			if(istype(scanned_atom, /obj))
				var/obj/object = scanned_atom
				if(detect_object(object))
					show_blip(loc, object)
					detected_sound = TRUE
					break

				if(length(object.contents))
					var/detected_nested_object = FALSE
					for(var/obj/nested_object as anything in object.contents_recursive())
						if(!detect_object(nested_object))
							continue

						show_blip(loc, object)
						detected_sound = TRUE
						detected_nested_object = TRUE
						break

					if(detected_nested_object)
						break

			else if(istype(scanned_atom, /mob))
				if(isxeno(scanned_atom) || isyautja(scanned_atom))
					show_blip(loc, scanned_atom)
					detected_sound = TRUE
					break

				else if(ishuman(scanned_atom))
					var/detected_nested_mob_object = FALSE
					for(var/obj/nested_mob_object as anything in scanned_atom.contents_recursive())
						if(!detect_object(nested_mob_object))
							continue

						show_blip(loc, scanned_atom)
						detected_sound = TRUE
						detected_nested_mob_object = TRUE
						break

					if(detected_nested_mob_object)
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
