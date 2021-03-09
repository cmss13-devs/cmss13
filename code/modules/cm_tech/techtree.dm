/datum/techtree
	// General tree variables
	var/name = TREE_NONE
	var/datum/space_level/zlevel = 0
	var/flags = NO_FLAGS

	var/list/cached_unlocked_techs = list()
	var/list/techs_by_type = list()
	var/list/unlocked_techs = list() // Unlocked techs (single use)
	var/list/all_techs = list() // All techs that can be unlocked. Each sorted into tiers

	var/points = INITIAL_STARTING_POINTS

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

	passive_node.make_active()

	var/longest_tier = 0
	for(var/tier in all_techs)
		var/tier_length = length(all_techs[tier])
		if(longest_tier < tier_length)
			longest_tier = tier_length

	// Clear out the area
	for(var/t in block(locate(1, 1, zlevel.z_value), locate(longest_tier * 2 + 1, length(all_techs) * 3 + 1, zlevel.z_value)))
		var/turf/pos = t
		for(var/A in pos)
			qdel(A)

		pos.ChangeTurf(/turf/open/blank)
		pos.color = "#000000"


	var/y_offset = 1
	for(var/tier in all_techs)
		var/tier_length = length(all_techs[tier])

		var/x_offset = (longest_tier - tier_length) + 1

		var/datum/tier/T = tree_tiers[tier]
		for(var/turf/pos in block(locate(x_offset, y_offset, zlevel.z_value), locate(x_offset + tier_length*2, y_offset + 2, zlevel.z_value)))
			pos.ChangeTurf(/turf/open/blank)
			pos.color = "#000000"
			LAZYADD(T.tier_turfs, pos)

		var/node_pos = x_offset + 1
		for(var/node in all_techs[tier])
			new /obj/effect/node(locate(node_pos, y_offset + 1, zlevel.z_value), all_techs[tier][node])
			node_pos += 2

		y_offset += 3

	entrance = locate(Ceiling((longest_tier*2 + 1)*0.5), 2, zlevel.z_value)

/datum/techtree/ui_status(mob/user, datum/ui_state/state)
	. = ..()

	if(has_access(user, TREE_ACCESS_MODIFY))
		return UI_INTERACTIVE

	if(has_access(user, TREE_ACCESS_VIEW))
		. = max(., UI_UPDATE)

/datum/techtree/proc/set_points(var/number)
	points = max(number, 0)

/datum/techtree/proc/add_points(var/number)
	set_points(points + number)

/datum/techtree/proc/can_use_points(var/number)
	if(number <= points)
		return TRUE
	else
		return FALSE

/datum/techtree/proc/check_and_use_points(var/number)
	if(!can_use_points(number))
		return FALSE

	add_points(-number)
	return TRUE

/datum/techtree/proc/has_access(var/mob/M, var/access_required)
	return FALSE

/datum/techtree/proc/purchase_node(var/mob/M, var/datum/tech/T)
	if(!M || M.stat == DEAD)
		return

	if(T.type in cached_unlocked_techs)
		M.show_message(SPAN_WARNING("This node is already unlocked!"))
		return

	if(!T.can_unlock(M))
		return

	unlock_node(T, M)

/datum/techtree/proc/unlock_node(var/datum/tech/T, mob/M)
	if((T.type in unlocked_techs[T.tier.type]) || !(T.type in all_techs[T.tier.type]))
		return

	if(!T.on_unlock(M))
		return

	unlocked_techs[T.tier.type] += list(T.type = T)
	cached_unlocked_techs[T.type] = T

/datum/techtree/proc/enter_mob(var/mob/M, var/force)
	if(!M.mind || M.stat == DEAD)
		return FALSE

	if(!has_access(M, TREE_ACCESS_VIEW) && !force)
		to_chat(M, SPAN_WARNING("You do not have access to this tech tree"))
		return FALSE

	if(SEND_SIGNAL(M, COMSIG_MOB_ENTER_TREE, src, force) & COMPONENT_CANCEL_TREE_ENTRY) return

	new/mob/hologram/techtree(entrance, M)

	return TRUE

/// `tech`: a typepath to a tech
/datum/techtree/proc/get_unlocked_node(var/tech)
	return cached_unlocked_techs[tech]

/// `tech`: a typepath to a tech
/datum/techtree/proc/get_node(var/tech)
	return techs_by_type[tech]

/datum/techtree/proc/on_node_gained(var/obj/structure/resource_node/RN)
	return

/datum/techtree/proc/on_node_lost(var/obj/structure/resource_node/RN)
	return

/datum/techtree/proc/on_process(var/obj/structure/resource_node/RN, delta_time)
	return

/datum/techtree/proc/can_attack(var/mob/living/carbon/H)
	return TRUE
