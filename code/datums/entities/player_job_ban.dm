/datum/entity/player_job_ban
	var/player_id
	var/admin_id
	var/text
	var/date
	var/ban_time
	var/expiration // in minute format
	var/role // role string

	var/datum/entity/player/player
	var/datum/entity/player/admin

BSQL_PROTECT_DATUM(/datum/entity/player_job_ban)

/datum/entity_meta/player_job_ban
	entity_type = /datum/entity/player_job_ban
	table_name = "player_job_bans"
	field_types = list("player_id"=DB_FIELDTYPE_BIGINT,
			"admin_id"=DB_FIELDTYPE_BIGINT,
			"text"=DB_FIELDTYPE_STRING_MAX,
			"date"=DB_FIELDTYPE_STRING_LARGE,
			"ban_time"=DB_FIELDTYPE_INT,
			"expiration"=DB_FIELDTYPE_BIGINT,
			"role"=DB_FIELDTYPE_STRING_MEDIUM
		)

/datum/entity_meta/player_job_ban/on_read(var/datum/entity/player_job_ban/ban)
	if(ban.player_id)
		ban.player = DB_ENTITY(/datum/entity/player, ban.player_id)
	ban.expiration = text2num("[ban.expiration]")

/datum/entity/player_job_ban/proc/load_refs()
	if(admin_id)
		admin = DB_ENTITY(/datum/entity/player, admin_id)