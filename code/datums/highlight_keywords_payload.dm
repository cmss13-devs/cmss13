// Unlikely to come up in normal gameplay.
#define EMPTY_VALUE ".EMPTY."

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
	job_comm_title = mob.comm_title

	if(ishuman(mob))
		var/first_name_end = findtext(name_full, " ")
		name_first = copytext(name_full, 1, first_name_end)

		var/last_name_start = findlasttext(name_full, " ")
		if (last_name_start != 0)
			name_last = copytext(name_full, last_name_start + 1)
			// If there is more than one space in the name, this triggers.
			// Note that this will contains everything between the first and
			// last names.
			if (first_name_end != last_name_start)
				name_middle = copytext(name_full, first_name_end, last_name_start)
	else if(isxeno(mob))
		var/dynamic_name_start = findlasttext(name_full, "(")
		var/dynamic_name_end = findlasttext(name_full, ")")
		// Get the "XX-123-YY" part of "Forsaken Prime Runner (XX-123-YY)".
		var/dynamic_name = copytext(name_full, dynamic_name_start + 1, dynamic_name_end)
		var/list/name_components = splittext(dynamic_name, "-")

		// "Normal" xeno name patterns.
		if(name_components.len == 2) {
			var/mob/living/carbon/xenomorph/xeno = mob
			var/nicknumber = num2text(xeno.nicknumber)

			// 123-XX
			if (name_components[1] == nicknumber)
				message_admins("AAA")
				xeno_number = name_components[1]
				xeno_postfix = name_components[2]
			// XX-123
			else if (name_components[2] == nicknumber)
				message_admins("BBB")
				xeno_prefix = name_components[1]
				xeno_number = name_components[2]
			// XX-YY
			else {
				message_admins("CCC")
				xeno_prefix = name_components[1]
				xeno_postfix = name_components[2]
			}
		}
		// XX-123-YY
		else if (name_components.len == 3) {
			xeno_prefix = name_components[1]
			xeno_number = name_components[2]
			xeno_postfix = name_components[3]
		}

/datum/highlight_keywords_payload/proc/to_list()
	return list(
		fullName = name_full,
		firstName = name_first,
		middleName = name_middle,
		lastName = name_last,
		fullJob = job_full,
		jobCommTitle = job_comm_title,
		xenoPrefix = xeno_prefix,
		xenoNumber = xeno_number,
		xenoPostfix = xeno_postfix
	)
