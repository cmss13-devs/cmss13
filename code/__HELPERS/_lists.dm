/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]
/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]

/****
	* Binary search sorted insert
	* INPUT: Object to be inserted
	* LIST: List to insert object into
	* TYPECONT: The typepath of the contents of the list
	* COMPARE: The object to compare against, usualy the same as INPUT
	* COMPARISON: The variable on the objects to compare
	* COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
	*/
#define BINARY_INSERT(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON <= COMPARE.##COMPARISON) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON > COMPARE.##COMPARISON ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

// binary search sorted insert
// IN: Object to be inserted
// LIST: List to insert object into
#define BINARY_INSERT_NUM(IN, LIST) \
	var/__BIN_CTTL = length(LIST);\
	if(!__BIN_CTTL) {\
		LIST += IN;\
	} else {\
		var/__BIN_LEFT = 1;\
		var/__BIN_RIGHT = __BIN_CTTL;\
		var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
		var/__BIN_ITEM;\
		while(__BIN_LEFT < __BIN_RIGHT) {\
			__BIN_ITEM = LIST[__BIN_MID];\
			if(__BIN_ITEM <= IN) {\
				__BIN_LEFT = __BIN_MID + 1;\
			} else {\
				__BIN_RIGHT = __BIN_MID;\
			};\
			__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
		};\
		__BIN_ITEM = LIST[__BIN_MID];\
		__BIN_MID = __BIN_ITEM > IN ? __BIN_MID : __BIN_MID + 1;\
		LIST.Insert(__BIN_MID, IN);\
	}

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L[T] = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L[P] = TRUE
				else
					for(var/T in typesof(P))
						L[T] = TRUE
		return L

//Return either pick(list) or null if list is not of type /list or is empty
#define SAFEPICK(L) (length(L) ? pick(L) : null)

///sort any value in a list
/proc/sort_list(list/list_to_sort, cmp=/proc/cmp_text_asc)
	return sortTim(list_to_sort.Copy(), cmp)

///Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield_to_list(bitfield = 0, list/wordlist)
	var/list/return_list = list()
	if(islist(wordlist))
		var/max = min(length(wordlist), 24)
		var/bit = 1
		for(var/i in 1 to max)
			if(bitfield & bit)
				return_list += wordlist[i]
			bit = bit << 1
	else
		for(var/bit_number = 0 to 23)
			var/bit = 1 << bit_number
			if(bitfield & bit)
				return_list += bit

	return return_list

/**
 * Picks a random element from a list based on a weighting system.
 * For example, given the following list:
 * A = 6, B = 3, C = 1, D = 0
 * A would have a 60% chance of being picked,
 * B would have a 30% chance of being picked,
 * C would have a 10% chance of being picked,
 * and D would have a 0% chance of being picked.
 * You should only pass integers in.
 */
/proc/pick_weight(list/list_to_pick)
	if(length(list_to_pick) == 0)
		return null

	var/total = 0
	for(var/item in list_to_pick)
		if(!list_to_pick[item])
			list_to_pick[item] = 0
		total += list_to_pick[item]

	total = rand(1, total)
	for(var/item in list_to_pick)
		var/item_weight = list_to_pick[item]
		if(item_weight == 0)
			continue

		total -= item_weight
		if(total <= 0)
			return item

	return null

/**
 * Removes any null entries from the list
 * Returns TRUE if the list had nulls, FALSE otherwise
**/
/proc/list_clear_nulls(list/list_to_clear)
	var/start_len = length(list_to_clear)
	var/list/new_list = new(start_len)
	list_to_clear -= new_list
	return length(list_to_clear) < start_len

///Return a list with no duplicate entries
/proc/unique_list(list/inserted_list)
	. = list()
	for(var/i in inserted_list)
		. |= i

///same as unique_list, but returns nothing and acts on list in place (also handles associated values properly)
/proc/unique_list_in_place(list/inserted_list)
	var/temp = inserted_list.Copy()
	inserted_list.len = 0
	for(var/key in temp)
		if (isnum(key))
			inserted_list |= key
		else
			inserted_list[key] = temp[key]

