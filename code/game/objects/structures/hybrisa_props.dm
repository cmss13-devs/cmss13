// Hybrisa props



/obj/structure/prop/hybrisa
	icon = 'icons/obj/structures/props/vehicles/small_truck_red.dmi'
	icon_state = "pimp"

// Vehicles

/obj/structure/prop/hybrisa/vehicles
	icon = 'icons/obj/structures/props/vehicles/meridian_red.dmi'
	icon_state = "meridian_red"
	health = 3000
	var/damage_state = 0
	var/brute_multiplier = 3

/obj/structure/prop/hybrisa/vehicles/attack_alien(mob/living/carbon/xenomorph/user)
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

/obj/structure/prop/hybrisa/vehicles/update_icon()
	switch(health)
		if(2500 to 3000)
			icon_state = initial(icon_state)
			return
		if(2000 to 2500)
			damage_state = 1
		if(1500 to 2000)
			damage_state = 2
		if(1000 to 1500)
			damage_state = 3
		if(500 to 1000)
			damage_state = 4
		if(0 to 500)
			damage_state = 5
	icon_state = "[initial(icon_state)]_damage_[damage_state]"

/obj/structure/prop/hybrisa/vehicles/get_examine_text(mob/user)
	. = ..()
	switch(health)
		if(2500 to 3000)
			. += SPAN_WARNING("It looks to be in good condition.")
		if(2000 to 2500)
			. += SPAN_WARNING("It looks slightly damaged.")
		if(1500 to 2000)
			. += SPAN_WARNING("It looks moderately damaged.")
		if(1000 to 1500)
			. += SPAN_DANGER("It looks heavily damaged.")
		if(500 to 1000)
			. += SPAN_DANGER("It looks very heavily damaged.")
		if(0 to 500)
			. += SPAN_DANGER("It looks like it's about break down into scrap.")

/obj/structure/prop/hybrisa/vehicles/proc/explode(dam, mob/M)
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
/obj/structure/prop/hybrisa/vehicles/proc/take_damage(dam, mob/M)
	if(health) //Prevents unbreakable objects from being destroyed
		health -= dam
		if(health <= 0)
			explode()
		else
			update_icon()

/obj/structure/prop/hybrisa/vehicles/bullet_act(obj/projectile/P)
	if(P.ammo.damage)
		take_damage(P.ammo.damage)
		playsound(src, 'sound/effects/metalping.ogg', 35, 1)
		update_icon()

// Armored Truck - Damage States
/obj/structure/prop/hybrisa/vehicles/Armored_Truck
	name = "heavy-loader truck"
	desc = "It's locked and seems to be broken down, forget driving this."
	icon = 'icons/obj/structures/props/vehicles/armored_truck_wy_black.dmi'
	icon_state = "armored_truck_wy_black"
	bound_height = 64
	bound_width = 96
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/Blue
	icon = 'icons/obj/structures/props/vehicles/armored_truck_blue.dmi'
	icon_state = "armored_truck_blue"

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/Teal
	icon = 'icons/obj/structures/props/vehicles/armored_truck_teal.dmi'
	icon_state = "armored_truck_teal"

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/White
	icon = 'icons/obj/structures/props/vehicles/armored_truck_white.dmi'
	icon_state = "armored_truck_white"

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/WY_Black
	name = "Weyland-Yutani security truck"
	icon = 'icons/obj/structures/props/vehicles/armored_truck_wy_black.dmi'
	icon_state = "armored_truck_wy_black"

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/WY_White
	name = "Weyland-Yutani security truck"
	icon = 'icons/obj/structures/props/vehicles/armored_truck_wy_white.dmi'
	icon_state = "armored_truck_wy_white"

// Ambulance - Damage States
/obj/structure/prop/hybrisa/vehicles/Ambulance
	name = "ambulance"
	desc = "It's locked and seems to be broken down, forget driving this."
	icon = 'icons/obj/structures/props/vehicles/ambulance.dmi'
	icon_state = "ambulance"
	bound_height = 64
	bound_width = 96
	density = TRUE
	layer = ABOVE_MOB_LAYER

// Long Hauler Truck - Damage States
/obj/structure/prop/hybrisa/vehicles/Long_Truck
	name = "long-hauler truck"
	desc = "It's locked and seems to be broken down, forget driving this."
	icon = 'icons/obj/structures/props/vehicles/long_truck_wy_blue.dmi'
	icon_state = "longtruck_wy_blue"
	bound_height = 64
	bound_width = 128
	density = TRUE

/obj/structure/prop/hybrisa/vehicles/Long_Truck/Blue
	icon = 'icons/obj/structures/props/vehicles/long_truck_blue.dmi'
	icon_state = "longtruck_blue"

/obj/structure/prop/hybrisa/vehicles/Long_Truck/Red
	icon = 'icons/obj/structures/props/vehicles/long_truck_red.dmi'
	icon_state = "longtruck_red"

/obj/structure/prop/hybrisa/vehicles/Long_Truck/Brown
	icon = 'icons/obj/structures/props/vehicles/long_truck_brown.dmi'
	icon_state = "longtruck_brown"

/obj/structure/prop/hybrisa/vehicles/Long_Truck/Kelland_Mining
	icon = 'icons/obj/structures/props/vehicles/long_truck_kelland.dmi'
	icon_state = "longtruck_kelland"

/obj/structure/prop/hybrisa/vehicles/Long_Truck/Donk
	icon = 'icons/obj/structures/props/vehicles/long_truck_donk.dmi'
	icon_state = "longtruck_donk"

/obj/structure/prop/hybrisa/vehicles/Long_Truck/WY_Blue
	icon = 'icons/obj/structures/props/vehicles/long_truck_wy_blue.dmi'
	icon_state = "longtruck_wy_blue"

/obj/structure/prop/hybrisa/vehicles/Long_Truck/WY_Black
	icon = 'icons/obj/structures/props/vehicles/long_truck_wy_black.dmi'
	icon_state = "longtruck_wy_black"

// Small Truck - Damage States
/obj/structure/prop/hybrisa/vehicles/Small_Truck
	name = "small truck"
	desc = "It's locked and seems to be broken down, forget driving this."
	icon = 'icons/obj/structures/props/vehicles/small_truck_turquoise_cargo.dmi'
	icon_state = "small_truck_turquoise_cargo"
	bound_height = 32
	bound_width = 64
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Turquoise_Cargo
	icon = 'icons/obj/structures/props/vehicles/small_truck_turquoise_cargo.dmi'
	icon_state = "small_truck_turquoise_cargo"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/White
	icon = 'icons/obj/structures/props/vehicles/small_truck_white.dmi'
	icon_state = "small_truck_white"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/White_Cargo
	icon = 'icons/obj/structures/props/vehicles/small_truck_white_cargo.dmi'
	icon_state = "small_truck_white_cargo"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Mining
	icon = 'icons/obj/structures/props/vehicles/small_truck_mining.dmi'
	icon_state = "small_truck_mining"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Blue
	icon = 'icons/obj/structures/props/vehicles/small_truck_blue.dmi'
	icon_state = "small_truck_blue"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Red
	icon = 'icons/obj/structures/props/vehicles/small_truck_red.dmi'
	icon_state = "small_truck_red"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Brown
	icon = 'icons/obj/structures/props/vehicles/small_truck_brown.dmi'
	icon_state = "small_truck_brown"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Green
	icon = 'icons/obj/structures/props/vehicles/small_truck_green.dmi'
	icon_state = "small_truck_green"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Garbage
	icon = 'icons/obj/structures/props/vehicles/small_truck_garbage.dmi'
	icon_state = "small_truck_garbage"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Brown_Cargo
	icon = 'icons/obj/structures/props/vehicles/small_truck_brown_cargo.dmi'
	icon_state = "small_truck_brown_cargo"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Blue_Cargo
	icon = 'icons/obj/structures/props/vehicles/small_truck_blue_cargo.dmi'
	icon_state = "small_truck_blue_cargo"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Medical_Cargo
	icon = 'icons/obj/structures/props/vehicles/small_truck_medical.dmi'
	icon_state = "small_truck_medical"

/obj/structure/prop/hybrisa/vehicles/Small_Truck/Brown_Cargo_Barrels
	icon = 'icons/obj/structures/props/vehicles/small_truck_brown_cargobarrels.dmi'
	icon_state = "small_truck_brown_cargobarrels"

// Box Vans - Damage States
/obj/structure/prop/hybrisa/vehicles/Box_Vans
	name = "box van"
	desc = "It's locked and seems to be broken down, forget driving this."
	icon = 'icons/obj/structures/props/vehicles/box_van_hyperdyne.dmi'
	icon_state = "box_van_hyperdyne"
	bound_height = 32
	bound_width = 64
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/vehicles/Box_Vans/Hyperdyne
	icon = 'icons/obj/structures/props/vehicles/box_van_hyperdyne.dmi'
	icon_state = "box_van_hyperdyne"

/obj/structure/prop/hybrisa/vehicles/Box_Vans/White
	icon = 'icons/obj/structures/props/vehicles/box_van_white.dmi'
	icon_state = "box_van_white"

/obj/structure/prop/hybrisa/vehicles/Box_Vans/Blue_Grey
	icon = 'icons/obj/structures/props/vehicles/box_van_bluegrey.dmi'
	icon_state = "box_van_bluegrey"

/obj/structure/prop/hybrisa/vehicles/Box_Vans/Kelland_Mining
	icon = 'icons/obj/structures/props/vehicles/box_van_kellandmining.dmi'
	icon_state = "box_van_kellandmining"

