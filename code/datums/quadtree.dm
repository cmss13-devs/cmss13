
/datum/quadtree
	var/is_divided
	var/datum/quadtree/nw_branch
	var/datum/quadtree/ne_branch
	var/datum/quadtree/sw_branch
	var/datum/quadtree/se_branch
	var/datum/shape/rectangle/boundary
	var/list/datum/coords/qtplayer/player_coords
	var/z_level

	/// Don't divide further when truthy
	var/final

/datum/quadtree/New(datum/shape/rectangle/rect, z)
	. = ..()
	boundary = rect
	z_level = z
	if(boundary.width <= QUADTREE_BOUNDARY_MINIMUM_WIDTH || boundary.height <= QUADTREE_BOUNDARY_MINIMUM_HEIGHT)
		final = TRUE

// By design i guess, discarding branch discards rest with BYOND soft-GCing
// There should never be anything else but SSquadtree referencing quadtrees,
// so discarding top cell cascades BYOND GC deletions triggered by refcounter
// If you do anyway, either burn CPU time going through qdel / SSgarbage as usual,
// or expect mem usage to explode and DD crash as they aren't garbaged
// (note for future readers, qtree instances should either be reused, or the whole thing removed, send help)

/datum/quadtree/Destroy()
	// Basically just DON'T use qdel, safety net provided if you do anyway
	QDEL_NULL(nw_branch)
	QDEL_NULL(ne_branch)
	QDEL_NULL(sw_branch)
	QDEL_NULL(se_branch)
	QDEL_NULL(boundary)
	QDEL_NULL(player_coords)
	..()
	return QDEL_HINT_IWILLGC // Shouldn't have to begin with

/datum/coords/qtplayer
	/// Relevant client the coords are associated to
	var/client/player
	/// Truthy if player is an observer
	var/is_observer = FALSE

// Related scheme to above
/datum/coords/qtplayer/Destroy()
	player = null
	..()
	return QDEL_HINT_IWILLGC

/datum/shape //Leaving rectangles as a subtype if anyone decides to add circles later
	var/center_x = 0
	var/center_y = 0

/datum/shape/proc/intersects()
	return
/datum/shape/proc/contains()
	return

/datum/shape/rectangle
	var/width = 0
	var/height = 0

/datum/shape/rectangle/New(x, y, w, h)
	..()
	center_x = x
	center_y = y
	width = w
	height = h

/datum/shape/rectangle/intersects(datum/shape/rectangle/range)
	return !(range.center_x + range.width/2 < center_x - width / 2|| \
			range.center_x  - range.width/2 > center_x + width / 2|| \
			range.center_y + range.height/2 < center_y - height / 2|| \
			range.center_y - range.height/2 > center_y + height / 2)

/datum/shape/rectangle/contains(datum/coords/coords)
	return (coords.x_pos >= center_x - width / 2  \
			&& coords.x_pos <= center_x + width / 2 \
			&& coords.y_pos >= center_y - height /2  \
			&& coords.y_pos <= center_y + height / 2)

/datum/shape/rectangle/proc/contains_atom(atom/A)
	return (A.x >= center_x - width / 2  \
			&& A.x <= center_x + width / 2 \
			&& A.y >= center_y - height /2  \
			&& A.y <= center_y + height / 2)

/datum/quadtree/proc/subdivide()
	//Warning: this might give you eye cancer
	nw_branch = QTREE(RECT(boundary.center_x - boundary.width / 4, boundary.center_y + boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	ne_branch = QTREE(RECT(boundary.center_x + boundary.width / 4, boundary.center_y + boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	sw_branch = QTREE(RECT(boundary.center_x - boundary.width / 4, boundary.center_y - boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	se_branch = QTREE(RECT(boundary.center_x + boundary.width / 4, boundary.center_y - boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	is_divided = TRUE

/datum/quadtree/proc/insert_player(datum/coords/qtplayer/p_coords)
	if(!boundary.contains(p_coords))
		return FALSE

	if(!player_coords)
		player_coords = list(p_coords)
		return TRUE

	else if(!final && player_coords.len >= QUADTREE_CAPACITY)
		if(!is_divided)
			subdivide()
		if(nw_branch.insert_player(p_coords))
			return TRUE
		else if(ne_branch.insert_player(p_coords))
			return TRUE
		else if(sw_branch.insert_player(p_coords))
			return TRUE
		else if(se_branch.insert_player(p_coords))
			return TRUE

	player_coords.Add(p_coords)
	return TRUE

/datum/quadtree/proc/query_range(datum/shape/rectangle/range, list/found_players, flags = 0)
	if(!found_players)
		found_players = list()
	. = found_players
	if(!range?.intersects(boundary))
		return
	if(is_divided)
		nw_branch.query_range(range, found_players, flags)
		ne_branch.query_range(range, found_players, flags)
		sw_branch.query_range(range, found_players, flags)
		se_branch.query_range(range, found_players, flags)
	if(!player_coords)
		return
	for(var/datum/coords/qtplayer/P as anything in player_coords)
		if(!P.player) // Basically client is gone
			continue
		if((flags & QTREE_EXCLUDE_OBSERVER) && P.is_observer)
			continue
		if(range.contains(P))
			if(flags & QTREE_SCAN_MOBS)
				found_players.Add(P.player.mob)
			else
				found_players.Add(P.player)

