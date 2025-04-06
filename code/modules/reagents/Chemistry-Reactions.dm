/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/gen_tier = 0 //used for generation purposes
	var/list/required_reagents = new/list()
	var/list/required_catalysts = new/list()

	/// Determines if a chemical reaction can occur inside a mob
	var/mob_react = TRUE
	/// The container path required for the reaction to happen
	var/required_container = null
	/// The resulting amount: Recommended to be set to the total volume of all components
	var/result_amount = 0
	/// set to nonzero if secondary reaction
	var/secondary = 0
	/// additional reagents produced by the reaction
	var/list/secondary_results = list()
	///flags of indicator of the reaction does this reaction has. potentially violent.
	var/reaction_type = CHEM_REACTION_CALM

/datum/chemical_reaction/proc/on_reaction(datum/reagents/holder, created_volume, multiplier)
	SHOULD_CALL_PARENT(TRUE)

	if(CHECK_BITFIELD(reaction_type, CHEM_REACTION_CALM) || (!CHECK_BITFIELD(reaction_type, CHEM_REACTION_CALM) && !CHECK_BITFIELD(reaction_type, CHEM_REACTION_ENDOTHERMIC))) //force the reaction to occur if both options are disabled.
		for(var/required_reagent in required_reagents)
			holder.remove_reagent(required_reagent, (multiplier * required_reagents[required_reagent]), safety = TRUE)
		holder.add_reagent(result, result_amount*multiplier)
		for(var/secondary_result in secondary_results)
			holder.add_reagent(secondary_result, result_amount * secondary_results[secondary_result] * multiplier)
		playsound(get_turf(holder.my_atom), 'sound/effects/bubbles.ogg', 5, 1)

	if(CHECK_BITFIELD(reaction_type, CHEM_REACTION_BUBBLING))
		if(!HAS_TRAIT(holder.my_atom, TRAIT_REACTS_UNSAFELY))
			return
		var/datum/reagent/result_to_splash = GLOB.chemical_reagents_list[result]
		var/datum/reagent/recipe_to_splash = GLOB.chemical_reagents_list[pick(required_reagents)]
		playsound(get_turf(holder.my_atom), 'sound/effects/bubbles2.ogg', 5, 1)
		for(var/mob/living/carbon/human/victim in view(1, get_turf(holder.my_atom)))
			if(prob(20))
				to_chat(victim, SPAN_WARNING("\a Large [pick("chunk", "drop", "lump")] of foam misses You narrowly!"))
				return
			if(!(victim.wear_suit?.armor_bio > CLOTHING_ARMOR_HARDCORE) && created_volume >= 5)
				to_chat(victim, SPAN_BOLDWARNING("[holder.my_atom] chemicals from [holder.my_atom] splash on you!"))
				victim.reagents.add_reagent(result_to_splash.id, max(1+rand(0,2), floor(created_volume/6)+rand(0,1)))
				victim.reagents.add_reagent(recipe_to_splash.id, max(1+rand(0,2), floor(created_volume/6)+rand(0,1)))
				if(result_to_splash.get_property(PROPERTY_CORROSIVE) || recipe_to_splash.get_property(PROPERTY_CORROSIVE))//make a burning sound and flash if the reagents involved are corrosive
					playsound(victim, "acid_sizzle", 25, TRUE)
					animation_flash_color(victim, "#FF0000")

			else if (created_volume >= 5)
				to_chat(victim, SPAN_WARNING("[holder.my_atom] starts to bubble and fizzle violently!"))

	if(CHECK_BITFIELD(reaction_type, CHEM_REACTION_GLOWING))
		if(!HAS_TRAIT(holder.my_atom, TRAIT_REACTS_UNSAFELY))
			return
		var/list/seen = viewers(3, get_turf(holder.my_atom))
		var/datum/reagent/result_chemical = GLOB.chemical_reagents_list[result]
		for(var/mob/seen_mob in seen)
			if(prob(50))
				to_chat(seen_mob, SPAN_NOTICE("[icon2html(holder.my_atom, seen_mob)] [holder.my_atom] starts to glow!"))
		var/obj/item/device/flashlight/flare/on/illumination/chemical/chem_light = new(holder.my_atom, max(1,created_volume/2), result_chemical.burncolor)
		chem_light.set_light_color(result_chemical.burncolor)

	if(CHECK_BITFIELD(reaction_type, CHEM_REACTION_FIRE))
		if(!HAS_TRAIT(holder.my_atom, TRAIT_REACTS_UNSAFELY))
			return
		var/datum/reagent/reagent_to_burn = GLOB.chemical_reagents_list[result]
		if(timeleft(addtimer(CALLBACK(holder, TYPE_PROC_REF(/datum/reagents, combust), get_turf(holder.my_atom), 1, 3, 2, 2, reagent_to_burn.burncolor), 3 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)) == 3 SECONDS) //prevents smoke and sound
			var/list/seen = viewers(3, get_turf(holder.my_atom))
			for(var/mob/seen_mob in seen)
				to_chat(seen_mob, SPAN_WARNING("[icon2html(holder.my_atom, seen_mob)] [holder.my_atom] starts to smoke heavily!"))
			var/datum/effect_system/smoke_spread/bad/fire_smoke = new(holder.my_atom)
			fire_smoke.attach(holder.my_atom)
			fire_smoke.set_up(0,3 SECONDS, holder.my_atom)
			fire_smoke.start()
			playsound(get_turf(holder.my_atom), 'sound/effects/tankhiss3.ogg', 5, 45000, 4)

	if(CHECK_BITFIELD(reaction_type, CHEM_REACTION_SMOKING))
		if(!HAS_TRAIT(holder.my_atom, TRAIT_REACTS_UNSAFELY))
			return
		var/list/seen = viewers(3, get_turf(holder.my_atom))
		for(var/mob/seen_mob in seen)
			to_chat(seen_mob, SPAN_WARNING("[icon2html(holder.my_atom, seen_mob)] [holder.my_atom] starts to give heavy fumes from it's contents!"))
		addtimer(CALLBACK(src, PROC_REF(create_smoke_reaction), holder, created_volume), 4 SECONDS, TIMER_UNIQUE)
		playsound(get_turf(holder.my_atom), 'sound/effects/tankhiss3.ogg', 10, 30000, 4)// what a great sound where did it hide all this time

	if(CHECK_BITFIELD(reaction_type, CHEM_REACTION_ENDOTHERMIC))
		var/list/seen = viewers(0, get_turf(holder.my_atom))
		for(var/mob/seen_mob in seen)
			to_chat(seen_mob, SPAN_NOTICE("[icon2html(holder.my_atom, seen_mob)] [holder.my_atom] feels extremely cold to touch."))
		addtimer(CALLBACK(src, PROC_REF(handle_endothermic_reaction), holder, created_volume), 2 SECONDS, TIMER_UNIQUE)//this could easily be in process but I want to control the time


