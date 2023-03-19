/client/proc/shakeshipverb()
	set name = "Shake shipmap"
	set category = "Admin.Events"

	var/drop = FALSE
	var/delayed
	var/announce
	var/delayt = 1
	var/whattoannounce = "WARNING, IMPACT IMMINENT"

	var/sstrength = tgui_input_number(src, "How Strong?", "Don't go overboard.", 0, 10)
	if(!sstrength)
		return
	var/stime = tgui_input_number(src, "Time Between Shakes?", "Don't make it too long", 0, 30)
	if(!sstrength)
		return

	var/prompt = alert(usr.client, "Drop people?", "Yeet?" ,"Yes","No")
	if(prompt == "Yes")
		drop = TRUE

	prompt = alert(usr.client, "delay it?", "Make them quiver!" ,"Yes","No")
	if(prompt == "Yes")
		delayed = TRUE
		delayt = tgui_input_number(src, "How much delay?", "60 secs maximum", 0, 60, 0)
		if(!delayt)
			return
		prompt = alert(usr.client, "alert people?", "ARES announcement!" ,"Yes","No")
		if(prompt == "Yes")
			announce = TRUE
			whattoannounce = input(usr, "Please enter announcement text. Keep it empty to keep the default.", "What?", "")
			if(!whattoannounce)
				if(sstrength <= 7)
					whattoannounce = "WARNING, IMPACT IMMINENT. ETA: [delayt] SECONDS. BRACE BRACE BRACE."
				if(sstrength > 7)
					whattoannounce = "DANGER, DANGER! HIGH ENERGY IMPACT IMMINENT. ETA: [delayt] SECONDS. BRACE BRACE BRACE."

	prompt = alert(src, "Are you sure you want to shake the shipmap?", "Rock the ship!" ,"Yes","No")
	if(prompt != "Yes")
		return
	else
		log_admin("[src] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		message_admins("[src] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		if(delayed)
			if(announce)
				if(sstrength <= 5)
					shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/alert.ogg')
				if(sstrength > 5)
					shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
		 //sleep(delayt * 10)
		 addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shakeship), sstrength, stime, drop), delayt * 10)
		else
			shakeship(sstrength, stime, drop)

