#define MINUTES_STAMP ((world.realtime / 10) / 60)

/datum/entity/player
	var/ckey
	var/last_known_ip
	var/last_known_cid

	var/whitelist_status
	var/whitelist_flags

	var/discord_link_id

	var/last_login

	var/is_permabanned = FALSE
	var/permaban_reason
	var/permaban_date
	var/permaban_admin_id

	var/is_time_banned = FALSE
	var/time_ban_reason
	var/time_ban_admin_id
	var/time_ban_expiration
	var/time_ban_date

	var/migrated_notes = FALSE
	var/migrated_bans = FALSE
	var/migrated_jobbans = FALSE

	var/stickyban_whitelisted = FALSE

	var/byond_account_age
	var/first_join_date


// UNTRACKED FIELDS
	var/name // Used for NanoUI statistics menu

	var/warning_count = 0
	var/refs_loaded = FALSE
	var/notes_loaded = FALSE
	var/jobbans_loaded = FALSE
	var/playtime_loaded = FALSE
	var/migrating_notes = FALSE
	var/migrating_bans = FALSE
	var/migrating_jobbans = FALSE

	var/datum/entity/discord_link/discord_link
	var/datum/entity/player/permaban_admin
	var/datum/entity/player/time_ban_admin
	var/list/datum/entity/player_note/notes
	var/list/datum/entity/player_job_ban/job_bans
	var/list/datum/entity/player_time/playtimes
	var/list/datum/entity/player_stat/stats
	var/list/playtime_data // For the NanoUI menu
	var/client/owning_client

BSQL_PROTECT_DATUM(/datum/entity/player)

/datum/entity_meta/player
	entity_type = /datum/entity/player
	table_name = "players"
	key_field = "ckey"
	field_types = list(
		"ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"last_known_ip" = DB_FIELDTYPE_STRING_SMALL,
		"last_known_cid" = DB_FIELDTYPE_STRING_SMALL,
		"last_login" = DB_FIELDTYPE_STRING_LARGE,
		"is_permabanned" = DB_FIELDTYPE_INT,
		"permaban_reason" = DB_FIELDTYPE_STRING_MAX,
		"permaban_date" = DB_FIELDTYPE_STRING_LARGE,
		"whitelist_status" = DB_FIELDTYPE_STRING_MAX,
		"discord_link_id" = DB_FIELDTYPE_BIGINT,
		"permaban_admin_id" = DB_FIELDTYPE_BIGINT,
		"is_time_banned" = DB_FIELDTYPE_INT,
		"time_ban_reason" = DB_FIELDTYPE_STRING_MAX,
		"time_ban_expiration" = DB_FIELDTYPE_BIGINT,
		"time_ban_admin_id" = DB_FIELDTYPE_BIGINT,
		"time_ban_date" = DB_FIELDTYPE_STRING_LARGE,
		"migrated_notes" = DB_FIELDTYPE_INT,
		"migrated_bans" = DB_FIELDTYPE_INT,
		"migrated_jobbans" = DB_FIELDTYPE_INT,
		"stickyban_whitelisted" = DB_FIELDTYPE_INT,
		"byond_account_age" = DB_FIELDTYPE_STRING_MEDIUM,
		"first_join_date" = DB_FIELDTYPE_STRING_MEDIUM,
	)

