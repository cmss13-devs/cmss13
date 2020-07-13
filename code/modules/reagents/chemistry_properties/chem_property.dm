/datum/chem_property
	var/name
	var/code = "ZZZ" //should be unique to all properties
	var/description = "You shouldn't be seeing this."
	var/datum/reagent/holder
	var/rarity = PROPERTY_DISABLED
	var/category = PROPERTY_TYPE_MEDICINE
	var/level = 1 //used to calculate potency
	var/value //how much value per level? Negative properties should have a high negative value, neutral should have a value near zero, and positive ones should have a high value
	var/updates_stats = FALSE //should the property change other variables in the reagent when added or removed?
	var/deleted = FALSE

/datum/chem_property/proc/reagent_added(atom/A, datum/reagent/R, var/amount)
	return

/datum/chem_property/proc/pre_process(mob/living/M) //used for properties that need special checks before processing starts, such as cryometabolization
	return

/datum/chem_property/proc/on_delete(mob/living/M) //used for properties that do something on delete
	deleted = TRUE

	return

/datum/chem_property/proc/process(mob/living/M, var/potency = 1)
	if(deleted)
		return FALSE

	return TRUE

/datum/chem_property/proc/process_overdose(mob/living/M, var/potency = 1)
	if(deleted)
		return FALSE

	return TRUE

/datum/chem_property/proc/process_critical(mob/living/M, var/potency = 1)
	if(deleted)
		return FALSE

	return TRUE

/datum/chem_property/proc/process_dead(mob/living/M, var/potency = 1)
	if(deleted)
		return FALSE

	return TRUE

/datum/chem_property/proc/trigger(var/A) //used for properties that needs something to trigger outside of where process is usually called
	return

/datum/chem_property/proc/update_reagent(var/update = TRUE) //used for changing other variables in the reagent, set update to FALSE to remove the update
	if(!update)
		holder = null

/datum/chem_property/proc/categories_to_string()
	var/text = ""
	switch(rarity)
		if(PROPERTY_DISABLED)
			text += "Unique "
		if(PROPERTY_COMMON)
			text += "Common "
		if(PROPERTY_UNCOMMON)
			text += "Uncommon "
		if(PROPERTY_RARE)
			text += "Rare "
		if(PROPERTY_LEGENDARY)
			text += "Legendary "
		if(PROPERTY_ADMIN)
			text += "Special "
	if(isNegativeProperty(src))
		text += "Harmful "
	else if(isPositiveProperty(src))
		text += "Helpful "
	if(category & PROPERTY_TYPE_MEDICINE)
		text += "Medicine "
	if(category & PROPERTY_TYPE_TOXICANT)
		text += "Toxicant "
	if(category & PROPERTY_TYPE_STIMULANT)
		text += "Stimulant "
	if(category & PROPERTY_TYPE_REACTANT)
		text += "Reactant "
	if(category & PROPERTY_TYPE_IRRITANT)
		text += "Irritant "
	if(category & PROPERTY_TYPE_METABOLITE)
		text += "Metabolite "
	if(category & PROPERTY_TYPE_ANOMALOUS)
		text += "Anomalous "
	return text