/obj/structure/prop/hybrisa/vehicles/Box_Vans/Maintenance_Blue
	icon = 'icons/obj/structures/props/vehicles/box_van_maintenanceblue.dmi'
	icon_state = "box_van_maintenanceblue"

/obj/structure/prop/hybrisa/vehicles/Box_Vans/Pizza
	icon = 'icons/obj/structures/props/vehicles/box_van_pizza.dmi'
	icon_state = "box_van_pizza"

// Meridian Cars - Damage States
/obj/structure/prop/hybrisa/vehicles/Meridian
	name = "Mono-Spectra"
	desc = "The 'Mono-Spectra', a mass-produced civilian vehicle for the colonial markets, in and outside of the United Americas. Produced by 'Meridian' a car marque and associated operating division of the Weyland-Yutani Corporation."
	icon = 'icons/obj/structures/props/vehicles/meridian_red.dmi'
	icon_state = "meridian_red"
	bound_height = 32
	bound_width = 64
	density = TRUE
	layer = ABOVE_MOB_LAYER
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	throwpass = TRUE

/obj/structure/prop/hybrisa/vehicles/Meridian/Red
	icon = 'icons/obj/structures/props/vehicles/meridian_red.dmi'
	icon_state = "meridian_red"

/obj/structure/prop/hybrisa/vehicles/Meridian/Black
	icon = 'icons/obj/structures/props/vehicles/meridian_black.dmi'
	icon_state = "meridian_black"

/obj/structure/prop/hybrisa/vehicles/Meridian/Blue
	icon = 'icons/obj/structures/props/vehicles/meridian_blue.dmi'
	icon_state = "meridian_blue"

/obj/structure/prop/hybrisa/vehicles/Meridian/Brown
	icon = 'icons/obj/structures/props/vehicles/meridian_brown.dmi'
	icon_state = "meridian_brown"

/obj/structure/prop/hybrisa/vehicles/Meridian/Cop
	icon = 'icons/obj/structures/props/vehicles/meridian_cop.dmi'
	icon_state = "meridian_cop"

/obj/structure/prop/hybrisa/vehicles/Meridian/Desat_Blue
	icon = 'icons/obj/structures/props/vehicles/meridian_desatblue.dmi'
	icon_state = "meridian_desatblue"

/obj/structure/prop/hybrisa/vehicles/Meridian/Green
	icon = 'icons/obj/structures/props/vehicles/meridian_green.dmi'
	icon_state = "meridian_green"

/obj/structure/prop/hybrisa/vehicles/Meridian/Light_Blue
	icon = 'icons/obj/structures/props/vehicles/meridian_lightblue.dmi'
	icon_state = "meridian_lightblue"

/obj/structure/prop/hybrisa/vehicles/Meridian/Pink
	icon = 'icons/obj/structures/props/vehicles/meridian_pink.dmi'
	icon_state = "meridian_pink"

/obj/structure/prop/hybrisa/vehicles/Meridian/Purple
	icon = 'icons/obj/structures/props/vehicles/meridian_purple.dmi'
	icon_state = "meridian_purple"

/obj/structure/prop/hybrisa/vehicles/Meridian/Turquoise
	icon = 'icons/obj/structures/props/vehicles/meridian_turquoise.dmi'
	icon_state = "meridian_turquoise"

/obj/structure/prop/hybrisa/vehicles/Meridian/Orange
	icon = 'icons/obj/structures/props/vehicles/meridian_orange.dmi'
	icon_state = "meridian_orange"

/obj/structure/prop/hybrisa/vehicles/Meridian/WeylandYutani
	icon = 'icons/obj/structures/props/vehicles/meridian_wy.dmi'
	icon_state = "meridian_wy"

/obj/structure/prop/hybrisa/vehicles/Meridian/Taxi
	icon = 'icons/obj/structures/props/vehicles/meridian_taxi.dmi'
	icon_state = "meridian_taxi"

/obj/structure/prop/hybrisa/vehicles/Meridian/Shell
	desc = "A Mono-Spectra chassis in the early stages of assembly."
	icon = 'icons/obj/structures/props/vehicles/meridian_shell.dmi'
	icon_state = "meridian_shell"

// Colony Crawlers - Damage States
/obj/structure/prop/hybrisa/vehicles/Colony_Crawlers
	name = "colony crawler"
	desc = "It's locked and seems to be broken down, forget driving this."
	icon = 'icons/obj/structures/props/vehicles/crawler_wy_1.dmi'
	icon_state = "crawler_wy_1"
	bound_height = 32
	bound_width = 64
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/vehicles/Colony_Crawlers/Science_1
	desc = "It is a tread bound crawler used in harsh conditions. This one is designed for personnel transportation. Supplied by Orbital Blue International; 'Your friends, in the Aerospace business.' A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehicles/crawler_wy_1.dmi'
	icon_state = "crawler_wy_1"

/obj/structure/prop/hybrisa/vehicles/Colony_Crawlers/Science_2
	desc = "It is a tread bound crawler used in harsh conditions. This one is designed for personnel transportation. Supplied by Orbital Blue International; 'Your friends, in the Aerospace business.' A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehicles/crawler_wy_2.dmi'
	icon_state = "crawler_wy_2"

/obj/structure/prop/hybrisa/vehicles/Colony_Crawlers/Crawler_Cargo
	icon = 'icons/obj/structures/props/vehicles/crawler_bed.dmi'
	icon_state = "crawler_bed"

// Mining Crawlers

/obj/structure/prop/hybrisa/vehicles/Mining_Crawlers
	name = "mining crawler"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehicles/mining_crawler.dmi'
	icon_state = "mining_crawler_1"
	bound_height = 32
	bound_width = 64
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/vehicles/Mining_Crawlers/Fuel
	icon = 'icons/obj/structures/props/vehicles/mining_crawler_fuel.dmi'
	icon_state = "mining_crawler_fuel"

// Car Pileup

/obj/structure/prop/hybrisa/vehicles/car_pileup
	name = "burned out vehicle pileup"
	desc = "Burned-out vehicles block your path, their charred frames and shattered glass hinting at recent chaos. The acrid smell of smoke lingers."
	icon = 'icons/obj/structures/props/vehicles/car_pileup.dmi'
	icon_state = "car_pileup"
	bound_height = 96
	bound_width = 128
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = 5

// Cave props

/obj/structure/prop/hybrisa/boulders
	icon = 'icons/obj/structures/props/natural/boulder_largedark.dmi'
	icon_state = "boulder_largedark1"

/obj/structure/prop/hybrisa/boulders/large_boulderdark
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/boulder_largedark.dmi'
	icon_state = "boulder_largedark1"
	density = TRUE
	bound_height = 64
	bound_width = 64

/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark1
	icon_state = "boulder_largedark1"

/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark2
	icon_state = "boulder_largedark2"

/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark3
	icon_state = "boulder_largedark3"

/obj/structure/prop/hybrisa/boulders/wide_boulderdark
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/boulder_widedark.dmi'
	icon_state = "boulderwidedark"
	density = TRUE
	bound_height = 32
	bound_width = 64

/obj/structure/prop/hybrisa/boulders/wide_boulderdark/wide_boulder1
	icon_state = "boulderwidedark"

/obj/structure/prop/hybrisa/boulders/wide_boulderdark/wide_boulder2
	icon_state = "boulderwidedark2"

/obj/structure/prop/hybrisa/boulders/smallboulderdark
	name = "boulder"
	icon_state = "bouldersmalldark1"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/boulder_small.dmi'
	density = TRUE

/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark1
	icon_state = "bouldersmalldark1"

/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark2
	icon_state = "bouldersmalldark2"

/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark3
	icon_state = "bouldersmalldark3"


/obj/structure/prop/hybrisa/cavedecor
	icon = 'icons/obj/structures/props/natural/rocks.dmi'
	name = "stalagmite"
	icon_state = "stalagmite"
	desc = "A cave stalagmite."
	layer = TURF_LAYER
	plane = FLOOR_PLANE

/obj/structure/prop/hybrisa/cavedecor/stalagmite0
	icon_state = "stalagmite"

/obj/structure/prop/hybrisa/cavedecor/stalagmite1
	icon_state = "stalagmite1"

/obj/structure/prop/hybrisa/cavedecor/stalagmite2
	icon_state = "stalagmite2"

/obj/structure/prop/hybrisa/cavedecor/stalagmite3
	icon_state = "stalagmite3"

/obj/structure/prop/hybrisa/cavedecor/stalagmite4
	icon_state = "stalagmite4"

/obj/structure/prop/hybrisa/cavedecor/stalagmite5
	icon_state = "stalagmite5"

// Supermart

/obj/structure/prop/hybrisa/supermart
	name = "long rack"
	icon_state = "longrack1"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	density = TRUE
	projectile_coverage = 20
	throwpass = TRUE
	health = 200

/obj/structure/prop/hybrisa/supermart/bullet_act(obj/projectile/P)
	health -= P.damage
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/supermart/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/supermart/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/supermart/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/supermart/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/supermart/rack/longrackempty
	name = "shelf"
	desc = "A long empty shelf."
	icon_state = "longrackempty"

/obj/structure/prop/hybrisa/supermart/rack/longrack1
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack1"

/obj/structure/prop/hybrisa/supermart/rack/longrack2
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack2"

/obj/structure/prop/hybrisa/supermart/rack/longrack3
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack3"

/obj/structure/prop/hybrisa/supermart/rack/longrack4
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack4"

/obj/structure/prop/hybrisa/supermart/rack/longrack5
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack5"

/obj/structure/prop/hybrisa/supermart/rack/longrack6
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack6"

/obj/structure/prop/hybrisa/supermart/rack/longrack7
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon_state = "longrack7"

