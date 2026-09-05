GLOBAL_DATUM_INIT(late_join_tgui, /datum/late_join, new)

/datum/late_join
	var/datum/tgui/ui = null

/datum/late_join/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	LAZYADD(data["HijackInitiated"], SShijack?.evac_status == EVACUATION_STATUS_INITIATED)

	// Build a list of named categories of roles, each containing a list of information on individual roles
	var/list/list/list/categorized_roles = list()
	for(var/i in GLOB.RoleAuthority.roles_for_mode)
		var/datum/job/mode_job = GLOB.RoleAuthority.roles_for_mode[i]
		var/job_title = mode_job.title
		if(!GLOB.RoleAuthority.check_role_entry(user, mode_job, latejoin = TRUE, faction = FACTION_NEUTRAL))
			continue
		var/active = 0
		// player_list holds all cliented mobs, AKA "active" players
		for(var/mob/player in GLOB.player_list)
			if(player.job == job_title)
				active++

		var/role_category
		if(GLOB.ROLES_CIC.Find(job_title))
			role_category = "Command"
		else if(GLOB.ROLES_AUXIL_SUPPORT.Find(job_title))
			role_category = "Auxiliary Combat Support"
		else if(GLOB.ROLES_MISC.Find(job_title))
			role_category = "Miscellaneous"
		else if(GLOB.ROLES_POLICE.Find(job_title))
			role_category = "Military Police"
		else if(GLOB.ROLES_ENGINEERING.Find(job_title))
			role_category = "Engineering"
		else if(GLOB.ROLES_REQUISITION.Find(job_title))
			role_category = "Requisitions"
		else if(GLOB.ROLES_MEDICAL.Find(job_title))
			role_category = "Medbay"
		else if(GLOB.ROLES_MARINES.Find(job_title))
			role_category = "Marines"
		else
			role_category = "Other"

		if(!(role_category in categorized_roles))
			categorized_roles[role_category] = list()

		// Append to the end of the list
		categorized_roles[role_category][++categorized_roles[role_category].len] = list(
			"Title" = job_title,
			"DisplayTitle" = mode_job.disp_title,
			"Slots" = mode_job.total_positions,
			"Players" = mode_job.current_positions,
			"Active" = active
		)

	LAZYADD(data["Categories"], categorized_roles)
	data["UPPEnabled"] = (GLOB.master_mode == /datum/game_mode/extended/faction_clash/cm_vs_upp::name)

	return data

/datum/late_join/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/role_icons)

/datum/late_join/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/success = ui.user?:AttemptLateSpawn(action)
	if(success)
		ui.close()

/datum/late_join/ui_state(mob/user, datum/ui_state/state)
	if(isnewplayer(user))
		return GLOB.new_player_state
	return GLOB.default_state

/datum/late_join/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LateJoin", "Late Join")
		ui.open()
