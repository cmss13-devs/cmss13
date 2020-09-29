
#define MOTION_DETECTOR_LONG	0
#define MOTION_DETECTOR_SHORT	1


/obj/effect/detector_blip
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "detector_blip"
	layer = BELOW_FULLSCREEN_LAYER

/obj/item/device/motiondetector
	name = "motion detector"
	desc = "A device that detects movement, but ignores marines. The screen will show the amount of unidentified movement detected (up to 9). You can switch modes with Alt+Click."
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "detector"
	item_state = "motion_detector"
	flags_atom = FPRINT| CONDUCT
	flags_equip_slot = SLOT_WAIST
	var/list/blip_pool = list()
	var/detector_range = 14
	var/detector_mode = MOTION_DETECTOR_LONG
	var/ping_count = 0
	w_class = SIZE_MEDIUM
	var/active = 0
	var/recycletime = 120
	var/long_range_cooldown = 2
	var/blip_type = "detector"
	var/iff_signal = FACTION_MARINE
	actions_types = list(/datum/action/item_action)
	var/scanning = FALSE // controls if MD is in process of scan
	var/datum/shape/rectangle/range_bounds

/obj/item/device/motiondetector/New()
	range_bounds = new //Just creating a rectangle datum
	..()

/obj/item/device/motiondetector/update_icon()
	if(ping_count > 8)
		icon_state = "detector_on_9_b"
		spawn(10)
			if(active)
				icon_state = "detector_on_9"
	else
		icon_state = "detector_on_[ping_count]_b"
		spawn(10)
			if(active)
				icon_state = "detector_on_[ping_count]"

/obj/item/device/motiondetector/verb/toggle_range_mode()
	set name = "Toggle Range Mode"
	set category = "Object"

	toggle_mode(usr)

/obj/item/device/motiondetector/proc/toggle_mode(mob/user)
	if(isobserver(user) || isXeno(user) || !Adjacent(user))
		return

	detector_mode = !detector_mode
	if(detector_mode)
		to_chat(user, SPAN_NOTICE("You switch [src] to short range mode."))
		detector_range = 7
	else
		to_chat(user, SPAN_NOTICE("You switch [src] to long range mode."))
		detector_range = 14
	if(active)
		update_icon()

/obj/item/device/motiondetector/clicked(mob/user, list/mods)
	if (isobserver(user) || isXeno(user)) return

	if (mods["alt"])
		toggle_mode(user)
		return 1

	return ..()

/obj/item/device/motiondetector/attack_self(mob/user)
	if(ishuman(user))
		toggle_active(user, active)

// var/active is used to forcefully toggle it to a specific state
/obj/item/device/motiondetector/proc/toggle_active(mob/user, var/old_active)
	active = !old_active	
	if(active)
		update_icon()
		if(user)
			to_chat(user, SPAN_NOTICE("You activate [src]."))
		playsound(loc, 'sound/items/detector_turn_on.ogg', 30, 0, 5, 2)
		processing_objects.Add(src)
	else
		scanning = FALSE // safety if MD runtimes in scan and stops scanning
		icon_state = "[initial(icon_state)]"
		if(user)
			to_chat(user, SPAN_NOTICE("You deactivate [src]."))
		playsound(loc, 'sound/items/detector_turn_off.ogg', 30, 0, 5, 2)
		processing_objects.Remove(src)

/obj/item/device/motiondetector/Destroy()
	processing_objects.Remove(src)
	for(var/obj/X in blip_pool)
		qdel(X)
	blip_pool = list()
	..()

/obj/item/device/motiondetector/process()
	if(isturf(loc))
		toggle_active(null, TRUE)
	if(!active)
		processing_objects.Remove(src)
		return
	recycletime--
	if(!recycletime)
		recycletime = initial(recycletime)
		for(var/X in blip_pool) //we dump and remake the blip pool every few minutes
			if(blip_pool[X])	//to clear blips assigned to mobs that are long gone.
				qdel(blip_pool[X])
		blip_pool = list()

	if(!detector_mode)
		long_range_cooldown--
		if(long_range_cooldown) return
		else long_range_cooldown = initial(long_range_cooldown)

	scan()

