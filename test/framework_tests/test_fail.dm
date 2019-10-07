/datum/test_case/framework/fail
	name = "Failing test"

// All the test should do is fail
/datum/test_case/framework/fail/test()
	assertTrue(FALSE)
