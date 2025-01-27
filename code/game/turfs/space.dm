/turf/open/space
	icon = 'icons/turf/floors/space.dmi'
	name = "space"
	icon_state = "0"
	turf_flags = TURF_NO_MULTIZ_SUPPORT
	plane = PLANE_SPACE
	layer = UNDER_TURF_LAYER
	can_bloody = FALSE
	supports_surgery = FALSE

/turf/open/space/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(FALSE)

	vis_contents.Cut() //removes inherited overlays

	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	GLOB.turfs += src

	if(opacity)
		directional_opacity = ALL_CARDINALS

	pass_flags = GLOB.pass_flags_cache[type]
	if(isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	return INITIALIZE_HINT_LATELOAD

/turf/open/space/LateInitialize()
	SHOULD_CALL_PARENT(FALSE)
	if(!istype(src, /turf/open/space/transit) && !istype(src, /turf/open/space/openspace))
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

	multiz_turfs()

/turf/open/space/multiz_turfs()
	var/turf/turf = SSmapping.get_turf_above(src)
	if(turf)
		turf.multiz_turf_new(src, DOWN)
	turf = SSmapping.get_turf_below(src)
	if(turf)
		turf.multiz_turf_new(src, UP)

/turf/open/space/zPassIn(atom/movable/mover, direction, turf/source)
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

/turf/open/space/zPassOut(atom/movable/mover, direction, turf/destination, allow_anchored_movement)
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

/turf/open/space/basic/New() //Do not convert to Initialize
	//This is used to optimize the map loader
	return

// override for space turfs, since they should never hide anything
/turf/open/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(FALSE)

/turf/open/space/attack_hand(mob/user)
	if((user.is_mob_restrained() || !( user.pulling )))
		return
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/open/space/attackby(obj/item/C, mob/user)

	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if(R.use(1))
			to_chat(user, SPAN_NOTICE(" Constructing support lattice ..."))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			ReplaceWithLattice()
		return

	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_DANGER("The plating is going to need some support."))
	return


// Ported from unstable r355

/turf/open/space/Entered(atom/movable/arrived, old_loc)
	..()
	if((!(arrived) || src != arrived.loc) || arrived.z == 1 || !length(SSmapping.levels_by_trait(ZTRAIT_GROUND)))
		return

	inertial_drift(arrived)

	if(SSticker.mode)
		if(arrived.x <= TRANSITIONEDGE || arrived.x >= (world.maxx - TRANSITIONEDGE - 1) || arrived.y <= TRANSITIONEDGE || arrived.y >= (world.maxy - TRANSITIONEDGE - 1))
			var/move_to_z = src.z
			var/safety = 1

			while(move_to_z == src.z)
				move_to_z = pick(SSmapping.levels_by_trait(ZTRAIT_GROUND))
				safety++
				if(safety > 10)
					break

			if(!move_to_z)
				return

			arrived.z = move_to_z

			if(src.x <= TRANSITIONEDGE)
				arrived.x = world.maxx - TRANSITIONEDGE - 2
				arrived.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if(arrived.x >= (world.maxx - TRANSITIONEDGE - 1))
				arrived.x = TRANSITIONEDGE + 1
				arrived.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if(src.y <= TRANSITIONEDGE)
				arrived.y = world.maxy - TRANSITIONEDGE -2
				arrived.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			else if(arrived.y >= (world.maxy - TRANSITIONEDGE - 1))
				arrived.y = TRANSITIONEDGE + 1
				arrived.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			spawn (0)
				if((arrived && arrived.loc))
					arrived.loc.Entered(arrived)

// Black & invisible to the mouse. used by vehicle interiors
/turf/open/void
	name = "void"
	icon = 'icons/turf/floors/space.dmi'
	icon_state = "black"
	turf_flags = NO_FLAGS
	mouse_opacity = FALSE

/turf/open/void/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(FALSE)

	vis_contents.Cut() //removes inherited overlays

	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	GLOB.turfs += src

	if(opacity)
		directional_opacity = ALL_CARDINALS

	pass_flags = GLOB.pass_flags_cache[type]
	if(isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	multiz_turfs()
	return INITIALIZE_HINT_NORMAL

/turf/open/void/LateInitialize()
	SHOULD_CALL_PARENT(FALSE)

/turf/open/void/multiz_turfs()
	var/turf/turf = SSmapping.get_turf_above(src)
	if(turf)
		turf.multiz_turf_new(src, DOWN)
	turf = SSmapping.get_turf_below(src)
	if(turf)
		turf.multiz_turf_new(src, UP)

/turf/open/void/densy
	density = TRUE
	opacity = TRUE