/obj/structure/prop/hybrisa/supermart/supermartbelt
	name = "conveyor belt"
	desc = "A conveyor belt."
	icon_state = "checkoutbelt"

/obj/structure/prop/hybrisa/supermart/freezer
	name = "commercial freezer"
	desc = "A commercial grade freezer."
	icon_state = "freezerupper"
	density = TRUE

/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer1
	icon_state = "freezerupper"

/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer2
	icon_state = "freezerlower"

/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer3
	icon_state = "freezermid"

/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer4
	icon_state = "freezerupper1"

/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer5
	icon_state = "freezerlower1"

/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer6
	icon_state = "freezermid1"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketempty
	name = "basket"
	desc = "A basket."
	icon_state = "supermarketbasketempty"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketoranges
	name = "basket"
	desc = "A basket full of oranges."
	icon_state = "supermarketbasket1"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketpears
	name = "basket"
	desc = "A basket full of pears."
	icon_state = "supermarketbasket2"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketcarrots
	name = "basket"
	desc = "A basket full of carrots."
	icon_state = "supermarketbasket3"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketmelons
	name = "basket"
	desc = "A basket full of melons."
	icon_state = "supermarketbasket4"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketapples
	name = "basket"
	desc = "A basket full of apples."
	icon_state = "supermarketbasket5"

/obj/structure/prop/hybrisa/supermart/souto_man_prop
	name = "Souto Man mannequin"
	icon = 'icons/obj/structures/props/hybrisa/souto.dmi'
	desc = "A mannequin of the famous 'Souto-Man', Party like it's 1999!"
	icon_state = "souto_man_prop"
	density = TRUE

/obj/structure/prop/hybrisa/supermart/souto_rack
	name = "Souto cans rack"
	icon = 'icons/obj/structures/props/hybrisa/souto.dmi'
	desc = "A rack filled with Souto cans of various flavors."
	icon_state = "souto_rack"
	density = TRUE

/obj/structure/prop/hybrisa/supermart/souto_can_stack
	name = "stacked souto cans"
	icon = 'icons/obj/structures/props/hybrisa/souto.dmi'
	desc = "A large stack of 'Souto-Classic' cans."
	icon_state = "souto_can_stack"
	density = TRUE

// Furniture
/obj/structure/prop/hybrisa/furniture
	icon = 'icons/obj/structures/tables_64x64.dmi'
	icon_state = "blackmetaltable"
	health = 200
	projectile_coverage = 20
	throwpass = TRUE

/obj/structure/prop/hybrisa/furniture/tables
	icon = 'icons/obj/structures/tables_64x64.dmi'
	icon_state = "table_pool"
	health = 200

/obj/structure/prop/hybrisa/furniture/tables/bullet_act(obj/projectile/P)
	health -= P.damage
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/furniture/tables/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/furniture/tables/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/furniture/tables/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/furniture/tables/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/furniture/tables/tableblack
	name = "large metal table"
	desc = "A large black metal table, looks very expensive."
	icon_state = "blackmetaltable"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	bound_height = 32
	bound_width = 64
	debris = list(/obj/item/stack/sheet/metal)

/obj/structure/prop/hybrisa/furniture/tables/tableblack/blacktablecomputer
	icon = 'icons/obj/structures/tables_64x64.dmi'
	icon_state = "blackmetaltable_computer"

/obj/structure/prop/hybrisa/furniture/tables/tablewood
	name = "large wood table"
	desc = "A large wooden table, looks very expensive."
	icon_state = "brownlargetable"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	bound_height = 32
	bound_width = 64
	debris = list(/obj/item/stack/sheet/wood)

/obj/structure/prop/hybrisa/furniture/tables/tablewood/woodtablecomputer
	icon = 'icons/obj/structures/tables_64x64.dmi'
	icon_state = "brownlargetable_computer"

/obj/structure/prop/hybrisa/furniture/tables/tablepool
	name = "pool table"
	desc = "A large table used for Pool."
	icon = 'icons/obj/structures/tables_64x64.dmi'
	icon_state = "table_pool"
	density = TRUE
	bound_height = 32
	bound_width = 64
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)

/obj/structure/prop/hybrisa/furniture/tables/tablegambling
	name = "gambling table"
	desc = "A large table used for gambling."
	icon = 'icons/obj/structures/tables_64x64.dmi'
	icon_state = "table_cards"
	density = TRUE
	bound_height = 32
	bound_width = 64
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)

// Chairs

/obj/structure/bed/chair/comfy/hybrisa
	name = "expensive chair"
	desc = "A expensive looking chair"

/obj/structure/bed/chair/comfy/hybrisa/black
	icon_state = "comfychair_hybrisablack"

/obj/structure/bed/chair/comfy/hybrisa/red
	icon_state = "comfychair_hybrisared"

/obj/structure/bed/chair/comfy/hybrisa/blue
	icon_state = "comfychair_hybrisablue"

/obj/structure/bed/chair/comfy/hybrisa/brown
	icon_state = "comfychair_hybrisabrown"

// Beds

/obj/structure/bed/hybrisa/dingy
	name = "dingy bed"
	desc = "An old mattress seated on a rectangular metallic frame. This is used to support a lying person in a comfortable manner, notably for regular sleep. Ancient technology, but still useful."
	icon_state = "bed_dingy"

/obj/structure/bed/hybrisa
	icon_state = ""
	buckling_y = 8

/obj/structure/bed/hybrisa/prisonbed
	name = "bunk bed"
	desc = "A sorry looking bunk-bed."
	icon_state = "prisonbed"

/obj/structure/bed/hybrisa/bunkbed1
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon_state = "zbunkbed"

/obj/structure/bed/hybrisa/bunkbed2
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon_state = "zbunkbed2"

/obj/structure/bed/hybrisa/bunkbed3
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon_state = "zbunkbed3"

/obj/structure/bed/hybrisa/bunkbed4
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon_state = "zbunkbed4"

// Cabinet

/obj/structure/closet/cabinet/hybrisa/metal
	name = "metal cabinet"
	desc = "A large metal cabinet, looks sturdy."
	icon_state = "cabinet_metal_closed"
	icon_closed = "cabinet_metal_closed"
	icon_opened = "cabinet_metal_open"

/obj/structure/closet/cabinet/hybrisa/metal/alt
	name = "metal cabinet"
	desc = "A large metal cabinet, looks sturdy."
	icon_state = "cabinet_metal_alt_closed"
	icon_closed = "cabinet_metal_alt_closed"
	icon_opened = "cabinet_metal_alt_open"

// Xenobiology

/obj/structure/prop/hybrisa/xenobiology
	icon = 'icons/obj/structures/props/hybrisa/hybrisaxenocryogenics.dmi'
	icon_state = "xenocellemptyon"
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/xenobiology/small/empty
	name = "specimen containment cell"
	desc = "It's empty."
	icon_state = "xenocellemptyon"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/offempty
	name = "specimen containment cell"
	desc = "It's turned off and empty."
	icon_state = "xenocellemptyoff"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/larva
	name = "specimen containment cell"
	desc = "There is something worm-like inside..."
	icon_state = "xenocelllarva"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/egg
	name = "specimen containment cell"
	desc = "There is, what looks like some sort of egg inside..."
	icon_state = "xenocellegg"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/hugger
	name = "specimen containment cell"
	desc = "There's something spider-like inside..."
	icon_state = "xenocellhugger"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/cracked1
	name = "specimen containment cell"
	desc = "Looks like something broke it...from the inside."
	icon_state = "xenocellcrackedempty"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/cracked2
	name = "specimen containment cell"
	desc = "Looks like something broke it...from the inside."
	icon_state = "xenocellcrackedempty2"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/small/crackedegg
	name = "specimen containment cell"
	desc = "Looks like something broke it, there's a giant empty egg inside."
	icon_state = "xenocellcrackedegg"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/giant_cryo
	icon = 'icons/obj/structures/props/xeno_cyro_giant.dmi'
	name = "colossal specimen containment cell"
	desc = "A colossal cryogenic tube with yellow-tinted glass towers before you, housing a hulking, monstrous entity. Is it alive, or in a deep slumber? Cold mist swirls around the base as a low hum fills the air."
	icon_state = "giant_xeno_cryo"
	bound_height = 128
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	density = FALSE
	layer = ABOVE_XENO_LAYER

/obj/structure/prop/hybrisa/xenobiology/misc
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	name = "strange egg"
	desc = "A strange ancient looking egg, it seems to be inert."
	icon_state = "inertegg"
	unslashable = TRUE
	explo_proof = TRUE
	layer = TURF_LAYER

// Engineer

/obj/structure/prop/hybrisa/engineer
	icon = 'icons/obj/structures/props/engineers/engineerJockey.dmi'
	icon_state = "spacejockey"

/obj/structure/prop/hybrisa/engineer/spacejockey
	name = "giant pilot"
	desc = "A colossal enigma looms before you—a titan of alien origin, frozen in time and death. Its massive form appears fossilized, hinting at eons spent entombed within the bowels of the derelict alien vessel. The creature seems fused with the grandeur of its chair, as if emerging from the very essence of the ship itself. Bones, twisted and contorted, protrude outward in a macabre display, as if violently expelled from within by some unimaginable force. It's a harrowing encounter with an enigmatic being from a bygone era—a silent witness to mysteries that may never be unraveled."
	icon = 'icons/obj/structures/props/engineers/engineerJockey.dmi'
	icon_state = "spacejockey"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/engineer/giantpod/broken
	name = "giant hypersleep chamber"
	desc = "Before you lies a behemoth of what looks like a 'hypersleep chamber', dwarfing everything around it. Within, a fossilized alien presence lies dormant. The chamber itself bears the scars of a violent past, with holes melted in its outer shell, as if something within had erupted outwards with some unknown force. The desiccated remains of the occupant are twisted and contorted, suggesting a violent demise that occurred long ago."
	icon = 'icons/obj/structures/props/engineers/engineerPod.dmi'
	icon_state = "pod_broken"
	bound_height = 96
	density = TRUE

