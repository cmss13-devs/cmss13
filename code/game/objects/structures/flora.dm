//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	layer = ABOVE_FLY_LAYER

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/structures/props/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/joshua
	name = "joshua tree"
	desc = "A tall tree covered in spiky-like needles, covering it's trunk."
	icon = 'icons/obj/structures/props/joshuatree.dmi'
	icon_state = "joshua_1"
	pixel_x = 0
	density = 0
	unacidable = 1
/obj/structure/flora/tree/joshua/New()
	..()
	icon_state = "joshua_[rand(1,4)]"

//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/structures/props/snowflora.dmi'
	anchored = 1

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]bb"


/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/New()
	..()
	icon_state = "snowgrassall[rand(1, 3)]"


//bushes
/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/structures/props/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = 1

/obj/structure/flora/bush/New()
	..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/pottedplant
	name = "potted plant"
	icon = 'icons/obj/structures/props/plants.dmi'
	icon_state = "plant-26"

/obj/structure/flora/pottedplant/random
	var/maxplants = 30 //Change this whenever you add new plants

/obj/structure/flora/pottedplant/random/New()
	..()
	icon_state = "plant-[rand(1,maxplants)]"
//newbushes

/obj/structure/flora/ausbushes
	name = "bush"
	icon = 'icons/obj/structures/props/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/New()
	..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/New()
	..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"


//Desert (Desert Dam)
//*********************//
// Generic undergrowth //
//*********************//

/obj/structure/flora/
	var/icon_tag = null

/obj/structure/flora/desert
	anchored = 1
	icon = 'icons/obj/structures/props/dam.dmi'
	var/variations = null

/obj/structure/flora/desert/New()
	..()
	//icon_state = "[icon_tag]_[rand(1,variations)]"

//GRASS
/obj/structure/flora/desert/grass
	name = "grass"
	icon_state = "lightgrass_1"
	icon_tag = "lightgrass"
	unacidable = 1
	//variations = 12

/obj/structure/flora/desert/grass/heavy
	icon_state = "heavygrass_1"
	icon_tag = "heavygrass"
	//variations = 16

//TALLGRASS
/obj/structure/flora/tallgrass
	name = "tallgrass"
	icon = 'icons/obj/structures/props/tallgrass.dmi'
	unacidable = 1
	var/center = TRUE //Determine if we want less or more ash when burned
	var/overlay_type = "tallgrass_overlay"

/obj/structure/flora/tallgrass/center
	icon_state = "tallgrass"
	icon_tag = "tallgrass"

/obj/structure/flora/tallgrass/New()
	update_icon()

/obj/structure/flora/tallgrass/update_icon()
	..()
	overlays.Cut()
	overlays += image("icon"=src.icon,"icon_state"=overlay_type,"layer"=ABOVE_XENO_LAYER,"dir"=dir)

/obj/structure/flora/tallgrass/flamer_fire_act()
	fire_act()

/obj/structure/flora/tallgrass/fire_act()
	if(!disposed)
		spawn(rand(75,150))
			for(var/D in cardinal) //Spread fire
				var/turf/T = get_step(src.loc, D)
				if(T && T.contents)
					for(var/obj/structure/flora/tallgrass/G in T.contents)
						if(istype(G,/obj/structure/flora/tallgrass))
							new /obj/flamer_fire(T, "wildfire")
							G.fire_act()
		spawn(rand(125,225))
			new /obj/effect/decal/cleanable/dirt(src.loc)
			if(center)
				new /obj/effect/decal/cleanable/dirt(src.loc) //Produces more ash at the center
			qdel(src)
///MAP VARIANTS///
///PARENT FOR COLOR, CORNERS AND CENTERS, BASED ON DIRECTIONS///

///TRIJENT - WHISKEY OUTPOST///
/obj/structure/flora/tallgrass/desert
	//color = COLOR_G_DES
	icon = 'icons/obj/structures/props/dam.dmi' //Override since the greyscale can't match
	icon_state = "tallgrass"
	icon_tag = "tallgrass"

