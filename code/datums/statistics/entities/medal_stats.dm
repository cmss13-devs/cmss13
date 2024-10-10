/datum/entity/statistic/medal
	var/round_id
	var/medal_type
	var/recipient_name
	var/recipient_role
	var/citation
	var/giver_name
	var/giver_player_id

BSQL_PROTECT_DATUM(/datum/entity/statistic/medal)

/datum/entity_meta/statistic_medal
	entity_type = /datum/entity/statistic/medal
	table_name = "player_statistic_medal"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"round_id" = DB_FIELDTYPE_BIGINT,

		"medal_type" = DB_FIELDTYPE_STRING_LARGE,
		"recipient_name" = DB_FIELDTYPE_STRING_LARGE,
		"recipient_role" = DB_FIELDTYPE_STRING_LARGE,
		"citation" = DB_FIELDTYPE_STRING_MAX,

		"giver_name" = DB_FIELDTYPE_STRING_LARGE,
		"giver_player_id" = DB_FIELDTYPE_BIGINT,
	)

/datum/view_record/statistic_medal
	var/player_id
	var/round_id
	var/medal_type
	var/recipient_name
	var/recipient_role
	var/citation
	var/giver_name
	var/giver_player_id
	var/id

/datum/entity_view_meta/statistic_medal_ordered
	root_record_type = /datum/entity/statistic/medal
	destination_entity = /datum/view_record/statistic_medal
	fields = list(
		"player_id",
		"round_id",
		"medal_type",
		"recipient_name",
		"recipient_role",
		"citation",
		"giver_name",
		"giver_player_id",
		"id",
	)


/datum/player_entity/proc/track_medal_earned(new_medal_type, mob/new_recipient, new_recipient_role, new_citation, mob/giver)
	if(!new_medal_type || !new_recipient || new_recipient.statistic_exempt || !new_recipient_role || !new_citation || !giver)
		return

	var/datum/entity/statistic/medal/new_medal = DB_ENTITY(/datum/entity/statistic/medal)
	var/datum/entity/player/player_entity = get_player_from_key(new_recipient.ckey)
	if(player_entity)
		new_medal.player_id = player_entity.id

	new_medal.round_id = SSperf_logging.round?.id
	new_medal.medal_type = new_medal_type
	new_medal.recipient_name = new_recipient.real_name
	new_medal.recipient_role = new_recipient_role
	new_medal.citation = new_citation

	new_medal.giver_name = giver.real_name

	var/datum/entity/player/giver_player = get_player_from_key(giver.ckey)
	if(giver_player)
		new_medal.giver_player_id = giver_player.id

	var/datum/entity/player/recipient_player = get_player_from_key(new_recipient.ckey)
	if(recipient_player)
		track_statistic_earned(new_recipient.faction, STATISTICS_MEDALS, 1, recipient_player)

	medals += new_medal
	new_medal.save()
	new_medal.detach()

/datum/player_entity/proc/untrack_medal_earned(medal_type, mob/recipient, citation)
	if(!medal_type || !recipient || recipient.statistic_exempt || !citation)
		return FALSE

	if(!check_rights(R_MOD))
		return FALSE


	var/datum/entity/player/recipient_player = get_player_from_key(recipient.ckey)
	if(recipient_player)
		track_statistic_earned(recipient.faction, STATISTICS_MEDALS, 1, recipient_player)

	var/round_id = SSperf_logging.round?.id
	for(var/datum/entity/statistic/medal/new_medal as anything in medals)
		if(new_medal.round_id == round_id && new_medal.recipient_name == recipient.real_name && new_medal.medal_type == medal_type && new_medal.citation == citation)
			medals -= new_medal
			new_medal.delete()
			break
	return TRUE
