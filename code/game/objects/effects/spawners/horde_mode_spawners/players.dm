/obj/effect/landmark/horde_mode/marinespawn
	name = "horde mode marine spawner"
	icon_state = "marine_spawn"


/obj/effect/landmark/horde_mode/marinespawn/Initialize(mapload, ...)
	. = ..()
	SShorde_mode.marine_spawns += loc

/obj/effect/landmark/horde_mode/xenospawn
	name = "horde mode xeno spawner"
	icon_state = "xeno_spawn"


/obj/effect/landmark/horde_mode/xenospawn/Initialize(mapload, ...)
	. = ..()
	SShorde_mode.xeno_spawns += loc
