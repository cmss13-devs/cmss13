/// These specify locations for a pool of items to be spawned in a random subset of these turfs.
/// They are initialized into one "master" item pool spawner datum. The landmark SS will use that to get these values.
/// Technically only the settings for the last of this pool_name matter.
/obj/effect/landmark/item_pool_spawner
	/// Holds the UUID of the pool
	var/pool_name
	/// The type or types of item to spawn. If this is a list, it will pick one from that list x multiplier.
	var/type_to_spawn
	/// Max # of items to spawn for the pool.
	var/quota
	/// How many of type_to_spawn to spawn
	var/multiplier = 1
	/// If non-null, limits this item pool to only this game mode
	var/mode_flags

/obj/effect/landmark/item_pool_spawner/Initialize(mapload, ...)
	. = ..()
	GLOB.item_pool_landmarks += src

/obj/effect/landmark/item_pool_spawner/Destroy()
	GLOB.item_pool_landmarks -= src
	. = ..()

/obj/effect/landmark/item_pool_spawner/corsat_bio_lock
	pool_name = "CORSAT biohazard lock pool"

/obj/effect/landmark/item_pool_spawner/corsat_bio_lock/master
	type_to_spawn = /obj/item/card/data/corsat
	quota = 2

/obj/effect/landmark/item_pool_spawner/prison_lock
	pool_name = "Prison Station lock pool"

/obj/effect/landmark/item_pool_spawner/prison_lock/master
	type_to_spawn = /obj/item/card/data/prison
	quota = 2

/obj/effect/landmark/item_pool_spawner/survivor_ammo
	pool_name = "Survivor ammo pool"
	icon_state = "ipool_surv_ammo"
	quota = 3

/obj/effect/landmark/item_pool_spawner/survivor_ammo/buckshot
	icon_state = "ipool_bubshot"
	type_to_spawn = /obj/item/ammo_magazine/shotgun/buckshot

/obj/effect/landmark/item_pool_spawner/survivor_mode
	pool_name = "Survivor mode pool"
	icon_state = "ipool_surv_mode"
	mode_flags = MODE_SURVIVE
