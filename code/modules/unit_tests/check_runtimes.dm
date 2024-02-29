/datum/unit_test/check_runtimes
	priority = TEST_LONGER

	///Regex patterns if we must satisfy checks with runtimes present
	var/list/whitelisted_regex = list()

/datum/unit_test/check_runtimes/Run()
	for(var/runtime as anything in GLOB.STUI.runtime)
		if(!is_whitelisted(runtime))
			TEST_FAIL(runtime)

/datum/unit_test/check_runtimes/proc/is_whitelisted(message)
	for(var/pattern as anything in whitelisted_regex)
		var/regex/regex = new(pattern)
		if(regex.Find(message))
			return TRUE
	return FALSE
