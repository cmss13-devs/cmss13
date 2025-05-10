/datum/entity/player_time
	var/player_id
	var/role_id
	var/total_minutes

	// Untracked vars
	var/bgcolor = "#4a4a4a"
	var/textcolor = "#ffffff"

BSQL_PROTECT_DATUM(/datum/entity/player_time)

/datum/entity_meta/player_time
	entity_type = /datum/entity/player_time
	table_name = "player_playtime"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"role_id" = DB_FIELDTYPE_STRING_LARGE,
		"total_minutes" = DB_FIELDTYPE_BIGINT,
	)

/datum/entity_meta/player_time/on_insert(datum/entity/player_time/player)
	player.total_minutes = 0

/datum/entity_link/player_to_time
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_time
	child_field = "player_id"

	parent_name = "player"
	child_name = "player_times"

/datum/view_record/playtime
	var/player_id
	var/role_id
	var/total_minutes

/datum/entity_view_meta/playtime_ordered
	root_record_type = /datum/entity/player_time
	destination_entity = /datum/view_record/playtime
	fields = list(
		"player_id",
		"role_id",
		"total_minutes",
	)
	order_by = list("total_minutes" = DB_ORDER_BY_DESC)

/datum/view_record/playtime/proc/get_nanoui_data(no_icons = FALSE)

	var/icon_display
	switch(total_minutes MINUTES_TO_DECISECOND)
		if(JOB_PLAYTIME_TIER_1 to JOB_PLAYTIME_TIER_2)
			icon_display = "tier1_big"
		if(JOB_PLAYTIME_TIER_2 to JOB_PLAYTIME_TIER_3)
			icon_display = "tier2_big"
		if(JOB_PLAYTIME_TIER_3 to JOB_PLAYTIME_TIER_4)
			icon_display = "tier3_big"
		if(JOB_PLAYTIME_TIER_4 to INFINITY)
			icon_display = "tier4_big"

	var/playtime_percentage = min((total_minutes MINUTES_TO_DECISECOND) / JOB_PLAYTIME_TIER_4, 1)
	return list(
		"job" = role_id,
		"playtime" = round(total_minutes MINUTES_TO_HOURS, 0.1),
		"bgcolor" = "rgb(0, [floor(128 * playtime_percentage)], [floor(255 * playtime_percentage)])",
		"textcolor" = "#FFFFFF",
		"icondisplay" = icon_display
	)

/datum/entity/player/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Playtime", "Playtimes")
		ui.open()

/datum/entity/player/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/playtime_rank))

/datum/entity/player/ui_data(mob/user)
	if(!LAZYACCESS(playtime_data, "loaded"))
		load_timestat_data()
	return playtime_data

/datum/entity/player/ui_state(mob/user)
	return GLOB.always_state

/datum/entity/player/proc/load_timestat_data()
	if(!playtime_loaded || !GLOB.RoleAuthority || LAZYACCESS(playtime_data, "loading")) // Need roleauthority to be up to see which job is xeno-related
		return

	LAZYSET(playtime_data, "loading", TRUE)
	var/list/datum/view_record/playtime/PTs = DB_VIEW(/datum/view_record/playtime, DB_COMP("player_id", DB_EQUALS, id))

	var/list/xeno_playtimes = LAZYACCESS(playtime_data, "stored_xeno_playtime")
	var/list/other_playtimes = LAZYACCESS(playtime_data, "stored_other_playtime")
	var/list/marine_playtimes = LAZYACCESS(playtime_data, "stored_human_playtime")

	LAZYCLEARLIST(xeno_playtimes)
	LAZYCLEARLIST(other_playtimes)
	LAZYCLEARLIST(marine_playtimes)

	if(owning_client)
		var/list/xeno_playtime = list(
			"job" = "Xenomorph",
			"playtime" = round(owning_client.get_total_xeno_playtime() DECISECONDS_TO_HOURS, 0.1),
			"bgcolor" = "#3a3a3a",
			"textcolor" = "#FFFFFF"
		)

		var/list/marine_playtime = list(
			"job" = "Human",
			"playtime" = round(owning_client.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1),
			"bgcolor" = "#3a3a3a",
			"textcolor" = "#FFFFFF"
		)

		LAZYADD(xeno_playtimes, list(xeno_playtime))
		LAZYADD(other_playtimes, list())
		LAZYADD(marine_playtimes, list(marine_playtime))

	for(var/datum/view_record/playtime/PT in PTs)
		var/isxeno = (PT.role_id in GLOB.RoleAuthority.castes_by_name)
		var/isOther = (PT.role_id == JOB_OBSERVER) // more maybe eventually

		if(PT.role_id == JOB_XENOMORPH)
			continue // Snowflake check, will need to be removed in the future

		if(!(PT.role_id in GLOB.RoleAuthority.roles_by_name) && !isxeno && !isOther)
			continue

		if(isxeno)
			LAZYADD(xeno_playtimes, list(PT.get_nanoui_data()))
		else if(isOther)
			LAZYADD(other_playtimes, list(PT.get_nanoui_data(TRUE)))
		else
			LAZYADD(marine_playtimes, list(PT.get_nanoui_data()))

	LAZYSET(playtime_data, "loading", FALSE)
	LAZYSET(playtime_data, "loaded", TRUE)

/// Returns the total time in minutes a specific player ID has played for
/proc/get_total_living_playtime(player_id)
	for(var/datum/view_record/playtime/time in DB_VIEW(/datum/view_record/playtime, DB_AND(DB_COMP("player_id", DB_EQUALS, player_id), DB_COMP("role_id", DB_NOTEQUAL, "Observer"))))
		. += time.total_minutes
