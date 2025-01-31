GLOBAL_LIST_EMPTY_TYPED(hologram_list, /mob/hologram)

/mob/hologram
	name = "Hologram"
	desc = "It seems to be a visual projection of someone" //jinkies!
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

/mob/hologram/movement_delay()
	. = -2 // Very fast speed, so they can navigate through easily, they can't ever have movement delay whilst as a hologram

/mob/hologram/Initialize(mapload, mob/M)
	if(!M)
		return INITIALIZE_HINT_QDEL

	. = ..()

	GLOB.hologram_list += src
	RegisterSignal(M, COMSIG_CLIENT_MOB_MOVE, PROC_REF(handle_move))
	RegisterSignal(M, COMSIG_MOB_RESET_VIEW, PROC_REF(handle_view))
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), PROC_REF(take_damage))
	RegisterSignal(M, list(
		COMSIG_BINOCULAR_ATTACK_SELF,
		COMSIG_BINOCULAR_HANDLE_CLICK
	), PROC_REF(handle_binoc))

	linked_mob = M
	linked_mob.reset_view()

	name = "[initial(name)] ([M.name])"

	leave_button = new initial_leave_button(null, action_icon_state)
	leave_button.linked_hologram = src
	leave_button.give_to(M)

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
		M.client.eye = src

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

/mob/hologram/look_up/Initialize(mapload, mob/viewer)
	. = ..()

	if(viewer)
		UnregisterSignal(viewer, COMSIG_CLIENT_MOB_MOVE)
		RegisterSignal(viewer, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

/mob/hologram/look_up/Destroy()
	if(linked_mob)
		UnregisterSignal(linked_mob, COMSIG_MOVABLE_MOVED)

	. = ..()

/mob/hologram/look_up/handle_move(mob/M, oldLoc, direct)
	var/turf/new_turf = get_step(loc, direct)
	forceMove(new_turf)
	
	if(!istype(new_turf, /turf/open_space))
		UnregisterSignal(linked_mob, COMSIG_MOB_RESET_VIEW)
		view_registered = FALSE
		linked_mob.reset_view()
	else if (!view_registered)
		RegisterSignal(linked_mob, COMSIG_MOB_RESET_VIEW, PROC_REF(handle_view))
		view_registered = TRUE
		linked_mob.reset_view()

/mob/hologram/look_up/movement_delay()
	if(linked_mob)
		return linked_mob.movement_delay()

	return -2

/mob/hologram/look_up/handle_view(mob/M, atom/target)	
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src

	return COMPONENT_OVERRIDE_VIEW