// NOTE: good example of database operations using NDatabase, so it is well commented
// is_ban DOES NOT MEAN THAT NOTE IS _THE_ BAN, IT MEANS THAT NOTE WAS CREATED FOR A BAN
/datum/entity/player/proc/add_note(note_text, is_confidential, note_category = NOTE_ADMIN, is_ban = FALSE, duration = null)
	var/client/admin = usr.client
	// do all checks here, especially for sensitive stuff like this
	if(!(note_category == NOTE_WHITELIST))
		if(!admin || !admin.player_data)
			return FALSE
		if(note_category == NOTE_ADMIN || is_confidential)
			if (!AHOLD_IS_MOD(admin.admin_holder))
				return FALSE

	// this is here for a short transition period when we still are testing DB notes and constantly deleting the file
	if(CONFIG_GET(flag/duplicate_notes_to_file))
		if(!is_confidential && note_category == NOTE_ADMIN)
			notes_add(ckey, note_text, admin.mob)
	else
		// notes_add already sends a message
		message_admins("[key_name_admin(admin.mob)] has edited [ckey]'s [GLOB.note_categories[note_category]] notes: [sanitize(note_text)]")
	if(!is_confidential && note_category == NOTE_ADMIN && owning_client)
		to_chat_immediate(owning_client, SPAN_WARNING(FONT_SIZE_LARGE("You have been noted by [key_name_admin(admin.mob, FALSE)].")))
		to_chat_immediate(owning_client, SPAN_WARNING(FONT_SIZE_BIG("The note is : [sanitize(note_text)]")))
		to_chat_immediate(owning_client, SPAN_WARNING(FONT_SIZE_BIG("If you believe this was filed in error or misplaced, make a staff report at <a href='[CONFIG_GET(string/staffreport)]'><b>The CM Forums</b></a>")))
		to_chat_immediate(owning_client, SPAN_WARNING(FONT_SIZE_BIG("You can also click the name of the staff member noting you to PM them.")))
	// create new instance of player_note entity
	var/datum/entity/player_note/note = DB_ENTITY(/datum/entity/player_note)
	// set its related data
	note.player_id = id
	note.text = note_text
	note.date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	note.round_id = GLOB.round_id
	note.is_confidential = is_confidential
	note.note_category = note_category
	note.is_ban = is_ban
	note.ban_time = duration
	note.admin_rank = admin.admin_holder ? admin.admin_holder.rank : "Non-Staff"
	// since admin is in game, their player_data has to be populated. This is also checked above
	note.admin_id = admin.player_data.id
	note.admin = admin.player_data
	note.player = src
	// say to the entity manager that we did all the changes and now want to save it
	note.save()
	// we wanna have list of notes for our player
	// if it is null, let's create it
	if(!notes)
		notes = list()
	// this list is managed by us. Maybe in future relations like this will be managed by Entity Manager in some way
	notes.Add(note)
	return TRUE

/datum/entity/player/proc/remove_note(note_id, whitelist = FALSE)
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED
	var/client/admin = usr.client
	// do all checks here, especially for sensitive stuff like this
	if(!admin || !admin.player_data)
		return FALSE

	if((!AHOLD_IS_MOD(admin.admin_holder)) && !whitelist)
		return FALSE
	if(whitelist && !(isSenator(admin) || CLIENT_HAS_RIGHTS(admin, R_PERMISSIONS)))
		return FALSE

	// this is here for a short transition period when we still are testing DB notes and constantly deleting the file
	message_admins("[key_name_admin(admin)] deleted one of [ckey]'s notes.")
	// get note from our list
	var/datum/entity/player_note/note = DB_ENTITY(/datum/entity/player_note, note_id)
	log_admin("Note: [note.text] by [note.admin]")
	// de-list it
	notes.Remove(note)
	// murder it
	note.delete()

/datum/entity/player/proc/add_timed_ban(ban_text, duration)
	var/client/admin = usr.client
	// do all checks here, especially for sensitive stuff like this
	if(!admin || !admin.player_data)
		return FALSE

	if (!AHOLD_IS_MOD(admin.admin_holder))
		return FALSE

	if(owning_client && owning_client.admin_holder && (owning_client.admin_holder.rights & R_MOD))
		return FALSE

	// this is here for a short transition period when we still are testing DB notes and constantly deleting the file
	if(CONFIG_GET(flag/duplicate_notes_to_file))
		AddBan(ckey, last_known_cid, ban_text, admin.ckey, 1, duration, last_known_ip)
		notes_add(ckey, "Banned by [admin.ckey]|Duration: [duration] minutes|Reason: [sanitize(ban_text)]", usr)

	message_admins("\blue[admin.ckey] has banned [ckey].\nReason: [sanitize(ban_text)]\nThis will be removed in [duration] minutes.")
	ban_unban_log_save("[admin.ckey] has banned [ckey]|Duration: [duration] minutes|Reason: [sanitize(ban_text)]")

	add_note(ban_text, FALSE, NOTE_ADMIN, TRUE, duration)

	// since this is a timed ban, we need to update the ban
	time_ban_date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	time_ban_expiration = MINUTES_STAMP + duration
	time_ban_admin_id = admin.player_data.id
	time_ban_admin = admin.player_data
	time_ban_reason = ban_text
	is_time_banned = TRUE
	save()

	// then we drop the player if they are in
	if(owning_client)
		to_chat_forced(owning_client, SPAN_WARNING("<BIG><B>You have been banned by [admin.ckey].\nReason: [sanitize(ban_text)].</B></BIG>"))
		to_chat_forced(owning_client, SPAN_WARNING("This is a temporary ban, it will be removed in [duration] minutes."))
		QDEL_NULL(owning_client)

	return TRUE

