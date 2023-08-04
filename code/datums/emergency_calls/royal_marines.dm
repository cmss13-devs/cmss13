/datum/emergency_call/royal_marines
	name = "Royal Marines Commando (Squad) (Friendly)"
	mob_max = 7
	probability = 20
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_twe
	item_spawn = /obj/effect/landmark/ert_spawns/distress_twe/item
	max_engineers =  0
	max_medics = 0
	max_heavies = 3
	var/max_synths = 1
	var/synths = 1


/datum/emergency_call/royal_marines/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is [pick(50;"HMS Patna", 50;"HMS Thunderchild",)]; we are responding to your distress call and boarding in accordance with the Military Aid Act of 2177, authenticication code Lima-18153. "
	objectives = "Ensure the survival of the [MAIN_SHIP_NAME], eliminate any hostiles, and assist the crew in any way possible."


/datum/emergency_call/royal_marines/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are an Officer in the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/team_leader, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a skilled marksman in the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/spec/marksman, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Smartgunner in the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/spec/machinegun, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a CQB Specialist in the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/spec/breacher, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/royal_marines/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You were born in the Three World Empire to a [pick(75;"average", 15;"poor", 10;"well-established")] family."))
		to_chat(M, SPAN_BOLD("Joining the Royal Marines gave you a lot of combat experience and useful skills."))
	else
		to_chat(M, SPAN_BOLD("You were brought online in a Tokyo lab."))
		to_chat(M, SPAN_BOLD("You were programmed with all of the medical and engineering knowledge a military fighting force support asset required."))
		to_chat(M, SPAN_BOLD("You were soon after assigned to a royal marine base on mars to act as support personnel."))
		to_chat(M, SPAN_BOLD("Some months after your assignment, you were reassigned to the USCSS Inheritor, a VAI transport vessel."))
	to_chat(M, SPAN_BOLD("You are [pick(80;"unaware", 15;"faintly aware", 5;"knowledgeable")] of the xenomorph threat."))
	to_chat(M, SPAN_BOLD("You are a citizen of the three world empire and joined the Royal Marines Commando"))
	to_chat(M, SPAN_BOLD("You are apart of a jointed UA/TWE taskforce onboard the HMS Patna and Thunderchild."))
	to_chat(M, SPAN_BOLD("Under the directive of the RMC high command, you have been assisting USCM forces with maintaining peace in the area."))
	to_chat(M, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))


/datum/emergency_call/royal_marines/platoon
	name = "Royal Marines Commando (Platoon) (Friendly)"
	mob_min = 7
	mob_max = 28
	probability = 0
	max_medics = 0
	max_heavies = 6
	max_engineers = 0
	max_synths = 2

/obj/effect/landmark/ert_spawns/distress_twe
	name = "Distress_TWE"

/obj/effect/landmark/ert_spawns/distress_twe/item
	name = "Distress_TWEItem"
