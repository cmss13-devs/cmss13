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

	if(!isobj(crosser) && !isliving(crosser))
		return

	if(!istype(old_loc, /turf/open/space))
		var/turf/projected = get_ranged_target_turf(crosser, dir, 10)

		INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 50, SPEED_FAST, null, TRUE)

		addtimer(CALLBACK(src, PROC_REF(handle_crosser), crosser), 0.5 SECONDS)

/turf/open/space/transit/proc/handle_crosser(atom/movable/crosser)
	if(QDELETED(crosser))
		return
	if(crosser.can_paradrop()) //let's not delete people who arent meant to be deleted... This shouldn't happen normally, but if it does, congratulations, you gamed the system
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

	// you just jumped out of a dropship heading towards the LZ, have fun living on the way down!
	var/list/ground_z_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(!length(ground_z_levels))
		return ..()

	if(dropship.paradrop_signal) //if dropship in paradrop mode, drop them near the signal. Whether they have a parachute or not
		var/list/valid_turfs = list()
		var/turf/location = get_turf(dropship.paradrop_signal.signal_loc)
		for(var/turf/turf as anything in RANGE_TURFS(crosser.get_paradrop_scatter(), location))
			var/area/turf_area = get_area(turf)
			if(istype(turf, /turf/open/space))
				continue
			if(!turf_area || CEILING_IS_PROTECTED(turf_area.ceiling, CEILING_PROTECTION_TIER_1))
				continue
			if(turf.density)
				continue
			var/found_dense = FALSE
			for(var/atom/turf_atom in turf)
				if(turf_atom.density && turf_atom.can_block_movement)
					found_dense = TRUE
					break
			if(found_dense)
				continue
			if(protected_by_pylon(TURF_PROTECTION_MORTAR, turf))
				continue
			valid_turfs += turf
		var/turf/deploy_turf
		if(length(valid_turfs)) //if we found a fitting place near the landing zone...
			deploy_turf = pick(valid_turfs)
		else //if we somehow did not. Drop them right on the signal then, there is nothing we can do
			deploy_turf = location
		if(crosser.can_paradrop())
			INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, handle_paradrop), deploy_turf, dropship.name)
			return
		INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, handle_airdrop), deploy_turf, dropship.name)
		return

	//find a random spot to drop them
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
		if(crosser.can_paradrop())
			INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, handle_paradrop), possible_turf, dropship.name)
			return
		INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, handle_airdrop), possible_turf, dropship.name)
		return

	//we didn't find a turf to drop them... This shouldn't happen usually
	if(crosser.can_paradrop()) //don't delete them if they were supposed to paradrop
		to_chat(crosser, SPAN_BOLDWARNING("Your harness got stuck and you got thrown back in the dropship."))
		var/turf/projected = get_ranged_target_turf(crosser, turn(dir, 180), 15)
		INVOKE_ASYNC(crosser, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 50, SPEED_FAST, null, TRUE)
		return
	return ..() // they couldn't be dropped, just delete them

/atom/movable/proc/can_paradrop()
	return FALSE

/atom/movable/proc/get_paradrop_scatter()
	return 7

/mob/living/carbon/human/can_paradrop()
	if(istype(back, /obj/item/parachute))
		return TRUE
	return ..()

/obj/structure/closet/crate/can_paradrop() //for now all crates can be paradropped
	return TRUE

/obj/structure/closet/crate/get_paradrop_scatter() //crates land closer to the signal
	return 4

/obj/structure/largecrate/can_paradrop()
	return TRUE

/obj/structure/largecrate/get_paradrop_scatter()
	return 4

/atom/movable/proc/handle_paradrop(turf/target, dropship_name)
	clear_active_explosives()
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	ADD_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	ADD_TRAIT(src, TRAIT_NO_STRAY, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	RegisterSignal(src, COMSIG_MOVABLE_FORCEMOVE_PRE_CROSSED, PROC_REF(cancel_cross))
	RegisterSignal(src, list(
		COMSIG_LIVING_FLAMER_FLAMED,
		COMSIG_LIVING_PREIGNITION
	), PROC_REF(cancel_fire))
	var/image/cables = image('icons/obj/structures/droppod_32x64.dmi', src, "chute_cables_static")
	overlays += cables
	var/image/chute = image('icons/obj/structures/droppod_64x64.dmi', src, "chute_static")

	chute.pixel_x -= 16
	chute.pixel_y += 16

	overlays += chute
	pixel_z = 360
	forceMove(target)
	playsound(src, 'sound/items/fulton.ogg', 30, 1)
	animate(src, time = 3.5 SECONDS, pixel_z = 0, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/turf, ceiling_debris)), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(clear_parachute), cables, chute), 3.5 SECONDS)

