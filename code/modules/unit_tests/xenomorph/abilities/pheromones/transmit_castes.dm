/// Tests for complete coverage of `transmit_castes` type unit_tests.
///
/// If this is failing, then that means that there exists a xenomorph that can emit pheromones but is not marked as an emitting caste/strain in this test.
/// Please ensure you add the appropriate unit tests to this module before including said caste/strain in this test's coverage list.
/datum/unit_test/pheromones/transmit_castes/coverage/Run()
	// Put any new castes/strains that can emit pheromones in here after creating a transmit_castes test for said variation
	var/list/emitting_castes = list(XENO_CASTE_DRONE, XENO_CASTE_LESSER_DRONE, XENO_CASTE_HIVELORD, XENO_CASTE_CARRIER, XENO_CASTE_QUEEN, XENO_CASTE_KING) // Only count castes that can emit with their base strain
	var/list/emitting_strains = list(DRONE_HEALER, DRONE_GARDENER, CARRIER_EGGSAC, HIVELORD_DESIGNER, HIVELORD_RESIN_WHISPERER, PRAETORIAN_VALKYRIE)

	for (var/caste_name in ALL_XENO_CASTES)
		var/datum/abstract_xenomorph/dummy_xeno_abstract = new (caste = caste_name)
		var/mob/living/carbon/xenomorph/dummy_xeno = dummy_xeno_abstract.initialize(src)

		var/datum/caste_datum/caste = dummy_xeno.caste
		if (emits_pheromones(dummy_xeno) && !(caste_name in emitting_castes))
			TEST_FAIL("Found a xenomorph caste [caste_name] define that can emit pheromones but does not have an associated /datum/unit_test/pheromones/transmit_castes subtype unit test. If you are adding a new xenomorph caste, set one up!")

		for(var/datum/xeno_strain/strain_type as anything in caste.available_strains)
			var/datum/xeno_strain/strain_instance = new strain_type()
			strain_instance._add_to_xeno(dummy_xeno)

			if (emits_pheromones(dummy_xeno) && !(strain_type.name in emitting_strains))
				TEST_FAIL("Found a xenomorph strain [strain_type] of [caste_name] that can emit pheromones but does not have an associated /datum/unit_test/pheromones/transmit_castes subtype unit test. If you are adding a new xenomorph strain, set one up!")
			dummy_xeno.reset_strain()