/obj/structure/prop/hybrisa/engineer/giantpod
	name = "colossal hypersleep chamber"
	desc = "Before you stands an imposing structure, what looks like a colossal 'hypersleep chamber' of alien design, unlike anything you've ever encountered. Its intricate patterns and unfamiliar symbols hint at technologies far beyond human comprehension. Yet, despite its grandeur, the chamber is empty, devoid of any sign of life."
	icon = 'icons/obj/structures/props/engineers/engineerPod.dmi'
	icon_state = "pod"
	bound_height = 96
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	health = 12000

/obj/structure/prop/hybrisa/engineer/giantpod/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/engineer/giantpod/proc/explode()
	visible_message(SPAN_DANGER("[src] crumbles!"), max_distance = 1)
	playsound(loc, 'sound/effects/burrowoff.ogg', 25)

	deconstruct(FALSE)

/obj/structure/prop/hybrisa/engineer/giantpod/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/engineer/giantpod/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/engineer/giantpod/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metal_close.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/engineer/giantconsole
	name = "colossal alien console"
	desc = "Before you looms a towering alien console, its design defying all familiarity and logic. It's a marvel of unknown technology, adorned with intricate patterns and pulsating lights that dance with otherworldly energy. What purpose does this enigmatic device serve? The answer eludes you..."
	icon = 'icons/obj/structures/props/engineers/consoles.dmi'
	icon_state = "engineerconsole"
	bound_height = 32
	bound_width = 32
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	density = TRUE

/obj/structure/prop/hybrisa/engineer/engineerpillar
	icon = 'icons/obj/structures/props/engineers/hybrisaengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1fade"
	bound_height = 64
	bound_width = 128
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/engineer/engineerpillar/northwesttop
	name = "strange pillar"
	icon_state = "engineerpillar_NW1"

/obj/structure/prop/hybrisa/engineer/engineerpillar/northwestbottom
	name = "strange pillar"
	icon_state = "engineerpillar_NW2"

/obj/structure/prop/hybrisa/engineer/engineerpillar/southwesttop
	name = "strange pillar"
	icon_state = "engineerpillar_SW1"

/obj/structure/prop/hybrisa/engineer/engineerpillar/southwestbottom
	name = "strange pillar"
	icon_state = "engineerpillar_SW2"

/obj/structure/prop/hybrisa/engineer/engineerpillar/smallsouthwest1
	name = "strange pillar"
	icon_state = "engineerpillar_SW1fade"

/obj/structure/prop/hybrisa/engineer/engineerpillar/smallsouthwest2
	name = "strange pillar"
	icon_state = "engineerpillar_SW2fade"

/obj/structure/blackgoocontainer
	name = "strange container"
	icon_state = "blackgoocontainer1"
	desc = "A strange alien container. It exudes an aura of otherworldly mystery, its sleek surface bearing no hint of its previous contents. It appears to be completely empty."
	icon = 'icons/obj/items/black_goo_stuff.dmi'
	density = TRUE
	anchored = TRUE
	unslashable = FALSE
	health = 100
	projectile_coverage = 20
	throwpass = TRUE

/obj/structure/blackgoocontainer/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY

/obj/structure/blackgoocontainer/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/thud.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/blackgoocontainer/proc/explode()
	visible_message(SPAN_DANGER("[src] crumbles!"), max_distance = 1)
	playsound(loc, 'sound/effects/burrowoff.ogg', 25)

	deconstruct(FALSE)

/obj/structure/blackgoocontainer/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/blackgoocontainer/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/blackgoocontainer/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metal_close.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/item/hybrisa/engineer_helmet
	icon = 'icons/obj/structures/props/engineers/props.dmi'
	name = "strange alien helmet"
	desc = "The alien helmet takes on a bizarre form reminiscent of an elongated elephant's trunk, adorned with insectoid-like eyes that peer out from its weathered surface. Its purpose and origins shrouded in mystery. As you behold this strange relic, you can't help but ponder the beings who once wore such unconventional headgear and the ancient secrets it may hold..."
	icon_state = "alien_helmet"
	force = 15
	throwforce = 12
	w_class = SIZE_MEDIUM

// Airport

/obj/structure/prop/hybrisa/airport
	name = "nose cone"
	icon = 'icons/obj/structures/props/dropship/dropship_parts.dmi'
	icon_state = "dropshipfrontwhite1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/airport/dropshipnosecone
	name = "nose cone"
	icon_state = "dropshipfrontwhite1"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER
	density = TRUE

/obj/structure/prop/hybrisa/airport/dropshipwingleft
	name = "wing"
	icon_state = "dropshipwingtop1"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/airport/dropshipwingright
	name = "wing"
	icon_state = "dropshipwingtop2"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/airport/dropshipvent1left
	name = "vent"
	icon_state = "dropshipvent1"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/airport/dropshipvent2right
	name = "vent"
	icon_state = "dropshipvent2"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/airport/dropshipventleft
	name = "vent"
	icon_state = "dropshipvent3"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/airport/dropshipventright
	name = "vent"
	icon_state = "dropshipvent4"
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

// Dropship damage

/obj/structure/prop/hybrisa/airport/dropshipenginedamage
	name = "dropship damage"
	desc = "the engine appears to have severe damage."
	icon = 'icons/obj/structures/props/dropship/dropshipdamage.dmi'
	icon_state = "dropship_engine_damage"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	gender = PLURAL

/obj/structure/prop/hybrisa/airport/dropshipenginedamagenofire
	name = "dropship damage"
	desc = "the engine appears to have severe damage."
	icon = 'icons/obj/structures/props/dropship/dropshipdamage.dmi'
	icon_state = "dropship_engine_damage_nofire"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	gender = PLURAL

/obj/structure/prop/hybrisa/airport/refuelinghose
	name = "refueling hose"
	desc = "A long refueling hose that connects to various types of dropships."
	icon = 'icons/obj/structures/props/dropship/dropshipdamage.dmi'
	icon_state = "fuelline1"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/airport/refuelinghose2
	name = "refueling hose"
	desc = "A long refueling hose that connects to various types of dropships."
	icon = 'icons/obj/structures/props/dropship/dropshipdamage.dmi'
	icon_state = "fuelline2"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

// Pilot body

/obj/structure/prop/hybrisa/airport/deadpilot1
	name = "decapitated Weyland-Yutani Pilot"
	desc = "What remains of a Weyland-Yutani Pilot. Their entire head is missing. Where'd it roll off to?..."
	icon = 'icons/obj/structures/props/hybrisa/64x96-props.dmi'
	icon_state = "pilotbody_decap1"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/airport/deadpilot2
	name = "decapitated Weyland-Yutani Pilot"
	desc = "What remains of a Weyland-Yutani Pilot. Their entire head is missing. Where'd it roll off to?..."
	icon = 'icons/obj/structures/props/hybrisa/64x96-props.dmi'
	icon_state = "pilotbody_decap2"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

// Misc

/obj/structure/prop/hybrisa/misc
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	icon_state = ""

// Floor props

/obj/structure/prop/hybrisa/misc/floorprops
	icon = 'icons/obj/structures/props/hybrisa/grates.dmi'
	icon_state = "solidgrate1"
	layer = HATCH_LAYER

/obj/structure/prop/hybrisa/misc/floorprops/grate
	name = "solid metal grate"
	desc = "A metal grate."
	icon_state = "solidgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/grate2
	name = "solid metal grate"
	desc = "A metal grate."
	icon_state = "solidgrate5"

/obj/structure/prop/hybrisa/misc/floorprops/grate3
	name = "solid metal grate"
	desc = "A metal grate."
	icon_state = "zhalfgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/floorglass
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon_state = "solidgrate2"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/hybrisa/misc/floorprops/floorglass2
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon_state = "solidgrate3"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	layer = ABOVE_TURF_LAYER

/obj/structure/prop/hybrisa/misc/floorprops/floorglass3
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon_state = "solidgrate4"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

// Graffiti

/obj/structure/prop/hybrisa/misc/graffiti
	name = "graffiti"
	icon = 'icons/obj/structures/props/hybrisa/64x96-props.dmi'
	icon_state = "zgraffiti4"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE
	gender = PLURAL

/obj/structure/prop/hybrisa/misc/graffiti/graffiti1
	icon_state = "zgraffiti1"

/obj/structure/prop/hybrisa/misc/graffiti/graffiti2
	icon_state = "zgraffiti2"

/obj/structure/prop/hybrisa/misc/graffiti/graffiti3
	icon_state = "zgraffiti3"

/obj/structure/prop/hybrisa/misc/graffiti/graffiti4
	icon_state = "zgraffiti4"

/obj/structure/prop/hybrisa/misc/graffiti/graffiti5
	icon_state = "zgraffiti5"

/obj/structure/prop/hybrisa/misc/graffiti/graffiti6
	icon_state = "zgraffiti6"

/obj/structure/prop/hybrisa/misc/graffiti/graffiti7
	icon_state = "zgraffiti7"

// Wall Blood

/obj/structure/prop/hybrisa/misc/blood
	name = "blood"
	icon = 'icons/obj/structures/props/hybrisa/64x96-props.dmi'
	icon_state = "wallblood_floorblood"
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE
	gender = PLURAL

