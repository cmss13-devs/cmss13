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
	anchored = TRUE
	density = TRUE
	var/icon_tag = null
	var/variations = 1
	var/cut_level = PLANT_NO_CUT
	var/cut_hits = 3
	var/fire_flag = FLORA_NO_BURN
	var/center = TRUE //Determine if we want less or more ash when burned
	var/burning = FALSE

/obj/structure/flora/Initialize()
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
		return ATTACKBY_HINT_UPDATE_NEXT_MOVE
	else
		. = ..()

/obj/structure/flora/flamer_fire_act()
	fire_act()

/obj/structure/flora/fire_act()
	if(QDELETED(src) || (fire_flag & FLORA_NO_BURN) || burning)
		return
	burning = TRUE
	var/spread_time = rand(75, 150)
	if(!(fire_flag & FLORA_BURN_NO_SPREAD))
		addtimer(CALLBACK(src, PROC_REF(spread_fire)), spread_time)
	addtimer(CALLBACK(src, PROC_REF(burn_up)), spread_time + 5 SECONDS)

/obj/structure/flora/proc/spread_fire()
	SIGNAL_HANDLER
	for(var/D in GLOB.cardinals) //Spread fire
		var/turf/T = get_step(src.loc, D)
		if(T)
			for(var/obj/structure/flora/F in T)
				if(fire_flag & FLORA_BURN_SPREAD_ONCE)
					F.fire_flag |= FLORA_BURN_NO_SPREAD
				if(!(locate(/obj/flamer_fire) in T))
					new /obj/flamer_fire(T, create_cause_data("wildfire"))

/obj/structure/flora/proc/burn_up()
	SIGNAL_HANDLER
	new /obj/effect/decal/cleanable/dirt(loc)
	if(center)
		new /obj/effect/decal/cleanable/dirt(loc) //Produces more ash at the center
	qdel(src)

