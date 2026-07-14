/**
 * Two blockers that mover can move through in `Collision` call will not be blocked
 */
/datum/unit_test/two_collisions_that_pass_through/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF, movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.collide_allows_movement_blocker_configuration,
				GLOB.collide_allows_movement_blocker_configuration,
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), FALSE),
	)

/**
 * If one blocker collision allows pass through and other does not, movement is blocked
 */
/datum/unit_test/one_collision_that_passes_through__one_collisions_that_blocks/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF, movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.collide_allows_movement_blocker_configuration,
				GLOB.none_directional_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), TRUE),
	)
