// #################### WY Intranet Console #####################
/obj/structure/machinery/computer/wy_intranet
	name = "WY Intranet Terminal"
	desc = "A standard issue Weyland-Yutani terminal for accessing the corporate intranet."
	icon_state = "medlaptop"
	explo_proof = TRUE

	var/current_menu = "login"
	var/last_menu = ""

	/// The last person to login.
	var/last_login = "No User"

	var/authentication = WY_COMP_ACCESS_LOGGED_OUT

	/// A list of everyone who has logged in.
	var/list/login_history = list()

	/// The ID of the wall divider(s) linked to this console.
	var/divider_id = null
	/// Whether or not the control panel for a hidden cell is available.
	var/hidden_cell_id = null
	/// The ID of any security systems. (Flashbulbs)
	var/security_system_id = null

	// If the room divider, or cell doors/shutters are open or not.
	var/open_divider = FALSE
	var/open_cell_door = FALSE
	var/open_cell_shutters = FALSE

	/// A loose number to order security vents if they aren't pre-ordered.
	var/vent_tag_num = 1

	/// Machinery the console interacts with (doors/shutters)
	var/list/obj/structure/machinery/targets = list()

	COOLDOWN_DECLARE(printer_cooldown)
	COOLDOWN_DECLARE(cell_flasher)
	COOLDOWN_DECLARE(sec_flasher)

/obj/structure/machinery/computer/wy_intranet/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/computer/wy_intranet/LateInitialize()
	. = ..()
	get_targets()

/obj/structure/machinery/computer/wy_intranet/Destroy()
	targets = null
	. = ..()

/obj/structure/machinery/computer/wy_intranet/proc/get_targets()
	targets = list()
	for(var/obj/structure/machinery/door/target_door in GLOB.machines)
		if(target_door.id == divider_id)
			targets += target_door
			continue
		if(target_door.id == hidden_cell_id)
			targets += target_door

	for(var/obj/structure/machinery/flasher/target_flash in GLOB.machines)
		if(target_flash.id == hidden_cell_id)
			targets += target_flash
			continue
		if(target_flash.id == security_system_id)
			targets += target_flash

	for(var/obj/structure/pipes/vents/pump/no_boom/gas/gas_vent in GLOB.gas_vents)
		if(gas_vent.network_id == security_system_id)
			targets += gas_vent

/obj/structure/machinery/computer/wy_intranet/liaison
	divider_id = "CLRoomDivider"
	hidden_cell_id = "CL_Containment"
	security_system_id = "CL_Security"

// ------ WY Intranet Console UI ------ //

/obj/structure/machinery/computer/wy_intranet/attack_hand(mob/user)
	if(..() || !allowed(usr) || inoperable())
		return FALSE

	tgui_interact(user)
	return TRUE

/obj/structure/machinery/computer/wy_intranet/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WYComputer", name)
		ui.open()

/obj/structure/machinery/computer/wy_intranet/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu
	data["last_page"] = last_menu
	data["logged_in"] = last_login

	data["access_text"] = "Intranet Tier [authentication], [wy_auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = GLOB.security_level
	data["worldtime"] = world.time

	data["access_log"] = login_history

	data["has_room_divider"] = divider_id
	data["has_hidden_cell"] = hidden_cell_id

	data["open_divider"] = open_divider
	data["open_cell_door"] = open_cell_door
	data["open_cell_shutters"] = open_cell_shutters

	data["printer_cooldown"] = !COOLDOWN_FINISHED(src, printer_cooldown)
	data["cell_flash_cooldown"] = !COOLDOWN_FINISHED(src, cell_flasher)

	data["security_vents"] = get_security_vents()

	return data

/obj/structure/machinery/computer/wy_intranet/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(inoperable())
		return UI_DISABLED

