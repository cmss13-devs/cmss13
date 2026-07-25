/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "You give up direct resin building, lose some plasma and health, but gain stronger pheromones and longer vision. You can place up to 36 design nodes: optimized nodes boost building by 50%, flexible nodes reduce plasma cost by 50%, and construct nodes allow anyone to donate plasma to build weedbound resin walls or doors, even on surfaces where we can't normally build. Some castes like hivelord, carrier, burrower and queen can stimulate construct nodes to make thick weedbound variant including gardener drone. You can mark nodes as walls or doors, remotely thicken structures, control doors, and remove nodes. Using Greater Resin Surge turns all design nodes into weaker reflective walls for temporary hive defense. Your tackle is slightly stronger, causing longer knockdowns."
	flavor_description = "You are hive's designer, while you no longer build with your own claws, your influence shapes the very foundation of the swarm, allowing it to expand beyond limits."
	icon_state_prefix = "Designer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/change_design, //macro 2, macro 1 is for weeds
		/datum/action/xeno_action/activable/place_design, //macro 3
		/datum/action/xeno_action/onclick/toggle_design_icons, //macro 4
		/datum/action/xeno_action/activable/greater_resin_surge, //macro 5
		/datum/action/xeno_action/onclick/toggle_long_range/designer,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)

	behavior_delegate_type = /datum/behavior_delegate/hivelord_designer

/datum/xeno_strain/designer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.available_design = list(
		/obj/effect/alien/resin/design/speed_node,
		/obj/effect/alien/resin/design/cost_node,
		/obj/effect/alien/resin/design/construct_node,
		/obj/effect/alien/resin/design/upgrade,
		/obj/effect/alien/resin/design/remove,
	)
	hivelord.selected_design_mark = /datum/design_mark/resin_wall
	hivelord.plasma_types = list(PLASMA_NUTRIENT, PLASMA_PHEROMONE)
	hivelord.max_design_nodes = 36
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.health_modifier -= XENO_HEALTH_MOD_LARGE
	hivelord.phero_modifier += XENO_PHERO_MOD_LARGE
	hivelord.plasmapool_modifier = 0.7 //-30% plasma pool
	hivelord.tacklestrength_min_modifier += 1
	hivelord.tacklestrength_max_modifier += 1
	hivelord.recalculate_everything()

	// Also change the primacy value for our abilities (because we want the same place but have another primacy ability)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		if(istype(action, /datum/action/xeno_action/activable/place_construction))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			continue
		if(istype(action, /datum/action/xeno_action/active_toggle/toggle_meson_vision))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			continue
		if(istype(action, /datum/action/xeno_action/active_toggle/toggle_speed))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			continue

/datum/behavior_delegate/hivelord_designer
	name = "Hivelord Designer Behavior Delegate"

/datum/behavior_delegate/hivelord_designer/append_to_stat()
	. = list()
	. += "Nodes sustained: [length(bound_xeno.current_design)] / [bound_xeno.max_design_nodes]"

// Far-sight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	delay = 0

//Marks
/datum/design_mark
	var/name = "xeno_declare"
	var/icon_state = "empty"
	var/desc = "Xenos make psychic markers with this meaning as positional lasting communication to each other."

/datum/design_mark/resin_wall
	name = "Resin Wall"
	desc = "Place resin wall here!"
	icon_state = "mark_wall"

/datum/design_mark/resin_door
	name = "Resin Door"
	desc = "Place resin door here!"
	icon_state = "mark_door"

/datum/action/xeno_action/proc/update_mouse_pointer()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(xeno.selected_design == /obj/effect/alien/resin/design/speed_node)
		if(xeno.selected_design_mark == /datum/design_mark/resin_wall)
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/spd_wall_mouse.dmi')
		else
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/spd_door_mouse.dmi')
		return

	if(xeno.selected_design == /obj/effect/alien/resin/design/cost_node)
		if(xeno.selected_design_mark == /datum/design_mark/resin_wall)
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/cost_wall_mouse.dmi')
		else
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/cost_door_mouse.dmi')
		return

	if(xeno.selected_design == /obj/effect/alien/resin/design/construct_node)
		if(xeno.selected_design_mark == /datum/design_mark/resin_wall)
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/const_wall_mouse.dmi')
		else
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/const_door_mouse.dmi')
		return

