BSQL_PROTECT_DATUM(/datum/entity/stickyban)

/datum/entity/stickyban
	var/identifier
	var/reason
	var/message
	var/date
	var/active = TRUE
	var/adminid

/datum/entity_meta/stickyban
	entity_type = /datum/entity/stickyban
	table_name = "stickyban"
	field_types = list(
		"identifier" = DB_FIELDTYPE_STRING_LARGE,
		"reason" = DB_FIELDTYPE_STRING_MAX,
		"message" = DB_FIELDTYPE_STRING_MAX,
		"date" = DB_FIELDTYPE_STRING_LARGE,
		"active" = DB_FIELDTYPE_INT,
		"adminid" = DB_FIELDTYPE_BIGINT,
	)

/datum/view_record/stickyban
	var/id
	var/identifier
	var/reason
	var/message
	var/date
	var/active
	var/admin

/datum/entity_view_meta/stickyban
	root_record_type = /datum/entity/stickyban
	destination_entity = /datum/view_record/stickyban
	fields = list(
		"id",
		"identifier",
		"reason",
		"message",
		"date",
		"active",
		"admin" = DB_CASE(DB_COMP("adminid", DB_ISNOT), "stickybanning_admin.ckey", DB_CONST("AdminBot"))
	)

/datum/entity_link/stickyban_to_banning_admin
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/stickyban
	child_field = "adminid"
	parent_name = "stickybanning_admin"

/datum/entity/stickyban_matched_ckey
	var/ckey
	var/linked_stickyban
	var/whitelisted = FALSE

/datum/entity_meta/stickyban_matched_ckey
	entity_type = /datum/entity/stickyban_matched_ckey
	table_name = "stickyban_matched_ckey"
	field_types = list(
		"ckey" = DB_FIELDTYPE_STRING_LARGE,
		"linked_stickyban" = DB_FIELDTYPE_BIGINT,
		"whitelisted" = DB_FIELDTYPE_INT,
	)

/datum/view_record/stickyban_matched_ckey
	var/id
	var/ckey
	var/linked_stickyban
	var/whitelisted

/datum/entity_view_meta/stickyban_matched_ckey
	root_record_type = /datum/entity/stickyban_matched_ckey
	destination_entity = /datum/view_record/stickyban_matched_ckey
	fields = list(
		"id",
		"ckey",
		"linked_stickyban",
		"whitelisted",
	)


/datum/entity/stickyban_matched_cid
	var/cid
	var/linked_stickyban

/datum/entity_meta/stickyban_matched_cid
	entity_type = /datum/entity/stickyban_matched_cid
	table_name = "stickyban_matched_cid"
	field_types = list(
		"cid" = DB_FIELDTYPE_STRING_LARGE,
		"linked_stickyban" = DB_FIELDTYPE_BIGINT,
	)

/datum/view_record/stickyban_matched_cid
	var/id
	var/cid
	var/linked_stickyban

/datum/entity_view_meta/stickyban_matched_cid
	root_record_type = /datum/entity/stickyban_matched_cid
	destination_entity = /datum/view_record/stickyban_matched_cid
	fields = list(
		"id",
		"cid",
		"linked_stickyban",
	)


/datum/entity/stickyban_matched_ip
	var/ip
	var/linked_stickyban

/datum/entity_meta/stickyban_matched_ip
	entity_type = /datum/entity/stickyban_matched_ip
	table_name = "stickyban_matched_ip"
	field_types = list(
		"ip" = DB_FIELDTYPE_STRING_LARGE,
		"linked_stickyban" = DB_FIELDTYPE_BIGINT,
	)

/datum/view_record/stickyban_matched_ip
	var/id
	var/ip
	var/linked_stickyban

/datum/entity_view_meta/stickyban_matched_ip
	root_record_type = /datum/entity/stickyban_matched_ip
	destination_entity = /datum/view_record/stickyban_matched_ip
	fields = list(
		"id",
		"ip",
		"linked_stickyban",
	)

