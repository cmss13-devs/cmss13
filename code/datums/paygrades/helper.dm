/proc/get_paygrades(paygrade, size, gender)
	if(!paygrade)
		return

	var/datum/paygrade/P = GLOB.paygrades[paygrade]

	if(size)//Builds the prefix, if one should exist.
		if(!P)//For custom admin-made paygrades to not cause runtimes.
			return "[paygrade] "
		var/NP = ""
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
		return NP
	else
		if(!P)//For custom admin-made paygrades to not cause runtimes.
			return "[paygrade]"
		return P.name

/proc/get_paygrade_id_by_name(paygrade_name)
	var/datum/paygrade/paygrade
	for(var/paygrade_id in GLOB.paygrades)
		paygrade = GLOB.paygrades[paygrade_id]
		if(paygrade.name == paygrade_name)
			return paygrade_id

/proc/get_rank_pins(paygrade)
	if(!paygrade)
		return null

	if(!(paygrade in GLOB.paygrades))
		return null

	var/datum/paygrade/P = GLOB.paygrades[paygrade]

	return P.rank_pin
