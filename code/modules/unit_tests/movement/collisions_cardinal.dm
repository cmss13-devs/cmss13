// Moving south with a non-directional blocker on the target turf blocks you
/datum/unit_test/non_directional_collision_blocker_in_target_turf__collision/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(movement_helper_constants::NONE_DIRECTIONAL)
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), TRUE),
	)

// Moving south with a blocker on the target turf facing north blocks you
/datum/unit_test/directional_collision_blocker_in_target_turf__collision/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.north_directional_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), TRUE),
	)

// Moving south with a blocker on your turf also facing south blocks you
/datum/unit_test/directional_collision_blocker_in_mover_turf__collision/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::MOVER_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.south_directional_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), TRUE),
	)

// Moving south with a non-directional blocker on your turf does not block you
/datum/unit_test/non_directional_collision_blocker_in_mover_turf__no_collision/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::MOVER_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.none_directional_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), FALSE),
	)

// Moving south with directional blockers on the target turf not facing north does not block you
/datum/unit_test/directional_collision_blockers_in_target_turf__no_collision/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF, movement_helper_constants::TARGET_TURF, movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.east_directional_blocker_configuration,
				GLOB.south_directional_blocker_configuration,
				GLOB.west_directional_blocker_configuration,
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), FALSE),
	)

// Moving south with directional blockers on the target turf not facing south does not block you
/datum/unit_test/directional_collision_blockers_in_mover_turf__no_collision/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::MOVER_TURF, movement_helper_constants::MOVER_TURF, movement_helper_constants::MOVER_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.east_directional_blocker_configuration,
				GLOB.north_directional_blocker_configuration,
				GLOB.west_directional_blocker_configuration,
			),
		),
		test_callback = CALLBACK(src, PROC_REF(collision_validation), FALSE),
	)
