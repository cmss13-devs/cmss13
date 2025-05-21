
#define MOTION_DETECTOR_LONG 0
#define MOTION_DETECTOR_SHORT 1

#define MOTION_DETECTOR_RANGE_LONG 14
#define MOTION_DETECTOR_RANGE_SHORT 7

/obj/effect/detector_blip
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "detector_blip"
	layer = BELOW_FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE

/obj/effect/detector_blip/m717
	icon_state = "tracker_blip"

/obj/item/device/motiondetector
	name = "motion detector"
	desc = "A device that detects movement, but ignores marines. Can also be used to scan a vehicle interior from outside, but accuracy of such scanning is low and there is no way to differentiate friends from foes."
	icon = 'icons/obj/items/marine-items.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
	)
	icon_state = "detector"
	item_state = "motion_detector"
	flags_atom = FPRINT| CONDUCT
	flags_equip_slot = SLOT_WAIST
	inherent_traits = list(TRAIT_ITEM_NOT_IMPLANTABLE)
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
	actions_types = list(/datum/action/item_action/toggle)
	var/scanning = FALSE // controls if MD is in process of scan
	var/datum/shape/rectangle/square/range_bounds
	var/long_range_locked = FALSE //only long-range MD
	var/ping_overlay

/obj/item/device/motiondetector/proc/get_help_text()
	. = "Blue bubble-like indicators on your HUD will show pings locations or direction to them. The device screen will show the amount of unidentified movements detected (up to 9). Has two modes: slow long-range [SPAN_HELPFUL("([MOTION_DETECTOR_RANGE_LONG] tiles)")] and fast short-range [SPAN_HELPFUL("([MOTION_DETECTOR_RANGE_SHORT] tiles)")]. Use [SPAN_HELPFUL("Alt + Click")] on the device to switch between modes. Using the device on the adjacent multitile vehicle will start the process of recalibrating and scanning vehicle interior for unidentified movements inside."

/obj/item/device/motiondetector/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO(get_help_text())

/obj/item/device/motiondetector/Initialize()
	. = ..()
	range_bounds = new //Just creating a square datum
	update_icon()

/obj/item/device/motiondetector/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/to_delete in blip_pool)
		qdel(blip_pool[to_delete])
		blip_pool.Remove(to_delete)
	blip_pool = null
	range_bounds = null
	return ..()

/obj/item/device/motiondetector/update_icon()
	//clear overlays
	if(overlays)
		overlays.Cut()
	else
		overlays = list()

	if(blood_overlay)
		overlays += blood_overlay
	//add ping overlay
	if(ping_count > 8)
		ping_overlay = "+[initial(icon_state)]_on_9"
	else
		ping_overlay = "+[initial(icon_state)]_on_[ping_count]"
	var/image/ping_overlay_image = ping_overlay
	if(active)
		overlays += ping_overlay_image
	//add toggle switch overlay
	if(detector_mode)
		overlays += "+[initial(icon_state)]_long_switch"
	else
		overlays += "+[initial(icon_state)]_short_switch"

/obj/item/device/motiondetector/verb/toggle_range_mode()
	set name = "Toggle Range Mode"
	set category = "Object"
	set src in usr
	if(!long_range_locked)
		toggle_mode(usr)
	else
		to_chat(usr, SPAN_WARNING("ERROR: 'SHORT-RANGE' MODE NOT LOCATED."))

/obj/item/device/motiondetector/proc/toggle_mode(mob/user)
	if(isobserver(user) || isxeno(user) || !Adjacent(user))
		return

	detector_mode = !detector_mode
	if(detector_mode)
		to_chat(user, SPAN_NOTICE("You switch [src] to short-range mode."))
		detector_range = 7
	else
		to_chat(user, SPAN_NOTICE("You switch [src] to long-range mode."))
		detector_range = 14
	update_icon()
	playsound(usr,'sound/machines/click.ogg', 15, TRUE)

