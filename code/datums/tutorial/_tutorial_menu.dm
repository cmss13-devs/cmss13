/datum/tutorial_menu
	/// Dict of "category" : [name = "name", path = "path"]
	var/static/list/categories = list()


/datum/tutorial_menu/New()
	if(!length(categories))
		var/list/categories_2 = list()
		for(var/datum/tutorial/tutorial as anything in subtypesof(/datum/tutorial))
			if(initial(tutorial.parent_path) == tutorial)
				continue

			if(!(initial(tutorial.category) in categories_2))
				categories_2[initial(tutorial.category)] = list()

			categories_2[initial(tutorial.category)] += list(list(
				"name" = initial(tutorial.name),
				"path" = "[tutorial]",
			))

		for(var/category in categories_2)
			categories += list(list(
				"name" = category,
				"tutorials" = categories_2[category],
			))


/datum/tutorial_menu/proc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TutorialList")
		ui.open()


/datum/tutorial_menu/ui_state(mob/user)
	return GLOB.new_player_state


/datum/tutorial_menu/ui_data(mob/user)
	var/list/data = list()

	return data


/datum/tutorial_menu/ui_static_data(mob/user)
	var/list/data = list()

	data["tutorial_categories"] = categories

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

			if(!path || !isnewplayer(usr))
				return

			if(HAS_TRAIT(usr, TRAIT_IN_TUTORIAL))
				to_chat(usr, SPAN_NOTICE("You are currently in a tutorial, or one is loading. Please be patient."))
				return

			path = new path
			path.start_tutorial(usr)
