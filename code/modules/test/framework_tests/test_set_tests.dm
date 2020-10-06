// Yup. We're testing the test framework with itself
// Note that this test set isn't included in the DME
// This is because it will produce 1 fail and 1 error when it "succeeds"
// Which can muddy up the test results as a whole
/datum/test_case/framework
	test_set = "Test framework tests"
