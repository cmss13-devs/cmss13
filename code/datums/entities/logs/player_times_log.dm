/datum/entity/player_time_log
    var/player_id
    var/round_id

    var/role_id
    var/total_deciseconds
    var/mob_type

    var/start_recording
    var/end_recording
    var/real_time_recorded

/datum/entity/player_time_log/New()
    . = ..()

    real_time_recorded = world.realtime

BSQL_PROTECT_DATUM(/datum/entity/player_time_log)

/datum/entity_meta/player_time_log
    entity_type = /datum/entity/player_time_log
    table_name = "log_player_playtime"
    field_types = list(
        "player_id" = DB_FIELDTYPE_BIGINT,
        "round_id" = DB_FIELDTYPE_BIGINT,

        "role_id" = DB_FIELDTYPE_STRING_LARGE,
        "total_deciseconds" = DB_FIELDTYPE_BIGINT,
        "mob_type" = DB_FIELDTYPE_STRING_LARGE,

        "start_recording" = DB_FIELDTYPE_BIGINT,
        "end_recording" = DB_FIELDTYPE_BIGINT,
        "real_time_recorded" = DB_FIELDTYPE_BIGINT
    )

/datum/entity/player/var/playtime_start = 0

/proc/record_playtime(var/datum/entity/player/P, var/role_id, var/mob_type)
    if(!P || !role_id || !P.playtime_start)
        return

    var/datum/entity/player_time_log/PLog = DB_ENTITY(/datum/entity/player_time_log)
    
    PLog.round_id = SSperf_logging.round.id // get the round id
    PLog.player_id = P.id

    PLog.start_recording = P.playtime_start
    PLog.end_recording = world.time
    PLog.total_deciseconds = (PLog.end_recording - PLog.start_recording)
    PLog.role_id = role_id
    PLog.mob_type = mob_type

    P.playtime_start = world.time

    PLog.save()
    PLog.detach()

/mob/var/logging_ckey