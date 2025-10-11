//Custom
/datum/emergency_call/custom
	mob_min = 0

	probability = 0
	hostility = FALSE

	var/list/players_to_offer = list()
	var/client/owner

	shuttle_id = null

	ert_message = "Several characters have been offered up to be played by the admins"

/datum/emergency_call/custom/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!length(players_to_offer))
		return // No more players

	var/mob/living/carbon/human/H = pick(players_to_offer)

	if(!H) // Something went wrong
		return

	M.transfer_to(H, TRUE)

	players_to_offer -= H

	return

/datum/emergency_call/custom/spawn_candidates(announce, override_spawn_loc, delete_mindless_mobs = FALSE)
	. = ..()
	if(delete_mindless_mobs)
		delete_mindless_mobs()
	else
		offer_mobs_for_ghosts()

/datum/emergency_call/custom/proc/offer_mobs_for_ghosts()
	if(owner)
		for(var/mob/living/carbon/human/H in players_to_offer)
			owner.free_for_ghosts(H)

/datum/emergency_call/custom/proc/delete_mindless_mobs()
	var/count_mob_deleted = 0
	for(var/player in players_to_offer)
		if(!ismob(player))
			continue
		var/mob/spawned_mob = player
		if(spawned_mob.mind)
			continue
		qdel(spawned_mob)
		count_mob_deleted++

	message_admins("After ERT spawn as [name], [count_mob_deleted] out of [mob_max] mindless mobs were removed.")
