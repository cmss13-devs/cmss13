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
	var/divider_id

	COOLDOWN_DECLARE(printer_cooldown)

/obj/structure/machinery/computer/wy_intranet/liaison
	divider_id = "CLRoomDivider"

// ------ WY Intranet Console UI ------ //

/obj/structure/machinery/computer/wy_intranet/attack_hand(mob/user as mob)
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

	data["access_text"] = "intranet level [authentication], [wy_auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = GLOB.security_level
	data["worldtime"] = world.time

	data["access_log"] = login_history


	data["printer_cooldown"] = !COOLDOWN_FINISHED(src, printer_cooldown)


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
		if("page_1to1")
			last_menu = current_menu
			current_menu = "talking"
		if("page_announcements")
			last_menu = current_menu
			current_menu = "announcements"

		if("unlock_divider")
			for(var/obj/structure/machinery/door/poddoor/divider in GLOB.machines)
				if(divider.id == divider_id)
					if(divider.density)
						INVOKE_ASYNC(divider, TYPE_PROC_REF(/obj/structure/machinery/door, open))
					else
						INVOKE_ASYNC(divider, TYPE_PROC_REF(/obj/structure/machinery/door, close))

	if(playsound)
		playsound(src, "keyboard_alt", 15, 1)



/obj/structure/machinery/computer/proc/get_wy_access(obj/item/card/id/card)
	if(card.paygrade in GLOB.wy_highcom_paygrades)
		return WY_COMP_ACCESS_SENIOR_LEAD
	if(ACCESS_WY_GENERAL in card.access)
		return WY_COMP_ACCESS_CORPORATE
	else
		return WY_COMP_ACCESS_FORBIDDEN



/obj/structure/machinery/computer/proc/wy_auth_to_text(access_level)
	switch(access_level)
		if(WY_COMP_ACCESS_LOGGED_OUT)
			return "Logged Out"
		if(WY_COMP_ACCESS_FORBIDDEN)
			return "Unauthorized User"
		if(WY_COMP_ACCESS_CORPORATE)
			return "Weyland-Yutani Employee"
		if(WY_COMP_ACCESS_SENIOR_LEAD)
			return "Weyland-Yutani Senior Leadership"
		if(WY_COMP_ACCESS_DIRECTOR)
			return "Weyland-Yutani Directorate"
