/datum/cas_fire_envelope
	var/obj/structure/machinery/computer/dropship_weapons/linked_console
	var/list/datum/cas_fire_mission/missions
	var/max_mission_len = 5
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


/datum/cas_fire_envelope/New()
	..()
	missions = list()

/datum/cas_fire_envelope/proc/get_total_duration()
	return grace_period+flyto_period+flyoff_period

/datum/cas_fire_envelope/proc/generate_mission(firemission_name, length)
	if(!missions || !linked_console || missions.len>max_mission_len || !fire_length)
		return null
	
	var/list/obj/structure/dropship_equipment/weapons = list()
	for(var/X in linked_console.shuttle_equipments)
		var/obj/structure/dropship_equipment/E = X
		if(E.is_weapon)
			weapons += E

	var/datum/cas_fire_mission/fm = new()

	if(weapons.len==0)
		return null //why bother?

	for(var/obj/structure/dropship_equipment/weapon/wp in weapons)
		var/datum/cas_fire_mission_record/record = new()
		record.weapon = wp
		record.offsets = new /list(fire_length)
		for(var/idx = 1; idx<=fire_length; idx++)
			record.offsets[idx] = "-"
		fm.records += record
	
	fm.name = firemission_name
	fm.mission_length = length

	missions += fm
	return fm

	//-1 - system error, 0 - mission error, 1 - all good
/datum/cas_fire_envelope/proc/update_mission(mission_id, weapon_id, offset_step, offset, skip_checks = 0)
	mission_error = null
	if(stat > FIRE_MISSION_STATE_IN_TRANSIT && stat < FIRE_MISSION_STATE_COOLDOWN)
		mission_error = "Fire Mission is under way already."
		return 0
	if(!missions[mission_id])
		return -1
	var/datum/cas_fire_mission/mission = missions[mission_id]
	if(!mission)
		return -1
	if(!mission.records[weapon_id])
		return -1
	var/datum/cas_fire_mission_record/fmr = mission.records[weapon_id]
	if(!fmr.offsets || !fmr.offsets[offset_step])
		return -1
	var/old_offset = fmr.offsets[offset_step]
	fmr.offsets[offset_step] = offset
	var/check_result = mission.check(linked_console)
	if(check_result == FIRE_MISSION_CODE_ERROR)
		return -1
	if(check_result == FIRE_MISSION_ALL_GOOD)
		return 1
	if(check_result == FIRE_MISSION_WEAPON_OUT_OF_AMMO)
		return 1
	
	mission_error = mission.error_message(check_result)
	if(skip_checks)
		return 0
	
	//we have mission error. Fill the thing and restore previous state
	fmr.offsets[offset_step] = old_offset

	return 0

/datum/cas_fire_envelope/proc/execute_firemission(datum/cas_signal/target_turf, offset, dir, mission_id)
	if(!istype(target_turf))
		mission_error = "No target."
		return 0
	if(stat != FIRE_MISSION_STATE_IDLE)
		mission_error = "Fire Mission is under way already."
		return 0
	if(!missions[mission_id])
		return -1
	if(offset<0)
		mission_error = "Can't have negative offsets."
		return 0
	if(offset>max_offset)
		mission_error = "[max_offset] is the maximum possible offset."
		return 0
	if(dir!=NORTH && dir!=SOUTH && dir!=WEST && dir!=EAST)
		mission_error = "Incorrect direction."
		return 0
	mission_error = null
	var/datum/cas_fire_mission/mission = missions[mission_id]
	var/check_result = mission.check(linked_console)
	if(check_result == FIRE_MISSION_CODE_ERROR)
		return -1
	
	if(check_result != FIRE_MISSION_ALL_GOOD)
		mission_error = mission.error_message(check_result)
		return 0
	//actual firemission code
	execute_firemission_unsafe(target_turf, offset, dir, mission)
	return 1

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

/datum/cas_fire_envelope/proc/change_target_loc(obj/location)
	if(location == null)
		recorded_loc = null
		return 1
	var/turf/TU = get_turf(location.loc)
	if(!istype(TU))
		mission_error = "Can't find target."
		return 0
	recorded_loc = location
	return 1

/datum/cas_fire_envelope/proc/change_current_loc(location)
	if(!location && guidance)
		for(var/mob/M in guidance.users)
			if(istype(M) && M.client)
				M.reset_view()
		qdel(guidance)			
		return
	if(!guidance)
		guidance = new /obj/effect/firemission_guidance()			
	guidance.loc = location

