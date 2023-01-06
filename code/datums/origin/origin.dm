/datum/origin
	var/name = ORIGIN_BASE
	var/desc = "You were born somewhere, someplace. The area is known for doing things, you think."

/datum/origin/proc/generate_human_name(var/gender = MALE)
	return pick(gender == MALE ? first_names_male : first_names_female) + " " + pick(last_names)

/// Return null if the name is correct, otherwise return a string containing the error message
/datum/origin/proc/validate_name(var/name_to_check)
	if(findtext(name_to_check, "A.W. "))
		return "Sorry, you cannot have a name that contains 'A.W.'. Those are reserved for Artificial-Womb origin soldiers."
	return null

/datum/origin/proc/correct_name(var/name_to_check, var/gender = MALE)
	name_to_check = replacetext(name_to_check, "A.W. ", "")
	return name_to_check
