BSQL_PROTECT_DATUM(/datum/entity/clan_player)
BSQL_PROTECT_DATUM(/datum/entity/clan)

DEFINE_ENTITY(clan, "clans")
FIELD_STRING_MEDIUM(clan, name)
FIELD_STRING_MAX(clan, description)
FIELD_BIGINT(clan, honor)
FIELD_DEFAULT_VALUE_STRING_SMALL(clan, color, "#FFFFFF")

DEFINE_ENTITY(clan_player, "clans_player")
FIELD_BIGINT(clan_player, player_id)
FIELD_DEFAULT_VALUE_BIGINT(clan_player, clan_rank, GLOB.clan_ranks_ordered[CLAN_RANK_UNBLOODED])
FIELD_DEFAULT_VALUE_BIGINT(clan_player, permissions, GLOB.clan_ranks[CLAN_RANK_UNBLOODED].permissions)
FIELD_BIGINT(clan_player, clan_id)
FIELD_DEFAULT_VALUE_BIGINT(clan_player, honor, 0)

/datum/entity_link/player_to_clan_player
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/clan_player
	child_foreign_key = "player_id"

/datum/entity_link/clan_to_player
	parent_entity = /datum/entity/clan
	child_entity = /datum/entity/clan_player
	child_foreign_key = "clan_id"

/datum/view_record/clan_playerbase_view
	var/clan_id
	var/player_id
	var/clan_player_id
	var/ckey
	var/clan_rank
	var/permissions
	var/clan_name
	var/honor

/datum/entity_view_meta/clan_players_view
	root_record_type = /datum/entity/clan_player
	destination_entity = /datum/view_record/clan_playerbase_view
	fields = list(
		"clan_id",
		"player_id",
		"clan_rank",
		"permissions",
		"honor",
		"clan_player_id" = "id",
		"clan_name" = "clan.name",
		"ckey" = "player.ckey"
	)
	order_by = list("clan_rank" = DB_ORDER_BY_DESC)

/datum/view_record/clan_view
	var/clan_id
	var/name

/datum/entity_view_meta/clan_view
	root_record_type = /datum/entity/clan
	destination_entity = /datum/view_record/clan_view
	fields = list(
		"name",
		"clan_id" = "id"
	)
	order_by = list("name" = DB_ORDER_BY_ASC)