/obj/structure/flora/ex_act(power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		deconstruct(FALSE)

/obj/structure/flora/get_projectile_hit_boolean(obj/projectile/P)
	. = ..()
	return FALSE

//trees
/obj/structure/flora/tree
	name = "tree"
	pixel_x = -16
	layer = ABOVE_FLY_LAYER

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/structures/props/natural/vegetation/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/structures/props/natural/vegetation/pinetrees.dmi'
	icon_state = "pine_c"

//dead
/obj/structure/flora/tree/dead
	icon = 'icons/obj/structures/props/natural/vegetation/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/tree_1
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/tree_2
	icon_state = "tree_2"

/obj/structure/flora/tree/dead/tree_3
	icon_state = "tree_3"

/obj/structure/flora/tree/dead/tree_4
	icon_state = "tree_4"

/obj/structure/flora/tree/dead/tree_5
	icon_state = "tree_5"

/obj/structure/flora/tree/dead/tree_6
	icon_state = "tree_6"

//joshua
/obj/structure/flora/tree/joshua
	name = "joshua tree"
	desc = "A tall tree covered in spiky-like needles, covering its trunk."
	icon = 'icons/obj/structures/props/natural/vegetation/joshuatree.dmi'
	icon_state = "joshua_1"
	pixel_x = 0
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/flora/tree/jungle
	name = "huge tree"
	icon = 'icons/obj/structures/props/natural/vegetation/ground_map64.dmi'
	desc = "What an enormous tree!"
	density = FALSE
	layer = ABOVE_XENO_LAYER

// LV-624's Yggdrasil Tree
/obj/structure/flora/tree/jungle/bigtreeTR
	icon_state = "bigtreeTR"

/obj/structure/flora/tree/jungle/bigtreeTL
	icon_state = "bigtreeTL"

/obj/structure/flora/tree/jungle/bigtreeBOT
	icon_state = "bigtreeBOT"

//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/structures/props/natural/vegetation/ausflora.dmi'
	density = FALSE
	fire_flag = FLORA_BURN_NO_SPREAD
/*

ICE GRASS

*/

/obj/structure/flora/grass/ice
	icon = 'icons/obj/structures/props/natural/vegetation/snowflora.dmi'
	icon_state = null
	variations = 3

//brown
/obj/structure/flora/grass/ice/brown
	icon_state = "snowgrassbb_1"
	icon_tag = "snowgrassbb"

/obj/structure/flora/grass/ice/brown/snowgrassbb_1
	icon_state = "snowgrassbb_1"
	icon_tag = null // Don't randomize

/obj/structure/flora/grass/ice/brown/snowgrassbb_2
	icon_state = "snowgrassbb_2"
	icon_tag = null // Don't randomize

/obj/structure/flora/grass/ice/brown/snowgrassbb_3
	icon_state = "snowgrassbb_3"
	icon_tag = null // Don't randomize

//green
/obj/structure/flora/grass/ice/green
	icon_state = "snowgrassgb_1"
	icon_tag = "snowgrassgb"

//both
/obj/structure/flora/grass/ice/both
	icon_state = "snowgrassall_1"
	icon_tag = "snowgrassall"

/*

ICEY GRASS. IT LOOKS LIKE IT'S MADE OF ICE.

*/

/obj/structure/flora/grass/ice/icey
	icon_state = "icegrass_5" //full patch of grass
	icon_tag = "icegrass"
	variations = 5

/obj/structure/flora/grass/ice/icey/eightdirection
	icon_state = "icegrass_1" //8 different directional states.
	icon_tag = null // Don't randomize

/obj/structure/flora/grass/ice/icey/fourdirection
	icon_state = "icegrass_2" //4 different directional states
	icon_tag = null // Don't randomize

/obj/structure/flora/grass/ice/icey/center
	icon_state = "icegrass_3" //1 center piece of grass
	icon_tag = null // Don't randomize

/obj/structure/flora/grass/ice/icey/centerfull
	icon_state = "icegrass_4" //More grass.
	icon_tag = null // Don't randomize

/obj/structure/flora/grass/ice/icey/full
	icon_state = "icegrass_5" //full patch of grass
	icon_tag = null // Don't randomize


/*
	DESERT GRASS

*/

//Light desert grass

/obj/structure/flora/grass/desert
	icon = 'icons/obj/structures/props/natural/vegetation/dam.dmi'
	icon_state = "lightgrass_1"

// to replace with
/obj/structure/flora/grass/desert/lightgrass_1
	icon_state = "lightgrass_1"

/obj/structure/flora/grass/desert/lightgrass_2
	icon_state = "lightgrass_2"

/obj/structure/flora/grass/desert/lightgrass_3
	icon_state = "lightgrass_3"

/obj/structure/flora/grass/desert/lightgrass_4
	icon_state = "lightgrass_4"

/obj/structure/flora/grass/desert/lightgrass_5
	icon_state = "lightgrass_5"

/obj/structure/flora/grass/desert/lightgrass_6
	icon_state = "lightgrass_6"

/obj/structure/flora/grass/desert/lightgrass_7
	icon_state = "lightgrass_7"

/obj/structure/flora/grass/desert/lightgrass_8
	icon_state = "lightgrass_8"

/obj/structure/flora/grass/desert/lightgrass_9
	icon_state = "lightgrass_9"

/obj/structure/flora/grass/desert/lightgrass_10
	icon_state = "lightgrass_10"

/obj/structure/flora/grass/desert/lightgrass_11
	icon_state = "lightgrass_11"

/obj/structure/flora/grass/desert/lightgrass_12
	icon_state = "lightgrass_12"

//heavy desert grass
/obj/structure/flora/grass/desert/heavy
	icon_state = "heavygrass_1"

/obj/structure/flora/grass/desert/heavygrass_1
	icon_state = "heavygrass_1"

/obj/structure/flora/grass/desert/heavygrass_2
	icon_state = "heavygrass_2"

/obj/structure/flora/grass/desert/heavygrass_3
	icon_state = "heavygrass_3"

/obj/structure/flora/grass/desert/heavygrass_4
	icon_state = "heavygrass_4"

/obj/structure/flora/grass/desert/heavygrass_5
	icon_state = "heavygrass_5"

/obj/structure/flora/grass/desert/heavygrass_6
	icon_state = "heavygrass_6"

/obj/structure/flora/grass/desert/heavygrass_7
	icon_state = "heavygrass_7"

/obj/structure/flora/grass/desert/heavygrass_8
	icon_state = "heavygrass_8"

/obj/structure/flora/grass/desert/heavygrass_9
	icon_state = "heavygrass_9"

/obj/structure/flora/grass/desert/heavygrass_10
	icon_state = "heavygrass_10"

/*

	TALLGRASS - SPREADS FIRES

*/

/obj/structure/flora/grass/tallgrass
	name = "tallgrass"
	icon = 'icons/obj/structures/props/natural/vegetation/tallgrass.dmi'
	unslashable = TRUE
	unacidable = TRUE
	cut_level = PLANT_CUT_MACHETE
	var/overlay_type = "tallgrass_overlay"

/obj/structure/flora/grass/tallgrass/Initialize()
	. = ..()
	update_icon()

/obj/structure/flora/grass/tallgrass/update_icon()
	..()
	overlays.Cut()
	overlays += image("icon"=src.icon,"icon_state"=overlay_type,"layer"=ABOVE_XENO_LAYER,"dir"=dir)

// MAP VARIANTS //
// PARENT FOR COLOR, CORNERS AND CENTERS, BASED ON DIRECTIONS //

//TRIJENT - WHISKEY OUTPOST//
/obj/structure/flora/grass/tallgrass/desert
	//color = COLOR_G_DES
	icon = 'icons/obj/structures/props/natural/vegetation/dam.dmi' //Override since the greyscale can't match
	icon_state = "tallgrass"
	fire_flag = FLORA_BURN_SPREAD_ALL

/obj/structure/flora/grass/tallgrass/desert/corner
	icon_state = "tallgrass_corner"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

//ICE COLONY - SOROKYNE//
/obj/structure/flora/grass/tallgrass/ice
	color = COLOR_G_ICE
	icon_state = "tallgrass"
	desc = "A large swathe of bristling snowgrass"

/obj/structure/flora/grass/tallgrass/ice/corner
	icon_state = "tallgrass_corner"
	overlay_type = "tallgrass_overlay_corner"
	center = FALSE

//LV - JUNGLE MAPS//

/obj/structure/flora/grass/tallgrass/jungle
	color = COLOR_G_JUNG
	icon_state = "tallgrass"
	desc = "A clump of vibrant jungle grasses"
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
	icon = 'icons/obj/structures/props/natural/vegetation/snowflora.dmi'
	icon_state = "snowbush_1"
	density = FALSE
	layer = ABOVE_XENO_LAYER
	fire_flag = FLORA_BURN_NO_SPREAD

/obj/structure/flora/bush/snow
	icon_tag = "snowbush"
	variations = 6

/*

	AUSBUSHES

*/

/obj/structure/flora/bush/ausbushes
	icon = 'icons/obj/structures/props/natural/vegetation/ausflora.dmi'
	icon_state = "firstbush_1"
	variations = 4
	cut_level = PLANT_CUT_KNIFE
	projectile_coverage = 0//CEASE EATING BULLETS, I BEG YOU

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

/obj/structure/flora/bush/ausbushes/ywflowers
	icon_state = "ywflowers_1"
	icon_tag = "ywflowers"
	layer = BELOW_MOB_LAYER

/*

	AUSBUSHES (3 VARIATIONS)

*/


/obj/structure/flora/bush/ausbushes/var3
	icon_state = "leafybush_1"
	cut_level = PLANT_CUT_KNIFE
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

/obj/structure/flora/bush/ausbushes/var3/brflowers
	icon_state = "brflowers_1"
	icon_tag = "brflowers"
	layer = BELOW_MOB_LAYER

/obj/structure/flora/bush/ausbushes/var3/ppflowers
	icon_state = "ppflowers_1"
	icon_tag = "ppflowers"
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
	icon = 'icons/obj/structures/props/natural/vegetation/dam.dmi'
	desc = "A small, leafy bush."
	icon_state = "tree_1"
	cut_level = PLANT_CUT_KNIFE
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
	icon = 'icons/obj/structures/props/natural/vegetation/plants.dmi'
	icon_state = "pottedplant_26"
	density = FALSE
	var/stashed_item
	var/static/possible_starting_items = list(/obj/item/clothing/mask/cigarette/weed, /obj/item/clothing/mask/cigarette, /obj/item/clothing/mask/cigarette/bcigarette) //breaking bad reference
	/// For things that might affect someone/everyone's round if hidden.
	var/static/blocked_atoms = list(/obj/item/device/cotablet, /obj/item/card/id)
	var/static/blacklist_typecache

/obj/structure/flora/pottedplant/Initialize(mapload)
	. = ..()

	if(!blacklist_typecache)
		blacklist_typecache = typecacheof(blocked_atoms)

	if(prob(5))
		var/prestashed_item = pick(possible_starting_items)
		stashed_item = new prestashed_item(src)

/obj/structure/flora/pottedplant/attackby(obj/item/stash, mob/user)
	if(stashed_item)
		to_chat(user, SPAN_WARNING("There's already something stashed here!"))
		return

	if(is_type_in_typecache(stash, blacklist_typecache))
		to_chat(user, SPAN_WARNING("You probably shouldn't hide [stash] in [src]."))
		return

	if(stash.w_class == SIZE_TINY)
		user.drop_inv_item_to_loc(stash, src)
		stashed_item = stash
		user.visible_message("[user] puts something in [src].", "You hide [stash] in [src].")
		return

	to_chat(user, SPAN_WARNING("[stash] is too big to fit into [src]!"))

/obj/structure/flora/pottedplant/attack_hand(mob/user)
	if(!stashed_item)
		return
	user.put_in_hands(contents[1])
	user.visible_message( "[user] takes something out of [src].", "You take [stashed_item] from [src].")
	stashed_item = null

/obj/structure/flora/pottedplant/Destroy()
	if(stashed_item)
		QDEL_NULL(stashed_item)
	return ..()
/obj/structure/flora/pottedplant/random
	icon_tag = "pottedplant"
	variations = "30"

/obj/structure/flora/pottedplant/random/unanchored
	anchored = FALSE

/*

	JUNGLE FOLIAGE

*/

/obj/structure/flora/jungle
	name = "jungle foliage"
	icon = 'icons/turf/ground_map.dmi'
	density = FALSE
	layer = ABOVE_XENO_LAYER
	projectile_coverage = PROJECTILE_COVERAGE_NONE

/obj/structure/flora/jungle/shrub
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon_state = "grass4"

/obj/structure/flora/jungle/plantbot1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "plantbot1"

/obj/structure/flora/jungle/cart_wreck
	name = "old janicart"
	desc = "Doesn't look like it'll do much cleaning any more."
	icon_state = "cart_wreck"

/obj/structure/flora/jungle/alienplant1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "alienplant1"
	light_range = 2

/obj/structure/flora/jungle/planttop1
	name = "strange tree"
	desc = "Some kind of bizarre alien tree. It oozes with a sickly yellow sap."
	icon_state = "planttop1"


/obj/structure/flora/jungle/treeblocker
	name = "huge tree"
	icon_state = "" //will this break it?? - Nope
	density = TRUE

//light vines
/obj/structure/flora/jungle/vines
	name = "vines"
	desc = "A mass of twisted vines."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "light_1"
	icon_tag = "light"
	variations = 3
	cut_level = PLANT_CUT_MACHETE
	fire_flag = FLORA_BURN_NO_SPREAD

/obj/structure/flora/jungle/vines/light_1
	icon_state = "light_1"
	icon_tag = "light"

/obj/structure/flora/jungle/vines/light_2
	icon_state = "light_2"
	icon_tag = "light"

/obj/structure/flora/jungle/vines/light_3
	icon_state = "light_3"
	icon_tag = "light"

//heavy hide you
/obj/structure/flora/jungle/vines/heavy
	desc = "A thick, coiled mass of twisted vines."
	opacity = TRUE
	icon_state = "heavy_6"
	icon_tag = "heavy"
	variations = 6

/obj/structure/flora/jungle/vines/heavy/New()
	..()
	icon_state = pick("heavy_1","heavy_2","heavy_3","heavy_4","heavy_5","heavy_6")

/obj/structure/flora/jungle/thickbush
	name = "dense vegetation"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'icons/obj/structures/props/natural/vegetation/jungleplants.dmi'
	icon_state = "bush_1"
	layer = BUSH_LAYER
	var/indestructable = 0
	var/stump = 0
	health = 100

/obj/structure/flora/jungle/thickbush/New()
	..()
	health = rand(50,75)
	if(prob(75))
		opacity = TRUE
	setDir(pick(NORTH,EAST,SOUTH,WEST))


/obj/structure/flora/jungle/thickbush/Collided(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.forceMove(get_turf(src))
	else if (ismonkey(M))
		var/mob/A = M
		A.forceMove(get_turf(src))


/obj/structure/flora/jungle/thickbush/Crossed(atom/movable/AM)
	if(!stump)
		if(isliving(AM))
			var/mob/living/L = AM
			var/bush_sound_prob = 60
			if(istype(L, /mob/living/carbon/xenomorph))
				var/mob/living/carbon/xenomorph/X = L
				bush_sound_prob = X.tier * 20

			if(prob(bush_sound_prob))
				var/sound = pick('sound/effects/vegetation_walk_0.ogg','sound/effects/vegetation_walk_1.ogg','sound/effects/vegetation_walk_2.ogg')
				playsound(src.loc, sound, 25, 1)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/stuck = rand(0,10)
				if(HAS_TRAIT(L, TRAIT_HAULED))
					return
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
		if(istype(I,/obj/item/weapon/sword))
			damage = rand(8,18)
		if(indestructable)
			//this bush marks the edge of the map, you can't destroy it
			to_chat(user, SPAN_DANGER("You flail away at the undergrowth, but it's too thick here."))
		else
			user.visible_message(SPAN_DANGER("[user] flails away at [src] with [I]."), SPAN_DANGER("You flail away at [src] with [I]."))
			playsound(src.loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
			health -= damage
			if(health < 0)
				to_chat(user, SPAN_NOTICE("You clear away [src]."))
			healthcheck()
	else
		return ..()

/obj/structure/flora/jungle/thickbush/proc/healthcheck()
	if(health < 35 && opacity)
		opacity = FALSE
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

/obj/structure/flora/jungle/thickbush/flamer_fire_act(dam = BURN_LEVEL_TIER_1)
	health -= dam
	healthcheck(src)


/obj/structure/flora/jungle/thickbush/jungle_plant
	icon_state = "plant_1"
	desc = "Looks like some of that fruit might be edible."
	icon_tag = "plant"
	variations  = 7
