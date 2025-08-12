/datum/cas_fire_envelope
	var/obj/structure/machinery/computer/dropship_weapons/linked_console
	var/list/datum/cas_fire_mission/missions
	var/fire_length
	var/base_fire_length // Base fire length before equipment bonuses
	var/grace_period //how much time you have after initiating fire mission and before you can't change firemissions
	var/first_warning
	var/second_warning
	var/third_warning
	var/execution_start
	var/flyoff_period //how much time it takes after shots fired to get off the map. CAS is vulnerable here
	var/cooldown_period //how much time you have to wait before new Fire Mission run
	var/soundeffect //what sound effect to play
	var/step_delay
	var/max_offset

	var/mission_error

	var/stat = FIRE_MISSION_STATE_IDLE

	var/recorded_dir = NORTH
	var/recorded_offset = 0
	var/datum/cas_signal/recorded_loc = null

	var/obj/effect/firemission_guidance/guidance
	var/atom/tracked_object

	var/antiair_fx_played = FALSE

	var/shuttle_shake_played = FALSE // Track if shuttle shake effect has played this firemission

	var/xeno_announcement_played = FALSE // Track if xeno announcement has played this firemission

	/// Stores saved firemission configurations by equipment attach_id for restoration after uninstall/reinstall
	var/list/saved_equipment_configs = list()

/datum/cas_fire_envelope/New()
	..()
	missions = list()

/datum/cas_fire_envelope/Destroy(force, ...)
	linked_console = null
	untrack_object()
	return ..()

/datum/cas_fire_envelope/ui_data(mob/user)
	. = list()
	.["missions"] = list()
	for(var/datum/cas_fire_mission/mission in missions)
		.["missions"] += list(mission.ui_data(user))

/datum/cas_fire_envelope/proc/update_weapons(list/obj/structure/dropship_equipment/weapon/weapons)
	// Exclude heavygun/bay from firemission weapons unless this is a belly_gun console
	var/is_belly_gun_console = istype(linked_console, /obj/structure/machinery/computer/dropship_weapons/belly_gun)
	var/list/obj/structure/dropship_equipment/weapon/filtered_weapons = list()
	for(var/obj/structure/dropship_equipment/weapon/weapon in weapons)
		if(istype(weapon, /obj/structure/dropship_equipment/weapon/heavygun/bay) && !is_belly_gun_console)
			continue
		filtered_weapons += weapon

	// Save configurations for equipment that's being removed
	save_equipment_configs(filtered_weapons)

	for(var/datum/cas_fire_mission/mission in missions)
		mission.update_weapons(filtered_weapons, fire_length, saved_equipment_configs)

/// Save firemission configurations for equipment that's about to be removed
/datum/cas_fire_envelope/proc/save_equipment_configs(list/obj/structure/dropship_equipment/weapon/current_weapons)
	// Create a set of current weapon attach_ids for quick lookup
	var/list/current_attach_ids = list()
	for(var/obj/structure/dropship_equipment/weapon/weapon in current_weapons)
		if(weapon?.ship_base?.attach_id)
			current_attach_ids += weapon.ship_base.attach_id

	// For each mission, save configs of equipment that's being removed
	for(var/datum/cas_fire_mission/mission in missions)
		for(var/datum/cas_fire_mission_record/record in mission.records)
			if(!record.weapon?.ship_base?.attach_id)
				continue
			var/attach_id = record.weapon.ship_base.attach_id
			// If this equipment is no longer in current weapons, it's being removed
			if(!(attach_id in current_attach_ids))
				if(!saved_equipment_configs[mission.name])
					saved_equipment_configs[mission.name] = list()
				// Create config key that includes weapon type, attach_id and ammo type
				var/weapon_type = record.weapon.type
				var/ammo_name = record.weapon?.ammo_equipped?.name || "No Ammo"
				var/config_key = "[weapon_type]_[attach_id]_[ammo_name]"
				// Save the offsets configuration for this combination
				saved_equipment_configs[mission.name][config_key] = record.offsets.Copy()

				// Also save a fallback configuration under weapon type and attach_id
				var/fallback_key = "[weapon_type]_[attach_id]_FALLBACK"
				saved_equipment_configs[mission.name][fallback_key] = record.offsets.Copy()

