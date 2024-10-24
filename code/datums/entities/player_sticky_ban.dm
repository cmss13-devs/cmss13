BSQL_PROTECT_DATUM(/datum/entity/stickyban)

DEFINE_ENTITY(stickyban, "stickyban")
FIELD_STRING_LARGE(stickyban, identifier)
FIELD_STRING_MAX(stickyban, reason)
FIELD_STRING_MAX(stickyban, message)
FIELD_STRING_LARGE(stickyban, date)
FIELD_DEFAULT_VALUE_INT(stickyban, active, TRUE)
FIELD_BIGINT(stickyban, adminid)

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
	child_foreign_key = "adminid"

DEFINE_ENTITY(stickyban_matched_ckey, "stickyban_matched_ckey")
FIELD_STRING_LARGE(stickyban_matched_ckey, ckey)
FIELD_BIGINT(stickyban_matched_ckey, linked_stickyban)
FIELD_DEFAULT_VALUE_INT(stickyban_matched_ckey, whitelisted, FALSE)

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

DEFINE_ENTITY(stickyban_matched_cid, "stickyban_matched_cid")
FIELD_STRING_LARGE(stickyban_matched_cid, cid)
FIELD_BIGINT(stickyban_matched_cid, linked_stickyban)

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

DEFINE_ENTITY(stickyban_matched_ip, "stickyban_matched_ip")
FIELD_STRING_LARGE(stickyban_matched_ip, ip)
FIELD_BIGINT(stickyban_matched_ip, linked_stickyban)

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
