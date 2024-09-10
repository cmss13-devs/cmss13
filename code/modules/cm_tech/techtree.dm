/datum/techtree
	// General tree variables
	var/name = TREE_NONE
	var/datum/space_level/zlevel = 0
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
	if(!zlevel)
		return

	var/longest_tier = 0
	for(var/tier in all_techs)
		var/tier_length = length(all_techs[tier])
		if(longest_tier < tier_length)
			longest_tier = tier_length

	// Clear out and create the area
	// (The `+ 2` on both of these is 1 for a buffer tile, and 1 for the outer `/turf/closed/void`.)
	var/area_max_x = longest_tier * 2 + 2
	var/area_max_y = length(all_techs) * 3 + 2
	for(var/turf/pos as anything in block(1, 1, zlevel.z_value, area_max_x, area_max_y, zlevel.z_value))
		for(var/A as anything in pos)
			qdel(A)

		if(pos.x == area_max_x || pos.y == area_max_y)
			// The turfs around the edge are closed.
			pos.ChangeTurf(/turf/closed/void)
		else
			pos.ChangeTurf(/turf/open/blank)
			pos.color = "#000000"
		new /area/techtree(pos)

	// Create the tech nodes
	var/y_offset = 1
	for(var/tier in all_techs)
		var/tier_length = length(all_techs[tier])

		var/x_offset = (longest_tier - tier_length) + 1

		var/datum/tier/T = tree_tiers[tier]
		for(var/turf/pos as anything in block(x_offset, y_offset, zlevel.z_value, x_offset + tier_length*2, y_offset + 2, zlevel.z_value))
			pos.ChangeTurf(/turf/open/blank)
			pos.color = "#000000"
			LAZYADD(T.tier_turfs, pos)

		var/node_pos = x_offset + 1
		for(var/node in all_techs[tier])
			new /obj/effect/node(locate(node_pos, y_offset + 1, zlevel.z_value), all_techs[tier][node])
			node_pos += 2

		y_offset += 3

	entrance = locate(ceil((longest_tier*2 + 1)*0.5), 2, zlevel.z_value)

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
		to_chat(M, SPAN_WARNING("You do not have access to this tech tree"))
		return FALSE

	if(SEND_SIGNAL(M, COMSIG_MOB_ENTER_TREE, src, force) & COMPONENT_CANCEL_TREE_ENTRY) return

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