/obj/structure/prop/hybrisa/misc/blood/blood1
	icon_state = "wallblood_floorblood"

/obj/structure/prop/hybrisa/misc/blood/blood2
	icon_state = "wall_blood_1"

/obj/structure/prop/hybrisa/misc/blood/blood3
	icon_state = "wall_blood_2"

// Fire

/obj/structure/prop/hybrisa/misc/fire
	name = "fire"
	icon = 'icons/obj/structures/props/dropship/dropshipdamage.dmi'
	icon_state = "zfire_smoke"
	layer = ABOVE_MOB_LAYER
	light_on = TRUE
	light_power = 2
	light_range = 3

/obj/structure/prop/hybrisa/misc/fire/fire1
	icon_state = "zfire_smoke"

/obj/structure/prop/hybrisa/misc/fire/fire2
	icon_state = "zfire_smoke2"

/obj/structure/prop/hybrisa/misc/fire/firebarrel
	name = "barrel"
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "zbarrelfireon"
	bound_height = 32
	bound_width = 32
	density = TRUE

/obj/structure/prop/hybrisa/misc/firebarreloff
	name = "barrel"
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	icon_state = "zfirebarreloff"
	bound_height = 32
	bound_width = 32
	density = TRUE

// Misc

/obj/structure/prop/hybrisa/misc/picture
	name = "framed picture"
	desc = "A golden framed picture of an ominous skeletal figure ordorned in golden garb, fancy for a pile of bones..."
	icon = 'icons/obj/structures/props/wall_decorations/decals.dmi'
	icon_state = "pictureframe"

/obj/structure/prop/hybrisa/misc/commandosuitemptyprop
	name = "Weyland-Yutani 'Ape-Suit' showcase"
	desc = "A display model of the Weyland-Yutani 'Apesuit', shame it's only a model..."
	icon_state = "dogcatchersuitempty1"

/obj/structure/prop/hybrisa/misc/cabinet
	name = "cabinet"
	desc = "a small cabinet with drawers."
	icon = 'icons/obj/structures/props/furniture/misc.dmi'
	icon_state = "sidecabinet"
	projectile_coverage = 20
	throwpass = TRUE

/obj/structure/prop/hybrisa/misc/elevator_door
	name = "broken elevator door"
	desc = "completely broken, the elevator is not going to work."
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	icon_state = "elevator_left"
	opacity = FALSE
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/hybrisa/misc/elevator_door/right
	icon_state = "elevator_right"

/obj/structure/prop/hybrisa/misc/trash
	name = "trash bin"
	desc = "A Weyland-Yutani trash bin used for disposing your unwanted items, or you can just throw your shit on the ground like every other asshole."
	icon = 'icons/obj/structures/props/hybrisa/trash_bins.dmi'
	icon_state = "trashblue"
	health = 150
	density = TRUE
	projectile_coverage = 20
	throwpass = TRUE

/obj/structure/prop/hybrisa/misc/trash/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/trash/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/trash/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/trash/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/trash/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/misc/trash/green
	icon_state = "trashgreen"

/obj/structure/prop/hybrisa/misc/trash/blue
	icon_state = "trashblue"

/obj/structure/prop/hybrisa/misc/redmeter
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	name = "meter"
	icon_state = "redmeter"

/obj/item/hybrisa/misc/trash_bag_full_prop
	name = "full trash bag"
	desc = "It's the heavy-duty black polymer kind. It's full of old trash, you don't want to touch it."
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	icon_state = "ztrashbag"
	force = 15
	throwforce = 3
	w_class = SIZE_MEDIUM

/obj/structure/prop/hybrisa/misc/slotmachine
	name = "slot machine"
	desc = "A slot machine."
	icon = 'icons/obj/structures/props/furniture/slot_machines.dmi'
	icon_state = "slotmachine"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	layer = WINDOW_LAYER
	health = 450

/obj/structure/prop/hybrisa/misc/slotmachine/broken
	name = "slot machine"
	desc = "A broken slot machine."
	icon_state = "slotmachine_broken"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	layer = WINDOW_LAYER

/obj/structure/prop/hybrisa/misc/slotmachine/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/slotmachine/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/slotmachine/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/slotmachine/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/slotmachine/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// Coffee Machine (Works with Empty Coffee cups, Mugs ect.)

/obj/structure/machinery/hybrisa/coffee_machine
	icon = 'icons/obj/structures/machinery/coffee_machine.dmi'
	name = "coffee machine"
	desc = "A coffee machine."
	wrenchable = TRUE
	icon_state = "coffee"
	var/vends = "coffee"
	var/base_state = "coffee"
	var/fiting_cups = list(/obj/item/reagent_container/food/drinks/coffee, /obj/item/reagent_container/food/drinks/coffeecup)
	var/making_time = 10 SECONDS
	var/brewing = FALSE
	var/obj/item/reagent_container/food/drinks/cup = null

/obj/structure/machinery/hybrisa/coffee_machine/pull_response(mob/puller)
	. = ..()
	if(.)
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
	return .

/obj/structure/machinery/hybrisa/coffee_machine/inoperable(additional_flags)
	if(additional_flags & MAINT)
		return FALSE // Allow attack_hand usage
	if(!anchored)
		return TRUE
	return ..()

/obj/structure/machinery/hybrisa/coffee_machine/attack_hand(mob/living/user)
	if(..())
		return TRUE

	if(!brewing && cup && user.Adjacent(src) && user.put_in_hands(cup))
		to_chat(user, SPAN_NOTICE("You take [cup] in your hand."))
		cup = null
		update_icon()
		return TRUE

/obj/structure/machinery/hybrisa/coffee_machine/attackby(obj/item/attacking_object, mob/user)
	if(is_type_in_list(attacking_object, fiting_cups))
		if(inoperable())
			to_chat(user, SPAN_WARNING("[src] does not appear to be working."))
			return TRUE

		if(cup)
			to_chat(user, SPAN_WARNING("There is already [cup] there."))
			return TRUE

		playsound(src, "sound/machines/coffee1.ogg", 40, TRUE)
		cup = attacking_object
		user.drop_inv_item_to_loc(attacking_object, src)
		update_icon()

		var/datum/reagents/current_reagent = cup.reagents
		var/space = current_reagent.maximum_volume - current_reagent.total_volume
		if(space < current_reagent.maximum_volume)
			to_chat(user, SPAN_WARNING("[capitalize_first_letters(vends)] spills around as it does not fit [cup], you should have emptied it first."))

		brewing = TRUE
		addtimer(CALLBACK(src, PROC_REF(vend_coffee), user, space), making_time)
		return TRUE

	if(istype(attacking_object, /obj/item/reagent_container))
		to_chat(user, SPAN_WARNING("[attacking_object] does not quite fit in."))
		return TRUE

	return ..()

/obj/structure/machinery/hybrisa/coffee_machine/proc/vend_coffee(mob/user, amount)
	brewing = FALSE
	cup?.reagents?.add_reagent(vends, amount)
	if(user?.Adjacent(src) && user.put_in_hands(cup))
		to_chat(user, SPAN_NOTICE("You take [cup] in your hand."))
		cup = null
	else
		to_chat(user, SPAN_WARNING("[cup] sits ready in the machine."))

	update_icon()

/obj/structure/machinery/hybrisa/coffee_machine/power_change(area/master_area)
	. = ..()
	update_icon()
	return .

/obj/structure/machinery/hybrisa/coffee_machine/toggle_anchored(obj/item/W, mob/user)
	. = ..()
	if(.)
		update_icon()
	return .

/obj/structure/machinery/hybrisa/coffee_machine/update_icon()
	if(!cup)
		if(!anchored)
			icon_state = ("[base_state]")
			return
		if(stat & NOPOWER)
			icon_state = ("[base_state]_empty_off")
			return
		icon_state = ("[base_state]_empty_on")
		return

	switch(cup.type)
		if(/obj/item/reagent_container/food/drinks/coffeecup)
			icon_state = ("[base_state]_mug")
		if(/obj/item/reagent_container/food/drinks/coffee/cuppa_joes)
			icon_state = ("[base_state]_cup")
		if(/obj/item/reagent_container/food/drinks/coffeecup/wy)
			icon_state = ("[base_state]_mug_wy")
		if(/obj/item/reagent_container/food/drinks/coffeecup/uscm)
			icon_state = ("[base_state]_mug_uscm")
		else
			icon_state = ("[base_state]_cup_generic")

/obj/structure/machinery/hybrisa/coffee_machine/get_examine_text(mob/user)
	. = ..()
	if(!anchored)
		. += "It does not appear to be plugged in."

// Big Computer Units 32x32

/obj/structure/machinery/big_computers
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	name = "computer"
	icon_state = "mapping_comp"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	health = 250
	opacity = FALSE

/obj/structure/machinery/big_computers/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/machinery/big_computers/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/machinery/big_computers/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/machinery/big_computers/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/machinery/big_computers/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/machinery/big_computers/computerwhite
	name = "computer"

/obj/structure/machinery/big_computers/computerblack
	name = "computer"

/obj/structure/machinery/big_computers/computerbrown
	icon = 'icons/obj/structures/props/almayer/almayer_props.dmi'
	name = "computer"

/obj/structure/machinery/big_computers/computerbrown/computer1
	icon_state = "mapping_comp"

/obj/structure/machinery/big_computers/computerbrown/computer2
	icon_state = "mps"

/obj/structure/machinery/big_computers/computerbrown/computer3
	icon_state = "sensor_comp1"

/obj/structure/machinery/big_computers/computerbrown/computer4
	icon_state = "sensor_comp2"

/obj/structure/machinery/big_computers/computerbrown/computer5
	icon_state = "sensor_comp3"
