/area/whiskey_outpost
	name = "\improper Whiskey Outpost"
	icon = 'icons/turf/area_whiskey.dmi'
	icon_state = "outside"
	ceiling = CEILING_METAL
	powernet_name = "ground"

/*
|***INSIDE AREAS***|
*/

/area/whiskey_outpost/inside
	name = "Interior Whiskey Outpost"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/whiskey_outpost/inside/hospital
	name = "\improper Hospital"
	icon_state = "medical"

/area/whiskey_outpost/inside/hospital/triage
	name = "\improper Triage Center"

/area/whiskey_outpost/inside/cic
	name = "\improper Command Information Center"
	icon_state = "CIC"

/area/whiskey_outpost/inside/bunker
	name = "\improper Bunker"
	icon_state = "bunker"

/area/whiskey_outpost/inside/bunker/pillbox
	ceiling = CEILING_METAL

/area/whiskey_outpost/inside/bunker/pillbox/one
	name = "Pillbox Bourbon"
	icon_state = "p1"

/area/whiskey_outpost/inside/bunker/pillbox/two
	name = "Pillbox Wine"
	icon_state = "p2"

/area/whiskey_outpost/inside/bunker/pillbox/three
	name = "Pillbox Vodka"
	icon_state = "p3"

/area/whiskey_outpost/inside/bunker/pillbox/four
	name = "Pillbox Tequila"
	icon_state = "p4"

/area/whiskey_outpost/inside/bunker/bunker/front
	name = "Pillbox Beer"
	icon_state = "p5"


/area/whiskey_outpost/inside/engineering
	name = "\improper Engineering"
	icon_state = "engineering"

/area/whiskey_outpost/inside/living
	name = "\improper Living Quarters"
	icon_state = "livingspace"

/area/whiskey_outpost/inside/supply
	name = "\improper Supply Depo"
	icon_state = "req"

/*
|***OUTSIDE AREAS***|
*/

/area/whiskey_outpost/outside
	name = "\improper Unused"
	icon_state = "outside"
	ceiling = CEILING_NONE
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE

/area/whiskey_outpost/outside/north
	name = "\improper Northern Beach"
	icon_state = "north"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/whiskey_outpost/outside/north/northwest
	name = "\improper North-Western Beach"
	icon_state = "northwest"

/area/whiskey_outpost/outside/north/northeast
	name = "\improper North-Eastern Beach"
	icon_state = "northeast"

/area/whiskey_outpost/outside/north/beach
	name = "\improper Bunker Beach"
	icon_state = "farnorth"

/area/whiskey_outpost/outside/north/platform
	name = "\improper Bunker Platform"
	icon_state = "platform"

/area/whiskey_outpost/outside/lane

/area/whiskey_outpost/outside/lane/one_north
	name = "\improper Western Jungle North"
	icon_state = "lane1n"

/area/whiskey_outpost/outside/lane/one_south
	name = "\improper Western Jungle South"
	icon_state = "lane1s"

/area/whiskey_outpost/outside/lane/two_north
	name = "\improper Western Path North"
	icon_state = "lane2n"

/area/whiskey_outpost/outside/lane/two_south
	name = "\improper Western Path South"
	icon_state = "lane2s"

/area/whiskey_outpost/outside/lane/three_north
	name = "\improper Eastern Path North"
	icon_state = "lane3n"

/area/whiskey_outpost/outside/lane/three_south
	name = "\improper Eastern Path South"
	icon_state = "lane3s"

/area/whiskey_outpost/outside/lane/four_north
	name = "\improper Eastern Crash Site North"
	icon_state = "lane4n"

/area/whiskey_outpost/outside/lane/four_south
	name = "\improper Eastern Crash Site South"
	icon_state = "lane4s"

//lane4south
/area/whiskey_outpost/outside/south
	name = "\improper Perimeter Entrance"
	icon_state = "south"

/area/whiskey_outpost/outside/south/far
	name = "Southern Jungle"
	icon_state = "farsouth"

/area/whiskey_outpost/outside/south/very_far
	name = "\improper Far-Southern Jungle"
	icon_state = "veryfarsouth"

/area/whiskey_outpost/outside/mortar_pit
	name = "\improper Mortar Pit"
	icon_state = "mortarpit"

/area/whiskey_outpost/outside/river
	name = "\improper Riko's River Central"
	icon_state = "river"

/area/whiskey_outpost/outside/river/east
	name = "\improper Riko's River East"
	icon_state = "rivere"

/area/whiskey_outpost/outside/river/west
	name = "\improper Riko's River West"
	icon_state = "riverw"

/*
|***CAVE AREAS***|
*/

/area/whiskey_outpost/inside/caves
	name = "\improper Rock"
	icon_state = "rock"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambisin4.ogg')
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE

/area/whiskey_outpost/inside/caves/tunnel
	name = "\improper Tunnel"
	icon_state = "tunnel"
	flags_atom = AREA_NOTUNNEL

/area/whiskey_outpost/inside/caves/caverns
	name = "\improper Northern Caverns"
	icon_state = "caves"
/area/whiskey_outpost/inside/caves/caverns/west
	name = "\improper Western Caverns"
	icon_state = "caveswest"

/area/whiskey_outpost/inside/caves/caverns/east
	name = "\improper Eastern Caverns"
	icon_state = "caveseast"