/obj/structure/machinery/computer/wy_intranet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	var/playsound = TRUE

	switch (action)
		if("go_back")
			if(!last_menu)
				return to_chat(user, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")
			var/mob/living/carbon/human/human_user = user
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			if(istype(idcard))
				if(!idcard.check_biometrics(human_user))
					to_chat(human_user, SPAN_WARNING("ERROR: Biometric identification failure. You must use your own ID card during login procedures."))
					return FALSE
				authentication = get_wy_access(idcard)
				last_login = idcard.registered_name
			else if(human_user.wear_id)
				idcard = human_user.get_idcard()
				if(idcard)
					authentication = get_wy_access(idcard)
					last_login = idcard.registered_name
			else
				to_chat(human_user, SPAN_WARNING("You require an ID card to access this terminal!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(authentication)
				login_history += "[last_login] at [worldtime2text()], Intranet Tier [authentication] - [wy_auth_to_text(authentication)]."
			current_menu = "main"

		// -- Page Changers -- //
		if("logout")
			last_menu = current_menu
			current_menu = "login"
			login_history += "[last_login] logged out at [worldtime2text()]."
			last_login = "No User"
			authentication = WY_COMP_ACCESS_LOGGED_OUT

		if("home")
			last_menu = current_menu
			current_menu = "main"
		if("page_vents")
			last_menu = current_menu
			current_menu = "vents"

		if("unlock_divider")
			toggle_divider()

		if("cell_shutters")
			if(!open_cell_shutters)
				open_shutters()
			else
				close_door()
				close_shutters()

		if("cell_door")
			if(!open_cell_door)
				open_door()
			else
				close_door()

		if("cell_flash")
			trigger_cell_flash()

		if("security_flash")
			trigger_sec_flash()

		if("trigger_vent")
			playsound = FALSE
			var/obj/structure/pipes/vents/pump/no_boom/gas/sec_vent = locate(params["vent"])
			if(!istype(sec_vent) || sec_vent.welded)
				to_chat(user, SPAN_WARNING("ERROR: Gas release failure."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(!COOLDOWN_FINISHED(sec_vent, vent_trigger_cooldown))
				to_chat(user, SPAN_WARNING("ERROR: Insufficient gas reserve for this vent."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			to_chat(user, SPAN_WARNING("Initiating gas release from [sec_vent.vent_tag]."))
			playsound(src, 'sound/machines/chime.ogg', 15, 1)
			COOLDOWN_START(sec_vent, vent_trigger_cooldown, 30 SECONDS)
			ares_apollo_talk("Nerve Gas release imminent from [sec_vent.vent_tag].")//Ares still monitors release of gas, even in the CLs vents.
			log_ares_security("Nerve Gas Release", "Released Nerve Gas from Vent '[sec_vent.vent_tag]'.")
			sec_vent.create_gas(VENT_GAS_CN20, 6, 5 SECONDS)
			log_admin("[key_name(user)] released nerve gas from Vent '[sec_vent.vent_tag]' via WY Intranet.")

	if(playsound)
		playsound(src, "keyboard_alt", 15, 1)



/obj/structure/machinery/computer/proc/get_wy_access(obj/item/card/id/card)
	if(ACCESS_WY_GENERAL in card.access)
		if(card.paygrade)
			switch(card.paygrade)
				if(PAY_SHORT_WYC10)
					return WY_COMP_ACCESS_DIRECTOR
				if(PAY_SHORT_WYC9, PAY_SHORT_WYC8)
					return WY_COMP_ACCESS_SENIOR_LEAD
				if(PAY_SHORT_WYC7, PAY_SHORT_WYC6)
					return WY_COMP_ACCESS_SUPERVISOR
		if(card.assignment == JOB_CORPORATE_LIAISON)
			return WY_COMP_ACCESS_LIAISON
		if(card.paygrade && (card.paygrade == PAY_SHORT_WYC5 || card.paygrade == PAY_SHORT_WYC4))
			return WY_COMP_ACCESS_CORPORATE_SENIOR
		return WY_COMP_ACCESS_CORPORATE
	else
		return WY_COMP_ACCESS_FORBIDDEN



/obj/structure/machinery/computer/proc/wy_auth_to_text(access_level)
	switch(access_level)
		if(WY_COMP_ACCESS_LOGGED_OUT)
			return "Logged Out"
		if(WY_COMP_ACCESS_FORBIDDEN)
			return "Unauthorized User"
		if(WY_COMP_ACCESS_LIAISON)
			return "Weyland-Yutani Liaison"
		if(WY_COMP_ACCESS_CORPORATE)
			return "Weyland-Yutani Employee"
		if(WY_COMP_ACCESS_SUPERVISOR)
			return "Weyland-Yutani Supervisor"
		if(WY_COMP_ACCESS_SENIOR_LEAD)
			return "Weyland-Yutani Senior Leadership"
		if(WY_COMP_ACCESS_DIRECTOR)
			return "Weyland-Yutani Directorate"



// Opens and locks doors, power check
/obj/structure/machinery/computer/wy_intranet/proc/open_door(force = FALSE)
	if(inoperable() && !force)
		return FALSE

	for(var/obj/structure/machinery/door/airlock/target_door in targets)
		if(target_door.id != hidden_cell_id)
			continue
		if(!target_door.density)
			continue
		target_door.unlock(force)
		target_door.open(force)
		open_cell_door = TRUE

	return TRUE

// Closes and unlocks doors, power check
/obj/structure/machinery/computer/wy_intranet/proc/close_door()
	if(inoperable())
		return FALSE

	for(var/obj/structure/machinery/door/airlock/target_door in targets)
		if(target_door.id != hidden_cell_id)
			continue
		if(target_door.density)
			continue
		target_door.close()
		target_door.lock()
		open_cell_door = FALSE

	return TRUE

// Opens and locks doors, power check
/obj/structure/machinery/computer/wy_intranet/proc/open_shutters(force = FALSE)
	if(inoperable() && !force)
		return FALSE

	for(var/obj/structure/machinery/door/poddoor/target_shutter in targets)
		if(target_shutter.id != hidden_cell_id)
			continue
		if(target_shutter.stat & BROKEN)
			continue
		if(!target_shutter.density)
			continue
		target_shutter.open()
		open_cell_shutters = TRUE
	return TRUE

// Closes and unlocks doors, power check
/obj/structure/machinery/computer/wy_intranet/proc/close_shutters()
	if(inoperable())
		return FALSE
	for(var/obj/structure/machinery/door/poddoor/target_shutter in targets)
		if(target_shutter.id != hidden_cell_id)
			continue
		if(target_shutter.stat & BROKEN)
			continue
		if(target_shutter.density)
			continue
		target_shutter.close()
		open_cell_shutters = FALSE
	return TRUE

/obj/structure/machinery/computer/wy_intranet/proc/toggle_divider()
	if(inoperable())
		return FALSE
	if(open_divider)
		for(var/obj/structure/machinery/door/poddoor/divider in targets)
			if(divider.id != divider_id)
				continue
			if(divider.density)
				continue
			divider.close()
		open_divider = FALSE
	else
		for(var/obj/structure/machinery/door/poddoor/divider in targets)
			if(divider.id != divider_id)
				continue
			if(!divider.density)
				continue
			divider.open()
		open_divider = TRUE

/obj/structure/machinery/computer/wy_intranet/proc/trigger_cell_flash()
	if(!COOLDOWN_FINISHED(src, cell_flasher))
		return FALSE

	for(var/obj/structure/machinery/flasher/target_flash in targets)
		if(target_flash.id != hidden_cell_id)
			continue
		target_flash.flash()
		COOLDOWN_START(src, cell_flasher, 15 SECONDS)
	return TRUE

/obj/structure/machinery/computer/wy_intranet/proc/trigger_sec_flash()
	if(!COOLDOWN_FINISHED(src, sec_flasher))
		return FALSE

	for(var/obj/structure/machinery/flasher/target_flash in targets)
		if(target_flash.id != security_system_id)
			continue
		target_flash.flash()
		COOLDOWN_START(src, sec_flasher, 15 SECONDS)
	return TRUE

/obj/structure/machinery/computer/wy_intranet/proc/get_security_vents()
	var/list/security_vents = list()
	for(var/obj/structure/pipes/vents/pump/no_boom/gas/vent in targets)
		if(!vent.vent_tag)
			vent.vent_tag = "Security Vent #[vent_tag_num]"
			vent_tag_num++

		var/list/current_vent = list()
		var/is_available = COOLDOWN_FINISHED(vent, vent_trigger_cooldown)
		current_vent["vent_tag"] = vent.vent_tag
		current_vent["ref"] = "\ref[vent]"
		current_vent["available"] = is_available
		security_vents += list(current_vent)
	return security_vents
