

//-----USS Almayer Walls ---//

/turf/closed/wall/almayer
	name = "hull"
	desc = "A metal wall used to separate rooms and make up the ship."
	icon = 'icons/turf/walls/almayer.dmi'
	icon_state = "testwall"
	walltype = WALL_HULL

	damage = 0
	damage_cap = HEALTH_WALL //Wall will break down to girders if damage reaches this point

	opacity = TRUE
	density = TRUE

	tiles_with = list(
		/turf/closed/wall,
		/obj/structure/window/framed,
		/obj/structure/window_frame,
		/obj/structure/girder,
		/obj/structure/machinery/door,
		/obj/structure/machinery/cm_vending/sorted/attachments/blend,
		/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend,
		/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend,
	)

	/// The type of wall decoration we use, to avoid the wall changing icon all the time
	var/decoration_type

/turf/closed/wall/almayer/Initialize(mapload, ...)
	if(!special_icon && prob(20))
		decoration_type = rand(0,3)
	return ..()

/turf/closed/wall/almayer/update_icon()
	if(decoration_type == null)
		return ..()
	if(neighbors_list in list(EAST|WEST))
		special_icon = TRUE
		icon_state = "almayer_deco_wall[decoration_type]"
	else // Wall connection was broken, return to normality
		special_icon = FALSE
	return ..()

/turf/closed/wall/almayer/take_damage(dam, mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "The fingerprint contains specks of metal and dirt.")

	..()

/turf/closed/wall/almayer/reinforced
	name = "reinforced hull"
	desc = "A reinforced metal wall used to separate rooms and make up the ship."
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/// Acts like /turf/closed/wall/almayer/outer until post-hijack where it reverts to /turf/closed/wall/almayer/reinforced.
/turf/closed/wall/almayer/reinforced/temphull
	name = "heavy reinforced hull"
	desc = "A highly reinforced metal wall used to separate rooms and make up the ship. It would take a great impact to weaken this wall."
	icon_state = "temphull"
	damage_cap = HEALTH_WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/almayer/reinforced/temphull/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(de_hull))

/turf/closed/wall/almayer/reinforced/temphull/proc/de_hull()
	SIGNAL_HANDLER
	turf_flags = NO_FLAGS
	desc = "A highly reinforced metal wall used to separate rooms and make up the ship. It has been weakened by a great impact."

/turf/closed/wall/almayer/outer
	name = "outer hull"
	desc = "A metal wall used to separate space from the ship"
	icon_state = "hull" //Codersprite to make it more obvious in the map maker what's a hull wall and what's not
	//icon_state = "testwall0_debug" //Uncomment to check hull in the map editor.
	walltype = WALL_HULL
	turf_flags = TURF_HULL //Impossible to destroy or even damage. Used for outer walls that would breach into space, potentially some special walls

/turf/closed/wall/almayer/no_door_tile
	tiles_with = list(/turf/closed/wall,/obj/structure/window/framed,/obj/structure/window_frame,/obj/structure/girder)

/turf/closed/wall/almayer/outer/take_damage(dam, mob/M)
	return

/turf/closed/wall/almayer/white
	walltype = WALL_WHITE
	icon = 'icons/turf/walls/almayer_white.dmi'
	icon_state = "wwall"

/turf/closed/wall/almayer/white/reinforced
	name = "reinforced hull"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/turf/closed/wall/almayer/white/outer_tile
	tiles_with = list(/turf/closed/wall/almayer/white,/turf/closed/wall/almayer/outer)

/turf/closed/wall/almayer/white/hull
	name = "ultra reinforced hull"
	desc = "An extremely reinforced metal wall used to isolate potentially dangerous areas"
	icon_state = "hull"
	turf_flags = TURF_HULL

/turf/closed/wall/almayer/research/can_be_dissolved()
	return 0

/turf/closed/wall/almayer/research/containment/wall
	name = "cell wall"
	icon = 'icons/turf/almayer.dmi'
	icon_state = null
	tiles_with = null
	walltype = null
	special_icon = TRUE

/turf/closed/wall/almayer/research/containment/wall/ex_act(severity, explosion_direction)
	if(severity <= EXPLOSION_THRESHOLD_MEDIUM) // Wall is resistant to explosives (and also crusher charge)
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/take_damage(dam, mob/M)
	if(isxeno(M))
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/attackby(obj/item/W, mob/user)
	if(isxeno(user))
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/attack_alien(mob/living/carbon/xenomorph/user)
	return

/turf/closed/wall/almayer/research/containment/wall/corner
	icon_state = "containment_wall_corner"

/turf/closed/wall/almayer/research/containment/wall/divide
	icon_state = "containment_wall_divide"
	var/operating = FALSE

/turf/closed/wall/almayer/research/containment/wall/divide/proc/open()
	if(operating)
		return
	operating = TRUE
	flick("containment_wall_divide_lowering", src)
	icon_state = "containment_wall_divide_lowered"
	set_opacity(0)
	density = FALSE
	operating = FALSE
	change_weeds()

/turf/closed/wall/almayer/research/containment/wall/divide/proc/close()
	if(operating)
		return
	operating = TRUE
	flick("containment_wall_divide_rising", src)
	icon_state = "containment_wall_divide"
	set_opacity(1)
	density = TRUE
	operating = FALSE

	change_weeds()