/obj/structure/flora/tallgrass/desert/corner
	icon_state = "tallgrass_corner"
	icon_tag = "tallgrass"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

///ICE COLONY - SOROKYNE///
/obj/structure/flora/tallgrass/ice
	color = COLOR_G_ICE
	icon_state = "tallgrass"
	icon_tag = "tallgrass"
	desc = "A large swathe of bristling snowgrass"

/obj/structure/flora/tallgrass/ice/corner
	icon_state = "tallgrass_corner"
	icon_tag = "tallgrass"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

///LV - JUNGLE MAPS///

/obj/structure/flora/tallgrass/jungle
	color = COLOR_G_JUNG
	icon_state = "tallgrass"
	icon_tag = "tallgrass"
	desc = "A clump of vibrant jungle grasses"

/obj/structure/flora/tallgrass/jungle/corner
	icon_state = "tallgrass_corner"
	icon_tag = "tallgrass"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

//BUSHES
/obj/structure/flora/desert/bush
	name = "bush"
	desc = "A small, leafy bush."
	icon_state = "tree_1"
	icon_tag = "tree"
	layer = ABOVE_XENO_LAYER
	//variations = 4

//CACTUS
/obj/structure/flora/desert/cactus
	name = "cactus"
	desc = "It's a small, spiky cactus."
	icon_state = "cactus_1"
	icon_tag = "cactus"
	//variations = 12

/obj/structure/flora/desert/cactus/multiple
	name = "cacti"
	icon_state = "cactus_1"
	icon_tag = "cacti"


//Jungle (Whiskey Outpost)

//*********************//
// Generic undergrowth //
//*********************//

/obj/structure/jungle
	name = "jungle foliage"
	icon = 'icons/turf/ground_map.dmi'
	density = 0
	anchored = 1
	unacidable = 1 // can toggle it off anyway
	layer = ABOVE_XENO_LAYER

/obj/structure/jungle/shrub
	name = "jungle foliage"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon_state = "grass4"

/obj/structure/jungle/plantbot1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "plantbot1"

/obj/structure/jungle/planttop1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "planttop1"

/obj/structure/jungle/tree
	icon = 'icons/obj/structures/props/ground_map64.dmi'
	desc = "What an enormous tree!"
	layer = ABOVE_FLY_LAYER

/obj/structure/jungle/tree/bigtreeTR
	name = "huge tree"
	icon_state = "bigtreeTR"

/obj/structure/jungle/tree/bigtreeTL
	name = "huge tree"
	icon_state = "bigtreeTL"

/obj/structure/jungle/tree/bigtreeBOT
	name = "huge tree"
	icon_state = "bigtreeBOT"

/obj/structure/jungle/treeblocker
	name = "huge tree"
	icon_state = ""	//will this break it?? - Nope
	density = 1

/obj/structure/jungle/vines
	name = "vines"
	desc = "A mass of twisted vines."
	icon = 'icons/effects/spacevines.dmi'

/obj/structure/jungle/vines/attackby(obj/item/W, mob/living/user)
	if(W.sharp == IS_SHARP_ITEM_BIG)
		to_chat(user, SPAN_WARNING("You cut \the [src] away with \the [W]."))
		user.animation_attack_on(src)
		playsound(src, 'sound/effects/vegetation_hit.ogg', 25, 1)
		qdel(src)
	else
		. = ..()

/obj/structure/jungle/vines/flamer_fire_act()
	fire_act()

/obj/structure/jungle/vines/fire_act()
	if(!disposed)
		spawn(rand(100,175))
			qdel(src)

/obj/structure/jungle/vines/New()
	..()
	icon_state = pick("Light1","Light2","Light3")

/obj/structure/jungle/vines/heavy
	desc = "A thick, coiled mass of twisted vines."
	opacity = 1

/obj/structure/jungle/vines/heavy/New()
	..()
	icon_state = pick("Hvy1","Hvy2","Hvy3","Med1","Med2","Med3")