///same as shuffle, but returns nothing and acts on list in place
/proc/shuffle_inplace(list/inserted_list)
	if(!inserted_list)
		return

	for(var/i in 1 to length(inserted_list) - 1)
		inserted_list.Swap(i, rand(i, length(inserted_list)))

/**
 * Attempts to convert a numeric keyed alist of (2=second, 1=first) to a list of (first, second).
 *
 * If you instead want to discard values and keep only keys, just do list + alist.
 *
 * Arguments:
 * * to_flatten - The alist with sequential numeric keys to extract values from into a normal list.
 * * assert - Whether to assert every key is numeric and in bounds.
 */
/proc/flatten_numeric_alist(alist/to_flatten, assert=TRUE)
	RETURN_TYPE(/list)

	var/count = length(to_flatten)
	if(assert)
		for(var/key in to_flatten)
			if(!isnum(key) || key < 1 || key > count)
				CRASH("flatten_numeric_alist not possible for alist: [json_encode(to_flatten)]")

	var/list/retval = list()
	for(var/i in 1 to count)
		retval += to_flatten[i]
	return retval

/proc/list_all(list/to_check, datum/callback/element_check_callback)
	ASSERT(islist(to_check), "Can only pass a list to check all elements")
	for (var/element in to_check)
		if (!element_check_callback.Invoke(element))
			return FALSE
	return TRUE

/proc/add_lua_return_value_variants(list/values, list/variants)
	if(!islist(values) || !islist(variants))
		return
	if(values.len != variants.len)
		CRASH("values and variants must be the same length")
	for(var/i in 1 to values.len)
		var/value = values[i]
		if(islist(value))
			add_lua_editor_variants(value, variants[i])
		else if(isdatum(value) || value == world || ref(value) == "\[0xe000001\]")
			variants[i] = list("ref", ref(value))

/**
 * Given a list and a list of its variant hints, appends variants that aren't explicitly required by dreamluau,
 * but are required by the lua editor tgui.
 */
/proc/add_lua_editor_variants(list/values, list/variants, list/visited, path = "")
	if(!islist(visited))
		visited = list()
		visited[values] = "\[\]"
	if(!islist(values) || !islist(variants))
		return
	if(values.len != variants.len)
		CRASH("values and variants must be the same length")
	for(var/i in 1 to variants.len)
		var/pair = variants[i]
		var/pair_modified = FALSE
		if(isnull(pair))
			pair = list("key", "value")
		var/key = values[i]
		if(islist(key))
			if(visited[key])
				pair["key"] = list("cycle", visited[key])
			else
				var/list/key_variants = pair["key"]
				var/new_path = path + "\[[i], \"key\"\],"
				visited[key] = new_path
				add_lua_editor_variants(key, key_variants, visited, new_path)
				visited -= key
				pair["key"] = list("list", key_variants)
			pair_modified = TRUE
		else if(isdatum(key) || key == world || ref(key) == "\[0xe000001\]")
			pair["key"] = list("ref", ref(key))
			pair_modified = TRUE
		var/value
		if(!isnull(key) && !isnum(key))
			value = values[key]
		if(islist(value))
			if(visited[value])
				pair["value"] = list("cycle", visited[value])
			else
				var/list/value_variants = pair["value"]
				var/new_path = path + "\[[i], \"value\"\],"
				visited[value] = new_path
				add_lua_editor_variants(value, value_variants, visited, new_path)
				visited -= value
				pair["value"] = list("list", value_variants)
			pair_modified = TRUE
		else if(isdatum(value) || value == world || ref(value) == "\[0xe000001\]")
			pair["value"] = list("ref", ref(value))
			pair_modified = TRUE
		if(pair_modified && pair != variants[i])
			variants[i] = pair
		if(i < variants.len)
			CHECK_TICK

