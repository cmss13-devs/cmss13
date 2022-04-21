var/global/datum/controller/subsystem/evacuation/EvacuationAuthority //This is initited elsewhere so that the world has a chance to load in.

GLOBAL_LIST_EMPTY(dest_rods)

SUBSYSTEM_DEF(evacuation)
	name          = "Evacuation"
	wait          = 30 SECONDS
	init_order    = SS_INIT_EVAC
	priority	  = SS_PRIORITY_EVAC
	flags		  = SS_NO_INIT

	var/evac_time	//Time the evacuation was initiated.
	var/evac_status = EVACUATION_STATUS_STANDING_BY //What it's doing now? It can be standing by, getting ready to launch, or finished.

	var/obj/structure/machinery/self_destruct/console/dest_master //The main console that does the brunt of the work.
	var/dest_rods[] //Slave devices to make the explosion work.
	var/dest_cooldown //How long it takes between rods, determined by the amount of total rods present.
	var/dest_index = 1	//What rod the thing is currently on.
	var/dest_status = NUKE_EXPLOSION_INACTIVE
	var/dest_started_at = 0

	var/lifesigns = 0

	var/flags_scuttle = NO_FLAGS

/datum/controller/subsystem/evacuation/proc/prepare()
	dest_master = locate()
	if(!dest_master)
		log_debug("ERROR CODE SD1: could not find master self-destruct console")
		to_world(SPAN_DEBUG("ERROR CODE SD1: could not find master self-destruct console"))
		return FALSE
	if(!dest_rods)
		dest_rods = new
		for(var/obj/structure/machinery/self_destruct/rod/I in GLOB.dest_rods)
			dest_rods += I
	if(!dest_rods.len)
		log_debug("ERROR CODE SD2: could not find any self destruct rods")
		to_world(SPAN_DEBUG("ERROR CODE SD2: could not find any self destruct rods"))
		return FALSE
	dest_cooldown = SELF_DESTRUCT_ROD_STARTUP_TIME / dest_rods.len
	dest_master.desc = "he main operating panel for a self-destruct system. It requires very little user input, but the final safety mechanism is manually unlocked.\nAfter the initial start-up sequence, [dest_rods.len] control rods must be armed, followed by manually flipping the detonation switch."

/datum/controller/subsystem/evacuation/proc/get_affected_zlevels() //This proc returns the ship's z level list (or whatever specified), when an evac/self destruct happens.
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS && evac_status == EVACUATION_STATUS_COMPLETE) //Nuke is not in progress and evacuation finished, end the round on ship and low orbit (dropships in transit) only.
		. = SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP, ZTRAIT_LOWORBIT))
	else
		if(SSticker.mode && SSticker.mode.is_in_endgame)
			. = SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP, ZTRAIT_LOWORBIT))

/datum/controller/subsystem/evacuation/proc/initiate_evacuation(var/force=0) //Begins the evacuation procedure.
	if(force || (evac_status == EVACUATION_STATUS_STANDING_BY && !(flags_scuttle & FLAGS_EVACUATION_DENY)))
		enter_allowed = 0 //No joining during evac.
		evac_time = world.time
		evac_status = EVACUATION_STATUS_INITIATING
		ai_announcement("Attention. Emergency. All personel must evacuate immediately. You have [round(EVACUATION_ESTIMATE_DEPARTURE/60,1)] minute\s until departure.", 'sound/AI/evacuate.ogg')
		xeno_message_all("A wave of adrenaline ripples through the hive. The fleshy creatures are trying to escape!")
		for(var/obj/structure/machinery/status_display/SD in machines)
			if(is_mainship_level(SD.z))
				SD.set_picture("evac")
		activate_escape()
		activate_lifeboats()
		process_evacuation()

		for(var/obj/docking_port/stationary/lifeboat_dock/LD in GLOB.lifeboat_almayer_docks) //evacuation confirmed, time to open lifeboats
			var/obj/docking_port/mobile/lifeboat/L = LD.get_docked()
			if(L && L.available)
				LD.open_dock()

		return TRUE