//------------------------------------------//
//-------// Greater Resin Surge. //---------//
//------------------------------------------//

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

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	for(var/obj/effect/alien/resin/design/node in xeno.current_design)
		if(get_dist(xeno, node) > 7)
			continue

		var/turf/node_loc = get_turf(node.loc)
		if(node_loc)
			create_animation_overlay(node_loc, /obj/effect/resin_construct/fastweak)

	addtimer(CALLBACK(src, PROC_REF(replace_nodes)), 1 SECONDS)
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)
	return ..()

/datum/action/xeno_action/activable/greater_resin_surge/proc/replace_nodes()
	var/mob/living/carbon/xenomorph/xeno = owner
	for(var/obj/effect/alien/resin/design/node in xeno.current_design.Copy())
		if(get_dist(xeno, node) > 7)
			continue

		var/turf/node_loc = get_turf(node.loc)
		if(!node_loc)
			continue

		var/obj/effect/alien/weeds/target_weeds = node_loc.weeds
		if(target_weeds && target_weeds.hivenumber == xeno.hivenumber)
			xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating an unstable wall!"),
				SPAN_XENONOTICE("We surge the resin, creating an unstable wall!"), null, 5)

			node_loc.place_on_top(/turf/closed/wall/resin/reflective/weak)
			var/turf/closed/wall/resin/reflective/weak/good_wall = node_loc
			if(good_wall)
				good_wall.hivenumber = xeno.hivenumber
				set_hive_data(good_wall, xeno.hivenumber)
			playsound(node_loc, "alien_resin_build", 25)

		qdel(node)
		xeno.current_design -= node

/datum/action/xeno_action/activable/greater_resin_surge/proc/create_animation_overlay(turf/target_turf, animation_type)
	if(!istype(target_turf, /turf))
		return

	if(!ispath(animation_type, /obj/effect/resin_construct/fastweak))
		return
	var/obj/effect/resin_construct/fastweak/animation = new animation_type(target_turf)

	addtimer(CALLBACK(animation, TYPE_PROC_REF(/obj/effect/resin_construct/fastweak, delete_animation)), 2 SECONDS)

/obj/effect/resin_construct/fastweak/proc/delete_animation()
	if(!QDELETED(src))
		qdel(src)

//------------------------------------------//
//-----------// Place Design //-------------//
//------------------------------------------//

/datum/action/xeno_action/activable/place_design
	name = "Influence"
	action_icon_state = "secrete_resin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/place_design
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 0
	/// How far we can reach with remote design placement.
	var/max_reach = 10
	/// Toggle state for design icon.
	var/design_toggle = TRUE

/datum/action/xeno_action/activable/place_design/action_activate()
	. = ..()
	update_mouse_pointer()

