SUBSYSTEM_DEF(yautja_panel)
	name = "Yautja Panel"
	wait = 30 MINUTES
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	/// A list of all clan names, in the order they were populated.
	var/list/clan_name_to_index = list()
	/// A list of clan IDs, tied to the order the clan was populated.
	var/list/clan_index_to_id = list()

	/// The global data.
	var/list/global_data

	/// Whether global data is reloading or not.
	var/reloading_data = FALSE

/datum/controller/subsystem/yautja_panel/fire(resumed)
	reloading_data = TRUE
	global_data = populate_clan_data()
	reloading_data = FALSE

/client/verb/yautja_panel()
	set name = "Yautja Clan Panel"
	set category = "OOC.Whitelist"

	if(!check_whitelist_status(WHITELIST_PREDATOR))
		return FALSE

	if(!SSyautja_panel.global_data)
		to_chat(usr, SPAN_WARNING("Clan Data has not populated yet, please wait for up to 30 seconds."))
		return FALSE

	if(SSyautja_panel.reloading_data)
		to_chat(usr, SPAN_WARNING("Clan Data is currently reloading, please wait for up to 30 seconds."))
		return FALSE

	SSyautja_panel.tgui_interact(mob)

/datum/controller/subsystem/yautja_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "YautjaClans", "Yautja Clan Panel")
		ui.open()

/datum/controller/subsystem/yautja_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/controller/subsystem/yautja_panel/vv_edit_var(var_name, var_value)
	return FALSE

/datum/controller/subsystem/yautja_panel/ui_data(mob/user)
	var/list/data = global_data

	data["user_clan_rank"] = user.client.clan_info.clan_rank
	data["user_clan_id"] = user.client.clan_info.clan_id

	data["user_is_council"] = verify_council(user)
	data["user_is_superadmin"] = verify_superadmin(user)

	return data

/datum/controller/subsystem/yautja_panel/ui_static_data(mob/user)
	. = ..()

	.["clan_elder_rank"] = GLOB.clan_ranks_ordered[CLAN_RANK_ELDER]
	.["clan_leader_rank"] = GLOB.clan_ranks_ordered[CLAN_RANK_LEADER]

