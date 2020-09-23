// These specify locations for a pool of items to be spawned in a random subset of these turfs

/obj/effect/landmark/item_pool_spawner

	// These are initialized on one "master" item pool spawner landmark, and left blank everywhere else. The landmark SS will use that one to get these values.
	// Technically you can have more than one, if they're different values you're gonna get inconsistent behavior though
	// Best to just make one master like I've done here and call it good, it should just *work* as long as
	var/type_to_spawn // Type variable indicating our datum type (holds which items we need to use, etc).. THIS NEEDS TO BE MOVABLE OR CODE WILL BORK
	var/quota			// Max # of items to spawn

	// Initialized everywhere
	var/pool_name			// Holds the UUID of the pool

/obj/effect/landmark/item_pool_spawner/New()
	set waitfor = 0
	item_pool_landmarks += src
	..()

/obj/effect/landmark/item_pool_spawner/Destroy()
	item_pool_landmarks -= src
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
	quota = 3

/obj/effect/landmark/item_pool_spawner/survivor_ammo/buckshot
	type_to_spawn = /obj/item/ammo_magazine/shotgun/buckshot