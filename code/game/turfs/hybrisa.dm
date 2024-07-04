// ------ Hybrisa tiles ------ //

/turf/open/hybrisa
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "hybrisa"

/turf/open/floor/hybrisa
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "hybrisa"

/turf/open/floor/plating/engineer_ship
	icon = 'icons/turf/floors/engineership.dmi'

// Hybrisa auto-turf

// Shale

/turf/open/auto_turf/hybrisashale
	layer_name = list("wind blown dirt", "volcanic plate rock", "volcanic plate and rock", "this layer does not exist")
	icon = 'icons/turf/floors/auto_shaledesaturated.dmi'
	icon_prefix = "shale"

/turf/open/auto_turf/hybrisashale/ex_act(severity)
	return

/turf/open/auto_turf/hybrisashale/scorch(heat_level)
	return

/turf/open/auto_turf/hybrisashale/get_dirt_type()
	return DIRT_TYPE_SHALE

/turf/open/auto_turf/hybrisashale/layer0
	icon_state = "shale_0"
	bleed_layer = 0

/turf/open/auto_turf/hybrisashale/layer0_plate //for inner plate shenanigans
	icon_state = "shale_1_alt"
	bleed_layer = 0

/turf/open/auto_turf/hybrisashale/layer1
	icon_state = "shale_1"
	bleed_layer = 1

/turf/open/auto_turf/hybrisashale/layer2
	icon_state = "shale_2"
	bleed_layer = 2

// Dirt

/turf/open/auto_turf/hybrisa_dirt
	layer_name = list("aged igneous", "dirt", "warn a coder", "warn a coder", "warn a coder")
	icon = 'icons/turf/floors/hybrisa_dirt.dmi'
	icon_state = "varadero_0"
	icon_prefix = "varadero"

/turf/open/auto_turf/hybrisa_dirt/ex_act(severity)
	return

/turf/open/auto_turf/hybrisa_dirt/scorch(heat_level)
	return

/turf/open/auto_turf/hybrisa_dirt/get_dirt_type()
	return DIRT_TYPE_SAND

/turf/open/auto_turf/hybrisa_dirt/layer0
	icon_state = "varadero_0"
	bleed_layer = 0

/turf/open/auto_turf/hybrisa_dirt/layer1
	icon_state = "varadero_1"
	bleed_layer = 1

// Street

/turf/open/hybrisa/street
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "cement1"

/turf/open/hybrisa/street/cement1
	icon_state = "cement1"

/turf/open/hybrisa/street/cement2
	icon_state = "cement2"

/turf/open/hybrisa/street/cement3
	icon_state = "cement3"

/turf/open/hybrisa/street/asphalt
	icon_state = "asphalt_old"

// Side-walk


/turf/open/hybrisa/street/sidewalkfull
	icon_state = "sidewalkfull"

/turf/open/hybrisa/street/sidewalkcorner
	icon_state = "sidewalkcorner"

// Side-Walk

/turf/open/hybrisa/street/sidewalk
	icon_state = "sidewalk"

/turf/open/hybrisa/street/sidewalk/south
	dir = SOUTH

/turf/open/hybrisa/street/sidewalk/north
	dir = NORTH

/turf/open/hybrisa/street/sidewalk/west
	dir = WEST

/turf/open/hybrisa/street/sidewalk/east
	dir = EAST

/turf/open/hybrisa/street/sidewalk/northeast
	dir = NORTHEAST

/turf/open/hybrisa/street/sidewalk/southwest
	dir = SOUTHWEST

/turf/open/hybrisa/street/sidewalk/northwest
	dir = NORTHWEST

/turf/open/hybrisa/street/sidewalk/southeast
	dir = SOUTHEAST


// Center

/turf/open/hybrisa/street/sidewalkcenter
	icon_state = "sidewalkcenter"

/turf/open/hybrisa/street/sidewalkcenter/south
	dir = SOUTH

/turf/open/hybrisa/street/sidewalkcenter/north
	dir = NORTH

/turf/open/hybrisa/street/sidewalkcenter/west
	dir = WEST

/turf/open/hybrisa/street/sidewalkcenter/east
	dir = EAST

//-------------------------------------//

