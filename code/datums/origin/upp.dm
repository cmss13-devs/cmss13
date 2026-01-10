/datum/origin/upp
	name = ORIGIN_UPP
	desc = "You were born in the Union of Progressive Peoples."

/datum/origin/upp/generate_human_name(gender = MALE)
	var/first_name
	var/last_name
	if(prob(40))
		first_name = "[capitalize(randomly_generate_chinese_word(1))]"
	else
		switch(gender)
			if(FEMALE)
				first_name = capitalize(pick(GLOB.first_names_female_upp))
			if(PLURAL, NEUTER)
				first_name = capitalize(pick(pick(GLOB.first_names_male_upp), pick(GLOB.first_names_female_upp)))
			else // MALE
				first_name = capitalize(pick(GLOB.first_names_male_upp))
	if(prob(35))
		last_name = "[capitalize(randomly_generate_chinese_word(pick(20;1, 80;2)))]"
	else
		last_name = "[pick(GLOB.last_names_upp)]"

	return first_name + " " + last_name
