/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.

	If you need help with creating new symptoms or expanding the advance disease, ask for Giacom on #coderbus.

*/

#define RANDOM_STARTING_LEVEL 2

var/list/archive_diseases = list()

// The order goes from easy to cure to hard to cure.
var/list/advance_cures = list(
									"nutriment", "sugar", "orangejuice",
									"spaceacillin", "kelotane", "ethanol",
									"leporazine", "lipozine",
									"silver", "gold", "phoron"
								)

/*

	PROPERTIES

 */

/datum/disease/advance

	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advance Disease" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread = "Unknown"
	affected_species = list("Human","Monkey")

	// NEW VARS

	var/list/symptoms = list() // The symptoms of the disease.
	var/id = ""
	var/processing = 0

/*

	OLD PROCS

 */

/datum/disease/advance/New(process = 1, datum/disease/advance/current_disease)

	// Setup our dictionary if it hasn't already.
	if(!dictionary_symptoms.len)
		for(var/symp in list_symptoms)
			var/datum/symptom/current_symptom = new symp
			dictionary_symptoms[current_symptom.id] = symp

	if(!istype(current_disease))
		current_disease = null
	// Generate symptoms if we weren't given any.

	if(!symptoms || !symptoms.len)

		if(!current_disease || !current_disease.symptoms || !current_disease.symptoms.len)
			symptoms = GenerateSymptoms()
		else
			for(var/datum/symptom/current_symptom in current_disease.symptoms)
				symptoms += new current_symptom.type

	Refresh()
	..()


/datum/disease/advance/Destroy()
	if(processing)
		for(var/datum/symptom/current_symptom in symptoms)
			current_symptom.End(src)
	. = ..()

// Randomly pick a symptom to activate.
/datum/disease/advance/stage_act()
	..()
	if(symptoms && symptoms.len)

		if(!processing)
			processing = 1
			for(var/datum/symptom/current_symptom in symptoms)
				current_symptom.Start(src)

		for(var/datum/symptom/current_symptom in symptoms)
			current_symptom.Activate(src)
	else
		CRASH("We do not have any symptoms during stage_act()!")

// Compares type then ID.
/datum/disease/advance/IsSame(datum/disease/advance/current_disease)

	if(!(istype(current_disease, /datum/disease/advance)))
		return 0

	if(src.GetDiseaseID() != current_disease.GetDiseaseID())
		return 0
	return 1

// To add special resistances.
/datum/disease/advance/cure(resistance=1)
	if(affected_mob)
		var/id = "[GetDiseaseID()]"
		if(resistance && !affected_mob.resistances[id])
			affected_mob.resistances[id] = id
		remove_virus()
	qdel(src) //delete the datum to stop it processing
	return

// Returns the advance disease with a different reference memory.
/datum/disease/advance/Copy(process = 0)
	return new /datum/disease/advance(process, src, 1)

/*

	NEW PROCS

 */

// Mix the symptoms of two diseases (the src and the argument)
/datum/disease/advance/proc/Mix(datum/disease/advance/current_disease)
	if(!(src.IsSame(current_disease)))
		var/list/possible_symptoms = shuffle(current_disease.symptoms)
		for(var/datum/symptom/current_symptom in possible_symptoms)
			AddSymptom(new current_symptom.type)

/datum/disease/advance/proc/HasSymptom(datum/symptom/current_symptom)
	for(var/datum/symptom/symp in symptoms)
		if(symp.id == current_symptom.id)
			return 1
	return 0

