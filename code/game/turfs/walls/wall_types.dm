

//-----USS Almayer Walls ---//

/turf/closed/wall/almayer
	name = "hull"
	desc = "A metal wall used to seperate rooms and make up the ship."
	icon = 'icons/turf/walls/almayer.dmi'
	icon_state = "testwall"
	walltype = WALL_HULL

	damage = 0
	damage_cap = HEALTH_WALL //Wall will break down to girders if damage reaches this point

	max_temperature = 18000 //K, walls will take damage if they're next to a fire hotter than this

	opacity = 1
	density = 1

/turf/closed/wall/almayer/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_list in list(EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		var/r2 = rand(0,3) // Which wall if we do choose it
		if(r1 >= 9)
			overlays += image(icon, icon_state = "almayer_deco_wall[r2]")

/turf/closed/wall/almayer/take_damage(dam, var/mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && z == MAIN_SHIP_Z_LEVEL)
		new /obj/effect/decal/prints(get_turf(src), M, "The fingerprint contains specks of metal and dirt.")
		ai_silent_announcement("DAMAGE REPORT: Structural damage detected at [get_area(src)], requesting Military Police supervision.")

	..()

/turf/closed/wall/almayer/reinforced
	name = "reinforced hull"
	desc = "A reinforced metal wall used to seperate rooms and make up the ship."
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/almayer/outer
	name = "outer hull"
	desc = "A metal wall used to seperate space from the ship"
	icon_state = "hull" //Codersprite to make it more obvious in the map maker what's a hull wall and what's not
	//icon_state = "testwall0_debug" //Uncomment to check hull in the map editor.
	walltype = WALL_HULL
	hull = 1 //Impossible to destroy or even damage. Used for outer walls that would breach into space, potentially some special walls

/turf/closed/wall/almayer/outer/take_damage(dam, var/mob/M)
	return

/turf/closed/wall/almayer/white
	walltype = WALL_WHITE
	icon = 'icons/turf/walls/almayer_white.dmi'
	icon_state = "wwall"

/turf/closed/wall/almayer/white/hull
	name = "research hull"
	desc = "An extremely reinforced metal wall used to isolate potentially dangerous areas"
	hull = 1

/turf/closed/wall/almayer/research/can_be_dissolved()
	return 0

/turf/closed/wall/almayer/research/containment/wall
	name = "cell wall"
	icon = 'icons/turf/almayer.dmi'
	tiles_with = null
	walltype = null
	special_icon = 1

/turf/closed/wall/almayer/research/containment/wall/ex_act(severity, explosion_direction)
	if(severity <= EXPLOSION_THRESHOLD_MEDIUM) // Wall is resistant to explosives (and also crusher charge)
		return

	. = ..()
	


/turf/closed/wall/almayer/research/containment/wall/take_damage(dam, mob/M)
	if(isXeno(M))
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/attackby(obj/item/W, mob/user)
	if(isXeno(user))
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/attack_alien(mob/living/carbon/Xenomorph/user)
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
	SetOpacity(0)
	density = 0
	operating = FALSE
	change_weeds()

/turf/closed/wall/almayer/research/containment/wall/divide/proc/close()
	if(operating)
		return
	operating = TRUE
	flick("containment_wall_divide_rising", src)
	icon_state = "containment_wall_divide"
	SetOpacity(1)
	density = 1
	operating = FALSE

	change_weeds()

/turf/closed/wall/almayer/research/containment/wall/divide/proc/change_weeds()
	for(var/obj/effect/alien/W in src) // Destroy all alien things on the divider (traps, special structures, etc)
		playsound(loc, "alien_resin_break", 25)
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
	opacity = 0




//Sulaco walls.
/turf/closed/wall/sulaco
	name = "spaceship hull"
	desc = "A metal wall used to separate rooms on spaceships from the cold void of space."
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "sulaco"
	hull = 0 //Can't be deconstructed

	damage_cap = HEALTH_WALL
	max_temperature = 28000 //K, walls will take damage if they're next to a fire hotter than this
	walltype = WALL_SULACO //Changes all the sprites and icons.

/turf/closed/wall/sulaco/hull
	name = "outer hull"
	desc = "A reinforced outer hull, probably to prevent breaches"
	hull = 1
	max_temperature = 50000 // Nearly impossible to melt
	walltype = WALL_SULACO


/turf/closed/wall/sulaco/unmeltable
	name = "outer hull"
	desc = "A reinforced outer hull, probably to prevent breaches"
	hull = 1
	max_temperature = 50000 // Nearly impossible to melt
	walltype = WALL_SULACO




/turf/closed/wall/indestructible
	name = "wall"
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	hull = 1



/turf/closed/wall/indestructible/bulkhead
	name = "bulkhead"
	desc = "It is a large metal bulkhead."
	icon_state = "hull"

/turf/closed/wall/indestructible/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

/turf/closed/wall/indestructible/splashscreen
	name = "Lobby Art"
	desc = "Assorted artworks."
	icon_source = "lobby_art"
	icon_state = "lobbyart1"
//	icon_state = "title_holiday"
	layer = FLY_LAYER
	special_icon = 1

/turf/closed/wall/indestructible/splashscreen/Initialize()
	. = ..()	
	tag = "LOBBYART"
	if(icon_state == "lobbyart1") // default
		// Only pick lobby art that credits the author
		displayed_lobby_art = rand(1,length(lobby_art_authors))
		icon_state = "lobbyart[displayed_lobby_art]"

		desc = "Artwork by [lobby_art_authors[displayed_lobby_art]]"

/proc/force_lobby_art(art_id)
	displayed_lobby_art = art_id
	var/turf/closed/wall/indestructible/splashscreen/SS = locate("LOBBYART")
	SS.icon_state = "lobbyart[displayed_lobby_art]"
	SS.desc = "Artwork by [lobby_art_authors[displayed_lobby_art]]"
	for(var/client/C in clients)
		if(displayed_lobby_art != -1)
			var/author = "[lobby_art_authors[displayed_lobby_art]]"
			if(author != "Unknown")
				to_chat_forced(C, SPAN_ROUNDBODY("<hr>This round's lobby art is brought to you by [author]<hr>"))

/turf/closed/wall/indestructible/other
	icon_state = "r_wall"

/turf/closed/wall/indestructible/invisible
	icon_state = "invisible"
	mouse_opacity = 0




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
	desc = "A wall with phoron plating. This is definately a bad idea."
	mineral = "phoron"
	color = "#9635aa"





//Misc walls

/turf/closed/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon = 'icons/turf/walls/cult.dmi'
	icon_state = "cult"
	walltype = WALL_CULT
	color = "#3c3434"


/turf/closed/wall/vault
	icon_state = "rockvault"

/turf/closed/wall/vault/Initialize()
	. = ..()
	icon_state = "[type]vault"


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
	icon = 'icons/turf/walls/cave.dmi'
	icon_state = "cavewall"
	desc = "A rough wall of hardened rock."
	walltype = WALL_CAVE
	hull = 1
	color = "#535963"

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
	hull = 1 //Can't break this ice.

/turf/closed/wall/strata_ice/jungle
	name = "jungle vegetation"
	icon = 'icons/turf/walls/strata_ice.dmi'
	icon_state = "strata_jungle"
	desc = "Exceptionally dense vegetation that you can't see through."
	walltype = WALL_STRATA_JUNGLE //Not a metal wall
	hull = 1 //Can't break this vegetation.

/turf/closed/wall/strata_outpost_ribbed //this guy is our reinforced replacement
	name = "ribbed outpost walls"
	icon = 'icons/turf/walls/strata_outpost.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = 1000
	max_temperature = 28000

/turf/closed/wall/strata_outpost_bare
	name = "bare outpost walls"
	icon = 'icons/turf/walls/strata_outpost.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

//SOLARIS RIDGE TILESET//

/turf/closed/wall/solaris
	name = "solaris ridge colony wall"
	icon = 'icons/turf/walls/solaris/solaris.dmi'
	icon_state = "solaris_interior"
	desc = "Tough looking walls that have been blasted by sand since they day they were erected. A testament to human willpower."
	walltype = WALL_SOLARIS

/turf/closed/wall/solaris/reinforced
	icon_state = "solaris_interior_r"
	walltype = WALL_SOLARISR
	damage_cap = 1000
	max_temperature = 28000

/turf/closed/wall/solaris/reinforced/hull
	hull = 1

/turf/closed/wall/solaris/rock
	name = "solaris ridge rock wall"
	icon_state = "solaris_rock"
	walltype = WALL_SOLARIS_ROCK
	hull = 1



//Xenomorph's Resin Walls

/turf/closed/wall/resin
	name = "resin wall"
	desc = "Weird slime solidified into a wall."
	icon_source = "alien_structures"
	icon_state = "resin"
	walltype = WALL_RESIN
	damage_cap = HEALTH_WALL_XENO
	layer = RESIN_STRUCTURE_LAYER
	blend_turfs = list(/turf/closed/wall/resin)
	blend_objects = list(/obj/structure/mineral_door/resin)
	var/hivenumber = XENO_HIVE_NORMAL

/turf/closed/wall/resin/flamer_fire_act(var/dam = config.min_burnlevel)
	take_damage(dam)

//this one is only for map use
/turf/closed/wall/resin/ondirt
	old_turf = "/turf/open/gm/dirt"
//strata specifics
/turf/closed/wall/resin/strata/on_tiles
	old_turf = "/turf/open/floor/strata"

/turf/closed/wall/resin/thick
	name = "thick resin wall"
	desc = "Weird slime solidified into a thick wall."
	damage_cap = HEALTH_WALL_XENO_THICK
	icon_state = "thickresin"
	walltype = WALL_THICKRESIN

/turf/closed/wall/resin/membrane
	name = "resin membrane"
	desc = "Weird slime translucent enough to let light pass through."
	icon_state = "membrane"
	walltype = WALL_MEMBRANE
	damage_cap = HEALTH_WALL_XENO_MEMBRANE
	opacity = 0
	alpha = 180

/turf/closed/wall/resin/membrane/can_bombard(var/mob/living/carbon/Xenomorph/X)
	if(!istype(X))
		return FALSE

	return X.hivenumber == hivenumber

/turf/closed/wall/resin/membrane/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_GLASS)

