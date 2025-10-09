/datum/caste_datum/proc/get_age_prefix(age)
	var/age_prefix = ""
	switch(age)
		if(XENO_YOUNG)
			age_prefix = "Молодой "
		if(XENO_MATURE)
			age_prefix = "Взрослый "
		if(XENO_ELDER)
			age_prefix = "Старший "
		if(XENO_ANCIENT)
			age_prefix = "Древний "
		if(XENO_PRIME)
			age_prefix = "Прайм "
	return age_prefix

/datum/caste_datum/facehugger/get_age_prefix(age)
	var/age_prefix = ""
	switch(age)
		if(XENO_NORMAL)
			age_prefix = "Молодой "
		if(XENO_MATURE)
			age_prefix = "Юный "
		if(XENO_ELDER)
			age_prefix = "Бывалый "
		if(XENO_ANCIENT)
			age_prefix = "Губительный "
		if(XENO_PRIME)
			age_prefix = "Королевский "
	return age_prefix
