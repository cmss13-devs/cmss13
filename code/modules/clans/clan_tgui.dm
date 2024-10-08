/datum/yautja_panel
	var/client/linked_client
	var/current_clan_index = 0

	/// A list of all clan names, in the order they were populated.
	var/list/clan_name_to_index = list()
	/// A list of clan IDs, tied to the order the clan was populated.
	var/list/clan_index_to_id = list()

	/// The permissions of the panel user.
	var/user_rights = 0
	/// The ID of the user's clan.
	var/user_clan_id
	/// The rank held within the user's clan.
	var/user_clan_rank

	/// The currently selected clan's OD
	var/current_clan_id

	/// The global data.
	var/list/global_data
	/// Whether an early update of the global data is queued.
	var/early_queued = FALSE

GLOBAL_DATUM_INIT(yautja_clan_data, /datum/yautja_panel, new(init_global = TRUE))

/datum/yautja_panel/New(client/origin_client, init_global = FALSE)
	. = ..()
	if(origin_client)
		linked_client = origin_client
		user_rights = linked_client.clan_info.permissions
		user_clan_id = linked_client.clan_info.clan_id
		user_clan_rank = linked_client.clan_info.clan_rank
	if(init_global)
		addtimer(CALLBACK(src, PROC_REF(populate_global_clan_data), TRUE), 30 SECONDS)

/client
	var/datum/yautja_panel/yautja_panel

/client/verb/yautja_panel()
	set name = "Yautja Clan Panel"
	set category = "OOC.Records"

	if(!check_whitelist_status(WHITELIST_PREDATOR))
		return FALSE

	if(!GLOB.yautja_clan_data.global_data)
		to_chat(usr, SPAN_WARNING("Clan Data has not populated yet, please wait for up to 30 seconds."))
		return FALSE

	if(yautja_panel)
		qdel(yautja_panel)
	yautja_panel = new(src)
	yautja_panel.tgui_interact(mob)

/datum/yautja_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "YautjaClans", "Yautja Clan Panel")
		ui.open()

/datum/yautja_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/yautja_panel/ui_close(mob/user)
	. = ..()
	if(user?.client.yautja_panel)
		qdel(user.client.yautja_panel)

/datum/yautja_panel/vv_edit_var(var_name, var_value)
	return FALSE

/datum/yautja_panel/ui_data(mob/user)
	var/list/data = GLOB.yautja_clan_data.global_data

	data["current_clan_index"] = current_clan_index
	data["user_is_clan_leader"] = verify_clan_leader(current_clan_id)
	data["user_is_clan_elder"] = verify_clan_elder(current_clan_id)

	data["user_is_council"] = verify_council()
	data["user_is_superadmin"] = verify_superadmin()

	return data

