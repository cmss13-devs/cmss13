/client/proc/shakeshipverb()
	set name = "Shake Shipmap"
	set category = "Admin.Events"

	var/drop = FALSE
	var/delayt
	var/whattoannounce

	var/sstrength = tgui_input_number(src, "How Strong?", "Don't go overboard.", 0, 10)
	if(!sstrength)
		return
	var/stime = tgui_input_number(src, "Time Between Shakes?", "Don't make it too long", 0, 30)
	if(!sstrength)
		return

	var/prompt = tgui_alert(src, "Drop people?", "Confirmation", list("Yes", "No"), 20 SECONDS)
	if(prompt == "Yes")
		drop = TRUE

	var/delayed
	var/announce
	prompt = tgui_alert(src, "Delay it?", "Confirmation", list("Yes", "No"), 20 SECONDS)
	if(prompt == "Yes")
		delayed = TRUE
		delayt = tgui_input_number(src, "How much delay?", "60 secs maximum", 0, 60, 0)
		if(!delayt)
			return
		prompt = tgui_alert(src, "Alert people?", "Confirmation", list("Yes", "No"), 20 SECONDS)
		if(prompt == "Yes")
			announce = TRUE
			whattoannounce = tgui_input_text(src, "Please enter announcement text. Keep it empty to keep the default.", "what?")
			if(!whattoannounce)
				if(sstrength <= 7)
					whattoannounce = "WARNING, IMPACT IMMINENT. ETA: [delayt] SECONDS. BRACE BRACE BRACE."
				if(sstrength > 7)
					whattoannounce = "DANGER, DANGER! HIGH ENERGY IMPACT IMMINENT. ETA: [delayt] SECONDS. BRACE BRACE BRACE."

	prompt = tgui_alert(src, "Are you sure you want to shake the shipmap?", "Rock the ship!", list("Yes", "No"), 20 SECONDS)
	if(prompt != "Yes")
		return
	else
		log_admin("[key_name_admin(src)] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		message_admins("[key_name_admin(src)] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		if(delayed)
			if(announce)
				if(sstrength <= 5)
					shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/alert.ogg')
				if(sstrength > 5)
					shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shakeship), sstrength, stime, drop), delayt * 10)
		else
			shakeship(sstrength, stime, drop)