/datum/action/xeno_action/activable/place_design/use_ability(atom/target_atom, mods, use_plasma = TRUE, message = TRUE)
	var/mob/living/carbon/xenomorph/xeno = owner

	var/obj/effect/alien/weeds/current_weeds = locate(/obj/effect/alien/weeds) in get_turf(xeno)

	if(!current_weeds)
		to_chat(xeno, SPAN_XENONOTICE("We must be standing on weeds to channel our nutrients and influence."))
		return

	if(current_weeds.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_XENOWARNING("These weeds we stand on do not belong to our hive."))
		return

	XENO_ACTION_CHECK(xeno)

	if(mods["click_catcher"])
		return

	if(ismob(target_atom))
		if(!can_see(xeno, target_atom, max_reach))
			to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
			return
	else
		if(get_dist(xeno, target_atom) > max_reach)
			to_chat(xeno, SPAN_WARNING("That's too far away!"))
			return

	var/turf/target_turf = get_turf(target_atom)
	if(!istype(target_turf))
		to_chat(xeno, SPAN_WARNING("We cannot design without weeds."))
		return

	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	if(!target_weeds)
		to_chat(xeno, SPAN_WARNING("There are no weeds to create a connection!"))
		return

	if(target_weeds.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_WARNING("These weeds do not belong to our hive; they reject our influence."))
		return

	var/plasma_cost
	if(xeno.selected_design && xeno.selected_design.plasma_cost)
		plasma_cost = xeno.selected_design.plasma_cost

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/upgrade))
		if(!(istype(target_atom, /turf/closed/wall/resin) || istype(target_atom, /turf/closed/wall/resin/membrane) || istype(target_atom, /obj/structure/mineral_door/resin)))
			to_chat(xeno, SPAN_XENOWARNING("We can only upgrade resin walls, membrane and doors!"))
			return

		if(istype(target_atom, /turf/closed/wall/resin) || istype(target_atom, /turf/closed/wall/resin/membrane))
			var/turf/closed/wall/resin/wall = target_atom

			if(wall.hivenumber != xeno.hivenumber)
				to_chat(xeno, SPAN_XENOWARNING("[wall] does not belong to our hive!"))
				return

			if(wall.upgrading_now) //<--- Prevent spam and waste of plasma
				to_chat(xeno, SPAN_WARNING("This wall is already being reinforced!"))
				return

			wall.upgrading_now = TRUE

			if(wall.type == /turf/closed/wall/resin)
				var/obj/thick_wall = new /obj/effect/resin_construct/thickfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
					qdel(thick_wall)
					wall.upgrading_now = FALSE
					return
				qdel(thick_wall)
				wall.ChangeTurf(/turf/closed/wall/resin/thick)

			else if(wall.type == /turf/closed/wall/resin/membrane)
				var/obj/thick_membrane = new /obj/effect/resin_construct/transparent/thickfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
					qdel(thick_membrane)
					wall.upgrading_now = FALSE
					return
				qdel(thick_membrane)
				wall.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
			else
				to_chat(xeno, SPAN_XENOWARNING("[wall] can't be made thicker."))
				return

			wall.upgrading_now = FALSE

		else if(istype(target_atom, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/door = target_atom

			if(door.hivenumber != xeno.hivenumber)
				to_chat(xeno, SPAN_XENOWARNING("[door] does not belong to your hive!"))
				return

			if(door.upgrading_now)
				to_chat(xeno, SPAN_WARNING("This door is already being reinforced!"))
				return

			if(door.hardness == 1.5)
				door.upgrading_now = TRUE
				var/obj/thick_door = new /obj/effect/resin_construct/thickdoorfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
					qdel(thick_door)
					door.upgrading_now = FALSE
					return
				qdel(thick_door)
				var/oldloc = door.loc
				qdel(door)
				new /obj/structure/mineral_door/resin/thick(oldloc, door.hivenumber)
			else
				if(xeno.try_toggle_resin_door(door))
					if(!check_and_use_plasma_owner())
						return TRUE
					return
				return

		else
			to_chat(xeno, SPAN_XENOWARNING("We can only upgrade resin structures!"))
			return

		if(!check_and_use_plasma_owner(plasma_cost))
			return

		xeno.visible_message(SPAN_XENONOTICE("Weeds around [target_atom] start to twitch and pump substance towards it, thickening it in process!"),
			SPAN_XENONOTICE("We start to channel nutrients towards [target_atom], using [plasma_cost] plasma."), null, 5)
		playsound(target_atom, "alien_resin_build", 25)

		target_atom.add_hiddenprint(xeno) //Tracks who reinforced it for admins
		return TRUE

	if(xeno.try_toggle_resin_door(target_atom))
		if(!check_and_use_plasma_owner())
			return TRUE
		return

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/remove))
		var/obj/effect/alien/resin/design/target_node = locate(/obj/effect/alien/resin/design) in target_turf
		if(!target_node)
			to_chat(xeno, SPAN_XENOWARNING("There is no resin node here to remove!"))
			return

		if(target_node.hivenumber != xeno.hivenumber)
			to_chat(xeno, SPAN_XENOWARNING("This node does not belong to your hive!"))
			return

		if(target_node.bound_xeno != xeno)
			to_chat(xeno, SPAN_XENOWARNING("We cannot remove a node placed by another sister!"))
			return

		qdel(target_node)
		to_chat(xeno, SPAN_XENONOTICE("We sever the bond to the node, causing it to dissolve into the ground."))
		playsound(xeno.loc, "alien_resin_move2", 25)
		return

	if(length(xeno.current_design) >= xeno.max_design_nodes) //Check if there are more nodes than length that was defined
		to_chat(xeno, SPAN_XENOWARNING("We cannot sustain another node, one will wither away to allow this one to live!"))
		var/obj/effect/alien/resin/design/old_design = xeno.current_design[1] //Check with node is first for deletion on list
		xeno.current_design.Remove(old_design) //Removes first node stored inside list
		qdel(old_design) //Delete node.

	var/selected_design = xeno.selected_design

	var/obj/effect/alien/resin/design/existing_node = locate(/obj/effect/alien/resin/design) in target_turf
	if(existing_node && xeno.selected_design_mark)
		if(!istype(existing_node.mark_meaning, xeno.selected_design_mark))
			existing_node.mark_meaning = new xeno.selected_design_mark
			existing_node.refresh_marker()
			to_chat(xeno, SPAN_XENONOTICE("We reshape the meaning of our node."))
		return

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/speed_node)) //Check path you selected from list
		if(!is_turf_clean(target_turf, check_resin_doors = TRUE))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		var/obj/speed_warn = new /obj/effect/resin_construct/speed_node(target_turf, src, xeno) //Create "Animation" overlay
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) || selected_design != xeno.selected_design)
			qdel(speed_warn) //Delete "Animation" overlay after defined time
			return
		qdel(speed_warn) //Delete again just in case overlay don't get deleted
		if(!is_turf_clean(target_turf)) //Recheck the turf again just in case
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("\The [xeno] channels nutrients and shapes it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno) //Create node you selected from list
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find node to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design) //Add Node to list.

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/cost_node))
		if(!is_turf_clean(target_turf, check_resin_doors = TRUE))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		var/obj/cost_warn = new /obj/effect/resin_construct/cost_node(target_turf, src, xeno)
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) || selected_design != xeno.selected_design)
			qdel(cost_warn)
			return
		qdel(cost_warn)
		if(!is_turf_clean(target_turf))
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("The [xeno] channels nutrients and shapes it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno)
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find placeholder to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design)

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/construct_node))
		if(!is_turf_clean(target_turf, check_resin_doors = TRUE))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		if(!xeno.check_alien_construction(target_turf, check_doors = FALSE))
			return FALSE
		var/obj/const_warn = new /obj/effect/resin_construct/construct_node(target_turf, src, xeno)
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) || selected_design != xeno.selected_design)
			qdel(const_warn)
			return
		qdel(const_warn)
		if(!is_turf_clean(target_turf))
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("The [xeno] channels nutrients and shapes it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno)
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find placeholder to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design)
	apply_cooldown()
	return ..()