/// Returns a copy of the list where any element that is a datum is converted into a weakref
/proc/weakrefify_list(list/target_list, list/visited)
	if(!visited)
		visited = list()
	var/list/ret = list()
	visited[target_list] = ret
	for(var/i in 1 to target_list.len)
		var/key = target_list[i]
		var/new_key = key
		if(isdatum(key))
			new_key = WEAKREF(key)
		else if(islist(key))
			if(visited.Find(key))
				new_key = visited[key]
			else
				new_key = weakrefify_list(key, visited)
		var/value
		if(!isnull(key) && !isnum(key))
			value = target_list[key]
		if(isdatum(value))
			value = WEAKREF(value)
		else if(islist(value))
			if(visited[value])
				value = visited[value]
			else
				value = weakrefify_list(value, visited)
		var/list/to_add = list(new_key)
		if(!isnull(value))
			to_add[new_key] = value
		ret += to_add
		if(i < target_list.len)
			CHECK_TICK
	return ret

/// Compares 2 lists, returns TRUE if they are the same
/proc/deep_compare_list(list/list_1, list/list_2)
	if(list_1 == list_2)
		return TRUE

	if(!islist(list_1) || !islist(list_2))
		return FALSE

	if(list_1.len != list_2.len)
		return FALSE

	for(var/i in 1 to list_1.len)
		var/key_1 = list_1[i]
		var/key_2 = list_2[i]
		if (islist(key_1) && islist(key_2))
			if(!deep_compare_list(key_1, key_2))
				return FALSE
		else if(key_1 != key_2)
			return FALSE
		if(istext(key_1) || islist(key_1) || ispath(key_1) || isdatum(key_1) || key_1 == world)
			var/value_1 = list_1[key_1]
			var/value_2 = list_2[key_1]
			if (islist(value_1) && islist(value_2))
				if(!deep_compare_list(value_1, value_2))
					return FALSE
			else if(value_1 != value_2)
				return FALSE
	return TRUE

///Returns a list with all weakrefs resolved
/proc/recursive_list_resolve(list/list_to_resolve)
	. = list()
	for(var/element in list_to_resolve)
		if(istext(element))
			. += element
			var/possible_assoc_value = list_to_resolve[element]
			if(possible_assoc_value)
				.[element] = recursive_list_resolve_element(possible_assoc_value)
		else
			. += list(recursive_list_resolve_element(element))

///Helper for recursive_list_resolve()
/proc/recursive_list_resolve_element(element)
	if(islist(element))
		var/list/inner_list = element
		return recursive_list_resolve(inner_list)
	else if(isweakref(element))
		var/datum/weakref/ref = element
		return ref.resolve()
	else
		return element


/proc/compare_lua_logs(list/log_1, list/log_2)
	if(log_1 == log_2)
		return TRUE
	for(var/field in list("status", "name", "message", "chunk"))
		if(log_1[field] != log_2[field])
			return FALSE
	switch(log_1["status"])
		if("finished", "yield")
			return deep_compare_list(
					recursive_list_resolve(log_1["return_values"]),
					recursive_list_resolve(log_2["return_values"])
					) && deep_compare_list(log_1["variants"], log_2["variants"])
		if("runtime")
			return log_1["file"] == log_2["file"]\
				&& log_1["line"] == log_2["line"]\
				&& deep_compare_list(log_1["stack"], log_2["stack"])
		else
			return TRUE

/**
 * Given a list and a list of its variant hints, removes any list key/values that are represent lua values that could not be directly converted to DM.
 */
/proc/remove_non_dm_variants(list/return_values, list/variants, list/visited)
	if(!islist(visited))
		visited = list()
	if(!islist(return_values) || !islist(variants) || visited[return_values])
		return
	visited[return_values] = TRUE
	if(return_values.len != variants.len)
		CRASH("return_values and variants must be the same length")
	for(var/i in 1 to variants.len)
		var/pair = variants[i]
		if(!islist(variants))
			continue
		var/key = return_values[i]
		if(pair["key"])
			if(!islist(pair["key"]))
				return_values[i] = null
				continue
			remove_non_dm_variants(key, pair["key"], visited)
		if(pair["value"])
			if(!islist(pair["value"]))
				return_values[key] = null
				continue
			remove_non_dm_variants(return_values[key], pair["value"], visited)

