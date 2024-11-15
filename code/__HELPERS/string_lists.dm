GLOBAL_LIST_EMPTY(string_lists)

/**
 * Caches lists with non-numeric stringify-able values (text or typepath).
 */
/proc/string_list(list/values)
	var/string_id = values.Join("-")

	. = GLOB.string_lists[string_id]

	if(.)
		return .

	return GLOB.string_lists[string_id] = values

///A wrapper for baseturf string lists, to offer support of non list values, and a stack_trace if we have major issues
/proc/baseturfs_string_list(list/values, turf/baseturf_holder)
	if(!islist(values))
		return values //baseturf things
	// return values
	if(length(values) > 10)
		return string_list(list(/turf/closed/cordon/debug))
	return string_list(values)