// Will generate new unique symptoms, use this if there are none. Returns a list of symptoms that were generated.
/datum/disease/advance/proc/GenerateSymptoms(type_level_limit = RANDOM_STARTING_LEVEL, amount_get = 0)

	var/list/generated = list() // Symptoms we generated.

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in list_symptoms)
		var/datum/symptom/current_symptom = new symp
		if(current_symptom.level <= type_level_limit)
			if(!HasSymptom(current_symptom))
				possible_symptoms += current_symptom

	if(!possible_symptoms.len)
		return
		//error("Advance Disease - We weren't able to get any possible symptoms in GenerateSymptoms([type_level_limit], [amount_get])")

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of++

	for(var/i = 1; number_of >= i; i++)
		var/datum/symptom/current_symptom = pick(possible_symptoms)
		generated += current_symptom
		possible_symptoms -= current_symptom

	return generated

/datum/disease/advance/proc/Refresh(new_name = 0)
	var/list/properties = GenerateProperties()
	AssignProperties(properties)

	if(!archive_diseases[GetDiseaseID()])
		if(new_name)
			AssignName()
		archive_diseases[GetDiseaseID()] = src // So we don't infinite loop
		archive_diseases[GetDiseaseID()] = new /datum/disease/advance(0, src, 1)

	var/datum/disease/advance/advanced_disease = archive_diseases[GetDiseaseID()]
	AssignName(advanced_disease.name)

//Generate disease properties based on the effects. Returns an associated list.
/datum/disease/advance/proc/GenerateProperties()

	if(!symptoms || !symptoms.len)
		CRASH("We did not have any symptoms before generating properties.")

	var/list/properties = list("resistance" = 1, "stealth" = 1, "stage_rate" = 1, "transmittable" = 1, "severity" = 1)

	for(var/datum/symptom/current_symptom in symptoms)

		properties["resistance"] += current_symptom.resistance
		properties["stealth"] += current_symptom.stealth
		properties["stage_rate"] += current_symptom.stage_speed
		properties["transmittable"] += current_symptom.transmittable
		properties["severity"] = max(properties["severity"], current_symptom.level) // severity is based on the highest level symptom

	return properties

// Assign the properties that are in the list.
/datum/disease/advance/proc/AssignProperties(list/properties = list())

	if(properties && properties.len)

		hidden = list( (properties["stealth"] > 2), (properties["stealth"] > 3) )
		// The more symptoms we have, the less transmittable it is but some symptoms can make up for it.
		SetSpread(Clamp(properties["transmittable"] - symptoms.len, BLOOD, AIRBORNE))
		permeability_mod = max(Ceiling(0.4 * properties["transmittable"]), 1)
		cure_chance = 15 - Clamp(properties["resistance"], -5, 5) // can be between 10 and 20
		stage_prob = max(properties["stage_rate"], 2)
		SetSeverity(properties["severity"])
		GenerateCure(properties)
	else
		CRASH("Our properties were empty or null!")


// Assign the spread type and give it the correct description.
/datum/disease/advance/proc/SetSpread(spread_id)
	switch(spread_id)

		if(NON_CONTAGIOUS)
			spread = "None"
		if(SPECIAL)
			spread = "None"
		if(CONTACT_GENERAL, CONTACT_HANDS, CONTACT_FEET)
			spread = "On contact"
		if(AIRBORNE)
			spread = "Airborne"
		if(BLOOD)
			spread = "Blood"

	spread_type = spread_id

/datum/disease/advance/proc/SetSeverity(level_sev)

	switch(level_sev)

		if(-INFINITY to 0)
			severity = "Non-Threat"
		if(1)
			severity = "Minor"
		if(2)
			severity = "Medium"
		if(3)
			severity = "Harmful"
		if(4)
			severity = "Dangerous!"
		if(5 to INFINITY)
			severity = "BIOHAZARD THREAT!"
		else
			severity = "Unknown"


// Will generate a random cure, the less resistance the symptoms have, the harder the cure.
/datum/disease/advance/proc/GenerateCure(list/properties = list())
	if(properties && properties.len)
		var/res = Clamp(properties["resistance"] - (symptoms.len / 2), 1, advance_cures.len)
		cure_id = advance_cures[res]

		// Get the cure name from the cure_id
		var/datum/reagent/current_disease = chemical_reagents_list[cure_id]
		cure = current_disease.name


	return

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/Evolve(level = 2)
	var/s = SAFEPICK(GenerateSymptoms(level, 1))
	if(s)
		AddSymptom(s)
		Refresh(1)
	return

