/datum/unused_moba_map
	var/map_id
	var/turf/left_base
	var/turf/right_base
	var/list/turf/ai_waypoints_topleft
	var/list/turf/ai_waypoints_topright
	var/list/turf/ai_waypoints_botleft
	var/list/turf/ai_waypoints_botright
	var/turf/minion_spawn_topleft
	var/turf/minion_spawn_topright
	var/turf/minion_spawn_botleft
	var/turf/minion_spawn_botright
	var/turf/left_boss_spawn
	var/turf/right_boss_spawn

/datum/unused_moba_map/New(datum/moba_controller/old_controller)
	. = ..()
	map_id = old_controller.map_id
	left_base = old_controller.left_base
	right_base = old_controller.right_base
	ai_waypoints_topleft = old_controller.ai_waypoints_topleft
	ai_waypoints_topright = old_controller.ai_waypoints_topright
	ai_waypoints_botleft = old_controller.ai_waypoints_botleft
	ai_waypoints_botright = old_controller.ai_waypoints_botright
	minion_spawn_topleft = old_controller.minion_spawn_topleft
	minion_spawn_topright = old_controller.minion_spawn_topright
	minion_spawn_botleft = old_controller.minion_spawn_botleft
	minion_spawn_botright = old_controller.minion_spawn_botright
	left_boss_spawn = old_controller.left_boss_spawn
	right_boss_spawn = old_controller.right_boss_spawn
