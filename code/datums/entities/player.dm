/datum/entity/player
	var/ckey

	var/last_login
	var/notes_migrated = FALSE

	var/is_permabanned = FALSE
	var/permaban_reason
	var/permaban_date

	var/is_time_banned = FALSE
	var/time_ban_reason
	var/time_ban_admin_id
	var/time_ban_expiration_date
	var/time_ban_date

	var/list/datum/entity/player_note/notes

/datum/entity/player/proc/add_note(var/client/admin, note_text, is_confidential)
	var/datum/entity/player_note/note = DB_ENTITY(/datum/entity/player_note)
	note.player_id = id
	note.text = note_text
	note.date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	note.admin_id = admin.player_data.id
	note.is_confidential = is_confidential
	note.save()
	if(!notes)
		notes = list()
	notes.Add(note)

/datum/entity_meta/player
	entity_type = /datum/entity/player
	table_name = "players"
	field_types = list("ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"last_login" = DB_FIELDTYPE_DATE,
		"notes_migrated" = DB_FIELDTYPE_INT,
		"is_permabanned" = DB_FIELDTYPE_INT,
		"permaban_reason" = DB_FIELDTYPE_STRING_MAX,
		"permaban_date" = DB_FIELDTYPE_STRING_LARGE,
		"is_time_banned" = DB_FIELDTYPE_INT,
		"time_ban_reason" = DB_FIELDTYPE_STRING_MAX,
		"time_ban_admin_id" = DB_FIELDTYPE_BIGINT,
		"time_ban_expiration_date" = DB_FIELDTYPE_DATE,
		"time_ban_date" = DB_FIELDTYPE_STRING_LARGE)

/datum/entity_meta/player/on_read(var/datum/entity/player/player)
	DB_FILTER(/datum/entity/player_note, DB_COMP("player_id", DB_EQUALS, player.id), CALLBACK(src, /datum/entity_meta/player.proc/on_read_notes, player))
	
/datum/entity_meta/player/proc/on_read_notes(var/datum/entity/player/player, var/list/datum/entity/player_note/notes)
	if(notes)
		player.notes = notes

/proc/get_player_from_key(ckey, var/datum/callback/CB)
	SSentity_manager.filter_then(/datum/entity/player, DB_COMP("ckey", DB_EQUALS, ckey), CALLBACK(GLOBAL_PROC, /client.proc/get_player_from_key_callback, ckey, CB))

/proc/get_player_from_key_callback(ckey, var/datum/callback/CB, var/list/datum/entity/players)
	set waitfor = 0
	var/datum/entity/player/player
	if(!players.len)
		player = SSentity_manager.select(/datum/entity/player)
		player.ckey = ckey
		player.save()		
	else
		player = players[1]
	player.sync()
	CB.Invoke(player)


/client/var/datum/entity/player/player_data

/client/proc/load_player_data()
	set waitfor=0
	WAIT_DB_READY
	get_player_from_key(ckey, CALLBACK(src, /client.proc/load_player_data_callback))

/client/proc/load_player_data_callback(var/datum/entity/player/player)
	player_data = player
	player_data.last_login = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	player_data.save()	
	player_data.sync()
	if(!player_data.notes_migrated)
		player_data.migrate_notes()

/datum/entity/player/proc/migrate_notes()
	notes_migrated = TRUE
	save() // important! because most likely player is not yet saved
	var/savefile/info = new("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		return
	if(!notes)
		notes = list()
	for(var/datum/player_info/I in infos)
		var/datum/entity/player_note/note = DB_ENTITY(/datum/entity/player_note)
		notes.Add(note)
		note.player_id = id
		 
		note.admin_rank = I.rank
		if(!note.admin_rank)
			note.admin_rank = "N/A"
		note.date = I.timestamp		
		var/list/splitting = splittext(I.content, "|")
		if(splitting.len == 1)
			note.text = I.content
			note.is_ban = FALSE
		if(splitting.len == 3)
			note.text = splitting[3]
			note.ban_time = text2num(replacetext(replacetext(splitting[2],"Duration: ","")," minutes",""))
			note.is_ban = TRUE
		if(splitting.len == 2)
			note.text = I.content
			note.is_ban = TRUE

		note.save()

		var/admin_ckey = "[ckey(I.author)]"
		get_player_from_key(admin_ckey, CALLBACK(src, /datum/entity/player.proc/migrate_notes_admin_callback, note))

/datum/entity/player/proc/migrate_notes_admin_callback(var/datum/entity/player_note/note, var/datum/entity/player/admin)
	if(!admin)
		return

	note.admin_id = admin.id
	note.admin = admin
	note.save()