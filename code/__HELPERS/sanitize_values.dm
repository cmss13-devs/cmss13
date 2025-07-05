//general stuff
/proc/sanitize_integer(number, min=0, max=1, default=0)
	if(isnum(number))
		number = floor(number)
		if(min <= number && number <= max)
			return number
	return default

/proc/sanitize_float(number, min = 0, max = 1, default = 0)
	if(isnum(number))
		if(min <= number && number <= max)
			return number
	return default

/proc/sanitize_text(text, default="")
	if(istext(text))
		return text
	return default

/proc/sanitize_islist(value, default)
	if(islist(value) && length(value))
		return value
	if(default)
		return default

/proc/sanitize_inlist(value, list/List, default)
	if(value in List)
		return value
	if(default)
		return default
	if(LAZYLEN(List))return List[1]

/proc/sanitize_list(list/List, list/filter = list(null), default = list())
	if(!islist(List))
		return default
	if(!islist(filter))
		return List
	. = list()
	for(var/E in List)
		if(E in filter)
			continue
		. += E

//more specialised stuff
/proc/sanitize_gender(gender,neuter=0,plural=0, default="male")
	switch(gender)
		if(MALE, FEMALE)return gender
		if(NEUTER)
			if(neuter)
				return gender
			else
				return default
		if(PLURAL)
			if(plural)
				return gender
			else
				return default
	return default

/proc/sanitize_skin_color(skin_color, default = "Pale 2")
	if(skin_color in GLOB.skin_color_list)
		return skin_color

	return default

/proc/sanitize_body_type(body_type, default = "Lean")
	if(body_type in GLOB.body_type_list)
		return body_type

	return default

/proc/sanitize_body_size(body_size, default = "Average")
	if(body_size in GLOB.body_size_list)
		return body_size

	return default

/proc/sanitize_hexcolor(color, default="#000000")
	if(!istext(color))
		return default
	var/len = length(color)
	if(len != 7 && len !=4)
		return default
	if(text2ascii(color,1) != 35)
		return default //35 is the ascii code for "#"
	. = "#"
	for(var/i=2,i<=len,i++)
		var/ascii = text2ascii(color,i)
		switch(ascii)
			if(48 to 57) . += ascii2text(ascii) //numbers 0 to 9
			if(97 to 102) . += ascii2text(ascii) //letters a to f
			if(65 to 70) . += ascii2text(ascii+32) //letters A to F - translates to lowercase
			else
				return default
	return .

/proc/sanitize_gear(list/gear, client/user)
	var/list/sanitized_gear = list()
	var/running_cost = 0

	for(var/gear_option in gear)
		var/gear_type = text2path(gear_option)
		if(!gear_type)
			var/datum/gear/attempted_gear = GLOB.gear_datums_by_name[gear_option]
			if(!attempted_gear)
				to_chat(user, SPAN_WARNING("Your [gear_option] was removed from your cosmetic gear as it is no longer a valid gear option."))
				continue
			gear_type = attempted_gear.type
		if(!GLOB.gear_datums_by_type[gear_type])
			to_chat(user, SPAN_WARNING("Your [gear_option] was removed from your cosmetic gear as it is no longer a valid gear option."))
			continue

		var/datum/gear/gear_datum = GLOB.gear_datums_by_type[gear_type]
		var/new_total = running_cost + gear_datum.fluff_cost

		if(new_total > MAX_GEAR_COST)
			to_chat(user, SPAN_WARNING("Your [gear_datum.display_name] was removed from your cosmetic gear as it exceeded the point limit."))
			continue

		running_cost = new_total
		sanitized_gear += gear_type

	return sanitized_gear

/proc/save_gear(gear)
	var/string_list = list()

	for(var/gear_type in gear)
		string_list += "[gear_type]"

	return string_list

/// Ensures that our job loadout is an associated list of role path -> list of slots -> list of gear
/proc/sanitize_loadout(list/list/loadout, client/user)
	var/sanitized_loadout = list()

	for(var/job in loadout)
		var/datum/job/job_datum = GLOB.RoleAuthority.roles_by_name[job]
		if(!job_datum)
			continue

		var/sanitized_slots = list()

		for(var/slot in loadout[job])
			if(!slot)
				continue

			var/running_total = 0
			var/sanitized_job_gear = list()

			for(var/gear_entry in loadout[job][slot])
				var/gear_type = text2path(gear_entry)
				if(!gear_type)
					to_chat(user, SPAN_WARNING("Your [gear_entry] was removed from your loadout as it is no longer a valid job loadout option."))
					continue

				var/datum/gear/gear_datum = GLOB.gear_datums_by_type[gear_type]
				if(!gear_datum)
					to_chat(user, SPAN_WARNING("Your [gear_entry] was removed from your loadout as it is no longer a valid job loadout option."))
					continue

				var/new_total = running_total + gear_datum.loadout_cost

				if(new_total > job_datum.loadout_points)
					to_chat(user, SPAN_WARNING("Your [gear_datum.display_name] was removed from your loadout as it exceeded the point limit for [job_datum.title]."))
					continue

				running_total = new_total
				sanitized_job_gear += gear_type

			sanitized_slots[slot] = sanitized_job_gear

		sanitized_loadout[job] = sanitized_slots

	return sanitized_loadout

/proc/save_loadout(loadout)
	var/string_list = list()

	for(var/job in loadout)
		if(!loadout[job])
			continue

		string_list[job] = list()

		for(var/slot in loadout[job])
			if(!length(loadout[job][slot]))
				continue

			string_list[job][slot] = save_gear(loadout[job][slot])

	return string_list
