
/mob/living/carbon/xenomorph/proc/build_resin(atom/target, node_fill_override, thick = FALSE, message = TRUE, use_plasma = TRUE, add_build_mod = 1)
	if(!selected_resin && !node_fill_override)
		return SECRETE_RESIN_FAIL

	var/obj/effect/alien/resin/building_node/node_in_turf = locate() in get_turf(target)
	var/mob/living/carbon/xenomorph/queen/queen_source = src
	// Ovi queens need special handling for this, as their remote build would mean they have no way of dispeling marks, and their node queue handles building on marks anyways
	if(node_in_turf && isqueen(src) && queen_source.ovipositor && isnull(node_fill_override))
		return handle_building_node(target, selected_resin)

	// Set the override resin to the node's type
	if(node_in_turf && node_in_turf.planter == src)
		node_fill_override = node_in_turf.resin_type

	var/datum/resin_construction/resin_construct
	if(node_fill_override)
		resin_construct = node_fill_override
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
	if(use_plasma && !check_plasma(total_resin_cost))
		return SECRETE_RESIN_FAIL
	if(SSinterior.in_interior(src))
		to_chat(src, SPAN_XENOWARNING("It's too tight in here to build."))
		return SECRETE_RESIN_FAIL

	if(resin_construct.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		var/current_amount = length(built_structures[resin_construct.build_path])
		if(current_amount >= resin_construct.max_per_xeno)
			to_chat(src, SPAN_XENOWARNING("We've already built the maximum possible structures we can!"))
			return SECRETE_RESIN_FAIL

	var/turf/current_turf = get_turf(target)
	var/obj/effect/alien/weeds/alien_weeds = current_turf.weeds
	if(!alien_weeds || alien_weeds.secreting)
		return SECRETE_RESIN_FAIL

	if(alien_weeds.hivenumber != hivenumber)
		to_chat(src, SPAN_DANGER("These aren't our weeds!"))
		return

	if(extra_build_dist != IGNORE_BUILD_DISTANCE && get_dist(src, target) > src.caste.max_build_dist + extra_build_dist)
		return handle_building_node(target, resin_construct)

	// Designate a mark if the door can't be built there right now.
	switch(resin_construct.can_build_here(current_turf, src))
		if(UNBUILDABLE_TURF)
			return SECRETE_RESIN_FAIL
		if(UNSUPPORTED_TURF)
			// Only clear the mark if this is not node autobuild.
			if(node_fill_override)
				return SECRETE_RESIN_FAIL
			else
				return handle_building_node(target, resin_construct)


	// Queue it up!
	if(action_busy && !can_stack_builds)
		if(node_fill_override) // We know that it came from node filling, so we don't use the proc as it'd just remove the mark.
			return SECRETE_RESIN_FAIL
		else
			return handle_building_node(target, resin_construct)

	else if(thick) //hivelords can thicken existing resin structures.
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


	SEND_SIGNAL(src, COMSIG_XENO_FINISH_BUILDING)

	return SECRETE_RESIN_SUCCESS

/mob/living/carbon/xenomorph/proc/handle_building_node(atom/target, datum/resin_construction/resin_construct)

	var/obj/effect/alien/resin/building_node/found_node = locate() in get_turf(target)
	if(found_node)
		to_chat(src, SPAN_WARNING("We clear the psychic mark from that location."))
		qdel(found_node)
		return SECRETE_RESIN_FAIL

	new /obj/effect/alien/resin/building_node(get_turf(target), src, resin_construct)
	return SECRETE_RESIN_NODE

/obj/effect/alien/resin/building_node
	name = "building node"
	icon_state = "nest"
	/// Xeno that planted the node.
	var/mob/living/carbon/xenomorph/planter
	/// Type of resin to build.
	var/datum/resin_construction/resin_type
	/// List of invisible effects that will cause the planter to start filling it up when standing on.
	var/list/obj/effect/fill_spot/fill_spots
	/// We use a special effect to only show the mark to the xeno that made it.
	var/obj/effect/client_image_holder/resin_building_node/node_image

/obj/effect/alien/resin/building_node/Initialize(mapload, planter, datum/resin_construction/resin_type)
	. = ..()
	var/area/area = get_area(src)
	if(area)
		if(area.linked_lz)
			AddComponent(/datum/component/resin_cleanup)
		setup_fill_spots()
	src.planter = planter
	src.resin_type = resin_type


	var/ovi_node = FALSE
	if(isqueen(planter))
		var/mob/living/carbon/xenomorph/queen/queen_planter = planter
		if(queen_planter.ovipositor)
			ovi_node = TRUE
			LAZYADD(queen_planter.nodes_in_queue, src)

	// Create the client mark image
	node_image = new /obj/effect/client_image_holder/resin_building_node(get_turf(src), list(planter), resin_type, src, ovi_node)


/obj/effect/alien/resin/building_node/Destroy()
	// Make sure it's out of the queue list!
	if(isqueen(planter))
		var/mob/living/carbon/xenomorph/queen/planter_queen = planter
		LAZYREMOVE(planter_queen.nodes_in_queue, src)
	QDEL_NULL_LIST(fill_spots)
	QDEL_NULL(node_image)
	planter = null
	return ..()

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
	var/datum/caste_datum/wanderer_caste = wanderer.caste
	var/datum/resin_construction/type_to_build = null
	// We look for a type of the intended build, allowing hivelords to build on nodes designated by drones,
	// and also queen whose resin is different for some reason.
	for(var/i in wanderer_caste.resin_build_order)
		if(i == linked_node.resin_type)
			type_to_build = i
		// We prefer an exact match if possible, otherwise any type will do
		if(ispath(i, linked_node.resin_type) && (type_to_build == null))
			type_to_build = i
	// Doesn't have an appropiate type
	if(!type_to_build)
		return
	if(wanderer.build_resin(linked_node, type_to_build, message = TRUE, use_plasma = TRUE) == SECRETE_RESIN_SUCCESS)
		var/obj/effect/fill_spot/extra_node = locate() in get_turf(wanderer)
		if(extra_node)
			INVOKE_ASYNC(extra_node, PROC_REF(try_fill_node), wanderer) // async so the spent node gets deleted now
		QDEL_NULL(linked_node)

/obj/effect/client_image_holder/resin_building_node
	desc = "A psychic node to mark future building spots."
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
