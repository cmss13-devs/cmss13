/datum/entity/clan_player
    var/player_id
    var/clan_rank
    var/permissions
    var/clan_id
    
    var/honor

/datum/entity/clan
    var/name
    var/description

    var/honor

BSQL_PROTECT_DATUM(/datum/entity/clan_player)
BSQL_PROTECT_DATUM(/datum/entity/clan)

/datum/entity_meta/clan
    entity_type = /datum/entity/clan
    table_name = "clans"
    field_types = list("name" = DB_FIELDTYPE_STRING_MEDIUM,
    "description" = DB_FIELDTYPE_STRING_MAX,
    "honor" = DB_FIELDTYPE_BIGINT)

/datum/entity_meta/clan_player
    entity_type = /datum/entity/clan_player
    table_name = "clans_player"
    field_types = list("player_id" = DB_FIELDTYPE_BIGINT,
    "clan_rank" = DB_FIELDTYPE_BIGINT,
    "permissions" = DB_FIELDTYPE_BIGINT,
    "clan_id" = DB_FIELDTYPE_BIGINT,
    "honor" = DB_FIELDTYPE_BIGINT)
    key_field = "player_id"

/datum/entity_meta/clan_player/on_insert(var/datum/entity/clan_player/player)
    player.honor = 0
    player.clan_rank = clan_ranks_ordered[CLAN_RANK_UNBLOODED]
    player.permissions = clan_ranks[CLAN_RANK_UNBLOODED].permissions

    player.save()


/datum/entity_link/player_to_clan_player
    parent_entity = /datum/entity/player
    child_entity = /datum/entity/clan_player
    child_field = "player_id"

    parent_name = "player"
    child_name = "clan_player"

/datum/entity_link/clan_to_player
    parent_entity = /datum/entity/clan
    child_entity = /datum/entity/clan_player
    child_field = "clan_id"

    parent_name = "clan"
    child_name = "clan_player"

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