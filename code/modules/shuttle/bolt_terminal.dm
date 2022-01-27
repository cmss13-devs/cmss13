/* BOLT CONTROLS for lifeboat manual launch */
#define BOLT_TERMINAL_LOCKED 0
#define BOLT_TERMINAL_UNLOCKED 1
#define BOLT_TERMINAL_LAUNCHING 2
#define BOLT_TERMINAL_LAUNCHED 3

#define BOLT_TERMINAL_UNLOCK_ID (1<<0)
#define BOLT_TERMINAL_UNLOCK_TEMP (1<<1)

#define BOLT_TERMINAL_AIMING (1<<0)
#define BOLT_TERMINAL_AIMED (1<<1)
#define BOLT_TERMINAL_FIRING (1<<2)

/obj/structure/machinery/bolt_control
	name = "bolt controller"
	desc = "The manual launch control for the lifeboats. The instruction label reads:\nTo manually decouple and launch:\n1. Ensure that the lifeboats have been refueled. Fuel is kept unloaded for safety reasons.\n2. Disengage safety from the clearance panel with ID access or with a hand-print scan from a secondary personnel.\n3. Ignite the decoupling explosive bolts' fuse by discharging a firearm into the central 10mm target.\nExtreme caution is advised as failure to hit the target may results in decoupling malfunction, bodily injuries and death."
	use_power = FALSE
	density = FALSE
	indestructible = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/stage = BOLT_TERMINAL_LOCKED
	var/id	//uses the shuttleID?

/obj/structure/machinery/bolt_control/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/bolt_control/target
	name = "Manual Launch - Target"
	icon = 'icons/obj/structures/machinery/bolt_target.dmi'
	icon_state = "closed"

	var/aim_status = NO_FLAGS
	var/obj/structure/machinery/bolt_control/panel/sis_panel

/obj/structure/machinery/bolt_control/target/LateInitialize()
	if(sis_panel)
		return
	for(var/obj/structure/machinery/bolt_control/panel/M in machines)
		if(M.id == id)
			M.sis_target = src
			sis_panel = M
			break

/obj/structure/machinery/bolt_control/ex_act(severity)
	return FALSE

/obj/structure/machinery/bolt_control/target/update_icon()
	. = ..()

	switch(stage)
		if(BOLT_TERMINAL_LOCKED)
			icon_state = "closed"

		if(BOLT_TERMINAL_UNLOCKED)
			if(sis_panel.access)
				icon_state = "red"
			else
				icon_state = "opened"

		if(BOLT_TERMINAL_LAUNCHING)
			icon_state = "flashing"

		if(BOLT_TERMINAL_LAUNCHED)
			icon_state = "released"

//procs for fancy visuals here
/obj/structure/machinery/bolt_control/target/proc/targeting_overlay()	//target overlay animation
	overlays.Cut()

	var/image/I = image('icons/effects/Targeted.dmi',"locking_movement")
	I.pixel_x = 1

	overlays += I
	aim_status |= BOLT_TERMINAL_AIMING
	playsound(src,'sound/weapons/TargetOn.ogg', 35)

/obj/structure/machinery/bolt_control/target/proc/remove_target_overlay()
	overlays.Cut()

	aim_status &= ~BOLT_TERMINAL_AIMING
	aim_status &= ~BOLT_TERMINAL_AIMED
	playsound(src,'sound/weapons/TargetOff.ogg', 35)

/obj/structure/machinery/bolt_control/target/proc/targeted_overlay()	//Final "locked in" overlay
	overlays.Cut()

	var/image/I = image('icons/effects/Targeted.dmi',"locked_wide")
	I.pixel_x = 1

	overlays += I
	aim_status &= ~BOLT_TERMINAL_AIMING
	aim_status |= BOLT_TERMINAL_AIMED
	playsound(src, 'sound/weapons/TargetOn.ogg', 35)


//Proc is used to see if the gun actually fired something
/obj/structure/machinery/bolt_control/target/bullet_act(obj/item/projectile/P)
	if((aim_status & BOLT_TERMINAL_FIRING) && operator == P.firer && P.ammo.damage && (P.ammo.damage_type == BRUTE || P.ammo.damage_type == BURN))
		detonate()

//Proc to aim a gun at the fuse
/obj/structure/machinery/bolt_control/target/attackby(obj/item/weapon/gun/G, mob/user)
	if(!istype(G) || !sis_panel.access || stage >= BOLT_TERMINAL_LAUNCHING)
		return

	if(aim_status & BOLT_TERMINAL_AIMED && sis_panel.operator != user && operator == user)//Fires gun when properly aimed
		aim_status |= BOLT_TERMINAL_FIRING
		remove_target_overlay()
		G.Fire(src, user)
		sleep(1)
		aim_status &= ~BOLT_TERMINAL_FIRING
		return

	if(user.action_busy || aim_status)
		return

	to_chat(user, SPAN_NOTICE("You aim at the bolt, steadying your arm..."))

	targeting_overlay()
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		remove_target_overlay()
		to_chat(user, SPAN_WARNING("You were interrupted and lost your aim."))
		return

	targeted_overlay()
	operator = user
	to_chat(user, SPAN_BOLDNOTICE("You are ready to shoot the bolt!"))

	if(do_after(user, 1 MINUTES, (INTERRUPT_ALL|INTERRUPT_LCLICK), BUSY_ICON_GENERIC, numticks = 60))//switch to move signal event? or use interrupt leftmouse click?
		to_chat(user, SPAN_WARNING("You lose your aim as your arm tires."))

	remove_target_overlay()

