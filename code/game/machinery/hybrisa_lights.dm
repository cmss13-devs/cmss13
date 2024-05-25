// Hybrisa Electrical Stuff
/obj/structure/machinery/colony_electrified_fence_switch
	name = "Colony Electrified Fence Switch"
	icon = 'icons/obj/structures/props/hybrisarandomprops.dmi'
	icon_state = "panelnopower"
	desc = "This switch controls the electrified fences. It only functions when there is power."
	density = FALSE
	anchored = TRUE
	var/ispowered = FALSE
	var/turned_on = FALSE //has to be toggled in SOMEWHERE
	use_power = USE_POWER_IDLE
	unslashable = TRUE
	unacidable = TRUE
	var/list/fencelist = list() // This will save our list of electrified fences on the map
	power_machine = TRUE

/obj/structure/machinery/colony_electrified_fence_switch/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/colony_electrified_fence_switch/LateInitialize()
	. = ..()
	for(var/obj/structure/fence/electrified/fence in  GLOB.all_fences)
		fencelist += fence
		fence.fswitch = src
	start_processing()

/obj/structure/machinery/colony_electrified_fence_switch/Destroy()
	for(var/obj/structure/fence/electrified/fence as anything in fencelist)
		fence.fswitch = null
	fencelist = null
	return ..()

/obj/structure/machinery/colony_electrified_fence_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(turned_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/colony_electrified_fence_switch/process()
	return

/obj/structure/machinery/colony_electrified_fence_switch/power_change()
	..()
	if((stat & NOPOWER))
		if(ispowered && turned_on)
			toggle_fences()
		ispowered = FALSE
		turned_on = FALSE
		update_icon()
	else
		ispowered = TRUE
		update_icon()

/obj/structure/machinery/colony_electrified_fence_switch/proc/toggle_fences()
	for(var/obj/structure/fence/electrified/fence as anything in fencelist)
		fence.toggle_power()

/obj/structure/machinery/colony_electrified_fence_switch/attack_hand(mob/user as mob)
	if(!ishuman(user))
		to_chat(user, "Nice try.")
		return FALSE
	if(!ispowered)
		to_chat(user, "Nothing happens.")
		return FALSE
	playsound(src,'sound/items/Deconstruct.ogg', 30, 1)
	use_power(5)
	toggle_fences()
	turned_on = !turned_on
	update_icon()
	return TRUE

// Hybrisa Streetlights
/obj/structure/machinery/colony_floodlight/street
	name = "Colony Streetlight"
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "street_off"
	layer = ABOVE_XENO_LAYER

/obj/structure/machinery/colony_floodlight/street/update_icon()
	if(damaged)
		icon_state = "street_dmg"
	else if(is_lit)
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
	layer = ABOVE_XENO_LAYER

/obj/structure/machinery/colony_floodlight/traffic/update_icon()
	if(damaged)
		icon_state = "trafficlight_damaged"
	else if(is_lit)
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
	layer = ABOVE_XENO_LAYER

/obj/structure/machinery/colony_floodlight/traffic_alt/update_icon()
	if(damaged)
		icon_state = "trafficlight_alt_damaged"
	else if(is_lit)
		icon_state = "trafficlight_alt_on"
	else
		icon_state = "trafficlight_alt"

// Engineer Floor lights

/obj/structure/machinery/engineerconsole_switch
	name = "Giant Alien Console"
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "engineerconsole"
	desc = "A Giant Alien console of some kind, unlike anything you've ever seen before. Who knows the purpose of this strange technology..."
	bound_height = 32
	bound_width = 32
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	density = TRUE
	anchored = TRUE
	var/ispowered = TRUE
	var/turned_on = 0 //has to be toggled in engineering
	use_power = USE_POWER_NONE
	var/list/floodlist = list() // This will save our list of floodlights on the map
	power_machine = TRUE

/obj/structure/machinery/engineerconsole_switch/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/engineerconsole_switch/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/colony_floodlight/engineer_circular/floodlight in GLOB.ship_floodlights)
		floodlist += floodlight
		floodlight.fswitch = src
	start_processing()

/obj/structure/machinery/engineerconsole_switch/Destroy()
	for(var/obj/structure/machinery/colony_floodlight/engineer_circular/floodlight as anything in floodlist)
		floodlight.fswitch = null
	floodlist = null
	return ..()

/obj/structure/machinery/engineerconsole_switch/process()
	var/lightpower = 0
	for(var/obj/structure/machinery/colony_floodlight/engineer_circular/colony_floodlight in floodlist)
		if(!colony_floodlight.is_lit)
			continue
		lightpower += colony_floodlight.power_tick
	use_power(lightpower)

/obj/structure/machinery/engineerconsole_switch/power_change()
	..()
	if((stat & NOPOWER))
		if(ispowered && turned_on)
			toggle_lights()
		ispowered = FALSE
		turned_on = FALSE
		update_icon()
	else
		ispowered = TRUE
		update_icon()

/obj/structure/machinery/engineerconsole_switch/proc/toggle_lights()
	for(var/obj/structure/machinery/colony_floodlight/engineer_circular/floodlight in floodlist)
		spawn(rand(10,60))
			floodlight.is_lit = !floodlight.is_lit
			if(!floodlight.damaged)
				if(floodlight.is_lit) //Shut it down
					floodlight.set_light(l_range = floodlight.lum_value,l_power = floodlight.light_power , l_color = floodlight.light_color)
				else
					floodlight.set_light(0)
			floodlight.update_icon()
	return FALSE

/obj/structure/machinery/engineerconsole_switch/attack_hand(mob/user as mob)
	if(!ishuman(user))
		to_chat(user, "Nice try.")
		return FALSE
	if(!ispowered)
		to_chat(user, "Nothing happens.")
		return FALSE
	playsound(src,'sound/effects/EMPulse.ogg', 30, 1)
	toggle_lights()
	turned_on = !turned_on
	update_icon()
	return TRUE

GLOBAL_LIST_INIT(ship_floodlights, list())
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
	else if(is_lit)
		icon_state = "engineerlight_on"
	else
		icon_state = "engineerlight_off"

/obj/structure/machinery/colony_floodlight/engineer_circular/Initialize()
	. = ..()
	GLOB.ship_floodlights += src

/obj/structure/machinery/colony_floodlight/engineer_circular/Destroy()
	. = ..()
	GLOB.ship_floodlights -= src
