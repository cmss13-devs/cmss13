/datum/origin/upp
	name = ORIGIN_UPP
	desc = "You were born in the Union of Progressive Peoples."

/datum/origin/upp/generate_human_name(gender = MALE)
	var/first_name
	var/last_name

	if(gender == MALE)
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(GLOB.first_names_male_upp)]"
	else
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(GLOB.first_names_female_upp)]"

	if(prob(35))
		last_name = "[capitalize(randomly_generate_chinese_word(pick(20;1, 80;2)))]"
	else
		last_name = "[pick(GLOB.last_names_upp)]"

	return first_name + " " + last_name