/obj/item/device/motiondetector/clicked(mob/user, list/mods)
	if (isobserver(user) || isxeno(user)) return

	if (mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		if(!long_range_locked)
			toggle_mode(usr)
		else
			to_chat(usr, SPAN_WARNING("ERROR: 'SHORT-RANGE' MODE NOT LOCATED."))
		return TRUE

	return ..()

/obj/item/device/motiondetector/attack_self(mob/user)
	..()

	if(ishuman(user))
		toggle_active(user, active)

// var/active is used to forcefully toggle it to a specific state
/obj/item/device/motiondetector/proc/toggle_active(mob/user, old_active, forced = FALSE)
	active = !old_active
	if(!active)
		turn_off(user, forced)
	else
		turn_on(user, forced)
	update_icon()

/obj/item/device/motiondetector/proc/turn_on(mob/user, forced = FALSE)
	if(forced)
		visible_message(SPAN_NOTICE("\The [src] turns on."), SPAN_NOTICE("You hear a beep."), 3)
	else if(user)
		to_chat(user, SPAN_NOTICE("You activate \the [src]."))
	playsound(loc, 'sound/items/detector_turn_on.ogg', 30, FALSE, 5, 2)
	START_PROCESSING(SSobj, src)

/obj/item/device/motiondetector/proc/turn_off(mob/user, forced = FALSE)
	if(forced)
		visible_message(SPAN_NOTICE("\The [src] shorts out."), SPAN_NOTICE("You hear a click."), 3)
	else if(user)
		to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))
	scanning = FALSE // safety if MD runtimes in scan and stops scanning
	icon_state = "[initial(icon_state)]"
	playsound(loc, 'sound/items/detector_turn_off.ogg', 30, FALSE, 5, 2)
	STOP_PROCESSING(SSobj, src)

/obj/item/device/motiondetector/process()
	if(isturf(loc))
		toggle_active(null, TRUE)
	if(!active)
		STOP_PROCESSING(SSobj, src)
		return
	recycletime--
	if(!recycletime)
		recycletime = initial(recycletime)
		refresh_blip_pool()

	if(!detector_mode)
		long_range_cooldown--
		if(long_range_cooldown)
			return
		else
			long_range_cooldown = initial(long_range_cooldown)

	scan()

/obj/item/device/motiondetector/proc/refresh_blip_pool()
	for(var/X in blip_pool) //we dump and remake the blip pool every few minutes
		if(blip_pool[X]) //to clear blips assigned to mobs that are long gone.
			qdel(blip_pool[X])
	blip_pool = list()

/obj/item/device/motiondetector/proc/get_user()
	if(ishuman(loc))
		return loc

/obj/item/device/motiondetector/sg

/obj/item/device/motiondetector/sg/get_user()
	var/atom/A = loc
	if(ishuman(A.loc))
		return A.loc

/obj/item/device/motiondetector/xm4

///Forces the blue blip to appear around the detected mob
/obj/item/device/motiondetector/xm4/get_user()
	var/atom/holder = loc
	if(ishuman(holder.loc))
		return holder.loc

/obj/item/device/motiondetector/proc/apply_debuff(mob/M)
	return

/obj/item/device/motiondetector/proc/scan()
	set waitfor = 0
	if(scanning)
		return
	scanning = TRUE
	var/mob/living/carbon/human/human_user = get_user()

	ping_count = 0

	var/turf/cur_turf = get_turf(src)
	if(!istype(cur_turf))
		return

	range_bounds.set_shape(cur_turf.x, cur_turf.y, detector_range * 2)

	var/list/ping_candidates = SSquadtree.players_in_range(range_bounds, cur_turf.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)

	for(var/A in ping_candidates)
		var/mob/living/M = A //do this to skip the unnecessary istype() check; everything in ping_candidate is a mob already
		if(M == loc)
			continue //device user isn't detected
		if(world.time > M.l_move_time + 20)
			continue //hasn't moved recently
		if(M.get_target_lock(iff_signal))
			continue

		apply_debuff(M)
		ping_count++
		if(human_user)
			show_blip(human_user, M)

	for(var/mob/hologram/holo as anything in GLOB.hologram_list)
		if(!holo.motion_sensed)
			continue
		if(holo.z != cur_turf.z || !(range_bounds.contains_atom(holo)))
			continue
		ping_count++
		if(human_user)
			show_blip(human_user, holo, "queen_eye")

	if(ping_count > 0)
		playsound(loc, pick('sound/items/detector_ping_1.ogg', 'sound/items/detector_ping_2.ogg', 'sound/items/detector_ping_3.ogg', 'sound/items/detector_ping_4.ogg'), 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 60, 0, 7, 2)

	update_icon()
	scanning = FALSE

	return ping_count

