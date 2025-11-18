/obj/effect/landmark/clan_spawn
	name = "clan spawn"
	icon_state = "clan_spawn"

/obj/effect/landmark/clan_spawn/New()
	. = ..()
	SSpredships.init_spawnpoint(src)
	qdel(src)

/obj/effect/landmark/badblood_spawn
	name = "badblood spawn"
	icon_state = "badblood_spawn"
/obj/effect/landmark/badblood_spawn/New()
	. = ..()
	var/turf/location_turf = get_turf(src)
	if(location_turf)
		GLOB.badblood_spawns += location_turf
	qdel(src)
