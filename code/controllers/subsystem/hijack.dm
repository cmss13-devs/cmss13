SUBSYSTEM_DEF(hijack)
	name   = "Hijack"
	wait   = 2 SECONDS
	flags  = SS_KEEP_TIMING
	priority   = SS_PRIORITY_HIJACK
	init_order = SS_INIT_HIJACK

	///Required progress to safely arrive at our destination
	var/required_progress = 100

	/// The progress at which the ship will enter FTL
	var/ftl_required_progress = 50

	///Current progress towards the FTL jump
	var/current_progress = 0

	/// How much progress is required to early launch
	var/early_launch_required_progress = 25

	///The estimated time left to get to the safe evacuation point
	var/estimated_time_left = 0

	///Areas that are marked as having progress, assoc list that is progress_area = boolean, the boolean indicating if it was progressing or not on the last fire()
	var/list/area/progress_areas = list()

	///The areas that need to be cycled through currently
	var/list/area/current_run = list()

	///The mobs that need to be cycled through currently
	var/list/area/current_run_mobs = list()

	///The progress of the current run that needs to be added at the end of the current run
	var/current_run_progress_additive = 0

	///Holds what the current_run_progress_additive should be multiplied by at the end of the current run
	var/current_run_progress_multiplicative = 1

	///Holds the progress change from last run
	var/last_run_progress_change = 0

	///Holds the next % point progress should be announced, increments on itself
	var/announce_checkpoint = 25

	///What stage of evacuation we are currently on
	var/evac_status = EVACUATION_STATUS_NOT_INITIATED

	///What stage of hijack are we currently on
	var/hijack_status = HIJACK_OBJECTIVES_NOT_STARTED

	///Whether or not evacuation has been disabled by admins
	var/evac_admin_denied = FALSE

	/// If TRUE, self destruct has been unlocked and is possible with a hold of reactor
	var/sd_unlocked = FALSE

	/// Admin var to manually prevent self destruct from occurring
	var/admin_sd_blocked = FALSE

	/// Maximum amount of fusion generators that can be overloaded at once for a time benefit
	var/maximum_overload_generators = 18

	/// How many generators are currently overloaded
	var/overloaded_generators = 0

	/// How long the manual self destruct will take on the high end
	var/sd_max_time = 15 MINUTES

	/// How long the manual self destruct will take on the low end
	var/sd_min_time = 5 MINUTES

	/// How much time left until SD detonates
	var/sd_time_remaining = 0

	/// Roughly what % of the SD countdown remains
	var/percent_completion_remaining = 100

	/// If the engine room has been heated, occurs at 33% SD completion
	var/engine_room_heated = FALSE

	/// If the engine room has been superheated, occurs at 66% SD completion
	var/engine_room_superheated = FALSE

	/// If the self destruct has/is detonating
	var/sd_detonated = FALSE

	/// If a generator has ever been overloaded in the past this round
	var/generator_ever_overloaded = FALSE

	/// If ARES has announced the 50% point yet for SD
	var/ares_sd_announced = FALSE

	/// At what world.time the ship is currently entered FTL
	var/in_ftl_time = INFINITY

	/// If the ship is currently transiting in FTL
	var/in_ftl = FALSE

	/// If the ship has crashed onto a ground map and the ftl_turfs are now turf/open_space
	var/crashed = FALSE

	/// The x offset for open_space turfs to ground when crashed
	var/crashed_offset_x = 0

	/// The y offset for open_space turfs to ground when crashed
	var/crashed_offset_y = 0

	/// The x origin for the mainship map
	var/ship_origin_x = 0

	/// The y origin for the mainship map
	var/ship_origin_y = 0

	/// Where the ship is currently transiting to
	var/datum/spaceport/spaceport

	/// A list of turfs to edit to FTL-ness
	var/list/ftl_turfs = list()

	var/list/obj/structure/machinery/fuelpump/fuelpumps = list()

/datum/controller/subsystem/hijack/Initialize(timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_GENERATOR_SET_OVERLOADING, PROC_REF(on_generator_overload))

	var/spaceport_to_use = pick(subtypesof(/datum/spaceport))
	spaceport = new spaceport_to_use

	return SS_INIT_SUCCESS

/datum/controller/subsystem/hijack/stat_entry(msg)
	if(!SSticker?.mode?.is_in_endgame)
		msg = " Not Hijack"
		return ..()

	if(current_progress >= required_progress)
		msg = " Complete"
		return ..()

	msg = " Progress: [current_progress]% | Last run: [last_run_progress_change]"
	return ..()

