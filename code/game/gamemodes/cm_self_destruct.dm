/*
TODO
Look into animation screen not showing on self-destruct and other weirdness
Intergrate distress into this controller.
Finish nanoui conversion for comm console.
Make sure people who get nuked and wake up from SSD don't live.
Add flashing lights to evac. //DEFERRED TO BETTER LIGHTING
Finish the game mode announcement thing.
Fix escape doors to work properly.
*/

/*
How this works:

First: All of the linking is done automatically on world start, so nothing needs to be done on that end other than making
sure that objects are actually placed in the game world. If not, the game will error and let you know about it. But you
don't need to modify variables or worry about area placement. It's all done for you.
The rods, for example, configure the time per activation based on their number. Shuttles link their own machines via area.
Nothing in this controller is linked to game mode, so it's stand alone, more or less, but it's best used during a game mode.
Admins have a lot of tools in their disposal via the check antagonist panel, and devs can access the VV of this controller
through that panel.

Second: The communication console handles most of the IC triggers for activating these functions, the rest is handled elsewhere.
Check communications.dm for that. shuttle_controller.dm handles the set up for the escape pods. escape_pods.dm handles most of the
functions of the escape pods themselves. This file would likely need to be broken down into individual parts at some point in the
future.

Evacuation takes place when sufficient alert level is reaised and a distress beacon was launched. All of the evac pods come online
and open their doors to allow entry inside. Characters may then get inside of the cryo units to before the shuttles automatically launch.
If wanted, a nearby controller object may launch each individual shuttle early. Only three people may ride on a shuttle to escape,
otherwise the launch will fail and the shuttle will become inoperable.
Any launched shuttles are taken out of the game. If the evacuation is canceled, any persons inside of the cryo tubes will be ejected.
They may temporarily open the door to exit if they are stuck inside after evac is canceled.

When the self-destruct is enabled, the console comes online. This usually happens during an evacuation. Once the console is
interacted with, it fires up the self-destruct sequence. Several rods rise and must be interacted with in order to arm the system.
Once that happens, the console must be interacted with again to trigger the self-destruct. The self-destruct may also be
canceled from the console.

The self-destruct may also happen if a nuke is detonated on the ship's zlevel; if it is detonated elsewhere, the ship will not blow up.
Regardless of where it's detonated, or how, a successful detonation will end the round or automatically restart the game.

All of the necessary difines are stored under mode.dm in defines.
*/

var/global/datum/authority/branch/evacuation/EvacuationAuthority //This is initited elsewhere so that the world has a chance to load in.

/datum/authority/branch/evacuation
	var/name = "Evacuation Authority"
	var/evac_time //Time the evacuation was initiated.
	var/evac_status = EVACUATION_STATUS_STANDING_BY //What it's doing now? It can be standing by, getting ready to launch, or finished.

	var/obj/structure/machinery/self_destruct/console/dest_master //The main console that does the brunt of the work.
	var/dest_rods[] //Slave devices to make the explosion work.
	var/dest_cooldown //How long it takes between rods, determined by the amount of total rods present.
	var/dest_index = 1 //What rod the thing is currently on.
	var/dest_status = NUKE_EXPLOSION_INACTIVE
	var/dest_started_at = 0

	var/flags_scuttle = NO_FLAGS

/datum/authority/branch/evacuation/New()
	..()
	dest_master = locate()
	if(!dest_master)
		log_debug("ERROR CODE SD1: could not find master self-destruct console")
		to_world(SPAN_DEBUG("ERROR CODE SD1: could not find master self-destruct console"))
		return FALSE
	dest_rods = new
	for(var/obj/structure/machinery/self_destruct/rod/I in dest_master.loc.loc) dest_rods += I
	if(!dest_rods.len)
		log_debug("ERROR CODE SD2: could not find any self-destruct rods")
		to_world(SPAN_DEBUG("ERROR CODE SD2: could not find any self-destruct rods"))
		QDEL_NULL(dest_master)
		return FALSE
	dest_cooldown = SELF_DESTRUCT_ROD_STARTUP_TIME / dest_rods.len
	dest_master.desc = "The main operating panel for a self-destruct system. It requires very little user input, but the final safety mechanism is manually unlocked.\nAfter the initial start-up sequence, [dest_rods.len] control rods must be armed, followed by manually flipping the detonation switch."

