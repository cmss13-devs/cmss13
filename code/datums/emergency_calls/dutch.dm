//Dutch's Dozen!... well, Dutch's Half Dozen

/datum/emergency_call/dutch
	name = "Dutch's Dozen"
	mob_max = 6
	mob_min = 4

	max_smartgunners = 1
	max_heavies = 1
	max_medics = 1

	arrival_message = "'Мы здесь, чтобы надрать задницы и убить Яутжа. В основном, чтобы убить Яутжа."
	objectives = "Выследите и убейте всех Яутжа без всякой жалости. Заберите снаряжение и уходите."
	probability = 0

/datum/emergency_call/dutch/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/dutch/arnie, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(H.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		arm_equipment(H, /datum/equipment_preset/dutch/flamer, TRUE, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		arm_equipment(H, /datum/equipment_preset/dutch/minigun, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/dutch/medic, TRUE, TRUE)
	else
		arm_equipment(H, /datum/equipment_preset/dutch, TRUE, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/dutch/full_dozen //AWWW YEAH DA FULL DOZEN FO TODAY
	name = "Dutch's Dozen - Full Strength"
	mob_max = 12
	mob_min = 8
	max_heavies = 2
	max_medics = 2
	arrival_message = "'Мы здесь, чтобы надрать задницы и убить Яутжа. В основном, чтобы убить Яутжа."
	objectives = "Выследите и убейте всех Яутжа без всякой жалости. Заберите снаряжение и уходите."
	probability = 0
