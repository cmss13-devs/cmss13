/datum/test_case/framework/functionality
	name = "Framework functionality test"
	// This is run manually to avoid recursion
	should_run = FALSE

// The test should run the other tests in the set and make sure they all produced the expected results
/datum/test_case/framework/functionality/test()
	var/list/results = test_executor.run_test_set(test_set)

	assertTrue(!isnull(results))

	assertTrue(results[TEST_PASS] = 1)
	assertTrue(results[TEST_FAIL] = 1)
	assertTrue(results[TEST_ERROR] = 1)
