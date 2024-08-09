

/datum/emergency_call/rmc/beacon
	name = "RMC (Beacon Reinforcements)"
	mob_max = 7
	mob_min = 1
	max_engineers = 1
	max_medics = 1
	spawn_max_amount = TRUE

/datum/emergency_call/rmc/beacon/New()
	..()
	objectives = "Assist the USCM forces"
	arrival_message = "[MAIN_SHIP_NAME], this is the HMS Thames of the Three World Empires. We've received your call and are enroute to aid per the C2 Collaborative Defense Agreement."

/datum/emergency_call/rmc/beacon/create_member(datum/mind/mind, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/human = new(spawn_loc)

	if(mind)
		mind.transfer_to(human, TRUE)
	else
		human.create_hud()

	if(mob_max > length(members))
		announce_dchat("Some Commandos were not taken, use the Join As Freed Mob verb to take one of them.")


	if(!leader && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, JOB_SQUAD_LEADER, time_required_for_job))))
		leader = human
		arm_equipment(human, /datum/equipment_preset/twe/royal_marine/beacon/leader, mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Officer in the RMC"))
	else
		arm_equipment(human, /datum/equipment_preset/twe/royal_marine/beacon/standard,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Rifleman in the RMC"))

	print_backstory(human)

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("Objectives: [objectives]"))

/datum/emergency_call/rmc/beacon/print_backstory(mob/living/carbon/human/human)
	to_chat(human, SPAN_BOLD("You were born in the Three World Empire to a [pick_weight(list("average" = 75, "poor" = 15, "well-established" = 10))] family."))
	to_chat(human, SPAN_BOLD("Joining the Royal Marines gave you a lot of combat experience and useful skills."))
	to_chat(human, SPAN_BOLD("You are [pick_weight(list("unaware" = 75, "faintly aware" = 15, "knoledgeable" = 10))] of the xenomorph threat."))
	to_chat(human, SPAN_BOLD("You are a citizen of the three world empire and joined the Royal Marines Commando"))
	to_chat(human, SPAN_BOLD("You are apart of a jointed UA/TWE taskforce onboard the HMS Patna and Thunderchild."))
	to_chat(human, SPAN_BOLD("Under the directive of the RMC high command, you have been assisting USCM forces with maintaining peace in the area."))
	to_chat(human, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))
