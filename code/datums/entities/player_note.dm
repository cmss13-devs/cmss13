#define NOTE_ROUND_ID(note_entity) note_entity.round_id ? "(ID: [note_entity.round_id])" : ""

/datum/entity/player_note
	var/player_id
	var/admin_id
	var/text
	var/date
	var/round_id
	var/is_ban = FALSE
	var/ban_time
	var/is_confidential = FALSE
	var/admin_rank
	///The category the note is. Admin/Merit/Commander/Synthetic/Yautja
	var/note_category = NOTE_ADMIN

	var/datum/entity/player/player
	var/datum/entity/player/admin

BSQL_PROTECT_DATUM(/datum/entity/player_note)

/datum/entity_meta/player_note
	entity_type = /datum/entity/player_note
	table_name = "player_notes"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"admin_id" = DB_FIELDTYPE_BIGINT,
		"text" = DB_FIELDTYPE_STRING_MAX,
		"date" = DB_FIELDTYPE_STRING_LARGE,
		"round_id" = DB_FIELDTYPE_BIGINT,
		"is_ban" = DB_FIELDTYPE_INT,
		"ban_time" = DB_FIELDTYPE_BIGINT,
		"is_confidential" = DB_FIELDTYPE_INT,
		"admin_rank" = DB_FIELDTYPE_STRING_MEDIUM,
		"note_category" = DB_FIELDTYPE_INT,
	)

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
	child_field = "player_id"

	parent_name = "player"
	child_name = "notes"

/datum/entity_link/admin_to_player_notes
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_note
	child_field = "admin_id"

	parent_name = "admin"

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
