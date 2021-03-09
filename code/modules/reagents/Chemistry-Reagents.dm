
//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.


/datum/reagent
	var/name = "Reagent"
	var/id = ""
	var/description = ""
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/data = 0 //Scratchpad for random chemicals to do their own thing TODO: unify this somehow?
	var/list/data_properties = list("blood_type" = null, "blood_colour" = "#A10808", "viruses" = null, "resistances" = null) //mostly for viruses...
	var/volume = 0
	var/nutriment_factor = 0
	var/custom_metabolism = REAGENTS_METABOLISM
	var/overdose = 0 //The young brother of overdose. Side effects include
	var/overdose_critical = 0 //The nastier brother of overdose. Expect to die
	var/overdose_dam = 1//Handeled by heart damage
	var/spray_warning = FALSE //whether spraying that reagent creates an admin message.
	//var/list/viruses = list()
	var/color = "#000000" // rgb: 0, 0, 0 (does not support alpha channels - yet!)
	var/mob/last_source_mob
	// For explosions
	var/explosive = FALSE
	var/power = 0
	var/falloff_modifier = 0
	// For chemical fire
	var/chemfiresupp = FALSE
	var/intensitymod = 0
	var/durationmod = 0
	var/radiusmod = 0
	// For chemical fire from flamethrowers
	var/intensityfire = 0
	var/durationfire = 0
	var/rangefire = -1 // Keep at -1 if you want an infinite range
	var/flameshape = FLAMESHAPE_LINE
	var/fire_penetrating = FALSE // Whether it can damage fire-immune xenos
	// For both chemical fires
	var/burncolor = "#f88818"
	var/burncolormod = 1
	// Chem generator and research stuff
	var/chemclass = CHEM_CLASS_NONE //Decides how rare the chem in the generation process
	var/gen_tier = 0 //Decides the chance of the chem being good during generation
	var/objective_value // How valuable it is to identify the chemical. (Only works on chemclass SPECIAL or ULTRA)
	var/list/datum/chem_property/properties = list() //Decides properties
	var/original_id //For tracing back
	var/flags = 0 // Flags for misc. stuff

	var/deleted = FALSE //If the reagent was deleted

/datum/reagent/New()
	if(properties)
		properties = properties_to_datums()
	recalculate_variables()

/datum/reagent/Destroy()
	QDEL_NULL_LIST(properties)
	data_properties = null
	holder = null
	last_source_mob = null
	return ..()

/datum/reagent/proc/recalculate_variables()
	for(var/datum/chem_property/P in properties)
		P.holder = src
		P.reset_reagent()

	for(var/datum/chem_property/P in properties)
		P.update_reagent()

