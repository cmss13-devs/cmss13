/* для потомков

GLOBAL_LIST_EMPTY(ru_span_cache)
VAR_PRIVATE/const/MAX_CACHE_SIZE = 100000

// #define RU_SPAN_DEBUG

// str - ключ для поиска в GLOB.ru_span
// list/attr - аргументы для подстановки в строку
// with_span_args - поиск по ru_span_args, иногда полезно
// type - для логов, чтобы понимать откуда вызов
/proc/ru_span(str, list/attr = list(), with_span_args = FALSE, type = "")
	if (!str || !length(str))
		return

	#ifdef RU_SPAN_DEBUG
	var/log_file = file("[GLOB.log_directory]/RU_SPANS.log")
	log_file << "=== RU_SPAN CALL ==="
	log_file << "Type: [type], Original: [str]"
	log_file << "Args: [json_encode(attr)]"
	#endif

	var/translated_str = GLOB.ru_span[str]
	if(isnull(translated_str))
		#ifdef RU_SPAN_DEBUG
		log_file << "НЕТ ПЕРЕВОДА! [type] = [str]"
		#endif
		translated_str = str

	if(!length(attr))
		return translated_str

	var/cache_key = generate_cache_key(translated_str, with_span_args, attr)
	if(!isnull(GLOB.ru_span_cache[cache_key]))
		#ifdef RU_SPAN_DEBUG
		log_file << "HIT cache: [cache_key] = [str]"
		#endif
		return GLOB.ru_span_cache[cache_key][1]


	var/substitutions = create_substitution_map(attr, with_span_args, type, str)
	#ifdef RU_SPAN_DEBUG
	log_file << "substitutions: [json_encode(substitutions)]"
	#endif
	translated_str = replace_all_substitutions(translated_str, substitutions)

	manage_cache_size()

	GLOB.ru_span_cache[cache_key] = list(translated_str, world.time)

	return translated_str

/proc/create_substitution_map(list/attr, with_span_args, type, original_str)
	var/list/substitutions = list()
	var/current_index = 1

	for(var/i in 1 to length(attr))
		var/processed_value = process_argument(attr[i], with_span_args, type, original_str)

		if(islist(processed_value))
			for(var/j in 1 to length(processed_value))
				substitutions["$[current_index]"] = processed_value[j]
				current_index++
		else
			substitutions["$[current_index]"] = processed_value
			current_index++

	return substitutions

/proc/process_argument(arg_value, with_span_args, type, original_str)
	if(!with_span_args || isnum(arg_value) || !length(GLOB.ru_span_args))
		return arg_value

	if(islist(arg_value))
		return translate_list(arg_value, type, original_str)

	return GLOB.ru_span_args[arg_value] || arg_value

/proc/replace_all_substitutions(text, list/substitutions)
	var/sorted_keys = sortTim(substitutions, /proc/cmp_key_length_desc)

	for(var/key in sorted_keys)
		text = replacetext(text, key, substitutions[key])

	return text

/proc/cmp_key_length_desc(key1, key2)
	return length(key2) - length(key1)

/proc/generate_cache_key(str, with_span_args, list/attr)
	var/cache_key = "[str]|[with_span_args]|#[length(attr)]"

	for(var/i in 1 to length(attr))
		var/arg_value = attr[i]
		if(islist(arg_value))
			cache_key += "|L#[length(arg_value)]"
			for(var/item in arg_value)
				cache_key += "|[item]"
		else
			cache_key += "|[arg_value]"
	return md5(cache_key)

/proc/translate_list(list/input_list, type, original_str)
	if(!input_list || !length(input_list))
		return list()

	var/list/translated_list = list()
	for(var/item in input_list)
		var/translated_item = GLOB.ru_span_args[item] || item
		translated_list += translated_item

	return translated_list

/proc/manage_cache_size()
	var/current_cache_length = length(GLOB.ru_span_cache)
	#ifdef RU_SPAN_DEBUG
	var/log_file = file("[GLOB.log_directory]/RU_SPANS.log")
	log_file << "Current cache size: [current_cache_length]"
	#endif

	if(current_cache_length >= MAX_CACHE_SIZE)
		#ifdef RU_SPAN_DEBUG
		log_file << "Cleaning cache: [current_cache_length] entries"
		#endif

		var/sorted_keys = sortTim(GLOB.ru_span_cache, /proc/cmp_cache_time)
		var/keys_to_remove = min(25000, length(sorted_keys))

		for(var/i = 1 to keys_to_remove)
			GLOB.ru_span_cache.Remove(sorted_keys[i])

		#ifdef RU_SPAN_DEBUG
		log_file << "Removed [keys_to_remove] entries, new size: [length(GLOB.ru_span_cache)]"
		#endif

/proc/cmp_cache_time(key1, key2)
    return GLOB.ru_span_cache[key1][2] - GLOB.ru_span_cache[key2][2]

/proc/span_english_list(list/input, nothing_text = "ничего", or_text = " или ", comma_text = ", ", final_comma_text = "")
	var/total = length(input)
	switch(total)
		if(0)
			return "[nothing_text]"
		if(1)
			return "[input[1]]"
		if(2)
			return "[input[1]][or_text][input[2]]"
		else
			var/output = ""
			for(var/i = 1 to total - 1)
				output += "[input[i]][i == total - 1 ? final_comma_text : comma_text]"
			return "[output][or_text][input[total]]"
*/
