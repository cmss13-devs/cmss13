/*

Plants, trees, etc. If you want to create a plant that can have variations, make sure the .dmi file
has all of the variations with the same prefix and different numbers

Example:
	/obj/structure/flora/plant
		icon_tag = "plant"
		variations = "5"

	when this plant is created, it'll pick one of the five icon states in the dmi file, provided that you have plant_1, plant_3, etc

If you want to make plant cuttable, change it's cut_level var

PLANT_NO_CUT = 1 = Can't be cut down
PLANT_CUT_KNIFE = 2 = Needs at least a bootknife to be cut down
PLANT_CUT_MACHETE = 3 = Needs at least a machete to be cut down


*/

#define PLANT_NO_CUT 1
#define PLANT_CUT_KNIFE 2
#define PLANT_CUT_MACHETE 4

#define FLORA_NO_BURN 0
#define FLORA_BURN_NO_SPREAD 1
#define FLORA_BURN_SPREAD_ONCE 2
#define FLORA_BURN_SPREAD_ALL 4

/obj/structure/flora
	name = "plant"
	anchored = 1
	density = 1
	var/icon_tag = null
	var/variations = 1
	var/cut_level = PLANT_NO_CUT
	var/cut_hits = 3
	var/fire_flag = FLORA_NO_BURN
	var/center = TRUE //Determine if we want less or more ash when burned

/obj/structure/flora/New()
	. = ..()
	if(icon_tag)
		icon_state = "[icon_tag]_[rand(1,variations)]"

/obj/structure/flora/attackby(obj/item/W, mob/living/user)
	if(cut_level &~PLANT_NO_CUT && W.sharp > IS_SHARP_ITEM_SIMPLE)
		if(cut_level & PLANT_CUT_MACHETE && W.sharp == IS_SHARP_ITEM_ACCURATE)
			cut_hits--
		else
			cut_hits = 0
		user.animation_attack_on(src)
		to_chat(user, SPAN_WARNING("You cut [cut_hits > 0 ? "some of" : "all of"] \the [src] away with \the [W]."))
		playsound(src, 'sound/effects/vegetation_hit.ogg', 25, 1)
		if(cut_hits <= 0)
			qdel(src)
	else
		. = ..()

/obj/structure/flora/flamer_fire_act()
	fire_act()



//trees
/obj/structure/flora/tree
	name = "tree"
	pixel_x = -16
	layer = ABOVE_FLY_LAYER

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/structures/props/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/joshua
	name = "joshua tree"
	desc = "A tall tree covered in spiky-like needles, covering it's trunk."
	icon = 'icons/obj/structures/props/joshuatree.dmi'
	icon_state = "joshua_1"
	pixel_x = 0
	density = 0
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/flora/tree/jungle
	icon = 'icons/obj/structures/props/ground_map64.dmi'
	desc = "What an enormous tree!"
	density = 0

/obj/structure/flora/tree/jungle/bigtreeTR
	name = "huge tree"
	icon_state = "bigtreeTR"

/obj/structure/flora/tree/jungle/bigtreeTL
	name = "huge tree"
	icon_state = "bigtreeTL"

/obj/structure/flora/tree/jungle/bigtreeBOT
	name = "huge tree"
	icon_state = "bigtreeBOT"

/obj/structure/flora/tree/jungle/grasscarpet
	name = "thick grass"
	desc = "A thick mat of dense grass."
	icon_state = "grasscarpet"
	layer = BELOW_MOB_LAYER
	density = 0

//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/structures/props/ausflora.dmi'
	density = 0
	fire_flag = FLORA_BURN_NO_SPREAD
/*

ICE GRASS

*/

/obj/structure/flora/grass/ice
	icon = 'icons/obj/structures/props/snowflora.dmi'
	variations = 3

/obj/structure/flora/grass/ice/brown
	icon_tag = "snowgrassbb"