/datum/reagent/proc/reaction_mob(var/mob/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
	if(!istype(M, /mob/living))	return 0
	var/datum/reagent/self = src
	src = null										  //of the reagent to the mob on TOUCHING it.

	if(self.holder)		//for catching rare runtimes
		if(!istype(self.holder.my_atom, /obj/effect/particle_effect/smoke/chem))
			// If the chemicals are in a smoke cloud, do not try to let the chemicals "penetrate" into the mob's system (balance station 13) -- Doohl

			if(method == TOUCH)

				var/chance = 1
				var/block  = 0

				for(var/obj/item/clothing/C in M.get_equipped_items())
					if(C.permeability_coefficient < chance) chance = C.permeability_coefficient
					if(istype(C, /obj/item/clothing/suit/bio_suit))
						// bio suits are just about completely fool-proof - Doohl
						// kind of a hacky way of making bio suits more resistant to chemicals but w/e
						if(prob(75))
							block = 1

					if(istype(C, /obj/item/clothing/head/bio_hood))
						if(prob(75))
							block = 1

				chance = chance * 100

				if(prob(chance) && !block)
					if(M.reagents)
						M.reagents.add_reagent(self.id,self.volume/2)
	return 1

/datum/reagent/proc/reaction_obj(var/obj/O, var/volume) //By default we transfer a small part of the reagent to the object
	src = null						//if it can hold reagents. nope!
	//if(O.reagents)
	//	O.reagents.add_reagent(id,volume/3)
	return

/datum/reagent/proc/reaction_turf(var/turf/T, var/volume)
	src = null
	return

/datum/reagent/proc/on_mob_life(mob/living/M, alien, var/delta_time)
	if(alien == IS_HORROR || !holder)
		return
	holder.remove_reagent(id, custom_metabolism*delta_time) //By default it slowly disappears.

	var/list/mods = handle_pre_processing(M)

	if(mods[REAGENT_CANCEL])
		return

	if((!isliving(M) || alien == IS_YAUTJA) && !mods[REAGENT_FORCE])
		return

	handle_processing(M, mods)

	return TRUE

//Pre-processing
/datum/reagent/proc/handle_pre_processing(mob/living/M)
	var/list/mods = list(	REAGENT_EFFECT		= TRUE,
							REAGENT_BOOST 		= FALSE,
							REAGENT_PURGE 		= FALSE,
							REAGENT_FORCE 		= FALSE,
							REAGENT_CANCEL		= FALSE)

	for(var/datum/chem_property/P in properties)
		var/list/A = P.pre_process(M)
		if(!A)
			continue
		for(var/mod in A)
			mods[mod] += A[mod]

	return mods

//Main Processing
/datum/reagent/proc/handle_processing(mob/living/M, var/list/mods)
	for(var/datum/chem_property/P in properties)
		//A level of 1 == 0.5 potency, which is equal to REM (0.2/0.4) in the old system
		//That means the level of the property by default is the number of REMs the effect had in the old system
		var/potency = mods[REAGENT_EFFECT] * ((P.level+mods[REAGENT_BOOST]) * 0.5)
		if(potency <= 0)
			continue
		P.process(M, potency)
		if(flags & REAGENT_CANNOT_OVERDOSE)
			continue
		if(overdose && volume >= overdose)
			P.process_overdose(M, potency)
			if(overdose_critical && volume > overdose_critical)
				P.process_critical(M, potency)
			var/overdose_message = "[name] overdose"
			M.last_damage_source = overdose_message
			M.last_damage_mob = last_source_mob

	if(mods[REAGENT_PURGE])
		holder.remove_all_type(/datum/reagent,2*mods[REAGENT_PURGE])

//Dead Processing, see /mob/living/carbon/human/proc/handle_necro_chemicals_in_body()
/datum/reagent/proc/handle_dead_processing(mob/living/M, var/list/mods)
	var/processing_in_dead = FALSE
	for(var/datum/chem_property/P in properties)
		var/potency = mods[REAGENT_EFFECT] * ((P.level+mods[REAGENT_BOOST]) * 0.5)
		if(potency <= 0)
			continue
		if(P.process_dead(M, potency))
			processing_in_dead = TRUE

	if(processing_in_dead && !mods[REAGENT_FORCE]) // mods[REAGENT_FORCE] will force the reagent removal anyhow.
		holder.remove_reagent(id, custom_metabolism)

/datum/reagent/proc/on_delete()
	if(!holder || !holder.my_atom || !isliving(holder.my_atom))
		return

	var/mob/living/M = holder.my_atom

	for(var/datum/chem_property/P in properties)
		P.on_delete(M)

	return

/datum/reagent/proc/make_alike(var/datum/reagent/C)
	name = C.name
	id = C.id
	color = C.color
	chemclass = C.chemclass
	gen_tier = C.gen_tier
	var/list/temp = list()
	for(var/datum/chem_property/P in C.properties)
		var/datum/chem_property/new_property = new P.type()
		new_property.level = P.level
		new_property.holder = src
		temp += new_property

	properties = temp
	description = C.description
	overdose = C.overdose
	overdose_critical = C.overdose_critical
	nutriment_factor = C.nutriment_factor
	custom_metabolism = C.custom_metabolism
	last_source_mob = C.last_source_mob
	objective_value = C.objective_value
	original_id = C.original_id
	chemfiresupp = C.chemfiresupp
	radiusmod = C.radiusmod
	durationmod = C.durationmod
	intensitymod = C.intensitymod
	burncolor = C.burncolor
	durationfire = C.durationfire
	intensityfire = C.intensityfire
	rangefire = C.rangefire
	fire_penetrating = C.fire_penetrating
	explosive = C.explosive
	power = C.power
	falloff_modifier =  C.falloff_modifier
	flags = C.flags

/datum/chemical_reaction/proc/make_alike(var/datum/chemical_reaction/C)
	if(!C)
		return
	id = C.id
	gen_tier = C.gen_tier
	required_reagents = C.required_reagents.Copy()
	required_catalysts = C.required_catalysts.Copy()
	result = C.result
	result_amount = C.result_amount

/datum/reagent/proc/save_chemclass() //Called from /datum/reagents/New()
	//Store all classed reagents so we can easily access chem IDs based on class.
	if(chemclass)
		switch(chemclass)
			if(CHEM_CLASS_BASIC)
				chemical_gen_classes_list["C1"] += id
			if(CHEM_CLASS_COMMON)
				chemical_gen_classes_list["C2"] += id
			if(CHEM_CLASS_UNCOMMON)
				chemical_gen_classes_list["C3"] += id
			if(CHEM_CLASS_RARE)
				chemical_gen_classes_list["C4"] += id
			if(CHEM_CLASS_SPECIAL)
				chemical_gen_classes_list["C5"] += id
				chemical_objective_list[id] = objective_value
			if(CHEM_CLASS_ULTRA)
				chemical_gen_classes_list["C6"] += id
				chemical_objective_list[id] = objective_value
		chemical_gen_classes_list["C"] += id
	if(gen_tier)
		switch(gen_tier)
			if(1)
				chemical_gen_classes_list["T1"] += id
			if(2)
				chemical_gen_classes_list["T2"] += id
			if(3)
				chemical_gen_classes_list["T3"] += id
			if(4)
				chemical_gen_classes_list["T4"] += id
			if(5)
				chemical_gen_classes_list["T5"] += id


/datum/reagent/proc/properties_to_datums()
	if(chemical_properties_list)
		var/new_properties = list()
		for(var/P in properties)
			if(istype(P, /datum/chem_property))
				new_properties += P
				continue
			var/datum/chem_property/D = chemical_properties_list[P]
			if(D)
				D = new D.type()
				D.level = properties[P]
				D.holder = src
				new_properties += D
		return new_properties
	else
		return properties

/datum/reagent/proc/properties_to_assoc()
	var/new_properties = list()
	for(var/P in properties)
		if(!istype(P, /datum/chem_property))
			continue
		var/datum/chem_property/D = P
		var/list/property_level[0]
		property_level["[D.name]"] = D.level
		new_properties += property_level
	return new_properties

/datum/reagent/proc/get_property(var/property_name)
	var/i = 1
	for(var/datum/chem_property/P in properties)
		if(P.name == property_name)
			return properties[i]
		i++
	return FALSE

/datum/reagent/proc/relevel_property(var/property_name, var/new_level = 1)
	var/i = 1
	var/datum/chem_property/R
	for(var/datum/chem_property/P in properties)
		if(P.name == property_name)
			R = new P.type()
			break
		i++
		if(i > properties.len)
			return FALSE
	R.level = new_level
	R.holder = src
	properties[i] = R

	recalculate_variables()
	return TRUE

/datum/reagent/proc/remove_property(var/property)
	for(var/datum/chem_property/P in properties)
		if(P.name == property)
			P.reset_reagent()
			LAZYREMOVE(properties, P)
			recalculate_variables()
			return TRUE

/datum/reagent/proc/reset_pain_reduction()
	if(holder && holder.my_atom && ishuman(holder.my_atom))
		var/mob/living/carbon/human/H = holder.my_atom
		H.pain.reset_pain_reduction()
