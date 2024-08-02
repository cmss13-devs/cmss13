/*   This is code made by Stuicey.
		He gave us/me permission to port it over.
		STUI - System Tabbed User Interface
		A system that allows admins to filter their chats
		ATTACK_LOG 1
		ADMIN_LOG 2
		STAFF_CHAT 3
		OOC_CHAT 4
		GAME_CHAT 5
		DEBUG 6
		RUNTIME  7
		DEFAULT CONFIG LENGTH == 150
		TODO:
			** setup a way of opening a single log
*/

#define STUI_TEXT_ATTACK "Attack"
#define STUI_TEXT_STAFF "Staff Logs"
#define STUI_TEXT_STAFF_CHAT "Staff Chat"
#define STUI_TEXT_OOC "OOC"
#define STUI_TEXT_GAME "Game"
#define STUI_TEXT_DEBUG "Debug"
#define STUI_TEXT_RUNTIME "Runtime"
#define STUI_TEXT_TGUI "TGUI"

// STUI
GLOBAL_DATUM_INIT(STUI, /datum/STUI, new)

/datum/STUI
	var/name = "STUI"
	var/list/attack = list() //Attack logs
	var/list/admin = list() //Admin logs
	var/list/staff = list() //Staff Chat
	var/list/ooc = list() //OOC chat
	var/list/game = list() //Game Chat
	var/list/debug = list() //Debug info
	var/list/runtime = list()    //Runtimes
	var/list/tgui = list() //TGUI
	var/list/processing = 0 //bitflag for logs that need processing

/datum/STUI/New()
	. = ..()
	if(length(stui_init_runtimes)) // Report existing errors that might have occurred during static initializers
		runtime = stui_init_runtimes.Copy()

/datum/STUI/Topic(href, href_list)
	if(href_list["command"])
		usr.STUI_log = text2num(href_list["command"])
		processing |= usr.STUI_log //forces the UI to update

/datum/STUI/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/STUI/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "STUI", "STUI")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/STUI/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("update")
			return TRUE
	return FALSE

/datum/STUI/ui_static_data(mob/user)
	. = list()
	.["tabs"] = list()
	if(user.client.admin_holder.rights & R_MOD)
		.["tabs"] += STUI_TEXT_ATTACK
		.["tabs"] += STUI_TEXT_STAFF
		.["tabs"] += STUI_TEXT_STAFF_CHAT
		.["tabs"] += STUI_TEXT_OOC
	if((user.client.admin_holder.rights & R_MOD) || (user.client.admin_holder.rights & R_DEBUG))
		.["tabs"] += STUI_TEXT_GAME
	if(user.client.admin_holder.rights & R_DEBUG)
		.["tabs"] += STUI_TEXT_DEBUG
		.["tabs"] += STUI_TEXT_RUNTIME
		.["tabs"] += STUI_TEXT_TGUI

/datum/STUI/ui_data(mob/user)
	var/stui_length = CONFIG_GET(number/STUI_length)
	. = list()
	.["logs"] = list()
	if(user.client.admin_holder.rights & R_MOD)
		if(length(attack) > stui_length+1)
			attack.Cut(,length(attack)-stui_length)
		.["logs"][STUI_TEXT_ATTACK] = attack
		if(length(admin) > stui_length+1)
			admin.Cut(,length(admin)-stui_length)
		.["logs"][STUI_TEXT_STAFF] = admin
		if(length(staff) > stui_length+1)
			staff.Cut(,length(staff)-stui_length)
		.["logs"][STUI_TEXT_STAFF_CHAT] = staff
		if(length(ooc) > stui_length+1)
			ooc.Cut(,length(ooc)-stui_length)
		.["logs"][STUI_TEXT_OOC] = ooc
	if((user.client.admin_holder.rights & R_MOD) || (user.client.admin_holder.rights & R_DEBUG))
		if(length(game) > stui_length+1)
			game.Cut(,length(game)-stui_length)
		.["logs"][STUI_TEXT_GAME] = game
	if(user.client.admin_holder.rights & R_DEBUG)
		if(length(debug) > stui_length+1)
			debug.Cut(,length(debug)-stui_length)
		.["logs"][STUI_TEXT_DEBUG] = debug
		if(length(runtime) > stui_length+1)
			runtime.Cut(,length(runtime)-stui_length)
		.["logs"][STUI_TEXT_RUNTIME] = runtime
		if(length(tgui) > stui_length+1)
			tgui.Cut(,length(tgui)-stui_length)
		.["logs"][STUI_TEXT_TGUI] = tgui

/client/proc/open_STUI()
	set name = "S: Open STUI"
	set category = "Admin"

	GLOB.STUI.tgui_interact(usr)