/turf/open/hybrisa/street/roadlines
	icon_state = "asphalt_old_roadlines"
/turf/open/hybrisa/street/roadlines2
	icon_state = "asphalt_old_roadlines2"
/turf/open/hybrisa/street/roadlines3
	icon_state = "asphalt_old_roadlines3"
/turf/open/hybrisa/street/roadlines4
	icon_state = "asphalt_old_roadlines4"
/turf/open/hybrisa/street/CMB_4x4_emblem
	icon_state = "marshallsemblem_concrete_2x2"

// Unweedable

/turf/open/hybrisa/street/underground_unweedable
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "underground"
	allow_construction = FALSE

/turf/open/hybrisa/metal/underground_unweedable
	name = "floor"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "bcircuit"
	allow_construction = FALSE


/turf/open/hybrisa/street/underground_unweedable/is_weedable()
	return NOT_WEEDABLE

// Engineer Ship Hull

/turf/open/floor/hybrisa/engineership/ship_hull
	name = "strange metal wall"
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship, looks like nothing you can do will penetrate the hull."
	icon = 'icons/turf/floors/engineership.dmi'
	icon_state = "engineerwallfloor1"
	allow_construction = FALSE

/turf/open/floor/hybrisa/engineership/ship_hull/is_weedable()
	return NOT_WEEDABLE

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull
	icon_state = "outerhull_dir"

// Carpet

/turf/open/floor/hybrisa/carpet
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "carpetred"

/turf/open/floor/hybrisa/carpet/carpetfadedred
	icon_state = "carpetfadedred"
/turf/open/floor/hybrisa/carpet/carpetgreen
	icon_state = "carpetgreen"
/turf/open/floor/hybrisa/carpet/carpetbeige
	icon_state = "carpetbeige"
/turf/open/floor/hybrisa/carpet/carpetblack
	icon_state = "carpetblack"
/turf/open/floor/hybrisa/carpet/carpetred
	icon_state = "carpetred"
/turf/open/floor/hybrisa/carpet/carpetdarkerblue
	icon_state = "carpetdarkerblue"
/turf/open/floor/hybrisa/carpet/carpetorangered
	icon_state = "carpetorangered"
/turf/open/floor/hybrisa/carpet/carpetblue
	icon_state = "carpetblue"
/turf/open/floor/hybrisa/carpet/carpetpatternblue
	icon_state = "carpetpatternblue"
/turf/open/floor/hybrisa/carpet/carpetpatternbrown
	icon_state = "carpetpatternbrown"
/turf/open/floor/hybrisa/carpet/carpetreddeco
	icon_state = "carpetred_deco"
/turf/open/floor/hybrisa/carpet/carpetbluedeco
	icon_state = "carpetblue_deco"
/turf/open/floor/hybrisa/carpet/carpetblackdeco
	icon_state = "carpetblack_deco"
/turf/open/floor/hybrisa/carpet/carpetbeigedeco
	icon_state = "carpetbeige_deco"
/turf/open/floor/hybrisa/carpet/carpetgreendeco
	icon_state = "carpetgreen_deco"

// Tile

/turf/open/floor/hybrisa/tile
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "supermartfloor1"

/turf/open/floor/hybrisa/tile/supermartfloor1
	icon_state = "supermartfloor1"
/turf/open/floor/hybrisa/tile/supermartfloor2
	icon_state = "supermartfloor2"
/turf/open/floor/hybrisa/tile/cuppajoesfloor
	icon_state = "cuppafloor"
/turf/open/floor/hybrisa/tile/tilered
	icon_state = "tilered"
/turf/open/floor/hybrisa/tile/tileblue
	icon_state = "tileblue"
/turf/open/floor/hybrisa/tile/tilegreen
	icon_state = "tilegreen"
/turf/open/floor/hybrisa/tile/tileblackcheckered
	icon_state = "tileblack"
/turf/open/floor/hybrisa/tile/tilewhitecheckered
	icon_state = "tilewhitecheck"
/turf/open/floor/hybrisa/tile/tilelightbeige
	icon_state = "tilelightbeige"
/turf/open/floor/hybrisa/tile/tilebeigecheckered
	icon_state = "tilebeigecheck"
/turf/open/floor/hybrisa/tile/tilebeige
	icon_state = "tilebeige"