/turf/closed/wall/almayer/research/containment/wall/divide/proc/change_weeds()
	for(var/obj/effect/alien/W in src) // Destroy all alien things on the divider (traps, special structures, etc)
		playsound(src, "alien_resin_break", 25)
		qdel(W)


/turf/closed/wall/almayer/research/containment/wall/south
	icon_state = "containment_wall_south"

/turf/closed/wall/almayer/research/containment/wall/west
	icon_state = "containment_wall_w"

/turf/closed/wall/almayer/research/containment/wall/connect_e
	icon_state = "containment_wall_connect_e"

/turf/closed/wall/almayer/research/containment/wall/connect3
	icon_state = "containment_wall_connect3"

/turf/closed/wall/almayer/research/containment/wall/connect_w
	icon_state = "containment_wall_connect_w"

/turf/closed/wall/almayer/research/containment/wall/connect_w2
	icon_state = "containment_wall_connect_w2"

/turf/closed/wall/almayer/research/containment/wall/east
	icon_state = "containment_wall_e"

/turf/closed/wall/almayer/research/containment/wall/north
	icon_state = "containment_wall_n"

/turf/closed/wall/almayer/research/containment/wall/connect_e2
	name = "\improper cell wall."
	icon_state = "containment_wall_connect_e2"

/turf/closed/wall/almayer/research/containment/wall/connect_s1
	icon_state = "containment_wall_connect_s1"

/turf/closed/wall/almayer/research/containment/wall/connect_s2
	icon_state = "containment_wall_connect_s2"

/turf/closed/wall/almayer/research/containment/wall/purple
	name = "cell window"
	icon_state = "containment_window"
	opacity = FALSE

//AI Core

/turf/closed/wall/almayer/aicore
	walltype = WALL_AICORE
	icon = 'icons/turf/walls/almayer_aicore.dmi'
	icon_state = "aiwall"

/turf/closed/wall/almayer/aicore/reinforced
	name = "reinforced hull"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/turf/closed/wall/almayer/aicore/hull
	name = "ultra reinforced hull"
	desc = "An extremely reinforced metal wall used to isolate potentially dangerous areas"
	icon_state = "hull"
	turf_flags = TURF_HULL

/turf/closed/wall/almayer/aicore/white
	walltype = WALL_AICORE
	icon = 'icons/turf/walls/almayer_aicore_white.dmi'
	icon_state = "aiwall"

/turf/closed/wall/almayer/aicore/white/reinforced
	name = "reinforced hull"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/turf/closed/wall/almayer/aicore/white/hull
	name = "ultra reinforced hull"
	desc = "An extremely reinforced metal wall used to isolate potentially dangerous areas"
	icon_state = "hull"
	turf_flags = TURF_HULL


//Sulaco walls.
/turf/closed/wall/sulaco
	name = "spaceship hull"
	desc = "A metal wall used to separate rooms on spaceships from the cold void of space."
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "sulaco"
	turf_flags = NO_FLAGS  //Can't be deconstructed

	damage_cap = HEALTH_WALL
	walltype = WALL_SULACO //Changes all the sprites and icons.

/turf/closed/wall/sulaco/hull
	name = "outer hull"
	desc = "A reinforced outer hull, probably to prevent breaches"
	walltype = WALL_SULACO
	turf_flags = TURF_HULL


/turf/closed/wall/sulaco/unmeltable
	name = "outer hull"
	desc = "A reinforced outer hull, probably to prevent breaches"
	walltype = WALL_SULACO
	turf_flags = TURF_HULL




/turf/closed/wall/indestructible
	name = "wall"
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	turf_flags = TURF_HULL



/turf/closed/wall/indestructible/bulkhead
	name = "bulkhead"
	desc = "It is a large metal bulkhead."
	icon_state = "hull"

/turf/closed/wall/indestructible/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = FALSE

/turf/closed/wall/indestructible/other
	icon_state = "r_wall"

/turf/closed/wall/indestructible/invisible
	icon_state = "invisible"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT




// Mineral Walls

/turf/closed/wall/mineral
	name = "mineral wall"
	desc = "This shouldn't exist"
	icon = 'icons/turf/walls/stone.dmi'
	icon_state = "stone"
	walltype = WALL_STONE
	var/mineral
	var/last_event = 0
	var/active = null
	tiles_with = list(/turf/closed/wall/mineral)

/turf/closed/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "gold0"
	walltype = WALL_GOLD
	mineral = "gold"
	//var/electro = 1
	//var/shocked = null

/turf/closed/wall/mineral/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	mineral = "silver"
	color = "#e5e5e5"
	//var/electro = 0.75
	//var/shocked = null

/turf/closed/wall/mineral/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	mineral = "diamond"
	color = "#3d9191"

/turf/closed/wall/mineral/diamond/thermitemelt(mob/user)
	return


/turf/closed/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	mineral = "sandstone"
	color = "#c6a480"
	baseturfs = /turf/open/gm/dirt

/turf/closed/wall/mineral/sandstone/runed
	name = "sandstone temple wall"
	desc = "A heavy wall of sandstone."
	mineral = "runed sandstone"
	color = "#b29082"
	damage_cap = HEALTH_WALL_REINFORCED//Strong, but only available to Hunters, can can still be blown up or melted by boilers.
	baseturfs = /turf/open/floor/sandstone/runed

