



//-----USS Almayer Walls ---//

/turf/closed/wall/almayer
	name = "hull"
	desc = "A metal wall used to seperate rooms and make up the ship."
	icon = 'icons/turf/walls/almayer.dmi'
	icon_state = "testwall"
	walltype = "testwall"

	damage = 0
	damage_cap = 1000 //Wall will break down to girders if damage reaches this point

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

/turf/closed/wall/almayer/outer
	name = "outer hull"
	desc = "A metal wall used to seperate space from the ship"
	icon_state = "hull" //Codersprite to make it more obvious in the map maker what's a hull wall and what's not
	//icon_state = "testwall0_debug" //Uncomment to check hull in the map editor.
	walltype = "testwall"
	hull = 1 //Impossible to destroy or even damage. Used for outer walls that would breach into space, potentially some special walls

/turf/closed/wall/almayer/white
	walltype = "wwall"
	icon = 'icons/turf/walls/almayer_white.dmi'
	icon_state = "wwall"

/turf/closed/wall/almayer/research/can_be_dissolved()
	return 0

/turf/closed/wall/almayer/research/containment/wall
	name = "cell wall"
	icon = 'icons/turf/almayer.dmi'
	tiles_with = null
	walltype = null
	special_icon = 1

/turf/closed/wall/almayer/research/containment/wall/corner
	icon_state = "containment_wall_corner"

/turf/closed/wall/almayer/research/containment/wall/divide
	icon_state = "containment_wall_divide"

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
	icon = 'icons/turf/walls.dmi'
	icon_state = "sulaco"
	hull = 0 //Can't be deconstructed

	damage_cap = 1000 //As tough as R_walls.
	max_temperature = 28000 //K, walls will take damage if they're next to a fire hotter than this
	walltype = "sulaco" //Changes all the sprites and icons.


/turf/closed/wall/sulaco/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			take_damage(rand(0, 250))
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(75))
				take_damage(rand(100, 250))
			else
				dismantle_wall(1, 1)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			ChangeTurf(/turf/open/floor/plating)
	return

/turf/closed/wall/sulaco/hull
	name = "outer hull"
	desc = "A reinforced outer hull, probably to prevent breaches"
	hull = 1
	max_temperature = 50000 // Nearly impossible to melt
	walltype = "sulaco"


/turf/closed/wall/sulaco/unmeltable
	name = "outer hull"
	desc = "A reinforced outer hull, probably to prevent breaches"
	hull = 1
	max_temperature = 50000 // Nearly impossible to melt
	walltype = "sulaco"

/turf/closed/wall/sulaco/unmeltable/ex_act(severity) //Should make it indestructable
	return

/turf/closed/wall/sulaco/unmeltable/fire_act(exposed_temperature, exposed_volume)
	return

/turf/closed/wall/sulaco/unmeltable/attackby() //This should fix everything else. No cables, etc
	return

/turf/closed/wall/sulaco/unmeltable/can_be_dissolved()
	return 0








/turf/closed/wall/indestructible
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	hull = 1

/turf/closed/wall/indestructible/ex_act(severity) //Should make it indestructable
	return

/turf/closed/wall/indestructible/fire_act(exposed_temperature, exposed_volume)
	return

/turf/closed/wall/indestructible/attackby() //This should fix everything else. No cables, etc
	return

/turf/closed/wall/indestructible/can_be_dissolved()
	return 0



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
	desc = "Assorted artworks by NicBoone & Triiodine. Holiday artwork by Monkeyfist."
	icon = 'icons/misc/title.dmi'
	icon_state = "title_painting1"
//	icon_state = "title_holiday"
	layer = FLY_LAYER
	special_icon = 1

/turf/closed/wall/indestructible/splashscreen/New()
	..()
	if(icon_state == "title_painting1") // default
		icon_state = "title_painting[rand(1,6)]"

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
	walltype = "stone"
	var/mineral
	var/last_event = 0
	var/active = null
	tiles_with = list(/turf/closed/wall/mineral)

/turf/closed/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "gold0"
	walltype = "gold"
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

/turf/closed/wall/mineral/uranium/attack_hand(mob/user as mob)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/attackby(obj/item/W as obj, mob/user as mob)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/Bumped(AM as mob|obj)
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
	walltype = "cult"
	color = "#3c3434"


/turf/closed/wall/vault
	icon_state = "rockvault"

/turf/closed/wall/vault/New(location,type)
	..()
	icon_state = "[type]vault"


//Hangar walls
/turf/closed/wall/hangar
	name = "hangar wall"
	icon = 'icons/turf/walls/hangar.dmi'
	icon_state = "hangar"
	walltype = "hangar"

//Prison wall

/turf/closed/wall/prison
	name = "metal wall"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "metal"
	walltype = "metal"



