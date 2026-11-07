/datum/unit_test/pheromones
	/// Overrides the `wait` variable of the SSxeno subsystem with this value when certain test functions are called.
	/// This is used to expedite tests so they don't have to wait the full 2 seconds per life loop.
	/// Resets the `wait` var to its original value after testing is complete.
	var/ss_wait_override = 100 MILLISECONDS

	var/last_life_complete = FALSE
	var/total_loops_complete = 0

/datum/unit_test/pheromones/Run()
	SHOULD_CALL_PARENT(FALSE)

/// Sleeps until X amount of full loops of the xeno life subsystem have completed
/datum/unit_test/pheromones/proc/wait_full_life_loops(loops)
	RegisterSignal(SSdcs, COSMIG_GLOB_XENO_LIFE_COMPLETE, PROC_REF(poke_full_life_loop), override = TRUE)

	var/waiting_loops = 0
	while (total_loops_complete < loops)
		sleep(ss_wait_override ? ss_wait_override : 1 SECONDS)

		waiting_loops++
		if (waiting_loops > 30 * loops)
			TEST_FAIL("Test timed out while waiting for a full cycle of the xeno life loop to complete")
			last_life_complete = FALSE
			total_loops_complete = 0
			UnregisterSignal(src, COSMIG_GLOB_XENO_LIFE_COMPLETE)
			return

	last_life_complete = FALSE
	total_loops_complete = 0
	UnregisterSignal(src, COSMIG_GLOB_XENO_LIFE_COMPLETE)

/datum/unit_test/pheromones/proc/poke_full_life_loop()
	SIGNAL_HANDLER

	if (!last_life_complete)
		last_life_complete = TRUE
		return
	total_loops_complete++

/// Returns true if the target xenomorph has the emit_pheromones action in its action list
/datum/unit_test/pheromones/proc/emits_pheromones(mob/living/carbon/xenomorph/target)
	for (var/datum/action/xeno_action/action in target.actions)
		if (istype(action, /datum/action/xeno_action/onclick/emit_pheromones))
			return TRUE
	return FALSE

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

	var/mob/living/carbon/xenomorph/emitter = abstract_emitter.initialize(src)
	var/mob/living/carbon/xenomorph/receiver = abstract_receiver.initialize(src)
	TEST_ASSERT_NOTNULL(emitter, "Initialization of the physical emitter xenomorph resulted in a null reference")
	TEST_ASSERT_NOTNULL(receiver, "Initialization of the physical receiver xenomorph resulted in a null reference")

	// Make the emitter release the appropriate pheromones
	emitter.emit_pheromones(pheromone_type)

	wait_full_life_loops(1)

	test_callback.Invoke(receiver)

	if (original_wait)
		SSxeno.wait = original_wait

/**
 * Tests whether a single xenomorph successfully emits its pheromones to every possible caste (barring hellhounds) of the same hive.
 */
/datum/unit_test/pheromones/proc/all_caste_reception_test(datum/abstract_xenomorph/abstract_emitter, pheromone_type, datum/callback/test_callback)
	TEST_ASSERT_NOTNULL(abstract_emitter, "No abstract emitter datum was specified for this test")
	TEST_ASSERT_NOTNULL(test_callback, "No testing callback was specified for this test")

	var/original_wait
	if (ss_wait_override)
		original_wait = SSxeno.wait
		SSxeno.wait = ss_wait_override

	var/datum/abstract_xenomorph/abstract_receiver = new
	abstract_receiver.hive = abstract_emitter.hive

	var/list/mob/living/carbon/xenomorph/hivemates = list()
	var/mob/living/carbon/xenomorph/emitter = abstract_emitter.initialize(src)
	TEST_ASSERT_NOTNULL(emitter, "Initialization of the physical emitter xenomorph resulted in a null reference")

	for (var/caste_type in ALL_XENO_CASTES)
		if (caste_type == XENO_CASTE_HELLHOUND)
			continue

		abstract_receiver.caste = caste_type
		hivemates += abstract_receiver.initialize(src)

	emitter.emit_pheromones(pheromone_type)

	wait_full_life_loops(1)

	for (var/mob/living/carbon/xenomorph/receiver as anything in hivemates)
		test_callback.Invoke(receiver)

	if (original_wait)
		SSxeno.wait = original_wait