/**
 * Converts a list into a list of assoc lists of the form ("key" = key, "value" = value)
 * so that list keys that are themselves lists can be fully json-encoded
 * and that unique objects with the same string representation do not
 * produce duplicate keys that are clobbered by the standard JavaScript JSON.parse function
 */
/proc/kvpify_list(list/target_list, depth = INFINITY, list/visited)
	if(!visited)
		visited = list()
	var/list/ret = list()
	visited[target_list] = ret
	for(var/i in 1 to target_list.len)
		var/key = target_list[i]
		var/new_key = key
		if(islist(key) && depth)
			if(visited[key])
				new_key = visited[key]
			else
				new_key = kvpify_list(key, depth-1, visited)
		var/value
		if(!isnull(key) && !isnum(key))
			value = target_list[key]
		if(islist(value) && depth)
			if(visited[value])
				value = visited[value]
			else
				value = kvpify_list(value, depth-1, visited)
		if(!isnull(value))
			ret += list(list("key" = new_key, "value" = value))
		else
			ret += list(list("key" = i, "value" = new_key))
		if(i < target_list.len)
			CHECK_TICK
	return ret

/**
 * Intermediate step for preparing lists to be passed into the lua editor tgui.
 * Resolves weakrefs, converts some values without a standard textual representation to text,
 * and can handle self-referential lists and potential duplicate output keys.
 */
/proc/prepare_lua_editor_list(list/target_list, list/visited)
	if(!visited)
		visited = list()
	var/list/ret = list()
	visited[target_list] = ret
	var/list/duplicate_keys = list()
	for(var/i in 1 to target_list.len)
		var/key = target_list[i]
		var/new_key = key
		if(isweakref(key))
			var/datum/weakref/ref = key
			new_key = ref.resolve() || "null weakref"
		else if(key == world)
			new_key = world.name
		else if(ref(key) == "\[0xe000001\]")
			new_key = "global"
		else if(islist(key))
			if(visited[key])
				new_key = visited[key]
			else
				new_key = prepare_lua_editor_list(key, visited)
		var/value
		if(!isnull(key) && !isnum(key))
			value = target_list[key]
		if(isweakref(value))
			var/datum/weakref/ref = value
			value = ref.resolve() || "null weakref"
		if(value == world)
			value = "world"
		else if(ref(value) == "\[0xe000001\]")
			value = "global"
		else if(islist(value))
			if(visited[value])
				value = visited[value]
			else
				value = prepare_lua_editor_list(value, visited)
		var/list/to_add = list()
		if(!isnull(value))
			var/final_key = new_key
			while(duplicate_keys[final_key])
				duplicate_keys[new_key]++
				final_key = "[new_key] ([duplicate_keys[new_key]])"
			duplicate_keys[final_key] = 1
			to_add[final_key] = value
		else
			to_add += list(new_key)
		ret += to_add
		if(i < target_list.len)
			CHECK_TICK
	return ret

/proc/deep_copy_without_cycles(list/values, list/visited)
	if(!islist(visited))
		visited = list()
	if(!islist(values))
		return values
	var/list/ret = list()
	var/cycle_count = 0
	visited[values] = TRUE
	for(var/i in 1 to values.len)
		var/key = values[i]
		var/out_key = key
		if(islist(key))
			if(visited[key])
				do
					out_key = "\[cyclical reference[cycle_count ? " (i)" : ""]\]"
					cycle_count++
				while(values.Find(out_key))
			else
				visited[key] = TRUE
				out_key = deep_copy_without_cycles(key, visited)
				visited -= key
		var/value
		if(!isnull(key) && !isnum(key))
			value = values[key]
		var/out_value = value
		if(islist(value))
			if(visited[value])
				out_value = "\[cyclical reference\]"
			else
				visited[value] = TRUE
				out_value = deep_copy_without_cycles(value, visited)
				visited -= value
		var/list/to_add = list(out_key)
		if(!isnull(out_value))
			to_add[out_key] = out_value
		ret += to_add
		if(i < values.len)
			CHECK_TICK
	return ret
