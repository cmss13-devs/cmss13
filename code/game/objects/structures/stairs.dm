#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2

/obj/structure/stairs
	name = "Stairs"
	icon = 'icons/obj/structures/structures.dmi'
	desc = "Stairs. You walk up and down them."
	icon_state = "rampbottom"
	gender = PLURAL
	unslashable = TRUE
	unacidable = TRUE
	anchored = TRUE
	health = null
	plane = FLOOR_PLANE
	layer = STAIRS_LAYER
	density = FALSE
	opacity = FALSE
	var/force_open_above = FALSE // replaces the turf above this stair obj with /turf/open/openspace
	var/terminator_mode = STAIR_TERMINATOR_NO
	var/turf/listening_to

/obj/structure/stairs/Initialize(mapload)
	if(force_open_above)
		force_open_above()
		build_signal_listener()

	AddElement(/datum/element/connect_loc, list(COMSIG_ATOM_EXITED = TYPE_PROC_REF(/obj/structure/stairs, on_move)))

	. = ..()

/obj/structure/stairs/Destroy()
	listening_to = null
	. = ..()

/obj/structure/stairs/BlockedPassDirs(atom/movable/mover, target_dir)
	if(target_dir == dir)
		return NO_BLOCKED_MOVEMENT

	. = ..()

	if(isTerminator() && mover.z == z && target_dir == REVERSE_DIR(dir))
		return BLOCKED_MOVEMENT

/obj/structure/stairs/proc/on_move(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return

	if(isTerminator() && get_dir(source, direction) == dir)
		leaving.set_currently_z_moving(CURRENTLY_Z_ASCENDING)
		if(!(leaving.flags_atom & DIRLOCK))
			leaving.setDir(dir)
		INVOKE_ASYNC(src, PROC_REF(stair_ascend), leaving, dir)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/stairs/proc/stair_ascend(atom/movable/climber, direction)
	var/turf/our_loc = get_turf(src)
	var/turf/checking = get_step_multiz(our_loc, UP)
	if(!istype(checking) || !checking.zPassIn(climber, UP, our_loc))
		return
	our_loc = checking
	checking = get_step(our_loc, direction)
	if(!checking.zPassIn(climber, UP, our_loc))
		return
	if(!climber.can_z_move(DOWN, checking, z_move_flags = ZMOVE_FALL_FLAGS)) //Don't throw them into a tile that will just dump them back down.
		if(istype(climber, /mob))
			var/mob/mob = climber
			mob.trainteleport(checking, z_move_flags = ZMOVE_STAIRS_FLAGS)
		else
			climber.zMove(target = checking, z_move_flags = ZMOVE_STAIRS_FLAGS)

/obj/structure/stairs/proc/build_signal_listener()
	if(listening_to)
		UnregisterSignal(listening_to, COMSIG_TURF_MULTIZ_NEW)
	var/turf/open/openspace/above = get_step_multiz(get_turf(src), UP)
	RegisterSignal(above, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_new))
	listening_to = above

/obj/structure/stairs/proc/force_open_above()
	var/turf/open/openspace/above = get_step_multiz(get_turf(src), UP)
	if(above && !istype(above))
		above.ChangeTurf(/turf/open/openspace)

/obj/structure/stairs/proc/on_multiz_new(turf/source, dir)
	SIGNAL_HANDLER

	if(dir == UP)
		var/turf/open/openspace/above = get_step_multiz(get_turf(src), UP)
		if(above && !istype(above))
			above.ChangeTurf(/turf/open/openspace)

/obj/structure/stairs/intercept_zImpact(list/falling_movables, levels = 1)
	. = ..()
	if(levels == 1 && isTerminator()) // Stairs won't save you from a steep fall.
		. |= FALL_INTERCEPTED | FALL_NO_MESSAGE | FALL_RETAIN_PULL

/obj/structure/stairs/proc/isTerminator() //If this is the last stair in a chain and should move mobs up
	if(terminator_mode != STAIR_TERMINATOR_AUTOMATIC)
		return (terminator_mode == STAIR_TERMINATOR_YES)
	var/turf/below = get_turf(src)
	if(!below)
		return FALSE
	var/turf/them = get_step(below, dir)
	if(!them)
		return FALSE
	for(var/obj/structure/stairs/S in them)
		if(S.dir == dir)
			return FALSE
	return TRUE