/turf/open/floor/hybrisa/tile/tilewhite
	icon_state = "tilewhite"
/turf/open/floor/hybrisa/tile/tilegrey
	icon_state = "tilegrey"
/turf/open/floor/hybrisa/tile/tileblack
	icon_state = "tileblack2"
/turf/open/floor/hybrisa/tile/beigetileshiny
	icon_state = "beigetileshiny"
/turf/open/floor/hybrisa/tile/blacktileshiny
	icon_state = "blacktileshiny"
/turf/open/floor/hybrisa/tile/cementflat
	icon_state = "cementflat"
/turf/open/floor/hybrisa/tile/beige_bigtile
	icon_state = "beige_bigtile"
/turf/open/floor/hybrisa/tile/yellow_bigtile
	icon_state = "yellow_bigtile"
/turf/open/floor/hybrisa/tile/darkgrey_bigtile
	icon_state = "darkgrey_bigtile"
/turf/open/floor/hybrisa/tile/darkbrown_bigtile
	icon_state = "darkbrown_bigtile"
/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile
	icon_state = "darkbrowncorner_bigtile"
/turf/open/floor/hybrisa/tile/asteroidfloor_bigtile
	icon_state = "asteroidfloor_bigtile"
/turf/open/floor/hybrisa/tile/asteroidwarning_bigtile
	icon_state = "asteroidwarning_bigtile"
/turf/open/floor/hybrisa/tile/lightbeige_bigtile
	icon_state = "lightbeige_bigtile"
/turf/open/floor/hybrisa/tile/greencorner_bigtile
	icon_state = "greencorner_bigtile"
/turf/open/floor/hybrisa/tile/greenfull_bigtile
	icon_state = "greenfull_bigtile"

// Green Tile

/turf/open/floor/hybrisa/tile/green_bigtile
	icon_state = "green_bigtile"

/turf/open/floor/hybrisa/tile/green_bigtile/south
	dir = SOUTH

/turf/open/floor/hybrisa/tile/green_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/green_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/green_bigtile/east
	dir = EAST

/turf/open/floor/hybrisa/tile/green_bigtile/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/tile/green_bigtile/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/tile/green_bigtile/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/tile/green_bigtile/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/tile/greencorner_bigtile
	icon_state = "greencorner_bigtile"

/turf/open/floor/hybrisa/tile/greencorner_bigtile/south
	dir = SOUTH

/turf/open/floor/hybrisa/tile/greencorner_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/greencorner_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/greencorner_bigtile/east
	dir = EAST

// Wood

/turf/open/floor/hybrisa/wood
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "darkerwood"

/turf/open/floor/hybrisa/wood/greywood
	icon_state = "greywood"
/turf/open/floor/hybrisa/wood/blackwood
	icon_state = "blackwood"
/turf/open/floor/hybrisa/wood/darkerwood
	icon_state = "darkerwood"
/turf/open/floor/hybrisa/wood/redwood
	icon_state = "redwood"

// Metal

/turf/open/floor/hybrisa/metal
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "bluemetal1"

/turf/open/floor/hybrisa/metal/bluemetal1
	icon_state = "bluemetal1"
/turf/open/floor/hybrisa/metal/bluemetalfull
	icon_state = "bluemetalfull"
/turf/open/floor/hybrisa/metal/bluemetalcorner
	icon_state = "bluemetalcorner"
/turf/open/floor/hybrisa/metal/orangelinecorner
	icon_state = "orangelinecorner"
/turf/open/floor/hybrisa/metal/orangeline
	icon_state = "orangeline"
/turf/open/floor/hybrisa/metal/darkblackmetal1
	icon_state = "darkblackmetal1"
/turf/open/floor/hybrisa/metal/darkblackmetal2
	icon_state = "darkblackmetal2"
/turf/open/floor/hybrisa/metal/darkredfull2
	icon_state = "darkredfull2"
/turf/open/floor/hybrisa/metal/redcorner
	icon_state = "zredcorner"
/turf/open/floor/hybrisa/metal/grated
	icon_state = "rampsmaller"
/turf/open/floor/hybrisa/metal/stripe_red
	icon_state = "stripe_red"
