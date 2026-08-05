TEST_FOCUS(/datum/unit_test/pheromones/)

/datum/unit_test/pheromones/transmit_hive__hivemate_recovery/Run()
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list(XENO_PHERO_RECOVERY = 2))
	)

/datum/unit_test/pheromones/transmit_hive__unallied_recovery/Run()
	GLOB.hive_datum[XENO_HIVE_NORMAL].change_stance(FACTION_XENOMORPH_ALPHA, FALSE)
	TEST_ASSERT(!HIVE_ALLIED_TO_HIVE(XENO_HIVE_NORMAL, XENO_HIVE_ALPHA), "Hive alliance setup failed during test initialization")

	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(hive = XENO_HIVE_ALPHA),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list())
	)

/datum/unit_test/pheromones/transmit_hive__allied_recovery/Run()
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_QUEEN
		),
		abstract_receiver = new /datum/abstract_xenomorph(
			hive = XENO_HIVE_ALPHA,
			caste = XENO_CASTE_QUEEN,
			initialization_callback = CALLBACK(src, PROC_REF(setup_alliance), XENO_HIVE_NORMAL, XENO_HIVE_ALPHA)
		),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list(XENO_PHERO_RECOVERY = 4))
	)

/// Sets up an alliance between the given hives after the abstract xeno is initialized. Fails if either faction lacks a queen.
/// Premade function for `initialization_callback` field of abstract xenomorphs.
/datum/unit_test/pheromones/proc/setup_alliance(offerer, receiver, mob/living/carbon/xenomorph/xeno)
	var/datum/hive_status/offering_hive = GLOB.hive_datum[offerer]
	var/datum/hive_status/receiving_hive = GLOB.hive_datum[receiver]

	TEST_ASSERT_NOTNULL(offering_hive, "Hive alliance setup failed due to undefined offering hive during test initializtion")
	TEST_ASSERT_NOTNULL(receiving_hive, "Hive alliance setup failed due to undefined receiving hive during test initialization")

	// No clue why, but this needs to be manually set even if the offerring hive has no banned allies.
	// Debugger says that it shouldn't, but it very much is still triggering the check that specifies banned allies.
	offering_hive.allow_banned_allies = TRUE

	offering_hive.change_stance(receiving_hive.internal_faction, TRUE)
	TEST_ASSERT(HIVE_ALLIED_TO_HIVE(offerer, receiver), "Hive alliance setup failed to form an alliance during test initialization")
