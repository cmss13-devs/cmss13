/client/proc/run_all_tests()
	set name = "Run All Tests"
	set category = "Debug.Tests"

	if(!check_rights(R_DEBUG))
		return

	var/verbose = (alert("Verbose?",,"Yes","No") == "Yes")

	if(alert("Are you sure?",,"Yes","No") == "No")
		return

	log_admin("[key_name(src)] ran ALL test cases! verbose=[verbose]")
	test_executor.run_all_tests(verbose)

/client/proc/run_test_set()
	set name = "Run Test Set"
	set category = "Debug.Tests"

	if(!check_rights(R_DEBUG))
		return

	var/set_to_run = tgui_input_list(usr, "Select test set","Test",null, test_executor.test_sets)
	if(!set_to_run)
		return
	var/verbose = (alert("Verbose?",,"Yes","No") == "Yes")

	log_admin("[key_name(src)] ran the [set_to_run] test set. verbose=[verbose]")
	var/list/results = test_executor.run_test_set(set_to_run, verbose)

	to_chat(src, "Test results:")
	to_chat(src, "Pass: [results[TEST_PASS]]")
	to_chat(src, "Fail: [results[TEST_FAIL]]")
	to_chat(src, "Error: [results[TEST_ERROR]]")

/client/proc/run_individual_test()
	set name = "Run Test Case"
	set category = "Debug.Tests"

	if(!check_rights(R_DEBUG))
		return

	var/list/all_tests = list()

	for(var/test_set in test_executor.test_sets)
		for(var/datum/test_case/case in test_executor.test_sets[test_set])
			all_tests[case.name] = case

	var/test_name = tgui_input_list(usr, "Select test case","Test", all_tests)
	if(!test_name)
		return
	var/verbose = (alert("Verbose?",,"Yes","No") == "Yes")

	log_admin("[key_name(src)] ran the [test_name] test case.")

	var/datum/test_case/case = all_tests[test_name]
	var/result = test_executor.run_individual_test(case, verbose)
	to_chat(src, "Test result for [test_name]: [test_executor.result_descriptions[result]]")
