var/datum/subsystem/quadtree/SSquadtree

/datum/subsystem/quadtree
    name = "Quadtree"
    wait = 0.5 SECONDS 
    priority = SS_PRIORITY_QUADTREE

    var/list/cur_quadtrees 
    var/list/new_quadtrees 
    var/list/player_feed
    var/qtree_capacity = QUADTREE_CAPACITY

/datum/subsystem/quadtree/New()
    NEW_SS_GLOBAL(SSquadtree)
    cur_quadtrees = new/list(world.maxz)
    new_quadtrees = new/list(world.maxz)

/datum/subsystem/quadtree/Initialize()
    var/datum/shape/rectangle/R
    for(var/i in 1 to cur_quadtrees.len)
        R = RECT(world.maxx/2,world.maxy/2, world.maxx, world.maxy)
        new_quadtrees[i] = QTREE(R, qtree_capacity, i)
    ..()

/datum/subsystem/quadtree/stat_entry()
	..("QT:[cur_quadtrees.len]")

/datum/subsystem/quadtree/fire(resumed = FALSE)
    if(!resumed)
        player_feed = player_list.Copy()
        cur_quadtrees = new_quadtrees.Copy()
        if(new_quadtrees.len < world.maxz)
            new_quadtrees.len = world.maxz
        for(var/i in 1 to world.maxz)
            new_quadtrees[i] = QTREE(RECT(world.maxx/2,world.maxy/2, world.maxx, world.maxy), qtree_capacity, i)

    while(player_feed.len)
        var/mob/M = player_feed[player_feed.len]
        player_feed.len--
        for(var/datum/quadtree/Q in new_quadtrees)
            Q.insert_player(M)
        if(MC_TICK_CHECK)
            return

/datum/subsystem/quadtree/proc/players_in_range(datum/shape/range, z_level, flags = 0)
    var/list/players = list()
    if(cur_quadtrees.len < z_level || cur_quadtrees[z_level])
        var/datum/quadtree/Q = cur_quadtrees[z_level]
        players = SEARCH_QTREE(Q, range, flags)
    return players
