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
		if(!GLOB.gear_datums_by_name[gear_option])
			continue

		var/datum/gear/gear_datum = GLOB.gear_datums_by_name[gear_option]
		var/new_total = running_cost + gear_datum.cost

		if(new_total > MAX_GEAR_COST)
			to_chat(user, SPAN_WARNING("Your [gear_option] was removed from your loadout as it exceeded the point limit."))
			continue

		running_cost = new_total
		sanitized_gear += gear_option

	return sanitized_gear
