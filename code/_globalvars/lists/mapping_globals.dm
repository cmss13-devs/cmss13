
GLOBAL_LIST_EMPTY(sorted_areas)
/// An association from typepath to area instance. Only includes areas with `unique` set.
GLOBAL_LIST_EMPTY_TYPED(areas_by_type, /area)

GLOBAL_DATUM(vehicle_elevator, /turf)
GLOBAL_LIST_EMPTY(spawns_by_job)
GLOBAL_LIST_EMPTY(spawns_by_squad_and_job)
GLOBAL_LIST_EMPTY(queen_spawns)
GLOBAL_LIST_EMPTY(xeno_spawns)
GLOBAL_LIST_EMPTY(xeno_hive_spawns)
GLOBAL_LIST_EMPTY(survivor_spawns_by_priority)
GLOBAL_LIST_EMPTY(corpse_spawns)

GLOBAL_LIST_EMPTY(mainship_yautja_teleports)
GLOBAL_LIST_EMPTY(mainship_yautja_desc)
GLOBAL_LIST_EMPTY(yautja_teleports)
GLOBAL_LIST_EMPTY(yautja_teleport_descs)
GLOBAL_LIST_EMPTY(yautja_young_teleports)
GLOBAL_LIST_EMPTY(yautja_young_descs)

GLOBAL_LIST_EMPTY(thunderdome_one)
GLOBAL_LIST_EMPTY(thunderdome_two)
GLOBAL_LIST_EMPTY(thunderdome_admin)
GLOBAL_LIST_EMPTY(thunderdome_observer)

GLOBAL_LIST_EMPTY(latewhiskey)

GLOBAL_LIST_EMPTY(latejoin)
GLOBAL_LIST_EMPTY(latejoin_by_squad)
GLOBAL_LIST_EMPTY(latejoin_by_job)

GLOBAL_LIST_EMPTY(zombie_landmarks)

GLOBAL_LIST_EMPTY(newplayer_start)
GLOBAL_LIST_EMPTY_TYPED(observer_starts, /obj/effect/landmark/observer_start)
GLOBAL_LIST_EMPTY_TYPED(spycam_starts, /obj/effect/landmark/spycam_start)

GLOBAL_LIST_EMPTY(map_items)
GLOBAL_LIST_EMPTY(xeno_tunnels)
GLOBAL_LIST_EMPTY(crap_items)
GLOBAL_LIST_EMPTY(good_items)
GLOBAL_LIST_EMPTY_TYPED(structure_spawners, /obj/effect/landmark/structure_spawner)
GLOBAL_LIST_EMPTY(hunter_primaries)
GLOBAL_LIST_EMPTY(hunter_secondaries)

GLOBAL_LIST_EMPTY(monkey_spawns)

GLOBAL_LIST_EMPTY(ert_spawns)

GLOBAL_LIST_EMPTY(simulator_targets)
GLOBAL_LIST_EMPTY(simulator_cameras)

GLOBAL_LIST_EMPTY(teleporter_landmarks)

GLOBAL_LIST_INIT(cardinals, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_EMPTY(nightmare_landmarks)
GLOBAL_LIST_EMPTY(nightmare_landmark_tags_removed)

GLOBAL_LIST_EMPTY(ship_areas)

// Objective landmarks. Value is TRUE if it contains documents
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_close, /obj/effect/landmark/objective_landmark/close)
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_medium, /obj/effect/landmark/objective_landmark/medium)
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_far, /obj/effect/landmark/objective_landmark/far)
GLOBAL_LIST_EMPTY_TYPED(objective_landmarks_science, /obj/effect/landmark/objective_landmark/science)

GLOBAL_LIST_EMPTY(comm_tower_landmarks_net_one)
GLOBAL_LIST_EMPTY(comm_tower_landmarks_net_two)

GLOBAL_LIST_EMPTY(landmarks_list) //list of all landmarks created
