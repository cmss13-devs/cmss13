/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "You relinquish your ability to build resin secretions and sacrifice a portion of your plasma pool, alongside a slight reduction in health. In return, you gain significantly stronger pheromones, enhanced long-range vision, and the ability to place up to 12 Design Nodes that enhance the efficiency of other builders. Additionally, you can remotely reinforce resin structures, control doors from a distance, and unleash a powerful Greater Resin Surge, transforming Design Nodes into temporary reflective walls to fortify your hive."
	flavor_description = "You are hive's designer, while you no longer build with your own claws, your influence shapes the very foundation of the swarm, allowing it to expand and adapt beyond limits."
	icon_state_prefix = "Designer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/place_design, //macro 2, macro 1 is for weeds
		/datum/action/xeno_action/onclick/change_design,
		/datum/action/xeno_action/activable/greater_resin_surge, //macro 3
		/datum/action/xeno_action/onclick/toggle_long_range/designer, //macro 5
		/datum/action/xeno_action/active_toggle/toggle_speed, // macro 4
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)

/datum/xeno_strain/designer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.available_design = list(
		/obj/effect/alien/resin/design/speed_node,
		/obj/effect/alien/resin/design/cost_node,
		/obj/effect/alien/resin/design/remote,
		/obj/effect/alien/resin/design/upgrade
	)
	hivelord.selected_design = /obj/effect/alien/resin/design/speed_node
	hivelord.max_design_nodes = 12
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.health_modifier -= XENO_HEALTH_MOD_LARGE
	hivelord.phero_modifier += XENO_PHERO_MOD_LARGE
	hivelord.speed_modifier += XENO_SPEED_TIER_3 // Lost 30% plasma in sac, you lost some weight
	hivelord.plasmapool_modifier = 0.7 // -30% plasma pool
	hivelord.tacklestrength_max = 6 // increase by +1
	hivelord.recalculate_everything()

	// Also change the primacy value for our abilities (because we want the same place but have another primacy ability)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		if(istype(action, /datum/action/xeno_action/activable/place_construction))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
		if(istype(action, /datum/action/xeno_action/active_toggle/toggle_meson_vision))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			break // Stop looking for other ones

// ""animations"" (effects)
/obj/effect/resin_construct/fastweak
	icon_state = "WeakReflectiveFast"

/obj/effect/resin_construct/speed_node
	icon_state = "speednode"

/obj/effect/resin_construct/cost_node
	icon_state = "costnode"

/obj/effect/resin_construct/thickfast
	icon_state = "ThickConstructFast"

/obj/effect/resin_construct/thickdoorfast
	icon_state = "ThickDoorConstructFast"
	layer = FIREDOOR_CLOSED_LAYER

/obj/effect/resin_construct/transparent/thickfast
	icon_state = "WeakTransparentConstructFast"

// Far-sight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_5
	delay = 0

//////////////////////////
/// Designer... Paths. ///
//////////////////////////

/obj/effect/alien/resin/design
	name = "Design Node"
	desc = "A weird node, it looks mutated."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "static_speednode"
	density = FALSE
	opacity = FALSE
	layer = RESIN_UNDER_STRUCTURE_LAYER
	plane = FLOOR_PLANE
	health = HEALTH_RESIN_XENO_STICKY
	var/hivenumber = XENO_HIVE_NORMAL
	var/plasma_cost = 0

	var/mob/living/carbon/xenomorph/bound_xeno
	var/obj/effect/alien/weeds/bound_weed

/obj/effect/alien/resin/design/Initialize(mapload, obj/effect/alien/weeds/weeds, mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		return INITIALIZE_HINT_QDEL

	bound_xeno = xeno
	bound_weed = weeds
	hivenumber = xeno.hivenumber
	RegisterSignal(weeds, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))
	RegisterSignal(xeno, COMSIG_PARENT_QDELETING, PROC_REF(handle_xeno_qdel))
	set_hive_data(src, hivenumber)
	. = ..()

/obj/effect/alien/resin/design/proc/on_weed_expire()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/alien/resin/design/proc/unregister_weed_expiration_signal()
	if(bound_weed)
		UnregisterSignal(bound_weed, COMSIG_PARENT_QDELETING)

/obj/effect/alien/resin/design/proc/register_weed_expiration_signal(obj/effect/alien/weeds/new_weed)
	RegisterSignal(new_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))
	bound_weed = new_weed

/obj/effect/alien/resin/design/proc/handle_xeno_qdel()
	SIGNAL_HANDLER
	bound_xeno = null

/obj/effect/alien/resin/design/Destroy()
	if(!QDELETED(bound_xeno))
		bound_xeno.current_design.Remove(src)
	bound_xeno = null
	return ..()

/obj/effect/alien/resin/design/speed_node
	name = "Design Optimized Node (70)"
	icon_state = "static_speednode"
	plasma_cost = 70

