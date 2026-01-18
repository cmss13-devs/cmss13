#define STATE_IDLE 4 //Pod is idle, not ready to launch.
#define STATE_BROKEN 5 //Pod failed to launch, is now broken.
#define STATE_READY 6 //Pod is armed and ready to go.
#define STATE_DELAYED 7 //Pod is being delayed from launching automatically.
#define STATE_LAUNCHING 8 //Pod is about to launch.
#define STATE_LAUNCHED 9 //Pod has successfully launched.

/obj/structure/machinery/computer/shuttle/escape_pod_panel
	name = "escape pod controller"
	icon = 'icons/obj/structures/machinery/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	unslashable = TRUE
	unacidable = TRUE
	var/pod_state = STATE_IDLE
	var/launch_without_evac = FALSE

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ex_act(severity)
	return FALSE

// TGUI stufferinos \\

/obj/structure/machinery/computer/shuttle/escape_pod_panel/attack_hand(mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied!"))
		return
	tgui_interact(user)

/obj/structure/machinery/computer/shuttle/escape_pod_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EscapePodConsole", "[src.name]")
		ui.open()

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_data(mob/user)
	. = list()
	var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle = SSshuttle.getShuttle(shuttleId)

	if(pod_state == STATE_IDLE && shuttle.evac_set)
		pod_state = STATE_READY

	.["docking_status"] = pod_state
	switch(shuttle.mode)
		if(SHUTTLE_CRASHED)
			.["docking_status"] = STATE_BROKEN
		if(SHUTTLE_IGNITING)
			.["docking_status"] = STATE_LAUNCHING
		if(SHUTTLE_CALL)
			.["docking_status"] = STATE_LAUNCHED
	var/obj/structure/machinery/door/door = shuttle.door_handler.doors[1]
	.["door_state"] = door.density
	.["door_lock"] = shuttle.door_handler.status == SHUTTLE_DOOR_LOCKED
	.["can_delay"] = TRUE//launch_status[2]
	.["launch_without_evac"] = launch_without_evac


/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle = SSshuttle.getShuttle(shuttleId)
	switch(action)
		if("force_launch")
			if(!launch_without_evac && pod_state != STATE_READY && pod_state != STATE_DELAYED)
				return

			shuttle.evac_launch()
			pod_state = STATE_LAUNCHING
			. = TRUE
		if("delay_launch")
			pod_state = pod_state == STATE_DELAYED ? STATE_READY : STATE_DELAYED
			. = TRUE
		if("lock_door")
			var/obj/structure/machinery/door/target_door = shuttle.door_handler.doors[1]
			if(target_door.density) //Closed
				shuttle.door_handler.control_doors("force-unlock")
			else //Open
				shuttle.door_handler.control_doors("force-lock-launch")
			. = TRUE

/obj/structure/machinery/computer/shuttle/escape_pod_panel/liaison
	req_access = list(ACCESS_WY_GENERAL)
	launch_without_evac = TRUE

//=========================================================================================
//================================Evacuation Sleeper=======================================
//=========================================================================================

/obj/structure/machinery/cryopod/evacuation
	stat = MACHINE_DO_NOT_PROCESS
	unslashable = TRUE
	unacidable = TRUE
	time_till_despawn = 6000000 //near infinite so despawn never occurs.
	/// The name of the mob who injected the occupant into the pod. If it does not match the occupant, the occupant can leave.
	var/injector_name
	var/being_forced = 0 //Simple variable to prevent sound spam.
	var/dock_state = STATE_IDLE

/obj/structure/machinery/cryopod/evacuation/ex_act(severity)
	return FALSE

/obj/structure/machinery/cryopod/evacuation/attackby(obj/item/grab/the_grab, mob/user)
	if(istype(the_grab))
		if(user.is_mob_incapacitated() || !(ishuman(user)))
			return FALSE

		if(being_forced)
			to_chat(user, SPAN_WARNING("There's something forcing it open!"))
			return FALSE

		if(occupant)
			to_chat(user, SPAN_WARNING("There is someone in there already!"))
			return FALSE

		if(dock_state < STATE_READY)
			to_chat(user, SPAN_WARNING("The cryo pod is not responding to commands!"))
			return FALSE

		var/mob/living/carbon/human/grabbed_mob = the_grab.grabbed_thing
		if(!istype(grabbed_mob))
			return FALSE
		if(grabbed_mob.stat == DEAD) //This mob is dead
			to_chat(user, SPAN_WARNING("[src] immediately rejects [grabbed_mob]. \He passed away!"))
			return FALSE

		visible_message(SPAN_WARNING("[user] starts putting [grabbed_mob.name] into the cryo pod."), null, null, 3)

		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(!grabbed_mob || !the_grab || !the_grab.grabbed_thing || !the_grab.grabbed_thing.loc || the_grab.grabbed_thing != grabbed_mob)
				return FALSE
			move_mob_inside(grabbed_mob)
			injector_name = user.real_name

/obj/structure/machinery/cryopod/evacuation/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)

	if(!occupant || !usr.stat || usr.is_mob_restrained())
		return FALSE

	add_fingerprint(usr)
	//Once you're in, you cannot exit, and outside forces cannot eject you.
	//The occupant is actually automatically ejected once the evac is canceled.
	if(occupant != usr)
		to_chat(usr, SPAN_WARNING("You are unable to eject the occupant unless the evacuation is canceled."))
		return FALSE
	if(occupant.real_name != injector_name)
		go_out()
	else
		to_chat(usr, SPAN_WARNING("You are unable to leave the [src] until evacuation completes, or is cancelled!."))
		return FALSE