/mob/living/carbon/xenomorph/proc/try_toggle_resin_door(atom/target_atom)
	if(!istype(target_atom, /obj/structure/mineral_door/resin))
		return FALSE

	var/obj/structure/mineral_door/resin/resin_door = target_atom

	if(resin_door.hivenumber != hivenumber)
		to_chat(src, SPAN_XENOWARNING("This door does not belong to our hive!"))
		return TRUE

	if(resin_door.TryToSwitchState(src))
		if(resin_door.open)
			to_chat(src, SPAN_XENONOTICE("We focus our connection to the resin and remotely close the resin door."))
		else
			to_chat(src, SPAN_XENONOTICE("We focus our connection to the resin and remotely open the resin door."))

	return TRUE

/datum/action/xeno_action/activable/place_design/proc/is_turf_clean(turf/current_turf, check_resin_additions = FALSE, check_doors = FALSE, check_resin_doors = FALSE)
	var/has_obstacle = FALSE
	for(var/obj/target in current_turf)
		if(check_doors)
			if(istype(target, /obj/structure/machinery/door))
				to_chat(src, SPAN_WARNING("[target] is blocking the resin! There's not enough space to build that here."))
				return FALSE
		if(check_resin_additions)
			if(istype(target, /obj/effect/alien/resin/sticky) || istype(target, /obj/effect/alien/resin/spike) || istype(target, /obj/effect/alien/resin/sticky/fast))
				has_obstacle = TRUE
				to_chat(src, SPAN_WARNING("[target] is blocking the resin!"))
				return FALSE
		if(check_resin_doors)
			if(istype(target, /obj/structure/mineral_door/resin))
				to_chat(src, SPAN_WARNING("[target] is blocking the resin node! There's not enough space to build that here."))
				return FALSE
	if(current_turf.density || has_obstacle || locate(/obj/effect/alien/resin/design) in current_turf)
		return FALSE
	return TRUE

//------------------------------------------//
//---------// Change Node Marker //---------//
//------------------------------------------//

/datum/action/xeno_action/onclick/toggle_design_icons
	name = "Change Design Mark"
	action_icon_state = "design_mark_1"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_design_icons
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/toggle_design_icons/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.buckled && !xeno.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/toggle_design_icons/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	if(!xeno.check_state(TRUE))
		return

	var/datum/action/xeno_action/activable/place_design/cAction = get_action(xeno, /datum/action/xeno_action/activable/place_design)

	if(!istype(cAction))
		return

	cAction.design_toggle = !cAction.design_toggle

	var/action_icon_result
	if(cAction.design_toggle)
		action_icon_result = "design_mark_1"
		to_chat(xeno, SPAN_INFO("We will now place wall markers."))
		xeno.selected_design_mark = /datum/design_mark/resin_wall
	else
		action_icon_result = "design_mark_2"
		to_chat(xeno, SPAN_INFO("We will now place door markers."))
		xeno.selected_design_mark = /datum/design_mark/resin_door

	update_mouse_pointer()
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
	return ..()