/datum/authority/branch/evacuation/proc/get_affected_zlevels() //This proc returns the ship's z level list (or whatever specified), when an evac/self-destruct happens.
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS && evac_status == EVACUATION_STATUS_COMPLETE) //Nuke is not in progress and evacuation finished, end the round on ship and low orbit (dropships in transit) only.
		. = SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP, ZTRAIT_LOWORBIT))
	else
		if(SSticker.mode && SSticker.mode.is_in_endgame)
			. = SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP, ZTRAIT_LOWORBIT))

//=========================================================================================
//=========================================================================================
//=====================================EVACUATION==========================================
//=========================================================================================
//=========================================================================================


/datum/authority/branch/evacuation/proc/initiate_evacuation(force=0) //Begins the evacuation procedure.
	if(force || (evac_status == EVACUATION_STATUS_STANDING_BY && !(flags_scuttle & FLAGS_EVACUATION_DENY)))
		evac_time = world.time
		evac_status = EVACUATION_STATUS_INITIATING
		ai_announcement("Attention. Emergency. All personnel must evacuate immediately. You have [round(EVACUATION_ESTIMATE_DEPARTURE/60,1)] minute\s until departure.", 'sound/AI/evacuate.ogg')
		xeno_message_all("A wave of adrenaline ripples through the hive. The fleshy creatures are trying to escape!")
		var/datum/shuttle/ferry/marine/evacuation_pod/P
		for(var/obj/structure/machinery/status_display/SD in machines)
			if(is_mainship_level(SD.z))
				SD.set_picture("evac")
		for(var/i = 1 to MAIN_SHIP_ESCAPE_POD_NUMBER)
			P = shuttle_controller.shuttles["[MAIN_SHIP_NAME] Evac [i]"]
			P.toggle_ready()
		activate_lifeboats()
		process_evacuation()
		return TRUE

/datum/authority/branch/evacuation/proc/cancel_evacuation() //Cancels the evac procedure. Useful if admins do not want the marines leaving.
	if(evac_status == EVACUATION_STATUS_INITIATING)
		evac_time = null
		evac_status = EVACUATION_STATUS_STANDING_BY
		deactivate_lifeboats()
		ai_announcement("Evacuation has been cancelled.", 'sound/AI/evacuate_cancelled.ogg')
		var/datum/shuttle/ferry/marine/evacuation_pod/P
		if(get_security_level() == "red")
			for(var/obj/structure/machinery/status_display/SD in machines)
				if(is_mainship_level(SD.z))
					SD.set_picture("redalert")
		for(var/i = 1 to MAIN_SHIP_ESCAPE_POD_NUMBER)
			P = shuttle_controller.shuttles["[MAIN_SHIP_NAME] Evac [i]"]
			P.toggle_ready()
		return TRUE

/datum/authority/branch/evacuation/proc/begin_launch() //Launches the pods.
	if(evac_status == EVACUATION_STATUS_INITIATING)
		evac_status = EVACUATION_STATUS_IN_PROGRESS //Cannot cancel at this point. All shuttles are off.
		spawn() //One of the few times spawn() is appropriate. No need for a new proc.
			ai_announcement("WARNING: Evacuation order confirmed. Launching escape pods.", 'sound/AI/evacuation_confirmed.ogg')
			lifeboat_unlock_manual_launch()
			var/datum/shuttle/ferry/marine/evacuation_pod/P
			var/L[] = new
			var/i
			for(i = 1 to MAIN_SHIP_ESCAPE_POD_NUMBER) L += i
			while(L.len)
				i = pick(L)
				P = shuttle_controller.shuttles["[MAIN_SHIP_NAME] Evac [i]"]
				P.prepare_for_launch() //May or may not launch, will do everything on its own.
				L -= i
				sleep(50) //Sleeps 5 seconds each launch.
			sleep(300) //Sleep 30 more seconds to make sure everyone had a chance to leave.
			var/lifesigns = 0
			lifesigns += P.passengers
			var/obj/docking_port/mobile/lifeboat/lifeboat1 = SSshuttle.getShuttle(MOBILE_SHUTTLE_LIFEBOAT_PORT)
			lifeboat1.check_for_survivors()
			lifesigns += lifeboat1.survivors
			var/obj/docking_port/mobile/lifeboat/lifeboat2 = SSshuttle.getShuttle(MOBILE_SHUTTLE_LIFEBOAT_STARBOARD)
			lifeboat2.check_for_survivors()
			lifesigns += lifeboat2.survivors
			ai_announcement("ATTENTION: Evacuation complete. Outbound lifesigns detected: [lifesigns ? lifesigns  : "none"].", 'sound/AI/evacuation_complete.ogg')
			evac_status = EVACUATION_STATUS_COMPLETE
		return TRUE

