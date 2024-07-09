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
