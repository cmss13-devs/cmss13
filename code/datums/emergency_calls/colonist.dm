

//Blank colonist ERT for admin stuff.
/datum/emergency_call/colonist
	name = "Colonists"
	mob_max = 8
	mob_min = 1
	arrival_message = "Incoming Transmission: 'This is the *static*. We are *static*.'"
	objectives = "Follow the orders given to you."
	probability = 0
	var/preset = "Colonist"


/datum/emergency_call/colonist/create_member(datum/mind/M) //Blank ERT with only basic items.
	set waitfor = 0
	var/turf/T = get_spawn_point()

	if(!istype(T)) 
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	H.key = M.key
	if(H.client) H.client.change_view(world_view_size)
	ticker.mode.traitors += H.mind
	arm_equipment(H, preset, TRUE, TRUE)

	sleep(20)
	if(H && H.loc)
		to_chat(H, SPAN_ROLE_HEADER("You are a colonist!"))
		to_chat(H, SPAN_ROLE_BODY("You have been put into the game by a staff member. Please follow all staff instructions."))

/datum/emergency_call/colonist/engineers
	name = "Colonists - Engineers"
	preset = "Colonist - Engineer"

/datum/emergency_call/colonist/security
	name = "Colonists - Security"
	preset = "Colonist - Security"

/datum/emergency_call/colonist/doctors
	name = "Colonists - Doctors"
	preset = "Colonist - Doctor"