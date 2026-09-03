/// Spawns two identical drones of the same hive and tests their recovery pheromone transmission. The identity test.
/datum/unit_test/pheromones/transmit_hive__hivemate/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns two identical drones of the same hive and tests their frenzy pheromone transmission. The identity test.
/datum/unit_test/pheromones/transmit_hive__hivemate/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two identical drones of the same hive and tests their warding pheromone transmission. The identity test.
/datum/unit_test/pheromones/transmit_hive__hivemate/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns two drones of the same hive, then banishes the receiver.
/// Expected behavior is that the receiver does not get the emitter's recovery pheromones.
/datum/unit_test/pheromones/transmit_hive__banished_receiver/Run(pheromone_type = XENO_PHERO_RECOVERY)
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(banish_xeno))
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list())
	)

/// Spawns two drones of the same hive, then banishes the receiver.
/// Expected behavior is that the receiver does not get the emitter's frenzy pheromones.
/datum/unit_test/pheromones/transmit_hive__banished_receiver/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two drones of the same hive, then banishes the receiver.
/// Expected behavior is that the receiver does not get the emitter's warding pheromones.
/datum/unit_test/pheromones/transmit_hive__banished_receiver/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns two drones of the same hive, then banishes the emitter.
/// Expected behavior is that the receiver does not get the emitter's recovery pheromones.
/datum/unit_test/pheromones/transmit_hive__banished_emitter/Run(pheromone_type = XENO_PHERO_RECOVERY)
	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(banish_xeno))
		),
		abstract_receiver = new /datum/abstract_xenomorph(),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list())
	)

/// Spawns two drones of the same hive, then banishes the emitter.
/// Expected behavior is that the receiver does not get the emitter's frenzy pheromones.
/datum/unit_test/pheromones/transmit_hive__banished_emitter/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two drones of the same hive, then banishes the emitter.
/// Expected behavior is that the receiver does not get the emitter's warding pheromones.
/datum/unit_test/pheromones/transmit_hive__banished_emitter/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns two drones of the same hive, banishes the receiver, then readmits them into the hive.
/// Expected behavior is that the receiver receives the emitter's recovery pheromones.
/datum/unit_test/pheromones/transmit_hive__readmit_receiver/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(),
		abstract_receiver = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(banish_then_readmit))
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns two drones of the same hive, banishes the receiver, then readmits them into the hive.
/// Expected behavior is that the receiver receives the emitter's frenzy pheromones.
/datum/unit_test/pheromones/transmit_hive__readmit_receiver/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two drones of the same hive, banishes the receiver, then readmits them into the hive.
/// Expected behavior is that the receiver receives the emitter's warding pheromones.
/datum/unit_test/pheromones/transmit_hive__readmit_receiver/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns two drones of the same hive, banishes the emitter, then readmits them into the hive.
/// Expected behavior is that the receiver receives the emitter's recovery pheromones.
/datum/unit_test/pheromones/transmit_hive__readmit_emitter/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_NORMAL

	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			initialization_callback = CALLBACK(src, PROC_REF(banish_then_readmit))
		),
		abstract_receiver = new /datum/abstract_xenomorph(),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns two drones of the same hive, banishes the emitter, then readmits them into the hive.
/// Expected behavior is that the receiver receives the emitter's frenzy pheromones.
/datum/unit_test/pheromones/transmit_hive__readmit_emitter/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two drones of the same hive, banishes the emitter, then readmits them into the hive.
/// Expected behavior is that the receiver receives the emitter's warding pheromones.
/datum/unit_test/pheromones/transmit_hive__readmit_emitter/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns two drones, one of prime hive and the other of alpha hive, ensures they are unallied, then tests their recovery transmission.
/// Expected behavior is that the alpha drone does not receive the prime hive's pheromones.
/datum/unit_test/pheromones/transmit_hive__unallied/Run(pheromone_type = XENO_PHERO_RECOVERY)
	GLOB.hive_datum[XENO_HIVE_NORMAL].change_stance(FACTION_XENOMORPH_ALPHA, FALSE)
	TEST_ASSERT(!HIVE_ALLIED_TO_HIVE(XENO_HIVE_NORMAL, XENO_HIVE_ALPHA), "Hive alliance setup failed during test initialization; prime and alpha hives were not properly unallied")

	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_QUEEN
		),
		abstract_receiver = new /datum/abstract_xenomorph(
			hive = XENO_HIVE_ALPHA,
			caste = XENO_CASTE_QUEEN
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), list())
	)

/// Spawns two drones, one of prime hive and the other of alpha hive, ensures they are unallied, then tests their frenzy transmission.
/// Expected behavior is that the alpha drone does not receive the prime hive's pheromones.
/datum/unit_test/pheromones/transmit_hive__unallied/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two drones, one of prime hive and the other of alpha hive, ensures they are unallied, then tests their warding transmission.
/// Expected behavior is that the alpha drone does not receive the prime hive's pheromones.
/datum/unit_test/pheromones/transmit_hive__unallied/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Spawns two queens, one of prime hive and the other of alpha hive, allies prime to alpha, then tests their recovery transmission.
/// Expected behavior is that the alpha queen receives the prime hive's pheromones.
/datum/unit_test/pheromones/transmit_hive__allied/Run(pheromone_type = XENO_PHERO_RECOVERY)
	var/list/expected_pheromones = list()
	expected_pheromones[pheromone_type] = XENO_PHERO_STRENGTH_VERY_STRONG

	pair_reception_test(
		abstract_emitter = new /datum/abstract_xenomorph(
			caste = XENO_CASTE_QUEEN
		),
		abstract_receiver = new /datum/abstract_xenomorph(
			hive = XENO_HIVE_ALPHA,
			caste = XENO_CASTE_QUEEN,
			initialization_callback = CALLBACK(src, PROC_REF(setup_alliance), XENO_HIVE_NORMAL, XENO_HIVE_ALPHA)
		),
		pheromone_type = pheromone_type,
		test_callback = CALLBACK(src, PROC_REF(pheromone_validation), expected_pheromones)
	)

/// Spawns two queens, one of prime hive and the other of alpha hive, allies prime to alpha, then tests their frenzy transmission.
/// Expected behavior is that the alpha queen receives the prime hive's pheromones.
/datum/unit_test/pheromones/transmit_hive__allied/frenzy/Run()
	. = ..(pheromone_type = XENO_PHERO_FRENZY)

/// Spawns two queens, one of prime hive and the other of alpha hive, allies prime to alpha, then tests their warding transmission.
/// Expected behavior is that the alpha queen receives the prime hive's pheromones.
/datum/unit_test/pheromones/transmit_hive__allied/warding/Run()
	. = ..(pheromone_type = XENO_PHERO_WARDING)

/// Helper proc that banishes a given xeno from their hive.
/datum/unit_test/pheromones/proc/banish_xeno(mob/living/carbon/xenomorph/xeno)
	var/datum/action/xeno_action/onclick/manage_hive/action = allocate(/datum/action/xeno_action/onclick/manage_hive/)
	action.do_banish(null, xeno)

/// Helper proc that banishes a given xeno from their hive, then readmits them after a full cycle of the xeno life loop.
/datum/unit_test/pheromones/proc/banish_then_readmit(mob/living/carbon/xenomorph/xeno)
	var/datum/action/xeno_action/onclick/manage_hive/action = allocate(/datum/action/xeno_action/onclick/manage_hive/)
	action.do_banish(null, xeno)

	wait_full_life_loops(1)

	action.do_readmit(null, xeno)

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
