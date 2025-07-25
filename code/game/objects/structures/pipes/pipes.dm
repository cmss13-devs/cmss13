#define VENT_SOUND_DELAY 20

/obj/structure/pipes
	anchored = TRUE
	layer = ATMOS_DEVICE_LAYER
	plane = FLOOR_PLANE

	var/list/connected_to = list()
	var/list/valid_directions = list(NORTH, SOUTH, EAST, WEST)

	var/pipe_color
	var/image/pipe_vision_img = null
	var/global/datum/pipe_icon_manager/icon_manager

	var/ventcrawl_message_busy = FALSE //Prevent spamming

	/// Whether or not the pipe will explode (when on the Almayer) during hijack
	var/explodey = TRUE
	/// The grenade subtypes that pipes will use when they explode
	var/static/list/exploding_types = list(/obj/item/explosive/grenade/high_explosive/bursting_pipe, /obj/item/explosive/grenade/incendiary/bursting_pipe)

/obj/structure/pipes/Initialize(mapload, ...)
	. = ..()

	if(!icon_manager)
		icon_manager = new()

	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	QDEL_NULL(pipe_vision_img)

	if(mapload)
		create_valid_directions()
		search_for_connections()

	if(!is_mainship_level(z))
		return

	if(explodey)
		GLOB.mainship_pipes += src

/obj/structure/pipes/Destroy()
	for(var/mob/living/M in src)
		M.remove_ventcrawl()
		M.forceMove(loc)

	for(var/obj/structure/pipes/P in connected_to)
		P.remove_connection(src)
	connected_to.Cut()

	GLOB.mainship_pipes -= src

	. = ..()

/obj/structure/pipes/attackby(obj/item/W, mob/user)
	if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
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
	new /obj/item/pipe(loc, null, null, src)
	qdel(src)

/obj/structure/pipes/proc/create_valid_directions()
	return

/obj/structure/pipes/proc/search_for_connections()
	for(var/direction in valid_directions)
		var/turf/T = get_step(src, direction)
		for(var/obj/structure/pipes/P in T)
			if(REVERSE_DIR(direction) in P.valid_directions)
				P.add_connection(src)
				add_connection(P)
				break

	update_icon()

/obj/structure/pipes/proc/add_connection(obj/structure/pipes/P)
	addToListNoDupe(connected_to, P)

/obj/structure/pipes/proc/remove_connection(obj/structure/pipes/P)
	connected_to -= P
	P.connected_to -= src

/obj/structure/pipes/proc/get_connection(direction)
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
				var/mob/living/carbon/xenomorph/X = user
				if(!istype(X) || X.hivenumber != W.linked_hive.hivenumber)
					to_chat(user, SPAN_WARNING("The weeds are blocking the exit of this vent"))
					return

		if(ventcrawl_message_busy > world.time)
			return

		ventcrawl_message_busy = world.time + 20
		playsound(src, pick('sound/effects/alien_ventcrawl1.ogg', 'sound/effects/alien_ventcrawl2.ogg'), 25, 1)
		var/turf/alert_turf = get_turf(src) //Pipe segments aren't guaranteed to be visible
		alert_turf.visible_message(SPAN_HIGHDANGER("You hear something squeezing through the ducts."))
		to_chat(user, SPAN_NOTICE("You begin to climb out of [src]"))
		animate_ventcrawl()
		user.remove_specific_pipe_image(src)
		if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND))
			animate_ventcrawl_reset()
			return

		animate_ventcrawl_reset()
		user.remove_ventcrawl()
		user.forceMove(src.loc)
		user.visible_message(SPAN_HIGHDANGER("[user] climbs out of [src]."), SPAN_NOTICE("You climb out of [src]."))
		playsound(user, pick('sound/effects/alien_ventpass1.ogg', 'sound/effects/alien_ventpass2.ogg'), 35, 1)

		return

	user.forceMove(next_pipe)
	user.client.eye = next_pipe //if we don't do this, Byond only updates the eye every tick - required for smooth movement
	user.update_pipe_icons(next_pipe)

	if(world.time - user.last_played_vent > VENT_SOUND_DELAY)
		user.last_played_vent = world.time
		playsound(src, pick('sound/effects/alien_ventcrawl1.ogg', 'sound/effects/alien_ventcrawl2.ogg'), 25, 1)


/obj/structure/pipes/proc/animate_ventcrawl(speed = 3, loop_amount = -1, sections = 4)
	animate(src, pixel_x = rand(-2,2), pixel_y = rand(-2,2), time = speed, loop = loop_amount, easing = JUMP_EASING)
	for(var/i in 1 to sections)
		animate(pixel_x = rand(-2,2), pixel_y = rand(-2,2), time = speed, easing = JUMP_EASING)

/obj/structure/pipes/proc/animate_ventcrawl_reset()
	animate(src, pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), easing = JUMP_EASING)

/obj/structure/pipes/proc/add_underlay(turf/T, direction)
	if(T && T.intact_tile && level == 1)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "down")
	else
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "intact")

/obj/structure/pipes/proc/update_underlays()
	if(check_icon_cache())
		return TRUE
	else
		return FALSE

/obj/structure/pipes/proc/check_icon_cache(safety = FALSE)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(TRUE)
		return FALSE
	return TRUE

/obj/structure/pipes/proc/color_cache_name(obj/structure/pipes/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/**
 * Makes a warning telegraph appear and, after a certain duration, explodes.
 *
 * Params:
 * time_till: required, the time until the explosion occurs. The sound file lasts 5 seconds.
 */
/obj/structure/pipes/proc/warning_explode(time_till)
	if(!time_till)
		CRASH("No time given to /warning_explode.")
	var/turf/position = get_turf(src)
	if(protected_by_pylon(TURF_PROTECTION_MORTAR, position))
		return

	new /obj/effect/warning/explosive(position, time_till)
	playsound(src, 'sound/effects/pipe_hissing.ogg', vol = 40)
	addtimer(CALLBACK(src, PROC_REF(kablooie)), time_till)
	visible_message(SPAN_HIGHDANGER("[src] begins hissing violently!"))

/**
 * Makes the pipe go boom.
 */
/obj/structure/pipes/proc/kablooie()
	var/new_cause_data = create_cause_data("bursting pipe")
	for(var/path in exploding_types)
		var/obj/item/explosive/grenade/exploder = new path(get_turf(src))
		exploder.cause_data = new_cause_data
		exploder.prime()
	qdel(src)

#undef VENT_SOUND_DELAY