/datum/authority/branch/evacuation/proc/process_evacuation() //Process the timer.
	set background = 1

	spawn while(evac_status == EVACUATION_STATUS_INITIATING) //If it's not departing, no need to process.
		if(world.time >= evac_time + EVACUATION_AUTOMATIC_DEPARTURE) begin_launch()
		sleep(10) //One second.

/datum/authority/branch/evacuation/proc/get_status_panel_eta()
	switch(evac_status)
		if(EVACUATION_STATUS_INITIATING)
			var/eta = EVACUATION_ESTIMATE_DEPARTURE
			. = "[(eta / 60) % 60]:[add_zero(num2text(eta % 60), 2)]"
		if(EVACUATION_STATUS_IN_PROGRESS) . = "NOW"

// LIFEBOATS CORNER
/datum/authority/branch/evacuation/proc/activate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_ACTIVE
			lifeboat_dock.open_dock()


/datum/authority/branch/evacuation/proc/deactivate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_INACTIVE

/datum/authority/branch/evacuation/proc/launch_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.send_to_infinite_transit()

//unlocks Manual Launch
/datum/authority/branch/evacuation/proc/lifeboat_unlock_manual_launch()
	for(var/obj/structure/machinery/lifeboat_bolt/target/bolt in machines)
		bolt.unlock()

////BOLT CONTROLS/// for lifeboat manual launch
#define LOCKED 0
#define UNLOCKED 1
#define LAUNCHING 2
#define LAUNCHED 3

#define AIMING 1
#define AIMED 2
#define FIRING 3

#define PRIMED_TEMP 1
#define PRIMED_PERMA 2

/obj/structure/machinery/lifeboat_bolt
	name = "Bolt Controller"
	desc_lore = "The Detonation Escape Switch, simply shortened to DES is a dead switch system developed for usage in emergencies when out in deep space, intended for priming an escape shuttle if all else failed. Due to the nature of the switch requiring constant pressure in order to function and launch the escape shuttle, it has been affectionately nicknamed the 'Des-pair switch' by crews that had their ships fitted with one."
	use_power = FALSE
	density = FALSE
	indestructible = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/id

/obj/structure/machinery/lifeboat_bolt/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

//Explosive Bolt Fuse/Target - shoot here to release bolts
//id should be the same as lifeboat dock ID for launch purpose
/obj/structure/machinery/lifeboat_bolt/target
	name = "DES-7 Manual Launch Fuse"
	desc = "The DES-7 12mm Fuse needs to be primed and ignited in order to detonate and launch the linked escape shuttle. Originally designed to be ignited by the purpose-built DES-7-N ignition gun, but it was soon noted in the 'Space, Ships and Stars' handbook by George Lambert that any firearm could perform the necessary action in an emergency situation."
	icon = 'icons/obj/structures/machinery/bolt_target.dmi'
	icon_state = "closed"

	var/obj/structure/machinery/lifeboat_bolt/id_panel/sister_panel
	var/stage = LOCKED //Unlocked, Locked, Launching & Launched
	var/aim_status	//Aiming, Aimed, Firing

/obj/structure/machinery/lifeboat_bolt/target/get_examine_text()
	. = ..()
	if(sister_panel.primed)
		. += SPAN_NOTICE("The control panel is <span class='bold'>primed</span>.\n<span class='bold'>Aim</span> then <span class='bold'>fire</span> to ignite the fuse and launch the lifeboat.")
	else
		. += SPAN_NOTICE("The control panel is <span class='bold'>deactivated</span>.\nPrime it using the other Control Panel.")

/obj/structure/machinery/lifeboat_bolt/target/update_icon()
	. = ..()
	switch(stage)
		if(LOCKED)
			icon_state = "closed"
		if(UNLOCKED)
			if(sister_panel.primed)
				icon_state = "red"
			else
				icon_state = "opened"
		if(LAUNCHING)
			icon_state = "flashing"
		if(LAUNCHED)
			icon_state = "released"


