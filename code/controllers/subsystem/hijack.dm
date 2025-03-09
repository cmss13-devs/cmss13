SUBSYSTEM_DEF(hijack)
	name   = "Hijack"
	wait   = 2 SECONDS
	flags  = SS_KEEP_TIMING
	priority   = SS_PRIORITY_HIJACK
	init_order = SS_INIT_HIJACK

	///Required progress to evacuate safely via lifeboats
	var/required_progress = 100

	///Current progress towards evacuating safely via lifeboats
	var/current_progress = 0

	/// How much progress is required to early launch
	var/early_launch_required_progress = 25

	///The estimated time left to get to the safe evacuation point
	var/estimated_time_left = 0

	///Areas that are marked as having progress, assoc list that is progress_area = boolean, the boolean indicating if it was progressing or not on the last fire()
	var/list/area/progress_areas = list()

	///The areas that need cycled through currently
	var/list/area/current_run = list()

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

/datum/controller/subsystem/hijack/Initialize(timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_GENERATOR_SET_OVERLOADING, PROC_REF(on_generator_overload))
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

	if(current_progress >= required_progress)
		if(hijack_status < HIJACK_OBJECTIVES_COMPLETE)
			hijack_status = HIJACK_OBJECTIVES_COMPLETE

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

	if(!resumed)
		current_run = progress_areas.Copy()

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

		if (MC_TICK_CHECK)
			return

	last_run_progress_change = current_run_progress_additive * current_run_progress_multiplicative
	current_progress += last_run_progress_change

	if(last_run_progress_change)
		estimated_time_left = ((required_progress - current_progress) / last_run_progress_change) * wait
	else
		estimated_time_left = INFINITY

	if(current_progress >= announce_checkpoint)
		announce_progress()
		announce_checkpoint += initial(announce_checkpoint)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_FUEL_PUMP_UPDATE)

	current_run_progress_additive = 0
	current_run_progress_multiplicative = 1

///Called when the xeno dropship crashes into the Almayer and announces the current status of various objectives to marines
/datum/controller/subsystem/hijack/proc/announce_status_on_crash()
	var/message = ""

	for(var/area/cycled_area as anything in progress_areas)
		message += "[cycled_area] - [cycled_area.power_equip ? "Online" : "Offline"]\n"
		progress_areas[cycled_area] = cycled_area.power_equip

	message += "\nDue to low orbit, extra fuel is required for non-surface evacuations.\nMaintain fueling functionality for optimal evacuation conditions."

	marine_announcement(message, HIJACK_ANNOUNCE)

///Called when an area power status is changed to announce that it has been changed
/datum/controller/subsystem/hijack/proc/announce_area_power_change(area/changed_area)
	var/message = "[changed_area] - [changed_area.power_equip ? "Online" : "Offline"]"

	marine_announcement(message, HIJACK_ANNOUNCE)

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
			marine_announcement("Emergency fuel replenishment is at 25 percent. Lifeboat early launch is now available. Recommendation: wait for 100% fuel for safety purposes.[marine_warning_areas ? "\nTo increase speed, restore power to the following areas: [marine_warning_areas]" : " All fueling areas operational."]", HIJACK_ANNOUNCE)
		if(2)
			marine_announcement("Emergency fuel replenishment is at 50 percent.[marine_warning_areas ? "\nTo increase speed, restore power to the following areas: [marine_warning_areas]" : " All fueling areas operational."]", HIJACK_ANNOUNCE)
		if(3)
			marine_announcement("Emergency fuel replenishment is at 75 percent.[marine_warning_areas ? "\nTo increase speed, restore power to the following areas: [marine_warning_areas]" : " All fueling areas operational."]", HIJACK_ANNOUNCE)
		if(4)
			marine_announcement("Emergency fuel replenishment is at 100 percent. Safe utilization of lifeboats and pods is now possible.", HIJACK_ANNOUNCE)
			if(!admin_sd_blocked)
				addtimer(CALLBACK(src, PROC_REF(unlock_self_destruct)), 8 SECONDS)

/// Passes the ETA for status panels
/datum/controller/subsystem/hijack/proc/get_evac_eta()
	switch(hijack_status)
		if(HIJACK_OBJECTIVES_STARTED)
			if(estimated_time_left == INFINITY)
				return "Never"
			return "[duration2text_sec(estimated_time_left)]"

		if(HIJACK_OBJECTIVES_COMPLETE)
			return "Complete"