/obj/structure/machinery/cryopod/evacuation/go_out() //When the system ejects the occupant.
	if(occupant)
		occupant.forceMove(get_turf(src))
		occupant.in_stasis = FALSE
		occupant = null
		injector_name = null
		icon_state = orient_right ? "body_scanner_open-r" : "body_scanner_open"

/obj/structure/machinery/cryopod/evacuation/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	var/mob/living/carbon/human/user = usr

	if(!istype(user) || user.stat || user.is_mob_restrained())
		return FALSE

	if(being_forced)
		to_chat(user, SPAN_WARNING("You can't enter when it's being forced open!"))
		return FALSE

	if(occupant)
		to_chat(user, SPAN_WARNING("The cryogenic pod is already in use! You will need to find another."))
		return FALSE

	if(dock_state < STATE_READY)
		to_chat(user, SPAN_WARNING("The cryo pod is not responding to commands!"))
		return FALSE

	visible_message(SPAN_WARNING("[user] starts climbing into the cryo pod."), null, null, 3)

	if(do_after(user, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		user.stop_pulling()
		move_mob_inside(user)
		injector_name = user.real_name

/obj/structure/machinery/cryopod/evacuation/attack_alien(mob/living/carbon/xenomorph/user)
	if(being_forced)
		to_chat(user, SPAN_XENOWARNING("It's being forced open already!"))
		return XENO_NO_DELAY_ACTION

	if(!occupant)
		to_chat(user, SPAN_XENOWARNING("There is nothing of interest in there."))
		return XENO_NO_DELAY_ACTION

	being_forced = !being_forced
	xeno_attack_delay(user)
	visible_message(SPAN_WARNING("[user] begins to pry \the [src]'s cover!"), null, null, 3)
	playsound(src,'sound/effects/metal_creaking.ogg', 25, 1)
	if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		go_out() //Force the occupant out.
	being_forced = !being_forced
	return XENO_NO_DELAY_ACTION

/obj/structure/machinery/cryopod/evacuation/proc/move_mob_inside(mob/M)
	if(occupant)
		to_chat(M, SPAN_WARNING("The cryogenic pod is already in use. You will need to find another."))
		return FALSE
	M.forceMove(src)
	to_chat(M, SPAN_NOTICE("You feel cool air surround you as your mind goes blank and the pod locks."))
	occupant = M
	occupant.in_stasis = STASIS_IN_CRYO_CELL
	add_fingerprint(M)
	icon_state = orient_right ? "body_scanner_closed-r" : "body_scanner_closed"


/obj/structure/machinery/door/airlock/evacuation
	name = "\improper Evacuation Airlock"
	icon = 'icons/obj/structures/doors/pod_doors.dmi'
	unslashable = TRUE
	unacidable = TRUE
	var/obj/docking_port/mobile/crashable/escape_shuttle/linked_shuttle
	var/start_locked = TRUE

/obj/structure/machinery/door/airlock/evacuation/Initialize()
	. = ..()
	if(start_locked)
		INVOKE_ASYNC(src, PROC_REF(lock))

/obj/structure/machinery/door/airlock/evacuation/Destroy()
	if(linked_shuttle)
		linked_shuttle.set_mode(SHUTTLE_CRASHED)
		linked_shuttle.door_handler.doors -= list(src)
	. = ..()

	//Can't interact with them, mostly to prevent grief and meta.
/obj/structure/machinery/door/airlock/evacuation/Collided()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attackby()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attack_hand()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!density || unslashable) //doors become slashable after evac is called
		return FALSE

	if(xeno.claw_type < CLAW_TYPE_SHARP)
		to_chat(xeno, SPAN_WARNING("[src] is bolted down tight."))
		return XENO_NO_DELAY_ACTION

	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	take_damage(HEALTH_DOOR / XENO_HITS_TO_DESTROY_BOLTED_DOOR)
	return XENO_ATTACK_ACTION


/obj/structure/machinery/door/airlock/evacuation/attack_remote()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/get_applying_acid_time() //you can melt evacuation doors only when they are manually locked
	if(!density)
		return -1
	return ..()

/obj/structure/machinery/door/airlock/evacuation/liaison
	start_locked = FALSE