/datum/controller/subsystem/evacuation/proc/cancel_evacuation() //Cancels the evac procedure. Useful if admins do not want the marines leaving.
	if(evac_status == EVACUATION_STATUS_INITIATING)
		enter_allowed = 1
		evac_time = null
		evac_status = EVACUATION_STATUS_STANDING_BY
		ai_announcement("Evacuation canceled.", 'sound/AI/evacuate_cancelled.ogg')
		if(get_security_level() == "red")
			for(var/obj/structure/machinery/status_display/SD in machines)
				if(is_mainship_level(SD.z))
					SD.set_picture("redalert")
		deactivate_escape()
		deactivate_lifeboats()
		return TRUE

/datum/controller/subsystem/evacuation/proc/begin_launch() //Launches the pods.
	if(evac_status == EVACUATION_STATUS_INITIATING)
		evac_status = EVACUATION_STATUS_IN_PROGRESS //Cannot cancel at this point. All shuttles are off.
		spawn() //One of the few times spawn() is appropriate. No need for a new proc.
			ai_announcement("WARNING: Evacuation order confirmed. Launching escape pods.", 'sound/AI/evacuation_confirmed.ogg')

			enable_self_destruct()

			for(var/obj/docking_port/stationary/escape_pod_dock/ED in GLOB.escape_almayer_docks)
				var/obj/docking_port/mobile/escape_pod/E = ED.get_docked()
				if(E && E.evacuation_program.dock_state != ESCAPE_STATE_BROKEN)
					E.prepare_for_launch() //May or may not launch, will do everything on its own.
					sleep(5 SECONDS) //Sleeps 5 seconds each launch.

			var/obj/docking_port/mobile/lifeboat/L1 = SSshuttle.getShuttle("lifeboat1")
			var/obj/docking_port/mobile/lifeboat/L2 = SSshuttle.getShuttle("lifeboat2")
			L1.try_launch()
			L2.try_launch()

			lifesigns += L1.survivors + L2.survivors

			ai_announcement("ATTENTION: Evacuation complete. Outbound lifesigns detected: [lifesigns ? lifesigns  : "none"].", 'sound/AI/evacuation_complete.ogg')

			evac_status = EVACUATION_STATUS_COMPLETE

			if(L1.status != LIFEBOAT_LOCKED && L2.status != LIFEBOAT_LOCKED)
				trigger_self_destruct()
			else
				ai_announcement("ATTENTION: Not all lifeboats have escaped, auto self destruct denied.", 'sound/AI/evacuation_complete.ogg')

		return TRUE

/datum/controller/subsystem/evacuation/proc/process_evacuation() //Process the timer.
	set background = 1

	spawn while(evac_status == EVACUATION_STATUS_INITIATING) //If it's not departing, no need to process.
		if(world.time >= evac_time + EVACUATION_AUTOMATIC_DEPARTURE) begin_launch()
		sleep(10) //One second.

/datum/controller/subsystem/evacuation/proc/get_status_panel_eta()
	switch(evac_status)
		if(EVACUATION_STATUS_INITIATING)
			var/eta = EVACUATION_ESTIMATE_DEPARTURE
			. = "[(eta / 60) % 60]:[add_zero(num2text(eta % 60), 2)]"
		if(EVACUATION_STATUS_IN_PROGRESS) . = "NOW"
		if(EVACUATION_STATUS_COMPLETE) . = "Ship Abandoned"


// ESCAPE_POODS
/datum/controller/subsystem/evacuation/proc/activate_escape()
	for(var/obj/docking_port/stationary/escape_pod_dock/ED in GLOB.escape_almayer_docks)
		var/obj/docking_port/mobile/escape_pod/E = ED.get_docked()
		if(E && E.evacuation_program.dock_state != ESCAPE_STATE_BROKEN)
			E.toggle_ready()

/datum/controller/subsystem/evacuation/proc/deactivate_escape()
	for(var/obj/docking_port/stationary/escape_pod_dock/ED in GLOB.escape_almayer_docks)
		var/obj/docking_port/mobile/escape_pod/E = ED.get_docked()
		if(E && E.evacuation_program.dock_state != ESCAPE_STATE_BROKEN)
			E.toggle_ready()


// LIFEBOATS CORNER
/datum/controller/subsystem/evacuation/proc/activate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/LD in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/lifeboat/L = LD.get_docked()
		if(L && L.status != LIFEBOAT_LOCKED)
			L.status = LIFEBOAT_ACTIVE
			L.set_mode(SHUTTLE_RECHARGING)
			L.setTimer(10 MINUTES)