/obj/item/device/motiondetector/proc/scan()
	set waitfor = 0
	if(scanning)
		return
	scanning = TRUE
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	ping_count = 0

	var/turf/cur_turf = get_turf(src)
	if(!istype(cur_turf))
		return

	if(!range_bounds)
		range_bounds = new/datum/shape/rectangle
	range_bounds.center_x = cur_turf.x
	range_bounds.center_y = cur_turf.y
	range_bounds.width = detector_range * 2
	range_bounds.height = detector_range * 2

	var/list/ping_candidates = SSquadtree.players_in_range(range_bounds, cur_turf.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)

	for(var/mob/M in ping_candidates)
		if(M == loc) continue //device user isn't detected
		if(world.time > M.l_move_time + 20) continue //hasn't moved recently
		if(isrobot(M)) continue
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.get_target_lock(iff_signal))
				continue
		ping_count++
		if(human_user)
			show_blip(human_user, M)

	if(ping_count > 0)
		playsound(loc, pick('sound/items/detector_ping_1.ogg', 'sound/items/detector_ping_2.ogg', 'sound/items/detector_ping_3.ogg', 'sound/items/detector_ping_4.ogg'), 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 60, 0, 7, 2)

	update_icon()
	scanning = FALSE


/obj/item/device/motiondetector/proc/show_blip(mob/user, mob/target)
	set waitfor = 0
	if(user && user.client)

		if(!blip_pool[target])
			blip_pool[target] = new /obj/effect/detector_blip

		var/obj/effect/detector_blip/DB = blip_pool[target]
		var/c_view = user.client.view
		var/view_x_offset = 0
		var/view_y_offset = 0
		if(c_view > 7)
			if(user.client.pixel_x >= 0) view_x_offset = round(user.client.pixel_x/32)
			else view_x_offset = Ceiling(user.client.pixel_x/32)
			if(user.client.pixel_y >= 0) view_y_offset = round(user.client.pixel_y/32)
			else view_y_offset = Ceiling(user.client.pixel_y/32)

		var/diff_dir_x = 0
		var/diff_dir_y = 0
		if(target.x - user.x > c_view + view_x_offset) diff_dir_x = 4
		else if(target.x - user.x < -c_view + view_x_offset) diff_dir_x = 8
		if(target.y - user.y > c_view + view_y_offset) diff_dir_y = 1
		else if(target.y - user.y < -c_view + view_y_offset) diff_dir_y = 2
		if(diff_dir_x || diff_dir_y)
			DB.icon_state = "[blip_type]_blip_dir"
			DB.dir = diff_dir_x + diff_dir_y
		else
			DB.icon_state = "[blip_type]_blip"
			DB.dir = initial(DB.dir)

		DB.screen_loc = "[Clamp(c_view + 1 - view_x_offset + (target.x - user.x), 1, 2*c_view+1)],[Clamp(c_view + 1 - view_y_offset + (target.y - user.y), 1, 2*c_view+1)]"
		user.client.screen += DB
		sleep(12)
		if(user.client)
			user.client.screen -= DB

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
		/obj/item/device/autopsy_scanner/objective,
		/obj/item/paper/research_notes,
		/obj/item/reagent_container/glass/beaker/vial/random,
		/obj/item/storage/fancy/vials/random,
		/obj/structure/machinery/computer/objective,
		/obj/item/limb/head/synth,
	)

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
				detected = TRUE
			if(I.contents)
				for(var/obj/item/CI in I.contents)
					if(istype(CI, DT))
						detected = TRUE
						break
			if(human_user && detected)
				show_blip(human_user, I)
			if(detected)
				break

		if(detected)
			detected_sound = TRUE
		
		CHECK_TICK

	for(var/mob/M in orange(detector_range, loc))
		var/detected
		if(loc == null || M == null) continue
		if(loc.z != M.z) continue
		if(M == loc) continue //device user isn't detected
		if((isXeno(M) || isYautja(M)) && M.stat == DEAD )
			detected = TRUE
		else if(ishuman(M) && M.stat == DEAD && M.contents.len)
			for(var/obj/I in M.contents_twice())
				for(var/DT in objects_to_detect)
					if(istype(I, DT))
						detected = TRUE
						break
				if(detected)
					break

		if(human_user && detected)
			show_blip(human_user, M)
			if(detected)
				detected_sound = TRUE

		CHECK_TICK

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 50, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)

	scanning = FALSE