/obj/structure/machinery/computer/spy_camera
	name = "remote monitoring computer"

	icon_state = "terminal"

	var/mob/hologram/spy_camera/spy_eye
	var/spy_range = 5
	var/spy_faction = FACTION_NEUTRAL

	var/turf/last_location
	var/turf/start_location
	var/target_z

	/// Computer and Spycam can only be used if this variable is cleared
	var/locked = FALSE

/obj/structure/machinery/computer/spy_camera/Initialize()
	. = ..()

	target_z = z

/obj/structure/machinery/computer/spy_camera/attackby(obj/I as obj, mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/spy_camera/bullet_act(obj/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/spy_camera/proc/set_operator(mob/living/carbon/human/new_operator)
	if(!istype(new_operator))
		return
	remove_current_operator()

	operator = new_operator
	var/datum/mob_hud/spy_hud = GLOB.huds[MOB_HUD_SPYCAMS]
	spy_hud.add_hud_to(new_operator, src)
	RegisterSignal(operator, COMSIG_PARENT_QDELETING, PROC_REF(remove_current_operator))
	RegisterSignal(operator, COMSIG_MOVABLE_MOVED, PROC_REF(remove_current_operator))

	if(!last_location)
		last_location = locate(1, 1, target_z)

		start_location = last_location

	spy_eye = new(last_location, new_operator, src)
	//RegisterSignal(eye, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_and_set_zlevel))
	RegisterSignal(spy_eye, COMSIG_PARENT_QDELETING, PROC_REF(remove_current_operator))

/*
/obj/structure/machinery/computer/spy_camera/proc/check_and_set_zlevel(/mob/hologram/spy_camera/hologram, turf/NewLoc, direction)
	SIGNAL_HANDLER
	if(!start_location)
		start_location = loc

	if(!NewLoc || (NewLoc.z != target_z && hologram.z != target_z))
		hologram.forceMove(start_location)
		return COMPONENT_OVERRIDE_MOVE
*/

/obj/structure/machinery/computer/spy_camera/proc/remove_current_operator()
	SIGNAL_HANDLER
	if(!operator) return

	if(spy_eye)
		last_location = spy_eye.loc
		if(spy_eye.gc_destroyed)
			spy_eye = null
		else
			QDEL_NULL(spy_eye)

	UnregisterSignal(operator, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_PRE_MOVE,
		COMSIG_MOB_POST_CLICK
	))
	operator.update_sight()
	var/datum/mob_hud/spy_hud = GLOB.huds[MOB_HUD_SPYCAMS]
	spy_hud.remove_hud_from(operator, src)
	operator = null

/obj/structure/machinery/computer/spy_camera/attack_hand(mob/living/carbon/human/pos_operator)
	if(..())
		return

	if(!istype(pos_operator))
		return

	if(locked || (!(pos_operator.faction == FACTION_FAX) && !(spy_faction in pos_operator.faction_group)))
		to_chat(pos_operator, SPAN_WARNING("The remote camera system is locked out!"))
		return FALSE

	if(operator && operator.stat == CONSCIOUS)
		to_chat(pos_operator, SPAN_WARNING("Someone is already using this computer!"))
		return

	if(tgui_alert(pos_operator, "Change the camera focus?", "Spycam Computer", list("Yes", "No")) == "Yes")
		var/obj/effect/landmark/spycam_start/start_point = tgui_input_list(pos_operator, "Where do you want to focus the camera?", "Camera Focus", GLOB.spycam_starts)
		if(!start_point)
			return
		last_location = start_point.loc

	set_operator(pos_operator)


/obj/effect/landmark/spycam_start
	name = "Spycam Landmark"
	icon_state = "spycam"

/obj/effect/landmark/spycam_start/Initialize()
	. = ..()
	name = "Spycam [get_area_name(src, TRUE)]"
	GLOB.spycam_starts += src

/obj/effect/landmark/spycam_start/Destroy()
	GLOB.spycam_starts -= src
	return ..()

/mob/hologram/spy_camera
	name = "Spy Camera"
	motion_sensed = FALSE
	icon_state = "spycam"

	color = "#10948d"

	hud_possible = list(SPYCAM_HUD)
	hears_speech = TRUE

	var/mob/living/carbon/is_watching

	var/spy_range = 5
	var/spy_faction = FACTION_NEUTRAL


/mob/hologram/spy_camera/Initialize(mapload, mob/living/carbon/spy_operator, obj/structure/machinery/computer/spy_camera/console)
	if(!console || !spy_operator)
		return INITIALIZE_HINT_QDEL

	if(!istype(console))
		stack_trace("Tried to initialize a /mob/hologram/spy_camera on type ([console.type])")
		return INITIALIZE_HINT_QDEL

	spy_range = console.spy_range
	spy_faction = console.spy_faction
	faction = spy_faction

	switch(spy_faction)
		if(FACTION_MARINE, FACTION_MARSHAL)
			color = "#0947bb"
		if(FACTION_CLF)
			color = "#717fbd"
		if(FACTION_UPP)
			color = "#0f3d11"
		if(FACTION_TWE)
			color = "#b350c0"
		if(FACTION_WY)
			color = "#b6b6b6"

	// Make sure to turn off any previous overwatches
	spy_operator.overwatch(stop_overwatch = TRUE)

	. = ..()

	name = "Spy Camera ([spy_faction])"
	RegisterSignal(spy_operator, COMSIG_MOB_PRE_CLICK, PROC_REF(handle_overwatch))
	//RegisterSignal(spy_operator, COMSIG_XENO_OVERWATCH_XENO, PROC_REF(start_watching))
	//RegisterSignal(spy_operator, list(
	//	COMSIG_XENO_STOP_OVERWATCH,
	//	COMSIG_XENO_STOP_OVERWATCH_XENO
	//), PROC_REF(stop_watching))
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(can_spy_turf))

	med_hud_set_status()
	add_to_all_mob_huds()

	spy_operator.sight |= SEE_TURFS|SEE_OBJS

