/obj/structure/pipes/vents
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "map_vent"
	desc = "Has a valve and pump attached to it"
	valid_directions = list(NORTH, SOUTH, EAST, WEST)

	var/area/initial_loc = null
	var/id_tag = null
	var/welded = FALSE
	var/area_uid = null
	var/global/gl_uid = 1
	var/uid

	var/vent_icon = "vent"

/obj/structure/pipes/vents/Initialize()
	. = ..()

	initial_loc = get_area(loc)
	if(initial_loc.master)
		initial_loc = initial_loc.master
	area_uid = initial_loc.uid
	if(!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/structure/pipes/vents/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/structure/pipes/vents/examine(mob/user)
	..()
	if(get_dist(user, src) <= 1)
		to_chat(user, SPAN_INFO("A small gauge in the corner reads 0.1 L/s; 0W."))
	else
		to_chat(user, SPAN_INFO("You are too far away to read the gauge."))
	if(welded)
		to_chat(user, SPAN_INFO("It seems welded shut."))

/obj/structure/pipes/vents/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return
	overlays.Cut()

	vent_icon = initial(vent_icon)
	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(T.intact_tile)
		vent_icon += "h"

	if(welded)
		vent_icon += "welded"
	else if(length(connected_to))
		vent_icon += "on"
	else
		vent_icon += "off"

	overlays += icon_manager.get_atmos_icon("device", null, null, vent_icon)

/obj/structure/pipes/vents/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T) || T.intact_tile)
			return

		add_underlay(T, dir)

/obj/structure/pipes/vents/hide()
	update_underlays()

/obj/structure/pipes/vents/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message(SPAN_NOTICE("[user] starts welding [src] with [WT]."), \
			SPAN_NOTICE("You start welding [src] with [WT]."))
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src || !WT.isOn()) return 0
				playsound(get_turf(src), 'sound/items/Welder2.ogg', 25, 1)
				if(!welded)
					user.visible_message(SPAN_NOTICE("[user] welds [src] shut."), \
					SPAN_NOTICE("You weld [src] shut."))
					welded = 1
					update_icon()
					msg_admin_niche("[key_name(user)] welded a vent pump.")
					return 1
				else
					user.visible_message(SPAN_NOTICE("[user] welds [src] open."), \
					SPAN_NOTICE("You weld [src] open."))
					welded = 0
					msg_admin_niche("[key_name(user)] un-welded a vent pump.")
					update_icon()
					return 1
			else
				to_chat(user, SPAN_WARNING("[W] needs to be on to start this task."))
				return 0
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return 1

	if(!iswrench(W))
		return ..()
	var/turf/T = src.loc
	if(isturf(T) && T.intact_tile)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return 1

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins unfastening [src]."),
	SPAN_NOTICE("You begin unfastening [src]."))
	if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
		SPAN_NOTICE("You unfasten [src]."))
		new /obj/item/pipe(loc, null, null, src)
		qdel(src)

/obj/structure/pipes/vents/Destroy()
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	. = ..()
