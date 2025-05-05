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
		if(length(new_quadtrees) < world.maxz)
			new_quadtrees.len = world.maxz
		for(var/i in 1 to world.maxz)
			new_quadtrees[i] = QTREE(RECT(world.maxx/2,world.maxy/2, world.maxx, world.maxy), i)

	while(length(player_feed))
		var/client/C = player_feed[length(player_feed)]
		player_feed.len--
		if(!C)
			continue
		var/turf/T = get_turf(C.mob)
		if(!T?.z || length(new_quadtrees) < T.z)
			continue
		var/datum/coords/qtplayer/p_coords = new
		p_coords.player = C
		p_coords.x_pos = T.x
		p_coords.y_pos = T.y
		p_coords.z_pos = T.z
		if(isobserver(C.mob))
			p_coords.is_observer = TRUE
		var/datum/quadtree/QT = new_quadtrees[T.z]
		QT.insert_player(p_coords)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/quadtree/proc/players_in_range(datum/shape/range, z_level, flags = 0)
	var/list/players = list()
	if(!cur_quadtrees)
		return players
	if(z_level && length(cur_quadtrees) >= z_level)
		var/datum/quadtree/Q = cur_quadtrees[z_level]
		if(!Q)
			return players
		players = SEARCH_QTREE(Q, range, flags)
	return players