/turf/closed/wall/mineral/sandstone/runed/attack_alien(mob/living/carbon/xenomorph/user)
	visible_message("[user] scrapes uselessly against [src] with their claws.")
	return

/turf/closed/wall/mineral/sandstone/runed/decor
	name = "runed sandstone temple wall"
	desc = "A heavy wall of sandstone, with elegant carvings and runes inscribed upon its face."
	icon = 'icons/turf/walls/runedstone.dmi'
	icon_state = "runedstone"
	walltype = "runedstone"

/turf/closed/wall/mineral/sandstone/runed/can_be_dissolved()
	return 2

/turf/closed/wall/mineral/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	mineral = "uranium"
	color = "#1b4506"

/turf/closed/wall/mineral/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/L in range(3,src))
				L.apply_effect(12,IRRADIATE,0)
			for(var/turf/closed/wall/mineral/uranium/T in range(3,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return

/turf/closed/wall/mineral/uranium/leaking
	name = "broken uranium wall"
	damage = 666
	desc = "A uranium plated wall that's leaking something. Just looking at it makes you dizzy."
	color = "#660202"

/turf/closed/wall/mineral/uranium/attack_hand(mob/user as mob)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/attackby(obj/item/W as obj, mob/user as mob)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/Collided(atom/movable/AM)
	radiate()
	..()

/turf/closed/wall/mineral/phoron
	name = "phoron wall"
	desc = "A wall with phoron plating. This is definitely a bad idea."
	mineral = "phoron"
	color = "#9635aa"


//BONE RESIN WALLS

/turf/closed/wall/mineral/bone_resin //mineral wall because, reasons bro.
	name = "skeletal resin"
	desc = "A wall made of molted old resin. This place is more alive than you are."
	icon = 'icons/turf/walls/prison/bone_resin.dmi'
	icon_state = "bone_resin"
	walltype = WALL_BONE_RESIN
	turf_flags = TURF_HULL

/turf/closed/wall/mineral/bone/is_weedable()
	return NOT_WEEDABLE

//Misc walls

/turf/closed/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon = 'icons/turf/walls/cult.dmi'
	icon_state = "cult"
	walltype = WALL_CULT
	color = "#3c3434"

/turf/closed/wall/cult/hunting_grounds
	name = "wall"
	turf_flags = TURF_HULL

/turf/closed/wall/cult/make_girder(destroyed_girder)
	return

/turf/closed/wall/vault
	icon_state = "rockvault"


//Hangar walls
/turf/closed/wall/hangar
	name = "hangar wall"
	icon = 'icons/turf/walls/hangar.dmi'
	icon_state = "hangar"
	walltype = WALL_HANGAR

//Prison wall

/turf/closed/wall/prison
	name = "metal wall"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

//Biodome wall

/turf/closed/wall/biodome
	name = "metal wall"
	icon = 'icons/turf/walls/corsat.dmi'
	icon_state = "dome"
	walltype = WALL_DOME

//Wood wall

/turf/closed/wall/wood
	name = "wood wall"
	icon = 'icons/turf/walls/wood.dmi'
	icon_state = "wood"
	walltype = WALL_WOOD
	baseturfs = /turf/open/floor/wood

/turf/closed/wall/wood/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_list in list(EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		if(r1 >= 9)
			overlays += image(icon, icon_state = "wood_variant")

//Colorable rocks. Looks like moonsand.

/turf/closed/wall/rock
	name = "rock wall"
	desc = "A rough wall of hardened rock."
	icon = 'icons/turf/walls/cave.dmi'
	icon_state = "cavewall"
	color = "#535963"
	walltype = WALL_CAVE
	turf_flags = TURF_HULL

/turf/closed/wall/rock/brown
	color = "#826161"

/turf/closed/wall/rock/orange
	color = "#994a16"
	desc = "A rough wall of granite and sandstone."

/turf/closed/wall/rock/red
	color = "#822d21"

/turf/closed/wall/rock/ice
	name = "dense ice wall"
	color = "#4b94b3"

/turf/closed/wall/rock/ice/thin
	alpha = 166

//Strata New Blendy Ice

/turf/closed/wall/strata_ice
	name = "ice columns"
	icon = 'icons/turf/walls/strata_ice.dmi'
	icon_state = "strata_ice"
	desc = "An absolutely massive collection of columns made of ice. The longer you stare, the deeper the ice seems to go."
	walltype = WALL_STRATA_ICE //Not a metal wall
	turf_flags = TURF_HULL //Can't break this ice.

/turf/closed/wall/strata_ice/dirty
	icon_state = "strata_ice_dirty"
	desc = "Columns and crags stacked atop one another. They defiantly push towards the heavens, but are stopped short by dripping frigid excess."
	walltype = WALL_STRATA_ICE_DIRTY

/turf/closed/wall/strata_ice/jungle
	name = "jungle vegetation"
	icon = 'icons/turf/walls/jungle_veg.dmi'
	icon_state = "jungle_veg"
	desc = "Exceptionally dense vegetation that you can't see through."
	walltype = WALL_JUNGLE_UPDATED //Not a metal wall
	turf_flags = TURF_HULL

/turf/closed/wall/strata_outpost_ribbed //this guy is our reinforced replacement
	name = "ribbed outpost walls"
	icon = 'icons/turf/walls/strata_outpost.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/strata_outpost
	name = "bare outpost walls"
	icon = 'icons/turf/walls/strata_outpost.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/strata_outpost/reinforced
	name = "ribbed outpost walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/strata_outpost/reinforced/hull
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	icon_state = "strata_hull"
	turf_flags = TURF_HULL

//SOLARIS RIDGE TILESET//

/turf/closed/wall/solaris
	name = "colony wall"
	icon = 'icons/turf/walls/solaris/solaris.dmi'
	icon_state = "solaris_interior"
	desc = "Tough looking walls that have been blasted by sand since the day they were erected. A testament to human willpower."
	walltype = WALL_SOLARIS

/turf/closed/wall/solaris/reinforced
	name = "reinforced colony wall"
	icon_state = "solaris_interior_r"
	walltype = WALL_SOLARISR
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/solaris/reinforced/hull
	name = "heavy reinforced colony wall"
	icon_state = "solaris_interior_h"
	turf_flags = TURF_HULL

/turf/closed/wall/solaris/reinforced/hull/lv522
	name = "Colony Windbreaker"

/turf/closed/wall/solaris/rock
	name = "rock wall"
	icon_state = "solaris_rock"
	walltype = WALL_SOLARIS_ROCK
	turf_flags = TURF_HULL
	baseturfs = /turf/open/mars_cave/mars_cave_2



//GREYBOX DEVELOPMENT WALLS

/turf/closed/wall/dev
	name = "greybox wall"
	icon = 'icons/turf/walls/dev/dev.dmi'
	icon_state = "devwall"
	desc = "Just like in the orange box!"
	walltype = WALL_DEVWALL

/turf/closed/wall/dev/reinforced
	name = "greybox reinforced wall"
	icon_state = "devwall_r"
	desc = "Just like in the orange box! This one is reinforced"
	walltype = WALL_DEVWALL_R
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/dev/reinforced/hull
	name = "greybox hull wall"
	desc = "Just like in the orange box! This one is indestructible."
	turf_flags = TURF_HULL

//KUTJEVO DESERT WALLS / SHARED TRIJENT TILESET

/turf/closed/wall/kutjevo/rock
	name = "rock wall"
	desc = "Tall sandy rocks. Imposing. Impressive. Attention grabbing."
	icon = 'icons/turf/walls/kutjevo/kutjevo.dmi'
	icon_state = "rock"
	walltype = WALL_KUTJEVO_ROCK
	turf_flags = TURF_HULL

/turf/closed/wall/kutjevo/rock/border
	icon_state = "rock_border"//no sandy edges
	walltype = WALL_KUTJEVO_ROCK_BORDER

/turf/closed/wall/kutjevo/colony
	name = "colony wall"
	icon = 'icons/turf/walls/kutjevo/kutjevo.dmi'
	icon_state = "colony"
	desc = "Dusty worn down walls that were once built to last."
	walltype = WALL_KUTJEVO_COLONY

/turf/closed/wall/kutjevo/colony/reinforced
	name = "reinforced colony wall"
	icon_state = "colonyr"
	desc = "Dusty worn down walls that were once built to last. This one is reinforced"
	walltype = WALL_KUTJEVO_COLONYR
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/kutjevo/colony/reinforced/hull
	icon_state = "colonyh"
	name = "reinforced colony wall"
	desc = "Dusty worn down walls that were once built to last. This one is indestructible."
	turf_flags = TURF_HULL

//ICE COLONY, AKA SHIVA'S SNOWBALL TOBLERONE WALLS
/turf/closed/wall/shiva
	icon = 'icons/turf/walls/ice_colony/shiva_turfs.dmi'
	walltype = WALL_SHIVA_ICE

/turf/closed/wall/shiva/ice
	name = "black ice slabs"
	icon_state = "shiva_ice"
	desc = "Slabs on slabs of dirty black ice crusted over ancient rock formations. The permafrost fluctuates between 20in and 12in during the summer months."
	walltype = WALL_SHIVA_ICE //Not a metal wall
	turf_flags = TURF_HULL //Can't break this ice.

/turf/closed/wall/shiva/prefabricated
	name = "prefabricated structure wall"
	icon_state = "shiva_fab"
	desc = "This structure is made of metal support rods and robust poly-kevlon plastics. A derivative of the stuff used in UA ballistics vests, USCM and UPP uniforms. These walls are pulled taught and have been reinforced into a more permanent structure."
	walltype = WALL_SHIVA_FAB
	damage_cap = HEALTH_WALL

/turf/closed/wall/shiva/prefabricated/reinforced
	name = "reinforced prefabricated structure wall"
	icon_state = "shiva_fab_r"
	desc = "This structure is made of metal support rods. The poly-kevlon has been replaced with sheet metal, reinforcing it."
	walltype = WALL_SHIVA_FAB_R
	damage_cap = HEALTH_WALL + HEALTH_WALL_XENO_THICK

/turf/closed/wall/shiva/prefabricated/reinforced/hull
	name = "reinforced prefabricated structure wall"
	icon_state = "shiva_fab_r_h"
	desc = "It cannot be destroyed by any means you have available. Perhaps praying to the gods may help."
	walltype = WALL_SHIVA_FAB_R
	turf_flags = TURF_HULL

/turf/closed/wall/shiva/prefabricated/orange
	icon_state = "shiva_fab_oj"
	walltype = WALL_SHIVA_FAB_ORANGE

/turf/closed/wall/shiva/prefabricated/blue
	icon_state = "shiva_fab_blu"
	walltype = WALL_SHIVA_FAB_BLUE

/turf/closed/wall/shiva/prefabricated/pink
	icon_state = "shiva_fab_pnk"
	walltype = WALL_SHIVA_FAB_PINK

/turf/closed/wall/shiva/prefabricated/white
	icon_state = "shiva_fab_wht"
	walltype = WALL_SHIVA_FAB_WHITE

/turf/closed/wall/shiva/prefabricated/red
	icon_state = "shiva_fab_red"
	walltype = WALL_SHIVA_FAB_RED


//Xenomorph's Resin Walls

/turf/closed/wall/resin
	name = "resin wall"
	desc = "Weird slime solidified into a wall."
	icon = 'icons/mob/xenos/structures.dmi'
	icon_state = "resin"
	walltype = WALL_RESIN
	damage_cap = HEALTH_WALL_XENO
	layer = RESIN_STRUCTURE_LAYER
	blend_turfs = list(/turf/closed/wall/resin)
	blend_objects = list(/obj/structure/mineral_door/resin)
	repair_materials = list()
	var/hivenumber = XENO_HIVE_NORMAL
	var/should_track_build = FALSE
	var/datum/cause_data/construction_data
	turf_flags = TURF_ORGANIC

/turf/closed/wall/resin/Initialize(mapload)
	. = ..()

	for(var/obj/effect/alien/weeds/node/weed_node in contents)
		qdel(weed_node)

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	if(!(turf_flags & TURF_HULL))
		var/area/area = get_area(src)
		if(area)
			if(area.linked_lz)
				AddComponent(/datum/component/resin_cleanup)
			area.current_resin_count++

/turf/closed/wall/resin/Destroy(force)
	. = ..()

	if(!(turf_flags & TURF_HULL))
		var/area/area = get_area(src)
		area?.current_resin_count--

/turf/closed/wall/resin/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/turf/closed/wall/resin/pillar
	name = "resin pillar segment"
	turf_flags = TURF_HULL

/turf/closed/wall/resin/proc/set_resin_builder(mob/M)
	if(istype(M) && should_track_build)
		construction_data = create_cause_data(initial(name), M)

/turf/closed/wall/resin/make_girder()
	return

/turf/closed/wall/resin/flamer_fire_act(dam = BURN_LEVEL_TIER_1)
	take_damage(dam)

//this one is only for map use
/turf/closed/wall/resin/ondirt
	baseturfs = /turf/open/gm/dirt
//strata specifics
/turf/closed/wall/resin/strata/on_tiles
	baseturfs = /turf/open/floor/strata

/turf/closed/wall/resin/thick
	name = "thick resin wall"
	desc = "Weird slime solidified into a thick wall."
	damage_cap = HEALTH_WALL_XENO_THICK
	icon_state = "thickresin"
	walltype = WALL_THICKRESIN

/turf/closed/wall/resin/tutorial
	name = "tutorial resin wall"
	desc = "Weird slime solidified into a wall. Remarkably resilient."
	hivenumber = XENO_HIVE_TUTORIAL

/turf/closed/wall/resin/tutorial/attack_alien(mob/living/carbon/xenomorph/xeno)
	return

/turf/closed/wall/resin/membrane
	name = "resin membrane"
	desc = "Weird slime translucent enough to let light pass through."
	icon_state = "membrane"
	walltype = WALL_MEMBRANE
	damage_cap = HEALTH_WALL_XENO_MEMBRANE
	opacity = FALSE
	alpha = 180

/turf/closed/wall/resin/membrane/can_bombard(mob/living/carbon/xenomorph/X)
	if(!istype(X))
		return FALSE

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	return hive.is_ally(X)

/turf/closed/wall/resin/membrane/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_GLASS

/datum/movable_wall_group
	var/list/obj/structure/alien/movable_wall/walls

	var/push_delay = 4
	var/next_push = 0
	var/is_moving = FALSE

/datum/movable_wall_group/New(list/datum/movable_wall_group/merge)
	. = ..()
	for(var/i in merge)
		var/datum/movable_wall_group/MWG = i
		for(var/wall in MWG.walls)
			add_structure(wall)

/datum/movable_wall_group/proc/add_structure(obj/structure/alien/movable_wall/MW)
	if(MW.group)
		MW.group.remove_structure(MW, TRUE)
	LAZYOR(walls, MW)
	MW.group = src
	MW.update_connections(TRUE)
	MW.update_icon()

/datum/movable_wall_group/Destroy(force)
	QDEL_NULL_LIST(walls)
	return ..()

/datum/movable_wall_group/proc/remove_structure(obj/structure/alien/movable_wall/MW, merge)
	LAZYREMOVE(walls, MW)
	MW.group = null
	if(!walls)
		qdel(src)
	else if(!merge)
		var/obj/structure/alien/movable_wall/current
		var/obj/structure/alien/movable_wall/connected
		var/list/current_walls = walls.Copy()
		for(var/i in current_walls)
			current = i
			if(!current.group || current.group == src)
				var/datum/movable_wall_group/MWG = new()
				MWG.add_structure(current)

			for(var/dir in GLOB.cardinals)
				connected = locate() in get_step(current, dir)
				if(connected in current_walls)
					if(connected.group == src)
						current.group.add_structure(connected)
					else if(connected.group != current.group)
						new /datum/movable_wall_group(list(current.group, connected.group))

		if(!QDELETED(src))
			qdel(src)


/datum/movable_wall_group/proc/try_move_in_direction(dir, list/forget)
	var/turf/T
	var/obj/structure/alien/movable_wall/MW
	var/failed = FALSE
	var/on_weeds = FALSE

	if(is_moving)
		return FALSE

	is_moving = TRUE
	for(var/i in walls)
		MW = i
		T = get_step(MW, dir)

		if(T.weeds)
			on_weeds = TRUE

		if(LinkBlocked(MW, MW.loc, T, forget=forget))
			failed = TRUE

		for(var/a in T)
			var/atom/movable/A = a

			if(A.loc != T)
				continue

			if(MW.pulledby == A)
				var/mob/M = A
				M.stop_pulling()

			if((A in forget) || A.anchored)
				continue

			if(ismob(A))
				var/mob/M = A
				if(M.stat == DEAD)
					continue

				var/result = M.Move(get_step(T, dir), dir)
				if(A.density && !result)
					failed = TRUE
			else if(A.density && !A.Move(get_step(T, dir), dir))
				failed = TRUE

	is_moving = FALSE

	if(failed || !on_weeds)
		return FALSE

	for(var/i in walls)
		MW = i
		T = get_step(MW, dir)
		MW.forceMove(T)
	next_push = world.time + push_delay

	return TRUE


// Not a turf because it is movable, but still very much an obstacle/wall.
/obj/structure/alien/movable_wall
	name = "shifting resin wall"
	desc = "A resin wall that can shift about."
	icon = 'icons/turf/walls/xeno.dmi'
	health = HEALTH_WALL_XENO
	icon_state = "resin"
	var/wall_type = "resin"

	flags_obj = OBJ_ORGANIC

	var/max_walls = 7
	var/datum/movable_wall_group/group

	density = TRUE
	anchored = TRUE
	opacity = TRUE

	var/turf/tied_turf
	var/list/wall_connections = list("0", "0", "0", "0")
	drag_delay = 4


	var/hivenumber = XENO_HIVE_NORMAL

/obj/structure/alien/movable_wall/Initialize(mapload, hive)
	. = ..()
	if(hive)
		hivenumber = hive
		set_hive_data(src, hive)
	recalculate_structure()
	update_tied_turf(loc)
	RegisterSignal(src, COMSIG_ATOM_TURF_CHANGE, PROC_REF(update_tied_turf))
	RegisterSignal(src, COMSIG_MOVABLE_XENO_START_PULLING, PROC_REF(allow_xeno_drag))
	RegisterSignal(src, COMSIG_MOVABLE_PULLED, PROC_REF(continue_allowing_drag))

/obj/structure/alien/movable_wall/ex_act(severity, direction)
	take_damage(severity)

/obj/structure/alien/movable_wall/proc/continue_allowing_drag(_, mob/living/L)
	if(isxeno(L))
		return COMPONENT_IGNORE_ANCHORED

/obj/structure/alien/movable_wall/proc/allow_xeno_drag(_, mob/living/carbon/xenomorph/X)
	return COMPONENT_ALLOW_PULL

/obj/structure/alien/movable_wall/update_icon()
	overlays.Cut()

	icon_state = "blank"
	var/image/I

	for(var/i = 1 to 4)
		I = image(icon, "[wall_type][wall_connections[i]]", dir = 1<<(i-1))
		overlays += I

	if(health < initial(health))
		var/image/img = image(icon = 'icons/turf/walls/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = ((1-health/initial(health)) * 255)
		overlays += img

/obj/structure/alien/movable_wall/proc/update_connections(propagate = FALSE)
	var/list/wall_dirs = list()

	for(var/dir in GLOB.alldirs)
		var/obj/structure/alien/movable_wall/MW = locate() in get_step(src, dir)
		if(!(MW in group.walls))
			continue

		wall_dirs |= dir
		if(propagate)
			MW.update_connections()
			MW.update_icon()

	wall_connections = dirs_to_corner_states(wall_dirs)

/obj/structure/alien/movable_wall/proc/take_damage(damage)
	health -= damage
	if(health <= 0)
		deconstruct(FALSE)
	else
		update_icon()

/obj/structure/alien/movable_wall/attack_alien(mob/living/carbon/xenomorph/M)
	if(islarva(M))
		return FALSE

	if(M.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"),
	SPAN_XENONOTICE("You claw \the [src]."))
	playsound(src, "alien_resin_break", 25)
	if (M.hivenumber == hivenumber)
		take_damage(ceil(HEALTH_WALL_XENO * 0.25)) //Four hits for a regular wall
	else
		take_damage(M.melee_damage_lower*RESIN_XENO_DAMAGE_MULTIPLIER)
	return XENO_ATTACK_ACTION

/obj/structure/alien/movable_wall/attackby(obj/item/W, mob/living/user)
	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force*RESIN_MELEE_DAMAGE_MULTIPLIER*W.demolition_mod, user)
		playsound(src, "alien_resin_break", 25)
	else
		return attack_hand(user)

/obj/structure/alien/movable_wall/get_projectile_hit_boolean(obj/projectile/P)
	return TRUE

/obj/structure/alien/movable_wall/bullet_act(obj/projectile/P)
	. = ..()
	take_damage(P.damage)

/obj/structure/alien/movable_wall/proc/recalculate_structure()
	var/list/found_structures = list()
	var/current_walls = 0
	for(var/i in GLOB.cardinals)
		var/turf/T = get_step(src, i)
		var/obj/structure/alien/movable_wall/MW = locate() in T
		if(!MW)
			continue

		if(MW.group && !(MW.group in found_structures))
			found_structures += MW.group
			current_walls += length(MW.group.walls)

	if(current_walls > max_walls)
		found_structures = null

	var/datum/movable_wall_group/MWG = new(found_structures)
	MWG.add_structure(src)

/obj/structure/alien/movable_wall/Destroy()
	if(!QDELETED(group))
		group.remove_structure(src)
	else
		group = null

	return ..()

/obj/structure/alien/movable_wall/proc/update_tied_turf(turf/T)
	SIGNAL_HANDLER

	if(!T)
		return

	if(tied_turf)
		UnregisterSignal(tied_turf, COMSIG_TURF_ENTER)
	RegisterSignal(T, COMSIG_TURF_ENTER, PROC_REF(check_for_move))
	tied_turf = T

/obj/structure/alien/movable_wall/forceMove(atom/dest)
	. = ..()
	update_tied_turf(loc)

/obj/structure/alien/movable_wall/proc/check_for_move(turf/T, atom/movable/mover)
	if(group.next_push > world.time)
		return

	var/target_dir = get_dir(mover, T)

	if(isxeno(mover))
		var/mob/living/carbon/xenomorph/X = mover
		if(X.hivenumber != hivenumber || X.throwing)
			return

		if(X.pulling == src)
			X.stop_pulling()

		if(group.try_move_in_direction(target_dir, list(mover)))
			return COMPONENT_TURF_ALLOW_MOVEMENT

/obj/structure/alien/movable_wall/Move(NewLoc, direct)
	if(!(direct in GLOB.cardinals))
		return
	group.try_move_in_direction(direct)

/obj/structure/alien/movable_wall/BlockedPassDirs(atom/movable/mover, target_dir)
	if(!group)
		return ..()

	if(mover in group.walls)
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/alien/movable_wall/membrane
	name = "shifting resin membrane"
	health = HEALTH_WALL_XENO_MEMBRANE
	icon_state = "membrane"
	wall_type = "membrane"

	opacity = FALSE

/obj/structure/alien/movable_wall/thick
	name = "shifting thick resin wall"
	health = HEALTH_WALL_XENO_THICK
	icon_state = "thickresin"
	wall_type = "thickresin"

/obj/structure/alien/movable_wall/membrane/thick
	name = "shifting thick resin membrane"
	health = HEALTH_WALL_XENO_MEMBRANE_THICK
	icon_state = "thickmembrane"
	wall_type = "thickmembrane"

/turf/closed/wall/resin/reflective
	name = "resin reflective wall"
	desc = "Weird hardened slime solidified into a fine, smooth wall."
	icon = 'icons/turf/walls/prison/bone_resin.dmi'
	icon_state = "resin"
	walltype = WALL_BONE_RESIN
	damage_cap = HEALTH_WALL_XENO_MEMBRANE
	should_track_build = TRUE

	// 75% chance of reflecting projectiles
	var/chance_to_reflect = 75
	var/reflect_range = 10

	var/brute_multiplier = 0.3
	var/explosive_multiplier = 0.3
	var/reflection_multiplier = 0.5

/turf/closed/wall/resin/reflective/bullet_act(obj/projectile/P)
	if(src in P.permutated)
		return

	//Ineffective if someone is sitting on the wall
	if(locate(/mob) in contents)
		return ..()

	if(!prob(chance_to_reflect))
		if(P.ammo.damage_type == BRUTE)
			P.damage *= brute_multiplier
		return ..()
	if(P.runtime_iff_group || P.ammo.flags_ammo_behavior & AMMO_NO_DEFLECT)
		// Bullet gets absorbed if it has IFF or can't be reflected.
		return

	var/obj/projectile/new_proj = new(src, construction_data ? construction_data : create_cause_data(initial(name)))
	new_proj.generate_bullet(P.ammo)
	new_proj.damage = P.damage * reflection_multiplier // don't make it too punishing
	new_proj.accuracy = HIT_ACCURACY_TIER_7 // 35% chance to hit something

	// Move back to who fired you.
	RegisterSignal(new_proj, COMSIG_BULLET_PRE_HANDLE_TURF, PROC_REF(bullet_ignore_turf))
	new_proj.permutated |= src

	var/angle = Get_Angle(src, P.firer) + rand(30, -30)
	var/atom/target = get_angle_target_turf(src, angle, get_dist(src, P.firer))
	new_proj.projectile_flags |= PROJECTILE_SHRAPNEL
	new_proj.fire_at(target, P.firer, src, reflect_range, speed = P.ammo.shell_speed)

	return TRUE

/turf/closed/wall/resin/reflective/proc/bullet_ignore_turf(obj/projectile/P, turf/T)
	SIGNAL_HANDLER
	if(T == src)
		return COMPONENT_BULLET_PASS_THROUGH

/turf/closed/wall/resin/reflective/ex_act(severity, explosion_direction, source, mob/source_mob)
	return ..(severity * explosive_multiplier, explosion_direction, source, source_mob)

//this one is only for map use
/turf/closed/wall/resin/membrane/ondirt
	baseturfs = /turf/open/gm/dirt
//strata specifics
/turf/closed/wall/resin/membrane/strata/on_tiles
	baseturfs = /turf/open/floor/strata

/turf/closed/wall/resin/membrane/thick
	name = "thick resin membrane"
	desc = "Weird thick slime just translucent enough to let light pass through."
	damage_cap = HEALTH_WALL_XENO_MEMBRANE_THICK
	icon_state = "thickmembrane"
	walltype = WALL_THICKMEMBRANE
	alpha = 210


/turf/closed/wall/resin/hitby(atom/movable/AM)
	..()
	if(isxeno(AM))
		return
	visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."),
	SPAN_DANGER("You hit \the [src]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else if (isobj(AM))
		var/obj/O = AM
		tforce = O.throwforce
	playsound(src, "alien_resin_break", 25)
	take_damage(tforce)


/turf/closed/wall/resin/attack_alien(mob/living/carbon/xenomorph/M)
	if(SEND_SIGNAL(src, COMSIG_WALL_RESIN_XENO_ATTACK, M) & COMPONENT_CANCEL_XENO_ATTACK)
		return XENO_NO_DELAY_ACTION

	if(islarva(M)) //Larvae can't do shit
		return
	if(M.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"),
	SPAN_XENONOTICE("We claw \the [src]."))
	playsound(src, "alien_resin_break", 25)
	if (M.hivenumber == hivenumber)
		take_damage(ceil(HEALTH_WALL_XENO * 0.25)) //Four hits for a regular wall
	else
		take_damage(M.melee_damage_lower*RESIN_XENO_DAMAGE_MULTIPLIER)
	return XENO_ATTACK_ACTION


/turf/closed/wall/resin/attack_animal(mob/living/M)
	M.visible_message(SPAN_DANGER("[M] tears \the [src]!"),
	SPAN_DANGER("You tear \the [name]."))
	playsound(src, "alien_resin_break", 25)
	M.animation_attack_on(src)
	take_damage(80)


/turf/closed/wall/resin/attack_hand(mob/user)
	if(isxeno(user) && istype(user.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/grab_item_dummy = user.get_active_hand()
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(grab_item_dummy.grabbed_thing, src)

	to_chat(user, SPAN_WARNING("You scrape ineffectively at \the [src]."))

/turf/closed/wall/resin/attackby(obj/item/W, mob/living/user)
	if(SEND_SIGNAL(src, COMSIG_WALL_RESIN_ATTACKBY, W, user) & COMPONENT_CANCEL_ATTACKBY)
		return

	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force*RESIN_MELEE_DAMAGE_MULTIPLIER*W.demolition_mod, user)
		playsound(src, "alien_resin_break", 25)
		return ATTACKBY_HINT_UPDATE_NEXT_MOVE
	else
		return attack_hand(user)

/turf/closed/wall/resin/ChangeTurf(newtype, ...)
	var/hive = hivenumber
	. = ..()
	if(.)
		var/turf/T
		for(var/i in GLOB.cardinals)
			T = get_step(src, i)
			if(!istype(T))
				continue
			for(var/obj/structure/mineral_door/resin/R in T)
				R.check_resin_support()

		var/turf/closed/wall/resin/W = .
		if (istype(W))
			W.hivenumber = hive
			set_hive_data(W, W.hivenumber)

/turf/closed/wall/resin/weak
	name = "weak resin wall"
	desc = "Weird slime solidified into a wall. It already looks on the verge of collapsing..."
	damage_cap = HEALTH_WALL_XENO_WEAK
	var/duration = 5 SECONDS


/turf/closed/wall/resin/weak/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		ScrapeAway()
		return
	addtimer(CALLBACK(src, PROC_REF(ScrapeAway)), duration)


/turf/closed/wall/resin/can_be_dissolved()
	return FALSE

/turf/closed/wall/huntership
	name = "hunter wall"
	desc = "Nigh indestructible walls that make up the hull of a hunter ship."
	icon = 'icons/turf/walls/hunter.dmi'
	icon_state = "metal"//DMI specific name
	walltype = WALL_HUNTERSHIP
	turf_flags = TURF_HULL

/turf/closed/wall/huntership/destructible
	name = "degraded hunter wall"
	color = "#c5beb4"
	desc = "Ancient beyond measure, these walls make up the hull of a vessel of non human origin. Despite this, they can be felled with plastic explosives like any other opaque blocker."
	turf_flags = NO_FLAGS
