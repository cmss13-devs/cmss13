/**
 * A non-directional blocker on the target turf with can pass flags that intersect
 * with a mover's pass flags will not block link
 */
/datum/unit_test/can_pass_link_blocker/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.directional_can_pass_all_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(link_blocked_validation), FALSE),
	)

/**
 * A directional blocker on the target turf with can pass front flags that intersect
 * with a mover's pass flags will not block link
 */
/datum/unit_test/can_pass_front_directional_link_blocker/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::TARGET_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.directional_can_pass_front_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(link_blocked_validation), FALSE),
	)

/**
 * A directional exit blocker on the mover's turf with can pass behind flags that intersect
 * with a mover's pass flags will not block link
 */
/datum/unit_test/can_pass_behind_directional_link_blocker/Run()
	movement_test(
		target_direction = SOUTH,
		blocker_positions = list(movement_helper_constants::MOVER_TURF),
		blocker_parameters_entries = list(
			list(
				GLOB.directional_can_pass_behind_blocker_configuration
			),
		),
		test_callback = CALLBACK(src, PROC_REF(link_blocked_validation), FALSE),
	)
