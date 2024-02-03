/obj/structure/machinery/storm_siren
	name = "storm siren"
	desc = "A siren used to announce storm warnings for the colony."
	icon = 'icons/obj/structures/machinery/loudspeaker.dmi'
	icon_state = "loudspeaker"
	density = FALSE
	anchored = TRUE
	unacidable = 1
	unslashable = 1
	use_power = USE_POWER_NONE
	health = 0

/obj/structure/machinery/storm_siren/Initialize()
	GLOB.weather_notify_objects += src
	return ..()

/obj/structure/machinery/storm_siren/Destroy()
	GLOB.weather_notify_objects -= src
	. = ..()

/obj/structure/machinery/storm_siren/power_change()
	return

/obj/structure/machinery/storm_siren/proc/weather_warning()
	playsound(loc, 'sound/effects/weather_warning_varadero.ogg', 60, 0)
	visible_message(SPAN_DANGER("The storm siren blares: ATTENTION. ATTENTION. INCOMING TROPICAL STORM DETECTED. SEEK SHELTER IMMEDIATELY."))
