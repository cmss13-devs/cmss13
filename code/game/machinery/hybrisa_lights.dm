// Hybrisa Electrical Stuff
/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch
	name = "colony electrified fence switch"
	icon = 'icons/obj/structures/props/hybrisarandomprops.dmi'
	icon_state = "panelnopower"
	desc = "This switch controls the electrified fences. It only functions when there is power."
	machinery_type_whitelist = null
	/// The power each fence takes up per process
	var/power_usage_per_fence = 5

/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/LateInitialize()
	. = ..()
	for(var/obj/structure/fence/electrified/fence as anything in GLOB.all_electric_fences)
		fence.breaker_switch = src

/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/Destroy()
	for(var/obj/structure/fence/electrified/fence as anything in GLOB.all_electric_fences)
		if(fence.breaker_switch == src)
			fence.breaker_switch = null
	return ..()

/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/process()
	var/machinepower = calculate_current_power_usage()
	if(is_on)
		machinepower += length(GLOB.all_electric_fences)
	use_power(machinepower)

/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(is_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/proc/toggle_fences()
	for(var/obj/structure/fence/electrified/fence as anything in GLOB.all_electric_fences)
		fence.toggle_power()

/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/attack_hand(mob/user as mob)
	if(..())
		toggle_fences()
		return TRUE
	return FALSE

// Hybrisa Streetlights
/obj/structure/machinery/colony_floodlight/street
	name = "colony streetlight"
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "street_off"
	layer = BILLBOARD_LAYER

/obj/structure/machinery/colony_floodlight/street/update_icon()
	if(damaged)
		icon_state = "street_dmg"
	else if(is_on)
		icon_state = "street_on"
	else
		icon_state = "street_off"

// Traffic
/obj/structure/machinery/colony_floodlight/traffic
	lum_value = 0
	name = "traffic light"
	desc = "A traffic light"
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "trafficlight"
	bound_width = 32
	bound_height = 32
	density = TRUE
	health = 200
	layer = BILLBOARD_LAYER

/obj/structure/machinery/colony_floodlight/traffic/update_icon()
	if(damaged)
		icon_state = "trafficlight_damaged"
	else if(is_on)
		icon_state = "trafficlight_on"
	else
		icon_state = "trafficlight"

/obj/structure/machinery/colony_floodlight/traffic_alt
	lum_value = 0
	name = "traffic light"
	desc = "A traffic light"
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "trafficlight_alt"
	bound_width = 32
	bound_height = 32
	density = TRUE
	health = 200
	layer = BILLBOARD_LAYER

/obj/structure/machinery/colony_floodlight/traffic_alt/update_icon()
	if(damaged)
		icon_state = "trafficlight_alt_damaged"
	else if(is_on)
		icon_state = "trafficlight_alt_on"
	else
		icon_state = "trafficlight_alt"

// Engineer Floor lights
/obj/structure/machinery/colony_floodlight_switch/engineerconsole_switch
	name = "giant alien console"
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "engineerconsole"
	desc = "A giant alien console of some kind, unlike anything you've ever seen before. Who knows the purpose of this strange technology..."
	use_power = USE_POWER_NONE
	needs_power = FALSE
	ispowered = TRUE
	machinery_type_whitelist = list(/obj/structure/machinery/colony_floodlight/engineer_circular)

/obj/structure/machinery/colony_floodlight_switch/engineerconsole_switch/LateInitialize()
	. = ..()
	stop_processing()

/obj/structure/machinery/colony_floodlight_switch/engineerconsole_switch/update_icon()
	return

/obj/structure/machinery/colony_floodlight_switch/engineerconsole_switch/power_change()
	return // It just works

/obj/structure/machinery/colony_floodlight/engineer_circular
	name = "circular light"
	icon_state = "engineerlight_off"
	desc = "A huge circular light"
	icon = 'icons/obj/structures/props/hybrisarandomprops.dmi'
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	wrenchable = FALSE
	layer = TURF_LAYER
	light_color =  "#00ffa0"
	lum_value = 14
	light_power = 6

/obj/structure/machinery/colony_floodlight/engineer_circular/update_icon()
	if(damaged)
		icon_state = "engineerlight_off"
	else if(is_on)
		icon_state = "engineerlight_on"
	else
		icon_state = "engineerlight_off"
