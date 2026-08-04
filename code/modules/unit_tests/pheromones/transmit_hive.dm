TEST_FOCUS(/datum/unit_test/pheromones/)

/datum/unit_test/pheromones/transmit_hive__hivemate_recovery/Run()
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list(XENO_PHERO_RECOVERY = 2))
	)

/datum/unit_test/pheromones/transmit_hive__unallied_recovery/Run()
	GLOB.hive_datum[XENO_HIVE_NORMAL].change_stance(XENO_HIVE_ALPHA, FALSE)
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
			caste = XENO_CASTE_QUEEN,
			initialization_callback = CALLBACK(src, PROC_REF(setup_alliance), XENO_HIVE_ALPHA)
		),
		abstract_receiver = new /datum/abstract_xenomorph(hive = XENO_HIVE_ALPHA),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list(XENO_PHERO_RECOVERY = 2))
	)
