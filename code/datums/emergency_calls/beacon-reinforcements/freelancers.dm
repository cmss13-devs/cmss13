

/datum/emergency_call/freelancer/beacon
	name = "Freelancer (Beacon Reinforcements)"
	mob_max = 7
	mob_min = 1
	max_engineers = 1
	max_medics = 1
	spawn_max_amount = TRUE

/datum/emergency_call/freelancer/beacon/New()
	..()
	objectives = "Assist the USCM forces"
	arrival_message = "[MAIN_SHIP_NAME], this is the Free Vessel Nellie. We've accepted your contract for aid and are coming aboard. Jolly ho!"

/datum/emergency_call/freelancer/beacon/create_member(datum/mind/mind, turf/override_spawn_loc)
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
		announce_dchat("Some Freelancers were not taken, use the Join As Freed Mob verb to take one of them.")


	if(!leader && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, JOB_SQUAD_LEADER, time_required_for_job))))
		leader = human
		arm_equipment(human, /datum/equipment_preset/other/freelancer/beacon/leader, mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Warlord over your own mercenary band."))
	else if (medics < max_medics && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(human.client, JOB_SQUAD_MEDIC, time_required_for_job))))
		medics++
		arm_equipment(human, /datum/equipment_preset/other/freelancer/medic,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Medic within a mercenary band."))
	else
		arm_equipment(human, /datum/equipment_preset/other/freelancer/beacon,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Riflemen within a mercenary faction"))

	print_backstory(human)

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("Objectives: [objectives]"))

/datum/emergency_call/freelancer/beacon/print_backstory(mob/living/carbon/human/human)
	to_chat(human, SPAN_BOLD("You started off in the Neroid Sector as a colonist seeking work at one of the established colonies."))
	to_chat(human, SPAN_BOLD("The withdrawl of United American forces in the early 2180s, the system fell into disarray."))
	to_chat(human, SPAN_BOLD("Taking up arms as a mercenary, the Freelancers have become a powerful force of order in the system."))
	to_chat(human, SPAN_BOLD("While they are motivated primarily by money, many colonists see the Freelancers as the main forces of order in the Neroid Sector."))