/// Save configuration
/datum/cas_fire_envelope/proc/save_equipment_config(datum/cas_fire_mission/mission, obj/structure/dropship_equipment/weapon/weapon)
	if(!mission || !weapon?.ship_base?.attach_id)
		return

	var/attach_id = weapon.ship_base.attach_id
	var/datum/cas_fire_mission_record/record = mission.record_for_weapon(attach_id)
	if(!record)
		return

	if(!saved_equipment_configs[mission.name])
		saved_equipment_configs[mission.name] = list()

	// Create config key that includes weapon type, attach_id and ammo type
	var/weapon_type = weapon.type
	var/ammo_name = weapon?.ammo_equipped?.name || "No Ammo"
	var/config_key = "[weapon_type]_[attach_id]_[ammo_name]"

	// Save the current offsets configuration
	saved_equipment_configs[mission.name][config_key] = record.offsets.Copy()

	// Also save a fallback configuration under weapon type and attach_id
	var/fallback_key = "[weapon_type]_[attach_id]_FALLBACK"
	saved_equipment_configs[mission.name][fallback_key] = record.offsets.Copy()

/datum/cas_fire_envelope/proc/generate_mission(firemission_name, length)
	if(!missions || !linked_console)
		return null
	var/list/obj/structure/dropship_equipment/weapons = list()
	var/shuttle_tag = linked_console.shuttle_tag
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)

	// Update fire_length based on equipment
	update_fire_length()

	// Exclude heavygun/bay from firemission weapons unless this is a belly_gun console
	var/is_belly_gun_console = istype(linked_console, /obj/structure/machinery/computer/dropship_weapons/belly_gun)
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if(equipment.is_weapon)
			if(istype(equipment, /obj/structure/dropship_equipment/weapon/heavygun/bay) && !is_belly_gun_console)
				continue
			weapons += equipment

	var/datum/cas_fire_mission/fm = new()
	for(var/obj/structure/dropship_equipment/weapon/wp in weapons)
		fm.build_new_record(wp, fire_length, saved_equipment_configs)

	fm.name = firemission_name
	fm.mission_length = length
	missions += fm
	return fm

	//-1 - system error, 0 - mission error, 1 - all good
/datum/cas_fire_envelope/proc/update_mission(mission_id, weapon_id, offset_step, offset, skip_checks = 0)
	mission_error = null
	if(stat > FIRE_MISSION_STATE_IN_TRANSIT && stat < FIRE_MISSION_STATE_COOLDOWN)
		mission_error = "Fire Mission is under way already."
		return FIRE_MISSION_NOT_EXECUTABLE
	if(!missions[mission_id])
		return FIRE_MISSION_NOT_EXECUTABLE
	var/datum/cas_fire_mission/mission = missions[mission_id]
	if(!mission)
		return FIRE_MISSION_NOT_EXECUTABLE

	// Update fire_length and check if mission exceeds current capability
	update_fire_length()
	if(mission.mission_length > fire_length)
		mission_error = "Fire Mission length ([mission.mission_length]) exceeds current vehicle capability ([fire_length]). Check equipment configuration."
		return FIRE_MISSION_NOT_EXECUTABLE

	var/datum/cas_fire_mission_record/fmr = mission.record_for_weapon(weapon_id)
	if(!fmr)
		return FIRE_MISSION_NOT_EXECUTABLE
	if(!fmr.offsets || isnull(fmr.offsets[offset_step]))
		return FIRE_MISSION_NOT_EXECUTABLE
	var/old_offset = fmr.offsets[offset_step]
	if(offset == null)
		offset = "-"
	fmr.offsets[offset_step] = offset

	save_equipment_config(mission, fmr.weapon)

	var/check_result = mission.check(linked_console)
	if(check_result == FIRE_MISSION_CODE_ERROR)
		return FIRE_MISSION_NOT_EXECUTABLE
	if(check_result == FIRE_MISSION_ALL_GOOD)
		return FIRE_MISSION_ALL_GOOD
	if(check_result == FIRE_MISSION_WEAPON_OUT_OF_AMMO)
		return FIRE_MISSION_ALL_GOOD

	mission_error = mission.error_message(check_result)
	if(skip_checks)
		return FIRE_MISSION_ALL_GOOD

	//we have mission error. Fill the thing and restore previous state
	fmr.offsets[offset_step] = old_offset

	return FIRE_MISSION_ALL_GOOD

