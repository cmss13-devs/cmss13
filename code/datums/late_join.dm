GLOBAL_DATUM_INIT(late_join_tgui, /datum/late_join, new)

/datum/late_join
	var/datum/tgui/ui = null
	var/faction = FACTION_NEUTRAL //Opening the UPP menu changes it to FACTION_UPP

/datum/late_join/proc/get_squad_preferences()
	var/list/squad_preferences = list("Character preference", "None")
	for(var/role_name in GLOB.RoleAuthority.roles_for_mode)
		var/datum/job/mode_job = GLOB.RoleAuthority.roles_for_mode[role_name]
		if(!mode_job.late_joinable || mode_job.faction_menu != faction || (mode_job.flags_startup_parameters & ROLE_HIDDEN))
			continue
		var/list/available_squads = GLOB.RoleAuthority.get_latejoin_squads(mode_job)
		for(var/squad_name in available_squads)
			squad_preferences |= squad_name
	return squad_preferences

/datum/late_join/ui_data(mob/new_player/user)
	. = ..()
	var/list/data = list()

	data["EvacInitiated"] = (SShijack?.evac_status == EVACUATION_STATUS_INITIATED)
	data["SquadPreferences"] = get_squad_preferences()
	data["PreferredSquad"] = user.latejoin_preferred_squad || "Character preference"

	// Build a list of named categories of roles, each containing a list of information on individual roles
	var/list/list/list/categorized_roles = list()
	for(var/role_name in get_manifest_ordered_jobs(GLOB.RoleAuthority.roles_for_mode))
		var/datum/job/mode_job = GLOB.RoleAuthority.roles_for_mode[role_name]
		var/job_title = mode_job.title
		if(!mode_job.late_joinable || mode_job.faction_menu != faction || (mode_job.flags_startup_parameters & ROLE_HIDDEN))
			continue
		var/active = 0
		// player_list holds all cliented mobs, AKA "active" players
		for(var/mob/player in GLOB.player_list)
			if(player.job == job_title)
				active++

		var/role_category = get_job_department(job_title) || "other"
		//prevents the badges from showing outdated slot counts when you hover over them
		var/total_positions = mode_job.get_total_positions(TRUE)
		var/default_role = GET_DEFAULT_ROLE(job_title)
		var/list/squad_data
		var/list/available_squads = GLOB.RoleAuthority.get_latejoin_squads(mode_job)
		if(available_squads)
			squad_data = list()
			for(var/squad_name in available_squads)
				var/datum/squad/squad = available_squads[squad_name]
				var/open_slots = squad.get_joinable_role_slots(default_role)
				if(total_positions != -1)
					var/role_open_slots = max(0, total_positions - mode_job.current_positions)
					open_slots = isnull(open_slots) ? role_open_slots : min(open_slots, role_open_slots)
				squad_data += list(list("Name" = squad_name, "Color" = squad.equipment_color, "Open" = open_slots))

		if(!(role_category in categorized_roles))
			categorized_roles[role_category] = list()

		// Append to the end of the list
		APPEND_RAW(categorized_roles[role_category], list(
			"Title" = job_title,
			"DisplayTitle" = mode_job.disp_title,
			"IsLeader" = is_job_leader(job_title),
			"Available" = GLOB.RoleAuthority.check_role_entry(user, mode_job, latejoin = TRUE, faction = faction),
			"WhitelistLocked" = !mode_job.check_whitelist_status(user),
			"JobBanned" = !!(jobban_isbanned(user, job_title) || (mode_job.role_ban_alternative && jobban_isbanned(user, mode_job.role_ban_alternative))),
			"Squads" = squad_data,
			"Slots" = total_positions,
			"Players" = mode_job.current_positions,
			"Active" = active
		))

	LAZYADD(data["Categories"], categorized_roles)
	data["UPPEnabled"] = (GLOB.master_mode == /datum/game_mode/extended/faction_clash/cm_vs_upp::name)

	return data

/datum/late_join/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/role_icons)

/datum/late_join/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/new_player/user = ui.user
	if(action == "set_preferred_squad")
		var/preferred_squad = params["squad"]
		if(!(preferred_squad in get_squad_preferences()))
			return
		user.latejoin_preferred_squad = preferred_squad == "Character preference" ? null : preferred_squad
		return TRUE
	var/datum/job/job = GLOB.RoleAuthority.roles_for_mode[action]
	if(!job || job.faction_menu != faction || (job.flags_startup_parameters & ROLE_HIDDEN))
		return FALSE
	var/success = user.AttemptLateSpawn(action, params["squad"])
	if(success)
		ui.close()

/datum/late_join/ui_state(mob/user, datum/ui_state/state)
	if(isnewplayer(user))
		return GLOB.new_player_state
	return GLOB.never_state

/datum/late_join/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LateJoin", "Late Join")
		ui.open()
