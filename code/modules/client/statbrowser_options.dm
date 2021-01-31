/client/var/datum/statbrowser_options/statbrowser_options

/// Handles the Statbrowser Options window for a given client
/datum/statbrowser_options
	var/client/client
	var/current_fontsize

/datum/statbrowser_options/New(client/client, current_fontsize)
	src.client = client
	src.current_fontsize = current_fontsize

/datum/statbrowser_options/tgui_interact(mob/user = client.mob, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "StatbrowserOptions", "Statbrowser Options")
		ui.open()

/datum/statbrowser_options/ui_data(mob/user)
	. = list()
	.["current_fontsize"] = current_fontsize

/datum/statbrowser_options/ui_state()
	return GLOB.always_state

/datum/statbrowser_options/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("change_fontsize")
			var/new_fontsize = text2num(params["new_fontsize"])
			current_fontsize = new_fontsize
			client << output("[url_encode(json_encode(new_fontsize))];", "statbrowser:change_fontsize")