/datum/yautja_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	var/data_reloader = TRUE

	if(action == "change_clan_list")
		var/selected_clan = params["selected_clan"]
		current_clan_index = GLOB.yautja_clan_data.clan_name_to_index[selected_clan]
		current_clan_id = index_to_id(current_clan_index)
		return TRUE

	if(!verify_clan_leader(current_clan_id))
		to_chat(user, SPAN_WARNING("You are not authorized to do this."))
		return FALSE

	var/datum/entity/clan_player/target_yautja
	var/datum/entity/player/target_player
	var/datum/entity/clan/target_clan
	var/target_ckey
	if(params["target_player"])
		target_yautja = GET_CLAN_PLAYER(params["target_player"])
		target_yautja.sync()

		target_player = DB_ENTITY(/datum/entity/player, target_yautja.player_id)
		target_player.sync()
		target_ckey = target_player.ckey


	if(params["target_clan"])
		target_clan = GET_CLAN(params["target_clan"])
		target_clan.sync()

	switch(action)
		if("clan_name")
			var/input = input(user, "Input the new name", "Set Name", target_clan.name) as text|null

			if(!input || input == target_clan.name)
				return

			message_admins("[key_name_admin(user)] has set the name of [target_clan.name] to [input].")
			to_chat(user, SPAN_NOTICE("Set the name of [target_clan.name] to [input]."))
			target_clan.name = trim(input)

		if("clan_desc")
			var/input = input(user, "Input a new description", "Set Description", target_clan.description) as message|null

			if(!input || input == target_clan.description)
				return

			message_admins("[key_name_admin(user)] has set the description of [target_clan.name].")
			to_chat(user, SPAN_NOTICE("Set the description of [target_clan.name]."))
			target_clan.description = trim(input)
			data_reloader = FALSE


		if("clan_color")
			data_reloader = FALSE
			var/color = input(user, "Input a new color", "Set Color", target_clan.color) as color|null

			if(!color)
				return

			target_clan.color = color
			message_admins("[key_name_admin(user)] has set the color of [target_clan.name] to [color].")
			to_chat(user, SPAN_NOTICE("Set the color of [target_clan.name] to [color]."))

		if("change_rank")
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == user_clan_id))
				to_chat(user, SPAN_WARNING("You cannot change this player, they are not in your clan!"))
				return
			if((target_yautja.permissions & CLAN_PERMISSION_ADMIN_MANAGER) || linked_client.clan_info.clan_rank <= target_yautja.clan_rank)
				to_chat(user, SPAN_WARNING("You can't target this person!"))
				return

			var/list/datum/yautja_rank/ranks = GLOB.clan_ranks.Copy()
			ranks -= CLAN_RANK_ADMIN // Admin rank should not and cannot be obtained from here

			var/datum/yautja_rank/chosen_rank
			if(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY, warn = FALSE))
				var/input = tgui_input_list(user, "Select the rank to change this user to.", "Select Rank", ranks)

				if(!input)
					return

				chosen_rank = ranks[input]

			else if(linked_client.has_clan_permission(CLAN_PERMISSION_USER_MODIFY, target_yautja.clan_id))
				for(var/rank in ranks)
					if(!linked_client.has_clan_permission(ranks[rank].permission_required, warn = FALSE))
						ranks -= rank

				var/input = tgui_input_list(user, "Select the rank to change this user to.", "Select Rank", ranks)

				if(!input)
					return

				chosen_rank = ranks[input]

				if(chosen_rank.limit_type)
					var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_AND(DB_COMP("clan_id", DB_EQUALS, target_yautja.clan_id), DB_COMP("rank", DB_EQUALS, GLOB.clan_ranks_ordered[input])))
					var/players_in_rank = length(CPV)

					switch(chosen_rank.limit_type)
						if(CLAN_LIMIT_NUMBER)
							if(players_in_rank >= chosen_rank.limit)
								to_chat(user, SPAN_DANGER("This slot is full! (Maximum of [chosen_rank.limit] slots)"))
								return
						if(CLAN_LIMIT_SIZE)
							var/list/datum/view_record/clan_playerbase_view/clan_players = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_COMP("clan_id", DB_EQUALS, target_yautja.clan_id))
							var/available_slots = ceil(length(clan_players) / chosen_rank.limit)

							if(players_in_rank >= available_slots)
								to_chat(user, SPAN_DANGER("This slot is full! (Maximum of [chosen_rank.limit] per player in the clan, currently [available_slots])"))
								return
			else
				return // Doesn't have permission to do this

			if(!linked_client.has_clan_permission(chosen_rank.permission_required)) // Double check
				return

			target_yautja.clan_rank = GLOB.clan_ranks_ordered[chosen_rank.name]
			target_yautja.permissions = chosen_rank.permissions
			message_admins("[key_name_admin(user)] has set the rank of [target_ckey] to [chosen_rank.name] for their clan.")
			to_chat(user, SPAN_NOTICE("Set [target_ckey]'s rank to [chosen_rank.name]"))

		if("assign_ancillary")
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == user_clan_id))
				to_chat(user, SPAN_WARNING("You cannot change this player, they are not in your clan!"))
				return

			var/list/datum/yautja_ancillary/ancillaries = GLOB.clan_ancillaries.Copy()
			var/datum/yautja_ancillary/chosen_ancillary
			if(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY, warn = FALSE))
				var/input = tgui_input_list(user, "Select the ancillary to change this user to.", "Select Ancillary", ancillaries)

				if(!input)
					return

				chosen_ancillary = ancillaries[input]

			else if(linked_client.has_clan_position(CLAN_RANK_ELDER, target_yautja.clan_id))
				for(var/ancillary in ancillaries)
					if(!linked_client.has_clan_position(ancillaries[ancillary].granter_title_required, warn = FALSE))
						ancillaries -= ancillary
					if(!target_yautja.can_be_ancillary(ancillaries[ancillary].target_rank_required, current_clan_id))
						ancillaries -= ancillary

				if(!ancillaries.len)
					to_chat(user, SPAN_WARNING("No possible ancillaries to grant!"))
					return

				var/input = tgui_input_list(user, "Select the ancillary to change this user to.", "Select Ancillary", ancillaries)

				if(!input)
					return

				chosen_ancillary = ancillaries[input]

				if(chosen_ancillary.limit_type)
					var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_AND(DB_COMP("clan_id", DB_EQUALS, target_yautja.clan_id), DB_COMP("rank", DB_EQUALS, GLOB.clan_ranks_ordered[input])))
					var/players_in_rank = length(CPV)

					switch(chosen_ancillary.limit_type)
						if(CLAN_LIMIT_NUMBER)
							if(players_in_rank >= chosen_ancillary.limit)
								to_chat(user, SPAN_DANGER("This slot is full! (Maximum of [chosen_ancillary.limit] slots)"))
								return
						if(CLAN_LIMIT_SIZE)
							var/list/datum/view_record/clan_playerbase_view/clan_players = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_COMP("clan_id", DB_EQUALS, target_yautja.clan_id))
							var/available_slots = ceil(length(clan_players) / chosen_ancillary.limit)

							if(players_in_rank >= available_slots)
								to_chat(user, SPAN_DANGER("This slot is full! (Maximum of [chosen_ancillary.limit] per player in the clan, currently [available_slots])"))
								return
			else
				return // Doesn't have permission to do this

			if(!linked_client.has_clan_position(chosen_ancillary.granter_title_required, target_yautja.clan_id)) // Double check
				return

			target_yautja.clan_ancillary = chosen_ancillary.name
			message_admins("[key_name_admin(user)] has set the ancillary title of [target_ckey] to [chosen_ancillary.name] for their clan.")
			to_chat(user, SPAN_NOTICE("Set [target_ckey]'s ancillary title to [chosen_ancillary.name]"))

		if("kick_from_clan")
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == user_clan_id))
				to_chat(user, SPAN_WARNING("You cannot kick this player, they are not in your clan!"))
				return
			target_yautja.clan_id = null
			target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]

			to_chat(user, SPAN_NOTICE("Kicked [target_ckey] from your clan."))
			message_admins("Yautja Clans: [key_name_admin(user)] has kicked [target_ckey] from their clan.")

		if("banish_from_clan")
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == user_clan_id))
				to_chat(user, SPAN_WARNING("You cannot banish this player, they are not in your clan!"))
				return
			var/reason = tgui_input_text(user, "Why do you wish to Banish this Yautja?", "Reason")
			if(!reason)
				return

			target_yautja.clan_id = get_clan_id("The Banished")
			target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]

			to_chat(user, SPAN_NOTICE("You have banished [target_ckey] from your clan."))
			message_admins("Yautja Clans: [key_name_admin(user)] has banished [target_ckey] from their clan for '[reason]'.")

		if("move_to_clan")
			if(!verify_council())
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

			var/new_clan = tgui_input_list(user, "Choose the clan to put them in", "Change player's clan", GLOB.yautja_clan_data.clan_name_to_index)
			if(!new_clan)
				return FALSE

			target_yautja.clan_id = get_clan_id(new_clan)

			to_chat(user, SPAN_NOTICE("Moved [target_ckey] to [new_clan]."))
			message_admins("Yautja Clans: [key_name_admin(user)] has moved [target_ckey] to clan [new_clan] ([target_yautja.clan_id]).")

			if(!(target_yautja.permissions & CLAN_PERMISSION_ADMIN_ANCIENT))
				target_yautja.permissions = GLOB.clan_ranks[CLAN_RANK_BLOODED].permissions
				target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]

		if("delete_player_data")
			if(!verify_superadmin())
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE
			to_chat(user, SPAN_WARNING("This command ([action]) is not yet functional."))

		if("delete_clan")
			if(!verify_superadmin())
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE
			to_chat(user, SPAN_WARNING("This command ([action]) is not yet functional."))

	if(data_reloader)
		GLOB.yautja_clan_data.queue_early_repopulate()
	else
		to_chat(user, SPAN_WARNING("The UI data will not be reloaded for this change, updates happen automatically every 30 minutes."))

	if(target_clan)
		target_clan.save()
		target_clan.sync()
	if(target_yautja)
		target_yautja.save()
		target_yautja.sync()

	return TRUE

