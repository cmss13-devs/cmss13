/datum/player_action/fun
	action_tag = "fun"
	name = "Fun"
	permissions_required = R_FUN

/datum/player_action/fun/narrate
	action_tag = "mob_narrate"
	name = "Narrate"


/datum/player_action/fun/narrate/act(var/client/user, var/mob/target, var/list/params)
	if(!params["to_narrate"]) return

	to_chat(target, params["to_narrate"])
	message_staff(SPAN_NOTICE("DirectNarrate: [key_name_admin(user)] to ([key_name_admin(target)]): [params["to_narrate"]]"), 1)
	return TRUE

/datum/player_action/fun/explode
	action_tag = "mob_explode"
	name = "Explode"


/datum/player_action/fun/explode/act(var/client/user, var/mob/target, var/list/params)

	var/power = text2num(params["power"])
	var/falloff = text2num(params["falloff"])

	message_staff("[key_name_admin(user)] dropped a custom cell bomb with power [power], falloff [falloff] on [target.name]!")
	cell_explosion(get_turf(target), power, falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, user.ckey, user)
	return TRUE