/datum/entity/player/proc/remove_timed_ban()
	var/client/admin = usr.client
	// do all checks here, especially for sensitive stuff like this
	if(!admin || !admin.player_data)
		return FALSE

	if (!AHOLD_IS_MOD(admin.admin_holder))
		return FALSE

	if(!is_time_banned)
		return FALSE

	// we cannot remove timed bans
	if(CONFIG_GET(flag/duplicate_notes_to_file))
		message_admins(SPAN_WARNING("CANNOT REMOVE BANS FROM OLD BAN MANAGER. If you see this during test period - reapply unban after test round is done."), 1)

	ban_unban_log_save("[key_name(admin)] removed [ckey]'s ban.")
	message_admins("[key_name_admin(admin)] removed [ckey]'s ban.", 1)

	time_ban_date = null
	time_ban_expiration = null
	time_ban_admin_id = null
	time_ban_reason = null
	is_time_banned = FALSE
	time_ban_admin = null
	save()

	return TRUE

/datum/entity/player/proc/add_job_ban(ban_text, list/ranks, duration = null)
	var/client/admin = usr.client
	// do all checks here, especially for sensitive stuff like this
	if(!admin || !admin.player_data)
		return FALSE

	if (!AHOLD_IS_MOD(admin.admin_holder))
		return FALSE

	if(owning_client && owning_client.admin_holder && (owning_client.admin_holder.rights & R_MOD))
		return FALSE

	var/total_rank = jointext(ranks, ", ")

	var/duration_text = duration?"jobbanned for [duration/60] hours":"perma-jobbanned"

	// this is here for a short transition period when we still are testing DB notes and constantly deleting the file
	if(CONFIG_GET(flag/duplicate_notes_to_file) && !duration)
		for(var/rank in ranks)
			var/safe_rank = ckey(rank)
			if(job_bans[safe_rank])
				continue
			var/old_rank = check_jobban_path(safe_rank)
			GLOB.jobban_keylist[old_rank][ckey] = ban_text
			jobban_savebanfile()

	add_note("Banned from [total_rank] - [ban_text]", FALSE, NOTE_ADMIN, TRUE, duration) // it is ban related note

	ban_unban_log_save("[key_name_admin(admin)] [duration_text] [ckey] from [total_rank]. reason: [ban_text]")
	log_admin("[key_name(admin)] [duration_text] [ckey] from [total_rank]")

	to_chat(owning_client, SPAN_WARNING("<BIG><B>You have been jobbanned by [admin.ckey] from: [total_rank].</B></BIG>"))
	to_chat(owning_client, SPAN_WARNING("<B>The reason is: [ban_text]</B>"))
	if(!duration)
		to_chat(owning_client, SPAN_WARNING("Jobban can be lifted only upon request."))
	else
		to_chat(owning_client, SPAN_WARNING("This jobban is timed and will expire in [duration] minutes."))

	if(!job_bans)
		job_bans = list()

	for(var/rank in ranks)
		var/safe_rank = ckey(rank)
		if(job_bans[safe_rank])
			continue
		var/datum/entity/player_job_ban/PJB = DB_ENTITY(/datum/entity/player_job_ban) // hi PJB
		PJB.player_id = id
		PJB.admin_id = admin.player_data.id
		PJB.admin = admin.player_data
		PJB.player = src
		PJB.text = ban_text
		PJB.date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
		PJB.ban_time = duration
		if(duration)
			PJB.expiration = MINUTES_STAMP + duration
		PJB.role = safe_rank
		PJB.save()
		job_bans[safe_rank] = PJB

	return TRUE

