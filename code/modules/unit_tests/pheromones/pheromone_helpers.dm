/// Helper datum used for unit testing that defines a xenomorph solely based on a few abstract qualities.
/datum/abstract_xenomorph
	var/hive //! The hive that this xeno will be a part of.
	var/caste //! The caste that this xeno will be spawned as.

	/// A callback that can be used for modifying the xenomorph after full instantiation. Takes one argument, which is the living/carbon/xenomorph that was instantiated.
	///
	/// Used for things like banishment, movement, setting health, et cetera.
	var/datum/callback/initialization_callback

/datum/abstract_xenomorph/New(hive = XENO_HIVE_NORMAL, caste = XENO_CASTE_DRONE, datum/callback/initialization_callback)
	src.hive = hive
	src.caste = caste

	src.initialization_callback = initialization_callback

/datum/unit_test/pheromones
	/// Overrides the `wait` variable of the SSxeno subsystem with this value when certain test functions are called.
	/// This is used to expedite tests so they don't have to wait the full 2 seconds per life loop.
	/// Resets the `wait` var to its original value after testing is complete.
	var/ss_wait_override = 100 MILLISECONDS

	var/last_life_complete = FALSE
	var/full_life_complete = FALSE

/datum/unit_test/pheromones/Run()
	SHOULD_CALL_PARENT(FALSE)

/// Sleeps until a full loop of the xeno life subsystem has completed
/datum/unit_test/pheromones/proc/wait_full_life_loop()
	RegisterSignal(SSdcs, COSMIG_GLOB_XENO_LIFE_COMPLETE, PROC_REF(poke_full_life_loop), override = TRUE)

	var/waiting_loops = 0
	while (!full_life_complete)
		sleep(ss_wait_override ? ss_wait_override : 1 SECONDS)

		waiting_loops++
		if (waiting_loops > 30)
			TEST_NOTICE(src, "Test timed out while waiting for a full cycle of the xeno life loop to complete")
			last_life_complete = FALSE
			full_life_complete = FALSE
			UnregisterSignal(src, COSMIG_GLOB_XENO_LIFE_COMPLETE)
			return

	full_life_complete = FALSE
	UnregisterSignal(src, COSMIG_GLOB_XENO_LIFE_COMPLETE)

/datum/unit_test/pheromones/proc/poke_full_life_loop()
	SIGNAL_HANDLER

	if (!last_life_complete)
		last_life_complete = TRUE
		return
	full_life_complete = TRUE
	last_life_complete = FALSE

/**
 * Tests whether a pair of xenomorphs, one dedicated emitter and one dedicated receiver, transmit the expected level of pheromones.
 */
/datum/unit_test/pheromones/proc/pair_reception_test(datum/abstract_xenomorph/abstract_emitter, datum/abstract_xenomorph/abstract_receiver, pheromone_type, datum/callback/test_callback)
	TEST_ASSERT_NOTNULL(abstract_emitter, "No abstract emitter datum was specified for this test")
	TEST_ASSERT_NOTNULL(abstract_receiver, "No abstract receiver datum was specified for this test")
	TEST_ASSERT_NOTNULL(test_callback, "No testing callback was specified for this test")

	var/original_wait
	if (ss_wait_override)
		original_wait = SSxeno.wait
		SSxeno.wait = ss_wait_override

	var/mob/living/carbon/xenomorph/emitter = init_abstract_xeno(abstract_emitter)
	var/mob/living/carbon/xenomorph/receiver = init_abstract_xeno(abstract_receiver)
	TEST_ASSERT_NOTNULL(emitter, "Initialization of the physical emitter xenomorph resulted in a null reference")
	TEST_ASSERT_NOTNULL(receiver, "Initialization of the physical receiver xenomorph resulted in a null reference")

	// Make the emitter release the appropriate pheromones
	emitter.emit_pheromones(pheromone_type)

	wait_full_life_loop()
	wait_full_life_loop()

	test_callback.Invoke(receiver)

	if (original_wait)
		SSxeno.wait = original_wait

/// Initializes an abstract xenomorph into a living, breathing mob. Spawns on the lower leftmost testing turf.
/datum/unit_test/pheromones/proc/init_abstract_xeno(datum/abstract_xenomorph/abstract)
	var/mob/living/carbon/xenomorph/xeno = allocate(GLOB.RoleAuthority.get_caste_by_text(abstract.caste))
	xeno.loc = run_loc_floor_bottom_left
	xeno.set_hive_and_update(abstract.hive)

	if (abstract.initialization_callback)
		abstract.initialization_callback.Invoke(xeno)

	return xeno

/// Validates that a given xenomorph is receiving the correct level of pheromones for every type.
/// Premade function for `test_callback` fields.
/datum/unit_test/pheromones/proc/pheromone_validation(list/expected_pheromones, mob/living/carbon/xenomorph/receiver)
	TEST_ASSERT_NOTNULL(receiver, "No receiver xenomorph was specified for pheromone validation")

	var/list/received_pheromones = list()
	if (receiver.recovery_aura > 0)
		received_pheromones[XENO_PHERO_RECOVERY] = receiver.recovery_aura
	if (receiver.frenzy_aura > 0)
		received_pheromones[XENO_PHERO_FRENZY] = receiver.frenzy_aura
	if (receiver.warding_aura > 0)
		received_pheromones[XENO_PHERO_WARDING] = receiver.warding_aura

	if (isnull(expected_pheromones) || !length(expected_pheromones))
		// No pheromones were expected and no pheromones were received; PASS
		if (!length(received_pheromones))
			return

		// We received something we shouldn't have; FAIL
		for (var/phero_type as anything in ALL_XENO_PHEROMONES)
			if (isnull(received_pheromones[phero_type]))
				continue
			TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received [phero_type] at strength [received_pheromones[phero_type]] when none was expected")
		return

	for (var/phero_type as anything in ALL_XENO_PHEROMONES)
		var/received_nothing = isnull(received_pheromones[phero_type]) || received_pheromones[phero_type] == 0
		var/expected_nothing = isnull(expected_pheromones[phero_type]) || expected_pheromones[phero_type] == 0

		// We did not expect to receive this type of pheromone and we did not receive it; CONTINUE
		if (expected_nothing && received_nothing)
			continue

		// We received something for this type of pheromone when we shouldn't have; FAIL
		if (expected_nothing)
			TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received [phero_type] at strength [received_pheromones[phero_type]] when no [phero_type] was expected")
			continue

		// We expected to receive something for this type of pheromone and got nothing; FAIL
		if (received_nothing)
			TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received no [phero_type] when expected to receive it at strength [expected_pheromones[phero_type]]")
			continue

		// We got something, but it was the wrong strength
		if (expected_pheromones[phero_type] != received_pheromones[phero_type])
			TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received [phero_type] at strength [received_pheromones[phero_type]] when expected to receive it at strength [expected_pheromones[phero_type]]")
