BSQL_PROTECT_DATUM(/datum/entity/player_stat)

DEFINE_ENTITY(player_stat, "player_stat")
FIELD_BIGINT(player_stat, player_id)
FIELD_STRING_LARGE(player_stat, stat_id)
FIELD_DEFAULT_VALUE_INT(player_stat, stat_number, 0)
FIELD_STRING_LARGE(player_stat, stat_category)

/datum/entity_link/player_to_stat
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_stat
	child_foreign_key = "player_id"
