DEFINE_ENTITY(discord_link, "discord_links")
FIELD_BIGINT(discord_link, player_id)
FIELD_STRING_MEDIUM(discord_link, discord_id)
KEY_FIELD(discord_link, discord_id)

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