//this one is only for map use
/turf/closed/wall/resin/membrane/ondirt
	old_turf = "/turf/open/gm/dirt"
//strata specifics
/turf/closed/wall/resin/membrane/strata/on_tiles
	old_turf = "/turf/open/floor/strata"

/turf/closed/wall/resin/membrane/thick
	name = "thick resin membrane"
	desc = "Weird thick slime just translucent enough to let light pass through."
	damage_cap = HEALTH_WALL_XENO_MEMBRANE_THICK
	icon_state = "thickmembrane"
	walltype = WALL_THICKMEMBRANE
	alpha = 210


/turf/closed/wall/resin/hitby(atom/movable/AM)
	..()
	if(isXeno(AM))
		return
	visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."), \
	SPAN_DANGER("You hit \the [src]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else if (isobj(AM))
		var/obj/O = AM
		tforce = O.throwforce
	playsound(src, "alien_resin_break", 25)
	take_damage(tforce)


/turf/closed/wall/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	else if(M.a_intent == INTENT_HELP)
		return 0
	else
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"), \
		SPAN_XENONOTICE("You claw \the [src]."))
		playsound(src, "alien_resin_break", 25)
		if (M.hivenumber == hivenumber)
			take_damage(Ceiling(HEALTH_WALL_XENO/4)) //Four hits for a regular wall
		else
			take_damage(M.melee_damage_lower*RESIN_XENO_DAMAGE_MULTIPLIER)