/obj/item/device/motiondetector/proc/show_blip(mob/user, atom/target, blip_icon)
	set waitfor = 0
	if(user && user.client)

		blip_icon = blip_icon ? blip_icon : blip_type

		if(!blip_pool[target])
			blip_pool[target] = new /obj/effect/detector_blip

		var/obj/effect/detector_blip/DB = blip_pool[target]
		var/c_view = user.client.view
		var/view_x_offset = 0
		var/view_y_offset = 0
		if(c_view > 7)
			if(user.client.pixel_x >= 0)
				view_x_offset = floor(user.client.pixel_x/32)
			else
				view_x_offset = ceil(user.client.pixel_x/32)
			if(user.client.pixel_y >= 0)
				view_y_offset = floor(user.client.pixel_y/32)
			else
				view_y_offset = ceil(user.client.pixel_y/32)

		var/diff_dir_x = 0
		var/diff_dir_y = 0
		if(target.x - user.x > c_view + view_x_offset)
			diff_dir_x = 4
		else if(target.x - user.x < -c_view + view_x_offset) diff_dir_x = 8
		if(target.y - user.y > c_view + view_y_offset)
			diff_dir_y = 1
		else if(target.y - user.y < -c_view + view_y_offset) diff_dir_y = 2
		if(diff_dir_x || diff_dir_y)
			DB.icon_state = "[blip_icon]_blip_dir"
			DB.setDir(diff_dir_x + diff_dir_y)
		else
			DB.icon_state = "[blip_icon]_blip"
			DB.setDir(initial(DB.dir))

		DB.screen_loc = "[clamp(c_view + 1 - view_x_offset + (target.x - user.x), 1, 2*c_view+1)],[clamp(c_view + 1 - view_y_offset + (target.y - user.y), 1, 2*c_view+1)]"
		user.client.add_to_screen(DB)
		addtimer(CALLBACK(src, PROC_REF(clear_pings), user, DB), 1 SECONDS)

/obj/item/device/motiondetector/proc/clear_pings(mob/user, obj/effect/detector_blip/DB)
	if(user.client)
		user.client.remove_from_screen(DB)

/obj/item/device/motiondetector/m717
	name = "M717 pocket motion detector"
	desc = "This prototype motion detector sacrifices versatility, having only the long-range mode, for size, being so small it can even fit in pockets."
	icon_state = "pocket"
	item_state = "motion_detector"
	flags_atom = FPRINT| CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	blip_type = "tracker"
	long_range_locked = TRUE

/obj/item/device/motiondetector/m717/hacked/contractor
	name = "modified M717 pocket motion detector"
	desc = "This prototype motion detector sacrifices versatility, having only the long-range mode, for size, being so small it can even fit in pockets. This one has been modified with an after-market IFF sensor to filter out Vanguard's Arrow Incorporated signals instead of USCM ones. Fight fire with fire!"
	iff_signal = FACTION_CONTRACTOR

/obj/item/device/motiondetector/hacked
	name = "hacked motion detector"
	desc = "A device that usually picks up non-USCM signals, but this one's been hacked to detect all non-UPP movement instead. Fight fire with fire!"
	iff_signal = FACTION_UPP

/obj/item/device/motiondetector/hacked/elite_merc
	name = "hacked motion detector"
	desc = "A device that usually picks up non-USCM signals, but this one's been hacked to detect all non-freelancer movement instead. Fight fire with fire!"
	iff_signal = FACTION_MERCENARY

/obj/item/device/motiondetector/hacked/pmc
	name = "corporate motion detector"
	desc = "A device that usually picks up non-USCM signals, but this one's been reprogrammed to detect all non-PMC movement instead. Very corporate."
	iff_signal = FACTION_PMC

/obj/item/device/motiondetector/hacked/dutch
	name = "hacked motion detector"
	desc = "A device that usually picks up non-USCM signals, but this one's been hacked to detect all non-Dutch's Dozen movement instead. Fight fire with fire!"
	iff_signal = FACTION_DUTCH

/obj/item/device/motiondetector/hacked/contractor
	name = "modified motion detector"
	desc = "A device that usually picks up non-USCM signals, but this one's been modified with after-market IFF sensors to detect all non-Vanguard's Arrow Incorporated movement instead. Fight fire with fire!"
	iff_signal = FACTION_CONTRACTOR

#undef MOTION_DETECTOR_RANGE_LONG
#undef MOTION_DETECTOR_RANGE_SHORT
