/datum/test_case/framework/error
	name = "Error test"

// The test should cause a runtime error
// Do it by attempting to index null
/datum/test_case/framework/error/test()
	var/list/test_list = null
	test_list["bad_key"] = "error"