/obj/effect/alien/resin/design/speed_node/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user) || isyautja(user))
		. += "On closer examination, this node looks like it has a big green oozing bulb at its center, making the weeds under it twitch..."
	if(isxeno(user) || isobserver(user))
		. += "You sense that building on top of this node will speed up your construction speed by [SPAN_NOTICE("50%")]."

/obj/effect/alien/resin/design/cost_node
	name = "Design Flexible Node (75)"
	icon_state = "static_costnode"
	plasma_cost = 75

/obj/effect/alien/resin/design/cost_node/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user) || isyautja(user))
		. += "On closer examination, this node looks like its made of smaller blue bulbs grown together, making the weeds under them look soft and squishy."
	if(isxeno(user) || isobserver(user))
		. += "You sense that building on top of this node will decrease plasma cost of basic resin structures by [SPAN_NOTICE("50%")]."

/obj/effect/alien/resin/design/remote
	name = "Remote Door Control (25)"
	desc = "Open and Closes Doors"
	icon = 'icons/mob/hud/actions_xeno.dmi'
	icon_state = "door_control"
	plasma_cost = 25

/obj/effect/alien/resin/design/upgrade
	name = "Thicken Resin (75)"
	desc = "Channel our plasma and nutrients to thicken structures."
	icon = 'icons/mob/hud/actions_xeno.dmi'
	icon_state = "upgrade_resin"
	plasma_cost = 75

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
	ability_primacy = XENO_PRIMARY_ACTION_3

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

	// Create overlays for all nodes on list
	for(var/obj/effect/alien/resin/design/node in xeno.current_design)
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
	for(var/obj/effect/alien/resin/design/node in xeno.current_design)
		var/turf/node_loc = get_turf(node.loc)
		if(!node_loc)
			continue
		var/obj/effect/alien/weeds/target_weeds = node_loc.weeds
		if(target_weeds && target_weeds.hivenumber == xeno.hivenumber)
			xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating an unstable wall!"),
			SPAN_XENONOTICE("We surge the resin, creating an unstable wall!"), null, 5)
			node_loc.PlaceOnTop(/turf/closed/wall/resin/reflective/weak)
			var/turf/closed/wall/resin/reflective/weak/good_wall = node_loc
			if(good_wall)
				good_wall.hivenumber = xeno.hivenumber
				set_hive_data(good_wall, xeno.hivenumber) // Ensure proper hive linking
			playsound(node_loc, "alien_resin_build", 25)
		qdel(node)
	xeno.current_design.Cut()

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

/////////////////////////////
///     Place Design      ///
/////////////////////////////

/datum/action/xeno_action/activable/place_design
	name = "Influence"
	action_icon_state = "secrete_resin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/place_design
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 0
	var/max_reach = 10

