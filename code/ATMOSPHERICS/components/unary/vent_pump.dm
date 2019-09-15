#define PRESSURE_CHECK_INTERNAL 2

/obj/structure/machinery/atmospherics/unary/vent_pump
	icon = 'icons/obj/pipes/vent_pump.dmi'
	icon_state = "map_vent"

	name = "Air Vent"
	desc = "Has a valve and pump attached to it"

	connect_types = list(1,2) //connects to regular and supply pipes

	var/area/initial_loc
	level = 1
	var/area_uid
	var/id_tag = null

	var/on = 0
	var/pump_direction = 1 //0 = siphoning, 1 = releasing

	var/last_power_draw = 0

	var/welded = 0 // Added for aliens -- TLE

/obj/structure/machinery/atmospherics/unary/vent_pump/on
	on = 1
	icon_state = "map_vent_out"

/obj/structure/machinery/atmospherics/unary/vent_pump/siphon
	pump_direction = 0

/obj/structure/machinery/atmospherics/unary/vent_pump/siphon/on
	on = 1
	icon_state = "map_vent_in"

/obj/structure/machinery/atmospherics/unary/vent_pump/New()
	..()

	icon = null
	initial_loc = get_area(loc)
	if (initial_loc.master)
		initial_loc = initial_loc.master
	area_uid = initial_loc.uid
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)//if the game is running
		src.initialize()

/obj/structure/machinery/atmospherics/unary/vent_pump/high_volume
	name = "Large Air Vent"


/obj/structure/machinery/atmospherics/unary/vent_pump/engine
	name = "Engine Core Vent"

/obj/structure/machinery/atmospherics/unary/vent_pump/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return
	if (!node)
		on = 0

	overlays.Cut()

	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(T.intact_tile && node && node.level == 1 && istype(node, /obj/structure/machinery/atmospherics/pipe))
		vent_icon += "h"

	if(welded)
		vent_icon += "weld"
	else if(!powered())
		vent_icon += "off"
	else
		vent_icon += "[on ? "[pump_direction ? "out" : "in"]" : "off"]"

	overlays += icon_manager.get_atmos_icon("device", , , vent_icon)

/obj/structure/machinery/atmospherics/unary/vent_pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(T.intact_tile && node && node.level == 1 && istype(node, /obj/structure/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/structure/machinery/atmospherics/unary/vent_pump/hide()
	update_icon()
	update_underlays()

/obj/structure/machinery/atmospherics/unary/vent_pump/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message(SPAN_NOTICE("[user] starts welding [src] with [WT]."), \
			SPAN_NOTICE("You start welding [src] with [WT]."))
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
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
	if(!(stat & NOPOWER) && on)
		to_chat(user, SPAN_WARNING("You cannot unwrench [src], turn it off first."))
		return 1
	var/turf/T = src.loc
	if(node && node.level == 1 && isturf(T) && T.intact_tile)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return 1

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins unfastening [src]."),
	SPAN_NOTICE("You begin unfastening [src]."))
	if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
		SPAN_NOTICE("You unfasten [src]."))
		new /obj/item/pipe(loc, make_from = src)
		qdel(src)

/obj/structure/machinery/atmospherics/unary/vent_pump/examine(mob/user)
	..()
	if(get_dist(user, src) <= 1)
		to_chat(user, SPAN_INFO("A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; 0W."))
	else
		to_chat(user, SPAN_INFO("You are too far away to read the gauge."))
	if(welded)
		to_chat(user, SPAN_INFO("It seems welded shut."))

/obj/structure/machinery/atmospherics/unary/vent_pump/Dispose()
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	. = ..()


/obj/structure/machinery/atmospherics/unary/vent_pump/can_crawl_through()
	return !welded
