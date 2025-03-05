/datum/moba_scoreboard

/datum/moba_scoreboard/New()
	. = ..()

/datum/moba_scoreboard/Destroy(force, ...)
	return ..()

/datum/moba_scoreboard/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobaScoreboard")
		ui.open()

/datum/moba_scoreboard/ui_state(mob/user)
	return GLOB.conscious_state

/datum/moba_scoreboard/ui_data(mob/user)
	var/list/data = list()

	return data

/datum/moba_scoreboard/ui_static_data(mob/user)
	var/list/data = list()

	return data

/datum/moba_scoreboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("buy_item")
			if(!params["path"])
				return FALSE
			return TRUE
