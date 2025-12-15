/obj/effect/landmark/clan_spawn
	name = "clan spawn"
	icon_state = "clan_spawn"

/obj/effect/landmark/clan_spawn/New()
	. = ..()
	SSpredships.init_spawnpoint(src)
	qdel(src)
