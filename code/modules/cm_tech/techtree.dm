/datum/techtree
	// General tree variables
	var/name = TREE_NONE
	var/flags = NO_FLAGS

	var/list/cached_unlocked_techs = list()
	var/list/techs_by_type = list()
	var/list/unlocked_techs = list() // Unlocked techs (single use)
	var/list/all_techs = list() // All techs that can be unlocked. Each sorted into tiers

	var/background_icon = "background"
	var/background_icon_locked = "marine"
	var/turf/entrance

	// Tier variables
	var/datum/tier/tier = /datum/tier/free
	var/list/datum/tier/tree_tiers = TECH_TIER_GAMEPLAY

	// Resource variables
	var/resource_icon_state = ""
	var/resource_make_sound = 'sound/machines/click.ogg'
	var/resource_destroy_sound = 'sound/machines/click.ogg'

	var/resource_break_sound = 'sound/machines/click.ogg'
	var/resource_harvest_sound = 'sound/machines/click.ogg'

	var/resource_receive_process = FALSE

	var/obj/structure/resource_node/passive_node

	// Tech points
	var/total_points = 0 // How many points we have earned total.
	var/total_points_last_sitrep = 0 // The total points we had at the last announcement. Used to calculate how many points were earned since then.
	var/points = INITIAL_STARTING_POINTS // Current points.
	var/points_mult = 1 // Factor we earn points by. Increases based on current unlocked tech tier.

	// UI Variables
	var/ui_theme

/datum/techtree/New()
	. = ..()

	for(var/type in tree_tiers)
		var/datum/tier/T = new type(src)
		tree_tiers[type] = T


	tier = tree_tiers[tier]

/datum/techtree/proc/generate_tree()
	var/longest_tier = 0
	for(var/tier in all_techs)
		var/tier_length = length(all_techs[tier])
		if(longest_tier < tier_length)
			longest_tier = tier_length

	// Clear out and create the area
	// (+1 for a buffer tile, and +2 for the outer `/turf/closed/void`s.)
	var/area_max_x = longest_tier * 2 + 1 + 2
	var/area_max_y = length(all_techs) * 3 + 1 + 2

	var/area/techtree/techtree_area = GLOB.areas_by_type[/area/techtree]
	if(!techtree_area) // create a new area instance
		techtree_area = new
	var/datum/turf_reservation/reservation = SSmapping.request_turf_block_reservation(
		area_max_x,
		area_max_y,
		turf_type_override = /turf/open/blank
	)
	if(!reservation)
		CRASH("Failed to reserve a block for techtree: '[type]'")
	var/turf/bottom_left = reservation.bottom_left_turfs[1] // 1z only
	var/turf/top_right = reservation.top_right_turfs[1] // 1z only
	var/turf/top_left = locate(bottom_left.x, top_right.y, bottom_left.z)
	var/turf/bottom_right = locate(top_right.x, bottom_left.y, bottom_left.z)
	// give all of them their area
	// we don't use change_area to avoid wasting time trying to transfer nonexistent lighting
	for(var/turf/pos in block(bottom_left, top_right))
		var/area/old_area = get_area(pos)
		TRANSFER_TURF_CONTAINED_AREA(pos, old_area, techtree_area)
		techtree_area.contents += pos
	// now close the edge turfs
	for(var/turf/pos in block(bottom_left, top_left)) // left wall
		pos.ChangeTurf(/turf/closed/void)
	for(var/turf/pos in block(bottom_left, bottom_right)) // bottom wall
		pos.ChangeTurf(/turf/closed/void)
	for(var/turf/pos in block(bottom_right, top_right)) // right wall
		pos.ChangeTurf(/turf/closed/void)
	for(var/turf/pos in block(top_left, top_right)) // top wall
		pos.ChangeTurf(/turf/closed/void)

	// Create the tech nodes
	var/y_offset = bottom_left.y + 1 // +1 so that it's centered and has 1 tile between it and the border on top and bottom
	for(var/tier in all_techs)
		var/tier_length = length(all_techs[tier])

		var/x_offset = bottom_left.x + (longest_tier - tier_length) + 1 // +1 for the inner void wall

		var/datum/tier/T = tree_tiers[tier]
		LAZYINITLIST(T.tier_turfs)
		// we use tier_length*2 because we place one tech every other tile
		// this ends up being a 1+2*length by 3 rectangle, so a line with a buffer above and below
		T.tier_turfs += block(x_offset, y_offset, bottom_left.z, x_offset + tier_length*2, y_offset + 2)

		var/node_pos = x_offset + 1 // add the buffer tile to start, so techs don't begin right up against the wall
		for(var/node in all_techs[tier])
			new /obj/effect/node(locate(node_pos, y_offset + 1, bottom_left.z), all_techs[tier][node])
			node_pos += 2

		y_offset += 3

	// entrance is located at the bottom row, in the middle
	// we technically need to subtract one from the x, but then we add one back for the void tile
	entrance = locate(bottom_left.x + ceil((longest_tier*2 + 1)*0.5), bottom_left.y + 1, bottom_left.z)

