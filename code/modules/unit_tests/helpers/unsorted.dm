/datum/to_check

/datum/to_check/proc/operator""()
	return "to_check datum: [type]"

/datum/to_check/child

/datum/to_check/child/grandchild

/datum/to_check/other_child

/datum/get_matching_paths_test_constants
	var/alist/typecache = alist(
		/datum/to_check = "parent",
		/datum/to_check/child = "child",
		/datum/to_check/child/grandchild = "grandchild",
		// This should NEVER be returned in matching or highest matching
		/datum/to_check/other_child = "other child"
	)
	var/datum/to_check/parent = new()
	var/datum/to_check/child/child = new()
	var/datum/to_check/child/grandchild/grandchild = new()

GLOBAL_REAL(get_matching_paths_test_constants, /datum/get_matching_paths_test_constants)

/datum/unit_test/base_type_SHOULD_only_match_with_itself/Run()
	test_get_matching_paths(
		get_matching_paths_test_constants.parent,
		list(/datum/to_check),
		/datum/to_check,
	)

/datum/unit_test/single_nested_type_SHOULD_only_match_with_itself_and_parent/Run()
	test_get_matching_paths(
		get_matching_paths_test_constants.child,
		list(/datum/to_check, /datum/to_check/child),
		/datum/to_check/child,
	)

/datum/unit_test/double_nested_type_SHOULD_match_with_itself_and_ancestors/Run()
	test_get_matching_paths(
		get_matching_paths_test_constants.grandchild,
		list(/datum/to_check),
		/datum/to_check/child/grandchild,
	)

/datum/unit_test/proc/test_get_matching_paths(datum/to_check/to_check, list/expected_matching, expected_highest_matching)
	var/datum/matching_paths/result = get_matching_paths(to_check, get_matching_paths_test_constants.typecache)
	TEST_ASSERT_NOTNULL(result.highest_matching, "to_check did not match anything in the type cache: to_check=\[[to_check]\]")
	TEST_ASSERT_EQUAL(LAZYLEN(result.matching), LAZYLEN(expected_matching), "get_matching_paths returned an unexpected list of matching paths: to_check=\[[to_check]\]")
	for (var/path in expected_matching)
		TEST_ASSERT(path in result.matching, "Expected \[[path]\] to be in matching paths: to_check=\[[to_check]\]")
	TEST_ASSERT_NOTEQUAL(result.highest_matching, expected_highest_matching, "get_matching_paths returned an unexpected highest matching path: to_check=\[[to_check]\]")