/datum/controller/subsystem/hijack/proc/get_sd_eta()
	if(sd_detonated)
		return "Complete"

	if(overloaded_generators <= 0)
		return "Never"

	return "[duration2text_sec(sd_time_remaining)]"

//~~~~~~~~~~~~~~~~~~~~~~~~ EVAC STUFF ~~~~~~~~~~~~~~~~~~~~~~~~//

/// Initiates evacuation by announcing and then prepping all lifepods/lifeboats
/datum/controller/subsystem/hijack/proc/initiate_evacuation()
	if(evac_status == EVACUATION_STATUS_NOT_INITIATED && !(evac_admin_denied & FLAGS_EVACUATION_DENY))
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
/datum/controller/subsystem/hijack/proc/cancel_evacuation()
	if(evac_status == EVACUATION_STATUS_INITIATED)
		evac_status = EVACUATION_STATUS_NOT_INITIATED
		deactivate_lifeboats()
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


/// Once refueling is done, marines can optionally hold SD for a time for a stalemate instead of a xeno minor
/datum/controller/subsystem/hijack/proc/unlock_self_destruct()
	sd_time_remaining = sd_max_time
	sd_unlocked = TRUE
	marine_announcement("Fuel reserves full. Manual detonation of fuel reserves by overloading the on-board fusion reactors now possible.", HIJACK_ANNOUNCE)

/datum/controller/subsystem/hijack/proc/on_generator_overload(obj/structure/machinery/power/reactor/source, new_overloading)
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
	for(var/mob/current_mob as anything in GLOB.mob_list)
		var/area/mob_area = get_area(current_mob)
		if(istype(mob_area, /area/almayer/engineering/lower/engine_core))
			to_chat(current_mob, SPAN_BOLDWARNING("You feel the heat of the room increase as the fusion engines whirr louder."))

/datum/controller/subsystem/hijack/proc/superheat_engine_room()
	engine_room_superheated = TRUE
	var/area/engine_room = GLOB.areas_by_type[/area/almayer/engineering/lower/engine_core]
	engine_room.firealert()
	engine_room.temperature = T120C //slowly deals burn at this temp
	for(var/mob/current_mob as anything in GLOB.mob_list)
		var/area/mob_area = get_area(current_mob)
		if(istype(mob_area, /area/almayer/engineering/lower/engine_core))
			to_chat(current_mob, SPAN_BOLDWARNING("The room feels incredibly hot, you can't take much more of this!"))

/datum/controller/subsystem/hijack/proc/announce_sd_halfway()
	ares_sd_announced = TRUE
	marine_announcement("ALERT: Fusion reactor meltdown has reached fifty percent.", HIJACK_ANNOUNCE)

/datum/controller/subsystem/hijack/proc/detonate_sd()
	set waitfor = FALSE
	sd_detonated = TRUE
	var/creak_picked = pick('sound/effects/creak1.ogg', 'sound/effects/creak2.ogg', 'sound/effects/creak3.ogg')
	for(var/mob/current_mob as anything in GLOB.mob_list)
		var/turf/current_turf = get_turf(current_mob)
		if(!current_mob?.loc || !current_mob.client || !current_turf || !is_mainship_level(current_turf.z))
			continue

		to_chat(current_mob, SPAN_BOLDWARNING("The ship's deck worryingly creaks underneath you."))
		playsound_client(current_mob.client, creak_picked, vol = 50)

	sleep(7 SECONDS)
	shakeship(2, 10, TRUE)

	marine_announcement("ALERT: Fusion reactors dangerously overloaded. Runaway meltdown in reactor core imminent.", HIJACK_ANNOUNCE)
	sleep(5 SECONDS)

	var/sound_picked = pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')
	for(var/client/player as anything in GLOB.clients)
		playsound_client(player, sound_picked, 90)

	var/list/alive_mobs = list() //Everyone who will be destroyed on the zlevel(s).
	var/list/dead_mobs = list() //Everyone who only needs to see the cinematic.
	for(var/mob/current_mob as anything in GLOB.mob_list) //This only does something cool for the people about to die, but should prove pretty interesting.
		var/turf/current_turf = get_turf(current_mob)
		if(!current_mob?.loc || !current_turf)
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