/datum/controller/subsystem/hijack/fire(resumed = FALSE)
	if(!SSticker?.mode?.is_in_endgame)
		return

	if(hijack_status < HIJACK_OBJECTIVES_STARTED)
		hijack_status = HIJACK_OBJECTIVES_STARTED
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_FUEL_PUMP_UPDATE)

	if(hijack_status == HIJACK_OBJECTIVES_DOCKED)
		if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_POSTHIJACK_ERT))
			return

		var/to_spawn = pick(spaceport.allies)
		var/datum/emergency_call/emergency_call = new to_spawn
		if(!emergency_call)
			return

		emergency_call.name_of_spawn = /obj/effect/landmark/ert_spawns/umbilical
		emergency_call.activate(TRUE, FALSE)

		TIMER_COOLDOWN_START(src, COOLDOWN_POSTHIJACK_ERT, 5 MINUTES)
		return

	if(hijack_status == HIJACK_OBJECTIVES_FTL_CRASH || hijack_status == HIJACK_OBJECTIVES_GROUND_CRASH)
		if(sd_unlocked && overloaded_generators)
			sd_time_remaining -= wait
			if(!engine_room_heated && (sd_time_remaining <= (max((1 - round(overloaded_generators / maximum_overload_generators, 0.01)) * sd_max_time, sd_min_time) * 0.66)))
				heat_engine_room()

			if(!ares_sd_announced && (sd_time_remaining <= (max((1 - round(overloaded_generators / maximum_overload_generators, 0.01)) * sd_max_time, sd_min_time) * 0.5)))
				announce_sd_halfway()

			if(!engine_room_superheated && (sd_time_remaining <= (max((1 - round(overloaded_generators / maximum_overload_generators, 0.01)) * sd_max_time, sd_min_time) * 0.33)))
				superheat_engine_room()

			if((sd_time_remaining <= 0) && !sd_detonated)
				detonate_sd()
		return

	if(current_progress >= required_progress)
		if(hijack_status <= HIJACK_OBJECTIVES_STARTED)
			hijack_status = HIJACK_OBJECTIVES_COMPLETE
			leave_ftl()
			addtimer(CALLBACK(src, PROC_REF(initiate_docking_procedures)), 10 SECONDS)
		return

	if(!SSticker.mode.count_marines(SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)))
		shipwide_ai_announcement("No USCM life signs detected on board. [in_ftl ? "Maintaining course to [spaceport.name]." : "Deactivating hyperdrive charge cycle."]")
		can_fire = FALSE
		return

	if(!resumed)
		current_run = progress_areas.Copy()
		if(in_ftl && world.time - in_ftl_time >= 30 SECONDS)
			current_run_mobs = GLOB.mob_list.Copy()

	for(var/area/almayer/cycled_area as anything in current_run)
		current_run -= cycled_area

		if(progress_areas[cycled_area] != cycled_area.power_equip)
			progress_areas[cycled_area] = !progress_areas[cycled_area]
			announce_area_power_change(cycled_area)

		if(progress_areas[cycled_area])
			switch(cycled_area.hijack_evacuation_type)
				if(EVACUATION_TYPE_ADDITIVE)
					current_run_progress_additive += cycled_area.hijack_evacuation_weight
				if(EVACUATION_TYPE_MULTIPLICATIVE)
					current_run_progress_multiplicative *= cycled_area.hijack_evacuation_weight

		if(MC_TICK_CHECK)
			return

	if(in_ftl)
		// Scalar between 30s and 5min for 1-25% chance of a hallucination
		var/duration_clamped = clamp(world.time - in_ftl_time, 30 SECONDS, 5 MINUTES)
		var/chance_haullucinate = SCALE(duration_clamped, 1, 25)
		var/list/ship_zs = SSmapping.levels_by_trait(ZTRAITS_MAIN_SHIP)
		for(var/mob/living/carbon/human/current_mob as anything in current_run_mobs)
			current_run_mobs -= current_mob

			if(!current_mob || current_mob.stat == DEAD)
				continue
			var/turf/mob_turf = get_turf(current_mob)
			if(!mob_turf || !(mob_turf.z in ship_zs))
				continue
			if(istype(current_mob.loc, /obj/structure/machinery/cryopod))
				continue
			if(!ishuman_strict(current_mob))
				continue

			if(prob(chance_haullucinate))
				current_mob.process_hallucination()

			if(MC_TICK_CHECK)
				return

	last_run_progress_change = current_run_progress_additive * current_run_progress_multiplicative
	current_progress += last_run_progress_change

	if(last_run_progress_change)
		estimated_time_left = ((required_progress - current_progress) / last_run_progress_change) * wait
	else
		estimated_time_left = INFINITY
		if(in_ftl)
			initiate_ftl_crash()
		else
			initiate_ground_crash()
		return

	if(current_progress >= announce_checkpoint)
		announce_progress()
		announce_checkpoint += initial(announce_checkpoint)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_FUEL_PUMP_UPDATE)

	if(current_progress >= ftl_required_progress && !in_ftl)
		charge_ftl()

	current_run_progress_additive = 0
	current_run_progress_multiplicative = 1

