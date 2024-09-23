/datum/entity/discord_identifier
	var/identifier
	var/playerid
	var/realtime
	var/used = FALSE

/datum/entity/discord_identifier/New()
	. = ..()

	realtime = world.realtime

/datum/entity_meta/discord_identifier
	entity_type = /datum/entity/discord_identifier
	table_name = "discord_identifiers"
	key_field = "identifier"

	field_typepaths = list(
		"identifier" = DB_FIELDTYPE_STRING_LARGE,
		"playerid" = DB_FIELDTYPE_BIGINT,
		"realtime" = DB_FIELDTYPE_BIGINT,
		"used" = DB_FIELDTYPE_INT,
	)

/datum/view_record/discord_identifier
	var/identifier
	var/playerid
	var/realtime
	var/used

/datum/entity_view_meta/discord_identifier
	root_record_type = /datum/entity/discord_identifier
	destination_entity = /datum/view_record/discord_identifier
	fields = list(
		"identifier",
		"playerid",
		"realtime",
		"used",
	)
	order_by = list("identifier" = DB_ORDER_BY_ASC)

/proc/get_discord_identifier_by_token(token)
	var/datum/entity/discord_identifier/ident = DB_EKEY(/datum/entity/discord_identifier, token)
	ident.save()
	ident.sync()
	return ident