/obj/structure/machinery/big_computers/computerwhite/computer1
	icon_state = "mapping_comp"

/obj/structure/machinery/big_computers/computerwhite/computer2
	icon_state = "mps"

/obj/structure/machinery/big_computers/computerwhite/computer3
	icon_state = "sensor_comp1"

/obj/structure/machinery/big_computers/computerwhite/computer4
	icon_state = "sensor_comp2"

/obj/structure/machinery/big_computers/computerwhite/computer5
	icon_state = "sensor_comp3"

/obj/structure/machinery/big_computers/computerblack/computer1
	icon_state = "blackmapping_comp"

/obj/structure/machinery/big_computers/computerblack/computer2
	icon_state = "blackmps"

/obj/structure/machinery/big_computers/computerblack/computer3
	icon_state = "blacksensor_comp1"

/obj/structure/machinery/big_computers/computerblack/computer4
	icon_state = "blacksensor_comp2"

/obj/structure/machinery/big_computers/computerblack/computer5
	icon_state = "blacksensor_comp3"

/obj/structure/machinery/big_computers/messaging_server
	name = "messaging server"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "messageserver_black"

/obj/structure/machinery/big_computers/messaging_server/black
	icon_state = "messageserver_black"

/obj/structure/machinery/big_computers/messaging_server/white
	icon_state = "messageserver_white"

/obj/structure/machinery/big_computers/messaging_server/brown
	icon_state = "messageserver_brown"

// Science Computer Stuff

/obj/structure/machinery/big_computers/science_big
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	name = "synthesis simulator"
	icon_state = "modifier"
	bound_width = 64
	bound_height = 32
	anchored = TRUE
	density = TRUE
	health = 250
	opacity = FALSE

/obj/structure/machinery/big_computers/science_big/synthesis_simulator
	name = "synthesis simulator"
	desc = "This computer uses advanced algorithms to perform simulations of reagent properties, for the purpose of calculating the synthesis required to make a new variant."
	icon_state = "modifier"

/obj/structure/machinery/big_computers/science_big/protolathe
	name = "chemical storage system"
	desc = "Storage system for a large supply of chemicals, which slowly recharges."
	icon_state = "protolathe"

/obj/structure/machinery/big_computers/science_big/operator_machine
	name = "synthesis simulator"
	desc = "This computer uses advanced algorithms to perform simulations of reagent properties, for the purpose of calculating the synthesis required to make a new variant."
	icon_state = "operator"

/obj/structure/machinery/big_computers/science_big/operator_machine_open
	name = "synthesis simulator"
	desc = "This computer uses advanced algorithms to perform simulations of reagent properties, for the purpose of calculating the synthesis required to make a new variant."
	icon_state = "operator_open"

/obj/structure/machinery/big_computers/science_big/medilathe
	name = "medilathe"
	desc = "A specialized autolathe made for printing medical items."
	icon_state = "medilathe"

// Monitors

/obj/structure/prop/hybrisa/misc/machinery/screens
	name = "monitor"
	health = 150

/obj/structure/prop/hybrisa/misc/machinery/screens/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/machinery/screens/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/machinery/screens/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/machinery/screens/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/machinery/screens/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/misc/machinery/screens/frame
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "frame"

/obj/structure/prop/hybrisa/misc/machinery/screens/security
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "security"

/obj/structure/prop/hybrisa/misc/machinery/screens/redalert
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "redalert_framed"

/obj/structure/prop/hybrisa/misc/machinery/screens/redalertblank
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "redalertblank"

/obj/structure/prop/hybrisa/misc/machinery/screens/entertainment
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "entertainment_framed"

/obj/structure/prop/hybrisa/misc/machinery/screens/telescreen
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "telescreen"

/obj/structure/prop/hybrisa/misc/machinery/screens/telescreenbroke
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "telescreenb"

/obj/structure/prop/hybrisa/misc/machinery/screens/telescreenbrokespark
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "telescreenbspark"

/obj/structure/prop/hybrisa/misc/machinery/screens/wood_clock
	icon = 'icons/obj/structures/props/furniture/clock.dmi'
	name = "clock"
	icon_state = "wood_clock"

/obj/structure/prop/hybrisa/misc/machinery/screens/gold_clock
	icon = 'icons/obj/structures/props/furniture/clock.dmi'
	name = "clock"
	icon_state = "gold_clock"

// Multi-Monitor

//Green
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorsmall_off
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "multimonitorsmall_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorsmall_on
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "multimonitorsmall_on"

/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitormedium_off
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "multimonitormedium_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitormedium_on
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "multimonitormedium_on"

/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorbig_off
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "multimonitorbig_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorbig_on
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "multimonitorbig_on"

// Blue

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorsmall_off
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "bluemultimonitorsmall_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorsmall_on
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "bluemultimonitorsmall_on"

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitormedium_off
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "bluemultimonitormedium_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitormedium_on
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "bluemultimonitormedium_on"

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorbig_off
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "bluemultimonitorbig_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorbig_on
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "bluemultimonitorbig_on"

// Egg
/obj/structure/prop/hybrisa/misc/machinery/screens/wallegg_off
	icon = 'icons/obj/structures/props/hybrisa/wall_egg.dmi'
	icon_state = "wallegg_off"

/obj/structure/prop/hybrisa/misc/machinery/screens/wallegg_on
	icon = 'icons/obj/structures/props/hybrisa/wall_egg.dmi'
	icon_state = "wallegg_on"

// Fake Pipes
/obj/effect/hybrisa/misc/fake/pipes
	name = "disposal pipe"
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	icon_state = "pipe-s"
	layer = WIRE_LAYER

/obj/effect/hybrisa/misc/fake/pipes/pipe1
	icon_state = "pipe-s"

/obj/effect/hybrisa/misc/fake/pipes/pipe2
	icon_state = "pipe-c"

/obj/effect/hybrisa/misc/fake/pipes/pipe3
	icon_state = "pipe-j1"

/obj/effect/hybrisa/misc/fake/pipes/pipe4
	icon_state = "pipe-y"

/obj/effect/hybrisa/misc/fake/pipes/pipe5
	icon_state = "pipe-b"

// Fake Wire

/obj/effect/hybrisa/misc/fake/wire
	name = "power cable"
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	icon_state = "intactred"
	layer = UNDERFLOOR_OBJ_LAYER

/obj/effect/hybrisa/misc/fake/ex_act()
	qdel(src)

/obj/effect/hybrisa/misc/fake/wire/red
	icon_state = "intactred"

/obj/effect/hybrisa/misc/fake/wire/yellow
	icon_state = "intactyellow"

/obj/effect/hybrisa/misc/fake/wire/blue
	icon_state = "intactblue"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire
	name = "heavy duty wire"
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	layer = TURF_LAYER

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy1
	icon_state = "0-1"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy2
	icon_state = "1-2"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy3
	icon_state = "1-4"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy4
	icon_state = "1-2-4"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy5
	icon_state = "1-2-4-8"

// Lattice & 'Effect' Lattice

/obj/structure/prop/hybrisa/misc/fake/lattice
	name = "structural lattice"
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	layer = TURF_LAYER

/obj/structure/prop/hybrisa/misc/fake/lattice/full
	icon_state = "latticefull"

/obj/effect/decal/hybrisa/lattice
	name = "structural lattice"
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	icon_state = "latticefull"
	layer = TURF_LAYER

/obj/effect/decal/hybrisa/lattice/full
	icon_state = "latticefull"

// Cargo Containers extended

/obj/structure/cargo_container/hybrisa/containersextended
	name = "cargo container"
	desc = "a cargo container."
	icon = 'icons/obj/structures/props/containers/containersextended.dmi'
	icon_state = "blackwyleft"
	bound_height = 32
	bound_width = 32
	layer = ABOVE_MOB_LAYER

/obj/structure/cargo_container/hybrisa/containersextended/blueleft
	name = "cargo container"
	icon_state = "blueleft"

/obj/structure/cargo_container/hybrisa/containersextended/blueright
	name = "cargo container"
	icon_state = "blueright"

/obj/structure/cargo_container/hybrisa/containersextended/greenleft
	name = "cargo container"
	icon_state = "greenleft"

/obj/structure/cargo_container/hybrisa/containersextended/greenright
	name = "cargo container"
	icon_state = "greenright"

/obj/structure/cargo_container/hybrisa/containersextended/tanleft
	name = "cargo container"
	icon_state = "tanleft"

/obj/structure/cargo_container/hybrisa/containersextended/tanright
	name = "cargo container"
	icon_state = "tanright"

/obj/structure/cargo_container/hybrisa/containersextended/redleft
	name = "cargo container"
	icon_state = "redleft"

/obj/structure/cargo_container/hybrisa/containersextended/redright
	name = "cargo container"
	icon_state = "redright"

/obj/structure/cargo_container/hybrisa/containersextended/greywyleft
	name = "Weyland-Yutani cargo container"
	icon_state = "greywyleft"

/obj/structure/cargo_container/hybrisa/containersextended/greywyright
	name = "Weyland-Yutani cargo container"
	icon_state = "greywyright"

/obj/structure/cargo_container/hybrisa/containersextended/lightgreywyleft
	name = "Weyland-Yutani cargo container"
	icon_state = "lightgreywyleft"

/obj/structure/cargo_container/hybrisa/containersextended/lightgreywyright
	name = "Weyland-Yutani cargo container"
	icon_state = "lightgreywyright"

/obj/structure/cargo_container/hybrisa/containersextended/blackwyleft
	name = "Weyland-Yutani cargo container"
	icon_state = "blackwyleft"

/obj/structure/cargo_container/hybrisa/containersextended/blackwyright
	name = "Weyland-Yutani cargo container"
	icon_state = "blackwyright"

