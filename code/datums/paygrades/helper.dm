/proc/get_paygrades(paygrade, size, gender)
	if(!paygrade) return

	// Format: WY-XX-X
    // WY has a special paygrade syntax, so it is handled separately. This should really be more modular, but can be done in the future.
	if(copytext(paygrade, 1, 3) == "WY")
		var/rank_info = copytext(paygrade, 3)

		var/rank = replacetext_char(rank_info, "-", "")

		var/division = GLOB.wy_ranks["division_code"][copytext_char(rank, 1, 2)]
		var/job = GLOB.wy_ranks[size? "job_code_prefix" : "job_code"][copytext_char(rank, 2, 3)]

		return trim("[division] [job]")

	if(!(paygrade in GLOB.paygrades))
		return paygrade

	var/datum/paygrade/P = GLOB.paygrades[paygrade]

	if(size)
		if(P.prefix)
			return "[P.prefix] "
		else
			return ""
	else
		return P.name

/proc/get_rank_pins(paygrade)
	if(!paygrade) return null

	if(!(paygrade in GLOB.paygrades))
		return null
	
	var/datum/paygrade/P = GLOB.paygrades[paygrade]

	return P.rank_pin