///Called when the dropship has been called by the xenos
/datum/controller/subsystem/hijack/proc/call_shuttle()
	hijack_status = HIJACK_OBJECTIVES_SHIP_INBOUND

///Called when the xeno dropship crashes into the Almayer and announces the current status of various objectives to marines
/datum/controller/subsystem/hijack/proc/announce_status_on_crash()
	var/message = ""

	for(var/area/cycled_area as anything in progress_areas)
		message += "[cycled_area] - [cycled_area.power_equip ? "Online" : "Offline"]\n"
		progress_areas[cycled_area] = cycled_area.power_equip

	message += "\nCritical damage sustained to ship systems. Altitude rapidly decreasing. Initiating sublight burn to exit AO.\nMaintain fueling functionality to initiate quantum jump to [spaceport.name]."

	marine_announcement(message, HIJACK_ANNOUNCE)

///Called when an area power status is changed to announce that it has been changed
/datum/controller/subsystem/hijack/proc/announce_area_power_change(area/changed_area)
	var/message = "[changed_area] - [changed_area.power_equip ? "Online" : "Offline"]"

	shipwide_ai_announcement(message, HIJACK_ANNOUNCE, sound('sound/misc/notice2.ogg'))

///Called to announce to xenos the state of evacuation progression
/datum/controller/subsystem/hijack/proc/announce_progress()
	var/announce = announce_checkpoint / initial(announce_checkpoint)

	var/marine_warning_areas = ""
	var/xeno_warning_areas = ""

	for(var/area/cycled_area as anything in progress_areas)
		if(cycled_area.power_equip)
			xeno_warning_areas += "[cycled_area], "
			continue
		marine_warning_areas += "[cycled_area], "

	if(xeno_warning_areas)
		xeno_warning_areas = copytext(xeno_warning_areas, 1, -2)

	if(marine_warning_areas)
		marine_warning_areas = copytext(marine_warning_areas, 1, -2)

	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(!length(hive.totalXenos))
			continue

		switch(announce)
			if(1)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls are a quarter of the way towards their goals. Disable the following areas: [xeno_warning_areas]"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)
			if(2)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls are half way towards their goals. Disable the following areas: [xeno_warning_areas]"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)
			if(3)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls are three quarters of the way towards their goals. Disable the following areas: [xeno_warning_areas]"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)
			if(4)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls have completed their goals!"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)

	switch(announce)
		if(1)
			marine_announcement("Emergency fuel replenishment is at 50%. Tachyon field accelerators currently charging.[marine_warning_areas ? "\nTo increase speed, restore power to the following areas: [marine_warning_areas]" : " All fueling areas operational."]", HIJACK_ANNOUNCE)
		if(2)
			marine_announcement("Emergency fuel replenishment is at 100%. Tachyon field accelerators fully charged, quantum jump initiating. Ensure constant supply of fuel to the tachyon field accelerators.[marine_warning_areas ? "\nTo increase speed, restore power to the following areas: [marine_warning_areas]" : " All fueling areas operational."]", HIJACK_ANNOUNCE)
		if(3)
			shipwide_ai_announcement("Tachyon quantum jump progress at 50 percent. Ensure constant supply of fuel to the tachyon field accelerators.[marine_warning_areas ? "\nTo increase speed, restore power to the following areas: [marine_warning_areas]" : " All fueling areas operational."]", HIJACK_ANNOUNCE, sound('sound/misc/notice2.ogg'))
		if(4)
			shipwide_ai_announcement("Tachyon quantum jump complete. Initiating docking procedures with [spaceport.name].", HIJACK_ANNOUNCE, sound('sound/misc/notice2.ogg'))

/// Passes the ETA for status panels
/datum/controller/subsystem/hijack/proc/get_evac_eta()
	switch(hijack_status)
		if(HIJACK_OBJECTIVES_STARTED)
			if(estimated_time_left == INFINITY)
				return "Never"
			return "[duration2text_sec(estimated_time_left)]"

		if(HIJACK_OBJECTIVES_COMPLETE)
			return "Complete"

