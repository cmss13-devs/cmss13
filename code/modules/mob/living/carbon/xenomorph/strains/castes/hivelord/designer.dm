/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "You lose your ability to build, sacrifice half of your plasma pool, have slower plasma regeneration and slightly less health in exchange for stronger phermones, ability to create Design Nodes that benefit other builders. Now you can design nodes that increase building speed or decrease cost. You gain ability to call Greater Resin Surge on your Design Nodes location."
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
	ADD_TRAIT(hivelord, TRAIT_ABILITY_SIGHT_IGNORE_REST, TRAIT_SOURCE_STRAIN)

/datum/action/xeno_action/verb/verb_design_resin()
	set category = "Alien"
	set name = "Design Resin"
	set hidden = TRUE
	var/action_name = "Design Resin (50)"
	handle_xeno_macro(src, action_name)

/obj/effect/alien/weeds/node/designer
	desc = "A wierd node, it look mutated."
	weed_strength = WEED_LEVEL_CONSTRUCT
	hibernate = TRUE

/obj/effect/alien/weeds/node/designer/speed
	name = "Optimized Design Node"
	icon_state = "speednode"
	designspeed = TRUE

/obj/effect/alien/weeds/node/designer/cost
	name = "Flexible Design Node"
	icon_state = "costnode"
	designcost = TRUE


// ""animations""" (effects)

/obj/effect/resin_construct/fastweak
	icon_state = "WeakConstructFast"

/obj/effect/resin_construct/speed_node
	icon_state = "speednode"

/obj/effect/resin_construct/cost_node
	icon_state = "costnode"

// farsight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4
	delay = 0

// Speed Node

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
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

	if(mods["click_catcher"])
		return

	if(ismob(target_atom)) // to prevent using thermal vision to bypass clickcatcher
		if(!can_see(xeno, target_atom, max_speed_reach))
			to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
			return
	else
		if(get_dist(xeno, target_atom) > max_speed_reach)
			to_chat(xeno, SPAN_WARNING("That's too far away!"))
			return

	if(!check_and_use_plasma_owner())
		return

	// Apply the immobilized trait to the xeno
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))

	var/turf/target_turf = get_turf(target_atom)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	var/obj/speed_warn

	if(target_turf)
		speed_warn = new /obj/effect/resin_construct/cost_node(target_turf)

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	qdel(speed_warn)

	if(target_weeds && istype(target_turf, /turf/open) && target_weeds.hivenumber == xeno.hivenumber)
		xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating strange looking node!"), \
		SPAN_XENONOTICE("We surge sustinance, creating optimized node!"), null, 5)

		var/speed_nodes = new /obj/effect/alien/weeds/node/designer/speed(target_turf)

		xeno.speed_node_list += speed_nodes
		playsound(target_turf, "alien_resin_build", 25)

		if(xeno.speed_node_list.len > max_speed_nodes)
			var/obj/effect/alien/weeds/node/designer/speed/oldest_speed_node = xeno.speed_node_list[1]
			if(oldest_speed_node)
				var/turf/old_speed_loc = get_turf(oldest_speed_node.loc)
				if(old_speed_loc)
					new /obj/effect/alien/weeds(old_speed_loc)
				qdel(oldest_speed_node)
			xeno.speed_node_list.Cut(1, 2)

	else if(target_turf)
		to_chat(xeno, SPAN_WARNING("You can only construct nodes on our weeds!"))
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))
		return FALSE

	else
		xeno_cooldown = xeno_cooldown * 0.5
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)

	// Remove the immobilized trait after the ability has been cast
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_speed"))

	return ..()



