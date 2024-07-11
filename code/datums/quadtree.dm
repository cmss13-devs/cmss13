
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
	var/final_divide = FALSE

/datum/quadtree/New(datum/shape/rectangle/rect, z)
	. = ..()
	boundary = rect
	z_level = z
	if(boundary.width <= QUADTREE_BOUNDARY_MINIMUM_WIDTH || boundary.height <= QUADTREE_BOUNDARY_MINIMUM_HEIGHT)
		final_divide = TRUE

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

/// A simple geometric shape for testing collisions and intersections. This one is a single point.
/datum/shape
	/// Horizontal position of the shape's center point.
	var/center_x = 0
	/// Vertical position of the shape's center point.
	var/center_y = 0
	/// Distance from the shape's leftmost to rightmost extent.
	var/bounds_x = 0
	/// Distance from the shape's topmost to bottommost extent.
	var/bounds_y = 0

/datum/shape/New()
	set_shape(arglist(args))

/// Assign shape variables.
/datum/shape/proc/set_shape(center_x, center_y)
	src.center_x = center_x
	src.center_y = center_y

/// Returns TRUE if the coordinates x, y are in or on the shape, otherwise FALSE.
/datum/shape/proc/contains_xy(x, y)
	return center_x == x && center_y == y

/// Returns TRUE if the coord datum is in or on the shape, otherwise FALSE.
/datum/shape/proc/contains_coords(datum/coords/coords)
	return contains_xy(coords.x_pos, coords.y_pos)

/// Returns TRUE if the atom is in or on the shape, otherwise FALSE.
/datum/shape/proc/contains_atom(atom/atom)
	return contains_xy(atom.x, atom.y)

/// Returns TRUE if this shape intersects the provided rectangle shape, otherwise FALSE.
/datum/shape/proc/intersects_rect(datum/shape/rectangle/range)
	return range.contains_xy(src.center_x, src.center_y)

/// A simple geometric shape for testing collisions and intersections. This one is an axis-aligned rectangle.
/datum/shape/rectangle
	/// Distance from the shape's leftmost to rightmost extent.
	var/width = 0
	/// Distance from the shape's topmost to bottommost extent.
	var/height = 0

/datum/shape/rectangle/set_shape(center_x, center_y, width, height)
	..()
	src.bounds_x = width
	src.bounds_y = height
	src.width = width
	src.height = height

/datum/shape/rectangle/contains_xy(x, y)
	return (abs(center_x - x) <= width * 0.5) && (abs(center_y - y) <= height * 0.5)

/datum/shape/rectangle/intersects_rect(datum/shape/rectangle/range)
	return (abs(src.center_x - range.center_x) <= (src.width + range.width) * 0.5) && (abs(src.center_y - range.center_y) <= (src.height + range.height) * 0.5)

/// A simple geometric shape for testing collisions and intersections. This one is an axis-aligned square.
/datum/shape/square
	/// Distance between the shape's opposing extents.
	var/length = 0

/datum/shape/square/set_shape(center_x, center_y, length)
	..()
	src.bounds_x = length
	src.bounds_y = length
	src.length = length

/datum/shape/square/contains_xy(x, y)
	return (abs(center_x - x) <= length * 0.5) && (abs(center_y - y) <= length * 0.5)

/datum/shape/square/intersects_rect(datum/shape/rectangle/range)
	return (abs(src.center_x - range.center_x) <= (src.length + range.width)  * 0.5) && (abs(src.center_y - range.center_y) <= (src.length + range.height) * 0.5)

/// A simple geometric shape for testing collisions and intersections. This one is an axis-aligned ellipse.
/datum/shape/ellipse
	/// Distance from the shape's leftmost to rightmost extent.
	var/width = 0
	/// Distance from the shape's topmost to bottommost extent.
	var/height = 0
	VAR_PROTECTED/_axis_x_sq = 0
	VAR_PROTECTED/_axis_y_sq = 0

/datum/shape/ellipse/set_shape(center_x, center_y, width, height)
	..()
	src.bounds_x = width
	src.bounds_y = height
	src.width = width
	src.height = height
	src._axis_x_sq = (width * 0.5)**2
	src._axis_y_sq = (height * 0.5)**2

/datum/shape/ellipse/contains_xy(x, y)
	return ((center_x - x)**2 / _axis_x_sq + (center_y - y)**2 / _axis_y_sq <= 1)

/datum/shape/ellipse/intersects_rect(datum/shape/rectangle/range)
	if(range.contains_xy(src.center_x, src.center_y))
		return TRUE

	var/nearest_x = clamp(src.center_x, range.center_x - range.width * 0.5, range.center_x + range.width * 0.5)
	var/nearest_y = clamp(src.center_y, range.center_y - range.height * 0.5, range.center_y + range.height * 0.5)

	return src.contains_xy(nearest_x, nearest_y)

/// A simple geometric shape for testing collisions and intersections. This one is a circle.
/datum/shape/circle
	/// Distance from the shape's center to edge.
	var/radius = 0
	VAR_PROTECTED/_radius_sq = 0

/datum/shape/circle/set_shape(center_x, center_y, radius)
	..()
	src.bounds_x = radius * 2
	src.bounds_y = radius * 2
	src.radius = radius
	src._radius_sq = radius**2

/datum/shape/circle/contains_xy(x, y)
	return ((center_x - x)**2 + (center_y - y)**2 <= _radius_sq)

/datum/shape/circle/intersects_rect(datum/shape/rectangle/range)
	if(range.contains_xy(src.center_x, src.center_y))
		return TRUE

	var/nearest_x = clamp(src.center_x, range.center_x - range.width * 0.5, range.center_x + range.width * 0.5)
	var/nearest_y = clamp(src.center_y, range.center_y - range.height * 0.5, range.center_y + range.height * 0.5)

	return src.contains_xy(nearest_x, nearest_y)

/datum/quadtree/proc/subdivide()
	//Warning: this might give you eye cancer
	nw_branch = QTREE(RECT(boundary.center_x - boundary.width / 4, boundary.center_y + boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	ne_branch = QTREE(RECT(boundary.center_x + boundary.width / 4, boundary.center_y + boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	sw_branch = QTREE(RECT(boundary.center_x - boundary.width / 4, boundary.center_y - boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	se_branch = QTREE(RECT(boundary.center_x + boundary.width / 4, boundary.center_y - boundary.height/ 4, boundary.width/2, boundary.height/2), z_level)
	is_divided = TRUE

/datum/quadtree/proc/insert_player(datum/coords/qtplayer/p_coords)
	if(!boundary.contains_coords(p_coords))
		return FALSE

	if(!player_coords)
		player_coords = list(p_coords)
		return TRUE

	else if(!final_divide && length(player_coords) >= QUADTREE_CAPACITY)
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

/datum/quadtree/proc/query_range(datum/shape/range, list/found_players, flags = 0)
	if(!found_players)
		found_players = list()
	. = found_players
	if(!range?.intersects_rect(boundary))
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
		if(range.contains_coords(P))
			if(flags & QTREE_SCAN_MOBS)
				found_players.Add(P.player.mob)
			else
				found_players.Add(P.player)

