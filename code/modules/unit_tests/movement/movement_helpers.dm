/obj/structure/blocker/test_blocker

/movement_helper_constants
	var/const/NONE_DIRECTIONAL = 0
	var/const/NOT_BLOCKING = null

	/// Resolves to the target direction
	var/const/TARGET_TURF = -1
	// get_step(A, 0) is equal to the turf of A
	var/const/MOVER_TURF = -2

	var/const/TRAIT_TEST = "trait_test"
	var/const/TEST_TRAIT = "test_trait"

GLOBAL_REAL(movement_helper_constants, /movement_helper_constants)

/atom/movable/test_mover
	can_block_movement = TRUE

/atom/movable/test_mover/Collide(atom/A)
	. = ..()
	if (HAS_TRAIT(A, movement_helper_constants::TRAIT_TEST))
		return TRUE

/datum/blocker_parameters
	var/direction
	var/datum/pass_flags_container/pass_flags_override
	var/has_collide_trait

/datum/blocker_parameters/New(direction, pass_flags_override, has_collide_trait)
	src.direction = direction
	src.pass_flags_override = pass_flags_override
	src.has_collide_trait = has_collide_trait

GLOBAL_DATUM_INIT(none_directional_blocker_configuration, /datum/blocker_parameters, new(movement_helper_constants::NONE_DIRECTIONAL))
GLOBAL_DATUM_INIT(not_blocking_blocker_configuration, /datum/blocker_parameters, new(movement_helper_constants::NOT_BLOCKING))
GLOBAL_DATUM_INIT(north_directional_blocker_configuration, /datum/blocker_parameters, new(NORTH))
GLOBAL_DATUM_INIT(south_directional_blocker_configuration, /datum/blocker_parameters, new(SOUTH))
GLOBAL_DATUM_INIT(west_directional_blocker_configuration, /datum/blocker_parameters, new(WEST))
GLOBAL_DATUM_INIT(east_directional_blocker_configuration, /datum/blocker_parameters, new(EAST))
GLOBAL_DATUM_INIT(non_directional_can_pass_all_blocker_configuration, /datum/blocker_parameters, new(movement_helper_constants::NONE_DIRECTIONAL, pass_flags_all_directions()))
// Below tests are for testing pass flags for a mover going south
GLOBAL_DATUM_INIT(directional_can_pass_all_blocker_configuration, /datum/blocker_parameters, new(movement_helper_constants::NONE_DIRECTIONAL, pass_flags_all_directions()))
GLOBAL_DATUM_INIT(directional_can_pass_front_blocker_configuration, /datum/blocker_parameters, new(NORTH, pass_flags_front()))
GLOBAL_DATUM_INIT(directional_can_pass_behind_blocker_configuration, /datum/blocker_parameters, new(SOUTH, pass_flags_behind()))
GLOBAL_DATUM_INIT(collide_allows_movement_blocker_configuration, /datum/blocker_parameters, new(movement_helper_constants::NONE_DIRECTIONAL, null, TRUE))

/proc/pass_flags_all_directions()
	var/datum/pass_flags_container/container = new()
	container.flags_can_pass_all = PASS_ALL
	return container

/proc/pass_flags_front()
	var/datum/pass_flags_container/container = new()
	container.flags_can_pass_front = PASS_ALL
	return container

/proc/pass_flags_behind()
	var/datum/pass_flags_container/container = new()
	container.flags_can_pass_behind = PASS_ALL
	return container

/proc/length_cmp(list/a, list/b)
	return length(a) == length(b)

/**
 * Test whether a movement collision will happen for a mover given a set of configurations for blockers
 *
 * target_direction: direction mover is moving to enter target turf
 * collision_expected: whether collisions for all of the blocker direction configurations are expected to happen
 * blocker_positions: the position of the blockers relative to the mover (unless specifying target or mover turfs)
 * blocker_parameters: a list of lists, where the nested lists are mapped to the blockers specified in `blocker_positions` specifying the blockers' parameters
 * test_callback: a callback of that accepts the mover, target turf, and mover's starting turf to validate whether expected result occurred
 */
