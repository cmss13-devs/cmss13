GLOBAL_VAR_INIT(security_level, SEC_LEVEL_GREEN)

/proc/set_security_level(level, no_sound = FALSE, announce = TRUE, log = ARES_LOG_SECURITY)
	if(level != GLOB.security_level)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_SECURITY_LEVEL_CHANGED, level)

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != GLOB.security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				if(announce)
					ai_announcement("Attention: Security level lowered to GREEN - all clear.", no_sound ? null : 'sound/AI/code_green.ogg', log)
				GLOB.security_level = SEC_LEVEL_GREEN

			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					if(announce)
						ai_announcement("Attention: Security level elevated to BLUE - potentially hostile activity on board.", no_sound ? null : 'sound/AI/code_blue_elevated.ogg', log)
				else
					if(announce)
						ai_announcement("Attention: Security level lowered to BLUE - potentially hostile activity on board.", no_sound ? null : 'sound/AI/code_blue_lowered.ogg', log)
				GLOB.security_level = SEC_LEVEL_BLUE

			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					if(announce)
						ai_announcement("Attention: Security level elevated to RED - there is an immediate threat to the ship.", no_sound ? null : 'sound/AI/code_red_elevated.ogg', log)
				else
					if(announce)
						ai_announcement("Attention: Security level lowered to RED - there is an immediate threat to the ship.", no_sound ? null : 'sound/AI/code_red_lowered.ogg', log)
				GLOB.security_level = SEC_LEVEL_RED

			if(SEC_LEVEL_DELTA)
				if(announce)
					var/name = "SELF-DESTRUCT SYSTEMS ACTIVE"
					var/input = "DANGER, THE EMERGENCY DESTRUCT SYSTEM IS NOW ACTIVATED. PROCEED TO THE SELF-DESTRUCT CHAMBER FOR CONTROL ROD INSERTION."
					marine_announcement(input, name, 'sound/AI/selfdestruct_short.ogg', logging = log)
				GLOB.security_level = SEC_LEVEL_DELTA

/proc/get_security_level()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA
