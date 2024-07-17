/mob/dead/observer/verb/donater_respawn()
	set name = "DRespawn"
	set desc = "Allow you to respawn"
	set category = "Ghost"

	if(!client.player_data.donator_info.patreon_function_available("respawn"))
		var/datum/view_record/discord_rank/discord_rank = GLOB.discord_ranks["3"]
		if(discord_rank)
			to_chat(usr, SPAN_NOTICE("You don't have enought donat level to do that, req [discord_rank.rank_name] or higher."))
		else
			to_chat(usr, SPAN_NOTICE("Currently inaccessible."))
		return FALSE

	var/remaining_time = timeofdeath + 30 MINUTES - world.time
	if(remaining_time > 0)
		to_chat(usr, SPAN_NOTICE("You still need wait [DisplayTimeText(remaining_time)] more to respawn."))
		return FALSE

	message_admins("[key_name_admin(src)] has their donater respawn time left and returned to lobby.")
	var/mob/new_player/NP = new()

	if(!mind)
		mind_initialize()

	mind.transfer_to(NP)

	qdel(src)
	return TRUE
