/*      This is code made by Stuicey.
        He gave us/me permission to port it over.
		STUI - System Tabbed User Interface
		A system that allows admins to filter their chats
		ATTACK_LOG 		1
		ADMIN_LOG 		2
		STAFF_CHAT 		3
		OOC_CHAT 		4
		GAME_CHAT 		5
		DEBUG 			6
		RUNTIME         7
		DEFAULT CONFIG LENGTH == 150
		TODO:
			** setup a way of opening a single log
*/

// STUI
GLOBAL_DATUM_INIT(STUI, /datum/STUI, new)

/datum/STUI
	var/name = "STUI"
	var/list/attack	= list()		//Attack logs
	var/list/admin = list()			//Admin logs
	var/list/staff = list()			//Staff Chat
	var/list/ooc = list()			//OOC chat
	var/list/game = list()			//Game Chat
	var/list/debug = list()			//Debug info
	var/list/runtime = list()       //Runtimes
	var/list/tgui = list()			//TGUI
	var/list/processing	= 0     	//bitflag for logs that need processing

/datum/STUI/Topic(href, href_list)
	if(href_list["command"])
		usr.STUI_log = text2num(href_list["command"])
		processing |= usr.STUI_log		//forces the UI to update

/datum/STUI/proc/ui_interact(mob/user, ui_key = "STUI", var/datum/nanoui/ui = null, var/force_open = 1,var/force_start = 0)
	if(!(user.STUI_log & processing) && !force_start)
		return

	var/data[0]

	data["current_log"] = user.STUI_log
	switch(user.STUI_log)
		if(STUI_LOG_ATTACK)
			if(user.client.admin_holder.rights & R_MOD)
				data["colour"] = "bad"
				if(attack.len > config.STUI_length+1)
					attack.Cut(,attack.len-config.STUI_length)
				data["log"] = jointext(attack, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_ADMIN)
			if(user.client.admin_holder.rights & R_ADMIN)
				data["colour"] = "blue"
				if(admin.len > config.STUI_length+1)
					admin.Cut(,admin.len-config.STUI_length)
				data["log"] = jointext(admin, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_STAFF_CHAT)
			if(user.client.admin_holder.rights & R_ADMIN)
				data["colour"] = "average"
				if(staff.len > config.STUI_length+1)
					staff.Cut(,staff.len-config.STUI_length)
				data["log"] = jointext(staff, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_OOC_CHAT)
			if(user.client.admin_holder.rights & R_MOD)
				data["colour"] = "average"
				if(ooc.len > config.STUI_length+1)
					ooc.Cut(,ooc.len-config.STUI_length)
				data["log"] = jointext(ooc, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_GAME_CHAT)
			if((user.client.admin_holder.rights & R_ADMIN) || (user.client.admin_holder.rights & R_DEBUG))
				data["colour"] = "white"
				if(game.len > config.STUI_length+1)
					game.Cut(,game.len-config.STUI_length)
				data["log"] = jointext(game, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_DEBUG)
			if(user.client.admin_holder.rights & R_DEBUG)
				data["colour"] = "average"
				if(debug.len > config.STUI_length+1)
					debug.Cut(,debug.len-config.STUI_length)
				data["log"] = jointext(debug, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_RUNTIME)
			if(user.client.admin_holder.rights & R_DEBUG)
				data["colour"] = "average"
				if(runtime.len > config.STUI_length+1)
					runtime.Cut(,runtime.len-config.STUI_length)
				data["log"] = jointext(runtime, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."
		if(STUI_LOG_TGUI)
			if(user.client.admin_holder.rights & R_DEBUG)
				data["colour"] = "average"
				if(tgui.len > config.STUI_length+1)
					tgui.Cut(,tgui.len-config.STUI_length)
				data["log"] = jointext(tgui, "\n")
			else
				data["log"] = "You do not have the right permissions to view this."

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "STUI.tmpl", "STUI", 700, 500, null, -1)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/client/proc/open_STUI()
	set name = "S: Open STUI"
	set category = "Admin"

	GLOB.STUI.ui_interact(usr, force_start=1)
