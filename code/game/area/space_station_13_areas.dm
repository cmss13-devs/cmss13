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

/*-----------------------------------------------------------------------------*/
/area/space
	name = "\improper Space"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 0
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	temperature = TCMB
	pressure = 0
	flags_area = AREA_NOTUNNEL
	test_exemptions = MAP_TEST_EXEMPTION_SPACE
	weather_enabled = FALSE

/area/engine
	//ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')

/area/admin
	name = "\improper Admin room"
	icon_state = "start"

/area/admin/droppod
	lighting_use_dynamic = FALSE

/area/admin/droppod/holding
	name = "\improper Admin Supply Drops Droppod"

/area/admin/droppod/loading
	name = "\improper Admin Supply Drops Loading"

//Defined for fulton recovery storage
/area/space/highalt
	name = "High Altitude"
	icon_state = "blue"

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	has_gravity = 1

// === end remove

// CENTCOM

/area/centcom
	name = "\improper abandoned  Centcom"
	icon_state = "centcom"
	requires_power = 0
	statistic_exempt = TRUE

/area/centcom/control
	name = "\improper abandoned  Centcom Control"

/area/centcom/living
	name = "\improper abandoned  Centcom Living Quarters"

/area/tdome
	name = "\improper abandoned  Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	flags_area = AREA_NOTUNNEL
	statistic_exempt = TRUE

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
