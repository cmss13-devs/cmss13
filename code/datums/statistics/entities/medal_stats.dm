/datum/entity/statistic/medal
	var/player_id
	var/round_id

	var/medal_type
	var/recipient_name
	var/recipient_role
	var/citation

	var/giver_name
	var/giver_player_id

/datum/entity_meta/statistic_medal
    entity_type = /datum/entity/statistic/medal
    table_name = "log_player_statistic_medal"
    field_types = list(
        "player_id" = DB_FIELDTYPE_BIGINT,
        "round_id" = DB_FIELDTYPE_BIGINT,

        "medal_type" = DB_FIELDTYPE_STRING_LARGE,
        "recipient_name" = DB_FIELDTYPE_STRING_LARGE,
        "recipient_role" = DB_FIELDTYPE_STRING_LARGE,
        "citation" = DB_FIELDTYPE_STRING_MAX,

        "giver_name" = DB_FIELDTYPE_STRING_LARGE,
		"giver_player_id" = DB_FIELDTYPE_BIGINT
    )

/datum/entity/player_entity/proc/track_medal_earned(var/new_medal_type, var/mob/new_recipient, var/new_recipient_role, var/new_citation, var/mob/giver)
	if(!new_medal_type || !new_recipient || new_recipient.statistic_exempt || !new_recipient_role || !new_citation || !giver)
		return

	var/datum/entity/statistic/medal/new_medal = DB_ENTITY(/datum/entity/statistic/medal)
	var/datum/entity/player/player_entity = get_player_from_key(new_recipient.ckey)
	if(player_entity)
		new_medal.player_id = player_entity.id

	new_medal.round_id = SSperf_logging.round.id
	new_medal.medal_type = new_medal_type
	new_medal.recipient_name = new_recipient.real_name
	new_medal.recipient_role = new_recipient_role
	new_medal.citation = new_citation

	new_medal.giver_name = giver.real_name

	var/datum/entity/player/giver_player = get_player_from_key(giver.ckey)
	if(giver_player)
		new_medal.giver_player_id = giver_player.id

	new_medal.save()
	new_medal.detach()

	var/datum/entity/player_stats/human/human_stats = setup_human_stats()
	human_stats.count_niche_stat(STATISTICS_NICHE_MEDALS, 1, new_recipient_role)
	human_stats.medal_list.Insert(1, new_medal)