/obj/structure/machinery/lifeboat_bolt/target/LateInitialize()
	if(sister_panel)
		return

	for(var/obj/structure/machinery/lifeboat_bolt/id_panel/M in machines)
		if(M.id == id)
			M.sister_target = src
			sister_panel = M
			break

	if(!sister_panel)
		stat |= BROKEN

//ANIMATION & SOUNDFX
/obj/structure/machinery/lifeboat_bolt/target/proc/targeting_overlay()
	overlays.Cut()
	var/image/I = image('icons/effects/Targeted.dmi',"locking_movement")
	I.pixel_x = 1
	overlays += I
	aim_status = AIMING
	playsound(src,'sound/weapons/TargetOn.ogg', 35)

/obj/structure/machinery/lifeboat_bolt/target/proc/targeted_overlay()
	overlays.Cut()
	var/image/I = image('icons/effects/Targeted.dmi',"locked_wide")
	I.pixel_x = 1
	overlays += I
	aim_status = AIMED
	playsound(src,'sound/weapons/TargetOn.ogg', 35)

/obj/structure/machinery/lifeboat_bolt/target/proc/remove_target_overlay()
	overlays.Cut()
	aim_status = null
	playsound(src,'sound/weapons/TargetOff.ogg', 35)

/obj/structure/machinery/lifeboat_bolt/target/proc/unlock()
	if(stage != LOCKED)
		return
	stage = UNLOCKED
	flick("opening",src)
	flick("opening_raising",sister_panel)
	update_icon()
	sister_panel.update_icon()

//TIMED TO MATCH EXPLOSION, for best effect
/obj/structure/machinery/lifeboat_bolt/target/proc/detonate_animation()
	stage = LAUNCHING
	update_icon()
	sister_panel.update_icon()
	addtimer(CALLBACK(src, PROC_REF(detonate_animation_2)), 30)

/obj/structure/machinery/lifeboat_bolt/target/proc/detonate_animation_2()
	flick("releasing",src)
	stage = LAUNCHED
	update_icon()
	addtimer(CALLBACK(sister_panel, TYPE_PROC_REF(/obj/structure/machinery/lifeboat_bolt/id_panel,update_icon)), 10)

/obj/structure/machinery/lifeboat_bolt/target/proc/detonate()
	if(stage >= LAUNCHING)
		return

	var/msg_log = "[key_name_admin(operator)] has launched the lifeboat [id]."
	if(sister_panel.primed == PRIMED_TEMP) msg_log += "\n With Help from [sister_panel.operator]."
	log_game(msg_log)
	message_staff(msg_log)

	operator.apply_effect(3,STUN)
	shake_camera(operator, 15, 1, 2)

	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock as anything in GLOB.lifeboat_almayer_docks)
		if(lifeboat_dock.id != id) continue
		var/obj/docking_port/mobile/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.send_to_infinite_transit()
		break

	INVOKE_ASYNC(src, PROC_REF(detonate_animation))

//Proc is used to see if the gun actually fired something
/obj/structure/machinery/lifeboat_bolt/target/bullet_act(obj/item/projectile/P)
	if(aim_status == FIRING && P.ammo.damage && (P.ammo.damage_type == BRUTE || P.ammo.damage_type == BURN))
		detonate()

/obj/structure/machinery/lifeboat_bolt/target/proc/finish_firing()
	aim_status = null

/obj/structure/machinery/lifeboat_bolt/target/attackby(obj/item/weapon/gun/G, mob/user)
	if(!istype(G) || !(sister_panel.primed) || stage >= LAUNCHING)
		return

	if(aim_status == AIMED && sister_panel.operator != user && operator == user)//Fires gun when properly aimed
		remove_target_overlay()
		aim_status = FIRING
		G.Fire(src,user)
		addtimer(CALLBACK(src, PROC_REF(finish_firing)), 2)
		return

	if(user.action_busy || aim_status) return

	targeting_overlay()
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC) || !(sister_panel.primed))
		remove_target_overlay()
		return

	targeted_overlay()
	operator = user

	if(do_after(user, 1 MINUTES, (INTERRUPT_ALL|INTERRUPT_LCLICK), BUSY_ICON_GENERIC, numticks = 60))//switch to move signal event? or use interrupt leftmouse click?
		to_chat(user, SPAN_WARNING("You lose your aim as your arm tires."))

	remove_target_overlay()

