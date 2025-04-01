/datum/unit_test/tutorials

/datum/unit_test/tutorials/Run()
	var/datum/tutorial/base_path = /datum/tutorial
	for(var/datum/tutorial/tutorial_path as anything in subtypesof(base_path))
		if(initial(tutorial_path.parent_path) == tutorial_path)
			continue

		// Make sure these variables are overridden on any subtypes.
		TEST_ASSERT_NOTEQUAL(initial(tutorial_path.name), initial(base_path.name),
			"[tutorial_path] does not have a name set.")
		TEST_ASSERT_NOTEQUAL(initial(tutorial_path.tutorial_id), initial(base_path.tutorial_id),
			"[tutorial_path] does not have a tutorial_id set.")
		TEST_ASSERT_NOTEQUAL(initial(tutorial_path.desc), initial(base_path.desc),
			"[tutorial_path] does not have a desc set.")
		TEST_ASSERT_NOTEQUAL(initial(tutorial_path.icon_state), initial(base_path.icon_state),
			"[tutorial_path] does not have an icon_state set.")

// TODO: Add a test verifying that a basic tutorial can be started and completed. (Requires unit test client handling)
