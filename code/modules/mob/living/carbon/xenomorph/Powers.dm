
/mob/living/carbon/xenomorph/proc/build_resin(atom/target, node_fill_override, thick = FALSE, message = TRUE, use_plasma = TRUE, add_build_mod = 1)
	if(!selected_resin && !node_fill_override)
		return SECRETE_RESIN_FAIL_NODEBREAK

	var/obj/effect/alien/resin/building_node/node_in_turf = locate() in get_turf(target)
	var/mob/living/carbon/xenomorph/queen/queen_source = src
	// Ovi queens need special handling for this, as their remote build would mean they have no way of dispeling marks, and their node queue handles building on marks anyways
	if(node_in_turf && isqueen(src) && queen_source.ovipositor && isnull(node_fill_override))
		return handle_building_node(target, selected_resin)

	// Set the override resin to the node's type
	// But only if the xeno actually has that type of resin!
	if(node_in_turf && node_in_turf.planter == src && (node_in_turf.resin_type in caste.resin_build_order))
		node_fill_override = node_in_turf.resin_type

	var/datum/resin_construction/resin_construct
	if(node_fill_override)
		resin_construct = GLOB.resin_constructions_list[node_fill_override]
	else
		resin_construct = GLOB.resin_constructions_list[selected_resin]

	var/total_resin_cost = XENO_RESIN_BASE_COST + resin_construct.cost // Live, diet, shit code, repeat

	if(resin_construct.scaling_cost && use_plasma)
		var/area/target_area = get_area(target)
		if(target_area && target_area.openable_turf_count)
			var/density_ratio = target_area.current_resin_count / target_area.openable_turf_count
			if(density_ratio > 0.4)
				total_resin_cost = ceil(total_resin_cost * (density_ratio + 0.35) * 2)
				if(total_resin_cost > plasma_max && (XENO_RESIN_BASE_COST + resin_construct.cost) < plasma_max)
					total_resin_cost = plasma_max

	if(!check_state())
		return SECRETE_RESIN_FAIL

	if(resin_construct.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		var/current_amount = length(built_structures[resin_construct.build_path])
		if(current_amount >= resin_construct.max_per_xeno)
			to_chat(src, SPAN_XENOWARNING("We've already built the maximum possible [initial(resin_construct.name)]\s we can!"))
			return SECRETE_RESIN_FAIL_NODEBREAK

	if(SSinterior.in_interior(src))
		to_chat(src, SPAN_XENOWARNING("It's too tight in here to build."))
		return SECRETE_RESIN_FAIL_NODEBREAK

	if(extra_build_dist != IGNORE_BUILD_DISTANCE && get_dist(src, target) > src.caste.max_build_dist + extra_build_dist)
		return handle_building_node(target, resin_construct)

	// Use plasma AFTER trying to make a building node, which is free.
	if(use_plasma && !check_plasma(total_resin_cost, message))
		return SECRETE_RESIN_FAIL

	if(thick) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(target, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/wall = target

			if(istype(target, /turf/closed/wall/resin/weak))
				to_chat(src, SPAN_XENOWARNING("[wall] is too flimsy to be reinforced."))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in wall.effects_list)
				to_chat(src, SPAN_XENOWARNING("The extra resin is preventing us from reinforcing [wall]. Wait until it elapse."))
				return SECRETE_RESIN_FAIL

			if (wall.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[wall] doesn't belong to your hive!"))
				return SECRETE_RESIN_FAIL

			if(wall.type == /turf/closed/wall/resin)
				wall.ChangeTurf(/turf/closed/wall/resin/thick)
				total_resin_cost = XENO_THICKEN_WALL_COST
			else if(wall.type == /turf/closed/wall/resin/membrane)
				wall.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
				total_resin_cost = XENO_THICKEN_MEMBRANE_COST
			else
				to_chat(src, SPAN_XENOWARNING("[wall] can't be made thicker."))
				return SECRETE_RESIN_FAIL
			thickened = TRUE

		else if(istype(target, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/door = target
			if (door.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[door] doesn't belong to your hive!"))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in door.effects_list)
				to_chat(src, SPAN_XENOWARNING("The extra resin is preventing us from reinforcing [door]. Wait until it elapse."))
				return SECRETE_RESIN_FAIL

			if(door.hardness == 1.5) //non thickened
				var/oldloc = door.loc
				qdel(door)
				new /obj/structure/mineral_door/resin/thick (oldloc, door.hivenumber)
				total_resin_cost = XENO_THICKEN_DOOR_COST
			else
				to_chat(src, SPAN_XENOWARNING("[door] can't be made thicker."))
				return SECRETE_RESIN_FAIL
			thickened = TRUE

		if(thickened)
			if(message)
				visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and thickens [target]."),
					SPAN_XENONOTICE("We regurgitate some resin and thicken [target], using [total_resin_cost] plasma."), null, 5)
				if(use_plasma)
					use_plasma(total_resin_cost)
				playsound(loc, "alien_resin_build", 25)
			target.add_hiddenprint(src) //so admins know who thickened the walls
			return TRUE

	// Weed check after thickening check for thickening walls and doors without weeds underneath.

	var/turf/current_turf = get_turf(target)
	if(!current_turf)
		return
	var/obj/effect/alien/weeds/alien_weeds = current_turf.weeds
	if(!alien_weeds || alien_weeds.secreting)
		return SECRETE_RESIN_FAIL

	if(alien_weeds.hivenumber != hivenumber)
		to_chat(src, SPAN_DANGER("These aren't our weeds!"))
		return

	// Designate a mark if the door can't be built there right now.
	switch(resin_construct.can_build_here(current_turf, src))
		if(UNBUILDABLE_TURF)
			return SECRETE_RESIN_FAIL
		if(UNSUPPORTED_TURF)
			// Only clear the mark if this is not node autobuild.
			if(node_fill_override)
				return SECRETE_RESIN_UNSUPPORTED
			else
				return handle_building_node(target, resin_construct)

	// Queue it up!
	if(action_busy && !can_stack_builds)
		if(node_fill_override) // We know that it came from node filling, so we don't use the proc as it'd just remove the mark.
			return SECRETE_RESIN_FAIL
		else
			return handle_building_node(target, resin_construct)

	var/wait_time = resin_construct.build_time * caste.build_time_mult * add_build_mod

	for(var/obj/effect/alien/resin/design/speed_node/sn in current_turf.contents)
		wait_time -= ((resin_construct.build_time * caste.build_time_mult) / 2)

	for(var/obj/effect/alien/resin/design/cost_node/cn in current_turf.contents)
		total_resin_cost -= (total_resin_cost / 2)


	var/obj/warning
	var/succeeded = TRUE
	if(resin_construct.build_overlay_icon)
		warning = new resin_construct.build_overlay_icon(current_turf)

	if(resin_construct.build_animation_effect)
		warning = new resin_construct.build_animation_effect(current_turf)

		switch(wait_time)
			if(1 SECONDS)
				warning.icon_state = "[warning.icon_state]Fast"
			if(4 SECONDS)
				warning.icon_state = "[warning.icon_state]Slow"

	alien_weeds.secreting = TRUE
	alien_weeds.update_icon()

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, alien_weeds))
		succeeded = FALSE

	qdel(warning)

	if(!QDELETED(alien_weeds))
		alien_weeds.secreting = FALSE
		alien_weeds.update_icon()

	if(!succeeded)
		return SECRETE_RESIN_INTERRUPT

	if(maybe_convert_to_weedbound(current_turf, resin_construct, thick))
		if(use_plasma)
			use_plasma(total_resin_cost)
		if(message)
			visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and shapes it into \a [resin_construct.construction_name]!"),
				SPAN_XENONOTICE("We regurgitate some resin and shape it into \a [resin_construct.construction_name][use_plasma ? " at the cost of a total [total_resin_cost] plasma" : ""]."), null, 5)
			playsound(loc, "alien_resin_build", 25)
		return SECRETE_RESIN_SUCCESS

	if(!resin_construct.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	if(use_plasma)
		use_plasma(total_resin_cost)
	if(message)
		visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and shapes it into \a [resin_construct.construction_name]!"),
			SPAN_XENONOTICE("We regurgitate some resin and shape it into \a [resin_construct.construction_name][use_plasma ? " at the cost of a total [total_resin_cost] plasma" : ""]."), null, 5)
		playsound(loc, "alien_resin_build", 25)

	var/atom/new_resin = resin_construct.build(current_turf, hivenumber, src)
	if(succeeded)
		for(var/obj/effect/alien/resin/design/node in current_turf)
			qdel(node)
		for(var/obj/effect/alien/resin/building_node/node2 in current_turf)
			qdel(node2)
	if(resin_construct.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		LAZYADD(built_structures[resin_construct.build_path], new_resin)
		RegisterSignal(new_resin, COMSIG_PARENT_QDELETING, PROC_REF(remove_built_structure))

	new_resin.add_hiddenprint(src) //so admins know who placed it

	var/area/resin_area = get_area(new_resin)
	if(resin_area && resin_area.linked_lz)
		new_resin.AddComponent(/datum/component/resin_cleanup)

	if(istype(new_resin, /turf/closed))
		for(var/mob/living/carbon/human/enclosed_human in new_resin.contents)
			if(enclosed_human.stat == DEAD && enclosed_human.is_revivable(TRUE))
				msg_admin_niche("[key_name_admin(src)] has built a closed resin structure, [new_resin.name], on top of a revivable human, [key_name_admin(enclosed_human)], at [ADMIN_VERBOSEJMP(new_resin)]")
		for(var/turf/cardinal as anything in CARDINAL_TURFS(new_resin))
			if(!is_enclosed_turf(cardinal))
				continue
			for(var/mob/living/carbon/human/enclosed_human in cardinal.contents)
				if(enclosed_human.stat == DEAD && enclosed_human.is_revivable(TRUE))
					msg_admin_niche("[key_name_admin(src)] has built a closed resin structure, [new_resin.name], enclosing a revivable human, [key_name_admin(enclosed_human)], at [ADMIN_VERBOSEJMP(new_resin)]")

	// Enable the xeno's other nodes now
	for(var/obj/effect/alien/resin/building_node/node_to_enable in current_building_nodes)
		node_to_enable.set_temp_disable(FALSE)

	SEND_SIGNAL(src, COMSIG_XENO_FINISH_BUILDING)

	return SECRETE_RESIN_SUCCESS

/mob/living/carbon/xenomorph/proc/handle_building_node(atom/target, datum/resin_construction/resin_construct)

	// Multiple xenos can place marks down in one location
	for(var/obj/effect/alien/resin/building_node/found_node in get_turf(target))
		if(found_node && found_node.planter == src)
			to_chat(src, SPAN_WARNING("We clear the psychic mark from that location."))
			qdel(found_node)
			return SECRETE_RESIN_FAIL

	// Weed check! Only place marks on weeds.
	var/turf/current_turf = get_turf(target)
	if(!current_turf)
		return
	var/obj/effect/alien/weeds/alien_weeds = current_turf.weeds
	if(!alien_weeds || alien_weeds.secreting)
		return SECRETE_RESIN_FAIL_NODEBREAK

	if(alien_weeds.hivenumber != hivenumber)
		to_chat(src, SPAN_DANGER("These aren't our weeds!"))
		return

	if(resin_construct.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		var/current_amount = length(built_structures[resin_construct.build_path])
		if(current_amount >= resin_construct.max_per_xeno)
			to_chat(src, SPAN_XENOWARNING("We've already built the maximum possible [initial(resin_construct.name)]\s we can!"))
			return SECRETE_RESIN_FAIL_NODEBREAK

	// No message to prevent spam from trying to thicken.
	if(!check_alien_construction(get_turf(target), check_doors = TRUE))
		return

	new /obj/effect/alien/resin/building_node(get_turf(target), src, resin_construct.type)
	return SECRETE_RESIN_NODE

/obj/effect/alien/resin/building_node
	name = "building node"
	icon_state = "nest"
	// The player sees the client image holder, not the 'real' node.
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	/// Xeno that planted the node.
	var/mob/living/carbon/xenomorph/planter
	/// Type of resin to build.
	var/datum/resin_construction/resin_type
	/// List of invisible effects that will cause the planter to start filling it up when standing on.
	var/list/obj/effect/fill_spot/fill_spots
	/// We use a special effect to only show the mark to the xeno that made it.
	var/obj/effect/client_image_holder/resin_building_node/node_image
	/// If the node is an ovipositor node that queues up the next one.
	var/ovi_node = FALSE
	/// If node is temporarily disabled due to an unsupported turf. Removes and readds fill spots via the set proc.
	var/temp_disable = FALSE

/obj/effect/alien/resin/building_node/Initialize(mapload, planter, datum/resin_construction/resin_type)
	. = ..()
	var/area/area = get_area(src)
	if(area)
		if(area.linked_lz)
			AddComponent(/datum/component/resin_cleanup)
		setup_fill_spots()
	src.planter = planter
	src.resin_type = resin_type

	var/mob/living/carbon/xenomorph/planter_xeno = planter
	if(!planter_xeno)
		qdel(src)
		return

	LAZYADD(planter_xeno.current_building_nodes, src)

	if(isqueen(planter))
		var/mob/living/carbon/xenomorph/queen/planter_queen = planter
		if(planter_queen.ovipositor)
			ovi_node = TRUE

	create_node_image(planter)
	// Create the client mark image
	RegisterSignal(src, COMSIG_TURF_WEED_DESTROYED, PROC_REF(on_weed_removal))

	// Recreate client images when client comes back
	RegisterSignal(planter_xeno, COMSIG_MOB_LOGGED_IN, PROC_REF(create_node_image))

// Delete and create a new node image.
/obj/effect/alien/resin/building_node/proc/create_node_image(mob/planter_xeno)
	if(node_image)
		qdel(node_image)
	node_image = new /obj/effect/client_image_holder/resin_building_node(get_turf(src), list(planter_xeno), resin_type, src, ovi_node)

/obj/effect/alien/resin/building_node/Destroy()
	QDEL_NULL_LIST(fill_spots)
	QDEL_NULL(node_image)
	var/mob/living/carbon/xenomorph/planter_xeno = planter
	if(planter_xeno)
		LAZYREMOVE(planter_xeno.current_building_nodes, src)
	planter = null
	UnregisterSignal(src, COMSIG_TURF_WEED_DESTROYED)
	// Make sure it's out of the node list!
	return ..()

/obj/effect/alien/resin/building_node/proc/on_weed_removal()
	qdel(src)

/obj/effect/alien/resin/building_node/proc/clear_fill_spots()
	QDEL_NULL_LIST(fill_spots)
	fill_spots = list()

/obj/effect/alien/resin/building_node/proc/setup_fill_spots()
	clear_fill_spots()
	for(var/turf/T in range(1,loc))
		var/obj/effect/fill_spot/new_fill_spot = new(T)
		new_fill_spot.linked_node = src
		LAZYADD(fill_spots, new_fill_spot)

/obj/effect/fill_spot
	name = "plasma fill spot"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/building_node/linked_node


/obj/effect/fill_spot/Destroy()
	if(linked_node)
		linked_node.fill_spots -= src
		linked_node = null
	. = ..()

/obj/effect/fill_spot/Crossed(atom/A)
	..()
	if(!linked_node)
		qdel(src)
		return

	try_fill_node(A)

/obj/effect/fill_spot/proc/try_fill_node(atom/movable/A)
	var/mob/living/carbon/xenomorph/wanderer = A
	if(!istype(wanderer))
		return
	if(wanderer != linked_node.planter)
		return


	// Build turfs (walls) before objects (doors, and others)
	// This is because 1. Walls are the most important resin construction, 2. Walls are necessary for doors
	if((linked_node.resin_type in typesof(/datum/resin_construction/resin_obj)))
		for(var/obj/effect/fill_spot/additional_spot in get_turf(wanderer))
			if(additional_spot.linked_node.resin_type in typesof(/datum/resin_construction/resin_turf))
				additional_spot.try_fill_node(wanderer)
				return

	// This causes a delay if the build fails for some other reason, which gives some breathing room and a small cooldown. And also prevents a infinite loop.
	if(linked_node.try_fill(wanderer) == SECRETE_RESIN_SUCCESS)
		// Try to fill nearby nodes afterwards too
		for(var/obj/effect/fill_spot/extra_spot in get_turf(wanderer))
			if(extra_spot.linked_node == linked_node)
				continue
			//INVOKE_ASYNC(extra_spot, TYPE_PROC_REF(/obj/effect/fill_spot, try_fill_node), wanderer)
			extra_spot.try_fill_node(wanderer)

/obj/effect/alien/resin/building_node/proc/try_fill(mob/living/carbon/xenomorph/filler, build_cost = TRUE)
	var/turf/nodeturf = get_turf(src)
	if(isnull(nodeturf))
		qdel(src)
		return

	// Do we have the right resin constructions to fill this node?
	var/datum/resin_construction/type_to_build = check_construction_type(filler)

	// Failed to fill a identical match or variant match.
	if(!type_to_build)
		return

	switch(filler.build_resin(src, type_to_build, message = TRUE, use_plasma = build_cost))
		// If this fails catastrophically, break the current node
		if(SECRETE_RESIN_FAIL_NODEBREAK)
			QDEL_NULL(src)
		// Disable node if unsupported, to enable when a node succeeds
		if(SECRETE_RESIN_UNSUPPORTED)
			set_temp_disable(TRUE)
		// Enable all adjacent nodes if this is a success
		if(SECRETE_RESIN_SUCCESS)
			return SECRETE_RESIN_SUCCESS

/// This proc at first tries to find an exact match for the node's resin construction datum.
/// If it fails, it instead attempts to find a variant (thick|queen) that works as a substitute.
/obj/effect/alien/resin/building_node/proc/check_construction_type(mob/living/carbon/xenomorph/filler)
	for(var/xeno_build_type in filler.resin_build_order)
		// We prefer an exact match if possible.
		if(xeno_build_type == resin_type.type)
			return xeno_build_type
		//otherwise a variant of the resin type will do.
		for(var/possible_build_variant in GLOB.resin_constructions_list[resin_type].types_of_variants)
			if(xeno_build_type == possible_build_variant)
				return possible_build_variant
	return

/// Temporarily disabled due to an unsupported turf return.
/// Enabled when another node is succesfully built next to it.
/obj/effect/alien/resin/building_node/proc/set_temp_disable(set_to = TRUE)
	temp_disable = set_to
	if(temp_disable)
		clear_fill_spots()
		node_image.alpha = 127
	else
		setup_fill_spots()
		node_image.alpha = 255

/obj/effect/client_image_holder/resin_building_node
	desc = "A psychic node to mark future building spots."
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// Resin construction type, used to source the icon and state.
	var/datum/resin_construction/resin_icon_source
	/// If this node was made by a queen on ovipositor. Colors it yellow and indicates it was placed in a queue earlier.
	var/ovi_node = FALSE
	/// The node this effect is displaying.
	var/obj/effect/alien/resin/building_node/parent_node

/obj/effect/client_image_holder/resin_building_node/Initialize(mapload, list/mobs_which_see_us, datum/resin_construction/resin_type, obj/effect/alien/resin/building_node/parent_node, ovi_node = FALSE)
	resin_icon_source = resin_type
	if(!resin_icon_source)
		return INITIALIZE_HINT_QDEL
	src.ovi_node = ovi_node
	src.parent_node = parent_node
	return ..()

/obj/effect/client_image_holder/resin_building_node/Destroy(force)
	resin_icon_source = null
	parent_node = null
	return ..()

/obj/effect/client_image_holder/resin_building_node/generate_image()
	var/image/created = image(parent_node.icon, src, resin_icon_source.buildnode_icon, image_layer, src.dir, image_pixel_x, image_pixel_y)
	if(ovi_node)
		created.color = COLOR_YELLOW
	else
		created.color = parent_node.planter.hive.color

	if(parent_node.temp_disable)
		parent_node.alpha = 127
	else
		parent_node.alpha = 255

	return created

/mob/living/carbon/xenomorph/proc/maybe_convert_to_weedbound(turf/current_turf, datum/resin_construction/resin_construct, thick = FALSE)
	if(current_turf.is_weedable != SEMI_WEEDABLE)
		return FALSE

	var/obj/effect/alien/resin/design/the_node = null
	for(var/obj/effect/alien/resin/design/node in current_turf)
		the_node = node
		break

	if(!the_node)
		return FALSE

	if(istype(resin_construct, /datum/resin_construction/resin_turf/wall))
		if(thick)
			current_turf.place_on_top(/turf/closed/wall/resin/weedbound/thick)
		else
			current_turf.place_on_top(/turf/closed/wall/resin/weedbound/normal)

		qdel(the_node)
		return TRUE

	else if(istype(resin_construct, /datum/resin_construction/resin_obj/door))
		if(thick)
			new /obj/structure/mineral_door/resin/weedbound/thick(current_turf)
		else
			new /obj/structure/mineral_door/resin/weedbound/normal(current_turf)

		qdel(the_node)
		return TRUE

	to_chat(src, SPAN_XENOWARNING("This node only accepts sturdy walls or doors."))
	return FALSE

/mob/living/carbon/xenomorph/proc/remove_built_structure(atom/A)
	SIGNAL_HANDLER
	LAZYREMOVE(built_structures[A.type], A)
	if(!built_structures[A.type])
		built_structures -= A.type

/mob/living/carbon/xenomorph/proc/place_construction(turf/current_turf, datum/construction_template/xenomorph/structure_template)
	if(!structure_template || !check_state() || action_busy)
		return

	var/current_area_name = get_area_name(current_turf)
	var/obj/effect/alien/resin/construction/new_structure = new(current_turf, hive)
	new_structure.set_template(structure_template)
	hive.add_construction(new_structure)

	var/max_constructions = hive.hive_structures_limit[structure_template.name]
	var/remaining_constructions = max_constructions - hive.get_structure_count(structure_template.name)
	visible_message(SPAN_XENONOTICE("A thick substance emerges from the ground and shapes into \a [new_structure]."),
		SPAN_XENONOTICE("We designate a new [structure_template] construction. ([remaining_constructions]/[max_constructions] remaining)"), null, 5)
	playsound(new_structure, "alien_resin_build", 25)

	if(hive.living_xeno_queen)
		xeno_message("Hive: A new <b>[structure_template]<b> construction has been designated at [sanitize_area(current_area_name)]!", 3, hivenumber)

/mob/living/carbon/xenomorph/proc/make_marker(turf/target_turf)
	if(!target_turf)
		return FALSE
	if(istype(target_turf, /turf/open/space/transit))
		to_chat(src, SPAN_NOTICE("What would that achieve?!"))
		return
	var/found_weeds = FALSE
	if(!selected_mark)
		to_chat(src, SPAN_NOTICE("We must have a meaning for the mark before you can make it."))
		hive.mark_ui.open_mark_menu(src)
		return FALSE

	if(!SSmapping.same_z_map(z, target_turf.loc.z))
		to_chat(src, SPAN_XENOWARNING("Our mind cannot reach that far."))
		return

	if(!(istype(target_turf)) || target_turf.density)
		return FALSE
	for(var/atom/movable/AM  in target_turf.contents)
		if(istype(AM, /obj/effect/alien/weeds))
			found_weeds = TRUE
		if(AM.density || istype(AM, /obj/effect/alien/resin))
			to_chat(src, SPAN_XENONOTICE("There's not enough space there for a resin mark."))
			return FALSE

	var/obj/effect/alien/resin/marker/NM = new /obj/effect/alien/resin/marker(target_turf, src)
	playsound(target_turf, "alien_resin_build", 25)

	if(!found_weeds)
		to_chat(src, SPAN_XENOMINORWARNING("We made the resin mark on ground with no weeds, it will break soon without any."))

	if(isqueen(src))
		NM.color = "#7a21c4"
	else
		NM.color = "#db6af1"
	if(hive.living_xeno_queen)
		var/current_area_name = get_area_name(target_turf)

		for(var/mob/living/carbon/xenomorph/X in hive.totalXenos)
			to_chat(X, SPAN_XENOANNOUNCE("[src.name] has declared: [NM.mark_meaning.desc] in [sanitize_area(current_area_name)]! (<a href='byond://?src=\ref[X];overwatch=1;target=\ref[NM]'>Watch</a>) (<a href='byond://?src=\ref[X];track=1;target=\ref[NM]'>Track</a>)"))
			//this is killing the tgui chat and I don't know why
	return TRUE
