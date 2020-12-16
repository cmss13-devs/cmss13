proc/random_ethnicity()
	return pick(GLOB.ethnicities_list)

proc/random_body_type()
	return pick(GLOB.body_types_list)

proc/random_hair_style(gender, species = "Human")
	var/h_style = "Crewcut"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		if(!S.selectable)
			continue
		valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style


proc/random_facial_hair_style(gender, species = "Human")
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		if(!S.selectable)
			continue
		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

proc/random_name(gender, species = "Human")
	if(gender==FEMALE)	return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
	else				return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

proc/has_species(var/mob/M, var/species)
	if(!M || !istype(M,/mob/living/carbon/human)) return 0
	var/mob/living/carbon/human/H = M

	if(!H.species) return 0
	if(H.species.name != species) return 0

	return 1

// We change real name, so we change the voice too if we are humans
// It also ensures our mind's name gets changed
/mob/proc/change_real_name(var/mob/M, var/new_name)
	if(!new_name)
		return FALSE

	M.real_name = new_name
	M.name = new_name

	// If we have a mind, we need to update its name as well
	M.change_mind_name(new_name)

	// If we are humans, we need to update our voice as well
	M.change_mob_voice(new_name)

	return TRUE

/mob/proc/change_mind_name(var/new_mind_name)
	if(!mind)
		return FALSE
	if(!new_mind_name)
		new_mind_name = "Unknown"
	mind.name = new_mind_name
	return TRUE

/mob/proc/change_mob_voice(var/new_voice_name)
	if(!ishuman(src))
		return FALSE
	if(!new_voice_name)
		new_voice_name = "Unknown"
	var/mob/living/carbon/human/H = src
	H.voice = new_voice_name
	return TRUE
