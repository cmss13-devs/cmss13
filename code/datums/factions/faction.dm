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

	var/list/role_mappings = list(
		MODE_NAME_EXTENDED = list(),
		MODE_NAME_DISTRESS_SIGNAL = list(),
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list(),
	)
	var/list/roles_list = list()
	var/list/coefficient_per_role = list()
	var/weight_act = list(
		MODE_NAME_EXTENDED = TRUE,
		MODE_NAME_DISTRESS_SIGNAL = TRUE,
		MODE_NAME_FACTION_CLASH = TRUE,
		MODE_NAME_WISKEY_OUTPOST = TRUE,
		MODE_NAME_HUNTER_GAMES = TRUE,
		MODE_NAME_HIVE_WARS = TRUE,
		MODE_NAME_INFECTION = TRUE,
	)

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
	if(!istype(src, /datum/faction/xenomorph))
		GLOB.faction_by_name_humanoid[name] = src

/datum/faction/proc/get_faction_module(module_required)
	if(module_required in faction_modules)
		return faction_modules[module_required]

/datum/faction/proc/add_mob(mob/living/carbon/creature)
	if(!istype(creature))
		return

	for(var/faction_module_to_get in faction_modules)
		var/datum/faction_module/faction_module = faction_modules[faction_module_to_get]
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

	for(var/faction_module_to_get in faction_modules)
		var/datum/faction_module/faction_module = faction_modules[faction_module_to_get]
		faction_module.remove_mob(creature, hard, light_mode)

	if(hard)
		creature.faction = null
		total_dead_mobs -= creature
	else
		total_dead_mobs |= creature

	total_mobs -= creature

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


//Roles and join stuff
/datum/faction/proc/get_role_coeff(role_name)
	if(coefficient_per_role[role_name])
		return coefficient_per_role[role_name]
	return 1

/datum/faction/proc/get_join_status(mob/new_player/user, dat)
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence... or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	dat = "<html><body onselectstart='return false;'><center>"
	dat += "Round Duration: [floor(hours)]h [floor(mins)]m<br>"

	dat += additional_join_status_info(user)

	if(!latejoin_enabled)
		dat = "Latejoin disabled<br>"
//	else if(!SSautobalancer.can_join(src)) // WILL BE INTRODUCED IN STAGE 2 (another PR)
//		dat = "Due to balance issues joining closed<br>"
	else
		dat += "Choose from the following open positions:<br>"
		dat += custom_faction_job_fill(user)

	dat += "</center>"
	show_browser(src, dat, "Late Join", "latechoices", "size=420x700")

/datum/faction/proc/additional_join_status_info(mob/new_player/user)
	return

/datum/faction/proc/custom_faction_job_fill(mob/new_player/user)
	. = ""
	var/list/roles = roles_list[SSticker.mode.name]
	for(var/i in roles)
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[i]
		var/check_result = GLOB.RoleAuthority.check_role_entry(user, job, src, TRUE)
		var/active = 0
		for(var/mob/mob in GLOB.player_list)
			if(mob.client && mob.job == job.title)
				active++

		if(check_result)
			. += "[job.disp_title] ([job.current_positions]): [check_result] (Active: [active])<br>"
		else
			. += "<a href='byond://?src=\ref[user];lobby_choice=SelectedJob;job_selected=[job.title]'>[job.disp_title] ([job.current_positions]) (Active: [active])</a><br>"