/datum/cas_fire_envelope/proc/execute_firemission(datum/cas_signal/signal, target_turf,dir, mission_id)
	if(stat != FIRE_MISSION_STATE_IDLE)
		mission_error = "Fire Mission is under way already."
		return FIRE_MISSION_NOT_EXECUTABLE
	if(!missions[mission_id])
		return FIRE_MISSION_NOT_EXECUTABLE
	if(dir!=NORTH && dir!=SOUTH && dir!=WEST && dir!=EAST)
		mission_error = "Incorrect direction."
		return FIRE_MISSION_BAD_DIRECTION
	mission_error = null
	var/datum/cas_fire_mission/mission = missions[mission_id]

	// Update fire_length and check if mission exceeds current capability
	update_fire_length()
	if(mission.mission_length > fire_length)
		mission_error = "Fire Mission length ([mission.mission_length]) exceeds current vehicle capability ([fire_length]). Check equipment configuration."
		return FIRE_MISSION_CODE_ERROR

	var/check_result = mission.check(linked_console)
	if(check_result == FIRE_MISSION_CODE_ERROR)
		return FIRE_MISSION_CODE_ERROR

	if(check_result != FIRE_MISSION_ALL_GOOD)
		mission_error = mission.error_message(check_result)
		return FIRE_MISSION_CODE_ERROR

	//actual firemission code
	execute_firemission_unsafe(signal, target_turf, dir, mission)
	return FIRE_MISSION_ALL_GOOD

/datum/cas_fire_envelope/proc/firemission_status_message()
	switch(stat)
		if(null)
			return "Unknown Status"
		if(FIRE_MISSION_STATE_IDLE)
			return "Idle"
		if(FIRE_MISSION_STATE_IN_TRANSIT)
			return "In Transit"
		if(FIRE_MISSION_STATE_ON_TARGET)
			return "On Target"
		if(FIRE_MISSION_STATE_FIRING)
			return "Firing"
		if(FIRE_MISSION_STATE_OFF_TARGET)
			return "Off Target"
		if(FIRE_MISSION_STATE_COOLDOWN)
			return "Returning to Sub-Orbital"

/datum/cas_fire_envelope/proc/change_target_loc(datum/cas_signal/marker)
	if(!marker)
		recorded_loc = null
		return TRUE
	var/turf/TU = get_turf(marker.signal_loc)
	if(!istype(TU))
		mission_error = "Can't find target."
		return FALSE
	recorded_loc = marker
	return TRUE

/datum/cas_fire_envelope/proc/change_current_loc(location, atom/object)
	if(object)
		untrack_object()
	if(!location && guidance)
		for(var/mob/M in guidance.users)
			if(istype(M) && M.client)
				M.reset_view()
		qdel(guidance)
		return
	if(!guidance)
		guidance = new /obj/effect/firemission_guidance()
	guidance.forceMove(location)
	guidance.updateCameras(linked_console)
	if(object)
		tracked_object = object
		RegisterSignal(tracked_object, COMSIG_PARENT_QDELETING, PROC_REF(on_tracked_object_del))

