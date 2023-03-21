SUBSYSTEM_DEF(quadtree)
	name = "Quadtree"
	wait = 0.5 SECONDS
	priority = SS_PRIORITY_QUADTREE

	var/list/cur_quadtrees
	var/list/new_quadtrees
	var/list/player_feed

/datum/controller/subsystem/quadtree/Initialize()
	cur_quadtrees = new/list(world.maxz)
	new_quadtrees = new/list(world.maxz)
	var/datum/shape/rectangle/R
	for(var/i in 1 to length(cur_quadtrees))
		R = RECT(world.maxx/2,world.maxy/2, world.maxx, world.maxy)
		new_quadtrees[i] = QTREE(R, i)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/quadtree/stat_entry(msg)
	msg = "QT:[length(cur_quadtrees)]"
	return ..()

/datum/controller/subsystem/quadtree/fire(resumed = FALSE)
	if(!resumed)
		player_feed = GLOB.clients.Copy()
		cur_quadtrees = new_quadtrees.Copy()
		if(new_quadtrees.len < world.maxz)
			new_quadtrees.len = world.maxz
		for(var/i in 1 to world.maxz)
			new_quadtrees[i] = QTREE(RECT(world.maxx/2,world.maxy/2, world.maxx, world.maxy), i)

	while(length(player_feed))
		var/client/current_client = player_feed[player_feed.len]
		player_feed.len--
		if(!current_client) continue
		var/turf/current_turf = get_turf(current_client.mob)
		if(!current_turf?.z || new_quadtrees.len < current_turf.z)
			continue
		var/datum/coords/qtplayer/p_coords = new
		p_coords.player = current_client
		p_coords.x_pos = current_turf.x
		p_coords.y_pos = current_turf.y
		p_coords.z_pos = current_turf.z
		if(isobserver(current_client.mob))
			p_coords.is_observer = TRUE
		var/datum/quadtree/QT = new_quadtrees[current_turf.z]
		QT.insert_player(p_coords)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/quadtree/proc/players_in_range(datum/shape/range, z_level, flags = 0)
	var/list/players = list()
	if(!cur_quadtrees)
		return players
	if(z_level && cur_quadtrees.len >= z_level)
		var/datum/quadtree/quadtree = cur_quadtrees[z_level]
		if(!quadtree)
			return players
		players = SEARCH_QTREE(quadtree, range, flags)
	return players
