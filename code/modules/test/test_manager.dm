var/datum/test_manager/test_executor = new

/datum/test_manager
	// A list of lists containing test sets to run and the individual test cases in each set
	var/list/test_sets = null

	var/list/result_descriptions = list("pass", "fail", "error")

/datum/test_manager/New()
	..()

	test_sets = list()

	for(var/test_type in subtypesof(/datum/test_case))
		var/datum/test_case/case = new test_type()

		// Don't try to run datums defining a set of test cases
		// Oh, and those marked for not being run
		if(!case.should_run || case.name == TEST_SET_NAME)
			qdel(case)
			continue

		if(!test_sets[case.test_set])
			test_sets[case.test_set] = list()

		test_sets[case.test_set] += case

// Runs an individual test case
// @param case - The test case to run
// @param verbose - Whether or not to log the result of the test
// @return success - TEST_PASS if the test succeeded
//                   TEST_FAIL if the test failed
//                   TEST_ERROR if the test threw an error
/datum/test_manager/proc/run_individual_test(var/datum/test_case/case, var/verbose=FALSE)
	if(!case)
		return TEST_FAIL

	// Set the test up, but throw an exception if it fails during setup
	try
		case.setUp()
	catch(var/exception/E)
		E.name = "[case.name] threw an exception during the test setup!\n[E.name]"
		throw E

	var/result = TEST_FAIL
	try
		result = case.test()

		// Falsey return is considered a pass because then we don't
		// have to explicitly return anything for the test to pass
		if(!result)
			result = TEST_PASS
		else
			result = TEST_FAIL
	catch(var/exception/TE)
		// Exception thrown by an assertion to fail the test
		if(TE.name == TEST_ASSERTION_FAIL)
			LOG_TEST("[case.name] failed with the following message:")
			LOG_TEST("[TE.desc]")

			result = TEST_FAIL
		else
			LOG_TEST("[case.name] threw an exception during the test routine:")
			LOG_TEST(TE.name)
			LOG_TEST(TE.desc)

			result = TEST_ERROR

	if(verbose)
		LOG_TEST("[case.name] - [result_descriptions[result]]")

	return result

// Run a set of test cases
// @param test_set - The test set to run
// @param verbose - Whether or not to log the result of each individual test
// @return stats - A list of how many tests passed, failed and errored
/datum/test_manager/proc/run_test_set(var/test_set, var/verbose=FALSE)
	if(!test_sets[test_set])
		return null

	var/list/result_counts = list(0, 0, 0)
	for(var/datum/test_case/case in test_sets[test_set])
		var/result = run_individual_test(case, verbose)
		result_counts[result] += 1

	if(verbose)
		LOG_TEST("Finished test set: [test_set]")
		LOG_TEST("Pass: [result_counts[TEST_PASS]]")
		LOG_TEST("Fail: [result_counts[TEST_FAIL]]")
		LOG_TEST("Error: [result_counts[TEST_ERROR]]")

	return result_counts

// Run all sets of test cases. Regardless of the verbose argument, exceptions will be logged!
// @param verbose - Whether or not to log additional information related to the tests
/datum/test_manager/proc/run_all_tests(var/verbose=FALSE)
	LOG_TEST("Running tests...")

	var/start = world.time
	var/tests_run = 0

	var/list/total_results = list(0, 0, 0)
	for(var/test_set in test_sets)
		if(verbose) LOG_TEST("Running test set: [test_set]")
		var/list/results = run_test_set(test_set, verbose)

		if(isnull(results))
			throw EXCEPTION("Test set [test_set] failed to return its results!")

		total_results[TEST_PASS] += results[TEST_PASS]
		total_results[TEST_FAIL] += results[TEST_FAIL]
		total_results[TEST_ERROR] += results[TEST_ERROR]

		tests_run += (results[TEST_PASS] + results[TEST_FAIL] + results[TEST_ERROR])

	var/test_duration = (world.time - start)/10
	LOG_TEST("Finished [tests_run] test(s) in [test_duration] seconds")
	LOG_TEST("----------------------------------------")
	LOG_TEST("Pass: [total_results[TEST_PASS]]")
	LOG_TEST("Fail: [total_results[TEST_FAIL]]")
	LOG_TEST("Error: [total_results[TEST_ERROR]]")
	LOG_TEST("----------------------------------------")

	return total_results

// The server is being run to do tests only, so start the game, run them and shut down
/datum/test_manager/proc/host_tests()
	master_mode = "extended"

	// Wait for the game ticker to initialize
	while(!SSticker.initialized)
		sleep(10)

	// Start the game
	ticker.current_state = GAME_STATE_SETTING_UP

	// Wait for the game to start
	while(ticker.current_state != GAME_STATE_PLAYING)
		sleep(10)

	// Run the tests
	var/verbose = world.params["verbose_tests"]
	var/test_set = world.params["test_set"]
	var/list/results = null
	if(test_set)
		results = run_test_set(test_set, verbose)
	else
		results = run_all_tests(verbose)

	if(results)
		var/all_tests_passed = results[TEST_FAIL] == 0 && results[TEST_ERROR] == 0
		if(all_tests_passed)
			world.log << TEST_HOST_SUCCESS

	shutdown()