/// Returns either a list containing the primary CKEYs this alt is connected to,
/// or FALSE.
/proc/get_player_is_alt(ckey)
	var/list/datum/view_record/known_alt/alts = DB_VIEW(/datum/view_record/known_alt, DB_COMP("ckey", DB_EQUALS, ckey))
	if(!length(alts))
		return FALSE

	var/ckeys = list()
	for(var/datum/view_record/known_alt/alt as anything in alts)
		ckeys += alt.player_ckey

	return ckeys

/client/proc/add_known_alt()
	set name = "Add Known Alt"
	set category = "Admin.Alt"

	var/player_ckey = ckey(tgui_input_text(src, "What is the player's primary Ckey?", "Player Ckey"))
	if(!player_ckey)
		return

	var/datum/entity/player/player = get_player_from_key(player_ckey)
	if(!istype(player))
		return

	var/existing_alts = get_player_is_alt(player_ckey)
	if(existing_alts)
		var/confirm = tgui_alert(src, "Primary Ckey [player_ckey] is already an alt for [english_list(existing_alts)].", "Primary Ckey", list("Confirm", "Cancel"))

		if(confirm != "Confirm")
			return

	var/whitelist_to_add = ckey(tgui_input_text(src, "What is the Ckey that should be added to known alts?", "Alt Ckey"))
	if(!whitelist_to_add)
		return

	var/alts_existing_primaries = get_player_is_alt(whitelist_to_add)
	if(alts_existing_primaries)
		if(player_ckey in alts_existing_primaries)
			to_chat(src, SPAN_WARNING("The alt '[whitelist_to_add]' is already set as an alt Ckey for '[player_ckey]'."))
			return

		var/confirm = tgui_alert(src, "Alt is already an alt for [english_list(alts_existing_primaries)].", "Alt Ckey", list("Confirm", "Cancel"))

		if(confirm != "Confirm")
			return

	var/datum/entity/known_alt/alt = DB_ENTITY(/datum/entity/known_alt)
	alt.player_id = player.id
	alt.player_ckey = player.ckey
	alt.ckey = whitelist_to_add

	alt.save()

	to_chat(src, SPAN_NOTICE("[alt.ckey] added to the known alts of [player.ckey]."))

/client/proc/remove_known_alt()
	set name = "Remove Known Alt"
	set category = "Admin.Alt"

	var/player_ckey = ckey(tgui_input_text(src, "What is the player's primary Ckey?", "Player Ckey"))
	if(!player_ckey)
		return

	var/datum/entity/player/player = get_player_from_key(player_ckey)
	if(!istype(player))
		return

	var/existing_alts = get_player_is_alt(player_ckey)
	if(existing_alts)
		var/confirm = tgui_alert(src, "Primary Ckey [player_ckey] is already an alt for [english_list(existing_alts)].", "Primary Ckey", list("Confirm", "Cancel"))

		if(confirm != "Confirm")
			return

	var/list/datum/view_record/known_alt/alts = DB_VIEW(/datum/view_record/known_alt, DB_COMP("player_id", DB_EQUALS, player.id))
	if(!length(alts))
		to_chat(src, SPAN_WARNING("User has no alts on record."))
		return

	var/options = list()
	for(var/datum/view_record/known_alt/alt in alts)
		options[alt.ckey] = alt.id

	var/picked = tgui_input_list(src, "Which known alt should be removed?", "Alt Removal", options)
	if(!picked)
		return

	var/picked_id = options[picked]
	var/datum/entity/known_alt/to_delete = DB_ENTITY(/datum/entity/known_alt, picked_id)
	to_delete.delete()

	to_chat(src, SPAN_NOTICE("[picked] removed from the known alts of [player.ckey]."))

/datum/entity/known_alt
	var/player_id
	var/player_ckey
	var/ckey

/datum/entity_meta/known_alt
	entity_type = /datum/entity/known_alt
	table_name = "known_alts"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"player_ckey" = DB_FIELDTYPE_STRING_LARGE,
		"ckey" = DB_FIELDTYPE_STRING_LARGE,
	)

/datum/view_record/known_alt
	var/id
	var/player_id
	var/player_ckey
	var/ckey

/datum/entity_view_meta/known_alt
	root_record_type = /datum/entity/known_alt
	destination_entity = /datum/view_record/known_alt
	fields = list(
		"id",
		"player_id",
		"player_ckey",
		"ckey",
	)
