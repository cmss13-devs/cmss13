/datum/traits_picker/ui_static_data(mob/user)
	. = ..()

	.["categories"] = list()
	for(var/type in GLOB.character_trait_groups)
		var/datum/character_trait_group/group = GLOB.character_trait_groups[type]
		if(!group.group_visible)
			continue

		var/traits = list()

		for(var/datum/character_trait/trait as anything in group.traits)
			if(!trait.applyable)
				continue

			traits += list(
				list("name" = trait.trait_name, "desc" = trait.trait_desc, "cost" = trait.cost, "type" = trait.type)
			)

		.["categories"] += list(
			list("name" = group.trait_group_name, "traits" = traits, "mutually_exclusive" = group.mutually_exclusive)
		)

/datum/traits_picker/ui_data(mob/user)
	. = ..()

	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return

	if(!prefs.read_traits)
		prefs.read_traits = TRUE

		for(var/trait in prefs.traits)
			var/datum/character_trait/character_trait = GLOB.character_traits[trait]
			prefs.trait_points -= character_trait.cost

	.["trait_points"] = prefs.trait_points
	.["starting_points"] = initial(prefs.trait_points)


	.["traits"] = list()
	for(var/trait_type as anything in prefs.traits)
		var/datum/character_trait/trait = GLOB.character_traits[trait_type]
		.["traits"] += list(
			list("name" = trait.trait_name, "desc" = trait.trait_desc, "cost" = trait.cost, "type" = trait_type)
		)

/datum/traits_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/datum/preferences/prefs = ui.user.client?.prefs
	if(!prefs)
		return

	switch(action)
		if("add")
			var/trait = params["type"]
			if(!trait)
				return

			trait = text2path(trait)
			if(!trait)
				return

			var/datum/character_trait/character_trait = GLOB.character_traits[trait]
			if(!character_trait)
				return

			character_trait.try_give_trait(prefs)
			if(character_trait.refresh_choices)
				prefs.ShowChoices(ui.user)

		if("remove")
			var/trait = params["type"]
			if(!trait)
				return

			trait = text2path(trait)
			if(!trait)
				return

			var/datum/character_trait/character_trait = GLOB.character_traits[trait]
			if(!character_trait)
				return

			character_trait.try_remove_trait(prefs)
			if(character_trait.refresh_choices)
				prefs.ShowChoices(ui.user)

	return TRUE

/datum/traits_picker/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "TraitsPicker", "Character Traits")
		ui.open()
		ui.set_autoupdate(FALSE)

	winset(user, ui.window.id, "focus=true")

/datum/traits_picker/ui_state(mob/user)
	return GLOB.always_state

