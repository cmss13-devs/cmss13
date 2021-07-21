/obj/effect/landmark
	name = "landmark"
	icon = 'icons/landmarks.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = TRUE

/obj/effect/landmark/New()
	..()
	tag = "landmark*[name]"
	invisibility = 101
	return 1

/obj/effect/landmark/Initialize(mapload, ...)
	. = ..()
	invisibility = 101

/obj/effect/landmark/newplayer_start
	name = "New player start"

/obj/effect/landmark/newplayer_start/New() // this must be New()
	. = ..()
	GLOB.newplayer_start += src

/obj/effect/landmark/newplayer_start/Destroy()
	GLOB.newplayer_start -= src
	return ..()

/obj/effect/landmark/ert_spawns/Initialize(mapload, ...)
	. = ..()
	LAZYADD(GLOB.ert_spawns[type], src)

/obj/effect/landmark/ert_spawns/Destroy()
	LAZYREMOVE(GLOB.ert_spawns[type], src)
	return ..()

// Nightmare insert locations
/obj/effect/landmark/nightmare
	name = "Nightmare Insert"
	icon_state = "nightmare_insert"
	var/insert_tag            // Identifier for global mapping
	var/replace = FALSE       // Replace another existing landmark mapping of same name
	var/autoremove = TRUE     // Delete mapped turf when landmark is deleted, such as by an insert in replace mode
/obj/effect/landmark/nightmare/Initialize(mapload, ...)
	. = ..()
	if(!insert_tag) return
	if(!replace && GLOB.nightmare_landmarks[insert_tag]) 
		return
	GLOB.nightmare_landmarks[insert_tag] = get_turf(src)
/obj/effect/landmark/nightmare/Destroy()
	if(insert_tag && autoremove \
	   && GLOB.nightmare_landmarks[insert_tag] == get_turf(src))
		GLOB.nightmare_landmarks.Remove(insert_tag)
	return ..()

/obj/effect/landmark/ert_spawns/distress
	name = "Distress"

/obj/effect/landmark/ert_spawns/distress/item
	name = "DistressItem"

/obj/effect/landmark/ert_spawns/distress_wo
	name = "distress_wo"

/obj/effect/landmark/monkey_spawn
	name = "monkey_spawn"
	icon_state = "monkey_spawn"

/obj/effect/landmark/monkey_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.monkey_spawns += src

/obj/effect/landmark/monkey_spawn/Destroy()
	GLOB.monkey_spawns -= src
	return ..()

/obj/effect/landmark/latewhiskey
	name = "Whiskey Outpost Late join"

/obj/effect/landmark/latewhiskey/Initialize(mapload, ...)
	. = ..()
	GLOB.latewhiskey += src

/obj/effect/landmark/latewhiskey/Destroy()
	GLOB.latewhiskey -= src
	return ..()

/obj/effect/landmark/thunderdome/one
	name = "Thunderdome Team 1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_one += src

/obj/effect/landmark/thunderdome/one/Destroy()
	GLOB.thunderdome_one -= src
	return ..()

/obj/effect/landmark/thunderdome/two
	name = "Thunderdome Team 2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_two += src

/obj/effect/landmark/thunderdome/two/Destroy()
	GLOB.thunderdome_two-= src
	return ..()

/obj/effect/landmark/thunderdome/admin
	name = "Thunderdome Admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_admin += src

/obj/effect/landmark/thunderdome/admin/Destroy()
	GLOB.thunderdome_admin -= src
	return ..()

/obj/effect/landmark/thunderdome/observer
	name = "Thunderdome Observer"

/obj/effect/landmark/thunderdome/observer/Initialize(mapload, ...)
	. = ..()
	GLOB.thunderdome_observer += src

/obj/effect/landmark/thunderdome/observer/Destroy()
	GLOB.thunderdome_observer -= src
	return ..()

/obj/effect/landmark/queen_spawn
	name = "queen spawn"
	icon_state = "queen_spawn"

/obj/effect/landmark/queen_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.queen_spawns += src

/obj/effect/landmark/queen_spawn/Destroy()
	GLOB.queen_spawns -= src
	return ..()

/obj/effect/landmark/xeno_spawn
	name = "xeno spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_spawns += src

/obj/effect/landmark/xeno_spawn/Destroy()
	GLOB.xeno_spawns -= src
	return ..()

/obj/effect/landmark/xeno_hive_spawn
	name = "xeno hive spawn"
	icon_state = "hive_spawn"

/obj/effect/landmark/xeno_hive_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_hive_spawns += src

/obj/effect/landmark/xeno_hive_spawn/Destroy()
	GLOB.xeno_hive_spawns -= src
	return ..()

/obj/effect/landmark/survivor_spawn
	name = "survivor spawn"
	icon_state = "x3"

/obj/effect/landmark/survivor_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.survivor_spawns += src

/obj/effect/landmark/survivor_spawn/Destroy()
	GLOB.survivor_spawns -= src
	return ..()

/obj/effect/landmark/yautja_teleport
	name = "yautja_teleport"

/obj/effect/landmark/yautja_teleport/Initialize(mapload, ...)
	. = ..()
	var/turf/T = get_turf(src)
	if(is_mainship_level(z))
		GLOB.mainship_yautja_teleports += src
		GLOB.mainship_yautja_desc[T.loc.name + T.loc_to_string()] = src
	else
		GLOB.yautja_teleports += src
		GLOB.yautja_teleport_descs[T.loc.name + T.loc_to_string()] = src

/obj/effect/landmark/yautja_teleport/Destroy()
	var/turf/T = get_turf(src)
	GLOB.mainship_yautja_teleports -= src
	GLOB.yautja_teleports -= src
	GLOB.mainship_yautja_desc -= T.loc.name + T.loc_to_string()
	GLOB.yautja_teleport_descs -= T.loc.name + T.loc_to_string()
	return ..()



/obj/effect/landmark/start
	name = "start"
	icon_state = "x"
	anchored = TRUE
	var/job

/obj/effect/landmark/start/Initialize(mapload, ...)
	. = ..()
	if(job)
		LAZYADD(GLOB.spawns_by_job[job], src)

/obj/effect/landmark/start/Destroy()
	if(job)
		LAZYREMOVE(GLOB.spawns_by_job[job], src)
	return ..()

/obj/effect/landmark/start/AISloc
	name = "AI"

/obj/effect/landmark/start/whiskey
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "spawn_shuttle"

/obj/effect/landmark/start/whiskey/Initialize(mapload, ...)
	. = ..()
	GLOB.whiskey_start += src

/obj/effect/landmark/start/whiskey/Destroy()
	GLOB.whiskey_start -= src
	return ..()

/obj/effect/landmark/late_join
	name = "late join"
	icon_state = "x2"

/obj/effect/landmark/late_join/Initialize(mapload, ...)
	. = ..()
	GLOB.latejoin += src

/obj/effect/landmark/late_join/Destroy()
	GLOB.latejoin -= src
	return ..()
