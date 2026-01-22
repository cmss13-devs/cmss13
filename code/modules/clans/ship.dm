/obj/effect/landmark/clan_spawn
	name = "clan spawn"
	icon_state = "clan_spawn"

/obj/effect/landmark/clan_spawn/New()
	. = ..()
	GLOB.yautja_spawnpoints += get_turf(src)
	qdel(src)