//////////////////////////////////////
//ID-SCAN PANEL - Anti-Grief Device
//Command ID is needed set and prime for the Fuse Iginition
//Instead without ID access, A second person needs to constantly hold down the control panel to prime it.
/obj/structure/machinery/lifeboat_bolt/id_panel
	name = "DES-7 Manual Launch Control Panel"
	desc = "The DES-7 control panel requires Command Access to set the fuel gauge and prime the Fuse. The fuel gauge can be manually set by having another person applying pressure."
	icon = 'icons/obj/structures/machinery/bolt_terminal.dmi'
	icon_state = "closed"
	pixel_x = 1
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_CORPORATE)
	var/obj/structure/machinery/lifeboat_bolt/target/sister_target
	var/primed = 0

/obj/structure/machinery/lifeboat_bolt/id_panel/get_examine_text()
	. = ..()
	if(primed)
		. += SPAN_NOTICE("The control panel is <span class='bold'>primed</span>.\n<span class='bold'>Shoot</span> the <span class='bold'>fuse</span> to manually launch the lifeboat.")
	else
		. += SPAN_NOTICE("The control panel is <span class='bold'>deactivated</span>.\nSwipe <span class='bold'>Command ID</span> or find any personnel to <span class='bold'>apply constant pressure</span> to Panel.")

/obj/structure/machinery/lifeboat_bolt/id_panel/update_icon()
	. = ..()
	switch(sister_target.stage)
		if(LOCKED)
			icon_state = "closed"
		if(UNLOCKED)
			if(primed)
				icon_state = "green"
			else
				icon_state = "red"
		if(LAUNCHING)
			icon_state = "flashing"
		if(LAUNCHED)
			icon_state = "green"

/obj/structure/machinery/lifeboat_bolt/id_panel/LateInitialize()
	if(sister_target)
		return

	for(var/obj/structure/machinery/lifeboat_bolt/target/M in machines)
		if(M.id == id)
			M.sister_panel = src
			sister_target = M
			break

	if(!sister_target)
		stat |= BROKEN

/obj/structure/machinery/lifeboat_bolt/id_panel/proc/id_unlock(mob/user)
	if(primed == PRIMED_PERMA)
		flick("falling",sister_target)
		visible_message(SPAN_NOTICE("[user] releases and deactivates the panel with their ID."))
		primed = null
	else
		flick("raising",sister_target)
		visible_message(SPAN_NOTICE("[user] sets and activates the panel with their ID."))
		primed = PRIMED_PERMA

	update_icon()
	sister_target.update_icon()

/obj/structure/machinery/lifeboat_bolt/id_panel/attack_hand(mob/user)
	if((. = ..()) || sister_target.stage != UNLOCKED)
		return

	if(allowed(user))
		id_unlock(user)
		return

	if(!primed)
		primed = PRIMED_TEMP
		operator = user
		flick("raising",sister_target)
		update_icon()
		sister_target.update_icon()
		visible_message(SPAN_NOTICE("[user] presses their hand onto the panel, activing it."))

		do_after(user, 3 MINUTES, INTERRUPT_ALL, BUSY_ICON_GENERIC,numticks = 180)

		primed = null
		operator = null
		flick("falling",sister_target)
		update_icon()
		sister_target.update_icon()
		visible_message(SPAN_NOTICE("[user] releases their hand from the panel, deactivating it."))

/obj/structure/machinery/lifeboat_bolt/id_panel/attackby(obj/item/W, mob/user)
	if(check_access(W) && sister_target.stage == UNLOCKED)
		id_unlock(user)
		return
	. = ..()


#undef LOCKED
#undef UNLOCKED
#undef LAUNCHING
#undef LAUNCHED

#undef AIMING
#undef AIMED
#undef FIRING

#undef PRIMED_TEMP
#undef PRIMED_PERMA


//=========================================================================================
//=========================================================================================
//=====================================SELF DETRUCT========================================
//=========================================================================================
//=========================================================================================

