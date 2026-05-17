
/datum/entity/authentication_request
	var/access_code
	var/ip
	var/cid
	var/time

	var/approved = FALSE
	var/authentication_method
	var/external_username
	var/internal_user_id

/datum/entity_meta/authentication_request
	entity_type = /datum/entity/authentication_request
	table_name = "authentication_requests"
	field_types = list(
		"access_code" = DB_FIELDTYPE_STRING_MEDIUM,
		"ip" = DB_FIELDTYPE_STRING_MEDIUM,
		"cid" = DB_FIELDTYPE_STRING_MEDIUM,
		"time" = DB_FIELDTYPE_DATE,
		"approved" = DB_FIELDTYPE_INT,
		"authentication_method" = DB_FIELDTYPE_STRING_MEDIUM,
		"external_username" = DB_FIELDTYPE_STRING_MEDIUM,
		"internal_user_id" = DB_FIELDTYPE_INT,
	)

/datum/view_record/authentication_request
	var/access_code
	var/ip
	var/cid
	var/time

	var/approved
	var/authentication_method
	var/external_username
	var/internal_user_id

/datum/entity_view_meta/authentication_request
	root_record_type = /datum/entity/authentication_request
	destination_entity = /datum/view_record/authentication_request
	fields = list(
		"access_code",
		"ip",
		"cid",
		"time",
		"approved",
		"authentication_method",
		"external_username",
		"internal_user_id",
	)
