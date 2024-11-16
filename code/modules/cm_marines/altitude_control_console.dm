//Defines what to times the OB and transport shuttle timers by based on the altitude
#define SHIP_ALT_LOW 0.5
#define SHIP_ALT_MED 1
#define SHIP_ALT_HIGH 1.5

//List of available heights
GLOBAL_VAR_INIT(ship_alt_list, list("Low Altitude" = SHIP_ALT_LOW, "Optimal Altitude" = SHIP_ALT_MED, "High Altitude" = SHIP_ALT_HIGH))

//Handles whether or not hijack has disabled the system
GLOBAL_VAR_INIT(alt_ctrl_disabled, FALSE)

//Defines how much to heat the engines or cool them by, and when to overheat
#define COOLING -10
#define OVERHEAT_COOLING -5
#define HEATING 10
#define OVERHEAT 100

//Has the ships temperature set to 0 on startup, sets the global default var to med
GLOBAL_VAR_INIT(ship_temp, 0)
GLOBAL_VAR_INIT(ship_alt, SHIP_ALT_MED)

/obj/structure/machinery/computer/altitude_control_console
	icon_state = "overwatch"
	name = "Altitude Control Console"
	desc = "The A.C.C console monitors, regulates, and updates the ships attitude and altitude in relation to the AO. It's not rocket science."

/obj/structure/machinery/computer/altitude_control_console/attack_hand()
	. = ..()
	if(!skillcheck(usr, SKILL_NAVIGATIONS, SKILL_NAVIGATIONS_TRAINED))
		to_chat(usr, SPAN_WARNING("A window of complex orbital math opens up. You have no idea what you are doing and quickly close it."))
		return
	if(GLOB.alt_ctrl_disabled)
		to_chat(usr, SPAN_WARNING("The Altitude Control Console has been locked by ARES due to Delta Alert."))
		return
	tgui_interact(usr)

/obj/structure/machinery/computer/altitude_control_console/Initialize()
	. = ..()
	START_PROCESSING(SSslowobj, src)

/obj/structure/machinery/computer/altitude_control_console/Destroy()
	STOP_PROCESSING(SSslowobj, src)
	return ..()

/obj/structure/machinery/computer/altitude_control_console/process()
	. = ..()
	var/temperature_change
	if(GLOB.ship_temp >= OVERHEAT)
		ai_silent_announcement("Attention: orbital correction no longer sustainable, moving to geo-synchronous orbit until engine cooloff.", ";", TRUE)
		GLOB.ship_alt = SHIP_ALT_HIGH
		temperature_change = OVERHEAT_COOLING
		for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
			if(!is_mainship_level(current_mob.z))
				continue
			current_mob.apply_effect(3, WEAKEN)
			shake_camera(current_mob, 10, 2)
		ai_silent_announcement("Attention performing high-G maneuverer", ";", TRUE)
	if(!temperature_change)
		switch(GLOB.ship_alt)
			if(SHIP_ALT_LOW)
				temperature_change = HEATING
			if(SHIP_ALT_MED)
				temperature_change = COOLING
			if(SHIP_ALT_HIGH)
				temperature_change = COOLING
	GLOB.ship_temp = clamp(GLOB.ship_temp += temperature_change, 0, 120)
	if(prob(50))
		return
	if(GLOB.ship_alt == SHIP_ALT_LOW)
		for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
			if(!is_mainship_level(current_mob.z))
				continue
			shake_camera(current_mob, 10, 1)
		ai_silent_announcement("Performing Attitude Control", ";", TRUE)

//TGUI.... fun... years have gone by, I am dying of old age
/obj/structure/machinery/computer/altitude_control_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AltitudeControlConsole", "[src.name]")
		ui.open()

/obj/structure/machinery/computer/altitude_control_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/altitude_control_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/altitude_control_console/ui_data(mob/user)
	var/list/data = list()
	data["alt"] = GLOB.ship_alt
	data["temp"] = GLOB.ship_temp

	return data

/obj/structure/machinery/computer/altitude_control_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("low_alt")
			change_altitude(user, SHIP_ALT_LOW)
			. = TRUE
		if("med_alt")
			change_altitude(user, SHIP_ALT_MED)
			. = TRUE
		if("high_alt")
			change_altitude(user, SHIP_ALT_HIGH)
			. = TRUE
	message_admins("[key_name(user)] has changed the ship's altitude to [action].")

	add_fingerprint(usr)

/obj/structure/machinery/computer/altitude_control_console/proc/change_altitude(mob/user, new_altitude)
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_ALTITUDE_CHANGE))
		to_chat(user, SPAN_WARNING("The engines are not ready to burn yet."))
		return
	if(GLOB.ship_alt == new_altitude)
		return
	GLOB.ship_alt = new_altitude
	TIMER_COOLDOWN_START(src, COOLDOWN_ALTITUDE_CHANGE, 90 SECONDS)
	for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
		if(!is_mainship_level(current_mob.z))
			continue
		current_mob.apply_effect(3, WEAKEN)
		shake_camera(current_mob, 10, 2)
	ai_silent_announcement("Attention: Performing high-G manoeuvre", ";", TRUE)

#undef COOLING
#undef OVERHEAT_COOLING
#undef HEATING
#undef OVERHEAT