/turf/open/floor/hybrisa/metal/zbrownfloor1
	icon_state = "zbrownfloor1"
/turf/open/floor/hybrisa/metal/zbrownfloor_corner
	icon_state = "zbrownfloorcorner1"
/turf/open/floor/hybrisa/metal/zbrownfloor_full
	icon_state = "zbrownfloorfull1"
/turf/open/floor/hybrisa/metal/greenmetal1
	icon_state = "greenmetal1"
/turf/open/floor/hybrisa/metal/greenmetalfull
	icon_state = "greenmetalfull"
/turf/open/floor/hybrisa/metal/greenmetalcorner
	icon_state = "greenmetalcorner"
/turf/open/floor/hybrisa/metal/metalwhitefull
	icon_state = "metalwhitefull"

// Misc

/turf/open/floor/hybrisa/misc
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "marshallsemblem"

/turf/open/floor/hybrisa/misc/marshallsemblem
	icon_state = "marshallsemblem"
/turf/open/floor/hybrisa/misc/wybiglogo
	name = "Weyland-Yutani corp. - bulding better worlds."
	icon_state = "big8x8wylogo"
/turf/open/floor/hybrisa/misc/wysmallleft
	icon_state = "weylandyutanismall1"
/turf/open/floor/hybrisa/misc/wysmallright
	icon_state = "weylandyutanismall2"
/turf/open/floor/hybrisa/misc/spaceport1
	icon_state = "spaceport1"
/turf/open/floor/hybrisa/misc/spaceport2
	icon_state = "spaceport2"

// Dropship

/turf/open/hybrisa/dropship
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "dropshipfloor1"

/turf/open/hybrisa/dropship/dropship1
	icon_state = "dropshipfloor1"
/turf/open/hybrisa/dropship/dropship2
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/dropship3
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/dropship3
	icon_state = "dropshipfloor3"
/turf/open/hybrisa/dropship/dropship4
	icon_state = "dropshipfloor4"
/turf/open/hybrisa/dropship/dropshipfloorcorner1
	icon_state = "dropshipfloorcorner1"
/turf/open/hybrisa/dropship/dropshipfloorcorner2
	icon_state = "dropshipfloorcorner2"
/turf/open/hybrisa/dropship/dropshipfloorfull
	icon_state = "dropshipfloorfull"

// Engineer tiles

/turf/open/floor/hybrisa/engineership
	name = "floor"
	desc = "A strange metal floor, unlike any metal you've seen before."
	icon = 'icons/turf/floors/engineership.dmi'
	icon_state = "hybrisa"
	plating_type = /turf/open/floor/plating/engineer_ship

/turf/open/floor/hybrisa/engineership/engineer_floor1
	icon_state = "engineer_metalfloor_3"
/turf/open/floor/hybrisa/engineership/engineer_floor2
	icon_state = "engineer_floor_4"
/turf/open/floor/hybrisa/engineership/engineer_floor3
	icon_state = "engineer_metalfloor_2"
/turf/open/floor/hybrisa/engineership/engineer_floor4
	icon_state = "engineer_metalfloor_1"
/turf/open/floor/hybrisa/engineership/engineer_floor5
	icon_state = "engineerlight"
/turf/open/floor/hybrisa/engineership/engineer_floor6
	icon_state = "engineer_floor_2"
/turf/open/floor/hybrisa/engineership/engineer_floor7
	icon_state = "engineer_floor_1"
/turf/open/floor/hybrisa/engineership/engineer_floor8
	icon_state = "engineer_floor_5"
/turf/open/floor/hybrisa/engineership/engineer_floor9
	icon_state = "engineer_metalfloor_4"
/turf/open/floor/hybrisa/engineership/engineer_floor10
	icon_state = "engineer_floor_corner1"
/turf/open/floor/hybrisa/engineership/engineer_floor11
	icon_state = "engineer_floor_corner2"
/turf/open/floor/hybrisa/engineership/engineer_floor12
	icon_state = "engineerwallfloor1"
/turf/open/floor/hybrisa/engineership/engineer_floor13
	icon_state = "outerhull_dir"
/turf/open/floor/hybrisa/engineership/engineer_floor14
	icon_state = "engineer_floor_corner3"

// Pillars

