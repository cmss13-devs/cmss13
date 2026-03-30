// ========================================== Prop stuff for new varadero
/obj/structure/prop/new_varadero_props
	icon = 'icons/obj/structures/props/landing_signs.dmi'
	icon_state = "new_varadero"

//---------------------WATER BUOYS, used for mostly boundary setting, animated to go up and down.
/obj/structure/prop/new_varadero_props/water_buoys
	name = "Water Buoy"
	desc = "It floats, slightly tilting as you look at it closer. "
	icon = 'icons/obj/structures/props/water_buoys.dmi'
	icon_state = "buoy"
	density = TRUE

/obj/structure/prop/new_varadero_props/water_buoys/striped
	icon_state = "buoy_striped"

/obj/structure/prop/new_varadero_props/water_buoys/rust
	icon_state = "buoy_rust"

/obj/structure/prop/new_varadero_props/water_buoys/small
	icon_state = "buoy_small"
	projectile_coverage = 20

/obj/structure/prop/new_varadero_props/water_buoys/small/small_striped
	icon_state = "buoy_small_striped"

/obj/structure/prop/new_varadero_props/water_buoys/small/small_rust
	icon_state = "buoy_small_rust"

//---------------------Concrete Seaweed
/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall
	name = "concrete wall"
	desc = "A concrete wall that has been berrated by the sea."
	icon = 'icons/obj/structures/props/seaweed_covered.dmi'
	icon_state = "seaweed"
	density = TRUE
	anchored = TRUE
	layer = WALL_LAYER

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/clean
	icon_state = "seaweed_clean"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/pattern_1
	icon_state = "seaweed0"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/pattern_2
	icon_state = "seaweed1"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/edge
	icon_state = "seaweed_east"
	density = FALSE

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/edge/west
	icon_state = "seaweed_west"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/edge/north
	icon_state = "seaweed1_north"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/half
	icon_state = "seaweed1_south"
	density = FALSE

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/half/pattern_1
	icon_state = "seaweed1_south_0"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/half/pattern_2
	icon_state = "seaweed1_south_1"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/half/edge
	icon_state = "seaweed1_east"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/half/edge/west
	icon_state = "seaweed1_west"

/obj/structure/prop/new_varadero_props/Seaweed_Covered_Wall/half/edge/north
	icon_state = "seaweed1_north"

//---------------------Airfield Tow Vehicle
/obj/structure/prop/new_varadero_props/tow_vehicle
	icon = 'icons/obj/structures/props/airfield_tow.dmi'
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER
	icon_state = "airfield_tow"
	name = "Pushback Tow"
	desc = "A ground support equipment vehicle made with the intent to haul cargo, airspace vehicles, and much more with precision."

/obj/structure/prop/new_varadero_props/tow_vehicle/tray
	icon_state = "airfield_cargo"
	layer = 4.0
	projectile_coverage = 5
	name = "Cargo Tray"
	desc = "A ground support equipment tray designed hold cargo and other anemities."

//---------------------Boulders
/obj/structure/prop/new_varadero_props/boulders
	icon = 'icons/obj/structures/props/natural/colorable_big_boulder.dmi'
	icon_state = "boulder_largedark1"

/obj/structure/prop/new_varadero_props/boulders/large_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/colorable_big_boulder.dmi'
	icon_state = "boulder_largedark1"
	density = TRUE
	bound_height = 64
	bound_width = 64

/obj/structure/prop/new_varadero_props/boulders/large_boulder/boulder_d1
	icon_state = "boulder_largedark1"

/obj/structure/prop/new_varadero_props/boulders/large_boulder/boulder_2
	icon_state = "boulder_largedark2"

/obj/structure/prop/new_varadero_props/boulders/large_boulder/boulder_3
	icon_state = "boulder_largedark3"

/obj/structure/prop/new_varadero_props/boulders/wide_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/colorable_long_boulder.dmi'
	icon_state = "boulderwidedark"
	density = TRUE
	bound_height = 32
	bound_width = 64

/obj/structure/prop/new_varadero_props/boulders/wide_boulder/wide_boulder1
	icon_state = "boulderwidedark"

/obj/structure/prop/new_varadero_props/boulders/wide_boulder/wide_boulder2
	icon_state = "boulderwidedark2"