// removing job bans is done one by one
/datum/entity/player/proc/remove_job_ban(rank)
	var/client/admin = usr.client
	// do all checks here, especially for sensitive stuff like this
	if(!admin || !admin.player_data)
		return FALSE

	if (!AHOLD_IS_MOD(admin.admin_holder))
		return FALSE

	var/safe_rank = ckey(rank)

	if(!job_bans[safe_rank])
		return

	if(CONFIG_GET(flag/duplicate_notes_to_file))
		jobban_remove("[ckey] - [safe_rank]")
		jobban_savebanfile()

	var/datum/entity/player_job_ban/PJB = job_bans[safe_rank]
	job_bans[safe_rank] = null
	PJB.delete()

	ban_unban_log_save("[key_name(admin)] unjobbanned [ckey] from [safe_rank]")
	log_admin("[key_name(admin)] unbanned [ckey] from [safe_rank]")

	return TRUE

/// Permanently bans this user, with the provided reason. The banner ([/datum/entity/player]) argument is optional, as this can be done without admin intervention.
/datum/entity/player/proc/add_perma_ban(reason, internal_reason, datum/entity/player/banner)
	if(is_permabanned)
		return FALSE

	is_permabanned = TRUE
	permaban_date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	permaban_reason = reason

	if(banner)
		permaban_admin_id = banner.id
		message_admins("[key_name_admin(banner.owning_client)] has permanently banned [ckey] for '[reason]'.")
		var/datum/tgs_chat_embed/field/reason_embed
		if(internal_reason)
			reason_embed = new("Permaban Reason", internal_reason)
		important_message_external("[banner.owning_client] has permanently banned [ckey] for '[reason]'.", "Permaban Placed", reason_embed ? list(reason_embed) : null)

		add_note("Permanently banned | [reason]", FALSE, NOTE_ADMIN, TRUE)
		if(internal_reason)
			add_note("Internal reason: [internal_reason]", TRUE, NOTE_ADMIN)

	if(owning_client)
		to_chat_forced(owning_client, SPAN_LARGE("<big><b>You have been permanently banned by [banner.ckey].\nReason: [reason].</b></big>"))
		to_chat_forced(owning_client, SPAN_LARGE("This is a permanent ban. It will not be removed."))
		QDEL_NULL(owning_client)

	save()

	return TRUE

/datum/entity/player/proc/auto_unban()
	if(!is_time_banned)
		return
	var/time_left = time_ban_expiration - MINUTES_STAMP
	if(time_left < 0)
		time_ban_date = null
		time_ban_expiration = null
		time_ban_admin_id = null
		time_ban_reason = null
		is_time_banned = FALSE
		save()

/datum/entity/player/proc/auto_unjobban()
	for(var/key in job_bans)
		var/datum/entity/player_job_ban/value = job_bans[key]
		var/time_left = value.expiration - MINUTES_STAMP
		if(value.ban_time && time_left < 0)
			value.delete()
			job_bans -= value

/datum/entity_meta/player/on_read(datum/entity/player/player)
	player.job_bans = list()
	player.notes = list()
	player.notes_loaded = FALSE
	player.jobbans_loaded = FALSE
	player.playtime_loaded = FALSE

	player.is_permabanned = text2num(player.is_permabanned)
	player.is_time_banned = text2num(player.is_time_banned)
	player.time_ban_expiration = text2num(player.time_ban_expiration)

	player.migrated_notes = text2num(player.migrated_notes)
	player.migrated_bans = text2num(player.migrated_bans)
	player.migrated_jobbans = text2num(player.migrated_jobbans)

	player.load_rels()

	player.auto_unban()