/obj/structure/jungle/tree/grasscarpet
	name = "thick grass"
	desc = "A thick mat of dense grass."
	icon_state = "grasscarpet"
	layer = BELOW_MOB_LAYER

/obj/structure/bush
	name = "dense vegetation"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'icons/obj/structures/props/jungleplants.dmi'
	icon_state = "bush1"
	density = 0
	anchored = 1
	layer = BUSH_LAYER
	var/indestructable = 0
	var/stump = 0
	health = 100

/obj/structure/bush/New()
	health = rand(50,75)
	if(prob(75))
		opacity = 1

	//Randomise a bit
	var/matrix/M = matrix()
	M.Turn(rand(1,360))
	M.Scale(pick(0.7,0.8,0.9,1,1.1,1.2),pick(0.7,0.8,0.9,1,1.1,1.2))
	src.transform = M


/obj/structure/bush/Bumped(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.loc = get_turf(src)
	else if (ismonkey(M))
		var/mob/A = M
		A.loc = get_turf(src)


/obj/structure/bush/Crossed(atom/movable/AM)
	if(!stump)
		if(isliving(AM))
			var/mob/living/L = AM
			var/bush_sound_prob = 60
			if(istype(L, /mob/living/carbon/Xenomorph))
				var/mob/living/carbon/Xenomorph/X = L
				bush_sound_prob = X.tier * 20

			if(prob(bush_sound_prob))
				var/sound = pick('sound/effects/vegetation_walk_0.ogg','sound/effects/vegetation_walk_1.ogg','sound/effects/vegetation_walk_2.ogg')
				playsound(src.loc, sound, 25, 1)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/stuck = rand(0,10)
				switch(stuck)
					if(0 to 4)
						H.next_move_slowdown += rand(2,3)
						if(prob(2))
							to_chat(H, SPAN_WARNING("Moving through [src] slows you down."))
					if(5 to 7)
						H.next_move_slowdown += rand(4,7)
						if(prob(10))
							to_chat(H, SPAN_WARNING("It is very hard to move trough this [src]..."))
					if(8 to 9)
						H.next_move_slowdown += rand(8,11)
						to_chat(H, SPAN_WARNING("You got tangeled in [src]!"))
					if(10)
						H.next_move_slowdown += rand(12,20)
						to_chat(H, SPAN_WARNING("You got completely tangeled in [src]! Oh boy..."))

/obj/structure/bush/attackby(var/obj/I as obj, var/mob/user as mob)
	//hatchets and shiet can clear away undergrowth
	if(I && (istype(I, /obj/item/tool/hatchet) || istype(I, /obj/item/weapon/combat_knife) || istype(I, /obj/item/weapon/claymore/mercsword) && !stump))
		var/damage = rand(2,5)
		if(istype(I,/obj/item/weapon/claymore/mercsword))
			damage = rand(8,18)
		if(indestructable)
			//this bush marks the edge of the map, you can't destroy it
			to_chat(user, SPAN_DANGER("You flail away at the undergrowth, but it's too thick here."))
		else
			user.visible_message(SPAN_DANGER("[user] flails away at the  [src] with [I]."),SPAN_DANGER("You flail away at the [src] with [I]."))
			playsound(src.loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
			health -= damage
			if(health < 0)
				to_chat(user, SPAN_NOTICE(" You clear away [src]."))
			healthcheck()
	else
		return ..()

/obj/structure/bush/proc/healthcheck()
	if(health < 35 && opacity)
		opacity = 0
	if(health < 0)
		if(prob(10))
			icon_state = "stump[rand(1,2)]"
			name = "cleared foliage"
			desc = "There used to be dense undergrowth here."
			stump = 1
			pixel_x = rand(-6,6)
			pixel_y = rand(-6,6)
		else
			qdel(src)

/obj/structure/bush/flamer_fire_act(heat)
	health -= 30
	healthcheck(src)


/obj/structure/jungle_plant
	icon = 'icons/obj/structures/props/jungleplants.dmi'
	icon_state = "plant1"
	desc = "Looks like some of that fruit might be edible."