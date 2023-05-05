/proc/get_paygrades(paygrade, size, gender)
	if(!paygrade) return

	var/datum/paygrade/P = GLOB.paygrades[paygrade]

	if(size)//Builds the prefix, if one should exist.
		var/NP = ""
		if(P)//extra check to avoid runtimes

			if(P.fprefix)//Factional (pre)prefix
				NP = "[P.fprefix] "
			if(P.prefix)//Actual rank prefix
				NP =  "[NP][P.prefix] "
				if(P.prefix == "C")//Override for Civilian ranks that don't have occupational prefixes.
					if(gender && gender == FEMALE)
						NP = "Ms. "
					else if(gender && gender == MALE)
						NP = "Mr. "
					else
						NP = "Mx. " //inclusivity win!
		else
			NP = "[paygrade] "
		areturn NP
	else
		return P.name

/proc/get_rank_pins(paygrade)
	if(!paygrade) return null

	if(!(paygrade in GLOB.paygrades))
		return null

	var/datum/paygrade/P = GLOB.paygrades[paygrade]

	return P.rank_pin
