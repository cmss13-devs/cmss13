
//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.


/datum/reagent
	var/name = "Reagent"
	var/id = ""
	var/description = ""
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/list/data = list("blood_type" = null, "blood_colour" = "#A10808", "viruses" = null, "resistances" = null)
	var/volume = 0
	var/nutriment_factor = 0
	var/custom_metabolism = REAGENTS_METABOLISM
	var/overdose = 0 //The young brother of overdose. Side effects include
	var/overdose_critical = 0 //The nastier brother of overdose. Expect to die
	var/overdose_dam = 1//Handeled by heart damage
	var/scannable = 0 //shows up on health analyzers
	var/spray_warning = FALSE //whether spraying that reagent creates an admin message.
	var/ingestible = TRUE // Set this to FALSE if the reagent must be delivered through injection only
	//var/list/viruses = list()
	var/color = "#000000" // rgb: 0, 0, 0 (does not support alpha channels - yet!)
	var/last_source_mob
	// For explosions
	var/explosive = FALSE
	var/power = 0
	var/falloff_modifier = 0
	// For chemical fire
	var/chemfiresupp = FALSE
	var/intensitymod = 0
	var/durationmod = 0
	var/radiusmod = 0
	var/burncolor = "#f88818"
	var/burncolormod = 1
	// Chem generator and research stuff
	var/chemclass = CHEM_CLASS_NONE //Decides how rare the chem in the generation process
	var/gen_tier = 0 //Decides the chance of the chem being good during generation
	var/objective_value // How valuable it is to identify the chemical. (Only works on chemclass SPECIAL or ULTRA)
	var/list/properties = list() //Decides properties
	var/original_type //For tracing back

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

/datum/reagent/proc/on_mob_life(mob/living/M, alien)
	if(!isliving(M) || alien == IS_HORROR || !holder) return //Noticed runtime errors from pacid trying to damage ghosts, this should fix. --NEO
	//We do not horrors to metabolize anything.
	var/overdose_message = "[name] overdose"
	holder.remove_reagent(id, custom_metabolism) //By default it slowly disappears.
	if(overdose && volume >= overdose)
		on_overdose(M, alien, overdose_message) //Small OD
		M.last_damage_source = overdose_message
		M.last_damage_mob = last_source_mob

	if(overdose_critical && volume > overdose_critical)
		on_overdose_critical(M, alien, overdose_message) //Big OD
		M.last_damage_source = overdose_message
		M.last_damage_mob = last_source_mob
	return 1

/datum/reagent/proc/on_overdose(mob/living/M, alien)
	return

/datum/reagent/proc/on_overdose_critical(mob/living/M, alien)
	return

/datum/reagent/proc/on_move(var/mob/M)
	return

	// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(var/data)
	return

/datum/reagent/proc/on_update(var/atom/A)
	return

/datum/reagent/proc/make_alike(var/datum/reagent/C)
	name = C.name
	id = C.id
	color = C.color
	chemclass = C.chemclass
	gen_tier = C.gen_tier
	properties = C.properties.Copy()
	description = C.description
	overdose = C.overdose
	overdose_critical = C.overdose_critical
	nutriment_factor = C.nutriment_factor
	custom_metabolism = C.custom_metabolism
	last_source_mob = C.last_source_mob
	scannable = C.scannable
	ingestible = C.ingestible
	objective_value = C.objective_value
	original_type = C.original_type
	chemfiresupp = C.chemfiresupp
	radiusmod = C.radiusmod
	durationmod = C.durationmod
	intensitymod = C.intensitymod
	burncolor = C.burncolor
	explosive = C.explosive
	power = C.power
	falloff_modifier =  C.falloff_modifier

/datum/chemical_reaction/proc/make_alike(var/datum/chemical_reaction/C)
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

/datum/reagent/proc/has_property(var/property)
	for(var/P in properties)
		if(P == property)
			return TRUE
	return FALSE