DEFINE_ENTITY(discord_identifier, "discord_identifiers")
FIELD_STRING_LARGE(discord_identifier, identifier)
FIELD_BIGINT(discord_identifier, playerid)
FIELD_DEFAULT_VALUE_BIGINT(discord_identifier, realtime, world.realtime)
FIELD_DEFAULT_VALUE_INT(discord_identifier, used, FALSE)
KEY_FIELD(discord_identifier, identifier)

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