// Randomly remove a symptom.
/datum/disease/advance/proc/Devolve()
	if(symptoms.len > 1)
		var/s = SAFEPICK(symptoms)
		if(s)
			RemoveSymptom(s)
			Refresh(1)
	return

// Name the disease.
/datum/disease/advance/proc/AssignName(name = "Unknown")
	src.name = name
	return

// Return a unique ID of the disease.
/datum/disease/advance/proc/GetDiseaseID()

	var/list/symptom_list = list()
	for(var/datum/symptom/current_symptom in symptoms)
		symptom_list += current_symptom.id
	symptom_list = sortList(symptom_list) // Sort the list so it doesn't matter which order the symptoms are in.
	var/result = jointext(symptom_list, ":")
	id = result
	return result


// Add a symptom, if it is over the limit (with a small chance to be able to go over)
// we take a random symptom away and add the new one.
/datum/disease/advance/proc/AddSymptom(datum/symptom/current_symptom)

	if(HasSymptom(current_symptom))
		return

	if(symptoms.len < 5 + rand(-1, 1))
		symptoms += current_symptom
	else
		RemoveSymptom(pick(symptoms))
		symptoms += current_symptom
	return

// Simply removes the symptom.
/datum/disease/advance/proc/RemoveSymptom(datum/symptom/current_symptom)
	symptoms -= current_symptom
	return

/*

	Static Procs

*/

// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(list/D_list)

	var/list/diseases = list()

	for(var/datum/disease/advance/advanced_disease in D_list)
		diseases += advanced_disease.Copy()

	if(!diseases.len)
		return null
	if(diseases.len <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && diseases.len > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	// Should be only 1 entry left, but if not let's only return a single entry
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.Refresh(1)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/preserved_disease in data["viruses"])
				preserve += preserved_disease.Copy()
			R.data_properties = data.Copy()
		else
			R.data_properties = data
		if(preserve.len)
			R.data_properties["viruses"] = preserve

/proc/AdminCreateVirus(mob/user)
	var/i = 5

	var/datum/disease/advance/current_disease = new(0, null)
	current_disease.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += list_symptoms.Copy()
	do
		var/symptom = tgui_input_list(user, "Choose a symptom to add ([i] remaining)", "Choose a Symptom", symptoms)
		if(istext(symptom))
			i = 0
		else if(ispath(symptom))
			var/datum/symptom/current_symptom = new symptom
			if(!current_disease.HasSymptom(current_symptom))
				current_disease.symptoms += current_symptom
				i--
	while(i > 0)

	if(current_disease.symptoms.len > 0)

		var/new_name = input(user, "Name your new disease.", "New Name")
		current_disease.AssignName(new_name)
		current_disease.Refresh()

		for(var/datum/disease/advance/AD in active_diseases)
			AD.Refresh()

		for(var/mob/living/carbon/human/human in shuffle(GLOB.alive_mob_list.Copy()))
			if(!is_ground_level(human.z))
				continue
			if(!human.has_disease(current_disease))
				human.contract_disease(current_disease, 1)
				break

		var/list/name_symptoms = list()
		for(var/datum/symptom/current_symptom in current_disease.symptoms)
			name_symptoms += current_symptom.name
		message_admins("[key_name_admin(user)] has triggered a custom virus outbreak of [current_disease.name]! It has these symptoms: [english_list(name_symptoms)]")

/*
/mob/verb/test()

	for(var/datum/disease/current_disease in active_diseases)
		to_chat(src, "<a href='?_src_=vars;Vars=\ref[current_disease]'>[current_disease.name] - [current_disease.holder]</a>")
*/

#undef RANDOM_STARTING_LEVEL
