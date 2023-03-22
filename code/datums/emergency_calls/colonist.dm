

//Blank colonist ERT for admin stuff.
/datum/emergency_call/colonist
	name = "Colonists"
	mob_max = 8
	mob_min = 1
	arrival_message = "Incoming Transmission: 'This is the *static*. We are *static*.'"
	objectives = "Follow the orders given to you."
	probability = 0
	var/preset = /datum/equipment_preset/colonist


/datum/emergency_call/colonist/create_member(datum/mind/M, turf/override_spawn_loc) //Blank ERT with only basic items.
	set waitfor = 0
	var/turf/current_turf = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(current_turf))
		return FALSE

	var/mob/living/carbon/human/human = new(current_turf)
	M.transfer_to(human, TRUE)
	arm_equipment(human, preset, TRUE, TRUE)

	sleep(20)
	if(human && human.loc)
		to_chat(human, SPAN_ROLE_HEADER("You are a colonist!"))
		to_chat(human, SPAN_ROLE_BODY("You have been put into the game by a staff member. Please follow all staff instructions."))

/datum/emergency_call/colonist/engineers
	name = "Colonists - Engineers"
	preset = /datum/equipment_preset/colonist/engineer

/datum/emergency_call/colonist/security
	name = "Colonists - Security"
	preset = /datum/equipment_preset/colonist/security

/datum/emergency_call/colonist/doctors
	name = "Colonists - Doctors"
	preset = /datum/equipment_preset/colonist/doctor