/obj/structure/cargo_container/hybrisa/containersextended/whitewyleft
	name = "Weyland-Yutani cargo container"
	icon_state = "whitewyleft"

/obj/structure/cargo_container/hybrisa/containersextended/whitewyright
	name = "Weyland-Yutani cargo container"
	icon_state = "whitewyright"

/obj/structure/cargo_container/hybrisa/containersextended/tanwywingsleft
	name = "cargo container"
	icon_state = "tanwywingsleft"

/obj/structure/cargo_container/hybrisa/containersextended/tanwywingsright
	name = "cargo container"
	icon_state = "tanwywingsright"

/obj/structure/cargo_container/hybrisa/containersextended/greenwywingsleft
	name = "cargo container"
	icon_state = "greenwywingsleft"

/obj/structure/cargo_container/hybrisa/containersextended/greenwywingsright
	name = "cargo container"
	icon_state = "greenwywingsright"

/obj/structure/cargo_container/hybrisa/containersextended/bluewywingsleft
	name = "cargo container"
	icon_state = "bluewywingsleft"

/obj/structure/cargo_container/hybrisa/containersextended/bluewywingsright
	name = "cargo container"
	icon_state = "bluewywingsright"

/obj/structure/cargo_container/hybrisa/containersextended/redwywingsleft
	name = "cargo container"
	icon_state = "redwywingsleft"

/obj/structure/cargo_container/hybrisa/containersextended/redwywingsright
	name = "cargo container"
	icon_state = "redwywingsright"

/obj/structure/cargo_container/hybrisa/containersextended/medicalleft
	name = "medical cargo containers"
	icon_state = "medicalleft"

/obj/structure/cargo_container/hybrisa/containersextended/medicalright
	name = "medical cargo containers"
	icon_state = "medicalright"

/obj/structure/cargo_container/hybrisa/containersextended/emptymedicalleft
	name = "medical cargo container"
	icon_state = "emptymedicalleft"

/obj/structure/cargo_container/hybrisa/containersextended/emptymedicalright
	name = "medical cargo container"
	icon_state = "emptymedicalright"

/obj/structure/cargo_container/hybrisa/containersextended/kelland_left
	name = "Kelland Mining Company cargo container"
	desc = "A small industrial shipping container.\nYou haven't heard much about Kelland Mining, besides the incident at LV-178's mining operation."
	icon_state = "kelland_alt_l"

/obj/structure/cargo_container/hybrisa/containersextended/kelland_right
	name = "Kelland Mining Company cargo container"
	desc = "A small industrial shipping container.\nYou haven't heard much about Kelland Mining, besides the incident at LV-178's mining operation."
	icon_state = "kelland_alt_r"

/// Fake Platforms

/obj/structure/prop/hybrisa/fakeplatforms
	name = "platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon = 'icons/obj/structures/props/hybrisa/platforms.dmi'
	icon_state = "platform"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE

/obj/structure/prop/hybrisa/fakeplatforms/platform1
	icon_state = "engineer_platform"

/obj/structure/prop/hybrisa/fakeplatforms/platform2
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "engineer_platform_platformcorners"

/obj/structure/prop/hybrisa/fakeplatforms/platform3
	icon_state = "platform"

/obj/structure/prop/hybrisa/fakeplatforms/platform4
	icon_state = "hybrisaplatform3"

/obj/structure/prop/hybrisa/fakeplatforms/platform4/deco
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "hybrisaplatform_deco3"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/prop/hybrisa/fakeplatforms/platform5
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "hybrisaplatform"

/obj/structure/prop/hybrisa/fakeplatforms/platform5/deco
	name = "platform"
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "hybrisaplatform_deco"

// Greeblies
/obj/structure/prop/hybrisa/misc/buildinggreeblies
	name = "\improper machinery"
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "buildingventbig1"
	bound_width = 64
	bound_height = 32
	density = TRUE
	health = 500
	anchored = TRUE
	layer = ABOVE_XENO_LAYER
	gender = PLURAL

/obj/structure/prop/hybrisa/misc/buildinggreeblies/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/buildinggreeblies/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/buildinggreeblies/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/buildinggreeblies/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/buildinggreeblies/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble1
	icon_state = "buildingventbig2"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble2
	icon_state = "buildingventbig3"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble3
	icon_state = "buildingventbig4"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble4
	icon_state = "buildingventbig5"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble5
	icon_state = "buildingventbig6"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble6
	icon_state = "buildingventbig7"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble7
	icon_state = "buildingventbig8"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble8
	icon_state = "buildingventbig9"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble9
	icon_state = "buildingventbig10"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble10
	density = FALSE
	icon_state = "buildingventbig11"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble11
	density = FALSE
	icon_state = "buildingventbig12"

/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble12
	density = FALSE
	icon_state = "buildingventbig13"

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall
	name = "wall vent"
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	icon_state = "smallwallvent1"
	density = FALSE
	health = 250

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/smallvent2
	name = "wall vent"
	icon_state = "smallwallvent2"

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/smallvent3
	name = "wall vent"
	icon_state = "smallwallvent3"

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/computer
	name = "computer"
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "zcomputermachine"
	density = TRUE

/obj/structure/prop/hybrisa/misc/metergreen
	name = "meter"
	icon = 'icons/obj/structures/props/hybrisa/computers.dmi'
	icon_state = "biggreenmeter1"

/obj/structure/prop/hybrisa/misc/elevator_button
	name = "broken elevator button"
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	icon_state = "broken_elevator_button"

// MISC

/obj/structure/prop/hybrisa/misc/stoneplanterseats
	name = "concrete seated planter"
	desc = "A decorative concrete planter with seating attached, the seats are fitted with synthetic leather, they've faded in time.."
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "planterseats"
	bound_width = 32
	bound_height = 64
	density = TRUE
	health = 2000
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	projectile_coverage = 20
	throwpass = TRUE

/obj/structure/prop/hybrisa/misc/stoneplanterseats/empty
	name = "concrete planter"
	desc = "A decorative concrete planter."
	icon_state = "planterempty"

/obj/structure/prop/hybrisa/misc/concretestatue
	name = "concrete statue"
	desc = "A decorative statue with the Weyland-Yutani 'Wings' adorned on it, A corporate brutalist piece of art."
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "concretesculpture"
	bound_width = 64
	bound_height = 64
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/misc/detonator
	name = "detonator"
	desc = "A detonator for explosives, armed and ready."
	icon_state = "detonator"
	density = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	projectile_coverage = 20
	throwpass = TRUE
	var/id = 1
	var/range = 15

/obj/structure/prop/hybrisa/misc/detonator/attack_hand(mob/user)
	for(var/obj/item/explosive/plastic/hybrisa/mining/explosive in range(range))
		if(explosive.id == id)
			var/turf/target_turf
			target_turf = get_turf(explosive.loc)
			var/datum/cause_data/temp_cause = create_cause_data(src, user)
			explosive.handle_explosion(target_turf, explosive.dir, temp_cause)

/obj/structure/prop/hybrisa/misc/firehydrant
	name = "fire hydrant"
	desc = "A fire hydrant public water outlet, designed for quick access to water."
	icon = 'icons/obj/structures/props/hybrisa/misc_props.dmi'
	icon_state = "firehydrant"
	density = TRUE
	anchored = TRUE
	health = 250
	projectile_coverage = 20
	throwpass = TRUE

/obj/structure/prop/hybrisa/misc/firehydrant/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/shimmy_around)

/obj/structure/prop/hybrisa/misc/firehydrant/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/firehydrant/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/firehydrant/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/firehydrant/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/firehydrant/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/misc/pole_stump
	name = "colony streetlight stump"
	icon = 'icons/obj/structures/props/streetlights.dmi'
	icon_state = "street_stump"
	plane = FLOOR_PLANE
	explo_proof = TRUE
	health = null

/obj/structure/prop/hybrisa/misc/pole_stump/Crossed(atom/movable/crosser)
	. = ..()
	if(ishuman(crosser) && prob(10))
		var/mob/living/carbon/human/crossing_human = crosser
		crossing_human.visible_message(SPAN_DANGER("[crossing_human] trips on [src] and falls prone."))
		playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
		crossing_human.KnockDown(0.5)

/obj/structure/prop/hybrisa/misc/pole_stump/traffic
	name = "colony streetlight stump"
	icon = 'icons/obj/structures/props/streetlights.dmi'
	icon_state = "trafficlight_stump"

// Sofa Black

/obj/structure/bed/sofa/hybrisa/sofa/black
	name = "Couch"
	desc = "Just like Space Ikea would have wanted"
	icon_state = "sofa_black"
	anchored = TRUE
	can_buckle = FALSE

// Sofa Red

/obj/structure/bed/sofa/hybrisa/sofa/red
	name = "Couch"
	desc = "Just like Space Ikea would have wanted"
	icon_state = "sofa_red"
	anchored = TRUE
	can_buckle = FALSE

/obj/structure/prop/hybrisa/misc/pole
	name = "pole"
	desc = "For all of your 'pole' related activities."
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "pole"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	density = TRUE
	anchored = TRUE
	projectile_coverage = 20
	throwpass = TRUE
	layer = BILLBOARD_LAYER

/obj/structure/prop/hybrisa/misc/pole/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/shimmy_around)

/obj/structure/bed/sofa/hybrisa/misc/bench
	name = "bench"
	desc = "A metal frame, with seats that are fitted with synthetic leather, they've faded in time."
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "seatedbench"
	bound_width = 32
	bound_height = 64
	layer = BELOW_MOB_LAYER
	density = FALSE
	anchored = TRUE

