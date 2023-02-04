GLOBAL_LIST_EMPTY(hologram_list)

/mob/hologram
	name = "Hologram"
	desc = "It seems to be a visual projection of someone" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "hologram"
	canmove = TRUE
	blinded = FALSE

	invisibility = INVISIBILITY_OBSERVER
	sight = SEE_SELF
	layer = ABOVE_FLY_LAYER

	var/action_icon_state = "hologram_exit"

	var/mob/linked_mob
	var/datum/action/leave_hologram/leave_button

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

	leave_button = new(null, action_icon_state)
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
		M.client.mouse_pointer_icon = mouse_icon

	return COMPONENT_OVERRIDE_VIEW


/mob/hologram/BlockedPassDirs(atom/movable/mover, target_dir)
	return NO_BLOCKED_MOVEMENT

/mob/hologram/Destroy()
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
	qdel(src)

/datum/action/leave_hologram/Destroy()
	QDEL_NULL(linked_hologram)
	return ..()

/mob/hologram/techtree/Initialize(mapload, mob/M)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_ENTER_TREE, PROC_REF(disallow_tree_entering))


/mob/hologram/techtree/proc/disallow_tree_entering(mob/M, datum/techtree/T, force)
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_TREE_ENTRY
