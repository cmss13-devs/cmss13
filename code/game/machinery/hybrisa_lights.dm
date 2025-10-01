// Hybrisa Electrical Stuff
/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch
	name = "colony electrified fence switch"
	icon_state = "panelbnopower"
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
		icon_state = "panelbnopower"
	else if(is_on)
		icon_state = "panelbon"
	else
		icon_state = "panelboff"

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
	icon = 'icons/obj/structures/props/streetlights.dmi'
	icon_state = "street_off"
	layer = BILLBOARD_LAYER
	light_color = LIGHT_COLOR_XENON
	explo_proof = FALSE
	lum_value = 12

/obj/structure/machinery/colony_floodlight/street/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/shimmy_around, east_offset = -15, west_offset = -15)

/obj/structure/machinery/colony_floodlight/street/update_icon()
	if(damaged)
		icon_state = "street_dmg"
	else if(is_on)
		icon_state = "street_on"
	else
		icon_state = "street_off"

/obj/structure/machinery/colony_floodlight/street/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			return
		if(EXPLOSION_THRESHOLD_LOW to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/colony_floodlight/street/deconstruct(disassembled)
	var/obj/structure/prop/hybrisa/misc/pole_stump/stump = new(loc)
	stump.pixel_x = pixel_x
	stump.pixel_y = pixel_y
	return ..()

// Traffic
/obj/structure/machinery/colony_floodlight/traffic
	name = "traffic light"
	desc = "A traffic light"
	icon = 'icons/obj/structures/props/streetlights.dmi'
	icon_state = "trafficlight"
	health = 200
	layer = BILLBOARD_LAYER
	lum_value = 0
	explo_proof = FALSE

/obj/structure/machinery/colony_floodlight/traffic/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/shimmy_around, east_offset = -15, west_offset = -15)

/obj/structure/machinery/colony_floodlight/traffic/update_icon()
	if(damaged)
		icon_state = "trafficlight_damaged"
	else if(is_on)
		icon_state = "trafficlight_on"
	else
		icon_state = "trafficlight"

/obj/structure/machinery/colony_floodlight/traffic/alt
	icon_state = "trafficlight_alt"

/obj/structure/machinery/colony_floodlight/traffic/alt/update_icon()
	if(damaged)
		icon_state = "trafficlight_alt_damaged"
	else if(is_on)
		icon_state = "trafficlight_alt_on"
	else
		icon_state = "trafficlight_alt"

/obj/structure/machinery/colony_floodlight/traffic/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			return
		if(EXPLOSION_THRESHOLD_LOW to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/colony_floodlight/traffic/deconstruct(disassembled)
	var/obj/structure/prop/hybrisa/misc/pole_stump/traffic/stump = new(loc)
	stump.pixel_x = pixel_x
	stump.pixel_y = pixel_y
	return ..()

// Engineer Floor lights
/obj/structure/machinery/colony_floodlight_switch/engineerconsole_switch
	name = "giant alien console"
	icon = 'icons/obj/structures/props/engineers/consoles.dmi'
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
	icon = 'icons/obj/structures/props/engineers/light.dmi'
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
