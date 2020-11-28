//Custom
/datum/emergency_call/custom
	mob_min = 0

	probability = 0
	hostility = FALSE

	var/list/players_to_offer = list()
	var/client/owner

	shuttle_id = null

	ert_message = "Several characters have been offered up to be played by the admins"

/datum/emergency_call/custom/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!players_to_offer.len)
		return // No more players

	var/mob/living/carbon/human/H = pick(players_to_offer)

	if(!H) // Something went wrong
		return

	M.transfer_to(H, TRUE)

	players_to_offer -= H

	return

/datum/emergency_call/custom/spawn_candidates(announce)
	. = ..()
	if(owner)
		for(var/mob/living/carbon/human/H in players_to_offer)
			owner.free_for_ghosts(H)