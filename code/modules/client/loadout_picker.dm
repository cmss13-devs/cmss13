/datum/loadout_picker/ui_static_data(mob/user)
	. = ..()

	var/job = user.client?.prefs.get_high_priority_job()

	.["fluff_categories"] = list()
	.["loadout_categories"] = list()
	for(var/category in GLOB.gear_datums_by_category)
		var/list/datum/gear/gears = GLOB.gear_datums_by_category[category]

		var/fluff_items = list()
		var/loadout_items = list()

		for(var/datum/gear/gear as anything in gears)
			if(job && length(gear.allowed_roles) && !(job in gear.allowed_roles))
				continue

			if(gear.loadout_cost)
				loadout_items += list(
					gear.get_list_representation()
				)
				continue

			if(gear.fluff_cost)
				fluff_items += list(
					gear.get_list_representation()
				)

		if(length(fluff_items))
			.["fluff_categories"] += list(
				list("name" = category, "items" = fluff_items)
			)

		if(length(loadout_items))
			.["loadout_categories"] += list(
				list("name" = category, "items" = loadout_items)
			)

	.["max_fluff_points"] = MAX_GEAR_COST
	.["max_save_slots"] = MAX_SAVE_SLOTS

/datum/loadout_picker/ui_data(mob/user)
	. = ..()

	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return

	.["fluff_gear"] = list()
	var/fluff_points = 0
	for(var/item in prefs.gear)
		var/datum/gear/gear = GLOB.gear_datums_by_type[item]
		fluff_points += gear.fluff_cost

		.["fluff_gear"] += list(
			gear.get_list_representation()
		)
	.["fluff_points"] = fluff_points

	.["loadout"] = list()
	var/loadout_points = 0
	for(var/item in prefs.get_active_loadout())
		var/datum/gear/gear = GLOB.gear_datums_by_type[item]
		loadout_points += gear.loadout_cost

		.["loadout"] += list(
			gear.get_list_representation()
		)
	.["loadout_points"] = loadout_points
	.["selected_loadout_slot"] = prefs.selected_loadout_slot

	var/job = prefs.get_high_priority_job()

	.["selected_job"] = job
	.["max_job_points"] = job ? GLOB.RoleAuthority.roles_by_name[job].loadout_points : 0
	.["loadout_slot_names"] = prefs.loadout_slot_names[job]

/datum/loadout_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/datum/preferences/prefs = ui.user.client?.prefs
	if(!prefs)
		return

	var/job = prefs.get_high_priority_job()

	switch(action)
		if("add")
			var/picked_type = text2path(params["type"])
			if(!picked_type)
				return

			var/datum/gear/gear = GLOB.gear_datums_by_type[picked_type]
			if(!istype(gear))
				return

			if(gear.fluff_cost)
				var/total_cost = 0
				for(var/gear_type in prefs.gear)
					total_cost += GLOB.gear_datums_by_type[gear_type].fluff_cost

				total_cost += gear.fluff_cost
				if(total_cost > MAX_GEAR_COST)
					return FALSE

				prefs.gear += gear.type

				prefs.ShowChoices(ui.user)
				return TRUE

			var/loadout_list = prefs.get_active_loadout()

			var/total_cost = 0
			for(var/gear_type in loadout_list)
				total_cost += GLOB.gear_datums_by_type[gear_type].loadout_cost

			total_cost += gear.loadout_cost
			if(total_cost > GLOB.RoleAuthority.roles_by_name[job].loadout_points)
				return FALSE

			loadout_list += gear.type

		if("remove")
			var/picked_type = text2path(params["type"])
			if(!picked_type)
				return FALSE

			var/datum/gear/gear = GLOB.gear_datums_by_type[picked_type]
			if(!istype(gear))
				return FALSE

			if(gear.fluff_cost)
				prefs.gear -= gear.type

			if(gear.loadout_cost)
				var/loadout_list = prefs.get_active_loadout()
				loadout_list -= gear.type

		if("slot")
			var/picked_slot = text2num(params["picked"])
			if(!picked_slot)
				return

			picked_slot = clamp(picked_slot, 1, MAX_SAVE_SLOTS)

			prefs.selected_loadout_slot = picked_slot

		if("name_slot")
			var/name = params["name"]
			if(!name)
				return

			name = strip_html(name, MAX_NAME_LEN)
			if(!length(name))
				return

			var/slot = params["slot"]
			if(!slot || !isnum(slot))
				return

			slot = clamp(slot, 1, MAX_SAVE_SLOTS)
			if(!slot)
				return

			if(!prefs.loadout_slot_names[job])
				prefs.loadout_slot_names[job] = list()

			prefs.loadout_slot_names[job]["[slot]"] = name

	prefs.check_slot_prefs()
	prefs.ShowChoices(ui.user)
	return TRUE

/datum/loadout_picker/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "LoadoutPicker", "Loadout Picker")
		ui.open()
		ui.set_autoupdate(FALSE)

	winset(user, ui.window.id, "focus=true")

/datum/loadout_picker/ui_state(mob/user)
	return GLOB.always_state