/datum/cas_fire_envelope/proc/user_is_guided(user)
	return guidance && (user in guidance.users)
	

/datum/cas_fire_envelope/proc/add_user_to_tracking(user)
	if(!guidance)
		return
	var/mob/M = user
	if(istype(M) && M.client)
		M.reset_view(guidance)
		if(!(user in guidance.users))
			guidance.users += user
		

/datum/cas_fire_envelope/proc/remove_user_from_tracking(user)
	if(!guidance)
		return
	if(user && (user in guidance.users))
		guidance.users -= user
		var/mob/M = user
		if(istype(M) && M.client)
			M.reset_view()

/datum/cas_fire_envelope/proc/check_firemission_loc(datum/cas_signal/target_turf)
	return TRUE //redefined in child class

/datum/cas_fire_envelope/proc/execute_firemission_unsafe(datum/cas_signal/target_turf, offset, dir, datum/cas_fire_mission/mission)
	var/sx = 0
	var/sy = 0		
	
	recorded_dir = dir
	recorded_offset = offset

	stat = FIRE_MISSION_STATE_IN_TRANSIT
	sleep(grace_period)
	stat = FIRE_MISSION_STATE_ON_TARGET
	switch(recorded_dir)
		if(NORTH) //default direction
			sx = 0
			sy = 1
		if(SOUTH)
			sx = 0
			sy = -1
		if(EAST)
			sx = 1
			sy = 0
		if(WEST)
			sx = -1
			sy = 0
	if(!target_turf)
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target Lost."
		return
	var/turf/tt_turf = get_turf(target_turf.loc)
	if(!tt_turf  || !check_firemission_loc(target_turf))
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target is off bounds or obstructed."
		return
	var/turf/shootloc = locate(tt_turf.x + sx*recorded_offset, tt_turf.y + sy*recorded_offset,tt_turf.z)
	if(!shootloc || !istype(shootloc))
		stat = FIRE_MISSION_STATE_IDLE
		mission_error = "Target is off bounds."
		return
	change_current_loc(shootloc)
	playsound(shootloc, soundeffect, 70, TRUE, 50) 
	sleep(flyto_period)
	stat = FIRE_MISSION_STATE_FIRING
	mission.execute_firemission(linked_console, shootloc, recorded_dir, fire_length, step_delay, src)
	stat = FIRE_MISSION_STATE_OFF_TARGET
	sleep(flyoff_period)
	stat = FIRE_MISSION_STATE_COOLDOWN
	sleep(cooldown_period)
	stat = FIRE_MISSION_STATE_IDLE

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
	grace_period = 50 //5 seconds
	flyto_period = 50 //five seconds
	flyoff_period = 50 //FIVE seconds
	cooldown_period = 100 //f~ I mean, 10 seconds
	soundeffect = 'sound/weapons/dropship_sonic_boom.ogg' //BOOM~WOOOOOSH~HSOOOOOW~BOOM
	step_delay = 3
	max_offset = 12

	var/z_level_restriction = TRUE

/datum/cas_fire_envelope/uscm_dropship/change_target_loc(obj/location)
	if(!location)
		return ..(location)
	var/turf/TU = get_turf(location.loc)
	if(TU.z != 1 && z_level_restriction)
		mission_error = "USCM Dropships can only operate with planetside targets."
		return 0
	return ..(location)

/datum/cas_fire_envelope/uscm_dropship/check_firemission_loc(datum/cas_signal/target_turf)
	return istype(target_turf) && target_turf.valid_signal()

//debugging procs
/obj/structure/machinery/computer/dropship_weapons/proc/generate_mission(firemission_name, length)
	firemission_envelope.generate_mission(firemission_name, length)

/obj/structure/machinery/computer/dropship_weapons/proc/update_mission(mission_id, weapon_id, offset_step, offset)
	var/result = firemission_envelope.update_mission(mission_id, weapon_id, offset_step, offset)
	if(result<1)
		return firemission_envelope.mission_error
	return "OK"

/obj/structure/machinery/computer/dropship_weapons/proc/execute_firemission(obj/location, offset, dir, mission_id)
	var/result = firemission_envelope.execute_firemission(get_turf(location), offset, dir, mission_id)
	if(result<1)
		return firemission_envelope.mission_error
	return "OK"
