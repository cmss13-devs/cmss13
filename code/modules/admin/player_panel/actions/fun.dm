/datum/player_action/fun
	action_tag = "fun"
	name = "Fun"
	permissions_required = R_ADMIN

/datum/player_action/fun/narrate
	action_tag = "mob_narrate"
	name = "Narrate"


/datum/player_action/fun/narrate/act(client/user, mob/target, list/params)
	if(!params["to_narrate"])
		return

	to_chat(target, params["to_narrate"])
	message_admins("DirectNarrate: [key_name_admin(user)] to ([key_name_admin(target)]): [params["to_narrate"]]")
	return TRUE

/datum/player_action/fun/explode
	action_tag = "mob_explode"
	name = "Explode"


/datum/player_action/fun/explode/act(client/user, mob/target, list/params)

	var/power = text2num(params["power"])
	var/falloff = text2num(params["falloff"])

	message_admins("[key_name_admin(user)] dropped a custom cell bomb with power [power], falloff [falloff] on [target.name]!")
	cell_explosion(get_turf(target), power, falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("divine intervention", user))
	return TRUE
