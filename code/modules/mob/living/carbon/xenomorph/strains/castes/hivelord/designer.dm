/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "You lose your ability to build, sacrifice half of your plasma pool, have slower plasma regeneration and slightly less health in exchange for stronger pheromones, ability to create Design Nodes that benefit other builders. Now you can design nodes that increase building speed or decrease cost. You gain ability to call Greater Resin Surge on your Design Nodes location."
	flavor_description = "You understand weeds, you control them, they tremble in your presence."
	icon_state_prefix = "Designer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/design_speed_node, // macro 2, macro 1 is for planting
		/datum/action/xeno_action/activable/design_cost_node, // macro 3
		/datum/action/xeno_action/onclick/toggle_long_range/designer, //macro 4
		/datum/action/xeno_action/activable/greater_resin_surge, // macro 5
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)

/datum/xeno_strain/designer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.health_modifier -= XENO_HEALTH_MOD_LARGE
	hivelord.plasma_gain = XENO_PLASMA_GAIN_TIER_8
	hivelord.phero_modifier += XENO_PHERO_MOD_LARGE
	hivelord.plasmapool_modifier = 0.5 // -50% plasma pool
	hivelord.tacklestrength_max = 6 // increase by +1
	hivelord.recalculate_everything()

/datum/action/xeno_action/verb/verb_design_resin()
	set category = "Alien"
	set name = "Design Resin"
	set hidden = TRUE
	var/action_name = "Design Resin (50)"
	handle_xeno_macro(src, action_name)

/obj/effect/alien/weeds/node/designer
	desc = "A weird node, it looks mutated."
	weed_strength = WEED_LEVEL_CONSTRUCT
	hibernate = TRUE

/obj/effect/alien/weeds/node/designer/speed
	name = "Optimized Design Node"
	icon_state_weeds = "speednode"

/obj/effect/alien/weeds/node/designer/speed/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user) || isyautja(user))
		. += "On closer examination, this node looks like it has a big green oozing bulb at its center, making the weeds under it twitch..."
	if(isxeno(user) || isobserver(user))
		. += "You sense that building on top of this node will speed up your construction speed by [SPAN_NOTICE("50%")]."

/obj/effect/alien/weeds/node/designer/cost
	name = "Flexible Design Node"
	icon_state_weeds = "costnode"

/obj/effect/alien/weeds/node/designer/cost/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user) || isyautja(user))
		. += "On closer examination, this node looks like its made of smaller blue bulbs grown together, making the weeds under them look soft and squishy."
	if(isxeno(user) || isobserver(user))
		. += "You sense that building on top of this node will decrease plasma cost of basic resin structures by [SPAN_NOTICE("50%")]."

// ""animations"" (effects)
/obj/effect/resin_construct/fastweak
	icon_state = "WeakConstructFast"

/obj/effect/resin_construct/speed_node
	icon_state = "speednode"

/obj/effect/resin_construct/cost_node
	icon_state = "costnode"

// Far-sight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4
	delay = 0

//////////////////////////
//     Speed Node       //
//////////////////////////

/datum/action/xeno_action/verb/verb_speed_node()
	set category = "Alien"
	set name = "Design Optimized Node"
	set hidden = TRUE
	var/action_name = "Design Optimized Node"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/design_speed_node
	name = "Design Optimized Node (100)"
	action_icon_state = "design_speed"
	plasma_cost = 100
	xeno_cooldown = 0.5 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_speed_node
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/max_speed_reach = 10
	var/max_speed_nodes = 6

