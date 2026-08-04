/datum/unit_test/pheromones/transmit_hive__hivemate_recovery/Run()
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(PROC_REF(pheromone_validation), list(XENO_PHERO_RECOVERY = XENO_PHERO_MOD_MED))
	)

/datum/unit_test/pheromones/transmit_hive__unallied_recovery/Run()
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(hive = XENO_HIVE_ALPHA),
		pheromone_type = XENO_PHERO_RECOVERY,
		test_callback = CALLBACK(PROC_REF(pheromone_validation), list())
	)
