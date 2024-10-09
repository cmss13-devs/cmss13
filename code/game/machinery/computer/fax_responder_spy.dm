/obj/structure/machinery/computer/fax_responder_spy
	name = "monitoring computer"

	icon_state = "terminal"

	var/mob/hologram/fax_spy/spy_eye
	var/mob/living/carbon/human/spy_operator

/obj/structure/machinery/computer/fax_responder_spy/attackby(obj/I as obj, mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/fax_responder_spy/bullet_act(obj/projectile/Proj) //Can't shoot it
	return FALSE




/mob/hologram/fax_spy
	name = "Fax Responder Spy"
	action_icon_state = "queen_exit"
	motion_sensed = TRUE

	color = "#a800a8"

	hud_possible = list(XENO_STATUS_HUD)
	var/mob/is_watching

	var/spy_range = 5
	var/spy_faction = FACTION_NEUTRAL



/mob/hologram/fax_spy/Initialize(mapload, obj/structure/machinery/computer/fax_responder_spy/console)
	if(!console)
		return INITIALIZE_HINT_QDEL

	if(!istype(console))
		stack_trace("Tried to initialize a /mob/hologram/fax_spy on type ([console.type])")
		return INITIALIZE_HINT_QDEL

	spy_range = console.spy_range
	spy_faction = console.spy_faction
	var/mob/spy_operator = console.spy_operator

	// Make sure to turn off any previous overwatches
	spy_operator.overwatch(stop_overwatch = TRUE)

	. = ..()
	RegisterSignal(spy_operator, COMSIG_MOB_PRE_CLICK, PROC_REF(handle_overwatch))
	RegisterSignal(spy_operator, COMSIG_XENO_OVERWATCH_XENO, PROC_REF(start_watching))
	RegisterSignal(spy_operator, list(
		COMSIG_XENO_STOP_OVERWATCH,
		COMSIG_XENO_STOP_OVERWATCH_XENO
	), PROC_REF(stop_watching))
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(can_spy_turf))

	med_hud_set_status()
	add_to_all_mob_huds()

	console.spy_operator.sight |= SEE_TURFS|SEE_OBJS

/mob/hologram/fax_spy/proc/exit_hologram()
	SIGNAL_HANDLER
	qdel(src)

/mob/hologram/fax_spy/handle_move(mob/living/carbon/human/spy_operator, NewLoc, direct)
	if(is_watching && (can_spy_turf(src, is_watching.loc) & COMPONENT_TURF_DENY_MOVEMENT))
		return COMPONENT_OVERRIDE_MOVE

	spy_operator.overwatch(stop_overwatch = TRUE)

	return ..()

// able to stop watching here before the loc is set to null
/mob/hologram/fax_spy/proc/target_watching_qdeleted(mob/living/carbon/target)
	SIGNAL_HANDLER
	stop_watching(linked_mob, target)

/mob/hologram/fax_spy/proc/stop_watching(mob/living/carbon/human/responder, mob/living/carbon/human/target)
	SIGNAL_HANDLER
	if(target)
		if(loc == target)
			var/turf/target_turf = get_turf(target)

			if(target_turf)
				forceMove(target_turf)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)

	if(!isturf(loc) || (can_spy_turf(src, loc) & COMPONENT_TURF_DENY_MOVEMENT))
		forceMove(target.loc)

	is_watching = null
	target.reset_view()
	return

/mob/hologram/fax_spy/proc/can_spy_turf(mob/self, turf/crossing_turf)
	SIGNAL_HANDLER

	if(!crossing_turf)
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(crossing_turf, /turf/closed/wall))
		var/turf/closed/wall/crossing_wall = crossing_turf
		if(crossing_wall.hull)
			return COMPONENT_TURF_DENY_MOVEMENT

	var/list/turf_area = range(spy_range, crossing_turf)

	//for(/obj/structure/machinery/camera/nearby_camera in turf_area)
	//	if(spy_faction in nearby_camera.owner_factions)
	//		return COMPONENT_TURF_ALLOW_MOVEMENT

	var/obj/structure/machinery/camera/nearby_camera = locate() in turf_area
	if(spy_faction in nearby_camera.owner_factions)
		return COMPONENT_TURF_ALLOW_MOVEMENT

	return COMPONENT_TURF_DENY_MOVEMENT

/mob/hologram/fax_spy/proc/is_spy_faction(atom/target_atom)
	if(!ismob(target_atom))
		return FALSE
	var/mob/living/carbon/target_mob = target_atom
	if(!(spy_faction in target_mob.faction_group))
		return FALSE
	return TRUE

/mob/hologram/fax_spy/proc/handle_overwatch(mob/living/carbon/human/spy_operator, atom/A, mods)
	SIGNAL_HANDLER

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	if(!mods["ctrl"])
		return

	if(is_spy_faction(A))
		var/mob/living/carbon/target_mob = A
			spy_operator.overwatch(A)
		return COMPONENT_INTERRUPT_CLICK

	if(!(can_spy_turf(src, T) & COMPONENT_TURF_ALLOW_MOVEMENT))
		return

	forceMove(T)
	if(is_watching)
		spy_operator.overwatch(stop_overwatch = TRUE)

	return COMPONENT_INTERRUPT_CLICK

/mob/hologram/fax_spy/handle_view(mob/spy_operator, atom/target)
	if(spy_operator.client)
		spy_operator.client.perspective = EYE_PERSPECTIVE

		if(is_watching)
			spy_operator.client.eye = is_watching
		else
			spy_operator.client.eye = src

	return COMPONENT_OVERRIDE_VIEW

/mob/hologram/fax_spy/Destroy()
	if(linked_mob)
		linked_mob.sight &= ~(SEE_TURFS|SEE_OBJS)

	remove_from_all_mob_huds()
	is_watching = null

	return ..()