/obj/structure/flora/grass/ice/green
	icon_tag = "snowgrassgb"

/obj/structure/flora/grass/ice/both
	icon_tag = "snowgrassall"

/*

	DESERT GRASS

*/

/obj/structure/flora/grass/desert
	icon = 'icons/obj/structures/props/dam.dmi'
	icon_state = "lightgrass_1"

/obj/structure/flora/grass/desert/heavy
	icon_state = "heavygrass_1"

/*

	TALLGRASS - SPREADS FIRES

*/

/obj/structure/flora/grass/tallgrass
	name = "tallgrass"
	icon = 'icons/obj/structures/props/tallgrass.dmi'
	unslashable = TRUE
	unacidable = TRUE
	var/overlay_type = "tallgrass_overlay"

/obj/structure/flora/grass/tallgrass/New()
	..()
	update_icon()

/obj/structure/flora/grass/tallgrass/update_icon()
	..()
	overlays.Cut()
	overlays += image("icon"=src.icon,"icon_state"=overlay_type,"layer"=ABOVE_XENO_LAYER,"dir"=dir)

/obj/structure/flora/fire_act()
	if(!QDELETED(src))
		if(fire_flag != FLORA_NO_BURN)
			if(fire_flag != FLORA_BURN_NO_SPREAD)
				spawn(rand(75,150))
					for(var/D in cardinal) //Spread fire
						var/turf/T = get_step(src.loc, D)
						if(T && T.contents)
							for(var/obj/structure/flora/grass/tallgrass/G in T.contents)
								if(istype(G,/obj/structure/flora/grass/tallgrass))
									var/datum/reagent/napalm/ut/R = new()
									new /obj/flamer_fire(T, "wildfire", null, R)
									if(fire_flag ==FLORA_BURN_SPREAD_ONCE)
										G.fire_flag = FLORA_BURN_NO_SPREAD
									G.fire_act()

			spawn(rand(125,225))
				new /obj/effect/decal/cleanable/dirt(src.loc)
				if(center)
					new /obj/effect/decal/cleanable/dirt(src.loc) //Produces more ash at the center
				qdel(src)