/datum/techtree/ui_status(mob/user, datum/ui_state/state)
	. = ..()

	if(user.stat == DEAD)
		return UI_UPDATE

	if(has_access(user, TREE_ACCESS_MODIFY))
		return UI_INTERACTIVE

	if(has_access(user, TREE_ACCESS_VIEW))
		. = max(., UI_UPDATE)

/datum/techtree/proc/set_points(number)
	points = max(number, 0)

/datum/techtree/proc/add_points(number)
	set_points(points + (number * points_mult))
	total_points += number * points_mult

/datum/techtree/proc/spend_points(number)
	set_points(points - number)

/datum/techtree/proc/can_use_points(number)
	if(number <= points)
		return TRUE
	return FALSE

/datum/techtree/proc/check_and_use_points(number)
	if(!can_use_points(number))
		return FALSE
	spend_points(number)
	return TRUE

/datum/techtree/proc/has_access(mob/M, access_required)
	return FALSE

/datum/techtree/proc/purchase_node(mob/M, datum/tech/T)
	if(!M || M.stat == DEAD)
		return

	if(T.type in cached_unlocked_techs)
		M.show_message(SPAN_WARNING("This node is already unlocked!"))
		return

	if(!T.can_unlock(M))
		return

	unlock_node(T, M)

/datum/techtree/proc/unlock_node(datum/tech/T, mob/M)
	if((T.type in unlocked_techs[T.tier.type]) || !(T.type in all_techs[T.tier.type]))
		return

	if(!T.on_unlock(M))
		return

	unlocked_techs[T.tier.type] += list(T.type = T)
	cached_unlocked_techs[T.type] = T

/datum/techtree/proc/enter_mob(mob/M, force)
	if(!M.mind || M.stat == DEAD)
		return FALSE

	if(!has_access(M, TREE_ACCESS_VIEW) && !force)
		to_chat(M, SPAN_WARNING("You do not have access to this tech tree."))
		return FALSE

	if(SEND_SIGNAL(M, COMSIG_MOB_ENTER_TREE, src, force) & COMPONENT_CANCEL_TREE_ENTRY)
		return

	var/tech_hologram = new/mob/hologram/techtree(entrance, M)

	M.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	M.sync_lighting_plane_alpha()

	M.RegisterSignal(tech_hologram, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, reset_lighting_alpha))

	return TRUE

/// `tech`: a typepath to a tech
/datum/techtree/proc/get_unlocked_node(tech)
	return cached_unlocked_techs[tech]

/// `tech`: a typepath to a tech
/datum/techtree/proc/get_node(tech)
	RETURN_TYPE(/datum/tech)
	return techs_by_type[tech]

/datum/techtree/proc/on_node_gained(obj/structure/resource_node/RN)
	return

/datum/techtree/proc/on_node_lost(obj/structure/resource_node/RN)
	return

/datum/techtree/proc/on_process(obj/structure/resource_node/RN, delta_time)
	return

/datum/techtree/proc/can_attack(mob/living/carbon/H)
	return TRUE

/// Triggered just after a tier change
/datum/techtree/proc/on_tier_change(datum/tier/oldtier)
	return