/// Passes the SD ETA for status panels
/datum/controller/subsystem/hijack/proc/get_sd_eta()
	if(sd_detonated)
		return "Complete"

	if(overloaded_generators <= 0)
		return "Never"

	return "[duration2text_sec(sd_time_remaining)]"

//~~~~~~~~~~~~~~~~~~~~~~~~ EVAC STUFF ~~~~~~~~~~~~~~~~~~~~~~~~//

/// Initiates evacuation by announcing and then prepping all lifepods/lifeboats
/datum/controller/subsystem/hijack/proc/initiate_evacuation()
	if(evac_status == EVACUATION_STATUS_INITIATED || (evac_admin_denied & FLAGS_EVACUATION_DENY))
		return FALSE
	if(in_ftl || hijack_status == HIJACK_OBJECTIVES_GROUND_CRASH || hijack_status == HIJACK_OBJECTIVES_FTL_CRASH)
		return FALSE

	evac_status = EVACUATION_STATUS_INITIATED
	ai_announcement("Attention. Emergency. All personnel must evacuate immediately.", 'sound/AI/evacuate.ogg')

	for(var/obj/structure/machinery/status_display/cycled_status_display in GLOB.machines)
		if(is_mainship_level(cycled_status_display.z))
			cycled_status_display.set_picture("evac")
	for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
		shuttle.prepare_evac()
	activate_lifeboats()
	return TRUE

/// Cancels evacuation, tells lifepods/lifeboats and status_displays
/datum/controller/subsystem/hijack/proc/cancel_evacuation(silent = FALSE)
	if(evac_status == EVACUATION_STATUS_NOT_INITIATED)
		return FALSE

	evac_status = EVACUATION_STATUS_NOT_INITIATED
	deactivate_lifeboats()
	if(!silent)
		ai_announcement("Evacuation has been cancelled.", 'sound/AI/evacuate_cancelled.ogg')

	for(var/obj/structure/machinery/status_display/cycled_status_display in GLOB.machines)
		if(is_mainship_level(cycled_status_display.z))
			cycled_status_display.set_sec_level_picture()

	for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
		shuttle.cancel_evac()
	return TRUE

/// Opens the lifeboat doors and gets them ready to launch
/datum/controller/subsystem/hijack/proc/activate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_ACTIVE
			lifeboat_dock.open_dock()

/// Turns off ability to manually take off lifeboats
/datum/controller/subsystem/hijack/proc/deactivate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_INACTIVE

//~~~~~~~~~~~~~~~~~~~~~~~~ SD STUFF ~~~~~~~~~~~~~~~~~~~~~~~~//

/// After a crash, marines can optionally hold SD for a time for a stalemate instead of a xeno minor
/datum/controller/subsystem/hijack/proc/unlock_self_destruct(from_ftl = FALSE)
	sd_time_remaining = sd_max_time
	sd_unlocked = TRUE
	shipwide_ai_announcement("[from_ftl ? "Hyperdrive tachyon shunt no longer operable. " : ""]Remaining fuel transferred to on board fusion generators to permit scuttling.", HIJACK_ANNOUNCE, sound('sound/misc/notice2.ogg'))

