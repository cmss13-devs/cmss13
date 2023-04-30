/client/proc/adminpanelgq()
	set name = "Call General Quarters"
	set category = "Admin.Ship"

	if(security_level == SEC_LEVEL_RED || security_level == SEC_LEVEL_DELTA)
		tgui_alert(src, "Security is already red or above, General Quarters cannot be called.", "Acknowledge!", list("ok."), 10 SECONDS)
	else
		var/whattoannounce = "ATTENTION! GENERAL QUARTERS. ALL HANDS, MAN YOUR BATTLESTATIONS."
		var/prompt = tgui_alert(src, "Do you want to leave the announcement as the default one?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt == "No")
			whattoannounce = tgui_input_text(src, "Please enter announcement text.", "what?")
			prompt = tgui_alert(src, "Are you sure you want to send General Quarters? This will force red alert.", "Choose.", list("Yes", "No"), 20 SECONDS)
			if(prompt == "Yes")
				set_security_level(2, no_sound=1, announce=0)
				shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/GQfullcall.ogg')
				message_admins("[key_name_admin(src)] Sent General Quarters with a custom announcement!")
		else
			prompt = tgui_alert(src, "Are you sure you want to send General Quarters? This will force red alert.", "Choose.", list("Yes", "No"), 20 SECONDS)
			if(prompt == "Yes")
				set_security_level(2, no_sound=1, announce=0)
				shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/GQfullcall.ogg')
				message_admins("[key_name_admin(src)] Sent General Quarters!")
