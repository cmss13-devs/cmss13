/obj/effect/firemission_guidance
	invisibility = 101
	var/list/users

/obj/effect/firemission_guidance/New()
	..()
	users = list()

/datum/cas_fire_mission
	var/mission_length = 3 //can be 3,4,6 or 12
	var/list/datum/cas_fire_mission_record/records = list()
	var/obj/structure/dropship_equipment/weapon/error_weapon
	var/name = "Unnamed Firemission"

/datum/cas_fire_mission/proc/check(obj/structure/machinery/computer/dropship_weapons/linked_console)
	error_weapon = null
	if(records.len == 0)
		return FIRE_MISSION_ALL_GOOD //I mean yes... but why?

	for(var/datum/cas_fire_mission_record/record in records)
		error_weapon = record.weapon
		if(!istype(record))
			return FIRE_MISSION_CODE_ERROR //What the fuck?
		if(!record.weapon.ship_base)
			return FIRE_MISSION_WEAPON_REMOVED //Someone disconnected it
		if(record.weapon.linked_console != linked_console)
			return FIRE_MISSION_WEAPON_REMOVED //Someone installed it on a different dropship

		var/limits = record.get_offsets()
		var/min
		var/max
		if(limits)
			min = limits["min"]
			max = limits["max"]
		var/cd = 0
		var/ammo_left = 0
		if(record.weapon.ammo_equipped)
			ammo_left = record.weapon.ammo_equipped.ammo_count
		var/i
		if(!record.offsets)
			continue
		for(i=1,i<=record.offsets.len,i++)
			if(cd > 0)
				cd--
			if(record.offsets[i] == null || record.offsets[i] == "-")
				continue
			if(record.offsets[i]<min || record.offsets[i]>max)
				return FIRE_MISSION_BAD_OFFSET
			if(cd > 0)
				return FIRE_MISSION_BAD_COOLDOWN
			if(!record.weapon.ammo_equipped)
				return FIRE_MISSION_WEAPON_OUT_OF_AMMO
			if(record.weapon.ammo_equipped.fire_mission_delay == 0)
				return FIRE_MISSION_WEAPON_UNUSABLE
			ammo_left -= record.weapon.ammo_equipped.ammo_used_per_firing
			if(ammo_left < 0)
				return FIRE_MISSION_WEAPON_OUT_OF_AMMO
			cd = record.weapon.ammo_equipped.fire_mission_delay
		error_weapon = null

	return FIRE_MISSION_ALL_GOOD//should be ok now

/datum/cas_fire_mission/proc/error_message(code_id)
	if(code_id == FIRE_MISSION_ALL_GOOD)
		return "All checks passed."
	if(code_id == FIRE_MISSION_CODE_ERROR)
		return "System error. Call Tech Support or create Fire Mission from scratch."
	if(!istype(error_weapon))
		return "Error or Fire Mission is outdated. Create Fire Mission from scratch if Error persists."
	var/weapon_string = "[error_weapon.name] "
	if(error_weapon.ammo_equipped)
		weapon_string += "([error_weapon.ammo_equipped.ammo_count]/[error_weapon.ammo_equipped.max_ammo_count]) "
	if(error_weapon.ship_base)
		weapon_string += "mounted on [error_weapon.ship_base.name] "

	if(code_id == FIRE_MISSION_BAD_COOLDOWN)
		return "Weapon [weapon_string] requires interval of [error_weapon.ammo_equipped.fire_mission_delay] time units per shot."
	if(code_id == FIRE_MISSION_BAD_OFFSET)
		// Change this to using weapon's when it is implemented
		var/obj/effect/attach_point/weapon/AW = error_weapon.ship_base
		if(!istype(AW))
			. = "Internal error: [weapon_string] hardpoint invalid"
			CRASH("CASFM-CHECK-01: Weapon attached to invalid hardpoint")
		var/list/allowed_offsets = AW.get_offsets()
		if(!allowed_offsets)
			. = "Internal error: [weapon_string] offsets invalid"
			CRASH("CASFM-CHECK-02: Weapon reported offsets invalid")
		return "Weapon hardpoint of [weapon_string] only allows gimbal offset between [allowed_offsets["min"]] and [allowed_offsets["max"]]."
	if(code_id == FIRE_MISSION_WEAPON_REMOVED)
		return "Weapon [weapon_string] is no longer located on this dropship"
	if(code_id == FIRE_MISSION_WEAPON_UNUSABLE)
		return "Weapon [weapon_string] is loaded with ammunition too dangerous to be used in Fire Mission"
	if(code_id == FIRE_MISSION_WEAPON_OUT_OF_AMMO)
		return "Weapon [weapon_string] has not enough ammunition to complete this Fire Mission"
	return "Unknown Error"

