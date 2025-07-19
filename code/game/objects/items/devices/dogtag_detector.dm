/obj/item/device/motiondetector/dogtag
	name = "dogtag detector"
	desc = "A device that detects fallen marine's dogtags."
	icon_state = "dogtagdetector"
	item_state = "dogtag_detector"
	blip_type = "dogtag"
	w_class = SIZE_SMALL

/obj/item/device/motiondetector/dogtag/get_help_text()
	. = "Red indicators on your HUD will show the location of dogtags detected by the scanner. Has two modes: slow long-range [SPAN_HELPFUL("(14 tiles)")] and fast short-range [SPAN_HELPFUL("(7 tiles)")]."

/obj/item/device/motiondetector/dogtag/update_icon()
	if (active)
		icon_state = "[initial(icon_state)]_on_[detector_mode]"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/motiondetector/dogtag/scan()
	if(scanning)
		return
	scanning = TRUE

	if(!ishuman(loc))
		return

	var/mob/living/carbon/human/human_user = loc

	var/detected_sound = FALSE

	var/list/nearby = orange(detector_range, loc)
	nearby -= loc  // remove the user from detection

	for(var/mob/living/carbon/human/sourcemob in nearby)
		if(loc.z != sourcemob?.z)
			continue

		if(sourcemob.undefibbable && length(sourcemob.contents) && sourcemob.faction == FACTION_MARINE)
			for(var/obj/I in sourcemob.contents_twice())
				if(istype(I, /obj/item/card/id/dogtag))
					show_blip(human_user, sourcemob)
					detected_sound = TRUE

		CHECK_TICK

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
	scanning = FALSE
