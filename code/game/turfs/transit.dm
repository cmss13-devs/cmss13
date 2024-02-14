/turf/open/space/transit
	name = "\proper hyperspace"
	icon_state = "black"
	dir = SOUTH
	baseturfs = /turf/open/space/transit
	var/auto_space_icon = TRUE

/turf/open/space/transit/Entered(atom/movable/crosser, atom/old_loc)
	. = ..()

	if(isobserver(crosser) || crosser.anchored)
		return

	if(!isitem(crosser) && !isliving(crosser))
		return

	if(!istype(old_loc, /turf/open/space))
		var/turf/projected = get_ranged_target_turf(crosser.loc, dir, 10)

		INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 50, SPEED_FAST, null, TRUE)

		addtimer(CALLBACK(src, PROC_REF(handle_crosser), crosser), 0.5 SECONDS)

/turf/open/space/transit/proc/handle_crosser(atom/movable/crosser)
	if(QDELETED(crosser))
		return
	qdel(crosser)

/turf/open/space/transit/dropship
	var/shuttle_tag

/turf/open/space/transit/dropship/handle_crosser(atom/movable/crosser)
	if(QDELETED(crosser))
		return
	if(!shuttle_tag)
		return ..()

	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!istype(dropship) || dropship.mode != SHUTTLE_CALL)
		return ..()

	if(dropship.destination.id != DROPSHIP_LZ1 && dropship.destination.id != DROPSHIP_LZ2)
		return ..() // we're not heading towards the LZs

	// you just jumped out of a dropship heading towards the LZ, have fun living on the way down!
	var/list/ground_z_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(!length(ground_z_levels))
		return ..()

	var/list/area/potential_areas = shuffle(SSmapping.areas_in_z["[ground_z_levels[1]]"])

	for(var/area/maybe_this_area in potential_areas)
		if(CEILING_IS_PROTECTED(maybe_this_area.ceiling, CEILING_PROTECTION_TIER_1)) // prevents out of bounds too
			continue
		if(istype(maybe_this_area, /area/space)) // make sure its not space, just in case
			continue

		var/turf/open/possible_turf = null
		var/list/area_turfs = get_area_turfs(maybe_this_area)
		for(var/i in 1 to 10)
			possible_turf = pick_n_take(area_turfs)
			// we're looking for an open, non-dense, and non-space turf.
			if(!istype(possible_turf) || is_blocked_turf(possible_turf) || istype(possible_turf, /turf/open/space))
				continue

		if(!istype(possible_turf) || is_blocked_turf(possible_turf) || istype(possible_turf, /turf/open/space))
			continue // couldnt find one in 10 loops, check another area

		// we found a good turf, lets drop em
		INVOKE_ASYNC(src, PROC_REF(handle_drop), crosser, possible_turf, dropship.name)
		return

	return ..() // they couldn't be dropped, just delete them

