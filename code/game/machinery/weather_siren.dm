/obj/structure/machinery/weather_siren
	name = "Weather Siren"
	desc = "A siren used to play weather warnings for the colony."
	icon = 'icons/obj/structures/machinery/loudspeaker.dmi'
	icon_state = "loudspeaker"
	density = 0
	anchored = 1
	unacidable = 1
	unslashable = 1
	use_power = 0
	health = 0

/obj/structure/machinery/weather_siren/Initialize()
	weather_notify_objects += src
	return ..()

/obj/structure/machinery/weather_siren/power_change()
	return

/obj/structure/machinery/weather_siren/proc/weather_warning()
	playsound(loc, 'sound/effects/weather_warning.ogg', 50, 0)
	visible_message(SPAN_DANGER("The [src] blares. ATTENTION. POTENTIALLY HAZARDOUS WEATHER ANOMALY DETECTED. SEEK SHELTER IMMEDIATELY."))