/obj/structure/prop/new_varadero_props/boulders/smallboulder
	name = "boulder"
	icon_state = "bouldersmalldark1"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/colorable_small_boulder.dmi'
	density = TRUE

/obj/structure/prop/new_varadero_props/boulders/smallboulder/boulder_1
	icon_state = "bouldersmalldark1"

/obj/structure/prop/new_varadero_props/boulders/smallboulder/boulder_2
	icon_state = "bouldersmalldark2"

/obj/structure/prop/new_varadero_props/boulders/smallboulder/boulder_3
	icon_state = "bouldersmalldark3"

//---------------------Flora
/*
/obj/structure/flora/coastal_colorable //These are colorable as well
	icon = 'icons/obj/structures/props/natural/vegetation/more_grass_and_colorable_flora.dmi'
	density = FALSE
	icon_tag = null // Don't randomize

/obj/structure/flora/coastal_colorable/bush
	icon_state = "firstbush_1"

/obj/structure/flora/coastal_colorable/bush/one_1
	icon_state = "firstbush_2"

/obj/structure/flora/coastal_colorable/bush/one_2
	icon_state = "firstbush_3"

/obj/structure/flora/coastal_colorable/bush/one_3
	icon_state = "firstbush_4"

/obj/structure/flora/coastal_colorable/bush/reed
	icon_state = "reedbush_1"

/obj/structure/flora/coastal_colorable/bush/reed/two_1
	icon_state = "reedbush_2"

/obj/structure/flora/coastal_colorable/bush/reed/two_2
	icon_state = "reedbush_3"

/obj/structure/flora/coastal_colorable/bush/reed/two_3
	icon_state = "reedbush_4"

/obj/structure/flora/coastal_colorable/bush/pale
	icon_state = "palebush_1"
	fire_flag = FLORA_BURN_SPREAD_ONCE

/obj/structure/flora/coastal_colorable/bush/pale/three_1
	icon_state = "palebush_2"

/obj/structure/flora/coastal_colorable/bush/pale/three_2
	icon_state = "palebush_3"

/obj/structure/flora/coastal_colorable/bush/pale/three_3
	icon_state = "palebush_4"

/obj/structure/flora/coastal_colorable/bush/leafy
	icon_state = "leafybush_1"
	fire_flag = FLORA_BURN_SPREAD_ALL

/obj/structure/flora/coastal_colorable/bush/leafy/four_1
	icon_state = "leafybush_2"

/obj/structure/flora/coastal_colorable/bush/leafy/four_2
	icon_state = "leafybush_3"

/obj/structure/flora/coastal_colorable/bush/stalky
	icon_state = "stalkybush_1"
	cut_level = PLANT_CUT_MACHETE
	fire_flag = FLORA_NO_BURN

/obj/structure/flora/coastal_colorable/bush/stalky/five_1
	icon_state = "stalkybush_2"

/obj/structure/flora/coastal_colorable/bush/stalky/five_2
	icon_state = "stalkybush_3"

/obj/structure/flora/coastal_colorable/bush/grassy
	icon_state = "grassybush_1"

/obj/structure/flora/coastal_colorable/bush/grassy/six_1
	icon_state = "grassybush_2"

/obj/structure/flora/coastal_colorable/bush/grassy/six_2
	icon_state = "grassybush_3"

/obj/structure/flora/coastal_colorable/bush/grassy/six_3
	icon_state = "grassybush_4"

/obj/structure/flora/coastal_colorable/bush/fern
	icon_state = "fernybush_1"

/obj/structure/flora/coastal_colorable/bush/fern/seven_1
	icon_state = "fernybush_2"

/obj/structure/flora/coastal_colorable/bush/fern/seven_2
	icon_state = "fernybush_3"

/obj/structure/flora/coastal_colorable/bush/sunny
	icon_state = "sunnybush_1"

/obj/structure/flora/coastal_colorable/bush/sunny/eight_1
	icon_state = "sunnybush_2"

/obj/structure/flora/coastal_colorable/bush/sunny/eight_2
	icon_state = "sunnybush_3"

/obj/structure/flora/coastal_colorable/bush/generic
	icon_state = "genericbush_1"
	cut_level = PLANT_CUT_MACHETE

/obj/structure/flora/coastal_colorable/bush/generic/nine_1
	icon_state = "genericbush_2"

/obj/structure/flora/coastal_colorable/bush/generic/nine_2
	icon_state = "genericbush_3"

/obj/structure/flora/coastal_colorable/bush/generic/nine_3
	icon_state = "genericbush_4"

/obj/structure/flora/coastal_colorable/bush/pointy
	icon_state = "pointybush_1"
	cut_level = PLANT_CUT_MACHETE

/obj/structure/flora/coastal_colorable/bush/pointy/ten_1
	icon_state = "pointybush_2"

/obj/structure/flora/coastal_colorable/bush/pointy/ten_2
	icon_state = "pointybush_3"

/obj/structure/flora/coastal_colorable/bush/pointy/ten_3
	icon_state = "pointybush_4"

/obj/structure/flora/coastal_colorable/grass_pattern
	icon_state = "fullgrass_1"

/obj/structure/flora/coastal_colorable/grass_pattern/lavender
	icon_state = "lavendergrass_1"

/obj/structure/flora/coastal_colorable/grass_pattern/lavender/var1
	icon_state = "lavendergrass_2"

/obj/structure/flora/coastal_colorable/grass_pattern/lavender/var2
	icon_state = "lavendergrass_3"

/obj/structure/flora/coastal_colorable/grass_pattern/lavender/var3
	icon_state = "lavendergrass_4"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_1
	icon_state = "ywflowers_1"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_1/var1
	icon_state = "ywflowers_2"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_1/var2
	icon_state = "ywflowers_3"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_1/var3
	icon_state = "ywflowers_4"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_2
	icon_state = "brflowers_1"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_2/var1
	icon_state = "brflowers_2"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_2/var2
	icon_state = "brflowers_3"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_3
	icon_state = "ppflowers_1"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_3/var1
	icon_state = "ppflowers_2"

/obj/structure/flora/coastal_colorable/grass_pattern/flower_3/var2
	icon_state = "ppflowers_3"

/obj/structure/flora/coastal_colorable/grass_pattern/sparse
	icon_state = "sparsegrass_1"

/obj/structure/flora/coastal_colorable/grass_pattern/sparse/var1
	icon_state = "sparsegrass_2"

/obj/structure/flora/coastal_colorable/grass_pattern/sparse/var2
	icon_state = "sparsegrass_3"

/obj/structure/flora/coastal_colorable/grass_pattern/full
	icon_state = "fullgrass_1"

/obj/structure/flora/coastal_colorable/grass_pattern/full/var1
	icon_state = "fullgrass_2"

/obj/structure/flora/coastal_colorable/grass_pattern/full/var2
	icon_state = "fullgrass_3"
*/

