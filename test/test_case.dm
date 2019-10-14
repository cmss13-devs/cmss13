/datum/test_case
	// Name of the test
	var/name = TEST_SET_NAME

	// A name for the category or set this test case belongs in
	var/test_set = "Tests"

	// Whether or not the test should be run
	var/should_run = TRUE

// Fails the test by throwing a special exception, ending it immediately
// @param fail_message - A message to display about why the test failed
/datum/test_case/proc/fail(var/fail_message=null)
	if(!fail_message)
		fail_message = "no fail message given (write fail messages for your tests!!!)"

	var/exception/fail_exception = EXCEPTION(TEST_ASSERTION_FAIL)
	fail_exception.desc = fail_message

	throw fail_exception

//  Assertions
//  ----------
//  
//  These procs check if a given condition is satisfied.
//  If it isn't, it will cancel the test and fail it.

// Assert that a statement evaluates to true
// @param statement - The statement to evaluate
// @param fail_description - A short message describing why the test failed if it turns out to fail
/datum/test_case/proc/assertTrue(var/statement, var/fail_msg=null)
	if(!statement)
		if(!fail_msg)
			fail_msg = "expected [statement] to be truthy (1)"

		fail(fail_msg)

// Assert that a statement evaluates to false
/datum/test_case/proc/assertFalse(var/statement, var/fail_msg=null)
	assertTrue(!statement, (fail_msg ? fail_msg : "expected [statement] to be falsy (0)"))

// Assert that a equals b
/datum/test_case/proc/assertEquals(var/a, var/b, var/fail_msg=null)
	assertTrue(a == b, (fail_msg ? fail_msg : "expected [a] == [b]"))

// Assert that a > b
/datum/test_case/proc/assertGt(var/a, var/b, var/fail_msg=null)
	assertTrue(a > b, (fail_msg ? fail_msg : "expected [a] > [b]"))

// Assert that a >= b
/datum/test_case/proc/assertGtEq(var/a, var/b, var/fail_msg=null)
	assertTrue(a >= b, (fail_msg ? fail_msg : "expected [a] >= [b]"))

// Assert that a < b
/datum/test_case/proc/assertLt(var/a, var/b, var/fail_msg=null)
	assertTrue(a < b, (fail_msg ? fail_msg : "expected [a] < [b]"))

// Assert that a <= b
/datum/test_case/proc/assertLtEq(var/a, var/b, var/fail_msg=null)
	assertTrue(a <= b, (fail_msg ? fail_msg : "expected [a] <= [b]"))

// Assert that a is in the list L
/datum/test_case/proc/assertInList(var/a, var/list/L, var/fail_msg=null)
	assertTrue(a in L, (fail_msg ? fail_msg : "expected [a] to be in list (L.len=[L.len])"))

// Set up everything you need for your test here
/datum/test_case/proc/setUp()
	return

// Run the test in here
// A falsy return from this is interpreted as the test passing
/datum/test_case/proc/test()
	return 0
