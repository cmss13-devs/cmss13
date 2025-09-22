/datum/reagent
	/// List consists of ("name", "именительный", "родительный", "дательный", "винительный", "творительный", "предложный", "gender")
	var/list/ru_names

/datum/reagent/New()
	. = ..()
	name = capitalize(update_to_ru(ru_reagent_names_toml(name), name))

/datum/reagent/proc/ru_reagent_names_toml(name, prefix, suffix, override_base)
	var/formatted_name = format_text(name)
	if(isnull(GLOB.ru_reagent_names))
		return list()

	if(!length(GLOB.ru_reagent_names))
		var/reagents_path = "[PATH_TO_TRANSLATE_DATA]/ru_reagents.toml"
		if(!length(reagents_path) || !fexists(file(reagents_path)))
			return list()
		var/list/file_data = rustg_read_toml_file(reagents_path)
		for(var/key in file_data)
			if(GLOB.ru_reagent_names[key])
				continue
			GLOB.ru_reagent_names[key] = file_data[key]
	if(GLOB.ru_reagent_names[formatted_name])
		var/list/entry = GLOB.ru_reagent_names[formatted_name]

		var/base = override_base || "[prefix][name][suffix]"
		var/nominative_form = entry["nominative"] || name
		var/genitive_form = entry["genitive"] || nominative_form
		var/dative_form = entry["dative"] || nominative_form
		var/accusative_form = entry["accusative"] || nominative_form
		var/instrumental_form = entry["instrumental"] || nominative_form
		var/prepositional_form = entry["prepositional"] || nominative_form

		return list(
			"base" = base,
			NOMINATIVE = "[prefix][nominative_form][suffix]",
			GENITIVE = "[prefix][genitive_form][suffix]",
			DATIVE = "[prefix][dative_form][suffix]",
			ACCUSATIVE = "[prefix][accusative_form][suffix]",
			INSTRUMENTAL = "[prefix][instrumental_form][suffix]",
			PREPOSITIONAL = "[prefix][prepositional_form][suffix]",
		)

/datum/reagent/proc/update_to_ru(list/new_list, backup_value)
	if(!length(new_list))
		ru_names = null
		return backup_value
	ru_names = new_list
	return ru_names[NOMINATIVE]

/datum/reagent/proc/declent_reagent_ru(declent = NOMINATIVE)
	if(!length(ru_names) || ru_names["base"] != name)
		return name
	return ru_names[declent] || ru_names[NOMINATIVE] || name

/datum/reagent/proc/declent_reagent_ru_from_obj(datum/reagent/reagent, declent = NOMINATIVE, backup_value)
	if(!reagent?.ru_names || !length(reagent.ru_names))
		return backup_value

	return reagent.ru_names[declent] || reagent.ru_names[NOMINATIVE] || backup_value
