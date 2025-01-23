/datum/faction/zombie
	name = "Zombie Horde"
	desc = "Unknow virus that makes all dead rise back and fight, for additional information required access 6X-X / XC-X or higher..."
	code_identificator = FACTION_ZOMBIE

	relations_pregen = RELATIONS_MAP_HOSTILE

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/zombie

/datum/faction/zombie/get_join_status(mob/user, dat)
	if(!user.client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	var/list/zombie_list = list()
	if(length(GLOB.zombie_landmarks))
		zombie_list += list("Underground Zombie" = "Underground Zombie")

	for(var/mob/living/carbon/human/A in GLOB.zombie_list)
		if(!A.client && A.stat != DEAD) // Only living zombies
			zombie_list += list(A.real_name = A)

	if(!length(zombie_list))
		to_chat(src, SPAN_DANGER("There are no available zombies."))
		return

	var/choice = tgui_input_list(usr, "Pick a Zombie:", "Join as Zombie", zombie_list)
	if(!choice)
		return

	if(!user.client || !user.mind)
		return

	if(choice == "Underground Zombie")
		if(!length(GLOB.zombie_landmarks))
			to_chat(src, SPAN_WARNING("Sorry, the last underground zombie just got taken."))
			return

		var/obj/effect/landmark/zombie/spawn_point = pick(GLOB.zombie_landmarks)
		spawn_point.spawn_zombie(src)
		return

	var/mob/living/carbon/human/Z = zombie_list[choice]

	if(!Z || QDELETED(Z))
		return

	if(Z.stat == DEAD)
		to_chat(src, SPAN_WARNING("This zombie is dead!"))
		return

	if(Z.client)
		to_chat(src, SPAN_WARNING("That player is still connected."))
		return

	user.mind.transfer_to(Z, TRUE)
	msg_admin_niche("[key_name(usr)] has joined as a [Z].")
