// MUTINEER
/datum/player_action/make_mutineer
	action_tag = "make_mutineer"
	name = "Make Mutineer"

/datum/player_action/make_mutineer/act(client/user, mob/target, list/params)
	if(!ishuman(target))
		to_chat(user, SPAN_WARNING("This can only be done to instances of type /mob/living/carbon/human"))
		return

	var/mob/living/carbon/human/H = target
	var/datum/equipment_preset/preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/mutiny/mutineer]
	if(params["leader"])
		preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/mutiny/mutineer/leader]


	preset.load_status(H)

	var/title = params["leader"]? "mutineer leader" : "mutineer"
	message_admins("[key_name_admin(user)] has made [key_name_admin(H)] into a [title].")

// XENO
/datum/player_action/change_hivenumber
	action_tag = "xeno_change_hivenumber"
	name = "Change Hivenumber"
	permissions_required = R_SPAWN

/datum/player_action/change_hivenumber/act(client/user, mob/target, list/params)
	if(!params["hivenumber"])
		return

	if(!isxeno(target))
		return

	var/mob/living/carbon/xenomorph/X = target

	X.set_hive_and_update(params["hivenumber"])
	message_admins("[key_name_admin(user)] changed hivenumber of [target] to [params["hivenumber"]].")
	return TRUE

/datum/player_action/make_cultist
	action_tag = "make_cultist"
	name = "Make Cultist"
	permissions_required = R_ADMIN

/datum/player_action/make_cultist/act(client/user, mob/target, list/params)
	if(!params["hivenumber"])
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target
	var/datum/equipment_preset/preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/xeno_cultist]

	if(params["leader"])
		preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/xeno_cultist/leader]

	preset.load_race(H)
	preset.load_status(H, params["hivenumber"])

	var/title = params["leader"]? "xeno cultist leader" : "cultist"

	message_admins("[key_name_admin(user)] has made [target] into a [title], enslaved to hivenumber [params["hivenumber"]].")
	return TRUE
