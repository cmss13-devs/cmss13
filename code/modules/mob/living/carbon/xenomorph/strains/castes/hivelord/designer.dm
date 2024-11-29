/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "Test"
	flavor_description = "what"
	icon_state_prefix = "Designer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/speed_node_place, // macro 2, macro 1 is for planting
		/datum/action/xeno_action/activable/cost_node_place, // macro 3
		/datum/action/xeno_action/onclick/toggle_long_range/designer, //macro 4
		/datum/action/xeno_action/onclick/greather_resin_surge, // macro 5
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)

/datum/xeno_strain/designer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.health_modifier -= XENO_HEALTH_MOD_LARGE
	hivelord.plasmapool_modifier = 0.5 // -50% plasma pool
	hivelord.tacklestrength_max = 6 // increase +1sec of max tackle time
	hivelord.phero_modifier += XENO_PHERO_MOD_LARGE
	hivelord.recalculate_health()
	hivelord.recalculate_plasma()
	hivelord.recalculate_pheromones()
	hivelord.recalculate_tackle()
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
	icon_state = "weednode"

/obj/effect/alien/weeds/node/designer/cost
	name = "Flexible Design Node"
	icon_state = "weednode"

// farsight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4
	delay = 0


// Speed Node

/datum/action/xeno_action/verb/verb_speed_node()
	set category = "Alien"
	set name = "Place Optimized Node"
	set hidden = TRUE
	var/action_name = "Place Optimized Node"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/speed_node_place
	name = "Place Optimized Node (100)"
	action_icon_state = "place_queen_beacon"
	plasma_cost = 100
	xeno_cooldown = 0.5 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_speed_node
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/max_speed_reach = 10
	var/max_speed_nodes = 6

/datum/action/xeno_action/activable/speed_node_place/use_ability(atom/target_atom, mods)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state(TRUE))
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

	if (!check_and_use_plasma_owner())
		return

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	var/turf/target_turf = get_turf(target_atom)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf

	if(target_weeds && istype(target_turf, /turf/open) && target_weeds.hivenumber == xeno.hivenumber)
		xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating strange looking node!"), \
		SPAN_XENONOTICE("We surge sustinance, creating optimized node!"), null, 5)

		var/speed_nodes = new /obj/effect/alien/weeds/node/designer/speed(target_turf)

		xeno.speed_node_list += speed_nodes
		playsound(target_turf, "alien_resin_build", 25)

		if(xeno.speed_node_list.len > max_speed_nodes)
			// Delete the oldest node (the first one in the list)
			var/obj/effect/alien/weeds/node/designer/speed/oldest_speed_node = xeno.speed_node_list[1]
			if(oldest_speed_node)
				var/turf/old_speed_loc = get_turf(oldest_speed_node.loc) // Get the turf of the oldest node
				if(old_speed_loc) // Ensure the turf exists
					new /obj/effect/alien/weeds(old_speed_loc) // Replace with a new /obj/effect/alien/weeds
				qdel(oldest_speed_node) // Safely delete the old node
			xeno.speed_node_list.Cut(1, 2) // Remove the first element from the list

	else if(target_turf)
		to_chat(xeno, SPAN_WARNING("You can only construct nodes on our weeds!"))
		return FALSE

	else
		xeno_cooldown = xeno_cooldown * 0.5

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)
	return ..()



// Cost Node

/datum/action/xeno_action/verb/verb_cost_node()
	set category = "Alien"
	set name = "Place Flexible Node"
	set hidden = TRUE
	var/action_name = "Place Flexible Node"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/cost_node_place
	name = "Place Flexible Node (125)"
	action_icon_state = "gardener_resin_surge"
	plasma_cost = 125
	xeno_cooldown = 0.5 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_cost_node
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/max_cost_reach = 10
	var/max_cost_nodes = 6

/datum/action/xeno_action/activable/cost_node_place/use_ability(atom/target_atom, mods)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state(TRUE))
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

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	var/turf/target_turf = get_turf(target_atom)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf

	if(target_weeds && istype(target_turf, /turf/open) && target_weeds.hivenumber == xeno.hivenumber)
		xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating strange looking node!"), \
		SPAN_XENONOTICE("We surge sustinance, creating flexible node!"), null, 5)

		var/cost_nodes = new /obj/effect/alien/weeds/node/designer/cost(target_turf)

		xeno.cost_node_list += cost_nodes
		playsound(target_turf, "alien_resin_build", 25)

		if(xeno.cost_node_list.len > max_cost_nodes)
			// Delete the oldest node (the first one in the list)
			var/obj/effect/alien/weeds/node/designer/cost/oldest_cost_node = xeno.cost_node_list[1]
			if(oldest_cost_node)
				var/turf/old_cost_loc = get_turf(oldest_cost_node.loc) // Get the turf of the oldest node
				if(old_cost_loc) // Ensure the turf exists
					new /obj/effect/alien/weeds(old_cost_loc) // Replace with a new /obj/effect/alien/weeds
				qdel(oldest_cost_node) // Safely delete the old node
			xeno.cost_node_list.Cut(1, 2) // Remove the first element from the list

	else if(target_turf)
		to_chat(xeno, SPAN_WARNING("You can only construct nodes on our weeds!"))
		return FALSE

	else
		xeno_cooldown = xeno_cooldown * 0.5

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)
	return ..()


/datum/action/xeno_action/verb/verb_greather_surge()
	set category = "Alien"
	set name = "Greather Resin Surge"
	set hidden = TRUE
	var/action_name = "Greather Resin Surge"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/greather_resin_surge
	name = "Greather Resin Surge (200)"
	action_icon_state = "gardener_resin_surge"
	plasma_cost = 250
	xeno_cooldown = 30 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_greather_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/onclick/greather_resin_surge/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state(TRUE))
		return

	if (!check_and_use_plasma_owner())
		return

	if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	for(var/obj/effect/alien/weeds/node/designer/speed/node in xeno.speed_node_list)
		if(node)
			var/turf/node_loc = get_turf(node.loc)
			if(node_loc)
				node_loc.PlaceOnTop(/turf/closed/wall/resin/weak) // Replace with weeds
			qdel(node) // Delete the node
	xeno.speed_node_list.Cut() // Clear the speed node list

	// Iterate through the cost node list
	for(var/obj/effect/alien/weeds/node/designer/cost/node in xeno.cost_node_list)
		if(node)
			var/turf/node_loc = get_turf(node.loc)
			if(node_loc)
				node_loc.PlaceOnTop(/turf/closed/wall/resin/weak) // Replace with weeds
			qdel(node) // Delete the node
	xeno.cost_node_list.Cut() // Clear the cost node list

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)
	return ..()
