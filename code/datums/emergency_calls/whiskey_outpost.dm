

//whiskey outpost extra marines
/datum/emergency_call/wo
	name = "Marine Reinforcements (Squad)"
	mob_max = 15
	mob_min = 1
	probability = 0
	objectives = "Assist the USCM forces"

	max_smartgunners = 1
	max_heavies = 1
	max_engineers = 2
	max_medics = 2

/datum/emergency_call/wo/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	sleep(5)
	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/dust_raider/leader, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("You are a Squad Leader in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]."))
	else if (heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		arm_equipment(mob, /datum/equipment_preset/dust_raider/specialist, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("You are a Specialist in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]."))
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		arm_equipment(mob, /datum/equipment_preset/dust_raider/smartgunner, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("You are a Smartgunner in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]."))
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(mob, /datum/equipment_preset/dust_raider/engineer, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("You are an Engineer in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]."))
	else if (medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/dust_raider/medic, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("You are a Hospital Corpsman in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]."))
	else
		arm_equipment(mob, /datum/equipment_preset/dust_raider/private, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("You are a Rifleman in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]."))

	sleep(10)
	to_chat(mob, "<B>Objectives:</b> [objectives]")

	GLOB.RoleAuthority.randomize_squad(mob)

	mob.sec_hud_set_ID()
	mob.hud_set_squad()

	GLOB.data_core.manifest_inject(mob) //Put people in crew manifest


/datum/game_mode/whiskey_outpost/activate_distress()
	var/datum/emergency_call/em_call = /datum/emergency_call/wo
	em_call.activate(TRUE, FALSE)
	return

/datum/emergency_call/wo/platoon
	name = "Marine Reinforcements (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0

	max_heavies = 4
	max_smartgunners = 4

/datum/emergency_call/wo/platoon/cryo
	name = "Marine Reinforcements (Platoon) (Cryo)"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/datum/emergency_call/wo/cryo
	name = "Marine Reinforcements (Squad) (Cryo)"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