/datum/unit_test/pheromones/proc/reception_permutation_test(list/datum/abstract_xenomorph/abstract_emitters, datum/abstract_xenomorph/abstract_receiver, datum/callback/test_callback)
	TEST_ASSERT_NOTEQUAL(length(abstract_emitters), 0, "No abstract emitters were specified for this test")
	TEST_ASSERT_NOTNULL(abstract_receiver, "No abstract receiver was specified for this test")
	TEST_ASSERT_NOTNULL(test_callback, "No testing callback was specified for this test")

	var/original_wait
	if (ss_wait_override)
		original_wait = SSxeno.wait
		SSxeno.wait = ss_wait_override

	var/mob/living/carbon/xenomorph/receiver = abstract_receiver.initialize(src)
	var/list/mob/living/carbon/xenomorph/emitters = list()
	for (var/datum/abstract_xenomorph/abstract_emitter as anything in abstract_emitters)
		var/mob/living/carbon/xenomorph/emitter = abstract_emitter.initialize(src)
		TEST_ASSERT_NOTNULL(emitter, "Initialization of the physical emitter xenomorph resulted in a null reference")

		emitters += emitter
	TEST_ASSERT_NOTNULL(receiver, "Initializtion of physical receiver xenomorph resulted in a null reference")

	// Asserting that the total number of pheromone types matches what we expect to test for. (3)
	// If you are adding a new pheromone type and reception_permutation_test is failing, please review this module and add/update the corresponding necessary unit tests.
	var/total_pheromones = length(ALL_XENO_PHEROMONES)
	var/const/expected_pheromones = 3
	TEST_ASSERT_EQUAL(total_pheromones, expected_pheromones, "Test found [total_pheromones] pheromone types, but expected to see [expected_pheromones]. If you are adding a new pheromone type, please review the 'code/modules/unit_tests/pheromones/' testing suite and add/update unit tests accordingly.")

	// Find the appropriate length of the bitmask used for permutation indexing.
	// For our current array of recovery, frenzy, and warding, this should be two.
	var/bitmask_length = 0
	while (total_pheromones >> bitmask_length != 0)
		bitmask_length++
	var/bitmask = (1 << bitmask_length) - 1 // Creating the actual bitmask

	// Iterate through all possible permutations
	var/hallucinated_loops = 0
	for (var/permutation = 0, permutation < (1 << (length(abstract_emitters) * bitmask_length)), permutation++)
		log_test("Starting pheromone permutation [num2hex(permutation, 2)]...")

		// Setting up each emitter state
		var/hallucinated = FALSE
		for (var/emitter_index in 1 to length(emitters))
			var/mob/living/carbon/xenomorph/emitter = emitters[emitter_index]
			if (!emitter) // Robustifying the loop
				continue
			// This test is long enough that xenos can actually run out of plasma/die from being off weeds
			emitter.heal_all_damage()
			emitter.gain_plasma(emitter.plasma_max)
			if (!emitter.check_state(TRUE))
				TEST_FAIL("...emitter [emitter] was incapacitated during testing. FAIL")

			/** === Bit math explanation ===
			 * The current permutation index is used to encode what pheromone is being emitted by each xenomorph in the test
			 * For instance, in a test with three xenomorphs, the permutation value would look something like this:
			 * 0b 00 10 01
			 * Breaking this down, this means that the first xenomorph is emitting pheromone type 0b01 (1-recovery),
			 * the second xenomorph is emitting pheromone type 0b10 (2-frenzy), and that the third xenomorph is not emitting pheromones at all.
			 *
			 * Doing it this way means we have a canonical way of encoding emissions of every possible permutation between n group of xenomorphs.
			 * The current gallery of no pheromones, recovery, warding, and frenzy allows the pheromone emission to be encoded in two bits.
			 * Should more pheromone types be added in the future, these two-bit "windows" will be expanded to three bits by the test.
			**/
			var/bitshift = (emitter_index - 1) * bitmask_length // Calculating how much we need to move the bitmask window. With two bits per xenomorph, we only need to shift it by two for every xenomorph.
			var/should_emit = (permutation & (bitmask << bitshift)) >> bitshift // Isolating the value using our bitmask of 0b11 (3).
			if (should_emit == 0)
				// A value of zero means that no pheromones should be emitted
				if (emitter.current_aura != null)
					emitter.emit_pheromones() // Emitting pheromones with no type specified cancels emission
			else if (should_emit > total_pheromones)
				// Because of the way permutations are being encoded into bits, it could be possible that the permutation loop iterates over a pheromone type that does not exist
				// For instance, if there were to be a fourth pheromone and the bit mask was pushed up to three bits, the loop would still iterate over the possible 5th, 6th, and 7th pheromones
				// Since we don't want to include these "hallucinated" pheromones in our testing callback, we should keep track of when we skipped over them
				hallucinated = TRUE
				break
			else
				// A non-zero value means that we use said value to index into the list of all pheromones
				emitter.emit_pheromones(ALL_XENO_PHEROMONES[should_emit])

		// Don't bother doing testing for hallucinated loops
		if (hallucinated)
			hallucinated_loops++
			log_test("...DONE (HALLUCINATED)")
			continue

		wait_full_life_loops(1)

		test_callback.Invoke(receiver, permutation - hallucinated_loops + 1)
		log_test("...DONE")

	if (original_wait)
		SSxeno.wait = original_wait

