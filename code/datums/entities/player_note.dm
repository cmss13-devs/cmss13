#define NOTE_ROUND_ID(note_entity) note_entity.round_id ? "(ID: [note_entity.round_id])" : ""

DEFINE_ENTITY(player_job_ban, "player_notes")
	var/datum/entity/player/player
	var/datum/entity/player/admin
FIELD_BIGINT(player_job_ban, player_id)
FIELD_BIGINT(player_job_ban, admin_id)
FIELD_STRING_MAX(player_job_ban, text)
FIELD_STRING_LARGE(player_job_ban, date)
FIELD_BIGINT(player_job_ban, round_id)
FIELD_DEFAULT_VALUE_INT(player_job_ban, is_ban, FALSE)
FIELD_BIGINT(player_job_ban, ban_time)
FIELD_DEFAULT_VALUE_INT(player_job_ban, is_confidential, FALSE)
FIELD_STRING_MEDIUM(player_job_ban, admin_rank)
FIELD_DEFAULT_VALUE_INT(player_job_ban, note_category, NOTE_ADMIN)

BSQL_PROTECT_DATUM(/datum/entity/player_note)

/datum/entity_meta/player_note/on_read(datum/entity/player_note/note)
	if(note.player_id)
		note.player = DB_ENTITY(/datum/entity/player, note.player_id)
	note.is_confidential = text2num("[note.is_confidential]")
	note.is_ban = text2num("[note.is_ban]")

/datum/entity/player_note/proc/load_refs()
	if(admin_id)
		admin = DB_ENTITY(/datum/entity/player, admin_id)


/datum/entity_link/player_to_player_notes
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_note
	child_foreign_key = "player_id"

/datum/entity_link/admin_to_player_notes
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_note
	child_foreign_key = "admin_id"

/datum/view_record/note_view
	var/id
	var/player_ckey
	var/text
	var/is_ban
	var/admin_ckey
	var/date
	var/round_id
	var/ban_time
	var/is_confidential
	var/admin_rank
	var/note_category

/datum/entity_view_meta/note_view
	root_record_type = /datum/entity/player_note
	destination_entity = /datum/view_record/note_view
	fields = list(
		"id",
		"player_ckey" = "player.ckey",
		"text",
		"is_ban",
		"admin_ckey" = "admin.ckey",
		"date",
		"round_id",
		"ban_time",
		"is_confidential",
		"admin_rank",
		"note_category"
	)

/// Returns all notes associated with a CKEY, structured as a list of strings.
/proc/get_all_notes(player_ckey)
	for(var/datum/view_record/note_view/note in DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, player_ckey)))
		LAZYADDASSOCLIST(., "[note.note_category]", "\"[note.text]\", by [note.admin_ckey] ([note.admin_rank]) on [note.date] ([note.round_id])")
