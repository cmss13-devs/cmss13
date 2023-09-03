/proc/generalquarters(customannouncement, customannouncementtext)
	var/GQannouncement = "ATTENTION! GENERAL QUARTERS. ALL HANDS, MAN YOUR BATTLESTATIONS."
	if(security_level < SEC_LEVEL_RED)
		set_security_level(SEC_LEVEL_RED, TRUE, FALSE)
	if(customannouncement)
	shipwide_ai_announcement(customannouncementtext, MAIN_AI_SYSTEM, 'sound/effects/GQfullcall.ogg')
	else
		shipwide_ai_announcement(GQannouncement, MAIN_AI_SYSTEM, 'sound/effects/GQfullcall.ogg')