/datum/entity_meta/player/on_insert(datum/entity/player/player)
	player.job_bans = list()
	player.notes = list()
	player.notes_loaded = FALSE
	player.jobbans_loaded = FALSE
	player.playtime_loaded = FALSE
	player.stickyban_whitelisted = FALSE

	player.load_rels()

/datum/entity/player/proc/load_rels()
	if(migrated_notes)
		DB_FILTER(/datum/entity/player_note, DB_COMP("player_id", DB_EQUALS, id), CALLBACK(src, TYPE_PROC_REF(/datum/entity/player, on_read_notes)))
	else if(!migrating_notes)
		migrating_notes = TRUE
		INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/entity/player, migrate_notes))

	if(migrated_jobbans)
		DB_FILTER(/datum/entity/player_job_ban, DB_COMP("player_id", DB_EQUALS, id), CALLBACK(src, TYPE_PROC_REF(/datum/entity/player, on_read_job_bans)))
	else if(!migrating_jobbans)
		migrating_jobbans = TRUE
		INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/entity/player, migrate_jobbans))

	DB_FILTER(/datum/entity/player_time, DB_COMP("player_id", DB_EQUALS, id), CALLBACK(src, TYPE_PROC_REF(/datum/entity/player, on_read_timestat)))
	DB_FILTER(/datum/entity/player_stat, DB_COMP("player_id", DB_EQUALS, id), CALLBACK(src, TYPE_PROC_REF(/datum/entity/player, on_read_stats)))

	if(!migrated_bans && !migrating_bans)
		migrating_bans = TRUE
		INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/entity/player, migrate_bans))

	if(permaban_admin_id)
		permaban_admin = DB_ENTITY(/datum/entity/player, permaban_admin_id)
	if(time_ban_admin_id)
		time_ban_admin = DB_ENTITY(/datum/entity/player, time_ban_admin_id)
	if(discord_link_id)
		discord_link = DB_ENTITY(/datum/entity/discord_link, discord_link_id)

	if(whitelist_status)
		var/list/whitelists = splittext(whitelist_status, "|")

		for(var/whitelist in whitelists)
			if(whitelist in GLOB.bitfields["whitelist_status"])
				whitelist_flags |= GLOB.bitfields["whitelist_status"]["[whitelist]"]

/datum/entity/player/proc/on_read_notes(list/datum/entity/player_note/_notes)
	notes_loaded = TRUE
	if(notes)
		notes = _notes

/datum/entity/player/proc/on_read_job_bans(list/datum/entity/player_job_ban/_job_bans)
	jobbans_loaded = TRUE
	if(_job_bans)
		for(var/datum/entity/player_job_ban/JB in _job_bans)
			var/safe_job_name = ckey(JB.role)
			job_bans[safe_job_name] = JB

	auto_unjobban()

/datum/entity/player/proc/on_read_timestat(list/datum/entity/player_time/_stat)
	playtime_loaded = TRUE
	if(_stat) // Viewable playtime statistics are only loaded when the player connects, as they do not need constant updates since playtime is a statistic that is recorded over a long period of time
		LAZYSET(playtime_data, "category", 0)
		LAZYSET(playtime_data, "loaded", FALSE) // The jobs themselves can be loaded whenever a player opens their statistic menu
		LAZYSET(playtime_data, "stored_human_playtime", list())
		LAZYSET(playtime_data, "stored_xeno_playtime", list())
		LAZYSET(playtime_data, "stored_other_playtime", list())

		for(var/datum/entity/player_time/S in _stat)
			LAZYSET(playtimes, S.role_id, S)

/datum/entity/player/proc/on_read_stats(list/datum/entity/player_stat/_stat)
	if(_stat)
		for(var/datum/entity/player_stat/S as anything in _stat)
			LAZYSET(stats, S.stat_id, S)