/obj/structure/flora/ex_act(var/power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		qdel(src)

///MAP VARIANTS///
///PARENT FOR COLOR, CORNERS AND CENTERS, BASED ON DIRECTIONS///

///TRIJENT - WHISKEY OUTPOST///
/obj/structure/flora/grass/tallgrass/desert
	//color = COLOR_G_DES
	icon = 'icons/obj/structures/props/dam.dmi' //Override since the greyscale can't match
	icon_state = "tallgrass"
	fire_flag = FLORA_BURN_SPREAD_ALL

/obj/structure/flora/grass/tallgrass/desert/corner
	icon_state = "tallgrass_corner"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

///ICE COLONY - SOROKYNE///
/obj/structure/flora/grass/tallgrass/ice
	color = COLOR_G_ICE
	icon_state = "tallgrass"
	desc = "A large swathe of bristling snowgrass"

/obj/structure/flora/grass/tallgrass/ice/corner
	icon_state = "tallgrass_corner"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

///LV - JUNGLE MAPS///

/obj/structure/flora/grass/tallgrass/jungle
	color = COLOR_G_JUNG
	icon_state = "tallgrass"
	desc = "A clump of vibrant jungle grasses"
	cut_level = PLANT_CUT_MACHETE
	fire_flag = FLORA_BURN_SPREAD_ONCE

/obj/structure/flora/grass/tallgrass/jungle/corner
	icon_state = "tallgrass_corner"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

//BUSHES

/*

	SNOW

*/

/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/structures/props/snowflora.dmi'
	icon_state = "snowbush_1"
	density = 0
	layer = ABOVE_XENO_LAYER
	fire_flag = FLORA_BURN_NO_SPREAD

/obj/structure/flora/bush/snow
	icon_tag = "snowbush"
	variations = 6

/*

	AUSBUSHES

*/

/obj/structure/flora/bush/ausbushes
	icon = 'icons/obj/structures/props/ausflora.dmi'
	icon_state = "firstbush_1"
	variations = 4
	cut_level = PLANT_CUT_KNIFE

/obj/structure/flora/bush/ausbushes/ausbush
	icon_state = "firstbush_1"
	icon_tag = "firstbush"

/obj/structure/flora/bush/ausbushes/reedbush
	icon_state = "reedbush_1"
	icon_tag = "reedbush"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/palebush
	icon_state = "palebush_1"
	icon_tag = "palebush"

/obj/structure/flora/bush/ausbushes/grassybush
	icon_state = "grassybush_1"
	icon_tag = "grassybush"

/obj/structure/flora/bush/ausbushes/genericbush
	icon_state = "genericbush_1"
	icon_tag = "genericbush"

/obj/structure/flora/bush/ausbushes/pointybush
	icon_state = "pointybush_1"
	icon_tag = "pointybush"

/obj/structure/flora/bush/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"
	icon_tag = "lavendergrass"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/ppflowers
	icon_state = "ppflowers_1"
	icon_tag = "ppflowers"
	layer = BELOW_MOB_LAYER

/*

	AUSBUSHES (3 VARIATIONS)

*/


/obj/structure/flora/bush/ausbushes/var3
	icon_state = "leafybush_1"
	variations = 3

/obj/structure/flora/bush/ausbushes/var3/leafybush
	icon_state = "leafybush_1"
	icon_tag = "leafybush"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/stalkybush
	icon_state = "stalkybush_1"
	icon_tag = "stalkybush"

/obj/structure/flora/bush/ausbushes/var3/fernybush
	icon_state = "fernybush_1"
	icon_tag = "fernybush"

/obj/structure/flora/bush/ausbushes/var3/sunnybush
	icon_state = "sunnybush_1"
	icon_tag = "sunnybush"

/obj/structure/flora/bush/ausbushes/var3/ywflowers
	icon_state = "ywflowers_1"
	icon_tag = "ywflowers"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/brflowers
	icon_state = "brflowers_1"
	icon_tag = "brflowers"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/sparsegrass
	icon_state = "sparsegrass_1"
	icon_tag = "sparsegrass"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/fullgrass
	icon_state =  "fullgrass_1"
	icon_tag = "fullgrass"
	layer = BELOW_MOB_LAYER

/*

	DESERT BUSH

*/

/obj/structure/flora/bush/desert
	icon = 'icons/obj/structures/props/dam.dmi'
	desc = "A small, leafy bush."
	icon_state = "tree_1"
	layer = ABOVE_XENO_LAYER

/obj/structure/flora/bush/desert/cactus
	name = "cactus"
	desc = "It's a small, spiky cactus."
	icon_state = "cactus_3"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/desert/cactus/multiple
	name = "cacti"
	icon_state = "cacti_1"

/*

	POTTED PLANTS

*/

/obj/structure/flora/pottedplant
	name = "potted plant"
	icon = 'icons/obj/structures/props/plants.dmi'
	icon_state = "pottedplant_26"
	density = 0

/obj/structure/flora/pottedplant/random
	icon_tag = "pottedplant"
	variations = "30"

/*

	JUNGLE FOLIAGE

*/

/obj/structure/flora/jungle
	name = "jungle foliage"
	icon = 'icons/turf/ground_map.dmi'
	density = 0
	layer = ABOVE_XENO_LAYER


/obj/structure/flora/jungle/shrub
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon_state = "grass4"

/obj/structure/flora/jungle/plantbot1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "plantbot1"

/obj/structure/flora/jungle/planttop1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "planttop1"


/obj/structure/flora/jungle/treeblocker
	name = "huge tree"
	icon_state = ""	//will this break it?? - Nope
	density = 1

/obj/structure/flora/jungle/vines
	name = "vines"
	desc = "A mass of twisted vines."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "light_1"
	icon_tag = "light"
	variations = 3
	cut_level = PLANT_CUT_MACHETE
	fire_flag = FLORA_BURN_NO_SPREAD

/obj/structure/flora/jungle/vines/heavy
	desc = "A thick, coiled mass of twisted vines."
	opacity = 1
	icon_state = "heavy_6"
	icon_tag = "heavy"
	variations = 6

/obj/structure/flora/jungle/vines/heavy/New()
	..()
	icon_state = pick("heavy_1","heavy_2","heavy_3","heavy_4","heavy_5","heavy_6")

/obj/structure/flora/jungle/thickbush
	name = "dense vegetation"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'icons/obj/structures/props/jungleplants.dmi'
	icon_state = "bush_1"
	layer = BUSH_LAYER
	var/indestructable = 0
	var/stump = 0
	health = 100

/obj/structure/flora/jungle/thickbush/New()
	..()
	health = rand(50,75)
	if(prob(75))
		opacity = 1

	//Randomise a bit
	var/matrix/M = matrix()
	M.Turn(rand(1,360))
	M.Scale(pick(0.7,0.8,0.9,1,1.1,1.2),pick(0.7,0.8,0.9,1,1.1,1.2))
	src.apply_transform(M)


/obj/structure/flora/jungle/thickbush/Collided(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.loc = get_turf(src)
	else if (ismonkey(M))
		var/mob/A = M
		A.loc = get_turf(src)


/obj/structure/flora/jungle/thickbush/Crossed(atom/movable/AM)
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
						var/new_slowdown = H.next_move_slowdown + rand(2,3)
						H.next_move_slowdown = new_slowdown
						if(prob(2))
							to_chat(H, SPAN_WARNING("Moving through [src] slows you down."))
					if(5 to 7)
						var/new_slowdown = H.next_move_slowdown + rand(4,7)
						H.next_move_slowdown = new_slowdown
						if(prob(10))
							to_chat(H, SPAN_WARNING("It is very hard to move trough this [src]..."))
					if(8 to 9)
						var/new_slowdown = H.next_move_slowdown + rand(8,11)
						H.next_move_slowdown = new_slowdown
						to_chat(H, SPAN_WARNING("You got tangeled in [src]!"))
					if(10)
						var/new_slowdown = H.next_move_slowdown + rand(12,20)
						H.next_move_slowdown = new_slowdown
						to_chat(H, SPAN_WARNING("You got completely tangeled in [src]! Oh boy..."))

/obj/structure/flora/jungle/thickbush/attackby(obj/item/I as obj, mob/user as mob)
	//hatchets and shiet can clear away undergrowth
	if(I && (I.sharp >= IS_SHARP_ITEM_ACCURATE) && !stump)
		var/damage = rand(2,5)
		if(istype(I,/obj/item/weapon/melee/claymore/mercsword))
			damage = rand(8,18)
		if(indestructable)
			//this bush marks the edge of the map, you can't destroy it
			to_chat(user, SPAN_DANGER("You flail away at the undergrowth, but it's too thick here."))
		else
			user.visible_message(SPAN_DANGER("[user] flails away at the  [src] with [I]."),SPAN_DANGER("You flail away at the [src] with [I]."))
			playsound(src.loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
			health -= damage
			if(health < 0)
				to_chat(user, SPAN_NOTICE("You clear away [src]."))
			healthcheck()
	else
		return ..()

/obj/structure/flora/jungle/thickbush/proc/healthcheck()
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

/obj/structure/flora/jungle/thickbush/flamer_fire_act(var/dam = config.min_burnlevel)
	health -= dam
	healthcheck(src)


/obj/structure/flora/jungle/thickbush/jungle_plant
	icon_state = "plant_1"
	desc = "Looks like some of that fruit might be edible."
	icon_tag = "plant"
	variations  = 7