/datum/cas_fire_mission/proc/execute_firemission(obj/structure/machinery/computer/dropship_weapons/linked_console, turf/initial_turf, direction = NORTH, steps = 12, step_delay = 3, datum/cas_fire_envelope/envelope = null)
	if(initial_turf == null || check(linked_console) != FIRE_MISSION_ALL_GOOD)
		return -1

	var/relative_dir
	for(var/mob/M in range(15, initial_turf))
		if(get_turf(M) == initial_turf)
			relative_dir = 0
		else
			relative_dir = get_dir(M, initial_turf)

		var/ds_identifier = "LARGE BIRD"
		if (M.mob_flags & KNOWS_TECHNOLOGY)
			ds_identifier = "DROPSHIP"

		M.show_message( \
			SPAN_HIGHDANGER("A [ds_identifier] FLIES [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), 1, \
			SPAN_HIGHDANGER("YOU HEAR SOMETHING GO [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), 2 \
		)

	// Xenos have time to react to the first message
	sleep(0.5 SECONDS)

	for(var/mob/M in range(10, initial_turf))
		if(get_turf(M) == initial_turf)
			relative_dir = 0
		else
			relative_dir = get_dir(M, initial_turf)

		var/ds_identifier = "LARGE BIRD"
		if (M.mob_flags & KNOWS_TECHNOLOGY)
			ds_identifier = "DROPSHIP"

		M.show_message( \
			SPAN_HIGHDANGER("A [ds_identifier] FIRES TO YOUR [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), 1, \
			SPAN_HIGHDANGER("YOU HEAR SOMETHING FIRE TO YOUR [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), 2 \
		)

	var/turf/current_turf = initial_turf
	var/tally_step = steps / mission_length //how much shots we need before moving to next turf
	var/next_step = tally_step //when we move to next turf
	var/sx = 0
	var/sy = 0 //perpendicular multiplication

	switch(direction)
		if(NORTH) //default direction
			sx = 1
			sy = 0
		if(SOUTH)
			sx = -1
			sy = 0
		if(EAST)
			sx = 0
			sy = -1
		if(WEST)
			sx = 0
			sy = 1
	var/step = 1
	for(step = 1; step<=steps; step++)
		if(step > next_step)
			current_turf = get_step(current_turf,direction)
			next_step += tally_step
			if(envelope)
				envelope.change_current_loc(current_turf)
		var/datum/cas_fire_mission_record/item
		for(item in records)
			if(item.offsets.len < step || item.offsets[step] == null || item.offsets[step]=="-")
				continue
			var/offset = item.offsets[step]
			if (current_turf == null)
				return -1
			var/turf/shootloc = locate(current_turf.x + sx*offset, current_turf.y + sy*offset, current_turf.z)
			var/area/A = get_area(shootloc)
			if(shootloc && !CEILING_IS_PROTECTED(A?.ceiling, CEILING_PROTECTION_TIER_3) && !protected_by_pylon(TURF_PROTECTION_CAS, shootloc))
				item.weapon.open_fire_firemission(shootloc)
		sleep(step_delay)
	if(envelope)
		envelope.change_current_loc(null)
