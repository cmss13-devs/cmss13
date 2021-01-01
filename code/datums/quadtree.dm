
/datum/quadtree 
    var/is_divided = FALSE
    var/capacity
    var/datum/quadtree/nw_branch
    var/datum/quadtree/ne_branch
    var/datum/quadtree/sw_branch
    var/datum/quadtree/se_branch
    var/datum/shape/rectangle/boundary
    var/list/player_coords = list()
    var/z_level

/datum/quadtree/New(datum/shape/rectangle/rect, cap, z)
    ..()
    boundary = rect
    capacity = cap
    z_level = z 

/datum/quadtree/Del()
    . = ..()
    qdel(nw_branch)
    qdel(ne_branch)
    qdel(sw_branch)
    qdel(se_branch)
    qdel(boundary)

/datum/coords/player
    var/client/player

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

/datum/shape/rectangle/proc/contains_atom(var/atom/A)
    return (A.x >= center_x - width / 2  \
            && A.x <= center_x + width / 2 \
            && A.y >= center_y - height /2  \
            && A.y <= center_y + height / 2)

/datum/quadtree/proc/subdivide() 
    //Warning: this might give you eye cancer
    nw_branch = QTREE(RECT(boundary.center_x - boundary.width / 4, boundary.center_y + boundary.height/ 4, boundary.width/2, boundary.height/2), capacity, z_level)
    ne_branch = QTREE(RECT(boundary.center_x + boundary.width / 4, boundary.center_y + boundary.height/ 4, boundary.width/2, boundary.height/2), capacity, z_level)
    sw_branch = QTREE(RECT(boundary.center_x - boundary.width / 4, boundary.center_y - boundary.height/ 4, boundary.width/2, boundary.height/2), capacity, z_level)
    se_branch = QTREE(RECT(boundary.center_x + boundary.width / 4, boundary.center_y - boundary.height/ 4, boundary.width/2, boundary.height/2), capacity, z_level)
    is_divided = TRUE

/datum/quadtree/proc/insert_player(datum/coords/player/p_coords)
    if(ismob(p_coords))
        var/mob/M = p_coords
        if(!M.client)
            return FALSE
        p_coords = new
        p_coords.player = M.client
        if(!M.x && !M.y && !M.z)
            var/turf/T = get_turf(M)
            if(!T)
                return FALSE
            p_coords.x_pos = T.x
            p_coords.y_pos = T.y
            p_coords.z_pos = T.z
        else
            p_coords.x_pos = M.x
            p_coords.y_pos = M.y
            p_coords.z_pos = M.z                     

    if(p_coords.z_pos != z_level)
        return FALSE

    if(!boundary.contains(p_coords))
        return FALSE
    if(player_coords.len < capacity || \
        boundary.width <= QUADTREE_BOUNDARY_MINIMUM_WIDTH  || \
        boundary.height <= QUADTREE_BOUNDARY_MINIMUM_HEIGHT)
        
        player_coords.Add(p_coords)

    else
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
                        
    return TRUE

/datum/quadtree/proc/query_range(datum/shape/rectangle/range, list/found_players, flags = 0)
    if(!found_players)
        found_players = list()
    if(!range || !range.intersects(boundary))
        return found_players
    for(var/datum/coords/player/P in player_coords)
        if(!P.player)
            continue
        if(flags & QTREE_EXCLUDE_OBSERVER)
            if(isobserver(P.player.mob))
                continue
        if(range.contains(P))
            if(flags & QTREE_SCAN_MOBS)
                if(!P.player.mob)
                    continue
                found_players.Add(P.player.mob)
            else
                found_players.Add(P.player)
    if(is_divided)
        found_players |= (nw_branch.query_range(range, found_players, flags))
        found_players |= (ne_branch.query_range(range, found_players, flags))
        found_players |= (sw_branch.query_range(range, found_players, flags))
        found_players |= (se_branch.query_range(range, found_players, flags))
    
    return found_players