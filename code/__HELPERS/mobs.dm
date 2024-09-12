#define isdeaf(A) (ismob(A) && ((A?:sdisabilities & DISABILITY_DEAF) || A?:ear_deaf))
#define xeno_hivenumber(A) (isxeno(A) ? A?:hivenumber : FALSE)

/proc/random_skin_color()
	return pick(GLOB.skin_color_list)

/proc/random_body_type()
	return pick(GLOB.body_type_list)

/proc/random_body_size()
	return pick(GLOB.body_size_list)

/proc/random_hair_style(gender, species = "Human")
	var/h_style = "Crewcut"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in GLOB.hair_styles_list)
		var/datum/sprite_accessory/S = GLOB.hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		if(!S.selectable)
			continue
		valid_hairstyles[hairstyle] = GLOB.hair_styles_list[hairstyle]

	if(length(valid_hairstyles))
		h_style = pick(valid_hairstyles)

	return h_style


/proc/random_facial_hair_style(gender, species = "Human")
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in GLOB.facial_hair_styles_list)
		var/datum/sprite_accessory/S = GLOB.facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		if(!S.selectable)
			continue
		valid_facialhairstyles[facialhairstyle] = GLOB.facial_hair_styles_list[facialhairstyle]

	if(length(valid_facialhairstyles))
		f_style = pick(valid_facialhairstyles)

		return f_style

/proc/random_name(gender, species = "Human")
	if(gender==FEMALE)
		return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	else
		return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

/proc/has_species(mob/M, species)
	if(!M || !istype(M,/mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = M

	if(!H.species)
		return FALSE
	if(H.species.name != species)
		return FALSE

	return TRUE

// We change real name, so we change the voice too if we are humans
// It also ensures our mind's name gets changed
/mob/proc/change_real_name(mob/M, new_name)
	if(!new_name)
		return FALSE
	var/old_name = M.real_name

	M.real_name = new_name
	M.name = new_name

	// If we have a mind, we need to update its name as well
	M.change_mind_name(new_name)

	// If we are humans, we need to update our voice as well
	M.change_mob_voice(new_name)

	SEND_SIGNAL(src, COMSIG_MOB_REAL_NAME_CHANGED, old_name, new_name)
	return TRUE

/mob/proc/change_mind_name(new_mind_name)
	if(!mind)
		return FALSE
	if(!new_mind_name)
		new_mind_name = "Unknown"
	mind.name = new_mind_name
	return TRUE

/mob/proc/change_mob_voice(new_voice_name)
	if(!ishuman(src))
		return FALSE
	if(!new_voice_name)
		new_voice_name = "Unknown"
	var/mob/living/carbon/human/H = src
	H.voice = new_voice_name
	return TRUE

/*Changing/updating a mob's client color matrices. These render over the map window and affect most things the player sees, except things like inventory,
text popups, HUD, and some fullscreens. Code based on atom filter code, since these have similar issues with application order - for ex. if you have
a desaturation and a recolor matrix, you'll get very different results if you desaturate before recoloring, or recolor before desaturating.

See matrices.dm for the matrix procs.

If you want to recolor a specific atom, you should probably do it as a color matrix filter instead since that code already exists.

Apparently color matrices are not the same sort of matrix used by matrix datums and can't be worked with using normal matrix procs.*/

///Adds a color matrix and updates the client. Priority is the order the matrices are applied, lowest first. Will replace an existing matrix of the same name, if one exists.
/mob/proc/add_client_color_matrix(name, priority, list/params, time, easing)
	LAZYINITLIST(client_color_matrices)

	//Package the matrices in another list that stores priority.
	client_color_matrices[name] = list("priority" = priority, "color_matrix" = params.Copy())

	update_client_color_matrices(time, easing)

/**Combines all color matrices and applies them to the client.
Also used on login to give a client its new body's color matrices.
Responsible for sorting the matrices.
Transition is animated but instant by default.**/
/mob/proc/update_client_color_matrices(time = 0 SECONDS, easing = LINEAR_EASING)
	if(!client)
		return

	if(!length(client_color_matrices))
		animate(client, color = null, time = time, easing = easing)
		UNSETEMPTY(client_color_matrices)
		SEND_SIGNAL(src, COMSIG_MOB_RECALCULATE_CLIENT_COLOR)
		return

	//Sort the matrix packages by priority.
	client_color_matrices = sortTim(client_color_matrices, GLOBAL_PROC_REF(cmp_filter_data_priority), TRUE)

	var/list/final_matrix

	for(var/package in client_color_matrices)
		var/list/current_matrix = client_color_matrices[package]["color_matrix"]
		if(!final_matrix)
			final_matrix = current_matrix
		else
			final_matrix = color_matrix_multiply(final_matrix, current_matrix)

	animate(client, color = final_matrix, time = time, easing = easing)
	SEND_SIGNAL(src, COMSIG_MOB_RECALCULATE_CLIENT_COLOR)

///Changes a matrix package's priority and updates client.
/mob/proc/change_client_color_matrix_priority(name, new_priority, time, easing)
	if(!client_color_matrices || !client_color_matrices[name])
		return

	client_color_matrices[name]["priority"] = new_priority

	update_client_color_matrices(time, easing)

///Returns the matrix of that name, if it exists.
/mob/proc/get_client_color_matrix(name)
	return client_color_matrices[name]["color_matrix"]

///Can take either a single name or a list of several. Attempts to remove target matrix packages and update client.
/mob/proc/remove_client_color_matrix(name_or_names, time, easing)
	if(!client_color_matrices)
		return

	var/found = FALSE
	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(client_color_matrices[name])
			client_color_matrices -= name
			found = TRUE

	if(found)
		update_client_color_matrices(time, easing)

///Removes all matrices and updates client.
/mob/proc/clear_client_color_matrices(time, easing)
	client_color_matrices = null
	update_client_color_matrices(time, easing)