/// Spawns a single prime hive emitter drone, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the drone's recovery pheromones at normal pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter drone, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the drone's frenzy pheromones at normal pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter drone, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the drone's warding pheromones at normal pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter drone of the healer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the drone's recovery pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/healer/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), DRONE_HEALER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter drone of the healer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the drone's frenzy pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/healer/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter drone of the healer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the drone's warding pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/healer/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter drone of the gardener strain, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the drone's recovery pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/gardener/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), DRONE_HEALER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter drone of the gardener strain, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the drone's frenzy pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/gardener/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter drone of the gardener strain, along with a prime hive receiver of every possible xenomorph cast, then forces the drone to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the drone's warding pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/drone/gardener/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter lesser drone, along with a prime hive receiver of every possible xenomorph cast, then forces the lesser drone to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the drone's recovery pheromones at weak pheromone strength.
/datum/unit_test/pheromones/transmit_castes/lesser/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_WEAK

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_LESSER_DRONE),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter lesser drone, along with a prime hive receiver of every possible xenomorph cast, then forces the lesser drone to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the drone's frenzy pheromones at weak pheromone strength.
/datum/unit_test/pheromones/transmit_castes/lesser/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter lesser drone, along with a prime hive receiver of every possible xenomorph cast, then forces the lesser drone to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the drone's warding pheromones at weak pheromone strength.
/datum/unit_test/pheromones/transmit_castes/lesser/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter hivelord, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's recovery pheromones at hivelord pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_HIVELORD

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_HIVELORD),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter hivelord, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's frenzy pheromones at hivelord pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter hivelord, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's warding pheromones at hivelord pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter hivelord of the resin whisperer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's recovery pheromones at hivelord pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/resin_whisperer/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_HIVELORD

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_HIVELORD,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), HIVELORD_RESIN_WHISPERER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter hivelord of the resin whisperer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's frenzy pheromones at hivelord pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/resin_whisperer/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter hivelord of the resin whisperer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's warding pheromones at hivelord pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/resin_whisperer/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter hivelord of the designer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's recovery pheromones at the unique designer pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/designer/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_HIVELORD + XENO_PHERO_MOD_LARGE

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_HIVELORD,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), HIVELORD_DESIGNER)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter hivelord of the designer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's frenzy pheromones at the unique designer pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/designer/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter hivelord of the designer strain, along with a prime hive receiver of every possible xenomorph cast, then forces the hivelord to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the hivelord's warding pheromones at the unique designer pheromone strength.
/datum/unit_test/pheromones/transmit_castes/hivelord/designer/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter carrier, along with a prime hive receiver of every possible xenomorph cast, then forces the carrier to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the carrier's recovery pheromones at normal pheromone strength.
/datum/unit_test/pheromones/transmit_castes/carrier/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_CARRIER),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter carrier, along with a prime hive receiver of every possible xenomorph cast, then forces the carrier to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the carrier's frenzy pheromones at normal pheromone strength.
/datum/unit_test/pheromones/transmit_castes/carrier/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter carrier, along with a prime hive receiver of every possible xenomorph cast, then forces the carrier to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the carrier's warding pheromones at normal pheromone strength.
/datum/unit_test/pheromones/transmit_castes/carrier/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter carrier of the eggsac strain, along with a prime hive receiver of every possible xenomorph cast, then forces the carrier to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the carrier's recovery pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/carrier/eggsac/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_CARRIER,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), CARRIER_EGGSAC)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter carrier of the eggsac strain, along with a prime hive receiver of every possible xenomorph cast, then forces the carrier to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the carrier's frenzy pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/carrier/eggsac/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter carrier of the eggsac strain, along with a prime hive receiver of every possible xenomorph cast, then forces the carrier to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the carrier's warding pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/carrier/eggsac/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter praetoreon of the valkyrie strain, along with a prime hive receiver of every possible xenomorph cast, then forces the praetoreon to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the praetoreon's recovery pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/praetorian/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_PRAETORIAN,
			initialization_callback = CALLBACK(src, PROC_REF(set_strain_on_init), PRAETORIAN_VALKYRIE)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter praetoreon of the valkyrie strain, along with a prime hive receiver of every possible xenomorph cast, then forces the praetoreon to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the praetoreon's frenzy pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/praetorian/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter praetoreon of the valkyrie strain, along with a prime hive receiver of every possible xenomorph cast, then forces the praetoreon to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the praetoreon's warding pheromones at strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/praetorian/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter queen, along with a prime hive receiver of every possible xenomorph cast, then forces the queen to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the queen's recovery pheromones at very strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/queen/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_VERY_STRONG

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_QUEEN),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter queen, along with a prime hive receiver of every possible xenomorph cast, then forces the queen to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the queen's frenzy pheromones at very strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/queen/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter queen, along with a prime hive receiver of every possible xenomorph cast, then forces the queen to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the queen's warding pheromones at very strong pheromone strength.
/datum/unit_test/pheromones/transmit_castes/queen/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns a single prime hive emitter king, along with a prime hive receiver of every possible xenomorph cast, then forces the king to emit recovery pheromones.
/// Expected behavior is that every receiver properly receives the king's recovery pheromones at overwhelming pheromone strength.
/datum/unit_test/pheromones/transmit_castes/king/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_OVERWHELMING

	all_caste_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(caste = XENO_CASTE_KING),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns a single prime hive emitter king, along with a prime hive receiver of every possible xenomorph cast, then forces the king to emit frenzy pheromones.
/// Expected behavior is that every receiver properly receives the king's frenzy pheromones at overwhelming pheromone strength.
/datum/unit_test/pheromones/transmit_castes/king/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns a single prime hive emitter king, along with a prime hive receiver of every possible xenomorph cast, then forces the king to emit warding pheromones.
/// Expected behavior is that every receiver properly receives the king's warding pheromones at overwhelming pheromone strength.
/datum/unit_test/pheromones/transmit_castes/king/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// An initialization callback for abstract xenomorphs that sets the strain of the target xenomorph.
/datum/unit_test/pheromones/proc/set_strain_on_init(strain_name, mob/living/carbon/xenomorph/xeno)
	var/list/datum/xeno_strain/strain_list = list()
	for(var/datum/xeno_strain/strain_type as anything in xeno.caste.available_strains)
		strain_list[initial(strain_type.name)] = strain_type

	var/datum/xeno_strain/chosen_strain = strain_list[strain_name]
	TEST_ASSERT_NOTNULL(chosen_strain, "Failed to find specified strain [strain_name] on [xeno] during test initializtion")

	var/datum/xeno_strain/strain_instance = new chosen_strain()
	strain_instance._add_to_xeno(xeno)
