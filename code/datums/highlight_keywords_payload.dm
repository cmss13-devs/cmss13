// Unlikely to come up in normal gameplay.
#define EMPTY_VALUE null

// Make sure to update `KeywordMenu` in TextHighlight.tsx to show users what
// keywords they can use.
/datum/highlight_keywords_payload
	var/name_full = EMPTY_VALUE
	var/name_first = EMPTY_VALUE
	var/name_middle = EMPTY_VALUE
	var/name_last = EMPTY_VALUE
	var/job_full = EMPTY_VALUE
	var/job_comm_title = EMPTY_VALUE
	var/xeno_prefix = EMPTY_VALUE
	var/xeno_number = EMPTY_VALUE
	var/xeno_postfix = EMPTY_VALUE

/datum/highlight_keywords_payload/New(mob/mob)
	..()

	name_full = mob.real_name
	job_full = mob.get_role_name()

	if(ishuman(mob))
		var/first_name_end = findtext(name_full, " ")
		name_first = copytext(name_full, 1, first_name_end)

		var/last_name_start = findlasttext(name_full, " ")
		if (last_name_start != 0)
			name_last = copytext(name_full, last_name_start)
			// If there is more than one space in the name, this triggers.
			// Note that this will contains everything between the first and
			// last names, so names like "John von Neumann" will trigger it.
			if (first_name_end != last_name_start)
				name_middle = copytext(name_full, first_name_end, last_name_start)

		// If this is called before the human is *equipped* it will be null.
		job_comm_title = mob.comm_title
	else if(isxeno(mob))
		// This is a more involved way of extracting the xeno's information,
		// compared to checking the user's settings, but this works if they
		// have changed their settings or are playing a different xeno.
		var/dynamic_name_start = findlasttext(name_full, "(")
		var/dynamic_name_end = findlasttext(name_full, ")")
		// Get the "XX-123-YY" part of "Forsaken Prime Runner (XX-123-YY)".
		var/dynamic_name = copytext(name_full, dynamic_name_start + 1, dynamic_name_end)
		var/list/name_components = splittext(dynamic_name, "-")

		switch(length(name_components))
			if(1)
				var/first_component = name_components[1]

				var/mob/living/carbon/xenomorph/xeno = mob
				var/nicknumber = num2text(xeno.nicknumber)

				if (first_component == nicknumber)
					xeno_number = first_component
				else
					xeno_prefix = first_component
			// "Normal" xeno name patterns.
			if(2)
				var/first_component = name_components[1]
				var/second_component = name_components[2]

				var/mob/living/carbon/xenomorph/xeno = mob
				var/nicknumber = num2text(xeno.nicknumber)

				// 123-XX
				if (first_component == nicknumber)
					xeno_number = first_component
					xeno_postfix = second_component
				// XX-123
				else if (second_component == nicknumber)
					xeno_prefix = first_component
					xeno_number = second_component
				// XX-YY
				else
					xeno_prefix = first_component
					xeno_postfix = second_component
			// XX-123-YY
			if (3)
				xeno_prefix = name_components[1]
				xeno_number = name_components[2]
				xeno_postfix = name_components[3]


/datum/highlight_keywords_payload/proc/to_list()
	return list(
		// Includes '' surrounding nickname.
		fullName = name_full,
		firstName = format_field(name_first),
		middleName = format_field(name_middle),
		lastName = format_field(name_last),
		fullJob = format_field(job_full),
		jobCommTitle = format_field(job_comm_title),
		xenoPrefix = format_field(xeno_prefix),
		xenoNumber = format_field(xeno_number),
		xenoPostfix = format_field(xeno_postfix)
	)

/proc/format_field(input)
	for (var/bad_char in list("'", "\"", "$"))
		input = replacetext(trim_right(trim_left(input)), bad_char, "")
	return input
