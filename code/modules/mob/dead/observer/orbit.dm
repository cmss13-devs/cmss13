/datum/orbit_menu
	var/mob/dead/observer/owner

/datum/orbit_menu/New(mob/dead/observer/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/orbit_menu/ui_state(mob/user)
	return GLOB.observer_state

/datum/orbit_menu/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Orbit")
		ui.open()

/datum/orbit_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("orbit")
			var/ref = params["ref"]
			var/atom/movable/poi = locate(ref) in GLOB.mob_list
			if (poi == null)
				poi = locate(ref) in GLOB.all_multi_vehicles
				if (poi == null)
					. = TRUE
					return
			owner.do_observe(poi)
			. = TRUE
		if("refresh")
			update_static_data(owner)
			. = TRUE
		if("toggle_auto_observe")
			ui.user.client?.prefs?.auto_observe = !ui.user?.client?.prefs.auto_observe
			ui.user.client?.prefs?.save_preferences()
			. = TRUE

/datum/orbit_menu/ui_data(mob/user)
	var/list/data = list()

	data["auto_observe"] = user.client?.prefs?.auto_observe
	return data

/datum/orbit_menu/ui_static_data(mob/user)
	var/list/data = list()

	var/list/humans = list()
	var/list/responders = list()
	var/list/marines = list()
	var/list/survivors = list()
	var/list/xenos = list()
	var/list/ert_members = list()
	var/list/upp = list()
	var/list/clf = list()
	var/list/wy = list()
	var/list/twe = list()
	var/list/freelancer = list()
	var/list/contractor = list()
	var/list/mercenary = list()
	var/list/dutch = list()
	var/list/marshal = list()
	var/list/synthetics = list()
	var/list/predators = list()
	var/list/hunted = list()
	var/list/animals = list()
	var/list/dead = list()
	var/list/ghosts = list()
	var/list/misc = list()
	var/list/npcs = list()
	var/list/vehicles = list()
	var/list/escaped = list()
	var/list/in_thunderdome = list()

	var/is_admin = FALSE
	if(user && user.client)
		is_admin = check_client_rights(user.client, R_ADMIN, FALSE)
	var/list/pois = getpois(skip_mindless = !is_admin, specify_dead_role = FALSE)
	for(var/name in pois)
		var/list/serialized = list()
		serialized["full_name"] = name

		var/poi = pois[name]

		serialized["ref"] = REF(poi)

		var/mob/poi_mob = poi
		if(!istype(poi_mob))
			if(isVehicleMultitile(poi_mob))
				vehicles += list(serialized)
			else
				misc += list(serialized)
			continue

		var/number_of_orbiters = length(poi_mob.get_all_orbiters())
		if(number_of_orbiters)
			serialized["orbiters"] = number_of_orbiters

		if(isobserver(poi_mob))
			ghosts += list(serialized)
			continue

		if(poi_mob.stat == DEAD)
			dead += list(serialized)
			continue

		if(poi_mob.ckey == null)
			npcs += list(serialized)
			continue

		if(isliving(poi_mob))
			var/mob/living/player = poi_mob
			serialized["health"] = floor(player.health / player.maxHealth * 100)

			if(isxeno(player))
				var/mob/living/carbon/xenomorph/xeno = player
				if(xeno.caste)
					var/datum/caste_datum/caste = xeno.caste
					serialized["caste"] = caste.caste_type
					serialized["icon"] = caste.minimap_icon
					serialized["background_icon"] = caste.minimap_background
					serialized["hivenumber"] = xeno.hivenumber
					serialized["area_name"] = get_area_name(xeno)
				xenos += list(serialized)
				continue

			if(ishuman(player))
				var/mob/living/carbon/human/human = player
				var/obj/item/card/id/id_card = human.get_idcard()
				var/datum/species/human_species = human.species
				var/max_health = human_species.total_health != human.maxHealth ? human_species.total_health : human.maxHealth
				serialized["health"] = floor(player.health / max_health * 100)

				serialized["job"] = id_card?.assignment ? id_card.assignment : human.job
				serialized["nickname"] = human.real_name

				var/icon = human.assigned_equipment_preset?.minimap_icon
				if(islist(icon))
					for(var/key in icon)
						icon = key
						break
				serialized["icon"] = icon ? icon : "private"

				if(human.assigned_squad)
					serialized["background_icon"] = human.assigned_squad.background_icon
				else
					serialized["background_icon"] = human.assigned_equipment_preset?.minimap_background

				if(istype(get_area(human), /area/tdome))
					in_thunderdome += list(serialized)
					continue

				if(issynth(human) && !isinfiltratorsynthetic(human))
					synthetics += list(serialized)

				if(human.job in FAX_RESPONDER_JOB_LIST)
					responders += list(serialized)
				else if(SSticker.mode.is_in_endgame == TRUE && !is_mainship_level(human.z) && !(human.faction in FACTION_LIST_ERT_ALL) && !(isyautja(human)))
					escaped += list(serialized)
				else if(human.faction in FACTION_LIST_WY)
					wy += list(serialized)
				else if(isyautja(human))
					predators += list(serialized)
				else if(human.faction in FACTION_LIST_ERT_OTHER)
					ert_members += list(serialized)
				else if(human.faction in FACTION_LIST_HUNTED)
					hunted += list(serialized)
				else if(human.faction in FACTION_LIST_UPP)
					upp += list(serialized)
				else if(human.faction in FACTION_LIST_CLF)
					clf += list(serialized)
				else if(human.faction in FACTION_LIST_TWE)
					twe += list(serialized)
				else if(human.faction in FACTION_LIST_FREELANCER)
					freelancer += list(serialized)
				else if(human.faction in FACTION_LIST_CONTRACTOR)
					contractor += list(serialized)
				else if(human.faction in FACTION_LIST_MERCENARY)
					mercenary += list(serialized)
				else if(human.faction in FACTION_LIST_MARSHAL)
					marshal += list(serialized)
				else if(human.faction in FACTION_LIST_DUTCH)
					dutch += list(serialized)
				else if(human.faction in FACTION_LIST_MARINE)
					marines += list(serialized)
				else if(issurvivorjob(human.job))
					survivors += list(serialized)
				else
					humans += list(serialized)
				continue
			if(isanimal(player))
				animals += list(serialized)

	data["humans"] = humans
	data["marines"] = marines
	data["survivors"] = survivors
	data["xenos"] = xenos
	data["ert_members"] = ert_members
	data["upp"] = upp
	data["clf"] = clf
	data["wy"] = wy
	data["twe"] = twe
	data["responders"] = responders
	data["freelancer"] = freelancer
	data["contractor"] = contractor
	data["mercenary"] = mercenary
	data["dutch"] = dutch
	data["marshal"] = marshal
	data["synthetics"] = synthetics
	data["predators"] = predators
	data["hunted"] = hunted
	data["animals"] = animals
	data["dead"] = dead
	data["ghosts"] = ghosts
	data["misc"] = misc
	data["npcs"] = npcs
	data["vehicles"] = vehicles
	data["escaped"] = escaped
	data["in_thunderdome"] = in_thunderdome
	data["icons"] = GLOB.minimap_icons

	return data

/datum/orbit_menu/ui_assets(mob/user)
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/orbit)