/datum/action/xeno_action/activable/design_speed_node/use_ability(atom/target_atom, mods)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

	if(mods["click_catcher"])
		return

	if(ismob(target_atom))
		if(!can_see(xeno, target_atom, max_speed_reach))
			to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
			return
	else
		if(get_dist(xeno, target_atom) > max_speed_reach)
			to_chat(xeno, SPAN_WARNING("That's too far away!"))
			return

	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))

	var/turf/target_turf = get_turf(target_atom)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	var/obj/effect/alien/weeds/node/designer/speed/existing_speed_node = locate(/obj/effect/alien/weeds/node/designer/speed) in target_turf

	// Prevent building on invalid locations
	if(!target_weeds || target_weeds.hivenumber != xeno.hivenumber || !istype(target_turf, /turf/open))
		to_chat(xeno, SPAN_WARNING("We can only construct nodes on our weeds!"))
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))
		return FALSE

	// Check if replacing an existing speed node
	var/is_replacing = existing_speed_node ? TRUE : FALSE
	var/do_after_time = is_replacing ? 0.5 SECONDS : 1 SECONDS

	// Only consume plasma when creating a new node
	if(!is_replacing && !check_and_use_plasma_owner())
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))
		return

	var/obj/speed_warn = new /obj/effect/resin_construct/speed_node(target_turf, src, xeno)

	if(!do_after(xeno, do_after_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		qdel(speed_warn)
		return

	qdel(speed_warn)

	if(is_replacing)
		// Remove the existing node from the speed node list
		xeno.speed_node_list -= existing_speed_node
		qdel(existing_speed_node)
		new /obj/effect/alien/weeds(target_turf, src, xeno)
		xeno.visible_message(SPAN_XENODANGER("[xeno] reverts the node into weeds."),
		SPAN_XENONOTICE("We restructure the node, reverting it into weeds."), null, 5)
	else
		// Create a new speed node normally
		xeno.visible_message(SPAN_XENODANGER("[xeno] surges the resin, creating a strange looking node!"),
		SPAN_XENONOTICE("We create an optimized node!"), null, 5)
		var/speed_nodes = new /obj/effect/alien/weeds/node/designer/speed(target_turf, src, xeno)
		xeno.speed_node_list += speed_nodes
		playsound(target_turf, "alien_resin_build", 25)

		if(length(xeno.speed_node_list) > max_speed_nodes)
			addtimer(CALLBACK(src, PROC_REF(remove_oldest_speed_node), xeno), 0)

	xeno_cooldown = apply_cooldown(0.5)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))
	return ..()

/datum/action/xeno_action/activable/design_speed_node/proc/remove_oldest_speed_node(mob/living/carbon/xenomorph/xeno)
	if(length(xeno.speed_node_list) > 0)
		var/obj/effect/alien/weeds/node/designer/speed/oldest_speed_node = xeno.speed_node_list[1]
		if(oldest_speed_node)
			var/turf/old_speed_loc = get_turf(oldest_speed_node.loc)
			if(old_speed_loc)
				new /obj/effect/alien/weeds(old_speed_loc, oldest_speed_node)
			qdel(oldest_speed_node)
		xeno.speed_node_list.Cut(1, 2)

//////////////////////////
//      Cost Node       //
//////////////////////////

/datum/action/xeno_action/verb/verb_cost_node()
	set category = "Alien"
	set name = "Design Flexible Node"
	set hidden = TRUE
	var/action_name = "Design Flexible Node"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/design_cost_node
	name = "Design Flexible Node (125)"
	action_icon_state = "design_cost"
	plasma_cost = 125
	xeno_cooldown = 0.5 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_cost_node
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/max_cost_reach = 10
	var/max_cost_nodes = 6

/datum/action/xeno_action/activable/design_cost_node/use_ability(atom/target_atom, mods)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

	if(mods["click_catcher"])
		return

	if(ismob(target_atom)) // Prevent using thermal vision to bypass clickcatcher
		if(!can_see(xeno, target_atom, max_cost_reach))
			to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
			return
	else
		if(get_dist(xeno, target_atom) > max_cost_reach)
			to_chat(xeno, SPAN_WARNING("That's too far away!"))
			return

	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))

	var/turf/target_turf = get_turf(target_atom)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	var/obj/effect/alien/weeds/node/designer/cost/existing_cost_node = locate(/obj/effect/alien/weeds/node/designer/cost) in target_turf

	// Prevent building on invalid locations
	if(!target_weeds || target_weeds.hivenumber != xeno.hivenumber || !istype(target_turf, /turf/open))
		to_chat(xeno, SPAN_WARNING("We can only construct nodes on our weeds!"))
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))
		return FALSE

	// Check if replacing an existing cost node
	var/is_replacing = existing_cost_node ? TRUE : FALSE
	var/do_after_time = is_replacing ? 0.5 SECONDS : 1 SECONDS

	// Only consume plasma when creating a new node
	if(!is_replacing && !check_and_use_plasma_owner())
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))
		return

	var/obj/cost_warn = new /obj/effect/resin_construct/cost_node(target_turf, src, xeno)

	if(!do_after(xeno, do_after_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		qdel(cost_warn)
		return

	qdel(cost_warn)

	if(is_replacing)
		// Remove the existing node from the cost node list
		xeno.cost_node_list -= existing_cost_node
		qdel(existing_cost_node)
		new /obj/effect/alien/weeds(target_turf, src, xeno)
		xeno.visible_message(SPAN_XENODANGER("[xeno] reverts the node into weeds."),
		SPAN_XENONOTICE("We restructure the node, reverting it into weeds."), null, 5)
	else
		// Create a new cost node normally
		xeno.visible_message(SPAN_XENODANGER("[xeno] surges the resin, creating a strange looking node!"),
		SPAN_XENONOTICE("We create a flexible node!"), null, 5)
		var/cost_nodes = new /obj/effect/alien/weeds/node/designer/cost(target_turf, src, xeno)
		xeno.cost_node_list += cost_nodes
		playsound(target_turf, "alien_resin_build", 25)

		if(length(xeno.cost_node_list) > max_cost_nodes)
			addtimer(CALLBACK(src, PROC_REF(remove_oldest_cost_node), xeno), 0)

	xeno_cooldown = apply_cooldown(0.5)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))
	return ..()