/turf/closed/wall/resin/attack_animal(mob/living/M)
	M.visible_message(SPAN_DANGER("[M] tears \the [src]!"), \
	SPAN_DANGER("You tear \the [name]."))
	playsound(src, "alien_resin_break", 25)
	M.animation_attack_on(src)
	take_damage(80)


/turf/closed/wall/resin/attack_hand(mob/user)
	to_chat(user, SPAN_WARNING("You scrape ineffectively at \the [src]."))

/turf/closed/wall/resin/attackby(obj/item/W, mob/living/user)
	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force*RESIN_MELEE_DAMAGE_MULTIPLIER, user)
		playsound(src, "alien_resin_break", 25)
	else
		return attack_hand(user)

/turf/closed/wall/resin/dismantle_wall(devastated = 0, explode = 0)
	qdel(src) //ChangeTurf is called by Dispose()

/turf/closed/wall/resin/ChangeTurf(newtype)
	var/hive = hivenumber
	. = ..()
	if(.)
		var/turf/T
		for(var/i in cardinal)
			T = get_step(src, i)
			if(!istype(T)) continue
			for(var/obj/structure/mineral_door/resin/R in T)
				R.check_resin_support()
		
		var/turf/closed/wall/resin/W = .
		if (istype(W))
			W.hivenumber = hive
			set_hive_data(W, W.hivenumber)




/turf/closed/wall/resin/can_be_dissolved()
	return FALSE
