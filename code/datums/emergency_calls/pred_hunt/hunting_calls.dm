///Predator Hunting Ground ERTs


/datum/emergency_call/pred
	name = "template"
	var/hunt_name
	probability = 0

/datum/emergency_call/pred/mixed
	name = "Hunting Grounds Mutil Faction Small"
	hunt_name = "Multi Faction (Easy)"
	mob_max = 4
	mob_min = 3

/datum/emergency_call/pred/create_member(datum/mind/man, turf/override_spawn_loc)
	if(SSmapping.loaded_lazy_templates[/datum/lazy_template/pred])
		name_of_spawn = /obj/effect/landmark/ert_spawns/hunt_spawner
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/hunted = new(spawn_loc)

	if(heavies < max_heavies && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(hunted.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		hunted.client?.prefs.copy_all_to(hunted, JOB_SQUAD_SPECIALIST, TRUE, TRUE)
		arm_equipment(hunted, /datum/equipment_preset/other/elite_merc, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are an Elite Mercenary!"))
	else if(medics < max_medics && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(hunted.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		hunted.client?.prefs.copy_all_to(hunted, JOB_SQUAD_MEDIC, TRUE, TRUE)
		arm_equipment(hunted, /datum/equipment_preset/upp/medic, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are a Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
	else if(heavies < max_heavies && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_HEAVY))
		heavies++
		hunted.client?.prefs.copy_all_to(hunted, JOB_SQUAD_SPECIALIST, TRUE, TRUE)
		arm_equipment(hunted, /datum/equipment_preset/dutch, man == null, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_SMARTGUNNER))
		smartgunners++
		hunted.client?.prefs.copy_all_to(hunted, JOB_SQUAD_SMARTGUN, TRUE, TRUE)
		arm_equipment(hunted, /datum/equipment_preset/uscm/sg_pve, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are a Solar Devils Smartgunner!"))
	else
		hunted.client?.prefs.copy_all_to(hunted, JOB_SQUAD_MARINE, TRUE, TRUE)
		arm_equipment(hunted, /datum/equipment_preset/clf/soldier, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You awake, startled. The last thing you remember is a firefight with the Colonial Marshals on UV-941 before a blinding light washed out your vision. Your head is pounding.!"))

/datum/emergency_call/pred/mixed/medium
	name = "Hunting Grounds Mutil Faction Medium"
	hunt_name = "Multi Faction (Medium)"
	mob_max = 6
	mob_min = 4

	max_heavies = 2
	max_medics = 1

/datum/emergency_call/pred/mixed/hard
	name = "Hunting Grounds Mutil Faction Large"
	hunt_name = "Multi Faction (HARD)"
	mob_max = 8
	mob_min = 6

	max_heavies = 3
	max_medics = 2

/datum/emergency_call/pred/xeno
	name = "Hunting Grounds Xenos Small"
	hunt_name = "Serpents (easy)"
	mob_max = 2
	hostility = TRUE

/datum/emergency_call/pred/xeno/spawn_items()
	var/turf/drop_spawn = get_spawn_point(TRUE)
	if(istype(drop_spawn))
		new /obj/effect/alien/weeds/node(drop_spawn) //drop some weeds for xeno plasma regen.

/datum/emergency_call/pred/xeno/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/current_mob = player.current

	var/mob/living/carbon/xenomorph/new_xeno
	if(!leader)
		new_xeno = new /mob/living/carbon/xenomorph/ravager(spawn_loc)
		leader = new_xeno
	else
		var/picked = pick(/mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/praetorian)
		new_xeno = new picked(spawn_loc)

	new_xeno.set_hive_and_update(XENO_HIVE_FORSAKEN)

	QDEL_NULL(current_mob)

/datum/emergency_call/pred/xeno/med
	name = "Hunting Grounds Xenos Medium"
	hunt_name = "Serpents (Medium)"
	mob_max = 4
	hostility = TRUE

/datum/emergency_call/pred/xeno/hard
	name = "Hunting Grounds Xenos Large"
	hunt_name = "Serpents (Hard)"
	mob_max = 6
	hostility = TRUE