// Phonebox Prop (Doesn't actually work as a locker)

/obj/structure/prop/hybrisa/misc/phonebox
	name = "wrecked phonebox"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. It seems it's completely wrecked, the glass is smashed, hiding inside would be pointless."
	icon = 'icons/obj/structures/props/phonebox.dmi'
	icon_state = "phonebox_off_broken"
	layer = ABOVE_MOB_LAYER
	bound_width = 32
	bound_height = 32
	density = TRUE
	anchored = TRUE

/obj/structure/prop/hybrisa/misc/phonebox/bloody
	name = "wrecked phonebox"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. It seems it's completely wrecked, covered in blood and the glass is smashed. Hiding inside would be pointless."
	icon_state = "phonebox_bloody_off_broken"

/obj/structure/prop/hybrisa/misc/phonebox/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/hybrisa/misc/phonebox/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/phonebox/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/hybrisa/misc/phonebox/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/hybrisa/misc/phonebox/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/Glasshit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/hybrisa/misc/urinal
	name = "urinal"
	desc = "A urinal."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "small_urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/prop/hybrisa/misc/urinal/dark
	icon_state = "small_urinal_dark"

/obj/effect/decal/hybrisa/deco_edging
	name = "decorative concrete edging"
	desc = "Decorative edging for bordering stuff, very fancy."
	icon = 'icons/obj/structures/props/hybrisa/platforms.dmi'
	icon_state = "stone_edging"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER

/obj/effect/decal/hybrisa/deco_edging/corner
	icon = 'icons/obj/structures/props/hybrisa/platforms.dmi'
	icon_state = "stone_edging_deco"
	density = FALSE
	anchored = TRUE

// Signs

/obj/structure/roof/hybrisa/signs
	name = "neon sign"
	icon = 'icons/obj/structures/props/wall_decorations/hybrisa64x64_signs.dmi'
	icon_state = "jacksopen_on"
	bound_height = 64
	bound_width = 64
	layer = BILLBOARD_LAYER
	health = 250

/obj/structure/roof/hybrisa/signs/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/roof/hybrisa/signs/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/roof/hybrisa/signs/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/roof/hybrisa/signs/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/roof/hybrisa/signs/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/roof/hybrisa/signs/casniosign
	name = "casino sign"
	icon_state = "nightgoldcasinoopen_on"

/obj/structure/roof/hybrisa/signs/jackssign
	name = "jack's surplus sign"
	icon_state = "jacksopen_on"

/obj/structure/roof/hybrisa/signs/opensign
	name = "open sign"
	icon_state = "open_on"

/obj/structure/roof/hybrisa/signs/opensign2
	name = "open sign"
	icon_state = "open_on2"

/obj/structure/roof/hybrisa/signs/pizzasign
	name = "pizza sign"
	icon_state = "pizzaneon_on"

/obj/structure/roof/hybrisa/signs/weymartsign
	name = "weymart sign"
	icon_state = "weymartsign2"

/obj/structure/roof/hybrisa/signs/mechanicsign
	name = "mechanic sign"
	icon_state = "mechanicopen_on2"

/obj/structure/roof/hybrisa/signs/cuppajoessign
	name = "cuppa joe's sign"
	icon_state = "cuppajoes"

/obj/structure/roof/hybrisa/signs/barsign
	name = "bar sign"
	icon_state = "barsign_on"

/obj/structure/roof/hybrisa/signs/miscsign
	name = "sign"
	icon_state = "misc_on"

/obj/structure/roof/hybrisa/signs/miscvertsign
	name = "sign"
	icon_state = "miscvert_on"

/obj/structure/roof/hybrisa/signs/miscvert2sign
	name = "sign"
	icon_state = "miscvert2_on"

/obj/structure/roof/hybrisa/signs/miscvert3sign
	name = "sign"
	icon_state = "miscvert3_on"

/obj/structure/roof/hybrisa/signs/miscvert4sign
	name = "sign"
	icon_state = "miscvert4_on"

/obj/structure/roof/hybrisa/signs/miscvert5sign
	name = "sign"
	icon_state = "miscvert5_on"

/obj/structure/roof/hybrisa/signs/miscvert6sign
	name = "sign"
	icon_state = "miscvert6_on"

/obj/structure/roof/hybrisa/signs/miscvert7sign
	name = "sign"
	icon_state = "miscvert7_on"

/obj/structure/roof/hybrisa/signs/cafesign
	name = "cafe sign"
	icon_state = "cafe_on"

/obj/structure/roof/hybrisa/signs/cafealtsign
	name = "cafe sign"
	icon_state = "cafealt_on"

/obj/structure/roof/hybrisa/signs/coffeesign
	name = "coffee sign"
	icon_state = "coffee_on"

/obj/structure/roof/hybrisa/signs/arcadesign
	name = "arcade sign"
	icon_state = "arcade_on"

/obj/structure/roof/hybrisa/signs/hotelsign
	name = "hotel sign"
	icon_state = "hotel_on"

/obj/structure/roof/hybrisa/signs/casinolights
	name = "neon sign"
	icon_state = "casinolights_on"

/obj/structure/roof/hybrisa/signs/pharmacy_sign
	name = "pharmacy sign"
	icon_state = "pharmacy_on"

// Small Sign

/obj/structure/prop/hybrisa/signs/high_voltage
	name = "warning sign"
	desc = null
	icon = 'icons/obj/structures/props/wall_decorations/decals.dmi'
	icon_state = "shockyBig"
	layer = WALL_OBJ_LAYER

/obj/structure/prop/hybrisa/signs/high_voltage/small
	name = "warning sign"
	desc = null
	icon_state = "shockyTiny"
	layer = WALL_OBJ_LAYER

// Billboards, Signs and Posters

/// Alien Isolation - posters used as reference (direct downscale of the image for some) If anyone wants to name the billboards individually ///

/obj/structure/roof/hybrisa/billboardsandsigns
	name = "billboard"
	desc = "An advertisement billboard."
	icon = 'icons/obj/structures/props/wall_decorations/32x64_hybrisabillboards.dmi'
	icon_state = "billboard_bigger"
	health = 500
	bound_width = 64
	bound_height = 32
	density = FALSE
	anchored = TRUE

/obj/structure/roof/hybrisa/billboardsandsigns/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/metalping.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/roof/hybrisa/billboardsandsigns/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/roof/hybrisa/billboardsandsigns/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/roof/hybrisa/billboardsandsigns/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/roof/hybrisa/billboardsandsigns/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/roof/hybrisa/billboardsandsigns/bigbillboards
	icon_state = "billboard_bigger"

/obj/structure/roof/hybrisa/billboardsandsigns/billboardsmedium/billboard1
	icon_state = "billboard1"

/obj/structure/roof/hybrisa/billboardsandsigns/billboardsmedium/billboard2
	icon_state = "billboard2"

/obj/structure/roof/hybrisa/billboardsandsigns/billboardsmedium/billboard3
	icon_state = "billboard3"

/obj/structure/roof/hybrisa/billboardsandsigns/billboardsmedium/billboard4
	icon_state = "billboard4"

/obj/structure/roof/hybrisa/billboardsandsigns/billboardsmedium/billboard5
	icon_state = "billboard5"

// Big Road Signs

/obj/structure/roof/hybrisa/billboardsandsigns/bigroadsigns
	name = "road sign"
	desc = "A road sign."
	icon = 'icons/obj/structures/props/hybrisa/64x64_props.dmi'
	icon_state = "roadsign_1"
	bound_width = 64
	bound_height = 32
	density = FALSE
	anchored = TRUE
	layer = BILLBOARD_LAYER

/obj/structure/roof/hybrisa/billboardsandsigns/bigroadsigns/road_sign_1
	icon_state = "roadsign_1"

/obj/structure/roof/hybrisa/billboardsandsigns/bigroadsigns/road_sign_2
	icon_state = "roadsign_2"

// Car Factory

/obj/structure/prop/hybrisa/Factory
	icon = 'icons/obj/structures/props/industrial/factory.dmi'
	icon_state = "factory_roboticarm"

/obj/structure/prop/hybrisa/Factory/Robotic_arm
	name = "robotic arm"
	desc = "A robotic arm used in the construction of 'Meridian' Automobiles."
	icon_state = "factory_roboticarm"
	bound_width = 64
	bound_height = 32
	anchored = TRUE

/obj/structure/prop/hybrisa/Factory/Robotic_arm/Flipped
	icon_state = "factory_roboticarm2"

/obj/structure/prop/hybrisa/Factory/Conveyor_belt
	name = "large conveyor belt"
	desc = "A large conveyor belt used in industrial factories."
	icon_state = "factory_conveyer"
	density = FALSE

// Hybrisa Lattice
/obj/structure/roof/hybrisa/lattice_prop
	name = "lattice"
	desc = "A support lattice."
	icon = 'icons/obj/structures/props/industrial/hybrisa_lattice.dmi'
	icon_state = "lattice1"
	density = FALSE
	layer = ABOVE_XENO_LAYER
	health = 1000

/obj/structure/roof/hybrisa/lattice_prop/lattice_1
	icon_state = "lattice1"
/obj/structure/roof/hybrisa/lattice_prop/lattice_2
	icon_state = "lattice2"
/obj/structure/roof/hybrisa/lattice_prop/lattice_3
	icon_state = "lattice3"
/obj/structure/roof/hybrisa/lattice_prop/lattice_4
	icon_state = "lattice4"
/obj/structure/roof/hybrisa/lattice_prop/lattice_5
	icon_state = "lattice5"
/obj/structure/roof/hybrisa/lattice_prop/lattice_6
	icon_state = "lattice6"