/// Signal handler for COMSIG_GLOB_GENERATOR_SET_OVERLOADING
/datum/controller/subsystem/hijack/proc/on_generator_overload(obj/structure/machinery/power/power_generator/reactor/source, new_overloading)
	SIGNAL_HANDLER

	if(!generator_ever_overloaded)
		generator_ever_overloaded = TRUE
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				continue

			xeno_announcement(SPAN_XENOANNOUNCE("The talls may be attempting to take their ship down with them in Engineering, stop them!"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)

	adjust_generator_overload_count(new_overloading ? 1 : -1)

/datum/controller/subsystem/hijack/proc/adjust_generator_overload_count(amount = 1)
	var/generator_overload_percent = round(overloaded_generators / maximum_overload_generators, 0.01)
	var/old_required_time = sd_min_time + ((1 - generator_overload_percent) * (sd_max_time - sd_min_time))
	percent_completion_remaining = sd_time_remaining / old_required_time
	overloaded_generators = clamp(overloaded_generators + amount, 0, maximum_overload_generators)
	generator_overload_percent = round(overloaded_generators / maximum_overload_generators, 0.01)
	var/new_required_time = sd_min_time + ((1 - generator_overload_percent) * (sd_max_time - sd_min_time))
	sd_time_remaining = percent_completion_remaining * new_required_time

/datum/controller/subsystem/hijack/proc/heat_engine_room()
	engine_room_heated = TRUE
	var/area/engine_room = GLOB.areas_by_type[/area/almayer/engineering/lower/engine_core]
	engine_room.firealert()
	engine_room.temperature = T90C
	for(var/mob/current_mob as anything in GLOB.living_player_list)
		if(current_mob?.stat != CONSCIOUS)
			continue
		var/area/mob_area = get_area(current_mob)
		if(istype(mob_area, /area/almayer/engineering/lower/engine_core))
			to_chat(current_mob, SPAN_BOLDWARNING("You feel the heat of the room increase as the fusion engines whirr louder."))

/datum/controller/subsystem/hijack/proc/superheat_engine_room()
	engine_room_superheated = TRUE
	var/area/engine_room = GLOB.areas_by_type[/area/almayer/engineering/lower/engine_core]
	engine_room.firealert()
	engine_room.temperature = T120C //slowly deals burn at this temp
	for(var/mob/current_mob as anything in GLOB.living_player_list)
		if(current_mob?.stat != CONSCIOUS)
			continue
		var/area/mob_area = get_area(current_mob)
		if(istype(mob_area, /area/almayer/engineering/lower/engine_core))
			to_chat(current_mob, SPAN_BOLDWARNING("The room feels incredibly hot, you can't take much more of this!"))

/datum/controller/subsystem/hijack/proc/announce_sd_halfway()
	ares_sd_announced = TRUE
	shipwide_ai_announcement("ALERT: Fusion reactor meltdown has reached fifty percent.", HIJACK_ANNOUNCE, sound('sound/misc/notice2.ogg'))

/datum/controller/subsystem/hijack/proc/detonate_sd()
	set waitfor = FALSE
	sd_detonated = TRUE
	var/creak_picked = pick('sound/effects/creak1.ogg', 'sound/effects/creak2.ogg', 'sound/effects/creak3.ogg')
	for(var/mob/current_mob as anything in GLOB.mob_list)
		var/turf/current_turf = get_turf(current_mob)
		if(!current_turf || !current_mob.client || !is_mainship_level(current_turf.z))
			continue

		to_chat(current_mob, SPAN_BOLDWARNING("The ship's deck worryingly creaks underneath you."))
		playsound_client(current_mob.client, creak_picked, vol=50)

	sleep(7 SECONDS)
	shakeship(2, 10, TRUE)

	shipwide_ai_announcement("ALERT: Fusion reactors dangerously overloaded. Runaway meltdown in reactor core imminent.", HIJACK_ANNOUNCE, sound('sound/misc/notice2.ogg'))
	sleep(5 SECONDS)

	var/sound_picked = pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')
	for(var/client/player as anything in GLOB.clients)
		playsound_client(player, sound_picked, 90)

	var/list/alive_mobs = list() //Everyone who will be destroyed on the zlevel(s).
	var/list/dead_mobs = list() //Everyone who only needs to see the cinematic.
	for(var/mob/current_mob as anything in GLOB.mob_list) //This only does something cool for the people about to die, but should prove pretty interesting.
		var/turf/current_turf = get_turf(current_mob)
		if(!current_turf)
			continue

		if(current_mob.stat == DEAD)
			dead_mobs |= current_mob
			continue

		if(is_mainship_level(current_turf.z))
			alive_mobs |= current_mob
			shake_camera(current_mob, 110, 4)


	sleep(10 SECONDS)
	/*Hardcoded for now, since this was never really used for anything else.
	Would ideally use a better system for showing cutscenes.*/
	var/atom/movable/screen/cinematic/explosion/explosive_cinematic = new()

	for(var/mob/current_mob as anything in (alive_mobs + dead_mobs))
		if(current_mob?.loc && current_mob.client)
			current_mob.client.add_to_screen(explosive_cinematic)  //They may have disconnected in the mean time.

	sleep(1.5 SECONDS) //Extra 1.5 seconds to look at the ship.
	flick("intro_nuke", explosive_cinematic)

	sleep(3.5 SECONDS)
	for(var/mob/current_mob as anything in alive_mobs)
		var/turf/current_mob_turf = get_turf(current_mob)
		if(!current_mob?.loc || !current_mob_turf) //Who knows, maybe they escaped, or don't exist anymore.
			continue

		if(is_mainship_level(current_mob_turf.z))
			if(istype(current_mob.loc, /obj/structure/closet/secure_closet/freezer/fridge))
				continue

			current_mob.death(create_cause_data("nuclear explosion"))
		else
			current_mob.client.remove_from_screen(explosive_cinematic) //those who managed to escape the z level at last second shouldn't have their view obstructed.

	flick("ship_destroyed", explosive_cinematic)
	explosive_cinematic.icon_state = "summary_destroyed"

	for(var/client/player as anything in GLOB.clients)
		playsound_client(player, 'sound/effects/explosionfar.ogg', 90)


	sleep(0.5 SECONDS)
	if(SSticker.mode)
		SSticker.mode.check_win()

	if(!SSticker.mode) //Just a safety, just in case a mode isn't running, somehow.
		to_world(SPAN_ROUNDBODY("Resetting in 30 seconds!"))
		sleep(30 SECONDS)
		log_game("Rebooting due to nuclear detonation.")
		world.Reboot()


//~~~~~~~~~~~~~~~~~~~~~~~~ GROUND CRASH STUFF ~~~~~~~~~~~~~~~~~~~~~~~~//

/// Called when pumps failed before FTL initiated to crash onto the ground map
/datum/controller/subsystem/hijack/proc/initiate_ground_crash()
	hijack_status = HIJACK_OBJECTIVES_GROUND_CRASH
	marine_announcement("Tachyon quantum jump drive deactivated due to insufficient fueling. Entry into atmosphere imminent.", HIJACK_ANNOUNCE, sound('sound/mecha/internaldmgalarm.ogg'))
	cancel_evacuation(silent=TRUE)

	if(!admin_sd_blocked)
		addtimer(CALLBACK(src, PROC_REF(unlock_self_destruct), FALSE), 35 SECONDS)

	// Figure out the main Z by assuming the LZs are on that Z
	var/obj/lz = locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1)
	if(!lz)
		lz = locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2)
	var/ground_z = lz.z

	// Figure out the bottom left of playable space with 1 extra border
	var/obj/effect/landmark/mainship_crashsite/origin_landmark = locate() in GLOB.landmarks_list
	var/turf/ground_origin = get_turf(origin_landmark)
	var/border_type = /turf/closed/wall/strata_ice/jungle
	var/cordon_type = FALSE
	if(ground_origin)
		if(istype(ground_origin, /turf/closed))
			if(istype(ground_origin, /turf/closed/cordon))
				cordon_type = /turf/closed/cordon
				var/turf/border_turf = locate(ground_origin.x + 1, ground_origin.y + 1, ground_origin.z)
				if(istype(border_turf, /turf/closed))
					border_type = border_turf.type
				ground_origin = locate(ground_origin.x + 2, ground_origin.y + 2, ground_origin.z)
			border_type = ground_origin.type
			ground_origin = locate(ground_origin.x + 1, ground_origin.y + 1, ground_origin.z)
	else
		for(var/turf/closed/current_turf in block(1, 1, ground_z, 50, 50, ground_z))
			if(istype(current_turf, /turf/closed/cordon))
				cordon_type = /turf/closed/cordon
				var/turf/border_turf = locate(current_turf.x + 1, current_turf.y + 1, current_turf.z)
				if(istype(border_turf, /turf/closed))
					border_type = border_turf.type
				ground_origin = locate(current_turf.x + 2, current_turf.y + 2, current_turf.z)
				break
			border_type = current_turf.type
			ground_origin = locate(current_turf.x + 1, current_turf.y + 1, current_turf.z)
			break

	// Explosive reentry
	if(ground_origin)
		INVOKE_ASYNC(src, PROC_REF(ground_reentry_hazard), locate(ground_origin.x + 50, ground_origin.y + 50, ground_origin.z))
		INVOKE_ASYNC(src, PROC_REF(ground_reentry_hazard), locate(ground_origin.x + 100, ground_origin.y + 50, ground_origin.z))
		INVOKE_ASYNC(src, PROC_REF(ground_reentry_hazard), locate(ground_origin.x + 150, ground_origin.y + 50, ground_origin.z))
		INVOKE_ASYNC(src, PROC_REF(ground_reentry_hazard), locate(ground_origin.x + 200, ground_origin.y + 50, ground_origin.z))
	addtimer(CALLBACK(src, PROC_REF(crash_onto_ground), ground_origin, border_type, cordon_type), 20 SECONDS)

