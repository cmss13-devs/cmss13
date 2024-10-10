GLOBAL_DATUM(current_battlepass, /datum/entity/battlepass_server)

GLOBAL_LIST_INIT_TYPED(server_battlepasses, /datum/view_record/battlepass_server, load_server_battlepasses())

/proc/load_server_battlepasses()
	WAIT_DB_READY
	UNTIL(GLOB.round_id)
	var/list/season_battlepasses = list()
	var/list/datum/view_record/battlepass_server/battlepasses = DB_VIEW(/datum/view_record/battlepass_server)
	for(var/datum/view_record/battlepass_server/battlepass as anything in battlepasses)
		season_battlepasses[battlepass.season_name] = battlepass

	var/datum/view_record/battlepass_server/current
	for(var/battlepass_name in season_battlepasses)
		var/datum/view_record/battlepass_server/battlepass = season_battlepasses[battlepass_name]
		switch(battlepass.battlepass_status)
			if("Ongoing")
				current = battlepass
				break
			if("Starting")
				current = battlepass

	if(current)
		DB_FILTER(/datum/entity/battlepass_server, DB_COMP("season", DB_EQUALS, current.season), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(on_read_server_battlepasses)))
	return season_battlepasses

/proc/on_read_server_battlepasses(list/datum/entity/battlepass_server/_battlepass)
	if(length(_battlepass))
		GLOB.current_battlepass = pick(_battlepass)
		GLOB.current_battlepass.sync()
		if(GLOB.current_battlepass.status == "Starting")
			GLOB.current_battlepass.status = "Ongoing"
			GLOB.current_battlepass.start_round_id = text2num(GLOB.round_id)
		else if(GLOB.current_battlepass.status == "Ongoing" && !GLOB.current_battlepass.end_round_id)
			GLOB.current_battlepass.check_pre_ending_starting()
		else if(text2num(GLOB.round_id) > GLOB.current_battlepass.end_round_id)
			GLOB.current_battlepass.status = "Ended"
		GLOB.current_battlepass.save()

/proc/prepare_next_season(list/datum/entity/battlepass_server/_battlepass)
	if(length(_battlepass))
		var/datum/entity/battlepass_server/battlepass = pick(_battlepass)
		battlepass.sync()
		battlepass.status = "Starting"
		battlepass.save()

/datum/entity/battlepass_server
	var/season
	var/season_name
	var/max_tier
	var/xp_per_tier_up

	var/rewards
	var/premium_rewards
	var/point_sources

	var/start_round_id
	var/end_round_id

	var/battlepass_status

	var/list/mapped_rewards
	var/list/mapped_premium_rewards
	var/list/mapped_point_sources

BSQL_PROTECT_DATUM(/datum/entity/battlepass_server)

/datum/entity_meta/battlepass_server
	entity_type = /datum/entity/battlepass_server
	table_name = "battlepass_server"
	field_types = list(
		"season" = DB_FIELDTYPE_BIGINT,
		"season_name" = DB_FIELDTYPE_STRING_LARGE,
		"max_tier" = DB_FIELDTYPE_BIGINT,
		"xp_per_tier_up" = DB_FIELDTYPE_BIGINT,
		"rewards" = DB_FIELDTYPE_STRING_MAX,
		"premium_rewards" = DB_FIELDTYPE_STRING_MAX,
		"point_sources" = DB_FIELDTYPE_STRING_MAX,
		"start_round_id" = DB_FIELDTYPE_BIGINT,
		"end_round_id" = DB_FIELDTYPE_BIGINT,
		"battlepass_status" = DB_FIELDTYPE_STRING_LARGE,
	)
	key_field = "season"

/datum/entity_meta/battlepass_server/map(datum/entity/battlepass_server/battlepass, list/values)
	. = ..()
	if(values["rewards"])
		battlepass.mapped_rewards = json_decode(values["rewards"])
	if(values["premium_rewards"])
		battlepass.mapped_premium_rewards = json_decode(values["premium_rewards"])
	if(values["point_sources"])
		battlepass.mapped_point_sources = json_decode(values["point_sources"])

/datum/entity_meta/battlepass_server/unmap(datum/entity/battlepass_server/battlepass)
	. = ..()
	if(length(battlepass.mapped_rewards))
		.["rewards"] = json_encode(battlepass.mapped_rewards)
	if(length(battlepass.mapped_premium_rewards))
		.["premium_rewards"] = json_encode(battlepass.mapped_premium_rewards)
	if(length(battlepass.mapped_point_sources))
		.["point_sources"] = json_encode(battlepass.mapped_point_sources)

/datum/entity/battlepass_server/proc/check_pre_ending_starting()
	UNTIL(length(GLOB.current_battlepasses))
	var/max_lvls = 0
	for(var/datum/view_record/battlepass_player/battlepass in GLOB.current_battlepasses)
		if(battlepass.xp < max_tier * xp_per_tier_up)
			continue
		max_lvls++

	var/percentage = length(GLOB.current_battlepasses) / max_lvls * 100
	if(percentage > 100 - (text2num(GLOB.round_id) - start_round_id) / 10)
		end_round_id = text2num(GLOB.round_id) + round(100 - percentage)
		save()
		DB_FILTER(/datum/entity/battlepass_server, DB_COMP("season", DB_EQUALS, season + 1), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(prepare_next_season)))

/datum/view_record/battlepass_server
	var/season
	var/season_name
	var/max_tier
	var/xp_per_tier_up
	var/rewards
	var/premium_rewards

	var/start_round_id
	var/end_round_id

	var/battlepass_status

	var/list/mapped_rewards
	var/list/mapped_premium_rewards

/datum/entity_view_meta/battlepass_server
	root_record_type = /datum/entity/battlepass_server
	destination_entity = /datum/view_record/battlepass_server
	fields = list(
		"season",
		"season_name",
		"max_tier",
		"xp_per_tier_up",
		"rewards",
		"premium_rewards",
		"start_round_id",
		"end_round_id",
		"battlepass_status",
	)

/datum/entity_view_meta/battlepass_server/map(datum/view_record/battlepass_server/battlepass, list/values)
	. = ..()
	if(values["rewards"])
		battlepass.mapped_rewards = json_decode(values["rewards"])
	if(values["premium_rewards"])
		battlepass.mapped_premium_rewards = json_decode(values["premium_rewards"])
