GLOBAL_DATUM_INIT(late_join_tgui, /datum/late_join, new)

/datum/late_join
	var/datum/tgui/ui = null
	var/mob/new_player/user = null

/datum/late_join/New(mob/new_player/new_user)
	. = ..()
	user = new_user

/datum/late_join/ui_data()
	. = ..()
	var/list/data = list()

	if(SShijack)
		switch(SShijack.evac_status)
			if(EVACUATION_STATUS_INITIATED)
				LAZYADD(data["HijackInitiated"], TRUE)

	// Build a list of named categories of roles, each containing a list of information on individual roles
	var/list/categorized_roles = list()
	for(var/i in GLOB.RoleAuthority.roles_for_mode)
		var/datum/job/J = GLOB.RoleAuthority.roles_for_mode[i]
		if(!GLOB.RoleAuthority.check_role_entry(user, J, latejoin = TRUE, faction = FACTION_NEUTRAL))
			continue
		var/active = 0
		// Only players with the job assigned and AFK for less than 10 minutes count as active
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.job == J.title)
				active++

		var/role_category
		if(GLOB.ROLES_CIC.Find(J.title))
			role_category = "Command"
		else if(GLOB.ROLES_AUXIL_SUPPORT.Find(J.title))
			role_category = "Auxiliary Combat Support"
		else if(GLOB.ROLES_MISC.Find(J.title))
			role_category = "Miscellaneous"
		else if(GLOB.ROLES_POLICE.Find(J.title))
			role_category = "Military Police"
		else if(GLOB.ROLES_ENGINEERING.Find(J.title))
			role_category = "Engineering"
		else if(GLOB.ROLES_REQUISITION.Find(J.title))
			role_category = "Requisitions"
		else if(GLOB.ROLES_MEDICAL.Find(J.title))
			role_category = "Medbay"
		else if(GLOB.ROLES_MARINES.Find(J.title))
			role_category = "Marines"
		else
			role_category = "Other"

		if(!(role_category in categorized_roles))
			categorized_roles[role_category] = list()

		// Why is DM so insistent that you don't make multidimensional arrays?
		categorized_roles[role_category][++categorized_roles[role_category].len] = list(
			"Title" = J.title,
			"DisplayTitle" = J.disp_title,
			"Slots" = J.total_positions,
			"Players" = J.current_positions,
			"Active" = active
		)

	LAZYADD(data["Categories"], categorized_roles)
	return data

/datum/late_join/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/role_icons)

/datum/late_join/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/success = user.AttemptLateSpawn(action)
	if(success)
		ui.close()

/datum/late_join/ui_state(mob/user, datum/ui_state/state)
	if(isnewplayer(user))
		return GLOB.new_player_state
	return GLOB.default_state

/datum/late_join/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LateJoin", "Late Join")
		ui.open()
