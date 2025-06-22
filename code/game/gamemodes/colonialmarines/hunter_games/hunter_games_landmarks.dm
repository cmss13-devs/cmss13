// Landmarks used for hunter games mode setup.

// Weapon spawning
/obj/effect/landmark/melee_weapon
	name = "melee_weapon"
	icon_state = "item_crap"

/obj/effect/landmark/melee_weapon/Initialize(mapload, ...)
	. = ..()
	GLOB.melee_weapon += src

/obj/effect/landmark/melee_weapon/Destroy()
	GLOB.melee_weapon -= src
	return ..()

// Better Stuff, Rarer
/obj/effect/landmark/good_item
	name = "good_item"
	icon_state = "item_good"

/obj/effect/landmark/good_item/Initialize(mapload, ...)
	. = ..()
	GLOB.good_items += src

/obj/effect/landmark/good_item/Destroy()
	GLOB.good_items -= src
	return ..()


// Contestant Spawning
/obj/effect/landmark/hunter_primary
	name = "hunter_games_primary"
	icon_state = "hunter_primary"

/obj/effect/landmark/hunter_primary/Initialize(mapload, ...)
	. = ..()
	GLOB.hunter_primaries += src

/obj/effect/landmark/hunter_primary/Destroy()
	GLOB.hunter_primaries -= src
	return ..()

// Backup Contesting Spawning (?)
/obj/effect/landmark/hunter_secondary
	name = "hunter_games_secondary"
	icon_state = "hunter_secondary"

/obj/effect/landmark/hunter_secondary/Initialize(mapload, ...)
	. = ..()
	GLOB.hunter_secondaries += src

/obj/effect/landmark/hunter_secondary/Destroy()
	GLOB.hunter_secondaries -= src
	return ..()