/datum/entity/player/proc/load_byond_account_age()
	var/list/http_request = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http_request)
		log_admin("Could not check BYOND account age for [ckey] - no response from server.")
		return

	var/body = file2text(http_request["CONTENT"])
	if(!body)
		log_admin("Could not check BYOND account age for [ckey] - invalid response.")
		return

	var/static/regex/regex = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
	if(!regex.Find(body))
		log_admin("Could not check BYOND account age for [ckey] - no valid date in response.")
		return

	byond_account_age = regex.group[1]

/datum/entity/player/proc/find_first_join_date()
	var/list/triplets = search_login_triplet_by_ckey(ckey)

	if(!length(triplets))
		first_join_date = "UNKNOWN"
		return

	var/datum/view_record/login_triplet/first_triplet = triplets[1]
	first_join_date = first_triplet.login_date


/proc/get_player_from_key(key)
	var/safe_key = ckey(key)
	if(!safe_key)
		return null
	var/datum/entity/player/P = DB_EKEY(/datum/entity/player, safe_key)
	P.save()
	P.sync()
	return P

/client/var/datum/entity/player/player_data

/client/proc/load_player_data()
	set waitfor=0
	WAIT_DB_READY
	load_player_data_info(get_player_from_key(ckey))

/client/proc/load_player_data_info(datum/entity/player/player)
	set waitfor = FALSE

	if(ckey != player.ckey)
		error("ALARM: MISMATCH. Loaded player data for client [ckey], player data ckey is [player.ckey], id: [player.id]")
	player_data = player
	player_data.owning_client = src
	if(!player_data.last_login)
		player_data.first_join_date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	if(!player_data.first_join_date)
		player_data.find_first_join_date()
	player_data.last_login = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	player_data.last_known_ip = address
	player_data.last_known_cid = computer_id
	if(!player_data.byond_account_age)
		player_data.load_byond_account_age()
	player_data.save()
	record_login_triplet(player.ckey, address, computer_id)
	player_data.sync()

	if(isSenator(src))
		add_verb(src, /client/proc/whitelist_panel)
	if(isCouncil(src))
		add_verb(src, /client/proc/other_records)

	if(GLOB.RoleAuthority && check_whitelist_status(WHITELIST_PREDATOR))
		clan_info = GET_CLAN_PLAYER(player.id)
		clan_info.sync()

		if(check_whitelist_status(WHITELIST_YAUTJA_LEADER))
			clan_info.clan_rank = GLOB.clan_ranks_ordered[CLAN_RANK_ADMIN]
			clan_info.permissions |= CLAN_PERMISSION_ALL
		else
			clan_info.permissions &= ~CLAN_PERMISSION_ADMIN_MANAGER // Only the leader can manage the ancients

		clan_info.save()

