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

/turf/open_space/Initialize()
	ADD_TRAIT(src, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_INHERENT)
	return INITIALIZE_HINT_LATELOAD

/turf/open_space/attack_alien(mob/user)
	attack_hand(user)

/turf/open_space/Entered(atom/movable/entered_movable, atom/old_loc)
	. = ..()

	check_fall(entered_movable)

/turf/open_space/on_throw_end(atom/movable/thrown_atom)
	check_fall(thrown_atom)

/turf/open_space/proc/climb_down(mob/user)
	if(user.action_busy)
		return

	var/turf/current_turf = get_turf(src)

	if(!istype(current_turf, /turf/open_space))
		return

	var/climb_down_time = 1 SECONDS

	if(ishuman_strict(user))
		climb_down_time = 2.5 SECONDS

	if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno_victim = user
		if(xeno_victim.mob_size >= MOB_SIZE_BIG)
			climb_down_time = 3 SECONDS
		else
			climb_down_time = 1.5 SECONDS

	user.visible_message(SPAN_WARNING("[user] starts climbing down."), SPAN_WARNING("You start climbing down."))

	if(!do_after(user, climb_down_time, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	user.visible_message(SPAN_WARNING("[user] climbs down."), SPAN_WARNING("You climb down."))

	var/turf/below = SSmapping.get_turf_below(current_turf)
	while(istype(below, /turf/open_space))
		below = SSmapping.get_turf_below(below)

	user.forceMove(below)
	return

/turf/open_space/proc/check_fall(atom/movable/movable)
	if(movable.flags_atom & NO_ZFALL)
		return

	var/height = 1
	var/turf/below = SSmapping.get_turf_below(get_turf(src))

	while(istype(below, /turf/open_space))
		below = SSmapping.get_turf_below(below)
		height++

	movable.forceMove(below)
	movable.onZImpact(below, height)

/turf/open_space/attack_hand(mob/user)
	if(user.action_busy)
		return
	var/turf/current_turf = get_turf(src)

	if(istype(current_turf, /turf/open_space))
		user.visible_message(SPAN_WARNING("[user] starts climbing down."), SPAN_WARNING("You start climbing down."))

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interrupted!"))
			return

		user.visible_message(SPAN_WARNING("[user] climbs down."), SPAN_WARNING("You climb down."))

		var/turf/below = SSmapping.get_turf_below(current_turf)
		while(istype(below, /turf/open_space))
			below = SSmapping.get_turf_below(below)

		user.forceMove(below)
		return

/turf/open_space/is_weedable()
	return NOT_WEEDABLE
