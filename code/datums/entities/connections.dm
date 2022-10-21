/datum/entity/connection
	var/ckey
	var/cid
	var/ip
	var/time
	var/byond_version

BSQL_PROTECT_DATUM(/datum/entity/connection)

/datum/entity_meta/connection
	entity_type = /datum/entity/connection
	table_name = "log_connection"
	field_types = list(
			"ckey"=DB_FIELDTYPE_STRING_MEDIUM,
			"cid"=DB_FIELDTYPE_STRING_SMALL,
			"ip"=DB_FIELDTYPE_STRING_SMALL,
			"time"=DB_FIELDTYPE_DATE,
			"byond_version"=DB_FIELDTYPE_STRING_SMALL,
		)
