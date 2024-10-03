DEFINE_ENTITY(player_job_ban, "player_job_bans")
	// TODO: have this automatically handled by the link (weakref)
	var/datum/entity/player/player
	var/datum/entity/player/admin
FIELD_BIGINT(player_job_ban, player_id)
FIELD_BIGINT(player_job_ban, admin_id)
FIELD_STRING_MAX(player_job_ban, text)
FIELD_STRING_LARGE(player_job_ban, date)
FIELD_INT(player_job_ban, ban_time)
// In minute format
FIELD_BIGINT(player_job_ban, expiration)
// Role string
FIELD_STRING_MEDIUM(player_job_ban, role)

BSQL_PROTECT_DATUM(/datum/entity/player_job_ban)

/datum/entity_meta/player_job_ban/on_read(datum/entity/player_job_ban/ban)
	if(ban.player_id)
		ban.player  =  DB_ENTITY(/datum/entity/player, ban.player_id)
	ban.expiration  =  text2num("[ban.expiration]")

/datum/entity/player_job_ban/proc/load_refs()
	if(admin_id)
		admin  =  DB_ENTITY(/datum/entity/player, admin_id)

/datum/entity_link/player_to_player_job_bans
	parent_entity  =  /datum/entity/player
	child_entity  =  /datum/entity/player_job_ban
	child_foreign_key  =  "player_id"

/datum/entity_link/admin_to_player_job_bans
	parent_entity  =  /datum/entity/player
	child_entity  =  /datum/entity/player_job_ban
	child_foreign_key  =  "admin_id"
