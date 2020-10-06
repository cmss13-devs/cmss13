/var/security_level = 0
//0 = code green
//1 = code blue
//2 = code red
//3 = code delta

//config.alert_desc_blue_downto


/proc/set_security_level(var/level, no_sound=0, announce=1)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("delta")
			level = SEC_LEVEL_DELTA
	for(var/X in gun_cabinets)
		var/obj/structure/closet/secure_closet/guncabinet/G = X
		if(G.z == MAIN_SHIP_Z_LEVEL)
			G.check_sec_level(level)


	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				if(announce)
					ai_announcement("Attention: Security level lowered to GREEN - all clear.", no_sound ? null : 'sound/AI/code_green.ogg')
				security_level = SEC_LEVEL_GREEN
				for(var/obj/structure/machinery/firealarm/FA in machines)
					if(FA.z == MAIN_SHIP_Z_LEVEL)
						FA.overlays = list()
						FA.overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_green")
				for(var/obj/structure/machinery/status_display/SD in machines)
					if(SD.z == MAIN_SHIP_Z_LEVEL)
						SD.set_picture("default")
			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					if(announce)
						ai_announcement("Attention: Security level elevated to BLUE - potentially hostile activity on board.", no_sound ? null : 'sound/AI/code_blue_elevated.ogg')
				else
					if(announce)
						ai_announcement("Attention: Security level lowered to BLUE - potentially hostile activity on board.", no_sound ? null : 'sound/AI/code_blue_lowered.ogg')
				security_level = SEC_LEVEL_BLUE
				for(var/obj/structure/machinery/firealarm/FA in machines)
					if(FA.z == MAIN_SHIP_Z_LEVEL)
						FA.overlays = list()
						FA.overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_blue")
				for(var/obj/structure/machinery/status_display/SD in machines)
					if(SD.z == MAIN_SHIP_Z_LEVEL)
						SD.set_picture("default")
			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					if(announce)
						ai_announcement("Attention: Security level elevated to RED - there is an immediate threat to the ship.", no_sound ? null : 'sound/AI/code_red_elevated.ogg')
				else
					if(announce)
						ai_announcement("Attention: Security level lowered to RED - there is an immediate threat to the ship.", no_sound ? null : 'sound/AI/code_red_lowered.ogg')
					/*
					var/area/A
					for(var/obj/structure/machinery/power/apc/O in machines)
						if(O.z == MAIN_SHIP_Z_LEVEL)
							A = O.loc.loc
							A.toggle_evacuation()
					*/

				security_level = SEC_LEVEL_RED

				for(var/obj/structure/machinery/firealarm/FA in machines)
					if(FA.z == MAIN_SHIP_Z_LEVEL)
						FA.overlays = list()
						FA.overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_red")
				for(var/obj/structure/machinery/status_display/SD in machines)
					if(SD.z == MAIN_SHIP_Z_LEVEL)
						SD.set_picture("redalert")
			if(SEC_LEVEL_DELTA)
				if(announce)
					var/name = "SELF DESTRUCT SYSTEMS ACTIVE"
					var/input = "DANGER, THE EMERGENCY DESTRUCT SYSTEM IS NOW ACTIVATED. PROCEED TO THE SELF DESTRUCT CHAMBER FOR CONTROL ROD INSERTION."
					marine_announcement(input, name, 'sound/AI/selfdestruct_short.ogg')
				security_level = SEC_LEVEL_DELTA
				for(var/obj/structure/machinery/firealarm/FA in machines)
					if(FA.z == MAIN_SHIP_Z_LEVEL)
						FA.overlays = list()
						FA.overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_delta")
				for(var/obj/structure/machinery/status_display/SD in machines)
					if(SD.z == MAIN_SHIP_Z_LEVEL)
						SD.set_picture("redalert")
				EvacuationAuthority.enable_self_destruct()
	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/
