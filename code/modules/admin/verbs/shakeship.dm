/client/proc/shakeship()
	set name = "Shake shipmap"
	set category = "Admin.Events"

	var/client/C = usr.client
	var/logckey = C.ckey
	var/drop = 0

	var/sstrength = tgui_input_number(src, "How Strong?", "Don't go overboard, please.")
	if(!sstrength)
		return
	var/stime = tgui_input_number(src, "Time Between Shakes?", "Don't make it too long")
	if(!sstrength)
		return

	var/prompt = alert(C, "Drop people?", "Yeet?" ,"Yes","No")
	if(prompt == "Yes")
		drop = 1

	prompt = alert(C, "Are you sure you want to shake the shipmap?", "Rock the ship!" ,"Yes","No")
	if(prompt != "Yes")
		return
	else
		log_admin("[logckey] rocked the ship! with the strength of [sstrength], and duration of [stime]")
		message_admins("[logckey] rocked the ship! with the strength of [sstrength], and duration of [stime]")

	for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
		if(!is_mainship_level(current_mob.z))
			continue
		if(drop == 1)
			current_mob.apply_effect(3, WEAKEN)
		shake_camera(current_mob, sstrength, stime)
		playsound_area(get_area(current_mob), 'sound/machines/bonk.ogg', 100)
		to_chat(current_mob, SPAN_BOLDANNOUNCE("The deck is shaken around as the ship suddenly bumps!"))