/datum/yautja_panel/proc/get_clan_id(clan_name)
	var/index_holder = GLOB.yautja_clan_data.clan_name_to_index[clan_name]
	return index_to_id(index_holder)

/datum/yautja_panel/proc/index_to_id(clan_index)
	var/index_holder = "[clan_index]"
	return GLOB.yautja_clan_data.clan_index_to_id[index_holder]

/datum/yautja_panel/proc/verify_clan_leader(clan_id)
	if(user_rights & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	if((user_rights & CLAN_PERMISSION_USER_MODIFY) && (user_clan_id == clan_id))
		return TRUE
	return FALSE

/datum/yautja_panel/proc/verify_clan_elder(clan_id)
	if(verify_clan_leader(clan_id))
		return TRUE
	if(user_clan_rank >= CLAN_RANK_ELDER_INT)
		return TRUE
	return FALSE

/datum/yautja_panel/proc/verify_council()
	if(user_rights & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	return FALSE

/datum/yautja_panel/proc/verify_superadmin()
	if(user_rights & CLAN_PERMISSION_ADMIN_MANAGER)
		return TRUE
	return FALSE

/datum/yautja_panel/proc/queue_early_repopulate()
	if(early_queued)
		return FALSE

	early_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(populate_global_clan_data), FALSE, "early"), 5 MINUTES)
	message_admins("Yautja Clans: Global Data will early repopulate in 5 minutes.")
	return TRUE

