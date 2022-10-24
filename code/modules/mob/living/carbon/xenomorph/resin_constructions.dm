GLOBAL_VAR_INIT(resin_lz_allowed, FALSE)

/datum/resin_construction
	var/name
	var/desc
	var/construction_name // The name used in messages (to replace old resin2text proc)
	var/cost
	var/build_time = 2 SECONDS
	var/pass_hivenumber = TRUE

	var/build_overlay_icon
	var/build_animation_effect

	var/range_between_constructions
	var/build_path
	var/build_path_thick
	var/max_per_xeno = RESIN_CONSTRUCTION_NO_MAX

	var/thick_hiveweed = FALSE // if this is set, the thick variants will only work on hiveweeds

/datum/resin_construction/proc/can_build_here(var/turf/T, var/mob/living/carbon/Xenomorph/X)
	var/mob/living/carbon/Xenomorph/blocker = locate() in T
	if(blocker && blocker != X && blocker.stat != DEAD)
		to_chat(X, SPAN_WARNING("Can't do that with [blocker] in the way!"))
		return FALSE

	if(!istype(T) || T.is_weedable() < FULLY_WEEDABLE)
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return FALSE

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	if(!(AR.resin_construction_allowed))	//disable resin walls not weed, in special circumstances EG. Stairs and Dropship turfs
		to_chat(X, SPAN_WARNING("You sense this is not a suitable area for expanding the hive."))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in T
	if(!alien_weeds)
		to_chat(X, SPAN_WARNING("You can only shape on weeds. Find some resin before you start building!"))
		return FALSE

	if(alien_weeds?.block_structures >= BLOCK_ALL_STRUCTURES)
		to_chat(X, SPAN_WARNING("\The [alien_weeds] block the construction of any structures!"))
		return FALSE

	var/obj/vehicle/V = locate() in T
	if(V)
		to_chat(X, SPAN_WARNING("You cannot build under \the [V]!"))
		return FALSE

	if(alien_weeds.linked_hive.hivenumber != X.hivenumber)
		to_chat(X, SPAN_WARNING("These weeds do not belong to your hive!"))
		return FALSE

	if(istype(T, /turf/closed/wall)) // Can't build in walls with no density
		to_chat(X, SPAN_WARNING("This area is too unstable to support a construction"))
		return FALSE

	if(!X.check_alien_construction(T))
		return FALSE

	if(range_between_constructions)
		for(var/i in urange(range_between_constructions, T))
			var/atom/A = i
			if(A.type == build_path)
				to_chat(X, SPAN_WARNING("This is too close to another similar structure!"))
				return FALSE

	return TRUE

/datum/resin_construction/proc/build(var/turf/T, var/hivenumber, var/builder)
	return

/datum/resin_construction/proc/check_thick_build(var/turf/build_turf, var/hivenumber, var/mob/living/carbon/Xenomorph/builder)
	var/can_build_thick = TRUE
	if(thick_hiveweed)
		var/obj/effect/alien/weeds/weeds = locate() in build_turf
		if(!weeds || weeds.hivenumber != hivenumber || weeds.weed_strength < WEED_LEVEL_HIVE)
			can_build_thick = FALSE

	if(build_path_thick && (can_build_thick || (SEND_SIGNAL(builder, COMSIG_XENO_THICK_RESIN_BYPASS) & COMPONENT_THICK_BYPASS)))
		return TRUE
	return FALSE

// Subtype encompassing all resin constructions that are of type /obj
/datum/resin_construction/resin_obj/build(var/turf/build_turf, var/hivenumber, var/mob/living/carbon/Xenomorph/builder)
	var/path = check_thick_build(build_turf, hivenumber, builder) ? build_path_thick : build_path
	if(pass_hivenumber)
		return new path(build_turf, hivenumber, builder)
	return new path(build_turf)

// Subtype encompassing all resin constructions that are of type /turf
/datum/resin_construction/resin_turf/build(var/turf/build_turf, var/hivenumber, var/mob/living/carbon/Xenomorph/builder)
	var/path = check_thick_build(build_turf, hivenumber, builder) ? build_path_thick : build_path

	build_turf.PlaceOnTop(path)

	var/turf/closed/wall/resin/resin_wall = build_turf
	if (istype(resin_wall) && pass_hivenumber)
		resin_wall.hivenumber = hivenumber
		resin_wall.set_resin_builder(builder)
		set_hive_data(resin_wall, hivenumber)

	return build_turf


