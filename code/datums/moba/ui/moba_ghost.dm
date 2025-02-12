/datum/moba_join_panel
	var/list/picked_castes = list("", "", "")
	var/list/picked_lanes = list("", "", "")
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

/datum/moba_join_panel/ui_state(mob/user)
	return GLOB.observer_state

/datum/moba_join_panel/ui_data(mob/user)
	var/list/data = list()

	data["picked_castes"] = picked_castes
	data["picked_lanes"] = picked_lanes
	data["in_queue"] = in_queue

	data["can_enter_queue"] = (picked_castes[1] && picked_castes[2] && picked_castes[3] && picked_lanes[1] && picked_lanes[2] && picked_lanes[3])

	data["amount_in_queue"] = length(SSmoba.players_in_queue)

	return data

/datum/moba_join_panel/ui_static_data(mob/user)
	var/list/data = list()

	data["castes"] = GLOB.moba_castes_name + "None"

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

			if(priority > MOBA_ALLOWED_POSITIONS || priority <= 0)
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

			if(priority > MOBA_ALLOWED_POSITIONS || priority <= 0)
				return

			if(caste == "None")
				picked_castes[priority] = ""
			else
				picked_castes[priority] = caste
			return TRUE

		if("enter_queue")
			if(!picked_castes[1] || !picked_castes[2] || !picked_castes[3])
				return

			if(!picked_lanes[1] || !picked_lanes[2] || !picked_lanes[3])
				return

			player = new /datum/moba_player
			player.tied_ckey = ui.user.ckey
			for(var/i in 1 to MOBA_ALLOWED_POSITIONS)
				var/datum/moba_player_slot/new_slot = new
				new_slot.position = picked_lanes[i]
				new_slot.caste = GLOB.moba_castes_name[picked_castes[i]]
				player.queue_slots += new_slot

			SSmoba.add_to_queue(player)
			in_queue = TRUE
			return TRUE

		if("exit_queue")
			SSmoba.remove_from_queue(player)
			QDEL_NULL(player)
			in_queue = FALSE
			return TRUE