/obj/structure/stairs/perspective //instance these for the required icons
	icon = 'icons/obj/structures/stairs/perspective_stairs.dmi'
	icon_state = "np_stair"
	terminator_mode = STAIR_TERMINATOR_NO

/obj/structure/stairs/perspective/kutjevo
	icon = 'icons/obj/structures/stairs/perspective_stairs_kutjevo.dmi'

/obj/structure/stairs/perspective/ice
	icon = 'icons/obj/structures/stairs/perspective_stairs_ice.dmi'

#undef STAIR_TERMINATOR_AUTOMATIC
#undef STAIR_TERMINATOR_NO
#undef STAIR_TERMINATOR_YES

/obj/structure/stairs/constructed
	icon = 'icons/obj/structures/building_stairs.dmi'
	icon_state = "stairs"
	desc = "Field made stairs. You can climb them up."

	unslashable = FALSE
	unacidable = FALSE
	health = 200
	density = TRUE

	plane = GAME_PLANE
	layer = ABOVE_OBJ_LAYER

/obj/structure/stairs/constructed/attackby(obj/item/tool, mob/living/user)
	if(HAS_TRAIT(tool, TRAIT_TOOL_WRENCH) && !istype(src, /obj/structure/stairs/constructed/resin))
		if(user.action_busy)
			return
		if(do_after(user, 5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(QDELETED(src))
				return
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			new /obj/item/stack/sheet/metal(loc, 25)
			qdel(src)
		return
	. = ..()

/obj/structure/stairs/constructed/attack_hand(mob/living/user)
	try_to_ascend_mob(user)

/obj/structure/stairs/constructed/attack_alien(mob/living/carbon/xenomorph/user)
	if(user.a_intent == INTENT_HARM)
		if(user.action_busy)
			return
		if(do_after(user, 5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(QDELETED(src))
				return
			if(!istype(src, /obj/structure/stairs/constructed/resin))
				playsound(loc, 'sound/items/Welder.ogg', 25, 1)
				new /obj/item/stack/sheet/metal(loc, 10)
			qdel(src)
	else
		try_to_ascend_mob(user)

/obj/structure/stairs/constructed/proc/try_to_ascend_mob(mob/living/carbon/user)
	if(user.is_mob_incapacitated())
		return

	to_chat(user, SPAN_NOTICE("You start climbing [src]."))
	if(do_after(user, 5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		if(QDELETED(src))
			return
		var/turf/prev = user.loc
		user.set_currently_z_moving(CURRENTLY_Z_ASCENDING)
		stair_ascend(user, get_dir(user, src))

		if(prev != user.loc)
			to_chat(user, SPAN_NOTICE("You climbed [src]."))
		else
			to_chat(user, SPAN_NOTICE("You failed climbing [src]."))
		return
	to_chat(user, SPAN_NOTICE("You stopped climbing [src]."))

/obj/structure/stairs/constructed/intercept_zImpact(list/falling_movables, levels = 1)
	. = ..()
	if(levels == 1)
		. |= FALL_INTERCEPTED | FALL_NO_MESSAGE | FALL_RETAIN_PULL

/obj/structure/stairs/constructed/resin
	icon_state = "resin_stairs"
	desc = "Thick resin stairs, can help to clim buildings."

	unacidable = TRUE

/obj/structure/stairs/constructed/resin/attackby(obj/item/W, mob/living/user)
	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force*RESIN_MELEE_DAMAGE_MULTIPLIER*W.demolition_mod, user)
		playsound(src, "alien_resin_break", 25)
	else
		return attack_hand(user)

/obj/structure/stairs/constructed/resin/bullet_act(obj/projectile/P)
	. = ..()
	take_damage(P.damage)

/obj/structure/stairs/constructed/resin/proc/take_damage(damage)
	health -= damage
	if(health <= 0)
		qdel(src)
	else
		update_icon()