/datum/controller/subsystem/evacuation/proc/deactivate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/LD in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/lifeboat/L = LD.get_docked()
		if(L && L.status != LIFEBOAT_LOCKED)
			L.status = LIFEBOAT_INACTIVE
			L.set_mode(SHUTTLE_IDLE)
			L.setTimer(0)

//=========================================================================================
//===================================SELF DESTRUCT=========================================
//=========================================================================================

/datum/controller/subsystem/evacuation/proc/enable_self_destruct(var/force=0)
	if(force || (dest_status == NUKE_EXPLOSION_INACTIVE && !(flags_scuttle & FLAGS_SELF_DESTRUCT_DENY)))
		dest_status = NUKE_EXPLOSION_ACTIVE
		dest_master.lock_or_unlock()
		dest_started_at = world.time
		set_security_level(SEC_LEVEL_DELTA) //also activate Delta alert, to open the SD shutters.
		spawn(0)
			for(var/obj/structure/machinery/door/poddoor/almayer/D in machines)
				if(D.id == "sd_lockdown")
					D.open()
		return TRUE

//Override is for admins bypassing normal player restrictions.
/datum/controller/subsystem/evacuation/proc/cancel_self_destruct(override)
	if(dest_status == NUKE_EXPLOSION_ACTIVE)
		var/obj/structure/machinery/self_destruct/rod/I
		var/i
		for(i in EvacuationAuthority.dest_rods)
			I = i
			if(I.active_state == SELF_DESTRUCT_MACHINE_ARMED && !override)
				dest_master.state(SPAN_WARNING("WARNING: Unable to cancel detonation. Please disarm all control rods."))
				return FALSE

		dest_status = NUKE_EXPLOSION_INACTIVE
		dest_master.in_progress = 1
		dest_started_at = 0
		for(i in dest_rods)
			I = i
			if(I.active_state == SELF_DESTRUCT_MACHINE_ACTIVE || (I.active_state == SELF_DESTRUCT_MACHINE_ARMED && override)) I.lock_or_unlock(1)
		dest_master.lock_or_unlock(1)
		dest_index = 1
		ai_announcement("The emergency destruct system has been deactivated.", 'sound/AI/selfdestruct_deactivated.ogg')
		if(evac_status == EVACUATION_STATUS_STANDING_BY) //the evac has also been cancelled or was never started.
			set_security_level(SEC_LEVEL_RED, TRUE) //both SD and evac are inactive, lowering the security level.
		return TRUE

/datum/controller/subsystem/evacuation/proc/initiate_self_destruct(override)
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS)
		var/obj/structure/machinery/self_destruct/rod/I
		var/i
		for(i in dest_rods)
			I = i
			if(I.active_state != SELF_DESTRUCT_MACHINE_ARMED && !override)
				dest_master.state(SPAN_WARNING("WARNING: Unable to trigger detonation. Please arm all control rods."))
				return FALSE
		dest_master.in_progress = !dest_master.in_progress
		for(i in EvacuationAuthority.dest_rods)
			I = i
			I.in_progress = 1
		ai_announcement("DANGER. DANGER. Self destruct system activated. DANGER. DANGER. Self destruct in progress. DANGER. DANGER.")
		trigger_self_destruct(,,override)
		return TRUE

