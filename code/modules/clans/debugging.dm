/client/proc/yautja_debug_reset_clan()
	set name = "Reset Yautja Clan"
	set category = "Debug.Yautja"

	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED

	var/target_key = tgui_input_text(src, "Please input the target ckey.", "Target Player")
	if(!target_key)
		return FALSE

	var/datum/entity/player/player_entity = get_player_from_key(target_key)
	var/datum/entity/clan_player/player_info = GET_CLAN_PLAYER(player_entity.id)
	player_info.sync()

	var/datum/entity/clan/owner_clan = GET_CLAN(player_info.clan_id)
	owner_clan.sync()

	to_chat(src, SPAN_WARNING("DEBUG YAUTJA: Clan ID - [player_info.clan_id]"))
	to_chat(src, SPAN_WARNING("DEBUG YAUTJA: Clan Name - [owner_clan.name]"))

	if(!(tgui_alert(src, "Confirm Reset Clan", "Confirmation", list("Yes","No")) == "Yes"))
		return FALSE

	player_info.clan_id = null
	player_info.permissions = GLOB.clan_ranks[CLAN_RANK_UNBLOODED].permissions
	player_info.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_UNBLOODED]

	player_info.save()
	player_info.sync()
	to_chat(src, SPAN_WARNING("DEBUG YAUTJA: Clan Reset"))
	message_admins("[key_name_admin(src)] has reset [target_key]'s Yautja Clan.")
	return TRUE

/client/proc/yautja_debug_force_clan()
	set name = "Force Yautja Clan"
	set category = "Debug.Yautja"
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED

	var/target_key = tgui_input_text(src, "Please input the target ckey.", "Target Player")
	if(!target_key)
		return FALSE

	var/datum/entity/player/player_entity = get_player_from_key(target_key)
	var/datum/entity/clan_player/player_info = GET_CLAN_PLAYER(player_entity.id)
	player_info.sync()

	var/datum/entity/clan/owner_clan = GET_CLAN(player_info.clan_id)
	owner_clan.sync()

	to_chat(src, SPAN_WARNING("DEBUG YAUTJA: Clan ID - [player_info.clan_id]"))
	to_chat(src, SPAN_WARNING("DEBUG YAUTJA: Clan Name - [owner_clan.name]"))

	var/list/clans = list()
	var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)
	for(var/datum/view_record/clan_view/CV in CPV)
		clans += list("[CV.name]" = CV.clan_id)

	var/input = tgui_input_list(src, "Choose the clan to put them in", "Change player's clan", clans)
	if(!input)
		return FALSE

	to_chat(src, SPAN_WARNING("Moved [target_key] to [input]."))
	message_admins("[key_name_admin(src)] has force-moved [target_key] to clan [input].")

	player_info.clan_id = clans[input]

	if(!(player_info.permissions & CLAN_PERMISSION_ADMIN_ANCIENT))
		player_info.permissions = GLOB.clan_ranks[CLAN_RANK_BLOODED].permissions
		player_info.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]

	player_info.save()
	player_info.sync()