/datum/unit_test/proc/movement_test(target_direction, list/blocker_positions, list/list/datum/blocker_parameters/blocker_parameters_entries, datum/callback/test_callback)
	TEST_ASSERT_NOTNULL(target_direction, "Target direction not specified for test")
	TEST_ASSERT(length(blocker_positions), "No blocker turfs passed to parameterized collision test")
	TEST_ASSERT(length(blocker_parameters_entries), "No blocker direction entries passed to parameterized collision test")
	TEST_ASSERT(list_all(blocker_parameters_entries, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(length_cmp), blocker_positions)), "Entry in blocker_dirs does not map 1:1 with the number of blockers for this test")
	var/list/obj/structure/blocker/test_blocker/blockers = list()
	var/list/datum/pass_flags_container/cached_pass_flags = list()
	// Target turf will be in the center and for each collision test, select
	// a direct to go towards the target turf and specify where the blockers are
	// relative to the mover
	var/turf/target_turf = get_step(run_loc_floor_bottom_left, NORTHEAST)
	var/turf/mover_start_turf = get_step(target_turf, GLOB.reverse_dir[target_direction])
	var/atom/movable/test_mover/mover = allocate(/atom/movable/test_mover, mover_start_turf)
	mover.add_temp_pass_flags(PASS_ALL)
	for (var/blocker_position in blocker_positions)
		var/turf/blocker_turf
		if (blocker_position == movement_helper_constants::TARGET_TURF)
			blocker_turf = target_turf
		else if (blocker_position == movement_helper_constants::MOVER_TURF)
			blocker_turf = mover_start_turf
		else
			blocker_turf = get_step(mover, blocker_position)
		var/obj/structure/blocker/test_blocker = create_blocker(blocker_turf)
		blockers += test_blocker
		cached_pass_flags = test_blocker.pass_flags
	for (var/i in 1 to length(blocker_parameters_entries))
		var/list/blocker_parameters_entry = blocker_parameters_entries[i]
		for (var/j in 1 to length(blocker_parameters_entry))
			var/datum/blocker_parameters/blocker_parameters = blocker_parameters_entry[j]
			TEST_ASSERT(istype(blocker_parameters), "Blocker parameters not passed for entry [i]")
			var/direction = blocker_parameters.direction
			if (direction == movement_helper_constants::NOT_BLOCKING)
				blockers[j].density = FALSE
			else if (direction == movement_helper_constants::NONE_DIRECTIONAL)
				blockers[j].density = TRUE
				blockers[j].flags_atom &= ~ON_BORDER
			else
				blockers[j].density = TRUE
				blockers[j].flags_atom |= ON_BORDER
				blockers[j].dir = direction
			var/pass_flags_override = blocker_parameters.pass_flags_override
			if (pass_flags_override)
				blockers[j].pass_flags = pass_flags_override
			if (blocker_parameters.has_collide_trait)
				ADD_TRAIT(blockers[j], movement_helper_constants::TRAIT_TEST, movement_helper_constants::TEST_TRAIT)
		test_callback.Invoke(i, mover, target_turf, mover_start_turf)
		// Reset pass flags
		for (var/j in 1 to length(cached_pass_flags))
			blockers[j].pass_flags = cached_pass_flags[j]
			if (HAS_TRAIT(blockers[j], movement_helper_constants::TRAIT_TEST))
				REMOVE_TRAIT(blockers[j], movement_helper_constants::TRAIT_TEST, movement_helper_constants::TEST_TRAIT)
	blockers.Cut()

/datum/unit_test/proc/collision_validation(collision_expected, entry_number, atom/movable/test_mover/mover, turf/target_turf, turf/mover_start_turf)
	var/expected_result = !collision_expected
	if ((mover.Move(target_turf) != 0) != expected_result)
		TEST_FAIL("Expected movement to [collision_expected ? "fail" : "succeed"] for entry [entry_number]")
	mover.forceMove(mover_start_turf)

/datum/unit_test/proc/link_blocked_validation(link_blocked_expected, entry_number, atom/movable/test_mover/mover, turf/target_turf, turf/mover_start_turf)
	var/expected_result = link_blocked_expected
	if (!isnull(LinkBlocked(mover, mover_start_turf, target_turf)) != expected_result)
		TEST_FAIL("Expected link blocked to be [link_blocked_expected ? "TRUE" : "FALSE"] for entry [entry_number]")

/datum/unit_test/proc/create_blocker(turf/blocker_turf, blocking_dir)
	var/obj/structure/blocker/test_blocker/blocker = allocate(/obj/structure/blocker/test_blocker, blocker_turf)
	if (blocking_dir)
		blocker.flags_atom |= ON_BORDER
		blocker.dir = blocking_dir
	TEST_ASSERT(blocker in blocker_turf.movement_blockers, "Blocker is not in its turf's movement blockers list")
	return blocker
