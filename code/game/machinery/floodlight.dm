/obj/structure/machinery/floodlight
	name = "emergency floodlight"
	desc = "A powerful light usually stationed near landing zones to provide better visibility."
	icon = 'icons/obj/structures/machinery/floodlight.dmi'
	icon_state = "flood_0"
	density = TRUE
	anchored = TRUE
	light_power = 2
	wrenchable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 100

	///How far the light will go when the floodlight is on
	var/on_light_range = 6
	///Whether or not the floodlight can be toggled on or off
	var/toggleable = TRUE
	///Whether or not the floodlight is turned on, disconnected from whether it has power or is lit
	var/turned_on = FALSE
	///base state
	var/base_icon_state = "flood"

/obj/structure/machinery/floodlight/Initialize(mapload, ...)
	. = ..()

	turn_light(toggle_on = (operable() && turned_on))

/obj/structure/machinery/floodlight/turn_light(mob/user, toggle_on)
	. = ..()
	if(. == NO_LIGHT_STATE_CHANGE)
		return

	if(toggle_on)
		set_light(on_light_range)
	else
		set_light(0)

	update_icon()

/obj/structure/machinery/floodlight/attack_hand(mob/living/user)
	if(!toggleable)
		to_chat(user, SPAN_NOTICE("[src] doesn't seem to have a switch to toggle the light."))
		return

	if(user.is_mob_incapacitated())
		return

	if(!is_valid_user(user))
		to_chat(user, SPAN_NOTICE("You don't have the dexterity to do this."))
		return

	turned_on = !turned_on

	if(inoperable())
		to_chat(user, SPAN_NOTICE("You turn [turned_on ? "on" : "off"] the floodlight. It seems to be inoperable."))
		return

	to_chat(user, SPAN_NOTICE("You turn [turned_on ? "on" : "off"] the light."))
	turn_light(user, toggle_on = turned_on)
	update_use_power(turned_on ? USE_POWER_ACTIVE : USE_POWER_IDLE)

/obj/structure/machinery/floodlight/update_icon()
	. = ..()
	icon_state = "[base_icon_state]_[light_on]"

/obj/structure/machinery/floodlight/power_change(area/master_area = null)
	. = ..()

	turn_light(toggle_on = (!(stat & NOPOWER) && turned_on))

//Magical floodlight that cannot be destroyed or interacted with.
/obj/structure/machinery/floodlight/landing
	name = "landing light"
	desc = "A powerful light usually stationed near landing zones to provide better visibility. This one seems to have been bolted down and is unable to be moved."
	icon_state = "flood_1"
	use_power = USE_POWER_NONE
	needs_power = FALSE
	unslashable = TRUE
	unacidable = TRUE
	wrenchable = FALSE
	toggleable = FALSE
	turned_on = TRUE

/obj/structure/machinery/floodlight/landing/floor
	icon_state = "floor_flood_1"
	base_icon_state = "floor_flood"
	density = FALSE

/obj/structure/machinery/floodlight/landing/floor/almayer
	light_power = 0.7

/obj/structure/machinery/floodlight/landing/dropship_airlock
	light_power = 2
	on_light_range = 10
	light_system = MOVABLE_LIGHT
	light_color =  LIGHT_COLOR_BLUE
	light_mask_type = /atom/movable/lighting_mask/rotating_toggleable
	var/obj/docking_port/stationary/marine_dropship/airlock/inner/linked_inner = null
	var/linked_inner_dropship_airlock_id = "generic"

/obj/structure/machinery/floodlight/landing/dropship_airlock/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/floodlight/landing/dropship_airlock/LateInitialize()
	. = ..()
	for(var/obj/docking_port/stationary/marine_dropship/airlock/inner/inner_airlock in GLOB.dropship_airlock_docking_ports)
		if(linked_inner_dropship_airlock_id == inner_airlock.dropship_airlock_id)
			linked_inner = inner_airlock
			linked_inner.floodlights += src

/obj/structure/machinery/floodlight/landing/dropship_airlock/Destroy()
	if(linked_inner)
		linked_inner.floodlights -= src
	. = ..()

/obj/structure/machinery/floodlight/landing/dropship_airlock/proc/toggle_rotating()
	if(istype(light.our_mask, /atom/movable/lighting_mask/rotating_toggleable))
		var/atom/movable/lighting_mask/rotating_toggleable/rotating_mask = light.our_mask
		playsound(src, 'sound/machines/switch.ogg', 100, vol_cat = VOLUME_SFX)
		rotating_mask.toggle()

/obj/structure/machinery/floodlight/landing/dropship_airlock/almayer_one
	linked_inner_dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_ONE

/obj/structure/machinery/floodlight/landing/dropship_airlock/almayer_two
	linked_inner_dropship_airlock_id = ALMAYER_HANGAR_AIRLOCK_TWO