/datum/controller/subsystem/evacuation/proc/trigger_self_destruct(list/z_levels = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP), origin = dest_master, override = FALSE, end_type = NUKE_EXPLOSION_FINISHED, play_anim = TRUE, end_round = TRUE)
	set waitfor = 0
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS) //One more check for good measure, in case it's triggered through a bomb instead of the destruct mechanism/admin panel.
		dest_status = NUKE_EXPLOSION_IN_PROGRESS
		playsound(origin, 'sound/machines/Alarm.ogg', 75, 0, 30)
		world << pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')

		var/ship_status = 1
		for(var/i in z_levels)
			if(is_mainship_level(i))
				ship_status = 0 //Destroyed.
			break

		var/L1[] = new //Everyone who will be destroyed on the zlevel(s).
		var/L2[] = new //Everyone who only needs to see the cinematic.
		var/mob/M
		var/turf/T
		for(M in GLOB.player_list) //This only does something cool for the people about to die, but should prove pretty interesting.
			if(!M || !M.loc) continue //In case something changes when we sleep().
			if(M.stat == DEAD)
				L2 |= M
			else if(M.z in z_levels)
				L1 |= M
				shake_camera(M, 110, 4)


		sleep(100)
		/*Hardcoded for now, since this was never really used for anything else.
		Would ideally use a better system for showing cutscenes.*/
		var/obj/screen/cinematic/explosion/C = new

		if(play_anim)
			for(M in L1 + L2)
				if(M && M.loc && M.client)
					M.client.screen |= C //They may have disconnected in the mean time.

			sleep(15) //Extra 1.5 seconds to look at the ship.
			flick(override ? "intro_override" : "intro_nuke", C)
		sleep(35)
		for(M in L1)
			if(M && M.loc) //Who knows, maybe they escaped, or don't exist anymore.
				T = get_turf(M)
				if(T.z in z_levels)
					if(istype(M.loc, /obj/structure/closet/secure_closet/freezer/fridge))
						continue
					M.death(create_cause_data("nuclear explosion"))
				else
					if(play_anim)
						M.client.screen -= C //those who managed to escape the z level at last second shouldn't have their view obstructed.
		if(play_anim)
			flick(ship_status ? "ship_spared" : "ship_destroyed", C)
			C.icon_state = ship_status ? "summary_spared" : "summary_destroyed"
		world << sound('sound/effects/explosionfar.ogg')

		if(end_round)
			dest_status = end_type

			sleep(5)
			if(SSticker.mode)
				SSticker.mode.check_win()

			if(!SSticker.mode) //Just a safety, just in case a mode isn't running, somehow.
				to_world(SPAN_ROUNDBODY("Resetting in 30 seconds!"))
				sleep(300)
				log_game("Rebooting due to nuclear detonation.")
				world.Reboot(SSticker.graceful)
			return TRUE

/datum/controller/subsystem/evacuation/proc/process_self_destruct()
	set background = 1

	spawn while(dest_master && dest_master.loc && dest_master.active_state == SELF_DESTRUCT_MACHINE_ARMED && dest_status == NUKE_EXPLOSION_ACTIVE && dest_index <= dest_rods.len)
		var/obj/structure/machinery/self_destruct/rod/I = dest_rods[dest_index]
		if(world.time >= dest_cooldown + I.activate_time)
			I.lock_or_unlock() //Unlock it.
			if(++dest_index <= dest_rods.len)
				I = dest_rods[dest_index]//Start the next sequence.
				I.activate_time = world.time
		sleep(10) //Checks every second. Could integrate into another controller for better tracking.

//Generic parent base for the self_destruct items.
/obj/structure/machinery/self_destruct
	icon = 'icons/obj/structures/machinery/self_destruct.dmi'
	use_power = 0 //Runs unpowered, may need to change later.
	density = FALSE
	anchored = TRUE //So it doesn't go anywhere.
	unslashable = TRUE
	unacidable = TRUE //Cannot C4 it either.
	mouse_opacity = FALSE //No need to click or interact with this initially.
	var/in_progress = 0 //Cannot interact with while it's doing something, like an animation.
	var/active_state = SELF_DESTRUCT_MACHINE_INACTIVE //What step of the process it's on.

/obj/structure/machinery/self_destruct/Initialize(mapload, ...)
	. = ..()
	icon_state += "_1"

/obj/structure/machinery/self_destruct/Destroy()
	. = ..()
	machines -= src
	operator = null

/obj/structure/machinery/self_destruct/ex_act(severity)
	return FALSE

/obj/structure/machinery/self_destruct/attack_hand()
	if(..() || in_progress)
		return FALSE //This check is backward, ugh.
	return TRUE

//Add sounds.
/obj/structure/machinery/self_destruct/proc/lock_or_unlock(lock)
	set waitfor = 0
	in_progress = 1
	flick(initial(icon_state) + (lock? "_5" : "_2"),src)
	sleep(9)
	mouse_opacity = !mouse_opacity
	icon_state = initial(icon_state) + (lock? "_1" : "_3")
	in_progress = 0
	active_state = active_state > SELF_DESTRUCT_MACHINE_INACTIVE ? SELF_DESTRUCT_MACHINE_INACTIVE : SELF_DESTRUCT_MACHINE_ACTIVE