/// Call to unregister the on_tracked_object_del behavior
/datum/cas_fire_envelope/proc/untrack_object()
	if(tracked_object)
		UnregisterSignal(tracked_object, COMSIG_PARENT_QDELETING)
		tracked_object = null

/// Signal handler for when we are viewing a object in cam is qdel'd (but camera actually is actually some other obj)
/datum/cas_fire_envelope/proc/on_tracked_object_del(atom/target)
	SIGNAL_HANDLER
	tracked_object = null
	change_current_loc()

/datum/cas_fire_envelope/proc/user_is_guided(user)
	return guidance && (user in guidance.users)


/datum/cas_fire_envelope/proc/add_user_to_tracking(user)
	if(!guidance)
		return
	var/mob/M = user
	if(istype(M) && M.client)
		M.reset_view(guidance)
		apply_upgrade(user)
		if(!(user in guidance.users))
			guidance.users += user
			RegisterSignal(user, COMSIG_MOB_RESISTED, PROC_REF(exit_cam_resist))

/datum/cas_fire_envelope/proc/apply_upgrade(user)
	var/mob/M = user
	if(linked_console.upgraded == MATRIX_NVG)
		if(linked_console.power <= 8)
			M.add_client_color_matrix("matrix_nvg", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string(linked_console.matrix_color)))
			M.overlay_fullscreen("matrix_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
		M.overlay_fullscreen("matrix", /atom/movable/screen/fullscreen/flash/noise/nvg)
		M.lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
		M.sync_lighting_plane_alpha()


/datum/cas_fire_envelope/proc/remove_upgrades(user)
	var/mob/M = user
	if(linked_console.upgraded == MATRIX_NVG)
		M.remove_client_color_matrix("matrix_nvg")
		M.clear_fullscreen("matrix")
		M.clear_fullscreen("matrix_blur")
		M.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		M.sync_lighting_plane_alpha()
	if(linked_console.upgraded == MATRIX_WIDE)
		M.client?.change_view(7, M)
	else
		return


/datum/cas_fire_envelope/proc/remove_user_from_tracking(user)
	if(!guidance)
		return
	var/mob/M = user
	if(user && (user in guidance.users))
		if(istype(M) && M.client)
			M.reset_view()
			remove_upgrades(user)
		guidance.users -= user
		UnregisterSignal(user, COMSIG_MOB_RESISTED)
	guidance.clearCameras(linked_console)

/datum/cas_fire_envelope/proc/exit_cam_resist(mob/user)
	SIGNAL_HANDLER

	remove_user_from_tracking(user)


/datum/cas_fire_envelope/proc/check_firemission_loc(datum/cas_signal/target_turf)
	return TRUE //redefined in child class

/// Step 1: Sets the stat to FIRE_MISSION_STATE_ON_TARGET and starts the sound effect for the fire mission.
/datum/cas_fire_envelope/proc/play_sound(atom/target_turf)
	stat = FIRE_MISSION_STATE_ON_TARGET
	change_current_loc(target_turf)
	playsound(target_turf, soundeffect, vol = 70, vary = TRUE, sound_range = 50, falloff = 8)

/// Step 2, 3, 4: Warns nearby mobs of the incoming fire mission. Warning as 1 is non-precise, whereas 2 and 3 are precise.
/datum/cas_fire_envelope/proc/chat_warning(atom/target_turf, range = 10, warning_number = 1)
	var/ds_identifier = "LARGE BIRD"
	var/fm_identifier = "SPIT FIRE"
	var/relative_dir
	for(var/mob/mob in range(15, target_turf))
		if (mob.mob_flags & KNOWS_TECHNOLOGY)
			ds_identifier = "DROPSHIP"
			fm_identifier = "FIRE"
		if(get_turf(mob) == target_turf)
			relative_dir = 0
		else
			relative_dir = Get_Compass_Dir(mob, target_turf)
		switch(warning_number)
			if(1)
				mob.show_message( \
					SPAN_HIGHDANGER("YOU HEAR THE [ds_identifier] ROAR AS IT PREPARES TO [fm_identifier] NEAR YOU!"),SHOW_MESSAGE_VISIBLE, \
					SPAN_HIGHDANGER("YOU HEAR SOMETHING FLYING CLOSER TO YOU!") , SHOW_MESSAGE_AUDIBLE \
				)
			if(2)
				mob.show_message( \
					SPAN_HIGHDANGER("A [ds_identifier] FLIES [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_VISIBLE, \
					SPAN_HIGHDANGER("YOU HEAR SOMETHING GO [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_AUDIBLE \
				)
			if(3)
				mob.show_message( \
					SPAN_HIGHDANGER("A [ds_identifier] FLIES [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_VISIBLE, \
					SPAN_HIGHDANGER("YOU HEAR SOMETHING GO [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_AUDIBLE \
				)

/// Step 5: Actually executes the fire mission updating stat to FIRE_MISSION_STATE_FIRING and then FIRE_MISSION_STATE_OFF_TARGET
/datum/cas_fire_envelope/proc/open_fire(atom/target_turf,datum/cas_fire_mission/mission,dir)
	stat = FIRE_MISSION_STATE_FIRING
	mission.execute_firemission(linked_console, target_turf, dir, fire_length, step_delay, src)
	stat = FIRE_MISSION_STATE_OFF_TARGET

/// Step 6: Sets the fire mission stat to FIRE_MISSION_STATE_COOLDOWN
/datum/cas_fire_envelope/proc/flyoff()
	stat = FIRE_MISSION_STATE_COOLDOWN

/// Step 7: Sets the fire mission stat to FIRE_MISSION_STATE_IDLE
/datum/cas_fire_envelope/proc/end_cooldown()
	stat = FIRE_MISSION_STATE_IDLE


/datum/cas_fire_envelope/proc/execute_firemission_unsafe(datum/cas_signal/signal, turf/target_turf, dir, datum/cas_fire_mission/mission)
	stat = FIRE_MISSION_STATE_IN_TRANSIT
	to_chat(usr, SPAN_ALERT("Firemission underway!"))
	if(!target_turf)
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target Lost."
		return
	if(!target_turf || !check_firemission_loc(signal))
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target is off bounds or obstructed."
		return

	var/obj/effect/firemission_effect = new(target_turf)

	firemission_effect.icon = 'icons/obj/items/weapons/projectiles.dmi'
	firemission_effect.icon_state = "laser_target2"
	firemission_effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	firemission_effect.invisibility = INVISIBILITY_MAXIMUM
	QDEL_IN(firemission_effect, 12 SECONDS)

	// Ramrocket decreases grace period
	var/adjusted_grace_period = grace_period
	if(linked_console)
		var/shuttle_tag = linked_console.shuttle_tag
		var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
		if(istype(dropship))
			for(var/obj/structure/dropship_equipment/fuel/ram_rocket/rocket in dropship.equipments)
				adjusted_grace_period = grace_period / 2
				break

	notify_ghosts(header = "CAS Fire Mission", message = "[usr ? usr : "Someone"] is launching Fire Mission '[mission.name]' at [get_area(target_turf)].", source = firemission_effect)
	msg_admin_niche("[usr ? key_name(usr) : "Someone"] is launching Fire Mission '[mission.name]' at ([target_turf.x],[target_turf.y],[target_turf.z]) [ADMIN_JMP(target_turf)]")


	addtimer(CALLBACK(src, PROC_REF(play_sound), target_turf), adjusted_grace_period)
	addtimer(CALLBACK(src, PROC_REF(chat_warning), target_turf, 15, 1), first_warning)
	addtimer(CALLBACK(src, PROC_REF(chat_warning), target_turf, 15, 2), second_warning)
	addtimer(CALLBACK(src, PROC_REF(chat_warning), target_turf, 10, 3), third_warning)
	addtimer(CALLBACK(src, PROC_REF(open_fire), target_turf, mission,dir), execution_start)
	addtimer(CALLBACK(src, PROC_REF(flyoff)), flyoff_period)
	addtimer(CALLBACK(src, PROC_REF(end_cooldown)), cooldown_period)

/**
 * Change attack vector for firemission
 */
/datum/cas_fire_envelope/proc/change_direction(new_dir)
	if(stat > FIRE_MISSION_STATE_IN_TRANSIT)
		mission_error = "Fire Mission is under way already."
		return 0
	if((new_dir != 1) && (new_dir != 2) && (new_dir != 4) && (new_dir != 8))
		mission_error = "Direction has to be cardinal (i.e. North/South/West/East)"
		return 0
	if(new_dir<0 || new_dir>15)
		mission_error = "Do not use 4D coordinate matrix vector please." //hehe
		return 0
	recorded_dir = new_dir
	return 1

/datum/cas_fire_envelope/proc/change_offset(new_offset)
	if(stat > FIRE_MISSION_STATE_IN_TRANSIT)
		mission_error = "Fire Mission is under way already."
		return 0
	if(new_offset < 0)
		mission_error = "Offset cannot be negative."
		return 0
	if(new_offset > max_offset)
		mission_error = "Offset cannot be greater than [max_offset]."
		return 0
	recorded_offset = new_offset
	return 1

/datum/cas_fire_envelope/proc/delete_firemission(mission_id)
	if(stat > FIRE_MISSION_STATE_IN_TRANSIT && stat < FIRE_MISSION_STATE_COOLDOWN)
		mission_error = "Fire Mission is under way already."
		return 0
	if(!missions[mission_id])
		return -1
	var/mission = missions[mission_id]
	missions -= mission
	qdel(mission)
	return 1

/datum/cas_fire_envelope/uscm_dropship
	fire_length = 12
	base_fire_length = 12
	grace_period = 5 SECONDS
	first_warning = 6 SECONDS
	second_warning = 8 SECONDS
	third_warning = 9 SECONDS
	execution_start = 10 SECONDS
	flyoff_period = 15 SECONDS
	cooldown_period = 25 SECONDS
	soundeffect = 'sound/weapons/dropship_sonic_boom.ogg' //BOOM~WOOOOOSH~HSOOOOOW~BOOM
	step_delay = 3
	max_offset = 12

	var/z_level_restriction = TRUE

/datum/cas_fire_envelope/uscm_dropship/change_target_loc(datum/cas_signal/marker)
	if(!marker)
		return ..(marker)
	var/turf/TU = get_turf(marker.signal_loc)
	if(!is_ground_level(TU.z) && z_level_restriction)
		mission_error = "USCM Dropships can only operate with planetside targets."
		return FALSE
	return ..(marker)

/datum/cas_fire_envelope/uscm_dropship/check_firemission_loc(datum/cas_signal/target_turf)
	return istype(target_turf) && target_turf.valid_signal()

//debugging procs
/obj/structure/machinery/computer/dropship_weapons/proc/generate_mission(firemission_name, length)
	firemission_envelope.generate_mission(firemission_name, length)

/obj/structure/machinery/computer/dropship_weapons/proc/update_mission(mission_id, weapon_id, offset_step, offset)
	var/result = firemission_envelope.update_mission(mission_id, weapon_id, offset_step, offset)
	if(result != FIRE_MISSION_ALL_GOOD)
		return firemission_envelope.mission_error
	return "OK"

// Used in the simulation room for firemission testing.
/obj/structure/machinery/computer/dropship_weapons/proc/execute_firemission(obj/location, offset, dir, mission_id)
	var/result = firemission_envelope.execute_firemission(get_turf(location), offset, dir, mission_id)
	if(result != FIRE_MISSION_ALL_GOOD)
		return firemission_envelope.mission_error
	return "OK"

/datum/cas_fire_envelope/proc/update_fire_length()
	// Reset to base fire length to prevent stacking bonuses
	// If base_fire_length is not set, use current fire_length as base
	if(!base_fire_length)
		base_fire_length = fire_length
	fire_length = base_fire_length

	if(linked_console)
		var/shuttle_tag = linked_console.shuttle_tag
		var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
		if(istype(dropship))
			// Check for ram rocket equipment (adds +4 fire length, not stackable)
			for(var/obj/structure/dropship_equipment/fuel/ram_rocket/rocket in dropship.equipments)
				fire_length += 4
				break

/datum/cas_fire_envelope/proc/anti_air_success(atom/target_turf, range = 10, datum/dropship_antiair/effect_type = null)
	var/ds_identifier = "LARGE BIRD"
	var/custom_message = ""

	for(var/mob/mob in range(range, target_turf))
		if(mob && !QDELETED(mob) && !mob.gc_destroyed && mob.client)
			if(mob.mob_flags & KNOWS_TECHNOLOGY)
				ds_identifier = "DROPSHIP"
			else
				ds_identifier = "LARGE BIRD"

			// Set custom message based on the antiair effect type
			if(effect_type && effect_type.get_antiair_message(ds_identifier))
				custom_message = effect_type.get_antiair_message(ds_identifier)
			else
				// Default message for all other cases
				custom_message = "YOU HEAR THE [ds_identifier] VEER OFF COURSE AS AN EXPLOSION ROCKS ITS FRAME!"

			mob.show_message(
				SPAN_HIGHDANGER(custom_message), SHOW_MESSAGE_AUDIBLE
			)
	if(!src.antiair_fx_played)
		src.antiair_fx_played = TRUE
		playsound(target_turf, 'sound/effects/supercapacitors_charging.ogg', vol = 80, vary = TRUE, sound_range = 75, falloff = 8)
		// Announce to xenos only if the anti-air was created by a xeno and announcement hasn't been played yet
		if(!src.xeno_announcement_played)
			var/turf/turf_loc = get_turf(target_turf)
			var/hivenumber_to_announce = null

			if(turf_loc && turf_loc.skyspit_applier && istype(turf_loc.skyspit_applier, /mob/living/carbon/xenomorph))
				var/mob/living/carbon/xenomorph/applier_xeno = turf_loc.skyspit_applier
				hivenumber_to_announce = applier_xeno.hivenumber
			// Check for pylon antiair
			else if(turf_loc && turf_loc.antiair_applier && istype(turf_loc.antiair_applier, /datum/hive_status))
				var/datum/hive_status/applier_hive = turf_loc.antiair_applier
				hivenumber_to_announce = applier_hive.hivenumber

			if(hivenumber_to_announce)
				xeno_announcement("The metal bird's cries can be heard from the sky. It's been injured!", hivenumber_to_announce, XENO_GENERAL_ANNOUNCE)
				src.xeno_announcement_played = TRUE
		// Spark effect for the Dropship
		var/list/nearby = list()
		for(var/turf/T in range(3, target_turf)) if(T != target_turf) nearby += T
		if(nearby.len)
			var/list/used = list()
			var/max_sparks = min(9, nearby.len)
			for(var/i = 1, i <= max_sparks, i++)
				var/turf/random_turf = pick(nearby - used)
				if(random_turf)
					new /obj/effect/particle_effect/sparks(random_turf)
					used += random_turf
		// Shake the camera for all mobs in range
		for(var/mob/mob in range(range, target_turf))
			if(mob && !QDELETED(mob) && !mob.gc_destroyed && mob.client && istype(mob, /mob/living))
				shake_camera(mob, 10, 1)
