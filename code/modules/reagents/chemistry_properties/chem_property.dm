/datum/chem_property
	var/name
	var/code = "ZZZ" //should be unique to all properties
	var/description = "You shouldn't be seeing this."
	var/datum/reagent/holder
	var/rarity = PROPERTY_DISABLED
	var/category = PROPERTY_TYPE_MEDICINE
	var/level = 1 //used to calculate potency
	var/max_level //if there a point where it makes no logical sense to increase the level? Remember potency is level / 2
	var/value //how much value per level? Negative properties should have a high negative value, neutral should have a value near zero, and positive ones should have a high value
	var/starter = FALSE //whether or not this is a starter property and should be added to the property database on startup
	var/updates_stats = FALSE //should the property change other variables in the reagent when added or removed?
	/// Should reagent with this property explode/start fire when mixed more than overdose threshold at once?
	var/volatile = FALSE 

/datum/chem_property/Destroy()
	holder = null
	. = ..()
	return QDEL_HINT_IWILLGC

/datum/chem_property/proc/reagent_added(atom/A, datum/reagent/R, var/amount)
	return

/datum/chem_property/proc/pre_process(mob/living/M) //used for properties that need special checks before processing starts, such as cryometabolization
	return

/datum/chem_property/proc/on_delete(mob/living/M) //used for properties that do something on delete
	qdel(src)
	return

/datum/chem_property/process(mob/living/M, var/potency = 1, var/delta_time)
	if(QDELETED(src))
		CRASH("Attempted to process a deleted chemical property: [name], type=[type]")

	return TRUE

/datum/chem_property/proc/process_overdose(mob/living/M, var/potency = 1, var/delta_time)
	if(QDELETED(src))
		CRASH("Attempted to process_overdose a deleted chemical property: [name], type=[type]")

	return TRUE

/datum/chem_property/proc/process_critical(mob/living/M, var/potency = 1, var/delta_time)
	if(QDELETED(src))
		CRASH("Attempted to process_critical a deleted chemical property: [name], type=[type]")

	return TRUE

/datum/chem_property/proc/process_dead(mob/living/M, var/potency = 1, var/delta_time)
	return FALSE // By default, chemicals don't process in dead personnel.

/datum/chem_property/proc/trigger(var/A) //used for properties that needs something to trigger outside of where process is usually called
	return

/datum/chem_property/proc/reset_reagent()
	return

/datum/chem_property/proc/update_reagent() //used for changing other variables in the reagent, set update to FALSE to remove the update
	return

/datum/chem_property/proc/reaction_mob(var/mob/M, var/method=TOUCH, var/volume, var/potency)
	return

/datum/chem_property/proc/reaction_obj(var/obj/O, var/volume, var/potency)
	return

/datum/chem_property/proc/reaction_turf(var/turf/T, var/volume, var/potency)
	return

/datum/chem_property/proc/post_update_reagent()
	return

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
	