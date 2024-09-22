/datum/entity/discord_link
	var/player_id
	var/discord_id

/datum/entity_meta/discord_link
	entity_type = /datum/entity/discord_link
	table_name = "discord_links"
	key_field = "discord_id"

	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"discord_id" = DB_FIELDTYPE_STRING_MEDIUM,
	)

/datum/view_record/discord_link
	var/id
	var/player_id
	var/discord_id

/datum/entity_view_meta/discord_link
	root_record_type = /datum/entity/discord_link
	destination_entity = /datum/view_record/discord_link
	fields = list(
		"id",
		"player_id",
		"discord_id",
	)
	order_by = list("player_id" = DB_ORDER_BY_ASC)

/datum/entity_link/player_to_discord
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/discord_link
	child_foreign_key = "player_id"

	parent_name = "player"
	child_name = "discord_link_id"