//detonate
/obj/structure/machinery/bolt_control/target/proc/detonate()
	if(stage >= BOLT_TERMINAL_LAUNCHING)
		return

	operator.Stun(2)
	shake_camera(operator, 15, 1,2)

//	operator.count_statistic_stat(STATISTICS_SACRIFICE)
//	if(sis_panel.operator)
//		sis_panel.operator.count_statistic_stat(STATISTICS_SACRIFICE) MAKE SURE COMMIT AFTER STATISTIC DB REFACTOR MERGED!!!

	detonate_animation()//launch proc here
	var/obj/docking_port/mobile/lifeboat/L = SSshuttle.getShuttle(id)
	if(!istype(L))
		return

	if(L.mode == SHUTTLE_IDLE && L.available)
		log_game("[key_name(usr)] has sent the shuttle [L] to infinite transit")
		visible_message(SPAN_NOTICE("<b>\The [src]</b> beeps, \"Shuttle departing. Please stand away from the doors.\""))
		L.try_launch()

/obj/structure/machinery/bolt_control/target/proc/detonate_animation()
	set waitfor = FALSE

	stage = BOLT_TERMINAL_LAUNCHING
	sis_panel.stage = BOLT_TERMINAL_LAUNCHING
	update_icon()
	sis_panel.update_icon()
	sleep(30)
	flick("releasing", src)
	stage = BOLT_TERMINAL_LAUNCHED
	update_icon()
	sleep(10)
	sis_panel.stage = BOLT_TERMINAL_LAUNCHED
	sis_panel.update_icon()

/obj/structure/machinery/bolt_control/target/proc/unlock()
	if(stage != BOLT_TERMINAL_LOCKED)
		return
	stage = BOLT_TERMINAL_UNLOCKED
	sis_panel.stage = BOLT_TERMINAL_UNLOCKED
	flick("opening", src)
	flick("opening_raising", sis_panel)
	update_icon()
	sis_panel.update_icon()
	spawn(2.5 MINUTES)
		detonate()


/obj/structure/machinery/bolt_control/panel
	name = "Manual Launch - Terminal"
	icon = 'icons/obj/structures/machinery/bolt_terminal.dmi'
	icon_state = "closed"
	pixel_x = 1
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_CORPORATE)
	var/access = NO_FLAGS
	var/obj/structure/machinery/bolt_control/target/sis_target

/obj/structure/machinery/bolt_control/panel/update_icon()
	. = ..()

	switch(stage)
		if(BOLT_TERMINAL_LOCKED)
			icon_state = "closed"

		if(BOLT_TERMINAL_UNLOCKED)
			if(access)
				icon_state = "green"
			else
				icon_state = "red"

		if(BOLT_TERMINAL_LAUNCHING)
			icon_state = "flashing"

		if(BOLT_TERMINAL_LAUNCHED)
			icon_state = "green"

/obj/structure/machinery/bolt_control/panel/LateInitialize()
	if(!sis_target)
		for(var/obj/structure/machinery/bolt_control/target/M in machines)
			if(M.id == id)
				M.sis_panel = src
				sis_target = M
				break

/obj/structure/machinery/bolt_control/panel/ex_act(severity)
	return FALSE

/obj/structure/machinery/bolt_control/panel/attack_hand(var/mob/user)
	if(..() || stage != BOLT_TERMINAL_UNLOCKED)
		return

	if(allowed(user))
		id_unlock(user)
		return

	if(!access)
		access |= BOLT_TERMINAL_UNLOCK_TEMP
		operator = user
		flick("raising", sis_target)
		update_icon()
		sis_target.update_icon()
		visible_message(SPAN_NOTICE("[user] presses their hand onto the panel, unlocking it."))

		if(!do_after(user, 3 MINUTES, INTERRUPT_ALL, BUSY_ICON_GENERIC,numticks = 180) && stage < BOLT_TERMINAL_LAUNCHING)
			access &= ~BOLT_TERMINAL_UNLOCK_TEMP
			operator = null
			flick("falling",sis_target)
			update_icon()
			sis_target.update_icon()
			visible_message(SPAN_NOTICE("[user] releases their hand from the panel, relocking it."))

/obj/structure/machinery/bolt_control/panel/attackby(obj/item/W, mob/user)
	if(check_access(W) && stage == BOLT_TERMINAL_UNLOCKED)
		id_unlock(user)
		return
	return ..()

/obj/structure/machinery/bolt_control/panel/proc/id_unlock(mob/user)
	if(access & BOLT_TERMINAL_UNLOCK_ID)
		flick("falling", sis_target)
		visible_message(SPAN_NOTICE("[user] relocks the panel with their ID."))
	else
		flick("raising", sis_target)
		visible_message(SPAN_NOTICE("[user] unlocks the panel with their ID."))
	access ^= BOLT_TERMINAL_UNLOCK_ID
	update_icon()
	sis_target.update_icon()

#undef BOLT_TERMINAL_LOCKED
#undef BOLT_TERMINAL_UNLOCKED
#undef BOLT_TERMINAL_LAUNCHING
#undef BOLT_TERMINAL_LAUNCHED

#undef BOLT_TERMINAL_UNLOCK_ID
#undef BOLT_TERMINAL_UNLOCK_TEMP

#undef BOLT_TERMINAL_AIMING
#undef BOLT_TERMINAL_AIMED
#undef BOLT_TERMINAL_FIRING