/**
 *  Validates that a given xenomorph is receiving the correct level of pheromones for every type.
 *  Premade function for `test_callback` fields.
 **/
/datum/unit_test/pheromones/proc/pheromone_validation(list/expected_pheromones, mob/living/carbon/xenomorph/receiver, permutation_index = null)
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
			if (permutation_index == null)
				TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received [phero_type] at strength [received_pheromones[phero_type]] when none was expected")
			else
				TEST_FAIL("Receiver [receiver.caste_type] of permutation [num2hex(permutation_index - 1, 2)] received [phero_type] at strength [received_pheromones[phero_type]] when none was expected")
		return

	for (var/phero_type as anything in ALL_XENO_PHEROMONES)
		var/received_nothing = isnull(received_pheromones[phero_type]) || received_pheromones[phero_type] == 0
		var/expected_nothing = isnull(expected_pheromones[phero_type]) || expected_pheromones[phero_type] == 0

		// We did not expect to receive this type of pheromone and we did not receive it; CONTINUE
		if (expected_nothing && received_nothing)
			continue

		// We received something for this type of pheromone when we shouldn't have; FAIL
		if (expected_nothing)
			if (permutation_index == null)
				TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received [phero_type] at strength [received_pheromones[phero_type]] when no [phero_type] was expected")
			else
				TEST_FAIL("Receiver [receiver.caste_type] of permutation [num2hex(permutation_index - 1, 2)] received [phero_type] at strength [received_pheromones[phero_type]] when no [phero_type] was expected")
			continue

		// We expected to receive something for this type of pheromone and got nothing; FAIL
		if (received_nothing)
			if (permutation_index == null)
				TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received no [phero_type] when expected to receive it at strength [expected_pheromones[phero_type]]")
			else
				TEST_FAIL("Receiver [receiver.caste_type] of permutation [num2hex(permutation_index - 1, 2)] received no [phero_type] when expected to receive it at strength [expected_pheromones[phero_type]]")
			continue

		// We got something, but it was the wrong strength
		if (expected_pheromones[phero_type] != received_pheromones[phero_type])
			if (permutation_index == null)
				TEST_FAIL("Receiver [receiver.caste_type] of hive [receiver.hivenumber] received [phero_type] at strength [received_pheromones[phero_type]] when expected to receive it at strength [expected_pheromones[phero_type]]")
			else
				TEST_FAIL("Receiver [receiver.caste_type] of permutation [num2hex(permutation_index - 1, 2)] received [phero_type] at strength [received_pheromones[phero_type]] when expected to receive it at strength [expected_pheromones[phero_type]]")

/datum/unit_test/pheromones/proc/permutable_pheromone_validation(list/expected_pheromone_permutatations, mob/living/carbon/xenomorph/receiver, permutation_index)
	if (permutation_index > length(expected_pheromone_permutatations))
		TEST_FAIL("Pheromone permutation [num2hex(permutation_index - 1, 2)] did not have defined expected behavior")
		return

	pheromone_validation(expected_pheromone_permutatations[permutation_index], receiver, permutation_index)
