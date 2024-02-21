GLOBAL_DATUM_INIT(relays_panel, /datum/ping_relay_tgui, new)

/datum/tgui_panel/proc/ping_relays()
	GLOB.relays_panel.tgui_interact(client.mob)

/datum/ping_relay_tgui/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PingRelaysPanel", "Relay Pings")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/ping_relay_tgui/ui_state(mob/user)
	return GLOB.always_state

/datum/ping_relay_tgui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("connect")
			user << link(params["url"])
			ui.close()
			return
