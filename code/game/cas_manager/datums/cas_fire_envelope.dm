/datum/cas_fire_envelope
	var/obj/structure/machinery/computer/dropship_weapons/linked_console
	var/list/datum/cas_fire_mission/missions
	var/fire_length
	var/grace_period //how much time you have after initiating fire mission and before you can't change firemissions
	var/flyto_period //how much time it takes from sound alarm start to first hit. CAS is vulnerable here
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


/datum/cas_fire_envelope/proc/get_total_duration()
	return grace_period+flyto_period+flyoff_period

/datum/cas_fire_envelope/proc/update_weapons(list/obj/structure/dropship_equipment/weapon/weapons)
	for(var/datum/cas_fire_mission/mission in missions)
		mission.update_weapons(weapons, fire_length)

/datum/cas_fire_envelope/proc/generate_mission(firemission_name, length)
	if(!missions || !linked_console || !fire_length)
		return null
	var/list/obj/structure/dropship_equipment/weapons = list()
	var/shuttle_tag = linked_console.shuttle_tag
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if(equipment.is_weapon)
			weapons += equipment

	var/datum/cas_fire_mission/fm = new()
	for(var/obj/structure/dropship_equipment/weapon/wp in weapons)
		fm.build_new_record(wp, fire_length)

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

	var/datum/cas_fire_mission_record/fmr = mission.record_for_weapon(weapon_id)
	if(!fmr)
		return FIRE_MISSION_NOT_EXECUTABLE
	if(!fmr.offsets || isnull(fmr.offsets[offset_step]))
		return FIRE_MISSION_NOT_EXECUTABLE
	var/old_offset = fmr.offsets[offset_step]
	if(offset == null)
		offset = "-"
	fmr.offsets[offset_step] = offset
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
			M.add_client_color_matrix("matrix_nvg", 99, color_matrix_multiply(color_matrix_saturation(1), color_matrix_rotate_x(-1*(20.8571-1.57143*linked_console.power)), color_matrix_from_string(linked_console.matrixcol))) // (20.8571-1.57143*linked_console.power) is an equation so we can make low level properties look bad
			M.overlay_fullscreen("matrix_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
		M.overlay_fullscreen("matrix", /atom/movable/screen/fullscreen/flash/noise/nvg)
		M.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
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

/**
 * Execute firemission.
 */
/datum/cas_fire_envelope/proc/execute_firemission_unsafe(datum/cas_signal/signal, turf/target_turf, dir, datum/cas_fire_mission/mission)
	stat = FIRE_MISSION_STATE_IN_TRANSIT
	to_chat(usr, SPAN_ALERT("Firemission underway!"))
	sleep(grace_period)
	stat = FIRE_MISSION_STATE_ON_TARGET
	if(!target_turf)
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target Lost."
		return
	if(!target_turf || !check_firemission_loc(signal))
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target is off bounds or obstructed."
		return
	change_current_loc(target_turf)
	playsound(source = target_turf, soundin = soundeffect, vol = 70, vary = TRUE, sound_range = 50, falloff = 8)

	for(var/mob/mob in range(15, target_turf))
		var/ds_identifier = "LARGE BIRD"
		var/fm_identifier = "SPIT FIRE"
		if (mob.mob_flags & KNOWS_TECHNOLOGY)
			ds_identifier = "DROPSHIP"
			fm_identifier = "FIRE"

		mob.show_message( \
			SPAN_HIGHDANGER("YOU HEAR THE [ds_identifier] ROAR AS IT PREPARES TO [fm_identifier] NEAR YOU!"),SHOW_MESSAGE_VISIBLE, \
			SPAN_HIGHDANGER("YOU HEAR SOMETHING FLYING CLOSER TO YOU!") , SHOW_MESSAGE_AUDIBLE \
		)

	sleep(flyto_period)
	stat = FIRE_MISSION_STATE_FIRING
	mission.execute_firemission(linked_console, target_turf, dir, fire_length, step_delay, src)
	stat = FIRE_MISSION_STATE_OFF_TARGET
	sleep(flyoff_period)
	stat = FIRE_MISSION_STATE_COOLDOWN
	sleep(cooldown_period)
	stat = FIRE_MISSION_STATE_IDLE

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
	grace_period = 5 SECONDS 
	flyto_period = 4 SECONDS //sleep in the FM itself has been increased by one more second
	flyoff_period = 5 SECONDS
	cooldown_period = 10 SECONDS
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
