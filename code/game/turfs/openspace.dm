GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)
GLOBAL_DATUM_INIT(openspace_shadow_one_for_all, /atom/movable/openspace_backdrop/shadow, new)

/atom/movable/openspace_backdrop
	icon = 'icons/turf/open_space.dmi'
	icon_state = "grey"
	name = "openspace_backdrop"
	anchored = TRUE
	plane = OPENSPACE_BACKDROP_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = NO_FLAGS

/atom/movable/openspace_backdrop/shadow
	name = "openspace_shadow"
	plane = OPENSPACE_SHADOW_PLANE

/turf/open/space/openspace
	icon = 'icons/turf/open_space.dmi'
	icon_state = "invisible"
	turf_flags = TURF_TRANSPARENT
	baseturfs = /turf/open/openspace
	antipierce = 0

/turf/open/space/openspace/update_icon()
	return

/turf/open/space/openspace/Initialize(mapload) // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	icon_state = "invisible"
	return INITIALIZE_HINT_LATELOAD

/turf/open/space/openspace/LateInitialize()
	. = ..()
	vis_contents += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.
	handle_transpare_turf()

/turf/open/space/openspace/ex_act(severity, explosion_direction)
	return


/turf/open/openspace
	icon = 'icons/turf/open_space.dmi'
	name = "open space"
	desc = "Watch your step!"
	icon_state = "invisible"
	baseturfs = /turf/open/openspace
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	turf_flags = TURF_TRANSPARENT
	antipierce = 0

/turf/open/openspace/update_icon()
	return

/turf/open/openspace/is_weedable()
	return NOT_WEEDABLE

/turf/open/openspace/Initialize(mapload) // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
//TODO (MULTIZ): IMPROVE IT, REMOVE THAT AND DO IT OTHER WAY, LIKE PROC [ON_OPENSPACE_UNDERNEATH] THAT WE CALL TO ALL SHIT ON THIS TURF WHEN IT"S CREATED
/*
	pass_flags = GLOB.pass_flags_cache[type]// fix for passflags
	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()
	for(var/obj/structure/locked_stuff in contents)
		if(!locked_stuff.anchored)
			continue

		if(istype(locked_stuff, /obj/structure/pipes))
			new /obj/item/pipe(src, null, null, locked_stuff)
			qdel(locked_stuff)
			continue

		if(istype(locked_stuff, /obj/structure/disposalpipe))
			locked_stuff.deconstruct(FALSE)
			continue

		if(locked_stuff.wrenchable)
			locked_stuff.anchored = FALSE
			locked_stuff.ex_act(50, DOWN)
		else
			locked_stuff.ex_act(200, DOWN)
*/

	. = ..()

	return INITIALIZE_HINT_LATELOAD

/turf/open/openspace/LateInitialize()
	SHOULD_CALL_PARENT(FALSE)
	multiz_turfs()
	vis_contents += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.
	handle_transpare_turf()

/turf/open/openspace/attackby(obj/item/using_obj, mob/user)
	if(istype(using_obj, /obj/item/stack/sheet/metal))
		var/obj/structure/lattice/support_structure = locate(/obj/structure/lattice) in src
		if(!support_structure)
			to_chat(user, SPAN_DANGER("The plating is going to need some support."))
			return

		if(ishuman(user) && !skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
			to_chat(user, SPAN_DANGER("You are not trained to build turfs from scratch..."))
			return

		var/obj/item/stack/sheet/metal/metal_sheet = using_obj
		if(metal_sheet.get_amount() < 5)
			return
		qdel(support_structure)
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		ChangeTurf(/turf/open/floor/plating)
		metal_sheet.use(5)
		return
	return

/turf/open/openspace/multiz_turfs()
	var/turf/turf = SSmapping.get_turf_above(src)
	if(turf)
		turf.multiz_turf_new(src, DOWN)
	turf = SSmapping.get_turf_below(src)
	if(turf)
		turf.multiz_turf_new(src, UP)

/**
 * Prepares a moving movable to be precipitated if Move() is successful.
 * This is done in Enter() and not Entered() because there's no easy way to tell
 * if the latter was called by Move() or forceMove() while the former is only called by Move().
 */
/turf/open/openspace/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(.)
		//higher priority than CURRENTLY_Z_FALLING so the movable doesn't fall on Entered()
		if(!istype(movable, /obj/vehicle/multitile) && movable.set_currently_z_moving(CURRENTLY_Z_FALLING_FROM_MOVE))
			zFall(movable, falling_from_move = TRUE)
		return .

///Makes movables fall when forceMove()'d to this turf.
/turf/open/openspace/Entered(atom/movable/movable)
	. = ..()
	if(.)
		if(!istype(movable, /obj/vehicle/multitile) && movable.set_currently_z_moving(CURRENTLY_Z_FALLING))
			zFall(movable, falling_from_move = TRUE)
		return .
/**
 * Drops movables spawned on this turf only after they are successfully initialized.
 * so flying mobs, qdeleted movables and things that were moved somewhere else during
 * Initialize() won't fall by accident.
 */
/turf/open/openspace/on_atom_created(atom/created_atom)
	if(ismovable(created_atom))
		//Drop it only when it's finished initializing, not before.
		addtimer(CALLBACK(src, PROC_REF(zfall_if_on_turf), created_atom), 0 SECONDS)

/turf/open/openspace/proc/zfall_if_on_turf(atom/movable/movable)
	if(QDELETED(movable) || movable.loc != src)
		return
	zFall(movable)

/turf/open/openspace/zPassIn(atom/movable/mover, direction, turf/source)
	switch(direction)
		if(DOWN)
			for(var/obj/contained_object in contents)
				if(contained_object.flags_obj & OBJ_BLOCK_Z_IN_DOWN)
					return FALSE
			return TRUE
		if(UP)
			for(var/obj/contained_object in contents)
				if(contained_object.flags_obj & OBJ_BLOCK_Z_IN_UP)
					return FALSE
			return TRUE
	return FALSE

/turf/open/openspace/zPassOut(atom/movable/mover, direction, turf/destination, allow_anchored_movement)
	if(mover.anchored && !allow_anchored_movement)
		return FALSE
	switch(direction)
		if(DOWN)
			for(var/obj/contained_object in contents)
				if(contained_object.flags_obj & OBJ_BLOCK_Z_OUT_DOWN)
					return FALSE
			return TRUE
		if(UP)
			for(var/obj/contained_object in contents)
				if(contained_object.flags_obj & OBJ_BLOCK_Z_OUT_UP)
					return FALSE
			return TRUE
	return FALSE