// Cost Node

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
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

	if(mods["click_catcher"])
		return

	if(ismob(target_atom)) // to prevent using thermal vision to bypass clickcatcher
		if(!can_see(xeno, target_atom, max_cost_reach))
			to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
			return
	else
		if(get_dist(xeno, target_atom) > max_cost_reach)
			to_chat(xeno, SPAN_WARNING("That's too far away!"))
			return

	if (!check_and_use_plasma_owner())
		return

	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))

	var/turf/target_turf = get_turf(target_atom)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	var/obj/cost_warn

	if(target_turf)
		cost_warn = new /obj/effect/resin_construct/cost_node(target_turf)

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	qdel(cost_warn)

	if(target_weeds && istype(target_turf, /turf/open) && target_weeds.hivenumber == xeno.hivenumber)
		xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating strange looking node!"), \
		SPAN_XENONOTICE("We surge sustinance, creating flexible node!"), null, 5)

		var/cost_nodes = new /obj/effect/alien/weeds/node/designer/cost(target_turf)

		xeno.cost_node_list += cost_nodes
		playsound(target_turf, "alien_resin_build", 25)

		if(xeno.cost_node_list.len > max_cost_nodes) // Delete the oldest node (the first one in the list)
			var/obj/effect/alien/weeds/node/designer/cost/oldest_cost_node = xeno.cost_node_list[1]
			if(oldest_cost_node)
				var/turf/old_cost_loc = get_turf(oldest_cost_node.loc) // Get the turf of the oldest node
				if(old_cost_loc) // Ensure the turf exists
					new /obj/effect/alien/weeds(old_cost_loc) // Replace with a new /obj/effect/alien/weeds
				qdel(oldest_cost_node) // Safely delete the old node
			xeno.cost_node_list.Cut(1, 2) // Remove the first element from the list

	else if(target_turf)
		to_chat(xeno, SPAN_WARNING("You can only construct nodes on our weeds!"))
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))
		return FALSE

	else
		xeno_cooldown = xeno_cooldown * 0.5
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)

	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("design_cost"))

	return ..()

// Greather Resin Surge.

/datum/action/xeno_action/verb/verb_greater_surge()
	set category = "Alien"
	set name = "Greather Resin Surge"
	set hidden = TRUE
	var/action_name = "Greather Resin Surge"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/greater_resin_surge
	name = "Greather Resin Surge (250)"
	action_icon_state = "greater_resin_surge"
	plasma_cost = 250
	xeno_cooldown = 30 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_greater_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/greater_resin_surge/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	if(!check_and_use_plasma_owner())
		return

	// Create overlays for speed nodes and schedule their replacement
	for(var/obj/effect/alien/weeds/node/designer/speed/node in xeno.speed_node_list)
		if(node)
			var/turf/node_loc = get_turf(node.loc)
			if(node_loc)
				create_animation_overlay(node_loc, /obj/effect/resin_construct/fastweak)

	for(var/obj/effect/alien/weeds/node/designer/cost/node in xeno.cost_node_list)
		if(node)
			var/turf/node_loc = get_turf(node.loc)
			if(node_loc)
				create_animation_overlay(node_loc, /obj/effect/resin_construct/fastweak)

	//Wait 1 second, then replace the nodes
	spawn(1 SECONDS)
		for(var/obj/effect/alien/weeds/node/designer/speed/node in xeno.speed_node_list)
			if(node)
				var/turf/node_loc = get_turf(node.loc)
				if(node_loc)
					node_loc.PlaceOnTop(/turf/closed/wall/resin/weak/greater) // Replace with weeds
				qdel(node) // Delete the node
		xeno.speed_node_list.Cut() // Clear the speed node list

		for(var/obj/effect/alien/weeds/node/designer/cost/node in xeno.cost_node_list)
			if(node)
				var/turf/node_loc = get_turf(node.loc)
				if(node_loc)
					node_loc.PlaceOnTop(/turf/closed/wall/resin/weak/greater)
				qdel(node)
		xeno.cost_node_list.Cut()

	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)
	return ..()

/proc/create_animation_overlay(turf/target_turf, animation_type)
	if(!istype(target_turf, /turf)) // Ensure the target is a valid turf
		return

	if(!ispath(animation_type, /obj/effect/resin_construct/fastweak)) // Ensure a valid path
		return

	//Spawn an animation effect
	var/obj/effect/resin_construct/fastweak/animation = new animation_type(target_turf)
	animation.loc = target_turf

	//Automatically delete the animation after 1 second
	spawn(1 SECONDS)
		if(animation)
			qdel(animation)