/datum/yautja_panel/proc/populate_global_clan_data(start_timer = FALSE, type = "override")
	if(type == "early")
		early_queued = FALSE

	message_admins("Yautja Clans: Populating Global Data.")
	global_data = populate_clan_data()
	message_admins("Yautja Clans: Global Data has been populated.")
	if(start_timer)
		addtimer(CALLBACK(src, PROC_REF(populate_global_clan_data), TRUE, "regular"), 30 MINUTES)
		message_admins("Yautja Clans: Clan Global Data will repopulate in 30 minutes.")
	return "Populated"

/datum/yautja_panel/proc/populate_clan_data()
	clan_name_to_index = list("Clanless" = 0)
	clan_index_to_id = list("0" = 0)
	var/list/clan_names = list("Clanless")
	var/index = 1
	var/list/data = list()
	data["clans"] = list()

	data["clans"] += list(populate_clan("Clanless", null))
	var/list/datum/view_record/clan_view/clan_list = DB_VIEW(/datum/view_record/clan_view/)
	for(var/datum/view_record/clan_view/viewed_clan in clan_list)
		data["clans"] += list(populate_clan("[viewed_clan.name]", viewed_clan.clan_id))
		clan_index_to_id["[index]"] = viewed_clan.clan_id
		clan_name_to_index[viewed_clan.name] = index
		index++
		clan_names += viewed_clan.name

	data["clan_names"] = clan_names
	return data

/datum/yautja_panel/proc/populate_clan(clan_name, clan_to_format)
	var/list/data = list()

	var/datum/entity/clan/formatting_clan
	var/list/datum/view_record/clan_playerbase_view/clan_view
	var/clan_desc = "This is a list of players without a clan"
	if(clan_to_format)
		formatting_clan = GET_CLAN(clan_to_format)
		formatting_clan.sync()
		clan_desc = html_encode(formatting_clan.description)
		clan_view = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, clan_to_format))
	else
		clan_view = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_IS, null))

	var/list/members_list = list()
	for(var/datum/view_record/clan_playerbase_view/CP in clan_view)

		var/yautja = list()
		yautja["ckey"] = CP.ckey
		yautja["player_label"] = CP.ckey
		yautja["name"] = (CP.player_name? CP.player_name : "No Data")
		yautja["player_id"] = CP.player_id
		yautja["rank"] = GLOB.clan_ranks[CP.clan_rank]
		yautja["ancillary"] = (CP.clan_ancillary? CP.clan_ancillary : "None")

		var/datum/entity/player/player = get_player_from_key(CP.ckey)
		if(player.check_whitelist_status(WHITELIST_YAUTJA_LEADER))
			yautja["player_label"] = "[CP.ckey] (SENATOR)"
		else if(player.check_whitelist_status(WHITELIST_YAUTJA_COUNCIL))
			yautja["player_label"] = "[CP.ckey] (COUNCILLOR)"
		else if(player.check_whitelist_status(WHITELIST_YAUTJA_LEGACY))
			yautja["player_label"] = "[CP.ckey] (LEGACY)"

		members_list += list(yautja)

	data["label"] = clan_name
	data["desc"] = clan_desc
	data["color"] = (formatting_clan?.color? formatting_clan.color : "#ffffff")
	data["members"] = members_list
	if(clan_to_format)
		data["clan_id"] = clan_to_format

	return data