// Resin Walls
/datum/resin_construction/resin_turf/wall
	name = "Resin Wall"
	desc = "A resin wall, able to block passage."
	construction_name = "resin wall"
	cost = XENO_RESIN_WALL_COST

	build_path = /turf/closed/wall/resin
	build_animation_effect = /obj/effect/resin_construct/weak

/datum/resin_construction/resin_turf/wall/thick
	name = "Thick Resin Wall"
	desc = "A thick resin wall, stronger than regular walls."
	construction_name = "thick resin wall"
	cost = XENO_RESIN_WALL_THICK_COST

	build_path = /turf/closed/wall/resin/thick
	build_animation_effect = /obj/effect/resin_construct/thick

/datum/resin_construction/resin_turf/wall/queen
	name = "Queen Resin Wall"
	desc = "A resin wall, able to block passage. Constructed type depends on weeds."
	construction_name = "queen resin wall"

	cost = XENO_RESIN_WALL_QUEEN_COST

	build_path = /turf/closed/wall/resin
	build_path_thick = /turf/closed/wall/resin/thick
	thick_hiveweed = TRUE
	build_animation_effect = /obj/effect/resin_construct/weak

/datum/resin_construction/resin_turf/wall/reflective
	name = "Reflective Resin Wall"
	desc = "A reflective resin wall, able to reflect any and all projectiles back to the shooter."
	construction_name = "reflective resin wall"
	cost = XENO_RESIN_WALL_REFLECT_COST
	max_per_xeno = 5

	build_path = /turf/closed/wall/resin/reflective

// Resin Membrane
/datum/resin_construction/resin_turf/membrane
	name = "Resin Membrane"
	desc = "Resin membrane that can be seen through."
	construction_name = "resin membrane"
	cost = XENO_RESIN_MEMBRANE_COST

	build_path = /turf/closed/wall/resin/membrane
	build_animation_effect = /obj/effect/resin_construct/transparent/weak

/datum/resin_construction/resin_turf/membrane/queen
	name = "Queen Resin Membrane"
	desc = "Resin membrane that can be seen through. Constructed type depends on weeds."
	construction_name = "queen resin membrane"
	cost = XENO_RESIN_MEMBRANE_QUEEN_COST

	build_path = /turf/closed/wall/resin/membrane
	build_path_thick = /turf/closed/wall/resin/membrane/thick
	thick_hiveweed = TRUE
	build_animation_effect = /obj/effect/resin_construct/transparent/weak

/datum/resin_construction/resin_turf/membrane/thick
	name = "Thick Resin Membrane"
	desc = "Strong resin membrane that can be seen through."
	construction_name = "thick resin membrane"
	cost = XENO_RESIN_MEMBRANE_THICK_COST

	build_path = /turf/closed/wall/resin/membrane/thick
	build_animation_effect = /obj/effect/resin_construct/transparent/thick

// Resin Doors
/datum/resin_construction/resin_obj/door
	name = "Resin Door"
	desc = "A resin door that only sisters may pass."
	construction_name = "resin door"
	cost = XENO_RESIN_DOOR_COST

	build_path = /obj/structure/mineral_door/resin
	build_animation_effect = /obj/effect/resin_construct/door

/datum/resin_construction/resin_obj/door/can_build_here(var/turf/T, var/mob/living/carbon/Xenomorph/X)
	if (!..())
		return FALSE

	var/wall_support = FALSE
	for(var/D in cardinal)
		var/turf/CT = get_step(T, D)
		if(CT)
			if(CT.density)
				wall_support = TRUE
				break
			else if(locate(/obj/structure/mineral_door/resin) in CT)
				wall_support = TRUE
				break

	if(!wall_support)
		to_chat(X, SPAN_WARNING("Resin doors need a wall or resin door next to them to stand up."))
		return FALSE

	return TRUE

/datum/resin_construction/resin_obj/door/queen
	name = "Queen Resin Door"
	desc = "A resin door that only sisters may pass. Constructed type depends on weeds."
	construction_name = "queen resin door"
	cost = XENO_RESIN_DOOR_QUEEN_COST

	build_path = /obj/structure/mineral_door/resin
	build_path_thick = /obj/structure/mineral_door/resin/thick
	thick_hiveweed = TRUE
	build_animation_effect = /obj/effect/resin_construct/door

/datum/resin_construction/resin_obj/door/thick
	name = "Thick Resin Door"
	desc = "A thick resin door, which is more durable, that only sisters may pass."
	construction_name = "thick resin door"
	cost = XENO_RESIN_DOOR_THICK_COST

	build_path = /obj/structure/mineral_door/resin/thick
	build_animation_effect = /obj/effect/resin_construct/door