/obj/structure/machinery/self_destruct/console
	name = "self destruct control panel"
	icon_state = "console"

/obj/structure/machinery/self_destruct/console/Destroy()
	. = ..()
	EvacuationAuthority.dest_master = null
	EvacuationAuthority.dest_rods = null

/obj/structure/machinery/self_destruct/console/lock_or_unlock(lock)
	playsound(src, 'sound/machines/hydraulics_1.ogg', 25, 1)
	..()

/obj/structure/machinery/self_destruct/console/attack_hand(mob/user)
	. = ..()
	if(.) ui_interact(user)

/obj/structure/machinery/self_destruct/console/Topic(href, href_list)
	if(..())
		return TRUE
	switch(href_list["command"])
		if("dest_start")
			to_chat(usr, SPAN_NOTICE("You press a few keys on the panel."))
			to_chat(usr, SPAN_NOTICE("The system must be booting up the self-destruct sequence now."))
			ai_announcement("Danger. The emergency destruct system is now activated. The ship will detonate in T-minus 20 minutes. Automatic detonation is unavailable. Manual detonation is required.", 'sound/AI/selfdestruct.ogg')
			active_state = SELF_DESTRUCT_MACHINE_ARMED //Arm it here so the process can execute it later.
			var/obj/structure/machinery/self_destruct/rod/I = EvacuationAuthority.dest_rods[EvacuationAuthority.dest_index]
			I.activate_time = world.time
			EvacuationAuthority.process_self_destruct()
			var/data[] = list(
				"dest_status" = active_state
			)
			nanomanager.try_update_ui(usr, src, "main",, data)
		if("dest_trigger")
			if(EvacuationAuthority.initiate_self_destruct()) nanomanager.close_user_uis(usr, src, "main")
		if("dest_cancel")
			var/list/allowed_officers = list("Commanding Officer", "Executive Officer", "Staff Officer", "Chief MP","Chief Medical Officer","Chief Engineer")
			if(!allowed_officers.Find(usr.job))
				to_chat(usr, SPAN_NOTICE("You don't have the necessary clearance to cancel the emergency destruct system."))
				return
			if(EvacuationAuthority.cancel_self_destruct()) nanomanager.close_user_uis(usr, src, "main")

/obj/structure/machinery/self_destruct/console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[] = list(
		"dest_status" = active_state
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "self_destruct_console.tmpl", "OMICRON6 PAYLOAD", 470, 290)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/self_destruct/rod
	name = "self destruct control rod"
	desc = "It is part of a complicated self-destruct sequence, but relatively simple to operate. Twist to arm or disarm."
	icon_state = "rod"
	layer = BELOW_OBJ_LAYER
	var/activate_time

/obj/structure/machinery/self_destruct/rod/Initialize(mapload, ...)
	. = ..()
	GLOB.dest_rods += src

/obj/structure/machinery/self_destruct/rod/Destroy()
	. = ..()
	GLOB.dest_rods -= src

/obj/structure/machinery/self_destruct/rod/lock_or_unlock(lock)
	playsound(src, 'sound/machines/hydraulics_2.ogg', 25, 1)
	..()
	if(lock)
		activate_time = null
		density = FALSE
		layer = initial(layer)
	else
		density = TRUE
		layer = ABOVE_OBJ_LAYER

/obj/structure/machinery/self_destruct/rod/attack_hand(mob/user)
	if(..())
		switch(active_state)
			if(SELF_DESTRUCT_MACHINE_ACTIVE)
				to_chat(user, SPAN_NOTICE("You twist and release the control rod, arming it."))
				playsound(src, 'sound/machines/switch.ogg', 25, 1)
				icon_state = "rod_4"
				active_state = SELF_DESTRUCT_MACHINE_ARMED
			if(SELF_DESTRUCT_MACHINE_ARMED)
				to_chat(user, SPAN_NOTICE("You twist and release the control rod, disarming it."))
				playsound(src, 'sound/machines/switch.ogg', 25, 1)
				icon_state = "rod_3"
				active_state = SELF_DESTRUCT_MACHINE_ACTIVE
			else to_chat(user, SPAN_WARNING("The control rod is not ready."))
