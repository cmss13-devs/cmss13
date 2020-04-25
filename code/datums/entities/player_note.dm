/datum/entity/player_note
	var/player_id
	var/admin_id
	var/text
	var/date
	var/is_ban = FALSE
	var/ban_time
	var/is_confidential = FALSE
	var/admin_rank

	var/datum/entity/player/player
	var/datum/entity/player/admin

BSQL_PROTECT_DATUM(/datum/entity/player_note)

/datum/entity_meta/player_note
	entity_type = /datum/entity/player_note
	table_name = "player_notes"
	field_types = list("player_id"=DB_FIELDTYPE_BIGINT,
			"admin_id"=DB_FIELDTYPE_BIGINT,
			"text"=DB_FIELDTYPE_STRING_MAX,
			"date"=DB_FIELDTYPE_STRING_LARGE,
			"is_ban"=DB_FIELDTYPE_INT,
			"ban_time"=DB_FIELDTYPE_BIGINT,
			"is_confidential"=DB_FIELDTYPE_INT,
			"admin_rank"=DB_FIELDTYPE_STRING_MEDIUM
		)

/datum/entity_meta/player_note/on_read(var/datum/entity/player_note/note)
	if(note.player_id)
		note.player = DB_ENTITY(/datum/entity/player, note.player_id)
	note.is_confidential = text2num("[note.is_confidential]")
	note.is_ban = text2num("[note.is_ban]")

/datum/entity/player_note/proc/load_refs()
	if(admin_id)
		admin = DB_ENTITY(/datum/entity/player, admin_id)