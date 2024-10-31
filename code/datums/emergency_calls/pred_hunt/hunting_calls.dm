///Predator Hunting Ground ERTs


/datum/emergency_call/pred
	name = "template"
	var/hunt_name
	var/obj/structure/machinery/hunt_ground_spawner/spawner
	probability = 0
	dispatch_message = "Let the hunt commence!"

/datum/emergency_call/pred/mixed
	name = "Hunting Grounds Mutil Faction Small"
	hunt_name = "multi Faction (small)"
	mob_max = 1
	mob_min = 1

/datum/emergency_call/pred/create_member(datum/mind/man, turf/override_spawn_loc)
	if(SSmapping.loaded_lazy_templates[/datum/lazy_template/pred/jungle_moon])
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress/hunt_spawner
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/hunted = new(spawn_loc)
	man.transfer_to(hunted, TRUE)

	if(heavies < max_heavies && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(hunted.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		arm_equipment(hunted, /datum/equipment_preset/other/elite_merc, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are an Elite Mercenary!"))
		playsound(hunted, 'sound/misc/hunt_start.ogg')
	else if(medics < max_medics && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(hunted.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(hunted, /datum/equipment_preset/upp/medic, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are a Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		playsound(hunted, 'sound/misc/hunt_start.ogg')
	else if(heavies < max_heavies && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_HEAVY))
		heavies++
		arm_equipment(hunted, /datum/equipment_preset/dutch, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are a"))
		playsound(hunted, 'sound/misc/hunt_start.ogg')
	else if(smartgunners < max_smartgunners && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_SMARTGUNNER))
		smartgunners++
		arm_equipment(hunted, /datum/equipment_preset/uscm/rifleman_pve, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You are a Solar Devils Marine"))
		playsound(hunted, 'sound/misc/hunt_start.ogg')
	else
		arm_equipment(hunted, /datum/equipment_preset/clf/soldier, man == null, TRUE)
		to_chat(hunted, SPAN_BOLD("You awake, startled. The last thing you remember is a firefight with the Colonial Marshals on UV-941 before a blinding light washed out your vision. Your head is pounding.!"))
		playsound(hunted, 'sound/misc/hunt_start.ogg')

/datum/emergency_call/pred/mixed/medium
	name = "Hunting Grounds Mutil Faction Medium"
	hunt_name = "multi Faction (group)"
	mob_max = 6
	mob_min = 4

	max_heavies = 2
	max_medics = 1

/datum/emergency_call/pred/mixed/hard
	name = "Hunting Grounds Mutil Faction Large"
	hunt_name = "multi Faction (large)"
	mob_max = 8
	mob_min = 6

	max_heavies = 3
	max_medics = 2

/datum/emergency_call/pred/xeno
	name = "Hunting Grounds Xenos Small"
	hunt_name = "serpents (small)"
	mob_max = 2
	mob_min = 1
	hostility = TRUE
	max_xeno_t3 = 1
	max_xeno_t2 = 1

/datum/emergency_call/pred/xeno/create_member(datum/mind/player, turf/override_spawn_loc)
	if(SSmapping.loaded_lazy_templates[/datum/lazy_template/pred/jungle_moon])
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress/hunt_spawner
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()
	var/mob/current_mob = player.current
	var/mob/living/carbon/xenomorph/new_xeno

	if(!istype(spawn_loc))
		return // Didn't find a usable spawn point.

	if(xeno_t3 < max_xeno_t3 && current_mob.client.prefs.toggles_ert[PLAY_XENO_T3])
		xeno_t3++
		var/choice = pick(/mob/living/carbon/xenomorph/ravager, /mob/living/carbon/xenomorph/praetorian)
		var/picked = tgui_input_list(player, "What will be today?.", choice)
		new_xeno = new picked (spawn_loc, new_xeno.set_hive_and_update(XENO_HIVE_FERAL))
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		to_chat(new_xeno, SPAN_BOLD("You are a xeno"))
		playsound(new_xeno, 'sound/misc/hunt_start.ogg')
	else if (xeno_t2 < max_xeno_t2 && current_mob.client.prefs.toggles_ert[PLAY_XENO_T2])
		xeno_t2++
		var/choice = pick(/mob/living/carbon/xenomorph/ravager, /mob/living/carbon/xenomorph/praetorian)
		var/picked = tgui_input_list(player, "What will be today?.", choice)
		new_xeno = new picked (spawn_loc, new_xeno.set_hive_and_update(XENO_HIVE_FERAL))
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		to_chat(new_xeno, SPAN_BOLD("You are a xeno"))
		playsound(new_xeno, 'sound/misc/hunt_start.ogg')


/datum/emergency_call/pred/xeno/med
	name = "Hunting Grounds Xenos Medium"
	hunt_name = "serpents (group)"
	mob_max = 4
	mob_min = 3
	hostility = TRUE
	max_xeno_t3 = 3
	max_xeno_t2 = 1

/datum/emergency_call/pred/xeno/hard
	name = "Hunting Grounds Xenos Large"
	hunt_name = "serpents (large)"
	mob_max = 6
	mob_min = 4
	hostility = TRUE
	max_xeno_t3 = 3
	max_xeno_t2 = 3

/datum/emergency_call/pred/remove_nonqualifiers(list/datum/mind/candidates_list)
	return candidates_list

/datum/emergency_call/pred/spawn_candidates(quiet_launch = TRUE, announce_incoming = TRUE, override_spawn_loc)
	if(SSticker.mode)
		SSticker.mode.picked_calls -= src

	SEND_SIGNAL(src, COMSIG_ERT_SETUP)
	candidates = remove_nonqualifiers(candidates)

	if(length(candidates) < mob_min && !spawn_max_amount)
		message_admins("Aborting distress beacon, not enough candidates: found [length(candidates)].")
		message_all_yautja("Not enough prey in storage recalibrating huntsmaster console")
		members = list() //Empty the members list.
		candidates = list()
		spawner.yautja_hunt_cooldown.end_cooldown
		return
	if(announce_incoming)
		message_all_yautja(dispatch_message, 'sound/misc/hunt_start.ogg',)