/datum/entity/player/proc/check_ban(computer_id, address, is_telemetry)
	. = list()

	var/list/datum/view_record/stickyban/all_stickies = SSstickyban.check_for_sticky_ban(ckey, address, computer_id)

	if(length(all_stickies))
		var/datum/view_record/stickyban/sticky = all_stickies[1]

		if(!is_telemetry)
			log_access("Failed Login: [ckey] [last_known_cid] [last_known_ip] - Stickybanned (Reason: [sticky.reason])")
			message_admins("Failed Login: [ckey] (IP: [last_known_ip], CID: [last_known_cid]) - Stickybanned (Reason: [sticky.reason])")

		var/appeal
		if(CONFIG_GET(string/banappeals))
			appeal = "\nFor more information on your ban, or to appeal, head to <a href='[CONFIG_GET(string/banappeals)]'>[CONFIG_GET(string/banappeals)]</a>"

		.["desc"] = "\nReason: Stickybanned - [sticky.message] Identifier: [sticky.identifier]\n[appeal]"
		.["reason"] = "ckey/id"

		if(!is_telemetry)
			SSstickyban.match_sticky(sticky.id, ckey, address, computer_id)
		return


	if(!is_time_banned && !is_permabanned)
		return null

	var/appeal
	if(CONFIG_GET(string/banappeals))
		appeal = "\nFor more information on your ban, or to appeal, head to <a href='[CONFIG_GET(string/banappeals)]'>[CONFIG_GET(string/banappeals)]</a>"
	if(is_permabanned)
		var/banner = "Host"
		if(permaban_admin_id)
			var/datum/view_record/players/banning_admin = locate() in DB_VIEW(/datum/view_record/players, DB_COMP("id", DB_EQUALS, permaban_admin_id))
			banner = banning_admin.ckey
		if(!is_telemetry)
			log_access("Failed Login: [ckey] [last_known_cid] [last_known_ip] - Banned [permaban_reason]")
			message_admins("Failed Login: [ckey] id:[last_known_cid] ip:[last_known_ip] - Banned [permaban_reason]")
		.["desc"] = "\nReason: [permaban_reason]\nExpires: <B>PERMANENT</B>\nBy: [banner][appeal]"
		.["reason"] = "ckey/id"
		return .
	if(is_time_banned)
		var/time_left = time_ban_expiration - MINUTES_STAMP
		if(time_left < 0)
			return FALSE
		time_ban_admin.sync()
		var/timeleftstring
		if (time_left >= 1440) //1440 = 1 day in minutes
			timeleftstring = "[round(time_left / 1440, 0.1)] Days"
		else if (time_left >= 60) //60 = 1 hour in minutes
			timeleftstring = "[round(time_left / 60, 0.1)] Hours"
		else
			timeleftstring = "[time_left] Minutes"
		if(!is_telemetry)
			log_access("Failed Login: [ckey] [last_known_cid] [last_known_ip] - Banned [time_ban_reason]")
			message_admins("Failed Login: [ckey] id:[last_known_cid] ip:[last_known_ip] - Banned [time_ban_reason]")
		.["desc"] = "\nReason: [time_ban_reason]\nExpires: [timeleftstring]\nBy: [time_ban_admin.ckey][appeal]"
		.["reason"] = "ckey/id"
		return .
	// shouldn't be here
	return FALSE