/mob/living/carbon/handle_paradrop(turf/target, dropship_name)
	..()
	if(client)
		playsound_client(client, 'sound/items/fulton.ogg', src, 50, 1) //for some reason you don't hear the sound while dropping, maybe because of force move?

/atom/movable/proc/clear_parachute(image/cables, image/chute)
	if(QDELETED(src))
		return
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	REMOVE_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	REMOVE_TRAIT(src, TRAIT_NO_STRAY, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	UnregisterSignal(src, list(
		COMSIG_MOVABLE_FORCEMOVE_PRE_CROSSED,
		COMSIG_LIVING_FLAMER_FLAMED,
		COMSIG_LIVING_PREIGNITION
	))
	overlays -= cables
	overlays -= chute
	for(var/atom/movable/atom in loc)
		if(atom == src)
			continue
		atom.Cross(src)

/atom/movable/proc/clear_active_explosives()
	for(var/obj/item/explosive/explosive in contents)
		if(!explosive.active)
			continue
		explosive.deconstruct(FALSE)

/atom/movable/proc/handle_airdrop(turf/target, dropship_name)
	clear_active_explosives()
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DROPSHIP_INTERACTION)
	pixel_z = 360
	forceMove(target)
	animate(src, time = 6, pixel_z = 0, flags = ANIMATION_PARALLEL)
	INVOKE_ASYNC(target, TYPE_PROC_REF(/turf, ceiling_debris))
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DROPSHIP_INTERACTION)

/obj/handle_airdrop(turf/target, dropship_name)
	..()
	if(!explo_proof && prob(30)) // throwing objects from the air is not always a good idea
		deconstruct(FALSE)

/obj/structure/closet/handle_airdrop(turf/target, dropship_name) // good idea but no
	if(!opened)
		for(var/atom/movable/content in src)
			INVOKE_ASYNC(content, TYPE_PROC_REF(/atom/movable, handle_airdrop), target, dropship_name)
		open()
	. = ..()

/obj/item/handle_airdrop(turf/target, dropship_name)
	..()
	if(QDELETED(src))
		return
	if(!explo_proof && w_class < SIZE_MEDIUM) //tiny and small items will be lost, good riddance
		deconstruct(FALSE)
		return
	explosion_throw(200) // give it a bit of a kick

/obj/item/explosive/handle_airdrop(turf/target, dropship_name)
	if(active)
		deconstruct(FALSE)
		return
	..()

/mob/living/handle_airdrop(turf/target, dropship_name)
	..()
	playsound(target, "punch", rand(20, 70), TRUE)
	playsound(target, "punch", rand(20, 70), TRUE)
	playsound(target, "bone_break", rand(20, 70), TRUE)
	playsound(target, "bone_break", rand(20, 70), TRUE)

	KnockDown(10)
	Stun(3)
	// take a little bit more damage otherwise
	take_overall_damage(400, used_weapon = "falling", limb_damage_chance = 100)
	visible_message(SPAN_WARNING("[src] falls out of the sky."), SPAN_HIGHDANGER("As you fall out of the [dropship_name], you plummet towards the ground."))

/mob/living/carbon/human/handle_airdrop(turf/target, dropship_name)
	..()
	last_damage_data = create_cause_data("falling from [dropship_name]", src)
	// I'd say falling from space is pretty much like getting hit by an explosion
	take_overall_armored_damage(300, ARMOR_BOMB, limb_damage_chance = 100)
	// but just in case, you will still take a ton of damage.
	take_overall_damage(200, used_weapon = "falling", limb_damage_chance = 100)
	if(stat < DEAD)
		death(last_damage_data)
	status_flags |= PERMANENTLY_DEAD

/atom/movable/proc/cancel_cross()
	SIGNAL_HANDLER
	return COMPONENT_IGNORE_CROSS

/atom/movable/proc/cancel_fire()
	SIGNAL_HANDLER
	return COMPONENT_NO_BURN

/turf/open/space/transit/dropship/alamo
	shuttle_tag = DROPSHIP_ALAMO
	dir = SOUTH

/turf/open/space/transit/dropship/normandy
	shuttle_tag = DROPSHIP_NORMANDY
	dir = SOUTH

/turf/open/space/transit/dropship/saipan
	shuttle_tag = DROPSHIP_SAIPAN
	dir = SOUTH

/turf/open/space/transit/dropship/morana
	shuttle_tag = DROPSHIP_MORANA
	dir = SOUTH

/turf/open/space/transit/dropship/devana
	shuttle_tag = DROPSHIP_DEVANA
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
