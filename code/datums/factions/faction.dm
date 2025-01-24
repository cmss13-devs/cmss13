/datum/faction
	var/name = "Neutral Faction"
	var/desc = "Neutral Faction"
	var/code_identificator = FACTION_NEUTRAL

	var/hud_type = FACTION_HUD
	var/color = "#22888a"
	var/ui_color = "#22888a"
	var/faction_orders = ""
	var/prefix = ""

	var/relations_pregen[] = RELATIONS_NEUTRAL
	var/datum/faction_module/relations/relations_datum

	var/organ_faction_iff_tag_type // Our faction have something like zenomoprhs gland?
	var/faction_iff_tag_type // Simply ass metal stick in body, those spy chips got so high tech!!! O kurwa!

	var/list/total_mobs = list() // All mobs linked to faction
	var/list/total_dead_mobs = list() // All dead mobs linked to faction
	var/list/late_join_landmarks = list() // Flexible latejoin landmarks per faction

	var/list/role_mappings = list()
	var/list/roles_list = list()
	var/list/coefficient_per_role = list()

	var/list/banished_ckeys = list()

	var/spawning_enabled = TRUE
	var/latejoin_enabled = TRUE
	var/force_spawning = FALSE

	var/need_round_end_check = TRUE
	var/minimap_flag = NO_FLAGS

	var/list/datum/faction_module/faction_modules = list()

/datum/faction/New()
	relations_datum = new(src)
	GLOB.custom_event_info_list[code_identificator] = new /datum/custom_event_info(src, null, code_identificator)

/datum/faction/proc/get_faction_module(module_required)
	if(module_required in faction_modules)
		return faction_modules[module_required]

/datum/faction/proc/add_mob(mob/living/carbon/creature)
	if(!istype(creature))
		return

	for(var/datum/faction_module/faction_module in faction_modules)
		faction_module.add_mob(creature)

	if(creature.faction && creature.faction != src)
		creature.faction.remove_mob(creature, TRUE)

	creature.faction = src

	if(creature.hud_list)
		creature.hud_update()

	if(!creature.statistic_exempt)
		total_mobs |= creature

/datum/faction/proc/remove_mob(mob/living/carbon/creature, hard = FALSE, light_mode = FALSE)
	if(!istype(creature))
		return

	for(var/datum/faction_module/faction_module in faction_modules)
		faction_module.remove_mob(creature, hard, light_mode)

	if(hard)
		creature.faction = null
	else
		total_dead_mobs |= creature

	total_mobs -= creature

/datum/faction/proc/get_join_status(mob/new_player/user, dat)/*
	dat = "<html><body onselectstart='return false;'><center>"
	dat += "[user.client.auto_lang(LANGUAGE_LOBBY_ROUND_TIME)]: [DisplayTimeText(world.time, language = user.client.language)]<br>"
	dat += "[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CHOSE)]:<br>"
	dat += additional_join_status(user)

	if(!latejoin_enabled)
		dat = "[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CLOSED)]:<br>"

	else if(!SSautobalancer.can_join(src))
		dat = "[user.client.auto_lang(LANGUAGE_JS_BALANCE_ISSUE)]:<br>"

	else
		var/list/roles = roles_list[SSticker.mode.name]
		for(var/i in roles)
			var/datum/job/job = GLOB.RoleAuthority.roles_by_name[i]
			var/check_result = GLOB.RoleAuthority.check_role_entry(user, job, src, TRUE)
			var/active = 0
			for(var/mob/mob in GLOB.player_list)
				if(mob.client && mob.job == job.title)
					active++

			if(check_result)
				dat += "[job.disp_title] ([job.current_positions]): [check_result] ([user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ACTIVE)]: [active])<br>"
			else
				dat += "<a href='byond://?src=\ref[user];lobby_choice=SelectedJob;job_selected=[job.title]'>[job.disp_title] ([job.current_positions]) ([user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ACTIVE)]: [active])</a><br>"

	dat += "</center>"
	show_browser(user, dat, user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN), "latechoices", "size=420x700")
*/
/datum/faction/proc/can_delay_round_end(mob/living/carbon/creature)
	return TRUE

// Friend or Foe functional
/atom/movable/proc/ally_faction(datum/faction/ally_faction)
	return FALSE

/obj/vehicle/multitile/ally_faction(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	var/list/factions = list()
	factions += ally_faction
	for(var/datum/faction/ally in ally_faction.relations_datum.allies)
		factions += ally
	if(isnull(factions) || !faction)
		return FALSE

	return faction in factions

/mob/ally_faction(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	if(client in ally_faction.banished_ckeys)
		return FALSE

	// Hard times, so basicaly if you organical... domain faction... You can figure it out on your self, without HIGH tech shit.
	if(organ_faction_tag)
		. += ally_faction.organ_faction_tag_is_ally(organ_faction_tag)
	if(faction_tag)
		. += ally_faction.faction_tag_is_ally(faction_tag)

/datum/faction/proc/organ_faction_tag_is_ally(obj/item/faction_tag/organ/organ_tag)
	if(organ_tag.faction == src)
		return TRUE

	for(var/datum/faction/faction in organ_tag.factions)
		if(relations_datum.allies[faction.code_identificator])
			return TRUE
	return FALSE

/datum/faction/proc/faction_tag_is_ally(obj/item/faction_tag/obj_tag)
	if(obj_tag.faction == src)
		return TRUE

	for(var/datum/faction/faction in obj_tag.factions)
		if(relations_datum.allies[faction.code_identificator])
			return TRUE
	return FALSE

/datum/faction/proc/faction_is_ally(datum/faction/faction_to_check)
	if(relations_datum.allies[faction_to_check.code_identificator])
		return TRUE

	return FALSE

//Minor functions
/datum/faction/proc/modify_hud_holder(image/holder, mob/living/carbon/human/creature)
	return

/datum/faction/proc/get_antag_guns_snowflake_equipment()
	return list()

/datum/faction/proc/get_antag_guns_sorted_equipment()
	return list()
