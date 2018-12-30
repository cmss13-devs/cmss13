

//Blank colonist ERT for admin stuff.
/datum/emergency_call/colonist
	name = "Colonists"
	mob_max = 8
	mob_min = 1
	arrival_message = "Incoming Transmission: 'This is the *static*. We are *static*.'"
	objectives = "Follow the orders given to you."
	probability = 0


/datum/emergency_call/colonist/create_member(datum/mind/M) //Blank ERT with only basic items.
	set waitfor = 0
	var/turf/T = get_spawn_point()
	var/mob/original = M.current

	if(!istype(T)) r_FAL

	var/mob/living/carbon/human/H = new(T)
	H.dna.ready_dna(H)
	H.key = M.key
	if(H.client) H.client.change_view(world.view)
	ticker.mode.traitors += H.mind
	H.arm_equipment(H, "Colonist", TRUE)

	sleep(20)
	if(H && H.loc)
		H << "<span class='role_header'>You are a colonist!</span>"
		H << "<span class='role_body'>You have been put into the game by a staff member. Please follow all staff instructions.</span>"

	if(original && original.loc) cdel(original)