/proc/get_paygrades(paygrade, size, gender)
	if(!paygrade) return

	var/datum/paygrade/grade = GLOB.paygrades[paygrade]

	if(size)//Builds the prefix, if one should exist.
		var/NP = ""
		if(grade.fprefix)//Factional (pre)prefix
			NP = "[grade.fprefix] "
		if(grade.prefix)//Actual rank prefix
			NP =  "[NP][grade.prefix] "
			if(grade.prefix == "C")//Override for Civilian ranks that don't have occupational prefixes.
				if(gender && gender == FEMALE)
					NP = "Ms. "
				else if(gender && gender == MALE)
					NP = "Mr. "
				else
					NP = "Mx. " //inclusivity win!
		return NP
	else
		return grade.name

/proc/get_rank_pins(paygrade)
	if(!paygrade) return null

	if(!(paygrade in GLOB.paygrades))
		return null

	var/datum/paygrade/grade = GLOB.paygrades[paygrade]

	return grade.rank_pin