/turf/open/space/transit/dropship/proc/handle_drop(atom/movable/crosser, turf/target, dropship_name)
	if(QDELETED(crosser))
		return
	ADD_TRAIT(crosser, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DROPSHIP_INTERACTION)

	crosser.pixel_z = 360
	crosser.forceMove(target)
	crosser.visible_message(SPAN_WARNING("[crosser] falls out of the sky."), SPAN_HIGHDANGER("As you fall out of the [dropship_name], you plummet towards the ground."))
	animate(crosser, time = 6, pixel_z = 0, flags = ANIMATION_PARALLEL)

	REMOVE_TRAIT(crosser, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	if(isitem(crosser))
		var/obj/item/item = crosser
		item.explosion_throw(200) // give it a bit of a kick
		return

	if(!isliving(crosser))
		return // don't know how you got here, but you shouldnt be here.
	var/mob/living/fallen_mob = crosser

	playsound(target, "punch", rand(20, 70), TRUE)
	playsound(target, "punch", rand(20, 70), TRUE)
	playsound(target, "bone_break", rand(20, 70), TRUE)
	playsound(target, "bone_break", rand(20, 70), TRUE)

	fallen_mob.KnockDown(10) // 10 seconds
	fallen_mob.Stun(3) // 3 seconds


	if(ishuman(fallen_mob))
		var/mob/living/carbon/human/human = fallen_mob
		human.last_damage_data = create_cause_data("falling from [dropship_name]", human)
		// I'd say falling from space is pretty much like getting hit by an explosion
		human.take_overall_armored_damage(300, ARMOR_BOMB, limb_damage_chance = 100)
		// but just in case, you will still take a ton of damage.
		human.take_overall_damage(200, used_weapon = "falling", limb_damage_chance = 100)
		if(human.stat != DEAD)
			human.death(human.last_damage_data)
		fallen_mob.status_flags |= PERMANENTLY_DEAD
		return
	// take a little bit more damage otherwise
	fallen_mob.take_overall_damage(400, used_weapon = "falling", limb_damage_chance = 100)

/turf/open/space/transit/dropship/alamo
	shuttle_tag = DROPSHIP_ALAMO
	dir = SOUTH

/turf/open/space/transit/dropship/normandy
	shuttle_tag = DROPSHIP_NORMANDY
	dir = SOUTH

/turf/open/space/transit/south
	dir = SOUTH

/turf/open/space/transit/north
	dir = NORTH

/turf/open/space/transit/horizontal
	dir = WEST

/turf/open/space/transit/west
	dir = WEST

/turf/open/space/transit/east
	dir = EAST


/turf/open/space/transit/Initialize(mapload)
	. = ..()
	update_icon()

/turf/open/space/transit/update_icon()
	. = ..()
	if(auto_space_icon)
		icon_state = "speedspace_ns_[get_transit_state(src)]"
		transform = turn(matrix(), get_transit_angle(src))

/proc/get_transit_state(turf/T)
	var/p = 9
	. = 1
	switch(T.dir)
		if(NORTH)
			. = ((-p*T.x+T.y) % 15) + 1
			if(. < 1)
				. += 15
		if(EAST)
			. = ((T.x+p*T.y) % 15) + 1
		if(WEST)
			. = ((T.x-p*T.y) % 15) + 1
			if(. < 1)
				. += 15
		else
			. = ((p*T.x+T.y) % 15) + 1

/proc/get_transit_angle(turf/T)
	. = 0
	switch(T.dir)
		if(NORTH)
			. = 180
		if(EAST)
			. = 90
		if(WEST)
			. = -90


// =======================
// Legacy static turf type definitions below. Just use the above instead
// =======================

/turf/open/space/transit/north // moving to the north
/turf/open/space/transit/north/shuttlespace_ns1
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_1"

/turf/open/space/transit/north/shuttlespace_ns2
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_2"

/turf/open/space/transit/north/shuttlespace_ns3
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_3"

/turf/open/space/transit/north/shuttlespace_ns4
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_4"

/turf/open/space/transit/north/shuttlespace_ns5
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_5"

/turf/open/space/transit/north/shuttlespace_ns6
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_6"

/turf/open/space/transit/north/shuttlespace_ns7
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_7"

/turf/open/space/transit/north/shuttlespace_ns8
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_8"

/turf/open/space/transit/north/shuttlespace_ns9
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_9"

/turf/open/space/transit/north/shuttlespace_ns10
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_10"

/turf/open/space/transit/north/shuttlespace_ns11
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_11"

/turf/open/space/transit/north/shuttlespace_ns12
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_12"

/turf/open/space/transit/north/shuttlespace_ns13
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_13"

/turf/open/space/transit/north/shuttlespace_ns14
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_14"

/turf/open/space/transit/north/shuttlespace_ns15
	auto_space_icon = FALSE
	icon_state = "speedspace_ns_15"

/turf/open/space/transit/east/shuttlespace_ew1
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_1"

/turf/open/space/transit/east/shuttlespace_ew2
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_2"

/turf/open/space/transit/east/shuttlespace_ew3
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_3"

/turf/open/space/transit/east/shuttlespace_ew4
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_4"

/turf/open/space/transit/east/shuttlespace_ew5
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_5"

/turf/open/space/transit/east/shuttlespace_ew6
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_6"

/turf/open/space/transit/east/shuttlespace_ew7
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_7"

/turf/open/space/transit/east/shuttlespace_ew8
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_8"

/turf/open/space/transit/east/shuttlespace_ew9
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_9"

/turf/open/space/transit/east/shuttlespace_ew10
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_10"

/turf/open/space/transit/east/shuttlespace_ew11
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_11"

/turf/open/space/transit/east/shuttlespace_ew12
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_12"

/turf/open/space/transit/east/shuttlespace_ew13
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_13"

/turf/open/space/transit/east/shuttlespace_ew14
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_14"

/turf/open/space/transit/east/shuttlespace_ew15
	auto_space_icon = FALSE
	icon_state = "speedspace_ew_15"