/datum/controller/subsystem/yautja_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	var/client/linked_client = user.client
	if(!global_data || reloading_data)
		ui.close()
		to_chat(user, SPAN_WARNING("Clan Data is missing or being reloaded, please re-open the UI later."))
		return
	var/data_reloader = TRUE

	var/current_clan_id = params["target_clan"]

	if(!verify_clan_elder(user, current_clan_id))
		to_chat(user, SPAN_WARNING("You are not authorized to do this."))
		return FALSE

	var/datum/entity/clan_player/target_yautja
	var/datum/entity/player/target_player
	var/datum/entity/clan/target_clan
	var/forbid_yautja_save = FALSE
	var/forbid_clan_save = FALSE
	var/target_ckey
	if(params["target_player"])
		target_yautja = GET_CLAN_PLAYER(params["target_player"])
		target_yautja.sync()

		log_debug("Yautja Clans: Selected Player Clan ID: [target_yautja.clan_id]")

		target_player = DB_ENTITY(/datum/entity/player, target_yautja.player_id)
		target_player.sync()
		target_ckey = target_player.ckey

		if(!verify_superadmin(user) && (target_ckey == user.ckey))
			to_chat(user, SPAN_WARNING("You cannot edit yourself!"))
			return FALSE


	if(current_clan_id)
		target_clan = GET_CLAN(current_clan_id)
		target_clan.sync()

		// ------------- CLAN ELDER+ ONLY ACTION ------------- \\

	if(action == "assign_ancillary")
		if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)))
			if(!(target_yautja.clan_id == current_clan_id))
				to_chat(user, SPAN_WARNING("You cannot assign an ancillary title to this player, they are not in your clan!"))
				log_debug("Target Clan: [target_yautja.clan_id], Needed Clan: [current_clan_id]")
				return

		var/list/datum/yautja_ancillary/ancillaries = GLOB.clan_ancillaries.Copy()

		var/datum/yautja_ancillary/chosen_ancillary
		if(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY, warn = FALSE))
			var/input = tgui_input_list(user, "Select the ancillary to change this user to.", "Select Ancillary", ancillaries)

			if(!input)
				log_debug("Yautja Clans: Input Check failed.")
				return

			chosen_ancillary = ancillaries[input]

		else if(linked_client.has_clan_position(CLAN_RANK_ELDER_INT, current_clan_id, TRUE))
			for(var/ancillary in ancillaries)
				if(!linked_client.has_clan_position(ancillaries[ancillary].granter_title_required, warn = FALSE))
					ancillaries -= ancillary
				//if(!target_yautja.can_be_ancillary(ancillaries[ancillary].target_rank_required, current_clan_id))
				//	ancillaries -= ancillary

			if(!ancillaries.len)
				to_chat(user, SPAN_WARNING("No possible ancillaries to grant!"))
				return

			var/input = tgui_input_list(user, "Select the ancillary to change this user to.", "Select Ancillary", ancillaries)

			if(!input)
				log_debug("Yautja Clans: Input Check failed.")
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
			log_debug("Yautja Clans: X Check failed.")
			return // Doesn't have permission to do this

		if(!linked_client.has_clan_position(chosen_ancillary.granter_title_required, target_yautja.clan_id)) // Double check
			log_debug("Yautja Clans: Double Check failed.")
			return

		target_yautja.clan_ancillary = chosen_ancillary.name
		message_admins("[key_name_admin(user)] has set the ancillary title of [target_ckey] to [chosen_ancillary.name] for their clan.")
		to_chat(user, SPAN_NOTICE("Set [target_ckey]'s ancillary title to [chosen_ancillary.name]"))


	// ------------- CLAN LEADER ONLY ACTIONS ------------- \\

	if(!verify_clan_leader(user, current_clan_id))
		to_chat(user, SPAN_WARNING("You are not authorized to do this."))
		return FALSE

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
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == current_clan_id))
				to_chat(user, SPAN_WARNING("You cannot change the rank of this player, they are not in your clan!"))
				log_debug("Target Clan: [target_yautja.clan_id], Needed Clan: [current_clan_id]")
				return
			if(!verify_superadmin(user) && ((target_yautja.permissions & CLAN_PERMISSION_ADMIN_MANAGER) || (linked_client.clan_info.clan_rank <= target_yautja.clan_rank)))
				to_chat(user, SPAN_WARNING("You can't target this person!"))
				return
			if(!target_yautja.clan_id)
				to_chat(src, SPAN_WARNING("This player doesn't belong to a clan!"))
				return

			var/list/datum/yautja_rank/ranks = GLOB.clan_ranks.Copy()
			if(!verify_superadmin(user))
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

		if("kick_from_clan")
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == current_clan_id))
				to_chat(user, SPAN_WARNING("You cannot kick this player, they are not in your clan!"))
				log_debug("Target Clan: [target_yautja.clan_id], Needed Clan: [current_clan_id]")
				return
			target_yautja.clan_id = null
			target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]

			to_chat(user, SPAN_NOTICE("Kicked [target_ckey] from your clan."))
			message_admins("Yautja Clans: [key_name_admin(user)] has kicked [target_ckey] from their clan.")

		if("banish_from_clan")
			if(!(linked_client.has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY)) && !(target_yautja.clan_id == current_clan_id))
				to_chat(user, SPAN_WARNING("You cannot banish this player, they are not in your clan!"))
				log_debug("Target Clan: [target_yautja.clan_id], Needed Clan: [current_clan_id]")
				return
			var/reason = tgui_input_text(user, "Why do you wish to Banish this Yautja?", "Reason")
			if(!reason)
				return

			target_yautja.clan_id = get_clan_id("The Banished")
			target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]

			to_chat(user, SPAN_NOTICE("You have banished [target_ckey] from your clan."))
			message_admins("Yautja Clans: [key_name_admin(user)] has banished [target_ckey] from their clan for '[reason]'.")

		if("move_to_clan")
			if(!verify_council(user))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

			var/new_clan = tgui_input_list(user, "Choose the clan to put them in", "Change player's clan", clan_name_to_index)
			if(!new_clan)
				return FALSE

			if(new_clan == CLAN_NAME_CLANLESS)
				target_yautja.clan_id = null
				target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]
				early_conclude_data_act(target_clan, target_yautja)
				to_chat(user, SPAN_NOTICE("Moved [target_ckey] to the Clanless list."))
				message_admins("Yautja Clans: [key_name_admin(user)] has moved [target_ckey] to the Clanless list.")
				return TRUE

			target_yautja.clan_id = get_clan_id(new_clan)

			to_chat(user, SPAN_NOTICE("Moved [target_ckey] to [new_clan]."))
			message_admins("Yautja Clans: [key_name_admin(user)] has moved [target_ckey] to clan [new_clan] ([target_yautja.clan_id]).")

			if(!(target_yautja.permissions & CLAN_PERMISSION_ADMIN_ANCIENT))
				target_yautja.permissions = GLOB.clan_ranks[CLAN_RANK_BLOODED].permissions
				target_yautja.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_BLOODED]
			target_yautja.clan_ancillary = "None"

		if("delete_player_data")
			if(!verify_superadmin(user))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

			var/typeout = target_ckey
			if(!typeout)
				typeout = "null"

			var/input = tgui_input_text(user, "Are you sure you want to purge this person? Type '[typeout]' to purge", "Confirm Purge")


			if(!input || input != typeout)
				to_chat(user, "You have decided not to delete [typeout].")
				return FALSE

			message_admins("[key_name_admin(user)] has purged [typeout]'s clan profile.")
			to_chat(user, SPAN_NOTICE("You have purged [typeout]'s clan profile."))

			target_yautja.delete()

			if(target_player.owning_client)
				target_player.owning_client.clan_info = null
			forbid_yautja_save = TRUE

		if("create_new_clan")
			if(!verify_superadmin(user))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

			var/new_clan_name = tgui_input_text(user, "Please input the name of the clan to proceed. (Include 'Clan' as a prefix)", "New Clan")
			if(!new_clan_name)
				to_chat(user, SPAN_WARNING("No clan name detected."))
				return FALSE

			create_new_clan(new_clan_name)
			message_admins("[key_name_admin(user)] has made a new Yautja clan, [new_clan_name].")
			to_chat(user, SPAN_NOTICE("You have created a new clan, [new_clan_name]."))

		if("delete_clan")
			if(!verify_superadmin(user))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

			var/input = tgui_input_text(user, "Please input the name of the clan to proceed.", "Delete Clan")
			if(input != target_clan.name)
				to_chat(user, "You have decided not to delete [target_clan.name].")
				return FALSE

			delete_clan(target_clan.id)
			message_admins("[key_name_admin(user)] has deleted the clan [target_clan.name].")
			to_chat(user, SPAN_NOTICE("You have deleted [target_clan.name]."))

	if(data_reloader)
		fire()
	else
		to_chat(user, SPAN_WARNING("The UI data will not be reloaded for this change, updates happen automatically every 30 minutes."))

	if(target_clan && !forbid_clan_save)
		target_clan.save()
		target_clan.sync()
	if(target_yautja && !forbid_yautja_save)
		target_yautja.save()
		target_yautja.sync()

	return TRUE