//---------------------AA Guns, not the actual AA gun shooting


/obj/structure/prop/new_varadero_props/aa_gun
	icon = 'icons/obj/structures/props/aa_turret/aa.dmi'
	icon_state = "aa_base"
	bound_height = 64
	bound_width = 64
	pixel_x = -48
	pixel_y = -41
	density = TRUE
	layer = ABOVE_MOB_LAYER
	var/damage_state = 0
	var/brute_multiplier = 3

/obj/structure/prop/new_varadero_props/aa_gun/attack_alien(mob/living/carbon/xenomorph/user)
	user.animation_attack_on(src)
	take_damage( rand(user.melee_damage_lower, user.melee_damage_upper) * brute_multiplier)
	playsound(src, 'sound/effects/metalscrape.ogg', 20, 1)
	if(health <= 0)
		user.visible_message(SPAN_DANGER("[user] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		user.visible_message(SPAN_DANGER("[user] [user.slashes_verb] [src]!"),
		SPAN_DANGER("We [user.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_icon()
	return XENO_ATTACK_ACTION

/obj/structure/prop/new_varadero_props/aa_gun/proc/explode(dam, mob/M)
	visible_message(SPAN_DANGER("[src] blows apart!"), max_distance = 1)
	playsound(loc, 'sound/effects/car_crush.ogg', 20)
	var/turf/Tsec = get_turf(src)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/sheet/metal(Tsec)
	new /obj/item/stack/sheet/metal(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	new /obj/effect/spawner/gibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	deconstruct(FALSE)
/obj/structure/prop/new_varadero_props/aa_gun/proc/take_damage(dam, mob/M)
	if(health) //Prevents unbreakable objects from being destroyed
		health -= dam
		if(health <= 0)
			explode()
		else
			update_icon()

/obj/structure/prop/new_varadero_props/aa_gun/bullet_act(obj/projectile/P)
	if(P.ammo.damage)
		take_damage(P.ammo.damage)
		playsound(src, 'sound/effects/metalping.ogg', 35, 1)
		update_icon()

/obj/structure/prop/new_varadero_props/aa_gun/base
	icon_state = "aa_base"
	name = "M35 Mounting Rig"
	desc = "The M35 Mounting System is a multipurpose mounting rig designed for rapid deployment of large scale crew served or automated defensive systems. Featuring an adjustable turret ring with 360 coverage, the M35 can be utilized with a surprising number of emplacements."
	health = 9000
	projectile_coverage = 85

/obj/structure/prop/new_varadero_props/aa_gun/base/get_examine_text(mob/user)
	. = ..()
	switch(health)
		if(1750 to 9000)
			. += SPAN_WARNING("It looks to be in good condition.")
		if(0 to 1750)
			. += SPAN_WARNING("It looks like it's about to turn into scrap.")

/obj/structure/prop/new_varadero_props/aa_gun/turret_heavy
	icon_state = "aa_turret"
	name = "M87 Emplaced Anti-Air Battery"
	desc = "The M87 Emplaced Anti-Air battery is an ARMAT designed dual-linked 45mm cannon system. Featuring automated smart guidance munitions as well as an integrated targeting computer, it is a light weight yet deadly system for low to mid distance flying targets."
	layer = 4.15
	health = 6000
	projectile_coverage = 65

/obj/structure/prop/new_varadero_props/aa_gun/turret_heavy/get_examine_text(mob/user)
	. = ..()
	switch(health)
		if(1250 to 6000)
			. += SPAN_WARNING("It looks to be in good condition.")
		if(0 to 1250)
			. += SPAN_WARNING("It looks like it's about to turn into scrap.")

/obj/structure/prop/new_varadero_props/aa_gun/turret_heavy/up
	icon_state = "aa_turret_up"

/obj/structure/prop/new_varadero_props/aa_gun/wreck
	icon_state = "aa_base_wreck"
	desc = "The M87 Emplaced Anti-Air battery is an ARMAT designed dual-linked 45mm cannon system. Featuring automated smart guidance munitions as well as an integrated targeting computer, it is a light weight yet deadly system for low to mid distance flying targets. This appears to be in a terrible state!"

/obj/structure/prop/new_varadero_props/aa_gun/wreck/base
	health = 1750
	projectile_coverage = 55

/obj/structure/prop/new_varadero_props/aa_gun/wreck/turret
	icon_state = "aa_turret_wreck"
	health = 1500
	projectile_coverage = 45

/obj/structure/prop/new_varadero_props/egg_open
	name = "egg"
	desc = "It looks like a weird egg, this one has been open for a long time."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "Egg Opened"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/new_varadero_props/egg_destroyed
	name = "egg"
	desc = "It looks like a weird egg, this one has been destroyed for a long time."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "Egg Exploded"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/new_varadero_props/radar_dish
	icon = 'icons/obj/structures/props/radar_prop.dmi'
	icon_state = "radar_dish"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/new_varadero_props/radar_dish_lights
	icon = 'icons/obj/structures/props/radar_prop.dmi'
	icon_state = "radar_dish_lightglow"

/obj/structure/prop/new_varadero_props/big_gun
	icon = 'icons/obj/structures/props/big_gun/icon_cannon.dmi'
	icon_state = "cannon"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/new_varadero_props/big_gun/barrel
	icon_state = "cannon1"

/obj/structure/prop/new_varadero_props/big_gun/lights
	icon_state = "cannon_lightglow"

/obj/structure/prop/new_varadero_props/big_gun/testing
	icon = 'icons/obj/structures/props/big_gun/testcannon.dmi'
	icon_state = "testcannon"



