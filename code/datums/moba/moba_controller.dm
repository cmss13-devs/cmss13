/datum/moba_controller
	var/map_id = 0

	var/list/datum/moba_player/players
	var/list/datum/moba_player/team1
	var/list/datum/moba_player/team2

	// Map stuff
	var/turf/left_base
	var/turf/right_base

/datum/moba_controller/New(list/team1_players, list/team2_players, id)
	. = ..()
	team1 = team1_players
	team2 = team2_players
	players = team1_players + team2_players

	map_id = id

/datum/moba_controller/Destroy(force, ...)
	left_base = null
	right_base = null
	return ..()

/datum/moba_controller/proc/handle_map_init()
	for(var/obj/effect/landmark/moba_tunnel_spawner/tunnel_spawner in GLOB.landmarks_list)
		var/turf/tunnel_turf = get_turf(tunnel_spawner)
		qdel(tunnel_spawner)
		var/obj/structure/tunnel/moba/new_tunnel = new(tunnel_turf)
		new_tunnel.map_id = map_id

	for(var/obj/effect/landmark/moba_base in GLOB.landmarks_list)
		if(moba_base.right_base)
			right_base = get_turf(moba_base)
		else
			left_base = get_turf(moba_base)
		qdel(moba_base)

/datum/moba_controller/proc/handle_tick()
	return
