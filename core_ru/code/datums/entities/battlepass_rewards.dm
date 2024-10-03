GLOBAL_LIST_INIT_TYPED(battlepass_rewards, /datum/view_record/battlepass_reward, load_battlepass_rewards())

/proc/load_battlepass_rewards()
	WAIT_DB_READY
	var/list/all_rewards = list()
	var/list/datum/view_record/battlepass_reward/rewards = DB_VIEW(/datum/view_record/battlepass_reward)
	for(var/datum/view_record/battlepass_reward/reward as anything in rewards)
		all_rewards[reward.unique_name] = reward
	return all_rewards

/datum/entity/battlepass_reward
	var/unique_name
	var/name
	var/icon_state
	var/lifeform_type

	var/reward_type
	var/reward_data

	var/list/mapped_reward_data

BSQL_PROTECT_DATUM(/datum/entity/battlepass_reward)

/datum/entity_meta/battlepass_reward
	entity_type = /datum/entity/battlepass_reward
	table_name = "battlepass_rewards"
	field_types = list(
		"unique_name" = DB_FIELDTYPE_STRING_LARGE,
		"name" = DB_FIELDTYPE_STRING_LARGE,
		"icon_state" = DB_FIELDTYPE_STRING_MAX,
		"lifeform_type" = DB_FIELDTYPE_STRING_LARGE,
		"reward_type" = DB_FIELDTYPE_STRING_LARGE,
		"reward_data" = DB_FIELDTYPE_STRING_MAX,
	)
	key_field = "unique_name"

/datum/entity_meta/battlepass_reward/map(datum/entity/battlepass_reward/reward, list/values)
	. = ..()
	if(values["reward_data"])
		reward.mapped_reward_data = json_decode(values["reward_data"])

/datum/entity_meta/battlepass_reward/unmap(datum/entity/battlepass_reward/reward)
	. = ..()
	if(length(reward.mapped_reward_data))
		.["reward_data"] = json_encode(reward.mapped_reward_data)

//BATTLEPASS REWARD ENTITY VIEW META
/datum/view_record/battlepass_reward
	var/unique_name
	var/name
	var/icon_state
	var/lifeform_type

	var/reward_type
	var/reward_data

	var/list/mapped_reward_data

/datum/entity_view_meta/battlepass_reward
	root_record_type = /datum/entity/battlepass_reward
	destination_entity = /datum/view_record/battlepass_reward
	fields = list(
		"unique_name",
		"name",
		"icon_state",
		"lifeform_type",
		"reward_type",
		"reward_data",
	)

/datum/entity_view_meta/battlepass_reward/map(datum/view_record/battlepass_reward/reward, list/values)
	. = ..()
	if(values["reward_data"])
		reward.mapped_reward_data = json_decode(values["reward_data"])

/datum/view_record/battlepass_reward/proc/get_ui_data(list/data)
	. = list()
	.["tier"] = data["tier"]
	.["name"] = name
	.["icon_state"] = icon_state
	.["lifeform_type"] = lifeform_type
