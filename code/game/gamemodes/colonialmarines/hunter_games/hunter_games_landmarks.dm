//! Landmarks used for hunter games mode setup.

/// Spawns a generic, relatively middling melee weapon.
/obj/effect/landmark/melee_weapon
	name = "melee_weapon"
	icon_state = "item_crap"

/obj/effect/landmark/melee_weapon/Initialize(mapload, ...)
	. = ..()
	GLOB.melee_weapon += src

/obj/effect/landmark/melee_weapon/Destroy()
	GLOB.melee_weapon -= src
	return ..()


/// Spawns a random bit of hunter games loot, ranging from benign to pretty powerful.
/obj/effect/landmark/good_item
	name = "good_item"
	icon_state = "item_good"

/obj/effect/landmark/good_item/Initialize(mapload, ...)
	. = ..()
	GLOB.good_items += src

/obj/effect/landmark/good_item/Destroy()
	GLOB.good_items -= src
	return ..()


/// Hunter Games contestant spawning
/obj/effect/landmark/start/hunter_games
	name = JOB_HUNTER_GAMES
	icon_state = "hunter_secondary"
	job = /datum/job/hunter_games