/turf/open/floor/hybrisa/engineership/pillars
	name = "strange metal pillar"
	desc = "A strange metal pillar, unlike any metal you've seen before."
	icon_state = "eng_pillar1"

/turf/open/floor/hybrisa/engineership/pillars/north/pillar1
	icon_state = "eng_pillar1"
/turf/open/floor/hybrisa/engineership/pillars/north/pillar2
	icon_state = "eng_pillar2"
/turf/open/floor/hybrisa/engineership/pillars/north/pillar3
	icon_state = "eng_pillar3"
/turf/open/floor/hybrisa/engineership/pillars/north/pillar4
	icon_state = "eng_pillar4"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth1
	icon_state = "eng_pillarsouth1"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth2
	icon_state = "eng_pillarsouth2"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth3
	icon_state = "eng_pillarsouth3"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth4
	icon_state = "eng_pillarsouth4"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest1
	icon_state = "eng_pillarwest1"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest2
	icon_state = "eng_pillarwest2"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest3
	icon_state = "eng_pillarwest3"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest4
	icon_state = "eng_pillarwest4"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast1
	icon_state = "eng_pillareast1"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast2
	icon_state = "eng_pillareast2"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast3
	icon_state = "eng_pillareast3"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast4
	icon_state = "eng_pillareast4"

// -------------------- // Hybrisa Wall types // ---------------- //

// Derelict Ship

/turf/closed/wall/engineership
	name = "strange metal wall"
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship, looks like nothing you can do will penetrate the hull."
	icon = 'icons/turf/walls/engineership.dmi'
	icon_state = "metal"
	walltype = WALL_HUNTERSHIP
	hull = TRUE

/turf/closed/wall/engineership/destructible
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship, with enough force they could break."
	hull = FALSE
	damage_cap = HEALTH_WALL_ULTRA_REINFORCED
	baseturfs = /turf/open/floor/plating/engineer_ship

// Rock

/turf/closed/wall/hybrisa/rock
	name = "rock wall"
	desc = "Massive columns comprised of anicent sedimentary rocks loom before you."
	icon = 'icons/turf/walls/kutjevorockdark.dmi'
	icon_state = "rock"
	walltype = WALL_KUTJEVO_ROCK
	hull = TRUE

// Marshalls

/turf/closed/wall/hybrisa/marhsalls
	name = "metal wall"
	icon = 'icons/turf/walls/hybrisa_marshalls.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

/turf/closed/wall/hybrisa/marhsalls/reinforced
	name = "reinforced metal wall"
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/hybrisa/marhsalls/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	hull = TRUE

// Research

/turf/closed/wall/hybrisa/research/ribbed //this guy is our reinforced replacement
	name = "ribbed facility walls"
	icon = 'icons/turf/walls/hybrisaresearchbrownwall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/research
	name = "bare facility walls"
	icon = 'icons/turf/walls/hybrisaresearchbrownwall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/research/reinforced
	name = "ribbed facility walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/research/reinforced/hull
	hull = TRUE
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."

// Colony Walls

/turf/closed/wall/hybrisa/colony/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/reinforced/hull
	hull = TRUE
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."

// Hospital

/turf/closed/wall/hybrisa/colony/hospital/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall_hospital.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/hospital
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall_hospital.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/hospital/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/hospital/reinforced/hull
	hull = TRUE
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."

// Offices

/turf/closed/wall/hybrisa/colony/office/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_offices_colonywall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/office
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_offices_colonywall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/office/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/office/reinforced/hull
	hull = TRUE
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."

// Engineering

/turf/closed/wall/hybrisa/colony/engineering/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_engineering_wall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/engineering
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_engineering_wall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/engineering/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/engineering/reinforced/hull
	hull = TRUE
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."

// Space-Port

/turf/closed/wall/hybrisa/spaceport
	name = "metal wall"
	icon = 'icons/turf/walls/hybrisa_spaceport_walls.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

/turf/closed/wall/hybrisa/spaceport/reinforced
	name = "reinforced metal wall"
	icon = 'icons/turf/walls/hybrisa_spaceport_walls.dmi'
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/hybrisa/spaceport/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon = 'icons/turf/walls/hybrisa_spaceport_walls.dmi'
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	hull = TRUE
