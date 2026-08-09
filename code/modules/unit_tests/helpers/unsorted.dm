/datum/to_check

/datum/to_check/proc/operator""()
	return "to_check datum: [type]"

/datum/to_check/child

/datum/to_check/child/grandchild

/datum/to_check/other_child

/datum/to_check_not_matching

/datum/get_matching_paths_test_constants
	VAR_FINAL/alist/typecache = alist(
		/datum/to_check = "parent",
		/datum/to_check/child = "child",
		/datum/to_check/child/grandchild = "grandchild",
		// This should NEVER be returned in matching or highest matching
		/datum/to_check/other_child = "other child"
	)

CONSTANT(get_matching_paths_test_constants, /datum/get_matching_paths_test_constants)

/datum/unit_test/get_matching_paths_TEST_base_type/Run()
	test_get_matching_paths(
		new /datum/to_check(),
		list(/datum/to_check),
		/datum/to_check,
	)

/datum/unit_test/get_matching_paths_TEST_single_nested_type/Run()
	test_get_matching_paths(
		new /datum/to_check/child(),
		list(/datum/to_check, /datum/to_check/child),
		/datum/to_check/child,
	)

/datum/unit_test/get_matching_paths_TEST_double_nested_type/Run()
	test_get_matching_paths(
		new /datum/to_check/child/grandchild(),
		list(/datum/to_check, /datum/to_check/child, /datum/to_check/child/grandchild),
		/datum/to_check/child/grandchild,
	)

/datum/unit_test/get_matching_paths_TEST_non_matching_type/Run()
	test_get_matching_paths(
		new /datum/to_check_not_matching(),
		list(),
		null,
	)

/datum/unit_test/proc/test_get_matching_paths(datum/to_check/to_check, list/expected_matching, expected_highest_matching)
	var/datum/matching_paths/result = get_matching_paths(to_check, get_matching_paths_test_constants.typecache)
	TEST_ASSERT_EQUAL(LAZYLEN(result.matching), LAZYLEN(expected_matching), "get_matching_paths returned an unexpected list of matching paths: to_check=[WRAP_BRACKETS(to_check)]")
	for (var/path in expected_matching)
		TEST_ASSERT(path in result.matching, "Expected [WRAP_BRACKETS(path)] to be in matching paths: to_check=[WRAP_BRACKETS(to_check)]")
	TEST_ASSERT_EQUAL(result.highest_matching, expected_highest_matching, "get_matching_paths returned an unexpected highest matching path: to_check=[WRAP_BRACKETS(to_check)]")
