GLOBAL_DATUM_INIT(relays_panel, /datum/ping_relay_tgui, new)

/datum/tgui_panel/proc/ping_relays()
	GLOB.relays_panel.tgui_interact(client.mob)

/datum/ping_relay_tgui/tgui_interact(mob/user, datum/tgui/ui)
	var/list/relay_ping_conf = CONFIG_GET(keyed_list/connection_relay_ping)
	if(!length(relay_ping_conf))
		to_chat(user, "There are no relays configured to test.")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PingRelaysPanel", "Relay Pings")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/ping_relay_tgui/ui_state(mob/user)
	return GLOB.always_state

/datum/ping_relay_tgui/ui_static_data(mob/user)
	var/list/data = list()
	var/list/relay_names = list()
	var/list/relay_pings = list()
	var/list/relay_cons = list()

	var/list/relay_ping_conf = CONFIG_GET(keyed_list/connection_relay_ping)
	var/list/relay_con_conf = CONFIG_GET(keyed_list/connection_relay_con)
	for(var/key in relay_ping_conf)
		// assumption: keys are the same in both configs
		relay_names += key
		relay_pings += relay_ping_conf[key]
		relay_cons += relay_con_conf[key]

	data["relay_names"] = relay_names
	data["relay_pings"] = relay_pings
	data["relay_cons"] = relay_cons
	return data

/datum/ping_relay_tgui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("connect")
			to_chat(user, "Now connecting via [params["desc"]]. Please wait...");
			user << link(params["url"])
			ui.close()
			return
