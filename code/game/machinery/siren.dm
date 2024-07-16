/obj/structure/machinery/siren
	name = "Siren"
	desc = "A siren used to play warnings for the colony."
	icon = 'icons/obj/structures/machinery/loudspeaker.dmi'
	icon_state = "loudspeaker"
	density = FALSE
	anchored = TRUE
	unacidable = 1
	unslashable = 1
	use_power = USE_POWER_NONE
	health = 0
	var/message
	var/sound = 'sound/effects/weather_warning.ogg'
	var/siren_lt = "weather"

/obj/structure/machinery/siren/Initialize()
	. = ..()
	GLOB.siren_objects["[siren_lt]"] += list(src)

/obj/structure/machinery/siren/Destroy()
	. = ..()
	GLOB.siren_objects["[siren_lt]"] -= src

/obj/structure/machinery/siren/power_change()
	return

/obj/structure/machinery/siren/proc/siren_warning(msg = message, sound_ch = 'sound/effects/weather_warning.ogg')
	playsound(loc, sound_ch, 80, 0)
	visible_message(SPAN_DANGER("[src] blares. [msg]."))


/obj/structure/machinery/siren/storm
	name = "Storm Siren"
	desc = "A siren used to announce storm warnings for the colony."
	message = "ATTENTION. ATTENTION. INCOMING TROPICAL STORM DETECTED. SEEK SHELTER IMMEDIATELY."


/obj/structure/machinery/siren/weather
	name = "Weather Siren"
	desc = "A siren used to play weather warnings for the colony."
	message = "ATTENTION. POTENTIALLY HAZARDOUS WEATHER ANOMALY DETECTED. SEEK SHELTER IMMEDIATELY."
