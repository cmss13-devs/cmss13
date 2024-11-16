/datum/tutorial_menu
	/// List of ["name" = name, "tutorials" = ["name" = name, "path" = "path", "id" = tutorial_id]]
	var/static/list/categories = list()


/datum/tutorial_menu/New()
	if(!length(categories))
		var/list/categories_2 = list()
		for(var/datum/tutorial/tutorial as anything in subtypesof(/datum/tutorial))
			if(tutorial::parent_path == tutorial)
				continue

			if(!(tutorial::category in categories_2))
				categories_2[tutorial::category] = list()

			categories_2[tutorial::category] += list(list(
				"name" = tutorial::name,
				"path" = "[tutorial]",
				"id" = tutorial::tutorial_id,
				"description" = tutorial::desc,
				"image" = tutorial::icon_state,
			))

		for(var/category in categories_2)
			categories += list(list(
				"name" = category,
				"tutorials" = categories_2[category],
			))

/datum/tutorial_menu/proc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TutorialMenu")
		ui.open()

/datum/tutorial_menu/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/tutorial),
	)

/datum/tutorial_menu/ui_state(mob/user)
	if(istype(get_area(user), /area/misc/tutorial))
		return GLOB.never_state

	return GLOB.new_player_state


/datum/tutorial_menu/ui_static_data(mob/user)
	var/list/data = list()

	data["tutorial_categories"] = categories
	data["completed_tutorials"] = list()
	data["locked_tutorials"] = list()

	if(user.client?.prefs)
		data["completed_tutorials"] = user.client.prefs.completed_tutorials

		for(var/datum/tutorial/tutorial as anything in subtypesof(/datum/tutorial))
			if(tutorial::parent_path == tutorial)
				continue
			if(tutorial::required_tutorial)
				if(!IS_TUTORIAL_COMPLETED(user, tutorial::required_tutorial))
					data["locked_tutorials"] += tutorial::tutorial_id

	return data


/datum/tutorial_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_tutorial")
			var/datum/tutorial/path
			if(!params["tutorial_path"])
				return

			path = text2path(params["tutorial_path"])

			if(!ispath(path, /datum/tutorial) || !isnewplayer(usr))
				return

			if(HAS_TRAIT(usr, TRAIT_IN_TUTORIAL) || istype(get_area(usr), /area/misc/tutorial))
				to_chat(usr, SPAN_NOTICE("You are currently in a tutorial, or one is loading. Please be patient."))
				return

			path = new path
			if(path.start_tutorial(usr))
				ui.close()
				return TRUE