/datum/authority/branch/evacuation/proc/enable_self_destruct(force=0)
	if(force || (dest_status == NUKE_EXPLOSION_INACTIVE && !(flags_scuttle & FLAGS_SELF_DESTRUCT_DENY)))
		dest_status = NUKE_EXPLOSION_ACTIVE
		dest_master.lock_or_unlock()
		dest_started_at = world.time
		set_security_level(SEC_LEVEL_DELTA) //also activate Delta alert, to open the SD shutters.
		spawn(0)
			for(var/obj/structure/machinery/door/poddoor/shutters/almayer/D in machines)
				if(D.id == "sd_lockdown")
					D.open()
		return TRUE

//Override is for admins bypassing normal player restrictions.
/datum/authority/branch/evacuation/proc/cancel_self_destruct(override)
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

/datum/authority/branch/evacuation/proc/initiate_self_destruct(override)
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
		ai_announcement("DANGER. DANGER. Self-destruct system activated. DANGER. DANGER. Self-destruct in progress. DANGER. DANGER.")
		trigger_self_destruct(,,override)
		return TRUE

/datum/authority/branch/evacuation/proc/trigger_self_destruct(list/z_levels = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP), origin = dest_master, override = FALSE, end_type = NUKE_EXPLOSION_FINISHED, play_anim = TRUE, end_round = TRUE)
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
		var/atom/movable/screen/cinematic/explosion/C = new

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
				world.Reboot()
			return TRUE

/datum/authority/branch/evacuation/proc/process_self_destruct()
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
	use_power = USE_POWER_NONE //Runs unpowered, may need to change later.
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
	name = "self-destruct control panel"
	icon_state = "console"
	req_one_access = list(ACCESS_MARINE_CE, ACCESS_MARINE_CMO, ACCESS_MARINE_CAPTAIN, ACCESS_MARINE_COMMANDER)

/obj/structure/machinery/self_destruct/console/Destroy()
	. = ..()
	EvacuationAuthority.dest_master = null
	EvacuationAuthority.dest_rods = null

/obj/structure/machinery/self_destruct/console/lock_or_unlock(lock)
	playsound(src, 'sound/machines/hydraulics_1.ogg', 25, 1)
	..()

//TODO: Add sounds.
/obj/structure/machinery/self_destruct/console/attack_hand(mob/user)
	if(inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/self_destruct/console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SelfDestructConsole", name)
		ui.open()

/obj/structure/machinery/sleep_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE


/obj/structure/machinery/self_destruct/console/ui_data(mob/user)
	var/list/data = list()

	data["dest_status"] = active_state

	return data

/obj/structure/machinery/self_destruct/console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("dest_start")
			to_chat(usr, SPAN_NOTICE("You press a few keys on the panel."))
			to_chat(usr, SPAN_NOTICE("The system must be booting up the self-destruct sequence now."))
			playsound(src.loc, 'sound/items/rped.ogg', 25, TRUE)
			sleep(2 SECONDS)
			ai_announcement("Danger. The emergency destruct system is now activated. The ship will detonate in T-minus 20 minutes. Automatic detonation is unavailable. Manual detonation is required.", 'sound/AI/selfdestruct.ogg')
			active_state = SELF_DESTRUCT_MACHINE_ARMED //Arm it here so the process can execute it later.
			var/obj/structure/machinery/self_destruct/rod/I = EvacuationAuthority.dest_rods[EvacuationAuthority.dest_index]
			I.activate_time = world.time
			EvacuationAuthority.process_self_destruct()
			. = TRUE

		if("dest_trigger")
			EvacuationAuthority.initiate_self_destruct()
			. = TRUE

		if("dest_cancel")
			if(!allowed(usr))
				to_chat(usr, SPAN_WARNING("You don't have the necessary clearance to cancel the emergency destruct system!"))
				return
			EvacuationAuthority.cancel_self_destruct()
			. = TRUE

/obj/structure/machinery/self_destruct/rod
	name = "self-destruct control rod"
	desc = "It is part of a complicated self-destruct sequence, but relatively simple to operate. Twist to arm or disarm."
	icon_state = "rod"
	layer = BELOW_OBJ_LAYER
	var/activate_time

/obj/structure/machinery/self_destruct/rod/Destroy()
	. = ..()
	if(EvacuationAuthority && EvacuationAuthority.dest_rods)
		EvacuationAuthority.dest_rods -= src

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
