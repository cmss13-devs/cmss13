/// Opens the station traits admin panel
/datum/admins/proc/round_traits_panel()
	set name = "Modify Round Traits"
	set category = "Admin.Events"

	var/static/datum/round_traits_panel/round_traits_panel = new
	round_traits_panel.tgui_interact(usr)

/datum/round_traits_panel
	var/static/list/future_traits

/datum/round_traits_panel/ui_data(mob/user)
	var/list/data = list()

	data["too_late_to_revert"] = too_late_to_revert()

	var/list/current_round_traits = list()
	for (var/datum/round_trait/round_trait as anything in SSround.round_traits)
		current_round_traits += list(list(
			"name" = round_trait.name,
			"can_revert" = round_trait.can_revert,
			"ref" = REF(round_trait),
		))

	data["current_traits"] = current_round_traits
	data["future_round_traits"] = future_traits

	return data

/datum/round_traits_panel/ui_static_data(mob/user)
	var/list/data = list()

	var/list/valid_round_traits = list()

	for (var/datum/round_trait/round_trait_path as anything in subtypesof(/datum/round_trait))
		valid_round_traits += list(list(
			"name" = initial(round_trait_path.name),
			"path" = round_trait_path,
		))

	data["valid_round_traits"] = valid_round_traits

	return data

/datum/round_traits_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch (action)
		if ("revert")
			var/ref = params["ref"]
			if (!ref)
				return TRUE

			var/datum/round_trait/round_trait = locate(ref)

			if (!istype(round_trait))
				return TRUE

			if (too_late_to_revert())
				to_chat(usr, SPAN_WARNING("It's too late to revert station traits, the round has already started!"))
				return TRUE

			if (!round_trait.can_revert)
				stack_trace("[round_trait.type] can't be reverted, but was requested anyway.")
				return TRUE

			var/message = "[key_name(usr)] reverted the station trait [round_trait.name] ([round_trait.type])"
			log_admin(message)
			message_admins(message)

			round_trait.revert()

			return TRUE
		if ("setup_future_traits")
			if (too_late_for_future_traits())
				to_chat(usr, SPAN_WARNING("It's too late to add future station traits, the round is already over!"))
				return TRUE

			var/list/new_future_traits = list()
			var/list/round_trait_names = list()

			for (var/round_trait_text in params["round_traits"])
				var/datum/round_trait/round_trait_path = text2path(round_trait_text)
				if (!ispath(round_trait_path, /datum/round_trait) || round_trait_path == /datum/round_trait)
					log_admin("[key_name(usr)] tried to set an invalid future station trait: [round_trait_text]")
					to_chat(usr, SPAN_WARNING("Invalid future station trait: [round_trait_text]"))
					return TRUE

				round_trait_names += initial(round_trait_path.name)

				new_future_traits += list(list(
					"name" = initial(round_trait_path.name),
					"path" = round_trait_path,
				))

			var/message = "[key_name(usr)] has prepared the following station traits for next round: [round_trait_names.Join(", ") || "None"]"
			log_admin(message)
			message_admins(message)

			future_traits = new_future_traits
			rustg_file_write(json_encode(params["round_traits"]), FUTURE_ROUND_TRAITS_FILE)

			return TRUE
		if ("clear_future_traits")
			if (!future_traits)
				to_chat(usr, SPAN_WARNING("There are no future station traits."))
				return TRUE

			var/message = "[key_name(usr)] has cleared the station traits for next round."
			log_admin(message)
			message_admins(message)

			fdel(FUTURE_ROUND_TRAITS_FILE)
			future_traits = null

			return TRUE

/datum/round_traits_panel/proc/too_late_for_future_traits()
	return SSticker.current_state >= GAME_STATE_FINISHED

/datum/round_traits_panel/proc/too_late_to_revert()
	return SSticker.current_state >= GAME_STATE_PLAYING

/datum/round_traits_panel/ui_status(mob/user, datum/ui_state/state)
	return check_rights_for(user.client, R_EVENT) ? UI_INTERACTIVE : UI_CLOSE

/datum/round_traits_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoundTraitsPanel")
		ui.open()
