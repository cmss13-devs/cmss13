/client/proc/shakeship()
	set name = "Shake shipmap"
	set category = "Admin.Events"

	var/client/C = usr.client
	var/logckey = C.ckey
	var/drop = 0
	var/delayed
	var/announce
	var/delayt = 1
	/var/whattoannounce = "WARNING, IMPACT IMMINENT"

	var/sstrength = tgui_input_number(src, "How Strong?", "Don't go overboard.", 0, 10)
	if(!sstrength)
		return
	var/stime = tgui_input_number(src, "Time Between Shakes?", "Don't make it too long", 0, 30)
	if(!sstrength)
		return

	var/prompt = alert(C, "Drop people?", "Yeet?" ,"Yes","No")
	if(prompt == "Yes")
		drop = 1

	prompt = alert(C, "delay it?", "Make them quiver!" ,"Yes","No")
	if(prompt == "Yes")
		delayed = TRUE
		delayt = tgui_input_number(src, "How much delay?", "60 secs maximum", 0, 60, 0)
		if(!delayt)
			return
		prompt = alert(C, "alert people?", "ARES announcement!" ,"Yes","No")
		if(prompt == "Yes")
			announce = TRUE
			whattoannounce = input(usr, "Please enter announcement text. Keep it empty to keep the default.", "What?", "")
			if(!whattoannounce)
				if(sstrength <= 7)
					whattoannounce = "WARNING, IMPACT IMMINENT. ETA: [delayt] SECONDS. BRACE BRACE BRACE."
				if(sstrength > 7)
					whattoannounce = "DANGER, DANGER! HIGH ENERGY IMPACT IMMINENT. ETA: [delayt] SECONDS. BRACE BRACE BRACE."

	prompt = alert(C, "Are you sure you want to shake the shipmap?", "Rock the ship!" ,"Yes","No")
	if(prompt != "Yes")
		return
	else
		log_admin("[logckey] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		message_admins("[logckey] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		if(delayed)
			if(announce)
				if(sstrength <= 5)
					shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/alert.ogg')
				if(sstrength > 5)
					shipwide_ai_announcement(whattoannounce, MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
					//playsound_area(get_area(current_mob), 'sound/machines/airalarm.ogg', 50)
		 sleep(delayt * 10)

	for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
		if(!is_mainship_level(current_mob.z))
			continue
		if(drop == 1)
			current_mob.apply_effect(3, WEAKEN)
		shake_camera(current_mob, stime, sstrength)
		if(sstrength <= 2)
			to_chat(current_mob, SPAN_DANGER("The whole deck jumps and the ship rocks!"))
			playsound_area(get_area(current_mob), 'sound/machines/bonk.ogg', 100)
		if(sstrength > 2 && sstrength <= 7)
			to_chat(current_mob, SPAN_BOLDANNOUNCE("The deck violently shakes and vibrates with the impact!"))
			playsound_area(get_area(current_mob), 'sound/machines/bonk.ogg', 100)
		if(sstrength > 7)
			playsound_area(get_area(current_mob), 'sound/effects/metal_crash.ogg', 100)
			playsound_area(get_area(current_mob), 'sound/effects/bigboom3.ogg', 100)
			if(drop == 1)
				current_mob.throw_atom( get_ranged_target_turf(current_mob, pick(cardinal), sstrength))
			to_chat(current_mob, SPAN_HIGHDANGER("YOU ARE THROWN AROUND WITH VIOLENCE AND HIT THE DECK FULL FORCE!!"))
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_area), get_area(current_mob), 'sound/effects/double_klaxon.ogg'), 2 SECONDS)

