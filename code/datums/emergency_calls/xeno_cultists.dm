//Xeno Cultists
/datum/emergency_call/xeno_cult
	name = "Xeno Cultists"
	mob_max = 6
	arrival_message = "Incoming Transmission: 'Ia! Ia!'"
	objectives = "Support the Xenomorphs in any way, up to and including giving your life for them!"
	probability = 0
	hostility = TRUE
	var/max_synths = 1
	var/synths = 0

/datum/emergency_call/xeno_cult/print_backstory(mob/living/carbon/human/human)
	to_chat(human, SPAN_BOLD("The xenos are graced the Neroid Sector with their presence! It's time to spread their glory across the stars!"))

/datum/emergency_call/xeno_cult/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/human = new(spawn_loc)
	M.transfer_to(human, TRUE)

	if(!leader && HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = human
		to_chat(human, SPAN_ROLE_HEADER("You are the leader of this xeno cult! Bring glory to Queen Mother!"))
		arm_equipment(human, /datum/equipment_preset/other/xeno_cultist/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(human.client.prefs.toggles_ert, PLAY_SYNTH) && RoleAuthority.roles_whitelist[human.ckey] & WHITELIST_SYNTHETIC)
		synths++
		to_chat(human, SPAN_ROLE_HEADER("You are the xeno cult's synthetic! Tend to the Hive and the captured hosts, make sure the Hive grows!"))
		arm_equipment(human, /datum/equipment_preset/synth/survivor/cultist_synth, TRUE, TRUE)
	else
		to_chat(human, SPAN_ROLE_HEADER("You are a xeno cultist! Follow the orders of the Queen Mother, the Queen, and your cult leader, in that order!"))
		arm_equipment(human, /datum/equipment_preset/other/xeno_cultist, TRUE, TRUE)
	print_backstory(human)

	addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(to_chat), human, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
