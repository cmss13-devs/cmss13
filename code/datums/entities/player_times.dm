/datum/entity/player_time
    var/player_id
    var/role_id
    var/total_minutes

BSQL_PROTECT_DATUM(/datum/entity/player_time)

/datum/entity_meta/player_time
    entity_type = /datum/entity/player_time
    table_name = "player_playtime"
    field_types = list(
        "player_id" = DB_FIELDTYPE_BIGINT,
        "role_id" = DB_FIELDTYPE_STRING_LARGE,
        "total_minutes" = DB_FIELDTYPE_BIGINT
    )

/datum/entity_meta/player_time/on_insert(var/datum/entity/player_time/player)
	player.total_minutes = 0

/datum/entity_link/player_to_time
    parent_entity = /datum/entity/player
    child_entity = /datum/entity/player_time
    child_field = "player_id"

    parent_name = "player"
    child_name = "player_times"

#define MINUTES_TO_DECISECOND *600 // Converting to decisecond makes it easier to do in calculations

#define get_job_playtime(client, job) (client.player_data? LAZYACCESS(client.player_data.playtimes, job)? client.player_data.playtimes[job].total_minutes MINUTES_TO_DECISECOND : 0 : 0)
