// ------ Abyssal walls ------ //

// Standard

/turf/closed/wall/abyssal/standard
	name = "metal wall"
	icon = 'icons/turf/walls/abyssall_walls_blank.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

/turf/closed/wall/abyssal/standard/reinforced
	name = "reinforced metal wall"
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/abyssal/standard/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/abyssal/standard/temphull
	name = "heavy reinforced hull"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. This wall appears to have had an extra layer of sheeting slid over."
	icon_state = "tempwall"
	damage_cap = HEALTH_WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/abyssal/standard/temphull/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABYSSAL_LOCKDOWN, PROC_REF(de_hull))

/turf/closed/wall/abyssal/standard/temphull/proc/de_hull()
	SIGNAL_HANDLER
	turf_flags = NO_FLAGS
	desc = "A highly reinforced metal wall used to separate rooms and make up the ship. The extra defensive sheeting has slid away."

// Blue

/turf/closed/wall/abyssal/blue
	name = "metal wall"
	icon = 'icons/turf/walls/abyssal_walls_blue.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

/turf/closed/wall/abyssal/blue/reinforced
	name = "reinforced metal wall"
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/abyssal/blue/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/abyssal/blue/temphull
	name = "heavy reinforced hull"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. This wall appears to have had an extra layer of sheeting slid over."
	icon_state = "tempwall"
	damage_cap = HEALTH_WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/abyssal/blue/temphull/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABYSSAL_LOCKDOWN, PROC_REF(de_hull))

/turf/closed/wall/abyssal/blue/temphull/proc/de_hull()
	SIGNAL_HANDLER
	turf_flags = NO_FLAGS
	desc = "A highly reinforced metal wall used to separate rooms and make up the ship. The extra defensive sheeting has slid away."
