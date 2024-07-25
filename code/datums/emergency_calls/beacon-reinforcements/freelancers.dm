/datum/emergency_call/freelancer/beacon
	name = "Freelancer  Infantry (Squad) (Beacon)"
	mob_max = 8
	max_medics = 1
	mob_min = 1
	spawn_max_amount = TRUE

/datum/emergency_call/freelancer/beacon/New()
	. = ..()
	arrival_message = "[MAIN_SHIP_NAME], this is the Free Vessel Nellie. We'll take your contract for aid, coming soon."
	objectives = "Render assistance towards the USCM. You've already been paid by the ship's automated systems.."

/datum/emergency_call/freelancer/beacon/print_backstory(mob/living/carbon/human/spawning_mob)
	to_chat(spawning_mob, SPAN_BOLD("You started off in the Neroid Sector as a colonist seeking work at one of the established colonies."))
	to_chat(spawning_mob, SPAN_BOLD("The withdrawl of United American forces in the early 2180s, the system fell into disarray."))
	to_chat(spawning_mob, SPAN_BOLD("Taking up arms as a mercenary, the Freelancers have become a powerful force of order in the system."))
	to_chat(spawning_mob, SPAN_BOLD("While they are motivated primarily by money, many colonists see the Freelancers as the main forces of order in the Neroid Sector."))
	to_chat(spawning_mob, SPAN_BOLD("Ensure they are not destroyed."))


/datum/emergency_call/freelancer/beacon/create_member(datum/mind/spawning_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	spawning_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job && (spawning_mind)))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/other/freelancer/beacon, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are an independent warlord, operating outside any nation's jursdiction."))
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job && (spawning_mind)))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are an independent medic, operating as a mercenary for hire."))
		arm_equipment(mob, /datum/equipment_preset/other/freelancer/medic, TRUE, TRUE)
	else if(spawning_mind)
		to_chat(mob, SPAN_ROLE_HEADER("You are an independent mercenary, operating as a gun for hire."))
		arm_equipment(mob, /datum/equipment_preset/other/freelancer/beacon, TRUE, TRUE)

	print_backstory(mob)

	sleep(10)
	if(!mind)
		mob.free_for_ghosts()
	to_chat(mob, SPAN_BOLD("Objectives: [objectives]"))