/datum/action/xeno_action/verb/place_design()
	set category = "Alien"
	set name = "Place Design"
	set hidden = TRUE
	var/action_name = "Place Design"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/place_design/use_ability(atom/target_atom, mods, use_plasma = TRUE, message = TRUE)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!can_remote_build())
		to_chat(owner, SPAN_XENONOTICE("We must be standing on weeds to channel our nutrients and influence."))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state(TRUE))
		return

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
		to_chat(xeno, SPAN_WARNING("The are no weeds to create a connection!"))
		return

	if(target_weeds.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_WARNING("These weeds do not belong to our hive; they reject our influence."))
		return

	if(locate(/obj/effect/alien/resin/design) in target_turf)
		to_chat(xeno, SPAN_XENOWARNING("There is already a node here!"))
		return

	var/plasma_cost
	if(xeno.selected_design && xeno.selected_design.plasma_cost)
		plasma_cost = xeno.selected_design.plasma_cost

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/remote))
		if(!istype(target_atom, /obj/structure/mineral_door/resin))
			to_chat(xeno, SPAN_XENOWARNING("We can only do this on resin doors!"))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		var/obj/structure/mineral_door/resin/resin_door = target_atom
		if(resin_door.TryToSwitchState(owner))
			if(resin_door.open)
				to_chat(owner, SPAN_XENONOTICE("We focus our connection to the resin and remotely close the resin door."))
			else
				to_chat(owner, SPAN_XENONOTICE("We focus our connection to the resin and remotely open the resin door."))
		return

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/upgrade))
		if(!(istype(target_atom, /turf/closed/wall/resin) || istype(target_atom, /turf/closed/wall/resin/membrane) || istype(target_atom, /obj/structure/mineral_door/resin)))
			to_chat(xeno, SPAN_XENOWARNING("We can only upgrade resin walls, membrane and doors!"))
			return

		if(!check_and_use_plasma_owner(plasma_cost))
			return

		if(istype(target_atom, /turf/closed/wall/resin) || istype(target_atom, /turf/closed/wall/resin/membrane))
			var/turf/closed/wall/resin/wall = target_atom
			if(wall.hivenumber != xeno.hivenumber)
				to_chat(xeno, SPAN_XENOWARNING("[wall] does not belong to our hive!"))
				return

			if(wall.type == /turf/closed/wall/resin)
				var/obj/thick_wall = new /obj/effect/resin_construct/thickfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					qdel(thick_wall)
					return
				qdel(thick_wall)
				wall.ChangeTurf(/turf/closed/wall/resin/thick)
			else if(wall.type == /turf/closed/wall/resin/membrane)
				var/obj/thick_membrane = new /obj/effect/resin_construct/transparent/thickfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					qdel(thick_membrane)
					return
				qdel(thick_membrane)
				wall.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
			else
				to_chat(xeno, SPAN_XENOWARNING("[wall] can't be made thicker."))
				return

		else if(istype(target_atom, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/door = target_atom

			if(door.hivenumber != xeno.hivenumber)
				to_chat(xeno, SPAN_XENOWARNING("[door] does not belong to your hive!"))
				return

			if(door.hardness == 1.5) // Normal resin door
				var/obj/thick_door = new /obj/effect/resin_construct/thickdoorfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					qdel(thick_door)
					return
				qdel(thick_door)
				var/oldloc = door.loc
				qdel(door)
				new /obj/structure/mineral_door/resin/thick(oldloc, door.hivenumber)
			else
				to_chat(xeno, SPAN_XENOWARNING("[door] can't be made thicker."))
				return

		else
			to_chat(xeno, SPAN_XENOWARNING("We can only upgrade resin structures!"))
			return

		xeno.visible_message(SPAN_XENONOTICE("Weeds around [target_atom] start to twitch and pump substance towards it, thickening it in process!"),
			SPAN_XENONOTICE("We start to channel nutrients towards [target_atom], using [plasma_cost] plasma."), null, 5)
		playsound(target_atom, "alien_resin_build", 25)

		target_atom.add_hiddenprint(xeno) // Tracks who reinforced it for admins
		return TRUE

	if(length(xeno.current_design) >= xeno.max_design_nodes) //Check if there are more nodes than lenght that was defined. (12)
		to_chat(xeno, SPAN_XENOWARNING("We cannot sustain another node, one will wither away to allow this one to live!"))
		var/obj/effect/alien/resin/design/old_design = xeno.current_design[1] //Check with node is first for deletion on list.
		xeno.current_design.Remove(old_design) //Removes first node stored inside list.
		qdel(old_design) //Delete node.

	var/selected_design = xeno.selected_design

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/speed_node)) //Check path you selected from list.
		if(!is_turf_clean(target_turf)) // Check if the turf is clean before continuing
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		var/obj/speed_warn = new /obj/effect/resin_construct/speed_node(target_turf, src, xeno) //Create "Animation" overlay.
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) || selected_design != xeno.selected_design)
			qdel(speed_warn) //Delete "Animation" overlay after defined time.
			return
		qdel(speed_warn) //Delete again just in case overlay don't get deleted.
		if(!is_turf_clean(target_turf)) // Recheck the turf again just in case
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("\The [xeno] channel nutrients and shape it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno) //Create node you selected from list.
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find node to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design) //Add Node to list.

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/cost_node))
		if(!is_turf_clean(target_turf))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		var/obj/cost_warn = new /obj/effect/resin_construct/cost_node(target_turf, src, xeno)
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) || selected_design != xeno.selected_design)
			qdel(cost_warn)
			return
		qdel(cost_warn)
		if(!is_turf_clean(target_turf))
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("The [xeno] channel nutrients and shape it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno)
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find node to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/place_design/proc/can_remote_build()
	if(!locate(/obj/effect/alien/weeds) in get_turf(owner))
		return FALSE
	return TRUE

/datum/action/xeno_action/activable/place_design/proc/is_turf_clean(turf/current_turf, check_resin_additions = FALSE, check_doors = FALSE)
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
	if(current_turf.density || has_obstacle || locate(/obj/effect/alien/resin/design) in current_turf)
		to_chat(src, SPAN_WARNING("There's something built here already."))
		return FALSE
	return TRUE

//////////////////////////
///   Change Design    ///
//////////////////////////

/datum/action/xeno_action/onclick/change_design
	name = "Choose Action"
	action_icon_state = "static_speednode"
	plasma_cost = 0
	xeno_cooldown = 0
	macro_path = /datum/action/xeno_action/verb/verb_resin_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/onclick/change_design/give_to(mob/living/carbon/xenomorph/xeno)
	. = ..()

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, initial(xeno.selected_design.icon_state))
	button.overlays += image(icon_file, button, action_icon_state)

/datum/action/xeno_action/onclick/change_design/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	tgui_interact(xeno)
	return ..()

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
			xeno.update_icons()
			button.overlays.Cut()
			button.overlays += image(icon_file, button, action_icon_state)
			button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, initial(design.icon_state))
			xeno.selected_design = selected_type
			. = TRUE

		if("refresh_ui")
			. = TRUE