/datum/action/xeno_action/activable/design_cost_node/proc/remove_oldest_cost_node(mob/living/carbon/xenomorph/xeno)
	if(length(xeno.cost_node_list) > 0)
		var/obj/effect/alien/weeds/node/designer/cost/oldest_cost_node = xeno.cost_node_list[1]
		if(oldest_cost_node)
			var/turf/old_cost_loc = get_turf(oldest_cost_node.loc) // Get the turf of the oldest node
			if(old_cost_loc) // Ensure the turf exists
				new /obj/effect/alien/weeds(old_cost_loc, oldest_cost_node) // Replace with a new /obj/effect/alien/weeds
			qdel(oldest_cost_node) // Safely delete the old node
		xeno.cost_node_list.Cut(1, 2) // Remove the first element from the list

//////////////////////////
// Greater Resin Surge. //
//////////////////////////

/datum/action/xeno_action/verb/verb_greater_surge()
	set category = "Alien"
	set name = "Greater Resin Surge"
	set hidden = TRUE
	var/action_name = "Greater Resin Surge"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/greater_resin_surge
	name = "Greater Resin Surge (250)"
	action_icon_state = "greater_resin_surge"
	plasma_cost = 250
	xeno_cooldown = 30 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_greater_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/greater_resin_surge/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	if(!check_and_use_plasma_owner())
		return

	// Create overlays for all nodes in the speed and cost node lists
	for(var/obj/effect/alien/weeds/node/designer/node in xeno.speed_node_list + xeno.cost_node_list)
		var/turf/node_loc = get_turf(node.loc)
		if(node_loc)
			create_animation_overlay(node_loc, /obj/effect/resin_construct/fastweak)

	// Wait 1 second, then replace the nodes
	addtimer(CALLBACK(src, PROC_REF(replace_nodes)), 1 SECONDS)
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)
	return ..()

/datum/action/xeno_action/activable/greater_resin_surge/proc/replace_nodes()
	var/mob/living/carbon/xenomorph/xeno = owner

	// Replace all nodes in the speed and cost node lists
	for(var/obj/effect/alien/weeds/node/designer/node in xeno.speed_node_list + xeno.cost_node_list)
		var/turf/node_loc = get_turf(node.loc)
		if(!node_loc)
			continue

		var/obj/effect/alien/weeds/target_weeds = node_loc.weeds
		if(target_weeds && target_weeds.hivenumber == xeno.hivenumber)
			xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating an unstable wall!"),
			SPAN_XENONOTICE("We surge the resin, creating an unstable wall!"), null, 5)
			node_loc.PlaceOnTop(/turf/closed/wall/resin/weak/greater)
			var/turf/closed/wall/resin/weak/greater/good_wall = node_loc
			if(good_wall)
				good_wall.hivenumber = xeno.hivenumber
				set_hive_data(good_wall, xeno.hivenumber) // Ensure it is properly linked to the hive
			playsound(node_loc, "alien_resin_build", 25)
		qdel(node)

	// Clear both lists
	xeno.speed_node_list.Cut()
	xeno.cost_node_list.Cut()

/datum/action/xeno_action/activable/greater_resin_surge/proc/create_animation_overlay(turf/target_turf, animation_type)
	if(!istype(target_turf, /turf)) // Ensure the target is a valid turf
		return

	if(!ispath(animation_type, /obj/effect/resin_construct/fastweak)) // Ensure a valid path
		return
	//Spawn an animation effect
	var/obj/effect/resin_construct/fastweak/animation = new animation_type(target_turf)

	// Schedule deletion of the animation after 1 second
	addtimer(CALLBACK(animation, TYPE_PROC_REF(/obj/effect/resin_construct/fastweak, delete_animation), 1 SECONDS))

/obj/effect/resin_construct/fastweak/proc/delete_animation()
	if(!QDELETED(src))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/resin_construct/fastweak, perform_deletion)), 1 SECONDS)

/obj/effect/resin_construct/fastweak/proc/perform_deletion()
	if(!QDELETED(src))
		qdel(src)
