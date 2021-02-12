


//Randomly-equipped mercenaries. May be friendly or hostile to the USCM, hostile to xenos.
/datum/emergency_call/mercs
	name = "Freelancers (Squad)"
	mob_max = 8
	probability = 25


/datum/emergency_call/mercs/New()
	. = ..()
	hostility = pick(75;FALSE,25;TRUE)
	arrival_message = "[MAIN_SHIP_NAME], this is Freelancer shuttle MC-98 responding to your distress call. Prepare for boarding."
	if(hostility)
		objectives = "Ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way. Do what your Captain says. Ensure your survival at all costs."
	else
		objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment, and choose your payment well. Do what your Captain says. Ensure your survival at all costs."

/datum/emergency_call/mercs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("You started off in Tychon's Rift system as a colonist seeking work at one of the established colonies."))
	to_chat(H, SPAN_BOLD("The withdrawl of United American forces in the early 2180s, the system fell into disarray."))
	to_chat(H, SPAN_BOLD("Taking up arms as a mercenary, the Freelancers have become a powerful force of order in the system."))
	to_chat(H, SPAN_BOLD("While they are motivated primarily by money, many colonists see the Freelancers as the main forces of order in Tychon's Rift."))
	if(hostility)
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Despite this, you have been tasked to ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way.")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Any UPP, CLF or WY forces also responding are to be considered neutral parties unless proven hostile.")))
	else
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("To this end, you have been contacted by Weston-Yamada of the USCSS Royce to assist the [MAIN_SHIP_NAME]..")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Ensure they are not destroyed.</b>")))

/datum/emergency_call/mercs/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.name = H.real_name
	M.transfer_to(H, TRUE)
	H.job = "Mercenary"

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Freelancer (Leader)", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the Freelancer leader!"))

	else if(medics < max_medics)
		medics++
		arm_equipment(H, "Freelancer (Medic)", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Freelancer medic!"))
	else
		arm_equipment(H, "Freelancer (Standard)", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Freelancer mercenary!"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)




/datum/emergency_call/mercs/platoon
	name = "Freelancers (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_medics = 3