/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	var/syndicate = 0
	immune_to_ssd = 1
	var/list/speech_synthesizer_langs = list()	//which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/device/camera/siliconcam/aiCamera = null //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/med_hud = MOB_HUD_MEDICAL_ADVANCED //Determines the med hud to use
	var/sec_hud = MOB_HUD_SECURITY_ADVANCED //Determines the sec hud to use
	var/list/HUD_toggled = list(0,0,0)

/mob/living/silicon/Initialize()
	. = ..()
	living_misc_mobs += src
	add_language("English")

/mob/living/silicon/Destroy()
	..()
	living_misc_mobs -= src

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_held_item()
	return

/mob/living/silicon/drop_held_items()
	return

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			src.take_limb_damage(20)
			Stun(rand(5,10))
		if(2)
			src.take_limb_damage(10)
			Stun(rand(1,5))
	flash_eyes(1, TRUE, type = /obj/screen/fullscreen/flash/noise)

	to_chat(src, SPAN_DANGER("<B>*BZZZT*</B>"))
	to_chat(src, SPAN_DANGER("Warning: Electromagnetic pulse detected."))
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount)
	return	//immune

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return 0//The only effect that can hit them atm is flashes and they still directly edit so this works for now

/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if (bot.connected_ai == ai)
		return 1
	return 0


// this function shows health in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!stat)
		stat(null, text("System integrity: [round((health/maxHealth)*100)]%"))
	else
		stat(null, text("Systems nonfunctional"))

// this function displays the station time in the status panel
/mob/living/silicon/proc/show_station_time()
	stat(null, "Station Time: [worldtime2text()]")


// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(EvacuationAuthority)
		var/eta_status = EvacuationAuthority.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)


// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/Stat()
	if (!..())
		return 0

	show_station_time()
	show_emergency_shuttle_eta()
	show_system_integrity()
	return 1

// this function displays the stations manifest in a separate window
/mob/living/silicon/proc/show_station_manifest()
	var/dat
	dat += "<h4>Crew Manifest</h4>"
	if(data_core)
		dat += data_core.get_manifest(1) // make it monochrome
	dat += "<br>"
	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user, var/error_msg)
	if(error_msg)
		to_chat(user, SPAN_WARNING("The armoured plating is too tough."))
	return 0


//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs)	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	if (..(language) && can_speak)
		speech_synthesizer_langs.Add(all_languages[language])
		return 1

/mob/living/silicon/remove_language(var/rem_language)
	..(rem_language)

	for (var/datum/language/L in speech_synthesizer_langs)
		if (L.name == rem_language)
			speech_synthesizer_langs -= L

/mob/living/silicon/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>Speech Synthesizer: <i>[(L in speech_synthesizer_langs)? "YES":"NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return



/mob/living/silicon/proc/toggle_sensor_mode()
	if(!client)
		return
	var/list/listed_huds = list("Medical HUD", "Security HUD", "Squad HUD")
	var/hud_choice = input("Choose a HUD to toggle", "Toggle HUD", null) as null|anything in listed_huds
	if(!client)
		return
	var/datum/mob_hud/H
	var/HUD_nbr = 1
	switch(hud_choice)
		if("Medical HUD")
			H = huds[MOB_HUD_MEDICAL_OBSERVER]
		if("Security HUD")
			H = huds[MOB_HUD_SECURITY_ADVANCED]
			HUD_nbr = 2
		if("Squad HUD")
			H = huds[MOB_HUD_SQUAD]
			HUD_nbr = 3
		else
			return

	if(HUD_toggled[HUD_nbr])
		HUD_toggled[HUD_nbr] = 0
		H.remove_hud_from(src)
		to_chat(src, SPAN_NOTICE(" <B>[hud_choice] Disabled</B>"))
	else
		HUD_toggled[HUD_nbr] = 1
		H.add_hud_to(src)
		to_chat(src, SPAN_NOTICE(" <B>[hud_choice] Enabled</B>"))

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  strip_html(input(usr, "This is [src]. It is...", "Pose", null)  as text)

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  strip_html(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text)

/mob/living/silicon/binarycheck()
	return 1

/mob/living/silicon/rejuvenate()
	..()
	living_misc_mobs += src

/mob/living/silicon/ex_act(severity)
	flash_eyes()

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (stat != 2)
				apply_damage(30, BRUTE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (stat != 2)
				apply_damage(60, BRUTE)
				apply_damage(60, BURN)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if (stat != 2)
				apply_damage(100, BRUTE)
				apply_damage(100, BURN)
				if(!anchored)
					gib()

	updatehealth()
