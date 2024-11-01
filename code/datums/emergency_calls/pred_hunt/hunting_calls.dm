///Predator Hunting Ground ERTs


/datum/emergency_call/pred
	name = "template"
	var/hunt_name
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress/hunt_spawner
	shuttle_id = ""

/datum/emergency_call/pred/mixed
	name = "Hunting Grounds Mutil Faction Small"
	hunt_name = "multi Faction (small)"
	mob_max = 4
	mob_min = 1
	max_heavies = 1
	max_medics = 1

/datum/emergency_call/pred/create_member(datum/mind/man, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/hunted = new(spawn_loc)
	man.transfer_to(hunted, TRUE)

	if(heavies < max_heavies && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(hunted.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		playsound(hunted,'sound/misc/hunt_start.ogg')
		arm_equipment(hunted, /datum/equipment_preset/other/elite_merc, TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("You jump awake and scramble to your feet. These surroundings are unfamiliar, and the darkness strains your eyes. Last you remember, you and your crew had been hired to guard an illegal mining operation in the Zuren Belt. It all seems distant now!"))
	else if(medics < max_medics && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(hunted.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		playsound(hunted,'sound/misc/hunt_start.ogg')
		arm_equipment(hunted, /datum/equipment_preset/upp/medic,TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("You jolt back to consciousness, your body shaking and drenched in sweat. Your surroundings are unfamiliar, and the last thing you remember is administering painkillers to a fatally wounded Comrade. Your throat is dry!"))
	else if(heavies < max_heavies && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_HEAVY))
		heavies++
		playsound(hunted,'sound/misc/hunt_start.ogg')
		arm_equipment(hunted, /datum/equipment_preset/twe/royal_marine/standard,TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("A shifting wind jolts you awake. Your vision is blurred and your surroundings are vague. The last thing you remember is being assigned bodyguard duty to some nameless influence peddler from the Empire. Your ears are ringing."))
	else if(smartgunners < max_smartgunners && HAS_FLAG(hunted.client.prefs.toggles_ert, PLAY_SMARTGUNNER))
		smartgunners++
		playsound(hunted,'sound/misc/hunt_start.ogg')
		arm_equipment(hunted, /datum/equipment_preset/uscm/rifleman_pve,TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("You open your eyes groggily. Moments ago you were wandering through the jungle with the rest of your squad, then everything went black. You can barely think straight."))
	else
		playsound(hunted,'sound/misc/hunt_start.ogg')
		arm_equipment(hunted, /datum/equipment_preset/clf/soldier,TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("You awake, startled. The last thing you remember is a firefight with the Colonial Marshals on UV-941 before a blinding light washed out your vision. Your head is pounding!"))

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
	mob_max = 3
	mob_min = 1
	hostility = TRUE
	max_xeno_t3 = 1
	max_xeno_t2 = 1

/datum/emergency_call/pred/xeno/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()
	var/mob/current_mob = player.current
	var/mob/living/carbon/xenomorph/new_xeno

	if(!istype(spawn_loc))
		return // Didn't find a usable spawn point.

	if(xeno_t3 < max_xeno_t3 && HAS_FLAG(current_mob.client.prefs.toggles_ert, PLAY_XENO_T3))
		xeno_t3++
		var/list/xeno_types = list(/mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/ravager)
		var/xeno_type = pick(xeno_types)
		new_xeno = new xeno_type(spawn_loc, null, XENO_HIVE_FERAL)
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		playsound(new_xeno,'sound/misc/hunt_start.ogg')
		to_chat(new_xeno, SPAN_BOLD("You are a xeno"))
	else if(xeno_t2 < max_xeno_t2 && HAS_FLAG(current_mob.client.prefs.toggles_ert, PLAY_XENO_T2))
		xeno_t2++
		var/list/xeno_types = list(/mob/living/carbon/xenomorph/lurker, /mob/living/carbon/xenomorph/warrior)
		var/xeno_type = pick(xeno_types)
		new_xeno = new xeno_type(spawn_loc, null, XENO_HIVE_FERAL)
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		playsound(new_xeno,'sound/misc/hunt_start.ogg')
		to_chat(new_xeno, SPAN_BOLD("You are a xeno let loose on a strang "))
	else
		var/list/xeno_types = list(/mob/living/carbon/xenomorph/defender)
		var/xeno_type = pick(xeno_types)
		new_xeno = new xeno_type(spawn_loc, null, XENO_HIVE_FERAL)
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		playsound(new_xeno,'sound/misc/hunt_start.ogg')
		to_chat(new_xeno, SPAN_BOLD("You are a xeno"))

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
