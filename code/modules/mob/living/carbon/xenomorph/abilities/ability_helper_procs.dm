//Corrosive acid is consolidated -- it checks for specific castes for strength now, but works identically to each other.
//The acid items are stored in XenoProcs.
/mob/living/carbon/xenomorph/proc/corrosive_acid(atom/acided_thing, acid_type, plasma_cost)
	if(!check_state())
		return
	if(!acided_thing.Adjacent(src))
		if(istype(acided_thing,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/acided_c4 = acided_thing
			if(acided_c4.plant_target && !acided_c4.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("We can't reach [acided_thing]."))
				return
		else
			to_chat(src, SPAN_WARNING("[acided_thing] is too far away."))
			return

	if(!isturf(loc) || HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_WARNING("We can't melt [acided_thing] from here!"))
		return

	face_atom(acided_thing)

	var/wait_time = 10

	var/turf/turf = get_turf(acided_thing)

	for(var/obj/effect/xenomorph/acid/other_acid in turf)
		if(acid_type == other_acid.type && other_acid.acid_t == acided_thing)
			to_chat(src, SPAN_WARNING("[other_acid] is already drenched in acid."))
			return

	var/obj/acided_object
	//OBJ CHECK
	if(isobj(acided_thing))
		acided_object = acided_thing

		wait_time = acided_object.get_applying_acid_time()
		if(wait_time == -1)
			to_chat(src, SPAN_WARNING("We cannot dissolve \the [acided_object]."))
			return

	//TURF CHECK
	else if(isturf(acided_thing))

		if(istype(acided_thing, /turf/closed/wall))
			var/turf/closed/wall/wall_target = acided_thing
			if(wall_target.acided_hole)
				to_chat(src, SPAN_WARNING("[acided_thing] is already weakened."))
				return

		var/dissolvability = turf.can_be_dissolved()
		switch(dissolvability)
			if(0)
				to_chat(src, SPAN_WARNING("We cannot dissolve [turf]."))
				return
			if(1)
				wait_time = 50
			if(2)
				if(acid_type != /obj/effect/xenomorph/acid/strong)
					to_chat(src, SPAN_WARNING("This [turf.name] is too tough to be melted by our weak acid."))
					return
				wait_time = 100
			else
				return
		if(istype(turf, /turf/closed/wall))
			var/turf/closed/wall/acided_wall = turf

			// Direction from wall to the mob generating acid on the wall turf
			var/ambiguous_dir_msg = SPAN_XENOWARNING("We are unsure which direction to melt through [acided_wall]. Face it directly and try again.")
			var/dir_to = get_dir(src, acided_wall)
			switch(dir_to)
				if(WEST, EAST, NORTH, SOUTH)
					acided_wall.acided_hole_dir = dir_to
				if(NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST)
					var/turf/closed/wall/wall_north_turf = get_step(acided_wall, NORTH)
					var/turf/closed/wall/wall_south_turf = get_step(acided_wall, SOUTH)
					var/turf/closed/wall/wall_east_turf = get_step(acided_wall, EAST)
					var/turf/closed/wall/wall_west_turf = get_step(acided_wall, WEST)
					// When wall is passable from all cardinal directions...
					if(!istype(wall_north_turf) && !istype(wall_south_turf) && !istype(wall_east_turf) && !istype(wall_west_turf))
						// ...don't make an acid hole
						to_chat(src, ambiguous_dir_msg)
						return
					else if(!istype(wall_north_turf) && !istype(wall_south_turf))
						acided_wall.acided_hole_dir = dir_to & (NORTH|SOUTH)
					else if(!istype(wall_east_turf) && !istype(wall_west_turf))
						acided_wall.acided_hole_dir = dir_to & (EAST|WEST)
					else
						// ...don't make an acid hole for corners bordering other walls
						to_chat(src, ambiguous_dir_msg)
						return

			var/acided_hole_type = acided_wall.acided_hole_dir & (EAST|WEST) ? "a hole horizontally" : "a hole vertically"
			to_chat(src, SPAN_XENOWARNING("We begin generating enough acid to melt [acided_hole_type] through [acided_wall]."))
		else
			to_chat(src, SPAN_XENOWARNING("We begin generating enough acid to melt through [turf]."))
	else
		to_chat(src, SPAN_WARNING("You cannot dissolve [acided_thing]."))
		return

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	// AGAIN BECAUSE SOMETHING COULD'VE ACIDED THE PLACE
	for(var/obj/effect/xenomorph/acid/other_acid in turf)
		if(acid_type == other_acid.type && other_acid.acid_t == acided_thing)
			to_chat(src, SPAN_WARNING("[other_acid] is already drenched in acid."))
			return

	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED)) //Checked again to account for people trying to place acid while channeling the burrow ability
		to_chat(src, SPAN_WARNING("We can't melt [acided_thing] from here!"))
		return

	if(!check_state())
		return

	if(!acided_thing || QDELETED(acided_thing)) //Some logic.
		return

	if(!check_plasma(plasma_cost))
		return

	if(!acided_thing.Adjacent(src) || (acided_object && !isturf(acided_object.loc)))//not adjacent or inside something
		if(istype(acided_thing,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/acided_c4 = acided_thing
			if(acided_c4.plant_target && !acided_c4.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("We can't reach [acided_thing]."))
				return
		else
			to_chat(src, SPAN_WARNING("[acided_thing] is too far away."))
			return

	use_plasma(plasma_cost)

	var/obj/effect/xenomorph/acid/new_acid = new acid_type(turf, acided_thing)

	if(istype(acided_thing, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/acided_vehicle = acided_thing
		acided_vehicle.take_damage_type(40 / new_acid.acid_delay, "acid", src)
		visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff at \the [acided_thing]. It sizzles under the bubbling mess of acid!"),
			SPAN_XENOWARNING("We vomit globs of vile stuff at [acided_thing]. It sizzles under the bubbling mess of acid!"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(new_acid, 20)
		return

	if(isturf(acided_thing))
		new_acid.icon_state += "_wall"

	if(istype(acided_thing, /obj/structure) || istype(acided_thing, /obj/structure/machinery)) //Always appears above machinery
		new_acid.layer = acided_thing.layer + 0.1
	else //If not, appear on the floor or on an item
		new_acid.layer = LOWER_ITEM_LAYER //below any item, above BELOW_OBJ_LAYER (smartfridge)

	new_acid.add_hiddenprint(src)
	new_acid.name += " ([acided_thing])"

	if(!isturf(acided_thing))
		msg_admin_attack("[src.name] ([src.ckey]) spat acid on [acided_thing] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
		attack_log += text("\[[time_stamp()]\] <font color='green'>Spat acid on [acided_thing]</font>")
	visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff all over [acided_thing]. It begins to sizzle and melt under the bubbling mess of acid!"),
	SPAN_XENOWARNING("We vomit globs of vile stuff all over [acided_thing]. It begins to sizzle and melt under the bubbling mess of acid!"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)

/proc/unroot_human(mob/living/carbon/H, trait_source)
	if (!isxeno_human(H))
		return

	REMOVE_TRAIT(H, TRAIT_IMMOBILIZED, trait_source)

	if(ishuman(H))
		var/mob/living/carbon/human/turf = H
		turf.update_xeno_hostile_hud()
	to_chat(H, SPAN_XENOHIGHDANGER("We can move again!"))

/mob/living/carbon/xenomorph/proc/zoom_in()
	if(!HAS_TRAIT(src, TRAIT_ABILITY_SIGHT_IGNORE_REST) && (stat || resting))
		if(is_zoomed)
			is_zoomed = 0
			zoom_out()
			return
		return
	if(is_zoomed)
		return
	if(!client)
		return
	QDEL_NULL(observed_atom)
	is_zoomed = 1
	client.change_view(viewsize)
	var/viewoffset = 32 * tileoffset
	switch(dir)
		if(NORTH)
			client.set_pixel_x(0)
			client.set_pixel_y(viewoffset)
		if(SOUTH)
			client.set_pixel_x(0)
			client.set_pixel_y(-viewoffset)
		if(EAST)
			client.set_pixel_x(viewoffset)
			client.set_pixel_y(0)
		if(WEST)
			client.set_pixel_x(-viewoffset)
			client.set_pixel_y(0)

	for (var/datum/action/xeno_action/onclick/toggle_long_range/action in actions)
		action.on_zoom_in()
		return

/mob/living/carbon/xenomorph/proc/zoom_out()
	if(!client)
		return
	client.change_view(GLOB.world_view_size)
	client.set_pixel_x(0)
	client.set_pixel_y(0)
	is_zoomed = 0
	// Since theres several ways we can get here, we need to update the ability button state and handle action's specific effects
	for (var/datum/action/xeno_action/onclick/toggle_long_range/action in actions)
		action.on_zoom_out()
		return

/mob/living/carbon/xenomorph/proc/do_acid_spray_cone(turf/turf, spray_type = /obj/effect/xenomorph/spray, range = 3)
	set waitfor = FALSE

	var/facing = get_cardinal_dir(src, turf)
	setDir(facing)

	turf = loc
	for(var/i in 0 to range - 1)
		var/turf/next_turf = get_step(turf, facing)
		var/atom/movable/temp = new/obj/effect/xenomorph/spray()
		var/atom/movable/AM = LinkBlocked(temp, turf, next_turf)
		qdel(temp)
		if(AM)
			AM.acid_spray_act(src)
			return
		turf = next_turf
		var/obj/effect/xenomorph/spray/S = new spray_type(turf, create_cause_data(initial( caste_type), src), hivenumber)
		do_acid_spray_cone_normal(turf, i, facing, S, spray_type)
		sleep(2)

// Normal refers to the mathematical normal
/mob/living/carbon/xenomorph/proc/do_acid_spray_cone_normal(turf/turf, distance, facing, obj/effect/xenomorph/spray/source_spray, spray_type = /obj/effect/xenomorph/spray)
	if(!distance)
		return

	var/obj/effect/xenomorph/spray/left_S = source_spray
	var/obj/effect/xenomorph/spray/right_S = source_spray

	var/normal_dir = turn(facing, 90)
	var/inverse_normal_dir = turn(facing, -90)

	var/turf/normal_turf = turf
	var/turf/inverse_normal_turf = turf

	var/normal_density_flag = FALSE
	var/inverse_normal_density_flag = FALSE

	for(var/i in 1 to distance)
		if(normal_density_flag && inverse_normal_density_flag)
			return

		if(!normal_density_flag)
			var/next_normal_turf = get_step(normal_turf, normal_dir)
			var/atom/A = LinkBlocked(left_S, normal_turf, next_normal_turf)

			if(A)
				A.acid_spray_act()
				normal_density_flag = TRUE
			else
				normal_turf = next_normal_turf
				left_S = new spray_type(normal_turf, create_cause_data(initial(caste_type), src), hivenumber)


		if(!inverse_normal_density_flag)
			var/next_inverse_normal_turf = get_step(inverse_normal_turf, inverse_normal_dir)
			var/atom/A = LinkBlocked(right_S, inverse_normal_turf, next_inverse_normal_turf)

			if(A)
				A.acid_spray_act()
				inverse_normal_density_flag = TRUE
			else
				inverse_normal_turf = next_inverse_normal_turf
				right_S = new spray_type(inverse_normal_turf, create_cause_data(initial(caste_type), src), hivenumber)


/mob/living/carbon/xenomorph/proc/do_acid_spray_line(list/turflist, spray_path = /obj/effect/xenomorph/spray, distance_max = 5)
	if(isnull(turflist))
		return
	var/turf/prev_turf = loc

	var/distance = 0
	for(var/turf/turf in turflist)
		distance++

		if(!prev_turf && length(turflist) > 1)
			prev_turf = get_turf(src)
			continue //So we don't burn the tile we be standin on

		if(turf.density || istype(turf, /turf/open/space))
			break
		if(distance > distance_max)
			break
		var/atom/movable/temp = new spray_path()
		var/atom/movable/blocker = LinkBlocked(temp, prev_turf, turf)
		qdel(temp)
		if(blocker)
			blocker.acid_spray_act(src)
			break

		prev_turf = turf
		new spray_path(turf, create_cause_data(initial(caste_type), src), hivenumber)
		sleep(2)


/mob/living/carbon/xenomorph/proc/xeno_transfer_plasma(atom/A, amount = 50, transfer_delay = 20, max_range = 2)
	if(!istype(A, /mob/living/carbon/xenomorph))
		return
	var/mob/living/carbon/xenomorph/target = A

	if(!check_can_transfer_plasma(target, max_range))
		return

	to_chat(src, SPAN_NOTICE("We start focusing our plasma towards [target]."))
	to_chat(target, SPAN_NOTICE("We feel that [src] starts transferring some of their plasma to us."))
	face_atom(target)
	target.flick_heal_overlay(transfer_delay, COLOR_CYAN)

	if(!do_after(src, transfer_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return

	if(!check_can_transfer_plasma(target, max_range))
		return

	if(plasma_stored < amount)
		amount = plasma_stored //Just use all of it
	use_plasma(amount)
	target.gain_plasma(amount)
	target.xeno_jitter(1 SECONDS)
	to_chat(target, SPAN_XENOWARNING("[src] has transferred [amount] plasma to us. We now have [target.plasma_stored]."))
	to_chat(src, SPAN_XENOWARNING("We have transferred [amount] plasma to [target]. We now have [plasma_stored]."))
	playsound(src, "alien_drool", 25)

/mob/living/carbon/xenomorph/proc/check_can_transfer_plasma(mob/living/carbon/xenomorph/target, max_range)
	if(!check_state())
		return FALSE

	if(target.stat == DEAD)
		to_chat(src, SPAN_WARNING("[target] is dead!"))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("We can't transfer plasma from here!"))
		return FALSE

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("We need to be closer to [target]."))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_ABILITY_OVIPOSITOR))
		to_chat(src, SPAN_WARNING("We can't transfer plasma to a queen mounted on her ovipositor."))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_ABILITY_NO_PLASMA_TRANSFER))
		to_chat(src, SPAN_WARNING("We can't transfer plasma to \the [target]."))
		return FALSE

	if(target.plasma_max == XENO_NO_PLASMA)
		to_chat(src, SPAN_WARNING("\The [target] doesn't use plasma."))
		return FALSE

	if(target == src)
		to_chat(src, SPAN_WARNING("We can't transfer plasma to ourself!"))
		return FALSE

	return TRUE
