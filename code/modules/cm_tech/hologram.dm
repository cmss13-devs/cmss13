GLOBAL_LIST_EMPTY_TYPED(hologram_list, /mob/hologram)

/mob/hologram
	name = "Hologram"
	desc = "It seems to be a visual projection of someone." //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "hologram"
	blinded = FALSE

	invisibility = INVISIBILITY_OBSERVER
	sight = SEE_SELF
	layer = ABOVE_FLY_LAYER

	var/action_icon_state = "hologram_exit"

	var/mob/linked_mob
	var/initial_leave_button = /datum/action/leave_hologram
	var/datum/action/leave_hologram/leave_button
	///If can be detected on motion detectors.
	var/motion_sensed = FALSE
	///If this hologram can hear speech.
	var/hears_speech = FALSE

/mob/hologram/movement_delay()
	. = -2 // Very fast speed, so they can navigate through easily, they can't ever have movement delay whilst as a hologram

/mob/hologram/Initialize(mapload, mob/hologram)
	if(!hologram)
		return INITIALIZE_HINT_QDEL

	. = ..()

	GLOB.hologram_list += src
	RegisterSignal(hologram, COMSIG_CLIENT_MOB_MOVE, PROC_REF(handle_move))
	RegisterSignal(hologram, COMSIG_MOB_RESET_VIEW, PROC_REF(handle_view))
	RegisterSignal(hologram, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(take_damage))
	RegisterSignal(hologram, list(
		COMSIG_BINOCULAR_ATTACK_SELF,
		COMSIG_BINOCULAR_HANDLE_CLICK
	), PROC_REF(handle_binoc))

	linked_mob = hologram
	linked_mob.reset_view()

	name = "[initial(name)] ([hologram.name])"

	leave_button = new initial_leave_button(null, action_icon_state)
	leave_button.linked_hologram = src
	leave_button.give_to(hologram)

/mob/hologram/proc/handle_binoc()
	SIGNAL_HANDLER
	return TRUE

/mob/hologram/proc/take_damage(mob/M, damage, damagetype)
	SIGNAL_HANDLER

	if(damage["damage"] > 5)
		qdel(src)

/mob/hologram/proc/handle_move(mob/M, NewLoc, direct)
	SIGNAL_HANDLER

	Move(get_step(loc, direct), direct)
	return COMPONENT_OVERRIDE_MOVE

/mob/hologram/proc/handle_view(mob/M, atom/target)
	SIGNAL_HANDLER

	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.set_eye(src)

	return COMPONENT_OVERRIDE_VIEW


/mob/hologram/BlockedPassDirs(atom/movable/mover, target_dir)
	return NO_BLOCKED_MOVEMENT

/mob/hologram/Destroy()
	if(linked_mob)
		UnregisterSignal(linked_mob, COMSIG_MOB_RESET_VIEW)
		linked_mob.reset_view()
		linked_mob = null

	if(!QDESTROYING(leave_button))
		QDEL_NULL(leave_button)
	else
		leave_button = null

	GLOB.hologram_list -= src

	return ..()

/datum/action/leave_hologram
	name = "Leave"
	action_icon_state = "hologram_exit"

	var/mob/hologram/linked_hologram

/datum/action/leave_hologram/action_activate()
	. = ..()
	qdel(src)

/datum/action/leave_hologram/Destroy()
	if(!QDESTROYING(linked_hologram))
		QDEL_NULL(linked_hologram)
	return ..()

/mob/hologram/techtree/Initialize(mapload, mob/M)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_ENTER_TREE, PROC_REF(disallow_tree_entering))


/mob/hologram/techtree/proc/disallow_tree_entering(mob/M, datum/techtree/T, force)
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_TREE_ENTRY

/mob/hologram/look_up
	flags_atom = NO_ZFALL
	var/view_registered = TRUE
	var/list/view_blocker_images = list()

/mob/hologram/look_up/Initialize(mapload, mob/viewer)
	. = ..()

	if(viewer)
		UnregisterSignal(viewer, COMSIG_CLIENT_MOB_MOVE)
		RegisterSignal(viewer, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
		RegisterSignal(viewer, COMSIG_MOB_GHOSTIZE, PROC_REF(end_lookup))
		update_view_blockers(viewer)

/mob/hologram/look_up/Destroy()
	if(linked_mob)
		UnregisterSignal(linked_mob, COMSIG_MOVABLE_MOVED)
		if(istype(linked_mob, /mob/living))
			var/mob/living/linked_living = linked_mob
			linked_living.observed_atom = null

		if(linked_mob.client)
			linked_mob.client.images -= view_blocker_images
	view_blocker_images.Cut()
	. = ..()

/mob/hologram/look_up/proc/update_view_blockers(mob/user)
	if(!user || !user.client)
		return

	user.client.images -= view_blocker_images
	view_blocker_images.Cut()
	var/list/turf/visible_turfs = alist()

	for(var/turf/cur_turf in view(world.view + 1, user))
		visible_turfs["[cur_turf.x]-[cur_turf.y]"] = TRUE

	for(var/x in user.x - world.view - 1 to user.x + world.view + 1)
		for(var/y in user.y - world.view - 1 to user.y + world.view + 1)
			if(visible_turfs["[x]-[y]"])
				continue

			var/turf/cur_turf = locate(x, y, user.z + 1)

			if(istransparentturf(cur_turf))
				var/image/view_blocker = image('icons/turf/floors/floors.dmi', cur_turf, "full_black", 100000)
				view_blocker.plane = GAME_PLANE
				view_blocker_images += view_blocker
				user.client.images += view_blocker

/mob/hologram/look_up/handle_move(mob/M, oldLoc, direct)
	if(!isturf(M.loc) || HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		qdel(src)
		return

	if(isturf(M.loc) && isturf(oldLoc))
		var/turf/mob_turf = M.loc
		var/turf/old_mob_turf = oldLoc
		if(!direct)
			direct = get_dir(old_mob_turf, mob_turf)
		if(mob_turf.z != old_mob_turf.z)
			qdel(src)
			return

	var/turf/new_turf = get_step(loc, direct)
	forceMove(new_turf)

	if(!istype(new_turf, /turf/open_space))
		UnregisterSignal(linked_mob, COMSIG_MOB_RESET_VIEW)
		view_registered = FALSE
		linked_mob.reset_view()
	else if (!view_registered)
		RegisterSignal(linked_mob, COMSIG_MOB_RESET_VIEW, PROC_REF(end_lookup))
		view_registered = TRUE
		linked_mob.reset_view()

	if(linked_mob)
		update_view_blockers(linked_mob)

/mob/hologram/look_up/movement_delay()
	if(linked_mob)
		return linked_mob.movement_delay()

	return -2

/mob/hologram/look_up/handle_view(mob/M, atom/target)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.set_eye(src)

	return COMPONENT_OVERRIDE_VIEW

/mob/hologram/look_up/take_damage(mob/M, damage, damagetype)
	return //no cancelation of looking up by taking damage

/mob/hologram/look_up/proc/end_lookup()
	SIGNAL_HANDLER
	qdel(src)
