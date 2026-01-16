GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name = "openspace_backdrop"
	anchored = TRUE
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "grey"
	plane = OPENSPACE_BACKDROP_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/turf/open_space
	name = "open space"
	icon_state = "transparent"
	baseturfs = /turf/open_space
	plane = OPEN_SPACE_PLANE_START
	is_weedable = NOT_WEEDABLE

/turf/open_space/proc/get_projected_turf()
	return SSmapping.get_turf_below(get_turf(src))

/turf/open_space/Initialize()
	pass_flags = GLOB.pass_flags_cache[type]

	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	ADD_TRAIT(src, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_INHERENT)
	return INITIALIZE_HINT_LATELOAD

/turf/open_space/attack_alien(mob/user)
	attack_hand(user)

/turf/open_space/attack_hand(mob/user)
	climb_down(user)

/turf/open_space/Entered(atom/movable/entered_movable, atom/old_loc)
	. = ..()

	check_fall(entered_movable)

/turf/open_space/additional_enter_checks(atom/movable/mover)
	var/turf/projected_turf = get_projected_turf()
	if(projected_turf.density)
		return FALSE

	for(var/atom/possible_blocker in projected_turf.contents)
		if(possible_blocker.density && !ismob(possible_blocker))
			return FALSE

	return TRUE

/turf/open_space/on_throw_end(atom/movable/thrown_atom)
	check_fall(thrown_atom)

/turf/open_space/proc/climb_down(mob/user)
	if(user.action_busy)
		return

	var/climb_down_time = 1 SECONDS

	if(ishuman_strict(user))
		climb_down_time = 2.5 SECONDS

	if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno_victim = user
		if(xeno_victim.mob_size >= MOB_SIZE_BIG)
			climb_down_time = 3 SECONDS
		else
			climb_down_time = 1 SECONDS

	if(user.action_busy)
		return

	user.visible_message(SPAN_WARNING("[user] starts climbing down."), SPAN_WARNING("You start climbing down."))

	if(!do_after(user, climb_down_time, INTERRUPT_ALL, BUSY_ICON_CLIMBING))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	user.visible_message(SPAN_WARNING("[user] climbs down."), SPAN_WARNING("You climb down."))

	var/turf/below = get_projected_turf()
	while(istype(below, /turf/open_space))
		below = SSmapping.get_turf_below(below)

	user.forceMove(below)
	return

/turf/open_space/proc/check_fall(atom/movable/movable)
	if(movable.flags_atom & NO_ZFALL)
		return

	var/height = 1
	var/turf/below = get_projected_turf()

	while(istype(below, /turf/open_space))
		below = SSmapping.get_turf_below(below)
		height++

	movable.forceMove(below)
	movable.onZImpact(below, height)


/turf/solid_open_space
	name = "open space"
	icon_state = "transparent_solid"
	baseturfs = /turf/solid_open_space
	plane = OPEN_SPACE_PLANE_START
	is_weedable = NOT_WEEDABLE
	density = TRUE

/turf/open_space/blackfoot
	var/target_x = 1
	var/target_y = 1
	var/target_z = 1
	var/backdrop = FALSE
	var/should_fall = FALSE

/turf/open_space/blackfoot/attack_hand(mob/user)
	return

/turf/open_space/blackfoot/get_projected_turf()
	RETURN_TYPE(/turf)
	return locate(target_x, target_y, target_z)

/turf/open_space/blackfoot/update_vis_contents()
	vis_contents.Cut()
	for(var/obj/vis_contents_holder/holder in src)
		qdel(holder)

	var/turf/below = get_projected_turf()
	var/depth = 0
	while(below)
		new /obj/vis_contents_holder(src, below, depth, backdrop)
		if(!istransparentturf(below))
			break
		below = SSmapping.get_turf_below(below)
		depth++

/turf/open_space/blackfoot/check_fall(atom/movable/movable)
	if(movable.flags_atom & NO_ZFALL)
		return

	var/height = should_fall ? 1 : 0
	var/turf/below = get_projected_turf()

	while(istype(below, /turf/open_space))
		below = SSmapping.get_turf_below(below)
		height++

	movable.forceMove(below)

	if(height > 0)
		movable.onZImpact(below, height)

/turf/solid_open_space/Initialize()
	ADD_TRAIT(src, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_INHERENT)
	icon_state = "transparent"
	return INITIALIZE_HINT_LATELOAD