/mob/hologram/spy_camera/proc/exit_hologram()
	SIGNAL_HANDLER
	qdel(src)

/mob/hologram/spy_camera/handle_move(mob/living/carbon/human/spy_operator, NewLoc, direct)
	if(is_watching && (can_spy_turf(src, is_watching.loc) & COMPONENT_TURF_DENY_MOVEMENT))
		return COMPONENT_OVERRIDE_MOVE

	spy_operator.overwatch(stop_overwatch = TRUE)

	return ..()

/mob/hologram/spy_camera/proc/start_watching(mob/living/carbon/human/source_mob, mob/living/carbon/human/target_mob)
	SIGNAL_HANDLER
	forceMove(target_mob)
	is_watching = target_mob

	RegisterSignal(target_mob, COMSIG_PARENT_QDELETING, PROC_REF(target_watching_qdeleted))
	return

// able to stop watching here before the loc is set to null
/mob/hologram/spy_camera/proc/target_watching_qdeleted(mob/living/carbon/target)
	SIGNAL_HANDLER
	stop_watching(linked_mob, target)

/mob/hologram/spy_camera/proc/stop_watching(mob/living/carbon/human/responder, mob/living/carbon/human/target)
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

/mob/hologram/spy_camera/proc/can_spy_turf(mob/self, turf/crossing_turf)
	SIGNAL_HANDLER

	if(!crossing_turf || istype(crossing_turf, /turf/open/space) || istype(get_area(crossing_turf), /area/space))
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(crossing_turf, /turf/closed/wall))
		var/turf/closed/wall/crossing_wall = crossing_turf
		if(crossing_wall.hull)
			return COMPONENT_TURF_DENY_MOVEMENT

	if((spy_faction in FACTION_LIST_MARINE_FAXES) && is_mainship_level(z))
		return COMPONENT_TURF_ALLOW_MOVEMENT

	var/list/turf_area = range(spy_range, crossing_turf)

	//for(/obj/structure/machinery/camera/nearby_camera in turf_area)
	//	if(spy_faction in nearby_camera.owner_factions)
	//		return COMPONENT_TURF_ALLOW_MOVEMENT

	var/obj/structure/machinery/camera/nearby_camera = locate() in turf_area
	if(spy_faction in nearby_camera.owner_factions)
		return COMPONENT_TURF_ALLOW_MOVEMENT

	return COMPONENT_TURF_DENY_MOVEMENT

/mob/hologram/spy_camera/proc/is_spy_faction(atom/target_atom)
	if(!ismob(target_atom))
		return FALSE
	var/mob/living/carbon/target_mob = target_atom
	if(!(spy_faction in target_mob.faction_group))
		return FALSE
	return TRUE

/mob/hologram/spy_camera/proc/handle_overwatch(mob/living/carbon/human/spy_operator, atom/target_atom, mods)
	SIGNAL_HANDLER

	var/turf/T = get_turf(target_atom)
	if(!istype(T))
		return

	if(!mods["ctrl"])
		return

	if(is_spy_faction(target_atom))
		var/mob/living/carbon/target_mob = target_atom
		spy_operator.overwatch(target_mob)
		return COMPONENT_INTERRUPT_CLICK

	if(!(can_spy_turf(src, T) & COMPONENT_TURF_ALLOW_MOVEMENT))
		return

	forceMove(T)
	if(is_watching)
		spy_operator.overwatch(stop_overwatch = TRUE)

	return COMPONENT_INTERRUPT_CLICK

/mob/hologram/spy_camera/handle_view(mob/spy_operator, atom/target)
	if(spy_operator.client)
		spy_operator.client.perspective = EYE_PERSPECTIVE

		if(is_watching)
			spy_operator.client.eye = is_watching
		else
			spy_operator.client.eye = src

	return COMPONENT_OVERRIDE_VIEW

/mob/hologram/spy_camera/Destroy()
	if(linked_mob)
		linked_mob.sight &= ~(SEE_TURFS|SEE_OBJS)

	remove_from_all_mob_huds()
	is_watching = null

	return ..()

/mob/hologram/spy_camera/add_to_all_mob_huds()
	var/datum/mob_hud/hud = GLOB.huds[MOB_HUD_SPYCAMS]
	hud.add_to_hud(src)

/mob/hologram/spy_camera/remove_from_all_mob_huds()
	var/datum/mob_hud/hud = GLOB.huds[MOB_HUD_SPYCAMS]
	hud.remove_from_hud(src)

/mob/hologram/spy_camera/med_hud_set_status()
	var/image/holder = hud_list[SPYCAM_HUD]
	holder.icon_state = "hudeye"
	holder.color = color



/obj/structure/machinery/computer/spy_camera/uscm
	spy_faction = FACTION_MARINE

/obj/structure/machinery/computer/spy_camera/wy
	spy_faction = FACTION_WY

/obj/structure/machinery/computer/spy_camera/twe
	spy_faction = FACTION_TWE

/obj/structure/machinery/computer/spy_camera/clf
	spy_faction = FACTION_CLF

/obj/structure/machinery/computer/spy_camera/upp
	spy_faction = FACTION_UPP

/obj/structure/machinery/computer/spy_camera/cmb
	spy_faction = FACTION_MARSHAL
