/datum/emergency_call/royal_marines/beacon
	name = "Royal Marines Commando (Squad) (Friendly)"
	mob_max = 6
	home_base = /datum/lazy_template/ert/twe_station
	shuttle_id = MOBILE_SHUTTLE_ID_ERT4
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_twe
	item_spawn = /obj/effect/landmark/ert_spawns/distress_twe/item

/datum/emergency_call/royal_marines/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is [pick_weight(list("HMS Patna"= 50, "HMS Thunderchild" = 50))]; we are responding to your call for reinforcements and sending aboard our forces. "
	objectives = "Ensure the survival of the [MAIN_SHIP_NAME], eliminate any hostiles, and assist the crew in any way possible."


/datum/emergency_call/royal_marines/create_member(datum/mind/spawning_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	spawning_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are an Officer in the Royal Marines Commando. Born in the Three World Empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/lieuteant/beacon, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a member of the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/standard/beacon, TRUE, TRUE)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/royal_marines/print_backstory(mob/living/carbon/human/spawning_mob)
	to_chat(spawning_mob, SPAN_BOLD("You were born in the Three World Empire to a [pick_weight(list("average" = 75, "poor" = 15, "well-established" = 10))] family."))
	to_chat(spawning_mob, SPAN_BOLD("Joining the Royal Marines gave you a lot of combat experience and useful skills."))
	to_chat(spawning_mob, SPAN_BOLD("You are [pick_weight(list("unaware" = 75, "faintly aware" = 15, "knoledgeable" = 10))] of the xenomorph threat."))
	to_chat(spawning_mob, SPAN_BOLD("You are a citizen of the three world empire and joined the Royal Marines Commando"))
	to_chat(spawning_mob, SPAN_BOLD("You are apart of a jointed UA/TWE taskforce onboard the HMS Patna and Thunderchild."))
	to_chat(spawning_mob, SPAN_BOLD("Under the directive of the RMC high command, you have been assisting USCM forces with maintaining peace in the area."))
	to_chat(spawning_mob, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))


/obj/effect/landmark/ert_spawns/distress_twe
	name = "Distress_TWE"

/obj/effect/landmark/ert_spawns/distress_twe/item
	name = "Distress_TWEItem"

