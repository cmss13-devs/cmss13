// MUTINEER
/datum/player_action/make_mutineer
	action_tag = "make_mutineer"
	name = "Make Mutineer"

/datum/player_action/make_mutineer/act(var/client/user, var/mob/target, var/list/params)
	if(!ishuman(target))
		to_chat(user, SPAN_WARNING("This can only be done to instances of type /mob/living/carbon/human"))
		return

	var/mob/living/carbon/human/H = target

	if(H.faction != FACTION_MARINE)
		to_chat(user, SPAN_WARNING("This player's faction must equal '[FACTION_MARINE]' to make them a mutineer."))
		return

	var/datum/equipment_preset/preset = gear_presets_list["Mutineer"]
	if(params["leader"])
		preset = gear_presets_list["Mutineer Leader"]


	preset.load_status(H)

	var/title = params["leader"]? "mutineer leader" : "mutineer"
	message_staff("[key_name_admin(user)] has made [key_name_admin(H)] into a [title].")

// XENO
/datum/player_action/change_hivenumber
	action_tag = "xeno_change_hivenumber"
	name = "Change Hivenumber"
	permissions_required = R_SPAWN

/datum/player_action/change_hivenumber/act(var/client/user, var/mob/target, var/list/params)
	if(!params["hivenumber"])
		return

	if(!isXeno(target))
		return

	if(params["hivenumber"] > length(GLOB.hive_datum))
		return

	var/mob/living/carbon/Xenomorph/X = target

	X.set_hive_and_update(params["hivenumber"])
	message_staff(SPAN_NOTICE("[key_name_admin(user)] changed hivenumber of [target] to [params["hivenumber"]]."))
	return TRUE

/datum/player_action/make_cultist
	action_tag = "make_cultist"
	name = "Make Cultist"
	permissions_required = R_FUN

/datum/player_action/make_cultist/act(var/client/user, var/mob/target, var/list/params)
	if(!params["hivenumber"])
		return

	if(!ishuman(target))
		return

	if(params["hivenumber"] > length(GLOB.hive_datum))
		return

	var/mob/living/carbon/human/H = target
	var/datum/equipment_preset/preset = gear_presets_list["Cultist - Xeno Cultist"]

	if(params["leader"])
		preset = gear_presets_list["Cultist - Xeno Cultist Leader"]


	preset.load_race(H, params["hivenumber"])
	preset.load_status(H)

	var/title = params["leader"]? "xeno cultist leader" : "cultist"

	message_staff(SPAN_NOTICE("[key_name_admin(user)] has made [target] into a [title], enslaved to hivenumber [params["hivenumber"]]."))
	return TRUE