/datum/chemical_reaction/proc/add_to_filtered_list(reset = FALSE)
	if(reset)
		for(var/R in GLOB.chemical_reactions_filtered_list)
			LAZYREMOVE(GLOB.chemical_reactions_filtered_list[R], src)
	for(var/R in required_reagents)
		LAZYADD(GLOB.chemical_reactions_filtered_list[R], src)

/datum/chemical_reaction/proc/check_duplicate()
	for(var/R in required_reagents)
		if(GLOB.chemical_reactions_filtered_list[R])
			for(var/reaction in GLOB.chemical_reactions_filtered_list[R])//We filter the GLOB.chemical_reactions_filtered_list so we don't have to search through as much
				var/datum/chemical_reaction/C = reaction
				var/matches = 0
				for(var/B in required_reagents)
					if(C.required_reagents.Find(B))
						matches++
				if(matches >= length(required_reagents))
					return TRUE

// As funny as it may sound, spawning a chemical which's recipe is Bicaridine, Tramadol and Kelotane that instantly kills or cripple marine is not nice.
// To prevent such a situation, if ALL reagent inside a reaction are medical chemicals, the recipe is considered flawed.
/datum/chemical_reaction/proc/check_reaction_uses_all_default_medical()
	for(var/R in required_reagents)
		var/datum/reagent/M = GLOB.chemical_reagents_list[R]
		if(!(initial(M.flags) & REAGENT_TYPE_MEDICAL))
			return FALSE
	return TRUE

/datum/chemical_reaction/proc/create_smoke_reaction(datum/reagents/holder, created_volume)
	var/list/seen = viewers(2, get_turf(holder.my_atom))
	if(!CHECK_BITFIELD(holder.my_atom.flags_atom, OPENCONTAINER))
		for(var/mob/seen_mob in seen)
			to_chat(seen_mob, SPAN_NOTICE("[icon2html(holder.my_atom, seen_mob)] Lid on [src] prevents fumes from spreading around itself."))
		return
	for(var/mob/seen_mob in seen)
		to_chat(seen_mob, SPAN_NOTICE("[icon2html(holder.my_atom, seen_mob)] "))
		playsound(get_turf(holder.my_atom), 'sound/effects/bubbles.ogg', 15, 1)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/smoke_reaction = new /datum/effect_system/smoke_spread/chem
	smoke_reaction.attach(location)
	smoke_reaction.set_up(holder, max(1, rand(3,8)), 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 25, 1)
	INVOKE_ASYNC(smoke_reaction, TYPE_PROC_REF(/datum/effect_system/smoke_spread/chem, start))

/datum/chemical_reaction/proc/handle_endothermic_reaction(datum/reagents/holder, created_volume)//HOPEFULLY, we are already clear on stuff like beaker type or holder type by checks made earlier, so we are only checking if we have enough chemicals.
	var/required_reagents_present = 0
	var/required_catalysts_present = 0
	for(var/datum/reagent/reagent_in_holder in holder.reagent_list)
		if((reagent_in_holder.id in required_reagents) && reagent_in_holder.volume >= required_reagents[reagent_in_holder.id])
			required_reagents_present++
	for(var/datum/reagent/catalysts_in_holder in holder.reagent_list)
		if((catalysts_in_holder.id in catalysts_in_holder) && catalysts_in_holder.volume >= required_catalysts[catalysts_in_holder.id])
			required_catalysts_present++
	if(!(length(required_reagents) == required_reagents_present && length(required_catalysts) == required_catalysts_present))
		return
	var/list/seen = viewers(2, get_turf(holder.my_atom))
	if(prob(5))
		for(var/mob/seen_mob in seen)
			to_chat(seen_mob, SPAN_NOTICE("[icon2html(holder.my_atom, seen_mob)] The solution bubbles."))
			playsound(get_turf(holder.my_atom), 'sound/effects/bubbles.ogg', 15, 1)
	for(var/required_reagent in required_reagents)
		holder.remove_reagent(required_reagent, required_reagents[required_reagent], safety = TRUE)
	holder.add_reagent(result, result_amount)
	for(var/secondary_result in secondary_results)
		holder.add_reagent(secondary_result, result_amount * secondary_results[secondary_result])
	addtimer(CALLBACK(src, PROC_REF(handle_endothermic_reaction), holder, created_volume), 2 SECONDS, TIMER_UNIQUE)