//------------------------------------------//
//-----------// Change Design //------------//
//------------------------------------------//

/datum/action/xeno_action/onclick/change_design
	name = "Choose Action"
	action_icon_state = "static_speednode"
	plasma_cost = 0
	xeno_cooldown = 0
	macro_path = /datum/action/xeno_action/verb/verb_change_design
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/change_design/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	var/static/list/options = list(
		"Optimized Node (50)" = icon(/datum/action/xeno_action::icon_file, "static_speednode"),
		"Construct Node (50)" = icon(/datum/action/xeno_action::icon_file, "static_constructnode"),
		"Thicken Resin (60)" = icon(/datum/action/xeno_action::icon_file, "upgrade_resin"),
		"Open Old UI" = icon(/datum/action/xeno_action::icon_file, "open_ui"),
		"Remove Node" = icon(/datum/action/xeno_action::icon_file, "remove_node"),
		"Flexible Node (50)" = icon(/datum/action/xeno_action::icon_file, "static_costnode")
	)

	var/choice
	if(owner.client.prefs.no_radials_preference)
		choice = tgui_input_list(owner, "Choose Desing Option", "Pick", options, theme="hive_status")
	else
		choice = show_radial_menu(owner, owner?.client.get_eye(), options, radius = 50)

	var/des = FALSE
	var/rem = FALSE
	plasma_cost = 0
	switch(choice)
		if("Optimized Node (50)")
			xeno.selected_design = /obj/effect/alien/resin/design/speed_node
			des = TRUE
		if("Flexible Node (50)")
			xeno.selected_design = /obj/effect/alien/resin/design/cost_node
			des = TRUE
		if("Construct Node (50)")
			xeno.selected_design = /obj/effect/alien/resin/design/construct_node
			des = TRUE
		if("Thicken Resin (60)")
			xeno.selected_design = /obj/effect/alien/resin/design/upgrade
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/upgrade_mouse.dmi')
			rem = TRUE
		if("Remove Node")
			xeno.selected_design = /obj/effect/alien/resin/design/remove
			xeno.set_action_cursor('icons/effects/mouse_pointer/designer/remove_mouse.dmi')
			rem = TRUE
		if("Open Old UI")
			tgui_interact(xeno)

	if(des)
		to_chat(xeno, SPAN_NOTICE("We will now build <b>[xeno.selected_design.name]</b>."))
	if(rem)
		to_chat(xeno, SPAN_NOTICE("We will now remotely <b>[xeno.selected_design.name]</b>."))

	update_mouse_pointer()
	button.overlays.Cut()
	button.overlays += image(icon_file, button, xeno.selected_design.icon_state)

	return ..()

// Below is UI for old players.

/datum/action/xeno_action/onclick/change_design/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/choose_design))

/datum/action/xeno_action/onclick/change_design/ui_static_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()

	var/list/design_list = list()
	for(var/obj/effect/alien/resin/design/design as anything in xeno.available_design)
		var/list/entry = list()

		entry["name"] = initial(design.name)
		entry["desc"] = initial(design.desc)
		entry["image"] = replacetext(initial(design.icon_state), " ", "-")
		entry["id"] = "[design]"
		design_list += list(entry)

	.["design"] = design_list

/datum/action/xeno_action/onclick/change_design/ui_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()
	.["selected_design"] = xeno.selected_design

/datum/action/xeno_action/onclick/change_design/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChooseDesign", "Choose Design")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/action/xeno_action/onclick/change_design/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/action/xeno_action/onclick/change_design/ui_state(mob/user)
	return GLOB.always_state

/datum/action/xeno_action/onclick/change_design/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/xeno = ui.user
	if(!istype(xeno))
		return

	switch(action)
		if("choose_design")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in xeno.available_design))
				return

			var/obj/effect/alien/resin/design/design = selected_type
			to_chat(xeno, SPAN_NOTICE("We will now build <b>[initial(design.name)]</b> when designing."))
			//update the button's overlay with new choice
			button.overlays.Cut()
			button.overlays += image(icon_file, button, action_icon_state)
			button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, initial(design.icon_state))
			xeno.selected_design = selected_type
			. = TRUE

		if("refresh_ui")
			. = TRUE
