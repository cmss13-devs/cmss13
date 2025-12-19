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

/turf/open_space/on_throw_end(atom/movable/thrown_atom)
	check_fall(thrown_atom)

/turf/open_space/update_vis_contents()
	if(!istransparentturf(src))
		return

	vis_contents.Cut()
	for(var/obj/vis_contents_holder/holder in src)
		qdel(holder)

	var/turf/below = get_turf_below()
	var/depth = 0
	while(below)
		new /obj/vis_contents_holder(src, below, depth)
		if(!istransparentturf(below))
			break
		below = SSmapping.get_turf_below(below)
		depth++

/turf/open_space/proc/get_turf_below()
	return SSmapping.get_turf_below(src)

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

	var/turf/below = get_turf_below()
	while(istype(below, /turf/open_space))
		below = SSmapping.get_turf_below(below)

	user.forceMove(below)
	return

/turf/open_space/proc/check_fall(atom/movable/movable)
	if(movable.flags_atom & NO_ZFALL)
		return

	var/height = 1
	var/turf/below = get_turf_below()
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

/turf/solid_open_space/Initialize()
	ADD_TRAIT(src, TURF_Z_TRANSPARENT_TRAIT, TRAIT_SOURCE_INHERENT)
	icon_state = "transparent"
	return INITIALIZE_HINT_LATELOAD


/// A variant of open_space intended for say the shipmap to fake the below turf as the groundmap
/turf/open_space/ground_level
	/// A offset in x to adjust what it deemed the below turf (adjusting this after Initialize requires update_vis_contents)
	var/offset_x = 0
	/// A offset in y to adjust what it deemed the below turf (adjusting this after Initialize requires update_vis_contents)
	var/offset_y = 0
	/// A specific z to adjust what it deemed the below turf (updated automatically in update_vis_contents)
	var/target_z = 0
	/// A cache of open_space z to ground z representative of the height
	var/static/alist/z_mapping = alist()

/turf/open_space/ground_level/Initialize(mapload, list/arguments)
	if(length(arguments) >= 2)
		offset_x = arguments[1]
		offset_y = arguments[2]
	return ..()

/turf/open_space/ground_level/get_turf_below()
	return locate(x + offset_x, y + offset_y, target_z)

/turf/open_space/ground_level/update_vis_contents()
	target_z = z_mapping[z]
	if(target_z)
		return ..()

	// target_z hasn't been determined yet for this z
	var/list/ground_zs = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(z in ground_zs)
		CRASH("[src] at [x],[y],[z] is already on the ground level so should be handled using /turf/open_space instead!")

	// Figure out how high up we are already
	// Assumption: Going ZTRAIT_DOWN keeps you within this ZTRAIT
	var/height = 0
	var/current_z = z
	var/offset = SSmapping.level_trait(current_z, ZTRAIT_DOWN)
	while(offset)
		height++
		current_z += offset
		offset = SSmapping.level_trait(current_z, ZTRAIT_DOWN)

	// Figure out lowest ground z
	// Assumption: Going ZTRAIT_DOWN keeps you within ZTRAIT_GROUND
	current_z = ground_zs[1]
	offset = SSmapping.level_trait(current_z, ZTRAIT_DOWN)
	while(offset)
		current_z += offset
		offset = SSmapping.level_trait(current_z, ZTRAIT_DOWN)

	// Now figure out target z
	offset = SSmapping.level_trait(current_z, ZTRAIT_UP)
	while(height > 0 && offset)
		height--
		current_z += offset
		offset = SSmapping.level_trait(current_z, ZTRAIT_UP)

	target_z = current_z
	z_mapping[z] = current_z
	return ..()
