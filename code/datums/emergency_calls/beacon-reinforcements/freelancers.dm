


//Randomly-equipped mercenaries. May be friendly or hostile to the USCM, hostile to xenos.
/datum/emergency_call/mercs
	name = "Freelancers (Squad)"
	mob_max = 6


/datum/emergency_call/mercs/New()
	. = ..()
	hostility = pick(75;FALSE,25;TRUE)
	arrival_message = "[MAIN_SHIP_NAME], this is Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	if(hostility)
		objectives = "Ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way. Do what your Warlord says. Ensure your survival at all costs."
	else
		objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment, and choose your payment well. Do what your Warlord says. Ensure your survival at all costs."

/datum/emergency_call/mercs/friendly //if admins want to specifically call in friendly ones
	name = "Friendly Freelancers (Squad)"
	mob_max = 8
	probability = 0

/datum/emergency_call/mercs/friendly/New()
	. = ..()
	hostility = FALSE
	arrival_message = "[MAIN_SHIP_NAME], this is Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your call for reinforcements."
	objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment you've received from ARES. Do what your Warlord says. Ensure your survival at all costs."


/datum/emergency_call/mercs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("You started off in the Neroid Sector as a colonist seeking work at one of the established colonies."))
	to_chat(H, SPAN_BOLD("The withdrawl of United American forces in the early 2180s, the system fell into disarray."))
	to_chat(H, SPAN_BOLD("Taking up arms as a mercenary, the Freelancers have become a powerful force of order in the system."))
	to_chat(H, SPAN_BOLD("While they are motivated primarily by money, many colonists see the Freelancers as the main forces of order in the Neroid Sector."))
	to_chat(H, SPAN_NOTICE(SPAN_BOLD("To this end, you have been contacted by ARES, the Almayer's ship AI with payment to help with the operation")))
	to_chat(H, SPAN_NOTICE(SPAN_BOLD("Ensure they are not destroyed.</b>")))

/datum/emergency_call/mercs/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.name = H.real_name
	M.transfer_to(H, TRUE)
	H.job = "Mercenary"

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/other/freelancer/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the Freelancer leader!"))
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/other/freelancer/medic, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Freelancer Medic!"))
	else
		arm_equipment(H, /datum/equipment_preset/other/freelancer/standard, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Freelancer Mercenary!"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
