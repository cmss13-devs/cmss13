/obj/structure/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "map_scrubber"

	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it"

	connect_types = list(1,3) //connects to regular and scrubber pipes

	level = 1

	var/area/initial_loc
	var/id_tag = null

	var/on = 0
	var/scrubbing = 1 //0 = siphoning, 1 = scrubbing

	var/panic = 0 //is this scrubber panicked?
	var/welded = 0

	var/area_uid

/obj/structure/machinery/atmospherics/unary/vent_scrubber/on
	on = 1

/obj/structure/machinery/atmospherics/unary/vent_scrubber/New()
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

/obj/structure/machinery/atmospherics/unary/vent_scrubber/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()

	if(welded)
		icon = 'icons/obj/pipes/vent_scrubber.dmi'
		icon_state = "welded"
		return

	var/scrubber_icon = "scrubber"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(!powered())
		scrubber_icon += "off"
	else
		scrubber_icon += "[on ? "[scrubbing ? "on" : "in"]" : "off"]"

	overlays += icon_manager.get_atmos_icon("device", , , scrubber_icon)

/obj/structure/machinery/atmospherics/unary/vent_scrubber/update_underlays()
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

/obj/structure/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/structure/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message(SPAN_NOTICE("[user] starts welding [src] with [WT]."), \
			SPAN_NOTICE("You start welding [src] with [WT]."))
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src || !WT.isOn())
					return
				playsound(get_turf(src), 'sound/items/Welder2.ogg', 25, 1)
				if(!welded)
					user.visible_message(SPAN_NOTICE("[user] welds [src] shut."), \
					SPAN_NOTICE("You weld [src] shut."))
					welded = 1
					msg_admin_niche("[key_name(user)] welded a vent scrubber.")
					update_icon()
				else
					user.visible_message(SPAN_NOTICE("[user] welds [src] open."), \
					SPAN_NOTICE("You weld [src] open."))
					msg_admin_niche("[key_name(user)] un-welded a vent scrubber.")
					welded = 0
					update_icon()
			else
				to_chat(user, SPAN_WARNING("[WT] needs to be on to start this task."))
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return
	if(!iswrench(W))
		return ..()
	if(!(stat & NOPOWER) && on)
		to_chat(user, SPAN_WARNING("You cannot unwrench [src], turn it off first."))
		return 1
	var/turf/T = loc
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

/obj/structure/machinery/atmospherics/unary/vent_scrubber/examine(mob/user)
	..()
	if(get_dist(user, src) <= 1)
		to_chat(user, SPAN_INFO("A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; 0W."))
	else
		to_chat(user, SPAN_INFO("You are too far away to read the gauge."))
	if(welded)
		to_chat(user, SPAN_INFO("It seems welded shut."))

/obj/structure/machinery/atmospherics/unary/vent_scrubber/Dispose()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	. = ..()

/obj/structure/machinery/atmospherics/unary/vent_scrubber/can_crawl_through()
	return !welded
