/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/



/area
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1

	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREAS_LAYER
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1

	var/flags_alarm_state = NOFLAGS

	var/debug = 0
	var/powerupdate = 10		//We give everything 10 ticks to settle out it's power usage.
	var/requires_power = 1
	var/unlimited_power = 0
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1
	var/list/apc = list()
	var/list/area_machines = list() // list of machines only for master areas
	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = list()		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = 0
	var/list/ambience = list('sound/ambience/ambigen1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/hook/startup/proc/setupTeleportLocs()
	for(var/area/AR in all_areas)
		if(istype(AR, /area/shuttle)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == MAIN_SHIP_Z_LEVEL)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	teleportlocs = sortAssoc(teleportlocs)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in all_areas)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/tdome) || istype(AR, /area/adminlevel/bunker01/mainroom) || istype(AR, /area/adminlevel/ert_station))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == 3 || picked.z == 4 || picked.z == 5)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortAssoc(ghostteleportlocs)

	return 1

/*-----------------------------------------------------------------------------*/
/area/space
	name = "\improper Space"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list('sound/ambience/ambispace.ogg')
	temperature = TCMB
	pressure = 0
	flags_atom = AREA_NOTUNNEL

/area/engine/
	ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')
/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "\improper Arrival Area"
	icon_state = "start"

/area/admin
	name = "\improper Admin room"
	icon_state = "start"

//Defined for fulton recovery storage
/area/space/highalt
	name = "High Altitude"
	icon_state = "blue"

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	has_gravity = 1

// === end remove
/*
/area/alien
	name = "\improper abandoned  Alien base"
	icon_state = "yellow"
	requires_power = 0
*/
// CENTCOM

/area/centcom
	name = "\improper abandoned  Centcom"
	icon_state = "centcom"
	requires_power = 0

/area/centcom/control
	name = "\improper abandoned  Centcom Control"

/area/centcom/evac
	name = "\improper abandoned  Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "\improper abandoned  Centcom Supply Shuttle"

/area/centcom/ferry
	name = "\improper abandoned  Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "\improper abandoned  Centcom Administration Shuttle"

/area/centcom/test
	name = "\improper abandoned  Centcom Testing Facility"

/area/centcom/living
	name = "\improper abandoned  Centcom Living Quarters"

/area/centcom/specops
	name = "\improper abandoned  Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "\improper abandoned  Holding Facility"

/area/centcom/solitary
	name = "Solitary Confinement"
	icon_state = "brig"


/area/tdome
	name = "\improper abandoned  Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	flags_atom = AREA_NOTUNNEL

/area/tdome/tdome1
	name = "\improper abandoned  Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper abandoned  Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper abandoned  Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper abandoned  Thunderdome (Observer.)"
	icon_state = "purple"

//Teleporter

/area/teleporter
	name = "\improper abandoned  Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/gateway
	name = "\improper abandoned  Gateway"
	icon_state = "teleporter"
	music = "signal"

/area/AIsattele
	name = "\improper abandoned  AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"
	ambience = list('sound/ambience/ambimalf.ogg')

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/centcom,
)

//SPACE STATION 13
var/list/the_station_areas = list ()