/datum/controller/subsystem/yautja_panel/proc/populate_clan_data()
	clan_name_to_index = list(CLAN_NAME_CLANLESS = 1)
	clan_index_to_id = list("1" = null)
	var/list/clan_names = list(CLAN_NAME_CLANLESS)
	var/index = 2
	var/list/data = list()
	data["clans"] = list()

	data["clans"] += list(populate_clan(CLAN_NAME_CLANLESS, null))
	var/list/datum/view_record/clan_view/clan_list = DB_VIEW(/datum/view_record/clan_view/)
	for(var/datum/view_record/clan_view/viewed_clan in clan_list)
		data["clans"] += list(populate_clan("[viewed_clan.name]", viewed_clan.clan_id))
		clan_index_to_id["[index]"] = viewed_clan.clan_id
		clan_name_to_index[viewed_clan.name] = index
		index++
		clan_names += viewed_clan.name

	data["clan_names"] = clan_names
	return data

/datum/controller/subsystem/yautja_panel/proc/populate_clan(clan_name, clan_to_format)
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
		yautja["clan_id"] = (CP.clan_id)

		var/datum/entity/player/player = get_player_from_key(CP.ckey)
		if(player.check_whitelist_status(WHITELIST_PREDATOR))
			yautja["active_whitelist"] = TRUE
		else
			yautja["active_whitelist"] = FALSE
			yautja["player_label"] = "[CP.ckey] (DEWHITELISTED)"

		if(player.check_whitelist_status(WHITELIST_YAUTJA_LEGACY))
			yautja["player_label"] = "[CP.ckey] (LEGACY)"
			yautja["is_legacy"] = TRUE

		if(player.check_whitelist_status(WHITELIST_YAUTJA_LEADER))
			yautja["player_label"] = "[CP.ckey] (SENATOR)"
		else if(player.check_whitelist_status(WHITELIST_YAUTJA_COUNCIL))
			yautja["player_label"] = "[CP.ckey] (COUNCILLOR)"

		members_list += list(yautja)

	data["label"] = clan_name
	data["desc"] = clan_desc
	data["color"] = (formatting_clan?.color? formatting_clan.color : "#ffffff")
	data["members"] = members_list
	if(clan_to_format)
		data["clan_id"] = clan_to_format

	return data