// Resin Nests
/datum/resin_construction/resin_obj/nest
	name = "Resin Nest"
	desc = "A resin nest used to contain any infected hosts."
	construction_name = "resin nest"
	cost = XENO_RESIN_NEST_COST

	build_path = /obj/structure/bed/nest

/datum/resin_construction/resin_obj/nest/can_build_here(var/turf/T, var/mob/living/carbon/Xenomorph/X)
	if (!..())
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in T // No need to check if null, because if there are no weeds then parent call fails any way
	if(!(alien_weeds.weed_strength >= WEED_LEVEL_HIVE))
		to_chat(X, SPAN_WARNING("These weeds are not strong enough to hold the nest."))
		return FALSE

	return TRUE


// Sticky Resin
/datum/resin_construction/resin_obj/sticky_resin
	name = "Sticky Resin"
	desc = "Resin that slows down any tallhosts when they walk over it."
	construction_name = "sticky resin"
	cost = XENO_RESIN_STICKY_COST
	build_time = 1 SECONDS

	build_path = /obj/effect/alien/resin/sticky


// Fast Resin
/datum/resin_construction/resin_obj/fast_resin
	name = "Fast Resin"
	desc = "Resin that speeds up other sisters when they walk over it."
	construction_name = "fast resin"
	cost = XENO_RESIN_FAST_COST
	build_time = 1 SECONDS

	build_path = /obj/effect/alien/resin/sticky/fast

/datum/resin_construction/resin_obj/resin_spike
	name = "Resin Spike"
	desc = "Resin that harms any tallhosts when they walk over it."
	construction_name = "resin spike"
	cost = XENO_RESIN_SPIKE_COST
	max_per_xeno = 15

	build_path = /obj/effect/alien/resin/spike

/datum/resin_construction/resin_obj/acid_pillar
	name = "Acid Pillar"
	desc = "A tall, green pillar that is capable of firing at multiple targets at once. Fires weak acid."
	construction_name = "acid pillar"
	cost = XENO_RESIN_ACID_PILLAR_COST
	max_per_xeno = 1

	build_overlay_icon = /obj/effect/warning/alien/weak

	build_path = /obj/effect/alien/resin/acid_pillar
	build_time = 12 SECONDS

	range_between_constructions = 5

/datum/resin_construction/resin_obj/shield_dispenser
	name = "Shield Pillar"
	desc = "A tall, strange pillar that gives shield to the interactor. Has a hefty cooldown."
	construction_name = "shield pillar"
	cost = XENO_RESIN_SHIELD_PILLAR_COST
	max_per_xeno = 1

	build_path = /obj/effect/alien/resin/shield_pillar
	build_time = 12 SECONDS

/datum/resin_construction/resin_obj/shield_dispenser/New()
	. = ..()
	var/obj/effect/alien/resin/shield_pillar/SP = build_path
	range_between_constructions = initial(SP.range)*2

/datum/resin_construction/resin_obj/grenade
	name = "Resin Acid Grenade"
	desc = "An acid grenade."
	construction_name = "acid grenade"
	cost = XENO_RESIN_ACID_GRENADE_COST
	max_per_xeno = 1

	build_path = /obj/item/explosive/grenade/alien/acid
	build_time = 6 SECONDS

/datum/resin_construction/resin_obj/movable
	construction_name = "resin wall"

	max_per_xeno = 7
	cost = XENO_RESIN_WALL_MOVABLE_COST
	build_time = 3 SECONDS

/datum/resin_construction/resin_obj/movable/wall
	name = "Movable Resin Wall"
	desc = "A resin wall that can be moved onto any adjacent tile, as long as there are weeds."
	construction_name = "resin wall"
	build_path = /obj/structure/alien/movable_wall

/datum/resin_construction/resin_obj/movable/membrane
	name = "Movable Resin Membrane"
	desc = "A resin membrane that can be moved onto any adjacent tile, as long as there are weeds."
	construction_name = "resin wall"
	build_path = /obj/structure/alien/movable_wall/membrane

/datum/resin_construction/resin_obj/movable/thick_wall
	name = "Movable Thick Resin Wall"
	desc = "A thick resin wall that can be moved onto any adjacent tile, as long as there are weeds."
	construction_name = "thick resin wall"
	build_path = /obj/structure/alien/movable_wall/thick

/datum/resin_construction/resin_obj/movable/thick_membrane
	name = "Movable Thick Membrane Wall"
	desc = "A thick resin membrane that can be moved onto any adjacent tile, as long as there are weeds."
	construction_name = "thick resin membrane"
	build_path = /obj/structure/alien/movable_wall/membrane/thick