//Wood wall

/turf/closed/wall/wood
	name = "wood wall"
	icon = 'icons/turf/walls/wood.dmi'
	icon_state = "wood"
	walltype = "wood"

/turf/closed/wall/wood/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_list in list(EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		if(r1 >= 9)
			overlays += image(icon, icon_state = "wood_variant")


/turf/closed/wall/rock
	name = "rock wall"
	icon = 'icons/turf/walls/cave.dmi'
	icon_state = "cavewall"
	walltype = "cavewall"
	hull = 1
	color = "#535963"

/turf/closed/wall/rock/brown
	color = "#826161"

/turf/closed/wall/rock/orange
	color = "#994a16"

/turf/closed/wall/rock/red
	color = "#822d21"

/turf/closed/wall/rock/ice
	name = "dense ice wall"
	color = "#4b94b3"

/turf/closed/wall/rock/ice/thin
	alpha = 166

//Xenomorph's Resin Walls

/turf/closed/wall/resin
	name = "resin wall"
	desc = "Weird slime solidified into a wall."
	icon = 'icons/Xeno/structures.dmi'
	icon_state = "resin"
	walltype = "resin"
	damage_cap = 200
	layer = RESIN_STRUCTURE_LAYER
	blend_turfs = list(/turf/closed/wall/resin)
	blend_objects = list(/obj/structure/mineral_door/resin)

/turf/closed/wall/resin/New()
	..()
	if(!locate(/obj/effect/alien/weeds) in loc)
		new /obj/effect/alien/weeds(loc)

/turf/closed/wall/resin/flamer_fire_act()
	take_damage(50)

//this one is only for map use
/turf/closed/wall/resin/ondirt
	old_turf = "/turf/open/gm/dirt"

/turf/closed/wall/resin/thick
	name = "thick resin wall"
	desc = "Weird slime solidified into a thick wall."
	damage_cap = 400
	icon_state = "thickresin"
	walltype = "thickresin"

/turf/closed/wall/resin/membrane
	name = "resin membrane"
	desc = "Weird slime translucent enough to let light pass through."
	icon_state = "membrane"
	walltype = "membrane"
	damage_cap = 120
	opacity = 0
	alpha = 180

//this one is only for map use
/turf/closed/wall/resin/membrane/ondirt
	old_turf = "/turf/open/gm/dirt"

/turf/closed/wall/resin/membrane/thick
	name = "thick resin membrane"
	desc = "Weird thick slime just translucent enough to let light pass through."
	damage_cap = 240
	icon_state = "thickmembrane"
	walltype = "thickmembrane"
	alpha = 210

/turf/closed/wall/resin/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.damage/2)
	..()

	return 1

/turf/closed/wall/resin/ex_act(severity)
	take_damage(severity)


/turf/closed/wall/resin/hitby(AM as mob|obj)
	..()
	if(istype(AM,/mob/living/carbon/Xenomorph))
		return
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>", \
	"<span class='danger'>You hit \the [src].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(src, "alien_resin_break", 25)
	take_damage(max(0, damage_cap - tforce))


/turf/closed/wall/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	else if(M.a_intent == "help")
		return 0
	else
		M.animation_attack_on(src)
		M.visible_message("<span class='xenonotice'>\The [M] claws \the [src]!</span>", \
		"<span class='xenonotice'>You claw \the [src].</span>")
		playsound(src, "alien_resin_break", 25)
		take_damage((M.melee_damage_upper + 50)) //Beef up the damage a bit


/turf/closed/wall/resin/attack_animal(mob/living/M)
	M.visible_message("<span class='danger'>[M] tears \the [src]!</span>", \
	"<span class='danger'>You tear \the [name].</span>")
	playsound(src, "alien_resin_break", 25)
	M.animation_attack_on(src)
	take_damage(40)


/turf/closed/wall/resin/attack_hand(mob/user)
	user << "<span class='warning'>You scrape ineffectively at \the [src].</span>"


/turf/closed/wall/resin/attack_paw(mob/user)
	return attack_hand(user)


/turf/closed/wall/resin/attackby(obj/item/W, mob/living/user)
	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force)
		playsound(src, "alien_resin_break", 25)
	else
		return attack_hand(user)

/turf/closed/wall/resin/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density

/turf/closed/wall/resin/dismantle_wall(devastated = 0, explode = 0)
	cdel(src) //ChangeTurf is called by Dispose()



/turf/closed/wall/resin/ChangeTurf(newtype)
	. = ..()
	if(.)
		var/turf/T
		for(var/i in cardinal)
			T = get_step(src, i)
			if(!istype(T)) continue
			for(var/obj/structure/mineral_door/resin/R in T)
				R.check_resin_support()




/turf/closed/wall/resin/can_be_dissolved()
	return FALSE