/// Creates a warhead at the provided location for mainship reentry
/datum/controller/subsystem/hijack/proc/ground_reentry_hazard(turf/target)
	if(!target)
		return
	var/obj/structure/ob_ammo/warhead/explosive/warhead = new
	warhead.name = "mainship reentry explosion"
	warhead.clear_power = 0
	warhead.clear_falloff = 30
	warhead.standard_power = 1200
	warhead.standard_falloff = 30
	warhead.clear_delay = 0
	warhead.double_explosion_delay = 0 // No third explosion please
	warhead.warhead_impact(target) // This is a blocking call

/// Actually places the crash template onto the ground map, updates space turfs, and performs some effects
/datum/controller/subsystem/hijack/proc/crash_onto_ground(turf/ground_origin, border_type, cordon_type, template_name="USS_Almayer_crash.dmm")
	if(!ground_origin)
		CRASH("Unable to determine origin location on groundmap for hijack ground crash! Origin can be manually specified with a /obj/effect/landmark/mainship_crashsite")

	msg_admin_niche("Crashing mainship to[ADMIN_COORDJMP(ground_origin)]")

	shakeship(
		sstrength = 1,
		stime = 3,
		drop = FALSE,
	)

	// Place the crash template
	var/datum/map_template/template = SSmapping.map_templates[template_name]
	if(!template?.load(ground_origin, centered=FALSE, delete=TRUE, allow_cropping=TRUE, crop_within_type=cordon_type, crop_within_border=1, expand_type=border_type))
		stack_trace("Hijack crash template '[template_name]' failed to load!")

	// Figure out the offset for open_space turfs to peer down to ground aligned to the wreck
	var/shipmap_z = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)[1]
	var/list/ship_bounds = SSmapping.z_list[shipmap_z].bounds
	ship_origin_x = ship_bounds[MAP_MINX]
	ship_origin_y = ship_bounds[MAP_MINY]
	crashed_offset_x = -ship_origin_x + 1 - 17 // Horizontal difference between shipmap and template
	crashed_offset_y = -ship_origin_y + 1 // 0 Vertical difference between shipmap and template
	crashed_offset_x += ground_origin.x - 1
	crashed_offset_y += ground_origin.y - 1

	playsound_z(SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP), 'sound/effects/dropship_crash.ogg', volume=75)
	shakeship(
		sstrength = 2,
		stime = 3,
		drop = FALSE,
	)

	// Update shipside space turfs to open_space
	crashed = TRUE
	for(var/turf/open/space/space_turf as anything in ftl_turfs)
		set_ftl_turf_open(space_turf)
		CHECK_TICK

	shakeship(
		sstrength = 5,
		stime = 3,
		drop = TRUE,
	)


