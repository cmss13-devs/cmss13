#define VENT_SOUND_DELAY 20

/obj/structure/pipes
	anchored = TRUE
	layer = ATMOS_DEVICE_LAYER

	var/list/connected_to = list()
	var/list/valid_directions = list(NORTH, SOUTH, EAST, WEST)

	var/pipe_color
	var/image/pipe_vision_img = null
	var/global/datum/pipe_icon_manager/icon_manager

	var/ventcrawl_message_busy = 0 //Prevent spamming

/obj/structure/pipes/Initialize()
	. = ..()
	if(!icon_manager)
		icon_manager = new()

	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	if(pipe_vision_img)
		qdel(pipe_vision_img)
		pipe_vision_img = null

	create_valid_directions()
	
	search_for_connections()

/obj/structure/pipes/Dispose()
	for(var/mob/living/M in src)
		M.remove_ventcrawl()
		M.forceMove(loc)

	for(var/obj/structure/pipes/P in connected_to)
		P.remove_connection(src)
	. = ..()

/obj/structure/pipes/attackby(var/obj/item/W, var/mob/user)
	if(!iswrench(W))
		return ..()

	var/turf/T = src.loc
	if(level == 1 && isturf(T) && T.intact_tile)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins unfastening [src]."), SPAN_NOTICE("You begin unfastening [src]."))
	if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
	SPAN_NOTICE("You unfasten [src]."))
	new /obj/item/pipe(loc, make_from = src)
	qdel(src)

/obj/structure/pipes/proc/create_valid_directions()
	return

/obj/structure/pipes/proc/search_for_connections(var/recursion_check = 0)
	if(recursion_check > 4) // We allow it to go 5 times.
		return

	for(var/direction in valid_directions)
		var/turf/T = get_step(src, direction)
		for(var/obj/structure/pipes/P in T)
			if(REVERSE_DIR(direction) in P.valid_directions)
				P.add_connection(src)
				add_connection(P)
				break

	if(!length(connected_to))
		add_timer(CALLBACK(src, .proc/search_for_connections, recursion_check + 1), 1)
	else
		add_timer(CALLBACK(src, .proc/update_icon), 5)

/obj/structure/pipes/proc/add_connection(var/obj/structure/pipes/P)
	addToListNoDupe(connected_to, P)

/obj/structure/pipes/proc/remove_connection(var/obj/structure/pipes/P)
	connected_to -= P

/obj/structure/pipes/proc/get_connection(var/direction)
	var/obj/structure/pipes/best_connected_pipe = null
	for(var/obj/structure/pipes/target in get_step(src, direction))
		if(!(target in connected_to))
			continue

		if(!QDELETED(target) && (isnull(best_connected_pipe) || length(target.connected_to) > length(best_connected_pipe.connected_to)))
			best_connected_pipe = target
	return best_connected_pipe

/obj/structure/pipes/relaymove(mob/living/user, direction)
	if(!(direction in valid_directions)) //can't go in a way we aren't connecting to
		return FALSE

	var/obj/structure/pipes/next_pipe = get_connection(direction)
	if(!next_pipe)
		if(istype(src, /obj/structure/pipes/vents))
			var/obj/structure/pipes/vents/V = src
			if(V.welded)
				to_chat(user, SPAN_WARNING("This vent is closed off, you cannot climb through it."))
				return
			var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in V.loc
			if(W)
				var/mob/living/carbon/Xenomorph/X = user
				if(!istype(X) || X.hivenumber != W.linked_hive.hivenumber)
					to_chat(user, SPAN_WARNING("The weeds are blocking the exit of this vent"))
					return

		if(ventcrawl_message_busy > world.time)
			return

		ventcrawl_message_busy = world.time + 20
		visible_message(SPAN_WARNING("You hear something squeezing through the ducts."))
		to_chat(user, SPAN_NOTICE("You begin to climb out of [src]"))
		if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND))
			return

		user.remove_ventcrawl()
		user.forceMove(src.loc)
		user.visible_message(SPAN_WARNING("[user] climbs out of [src]."), SPAN_NOTICE("You climb out of [src]."))
		playsound(user, pick('sound/effects/alien_ventpass1.ogg', 'sound/effects/alien_ventpass2.ogg'), 35, 1)
		return
	
	user.loc = next_pipe
	user.client.eye = next_pipe //if we don't do this, Byond only updates the eye every tick - required for smooth movement
	user.update_pipe_icons(next_pipe)
	
	if(world.time - user.last_played_vent > VENT_SOUND_DELAY)
		user.last_played_vent = world.time
		playsound(src, pick('sound/effects/alien_ventcrawl1.ogg', 'sound/effects/alien_ventcrawl2.ogg'), 25, 1)


/obj/structure/pipes/proc/add_underlay(var/turf/T, var/direction)
	if(T && T.intact_tile && level == 1)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "down")
	else
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "intact")

/obj/structure/pipes/proc/update_underlays()
	if(check_icon_cache())
		return TRUE
	else
		return FALSE

/obj/structure/pipes/proc/check_icon_cache(var/safety = FALSE)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(TRUE)
		return FALSE
	return TRUE

/obj/structure/pipes/proc/color_cache_name(var/obj/structure/pipes/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color


#undef VENT_SOUND_DELAY