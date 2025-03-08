/datum/moba_join_panel
	#ifdef MOBA_TESTING
	var/list/picked_castes = list("Drone", "Drone", "Drone")
	var/list/picked_lanes = list("Jungle", "Jungle", "Jungle")
	#else
	var/list/picked_castes = list("", "", "")
	var/list/picked_lanes = list("", "", "")
	#endif
	var/in_queue = FALSE
	var/datum/moba_player/player

/datum/moba_join_panel/Destroy(force, ...)
	QDEL_NULL(player)
	return ..()

/datum/moba_join_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobaJoinPanel")
		ui.open()

/datum/moba_join_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/moba_castes),
	)

/datum/moba_join_panel/ui_state(mob/user)
	if(HAS_TRAIT(user, TRAIT_MOBA_PARTICIPANT))
		return GLOB.never_state
	return GLOB.observer_state

/datum/moba_join_panel/ui_data(mob/user)
	var/list/data = list()

	data["picked_castes"] = list()
	for(var/caste_name in picked_castes)
		var/datum/moba_caste/caste = GLOB.moba_castes_name[caste_name]
		data["picked_castes"] += list(list(
			"name" = caste.name,
			"desc" = caste.desc,
			"icon_state" = caste.icon_state,
			"category" = caste.category,
			"ideal_roles" = caste.ideal_roles,
		))
	data["picked_lanes"] = picked_lanes
	data["in_queue"] = in_queue

	data["can_enter_queue"] = (picked_castes[1] && picked_castes[2] && picked_castes[3] && picked_lanes[1] && picked_lanes[2] && picked_lanes[3])

	data["amount_in_queue"] = length(SSmoba.players_in_queue)
	data["is_moba_participant"] = HAS_TRAIT(user, TRAIT_MOBA_PARTICIPANT)

	return data

/datum/moba_join_panel/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = list(MOBA_ARCHETYPE_ASSASSIN, MOBA_ARCHETYPE_CASTER, MOBA_ARCHETYPE_CONTROLLER, MOBA_ARCHETYPE_FIGHTER, MOBA_ARCHETYPE_TANK)

	data["castes"] = GLOB.moba_castes_name + "None"
	data["castes_2"] = list()
	for(var/caste_name in GLOB.moba_castes_name)
		var/datum/moba_caste/caste = GLOB.moba_castes_name[caste_name]
		data["castes_2"] += list(list(
			"name" = caste.name,
			"desc" = caste.desc,
			"icon_state" = caste.icon_state,
			"category" = caste.category,
			"ideal_roles" = caste.ideal_roles,
		))

	return data

/datum/moba_join_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_lane")
			var/lane = params["lane"]
			var/priority = params["priority"]
			if(!priority || !lane)
				return

			if(!(lane in list("Top Lane", "Jungle", "Support", "Bottom Lane", "None")))
				return

			if(priority > MOBA_ALLOWED_POSITIONS || priority <= 0 || HAS_TRAIT(ui.user, TRAIT_MOBA_PARTICIPANT))
				return

			if(lane == "None")
				picked_lanes[priority] = ""
			else
				picked_lanes[priority] = lane
			return TRUE

		if("select_caste")
			var/caste = params["caste"]
			var/priority = params["priority"]
			if(!priority || !caste)
				return

			if(!(caste in GLOB.moba_castes_name) && (caste != "None"))
				return

			if(priority > MOBA_ALLOWED_POSITIONS || priority <= 0 || HAS_TRAIT(ui.user, TRAIT_MOBA_PARTICIPANT))
				return

			if(caste == "None")
				picked_castes[priority] = ""
			else
				picked_castes[priority] = caste
			return TRUE

		if("enter_queue")
			if(!ui.user.client || HAS_TRAIT(ui.user, TRAIT_MOBA_PARTICIPANT))
				return

			if(!picked_castes[1] || !picked_castes[2] || !picked_castes[3])
				return

			if(!picked_lanes[1] || !picked_lanes[2] || !picked_lanes[3])
				return

			player = new /datum/moba_player(ui.user.ckey, ui.user.client)

			for(var/i in 1 to MOBA_ALLOWED_POSITIONS)
				var/datum/moba_player_slot/new_slot = new
				new_slot.position = picked_lanes[i]
				new_slot.caste = GLOB.moba_castes_name[picked_castes[i]]
				player.queue_slots += new_slot

			SSmoba.add_to_queue(player)
			in_queue = TRUE
			return TRUE

		if("exit_queue")
			if(HAS_TRAIT(ui.user, TRAIT_MOBA_PARTICIPANT))
				return

			SSmoba.remove_from_queue(player)
			QDEL_NULL(player)
			in_queue = FALSE
			return TRUE