//~~~~~~~~~~~~~~~~~~~~~~~~ FTL STUFF ~~~~~~~~~~~~~~~~~~~~~~~~//

/// Toggles the state of in_ftl and updates all space turfs on the main ship levels
/datum/controller/subsystem/hijack/proc/toggle_ftl_status()
	in_ftl = !in_ftl

	if(in_ftl)
		for(var/turf/open/space/space_turf as anything in ftl_turfs)
			set_ftl_turf(space_turf)
	else
		for(var/turf/open/space/space_turf as anything in ftl_turfs)
			unset_ftl_turf(space_turf)

/// Updates a specific space turf to have the speedspace animation
/datum/controller/subsystem/hijack/proc/set_ftl_turf(turf/open/space/space_turf)
	var/which_turf = ((space_turf.x - 9 * space_turf.y) % 15) + 1
	if(which_turf < 1)
		which_turf += 15
	space_turf.icon_state = "speedspace_ew_[which_turf]"

/// Updates a specific space turf to return back to regular space
/datum/controller/subsystem/hijack/proc/unset_ftl_turf(turf/open/space/space_turf)
	space_turf.icon_state = "[((space_turf.x + space_turf.y) ^ ~(space_turf.x * space_turf.y) + space_turf.z) % 25]"

/// Updates a specific space turf to either become black or an open_space turf depending on distance to the main ship
/datum/controller/subsystem/hijack/proc/set_ftl_turf_open(turf/open/space/space_turf)
	var/adjusted_x = space_turf.x - ship_origin_x
	var/adjusted_y = space_turf.y - ship_origin_y
	if(adjusted_x < 22 || adjusted_x > 311 || adjusted_y < -13 || adjusted_y > 113) // approx 15 each direction of empty space
		// Don't bother with open_space further out
		space_turf.icon_state = "black"
		return
	space_turf.ChangeTurf(/turf/open_space/ground_level, null, null, crashed_offset_x, crashed_offset_y)

