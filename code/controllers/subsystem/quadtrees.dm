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
	var/datum/shape/rectangle/rect
	for(var/i in 1 to length(cur_quadtrees))
		rect = RECT(world.maxx/2,world.maxy/2, world.maxx, world.maxy)
		new_quadtrees[i] = QTREE(rect, i)
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
		var/client/cur_client = player_feed[length(player_feed)]
		player_feed.len--
		if(!cur_client)
			continue
		var/turf/mob_turf = get_turf(cur_client.mob)
		if(!mob_turf?.z || length(new_quadtrees) < mob_turf.z)
			continue
		var/datum/coords/qtplayer/p_coords = new
		p_coords.player = cur_client
		p_coords.x_pos = mob_turf.x
		p_coords.y_pos = mob_turf.y
		p_coords.z_pos = mob_turf.z
		p_coords.non_living_mob = !isliving(cur_client.mob)
		p_coords.weak_mob = WEAKREF(cur_client.mob)
		var/datum/quadtree/quad = new_quadtrees[mob_turf.z]
		quad.insert_player(p_coords)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/quadtree/proc/players_in_range(datum/shape/range, z_level, flags = 0)
	var/list/players = list()
	if(!cur_quadtrees)
		return players
	if(z_level && length(cur_quadtrees) >= z_level)
		var/datum/quadtree/quad = cur_quadtrees[z_level]
		if(!quad)
			return players
		players = SEARCH_QTREE(quad, range, flags)
	return players
