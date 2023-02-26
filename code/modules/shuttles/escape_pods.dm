//=========================================================================================
//================================Evacuation Sleeper=======================================
//=========================================================================================

/obj/structure/machinery/cryopod/evacuation
	stat = MACHINE_DO_NOT_PROCESS
	unslashable = TRUE
	unacidable = TRUE
	time_till_despawn = 6000000 //near infinite so despawn never occurs.
	var/being_forced = 0 //Simple variable to prevent sound spam.
	var/dock_state = STATE_IDLE

/obj/structure/machinery/cryopod/evacuation/ex_act(severity)
	return FALSE

/obj/structure/machinery/cryopod/evacuation/attackby(obj/item/grab/G, mob/user)
	if(istype(G))
		if(being_forced)
			to_chat(user, SPAN_WARNING("There's something forcing it open!"))
			return FALSE

		if(occupant)
			to_chat(user, SPAN_WARNING("There is someone in there already!"))
			return FALSE

		if(dock_state < STATE_READY)
			to_chat(user, SPAN_WARNING("The cryo pod is not responding to commands!"))
			return FALSE

		var/mob/living/carbon/human/M = G.grabbed_thing
		if(!istype(M))
			return FALSE

		visible_message(SPAN_WARNING("[user] starts putting [M.name] into the cryo pod."), null, null, 3)

		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(!M || !G || !G.grabbed_thing || !G.grabbed_thing.loc || G.grabbed_thing != M)
				return FALSE
			move_mob_inside(M)

/obj/structure/machinery/cryopod/evacuation/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)

	if(!occupant || !usr.stat || usr.is_mob_restrained())
		return FALSE

	if(occupant) //Once you're in, you cannot exit, and outside forces cannot eject you.
		//The occupant is actually automatically ejected once the evac is canceled.
		if(occupant != usr) to_chat(usr, SPAN_WARNING("You are unable to eject the occupant unless the evacuation is canceled."))

	add_fingerprint(usr)

/obj/structure/machinery/cryopod/evacuation/go_out() //When the system ejects the occupant.
	if(occupant)
		occupant.forceMove(get_turf(src))
		occupant.in_stasis = FALSE
		occupant = null
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
	if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE)) go_out() //Force the occupant out.
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
	heat_proof = 1
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/airlock/evacuation/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(lock))

	//Can't interact with them, mostly to prevent grief and meta.
/obj/structure/machinery/door/airlock/evacuation/Collided()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attackby()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attack_hand()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attack_alien()
	return FALSE //Probably a better idea that these cannot be forced open.

/obj/structure/machinery/door/airlock/evacuation/attack_remote()
	return FALSE

#undef STATE_IDLE
#undef STATE_READY
#undef STATE_BROKEN
#undef STATE_LAUNCHED