/datum/entity/player/proc/migrate_notes()
	var/savefile/info = new("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		notes_loaded = TRUE
		migrated_notes = TRUE
		save()
		return
	if(!notes)
		notes = list()
	for(var/datum/player_info/I in infos)
		var/datum/entity/player_note/note = DB_ENTITY(/datum/entity/player_note)
		notes.Add(note)
		note.player = src
		note.player_id = id
		note.admin_rank = I.rank
		if(!note.admin_rank)
			note.admin_rank = "N/A"
		note.date = I.timestamp
		var/list/splitting = splittext(I.content, "|")
		if(length(splitting) == 1)
			note.text = I.content
			note.is_ban = FALSE
		if(length(splitting) == 3)
			note.text = splitting[3]
			note.ban_time = text2num(replacetext(replacetext(splitting[2],"Duration: ","")," minutes",""))
			note.is_ban = TRUE
		if(length(splitting) == 2)
			note.text = I.content
			note.is_ban = TRUE

		var/admin_ckey = "[ckey(I.author)]"
		var/datum/entity/player/admin = get_player_from_key(admin_ckey)
		admin.sync()

		if(admin)
			note.admin_id = admin.id
			note.admin = admin

		note.save()
		CHECK_TICK
	notes_loaded = TRUE
	migrated_notes = TRUE
	save()

/datum/entity/player/proc/migrate_bans()
	if(!GLOB.Banlist) // if GLOB.Banlist cannot be located for some reason
		LoadBans() // try to load the bans
		if(!GLOB.Banlist) // uh oh, can't find bans!
			return

	var/reason
	var/expiration
	var/banned_by

	GLOB.Banlist.cd = "/base"

	for (var/A in GLOB.Banlist.dir)
		GLOB.Banlist.cd = "/base/[A]"

		if(ckey != GLOB.Banlist["key"])
			continue

		if(GLOB.Banlist["temp"])
			if (!GetExp(GLOB.Banlist["minutes"]))
				return

		if(expiration > GLOB.Banlist["minutes"])
			return // found longer ban

		reason = GLOB.Banlist["reason"]
		banned_by = GLOB.Banlist["bannedby"]
		expiration = GLOB.Banlist["minutes"]

	migrated_bans = TRUE
	save()

	if(!expiration)
		return

	var/admin_ckey = "[ckey(banned_by)]"
	var/datum/entity/player/admin = get_player_from_key(admin_ckey)
	admin.sync()

	is_time_banned = TRUE
	time_ban_reason = reason
	time_ban_admin_id = admin.id
	time_ban_expiration = expiration
	time_ban_admin = admin

	save()

/datum/entity/player/proc/migrate_jobbans()
	if(!job_bans)
		job_bans = list()
	for(var/name in GLOB.RoleAuthority.roles_for_mode)
		var/safe_job_name = ckey(name)
		if(!GLOB.jobban_keylist[safe_job_name])
			continue
		if(!safe_job_name)
			continue
		var/reason = GLOB.jobban_keylist[safe_job_name][ckey]
		if(!reason)
			continue

		var/datum/entity/player_job_ban/PJB = DB_ENTITY(/datum/entity/player_job_ban)
		PJB.player_id = id
		PJB.text = reason
		PJB.role = safe_job_name

		PJB.save()

		job_bans["[safe_job_name]"] = PJB
		CHECK_TICK

	jobbans_loaded = TRUE
	migrated_jobbans = TRUE
	save()

/datum/entity/player/proc/adjust_stat(stat_id, stat_category, num, set_to_num = FALSE)
	var/datum/entity/player_stat/stat = LAZYACCESS(stats, stat_id)
	if(!stat)
		stat = DB_ENTITY(/datum/entity/player_stat)
		stat.player_id = id
		stat.stat_id = stat_id
		stat.stat_category = stat_category
		LAZYSET(stats, stat_id, stat)
	if(set_to_num)
		stat.stat_number = num
	else
		stat.stat_number += num
	stat.save()

/datum/entity/player/proc/check_whitelist_status(flag_to_check)
	if(whitelist_flags & flag_to_check)
		return TRUE

	return FALSE

/datum/entity/player/proc/set_whitelist_status(field_to_set)
	whitelist_flags = field_to_set

	var/list/output = list()
	for(var/bitfield in GLOB.bitfields["whitelist_status"])
		if(field_to_set & GLOB.bitfields["whitelist_status"]["[bitfield]"])
			output += bitfield
	whitelist_status = output.Join("|")

	save()

/datum/entity_link/player_to_banning_admin
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player
	child_field = "time_ban_admin_id"

	parent_name = "banning_admin"


/datum/entity_link/player_to_permabanning_admin
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player
	child_field = "permaban_admin_id"
	parent_name = "permabanning_admin"

/datum/view_record/players
	var/id
	var/ckey
	var/is_permabanned
	var/is_time_banned
	var/ban_type
	var/reason
	var/date
	var/expiration
	var/admin
	var/last_known_cid
	var/last_known_ip
	var/discord_link_id
	var/whitelist_status

/datum/entity_view_meta/players
	root_record_type = /datum/entity/player
	destination_entity = /datum/view_record/players
	fields = list(
		"id",
		"ckey",
		"is_permabanned", // this one for the machine
		"is_time_banned",
		"ban_type" = DB_CASE(DB_COMP("is_permabanned", DB_EQUALS, 1), DB_CONST("permaban"), DB_CONST("timed ban")), // this one is readable
		"reason" = DB_CASE(DB_COMP("is_permabanned", DB_EQUALS, 1), "permaban_reason", "time_ban_reason"),
		"date" = DB_CASE(DB_COMP("is_permabanned", DB_EQUALS, 1), "permaban_date", "time_ban_date"),
		"expiration" = "time_ban_expiration", //don't care if this is permaban, since it will be handled later
		"admin" = DB_CASE(DB_COMP("is_permabanned", DB_EQUALS, 1), "permabanning_admin.ckey", "banning_admin.ckey"),
		"last_known_ip",
		"last_known_cid",
		"discord_link_id",
		"whitelist_status"
		)
