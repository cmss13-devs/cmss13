//these are probably broken

/obj/structure/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/structures/machinery/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	anchored = TRUE
	light_power = 2
	wrenchable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100

	var/on_light_range = 6

	///Whether or not the floodlight can be toggled on or off
	var/toggleable = TRUE

/obj/structure/machinery/floodlight/Initialize(mapload, ...)
	. = ..()
	if(light_on)
		set_light(on_light_range)

/obj/structure/machinery/floodlight/turn_light(mob/user, toggle_on)
	. = ..()
	if(. == NO_LIGHT_STATE_CHANGE)
		return

	if(toggle_on)
		set_light(on_light_range)
	else
		set_light(0)

	update_icon()

/obj/structure/machinery/floodlight/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return

	if(!toggleable)
		return

	if(light_on)
		to_chat(user, SPAN_NOTICE("You turn off the light."))
		turn_light(user, toggle_on = FALSE)
		update_use_power(USE_POWER_IDLE)
	else
		to_chat(user, SPAN_NOTICE("You turn on the light."))
		turn_light(user, toggle_on = TRUE)
		update_use_power(USE_POWER_ACTIVE)

/obj/structure/machinery/floodlight/update_icon()
	. = ..()
	icon_state = "flood0[light_on]"

/obj/structure/machinery/floodlight/power_change(area/master_area = null)
	..()
	if(stat & NOPOWER)
		turn_light(toggle_on = FALSE)

//Magical floodlight that cannot be destroyed or interacted with.
/obj/structure/machinery/floodlight/landing
	name = "Landing Light"
	desc = "A powerful light stationed near landing zones to provide better visibility."
	icon_state = "flood01"
	light_on = TRUE
	in_use = 1
	use_power = USE_POWER_NONE
	needs_power = FALSE
	unslashable = TRUE
	unacidable = TRUE
	wrenchable = FALSE
	toggleable = FALSE

/obj/structure/machinery/floodlight/landing/floor
	icon_state = "floor_flood01"
	density = FALSE