/// Called to enter FTP warp
/datum/controller/subsystem/hijack/proc/enter_ftl()
	shakeship(
		sstrength = 2,
		stime = 1,
		drop = FALSE,
		osound = FALSE
	)

	toggle_ftl_status()
	cancel_evacuation(silent=TRUE)

	in_ftl_time = world.time
	shipwide_ai_announcement("ALERT: Prolonged exposure outside hypersleep chambers during a tachyon quantum jump can be fatal. Seek hypersleep chambers if possible.", HIJACK_ANNOUNCE)

/// Called when FTL has failed
/datum/controller/subsystem/hijack/proc/initiate_ftl_crash()
	hijack_status = HIJACK_OBJECTIVES_FTL_CRASH
	shipwide_ai_announcement("Tachyon quantum jump drive deactivated due to insufficient fueling. Brace for destabilization of hyperdrive field.", HIJACK_ANNOUNCE, sound('sound/mecha/internaldmgalarm.ogg'))
	cancel_evacuation(silent=TRUE)

	addtimer(CALLBACK(src, PROC_REF(leave_ftl), TRUE), 5 SECONDS)

	if(!admin_sd_blocked)
		addtimer(CALLBACK(src, PROC_REF(unlock_self_destruct), TRUE), 30 SECONDS)

	// TODO: Planet crash?

/// Delayed call to enter_ftl with announcement
/datum/controller/subsystem/hijack/proc/charge_ftl()
	marine_announcement("Initiating quantum jump. Opening virtual mass field.", HIJACK_ANNOUNCE, sound('sound/mecha/powerup.ogg'))
	addtimer(CALLBACK(src, PROC_REF(enter_ftl)), 5 SECONDS)

/// Called to leave FTL warp potentionally unintentionally with more destructive effects
/datum/controller/subsystem/hijack/proc/leave_ftl(unintentionally = FALSE)
	toggle_ftl_status()
	current_run_mobs.Cut()

	if(!unintentionally)
		shakeship(
			sstrength = 2,
			stime = 1,
			drop = FALSE,
			osound = FALSE
		)
		return

	shakeship(
		sstrength = 5,
		stime = 3,
		drop = TRUE,
	)

	for(var/mob/mob as anything in GLOB.player_list)
		if(!is_mainship_level(mob.z))
			continue
		playsound_client(mob.client, get_sfx("bigboom"))

	shipwide_ai_announcement("ALERT: Build up detected within pumping systems. Overload in 10 seconds.", HIJACK_ANNOUNCE)
	addtimer(CALLBACK(src, PROC_REF(explode_pumps)), 10 SECONDS)

/// Called when performing leave_ftl unintentionally to explode the fuel pumps
/datum/controller/subsystem/hijack/proc/explode_pumps()
	var/datum/space_weapon_ammo/rocket_launcher/swing_rockets/rockets = new
	for(var/obj/structure/machinery/fuelpump/pump as anything in fuelpumps)
		rockets.hit_target(get_turf(pump), shake=FALSE)

/// Called when FTL is completed successfully to load in shuttles
/datum/controller/subsystem/hijack/proc/initiate_docking_procedures()
	hijack_status = HIJACK_OBJECTIVES_DOCKED
	shipwide_ai_announcement(spaceport.docking_message, spaceport.name, sound('sound/misc/notice2.ogg'))

	var/obj/docking_port/stationary/dock_at = pick(/obj/docking_port/stationary/emergency_response/external/hangar_port, /obj/docking_port/stationary/emergency_response/external/hangar_starboard)
	var/stationary = SSshuttle.getDock(dock_at::id)
	var/datum/map_template/shuttle

	switch(dock_at)
		if(/obj/docking_port/stationary/emergency_response/external/hangar_port)
			shuttle = SSmapping.shuttle_templates[/datum/map_template/shuttle/port_umbilical_cord::shuttle_id]
		if(/obj/docking_port/stationary/emergency_response/external/hangar_starboard)
			shuttle = SSmapping.shuttle_templates[/datum/map_template/shuttle/starboard_umbilical_cord::shuttle_id]

	if(!shuttle || !stationary)
		return

	SSshuttle.action_load(shuttle, stationary)

/obj/docking_port/mobile/port_umbilical_cord
	name = "Port Umbilical Cord"
	id = "port_umbilical_cord"
	preferred_direction = WEST

/obj/docking_port/mobile/starboard_umbilical_cord
	name = "Starboard Umbilical Cord"
	id = "starboard_umbilical_cord"
	preferred_direction = WEST

/obj/effect/landmark/ert_spawns/umbilical