/datum/controller/subsystem/yautja_panel/proc/delete_clan(target_id)
	if(IsAdminAdvancedProcCall())
		alert_proccall("yautja clan delete")
		return PROC_BLOCKED

	var/datum/entity/clan/target_clan
	target_clan = GET_CLAN(target_id)
	target_clan.sync()

	var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, target_id))

	for(var/datum/view_record/clan_playerbase_view/CP in CPV)
		var/datum/entity/clan_player/pl = DB_EKEY(/datum/entity/clan_player/, CP.player_id)
		pl.sync()

		pl.clan_id = null
		pl.permissions = GLOB.clan_ranks[CLAN_RANK_UNBLOODED].permissions
		pl.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_UNBLOODED]

		pl.save()

	target_clan.delete()

/datum/controller/subsystem/yautja_panel/proc/early_conclude_data_act(datum/entity/clan/target_clan, datum/entity/clan_player/target_yautja)
	fire()

	if(target_clan)
		target_clan.save()
		target_clan.sync()

	if(target_yautja)
		target_yautja.save()
		target_yautja.sync()

/datum/controller/subsystem/yautja_panel/proc/get_clan_id(clan_name)
	var/index_holder = clan_name_to_index[clan_name]
	return index_to_id(index_holder)

/datum/controller/subsystem/yautja_panel/proc/index_to_id(clan_index)
	var/index_holder = "[clan_index]"
	return clan_index_to_id[index_holder]

/datum/controller/subsystem/yautja_panel/proc/verify_clan_leader(mob/user, clan_id)
	var/user_rights = user.client.clan_info.permissions

	if(user_rights & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	if((user_rights & CLAN_PERMISSION_USER_MODIFY) && (user.client.clan_info.clan_id == clan_id))
		return TRUE
	return FALSE

/datum/controller/subsystem/yautja_panel/proc/verify_clan_elder(mob/user, clan_id)
	if(verify_clan_leader(user, clan_id))
		return TRUE
	if(user.client.clan_info.clan_rank >= CLAN_RANK_ELDER_INT)
		return TRUE
	return FALSE

/datum/controller/subsystem/yautja_panel/proc/verify_council(mob/user)
	var/user_rights = user.client.clan_info.permissions

	if(user_rights & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	return FALSE

/datum/controller/subsystem/yautja_panel/proc/verify_superadmin(mob/user)
	var/user_rights = user.client.clan_info.permissions

	if(user_rights & CLAN_PERMISSION_ADMIN_MANAGER)
		return TRUE
	return FALSE

/datum/controller/subsystem/yautja_panel/proc/create_new_clan(clanname)
	var/datum/entity/clan/C = DB_ENTITY(/datum/entity/clan)
	C.name = clanname
	C.description = "This is a clan."
	C.save()
