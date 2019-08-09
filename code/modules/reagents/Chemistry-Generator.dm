/*
	For more info about about this generation process, and for tables describing the generator, check the FDS: https://docs.google.com/document/d/1JHmMm48j-MlUN6hKBfw42grwBDuftbSabZHUxSHWqV8/edit?usp=sharing
	
	Important keywords:
		chemclass 						Determines how often a chemical will show up in the generation process
			CHEM_CLASS_NONE             0 Default. Chemicals not used in the generator
			CHEM_CLASS_BASIC            1 Chemicals that can be dispensed directly from the dispenser (iron, oxygen)
			CHEM_CLASS_COMMON           2 Chemicals which recipe is commonly known and made (bicardine, alkysine, salt)
			CHEM_CLASS_UNCOMMON         3 Chemicals which recipe is uncommonly known and made (spacedrugs, foaming agent)
			CHEM_CLASS_RARE             4 Chemicals without a recipe but can be obtained on the Almayer, or requires rare components
			CHEM_CLASS_SPECIAL          5 Chemicals without a recipe and can't be obtained on the Almayer, or requires special components
		gen_tier						Determines how many properties a generated chemical gets, the chance of the properties being good/negative, and how rare the required reagents are
		potency							Determines how strong the paired property is. Is an associative variable to each property

	- TobiNerd July 2019
*/

/datum/proc/save_chemical_classes() //Called from /datum/reagents/New()
	chemical_gen_classes_list = list("C","C1","C2","C3","C4","C5","C6","T1","T2","T3","T4")
	chemical_gen_classes_list["C"] = list()
	chemical_gen_classes_list["C1"] = list()
	chemical_gen_classes_list["C2"] = list()
	chemical_gen_classes_list["C3"] = list()
	chemical_gen_classes_list["C4"] = list()
	chemical_gen_classes_list["C5"] = list()
	chemical_gen_classes_list["C6"] = list()
	chemical_gen_classes_list["T1"] = list()
	chemical_gen_classes_list["T2"] = list()
	chemical_gen_classes_list["T3"] = list()
	chemical_gen_classes_list["T4"] = list()
	//Store all classed reagents so we can easily access chem IDs based on class.
	var/id
	var/chemclass
	var/gen_tier
	var/paths = typesof(/datum/reagent) - /datum/reagent //Can't use chemical_reagents_list here, RIP
	for(var/path in paths)
		var/datum/reagent/D = new path()
		id = D.id
		chemclass = D.chemclass
		gen_tier = D.gen_tier
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
					chemical_objective_list[id] = D.objective_value
				if(CHEM_CLASS_ULTRA)
					chemical_gen_classes_list["C6"] += id
					chemical_objective_list[id] = D.objective_value
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

///////////////////////////////RECIPE GENERATOR///////////////////////////////
/datum/chemical_reaction/proc/generate_recipe()
	..()
	//Determine modifier for uneven recipe balance
	var/modifier = rand(0,100)
	if(modifier<=60)
		modifier = 1
	else if(modifier<=75)
		modifier = 2
	else if(modifier<=85)
		modifier = 3
	else if(modifier<=92)
		modifier = 4
	else if(modifier<=97)
		modifier = 5
	else
		modifier = 6

	//pick components
	for(var/i=1,i<=3,i++)
		if(i>=2) //only the first component should have a modifier higher than 1
			modifier = 1
		add_component(null, modifier)
		//make sure the final recipe is not already being used. If it is, start over.
		if(i==3)
			var/matches = 0
			for(var/R in chemical_gen_reactions_list["[src.id]"]["required_reagents"])
				if(chemical_reactions_filtered_list[R])
					for(var/reaction in chemical_reactions_filtered_list[R])//We filter the chemical_reactions_filtered_list so we don't have to search through as much
						var/datum/chemical_reaction/C = reaction
						for(var/B in C.required_reagents)
							if(chemical_gen_reactions_list["[src.id]"]["required_reagents"].Find(B))
								matches++
			if(matches >= 3)
				chemical_gen_reactions_list["[src.id]"]["required_reagents"] = list()
				i = 0	
				chemical_objective_list[src.id] = 10
	
	//pick catalyst
	if(prob(40) || src.gen_tier >= 4)//chance of requiring a catalyst
		add_component(null,5,TRUE)
	
	return TRUE

/datum/chemical_reaction/proc/add_component(var/my_chemid,var/my_modifier,var/is_catalyst)
	..()
	var/chem_id		//The id of the picked chemical
	var/modifier	//The number of required reagents
	var/new_objective_value 

	if(my_modifier) //Do we want a specific modifier?
		modifier = my_modifier
	else
		modifier = 1

	for(var/i=0,i<1,i++)
		new_objective_value = 0
		if(my_chemid) //Do we want a specific chem?
			chem_id = my_chemid
		else
			var/roll = rand(0,100)
			switch(src.gen_tier)
				if(0)
					chem_id = pick(chemical_gen_classes_list["C"])//If gen_tier is 0, we can add any classed chemical
				if(1)
					if(roll<=35)
						chem_id = pick(chemical_gen_classes_list["C1"])
					else if(roll<=65)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=85)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else
						chem_id = pick(chemical_gen_classes_list["C4"])
						new_objective_value += OBJECTIVE_MEDIUM_VALUE
				if(2)
					if(roll<=30)
						chem_id = pick(chemical_gen_classes_list["C1"])
					else if(roll<=55)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=70)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else
						chem_id = pick(chemical_gen_classes_list["C4"])
						new_objective_value += OBJECTIVE_MEDIUM_VALUE
				if(3)
					if(roll<=10)
						chem_id = pick(chemical_gen_classes_list["C1"])
					else if(roll<=30)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=50)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else if(roll<=70)
						chem_id = pick(chemical_gen_classes_list["C4"])
						new_objective_value += OBJECTIVE_MEDIUM_VALUE
					else
						chem_id = pick(chemical_gen_classes_list["C5"])
						new_objective_value += OBJECTIVE_HIGH_VALUE
				else
					if(!chemical_gen_reactions_list["[src.id]"]["required_reagents"] || is_catalyst)//first component is guaranteed special in chems tier 4 or higher, catalysts are always special in tier 4 or higher
						chem_id = pick(chemical_gen_classes_list["C5"])
						new_objective_value += OBJECTIVE_HIGH_VALUE
					else if(roll<=15)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=40)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else if(roll<=65)
						chem_id = pick(chemical_gen_classes_list["C4"])
						new_objective_value += OBJECTIVE_MEDIUM_VALUE
					else
						chem_id = pick(chemical_gen_classes_list["C5"])
						new_objective_value += OBJECTIVE_HIGH_VALUE
			
		//if we are already using this reagent, try again
		if(chemical_gen_reactions_list["[src.id]"]["required_reagents"])
			if(chemical_gen_reactions_list["[src.id]"]["required_reagents"].Find(chem_id))
				if(my_chemid) //If this was a manually set chemid, return FALSE so we don't cause an infinite loop
					return FALSE
				else
					i--
					continue
		else if(is_catalyst)
			new_objective_value += 20 //Worth a little more if it doesn't use up the rare reagent!
			if(chemical_gen_reactions_list["[src.id]"]["required_catalysts"])
				if(chemical_gen_reactions_list["[src.id]"]["required_catalysts"].Find(chem_id))
					if(my_chemid) //If this was a manually set chemid, return FALSE so we don't cause an infinite loop
						return FALSE
					else
						i--
						continue
		
		var/list/component_modifier[0]
		component_modifier["[chem_id]"] = modifier
		if(is_catalyst) 
			chemical_gen_reactions_list["[src.id]"]["required_catalysts"] += component_modifier
		else 
			chemical_gen_reactions_list["[src.id]"]["required_reagents"] += component_modifier

		chemical_objective_list[src.id] = chemical_objective_list[src.id] + new_objective_value

	return TRUE

////////////////////////////////NAME GENERATOR////////////////////////////////
/datum/reagent/proc/generate_name()
	..()
	/*We can't make use of this currently because reagents are initialised before reactions. Might fix this at a later date.
	if(modifier > 6)
		modifier = 6
	var/list/numprefix = list("Mono","Di","Tri","Tetra","Penta","Hexa")*/
	//PLEASE KEEP THE LISTS BELOW ALPHABETICALLY SORTED FOR CONVENIENCE (wordroot is sorted by start and end vowels)
	var/list/prefix = list("Alph","At","Aw","Az","Bar","Bet","Bren","Bor","Cak","Cal","Cath","Cet","Con","Dal","De","Dean","Delt","Dox","Em","Ep","Ethr","Far","Feth","Fohs","Het","Hydr","Hyper","Ian","In","Iot","Jam","Kan","Kap","Kil","Kl","Kol","Lar","Lin","Loz","Meg","Meth","Mn","Mnem","Mit","Mor","Mut","Nath","Neth","Nov","Nux","Pas","Pax","Per","Ph","Phr","Quaz","Rath","Ret","Rol","Sal","Sig","Stim","Super","Tau","Te","Th","Thet","Throx","Ul","Up","Ven","Vic","Xen","Xeon","Xit","Xir","Zar","Zet","Zol")
	var/list/wordroot = list("a","adia","agha","ama","amma","anthra","ara","ata","ade","alde","ale","ange","arpe","anthe","aze","azide","adefi","ami","ari","assi","athi","avi","azi","ado","alope","arpo","alto","aquo","agu","alnu","aphnu","axu","adhy","any","aphy","awy","e","ea","ega","enna","epina","era","erma","etha","eva","exa","edre","etre","epe","ephe","exe","efi","emni","esli","eno","elto","eto","evo","elnu","epu","ethu","equ","edry","ely","ety","evy","i","ia","ie","iqua","ipha","ista","ira","itra","iphe","imne","ine","isse","ihi","ini","itri","izi","ico","iglo","iho","ino","isto","immu","inu","ixu","izu","idy","immy","ithy","ity","isty","o","oga","olna","omna","ora","oxa","oghe","one","ore","oste","ove","oi","ogi","oni","orphi","owni","oxi","ocho","ommo","osto","odru","oru","owu","oxu","odry","omny","oxy","u","ua","uga","unga","uppa","ura","ugre","une","use","uve","udri","uli","unni","utri","uthri","uo","uclo","uno","uto","uu","uphu","umnu","uru","udry","uly","upy","urvy","y","ya","ydra","yla","ytha","yna","yxa","ye","ylfe","ymne","ylre","yse","ytre","yani","yphi","ypi","yvi","yo","ylo","ypho","yro","ydro","ynu","ysto","ytro","yxu","yru","ydy")
	var/list/suffix = list("cin","cene","cin","cine","cone","din","dine","dol","done","drate","drine","fen","fene","fic","gar","gen","l","lem","lin","line","lis","mel","mide","mite","mol","n","ne","nt","phrine","r","rene","rine","ry","ride","rium","rus","sene","sine","sone","sp","stol","tane","tant","tene","tine","thol","tic","um","vene","vone","x","xene","xin","xine","zene","zine","zone")
	var/gen_name = ""
	//Assemble name
	while(!gen_name)
		gen_name = addtext(pick(prefix),pick(wordroot),pick(suffix))
		//Make sure this name is not already used
		for(var/datum/reagent/R in chemical_reagents_list)
			if(R.name == gen_name)//if we are already using this name, try again
				gen_name = ""
	//set name
	chemical_gen_stats_list["[src.id]"]["name"] = gen_name
	return gen_name

/datum/reagent/proc/generate_stats(var/no_properties)
	..()
	//Properties
	if(!no_properties)
		for(var/i=0;i<src.gen_tier+1;i++)
			add_property()
	
	//OD ratios
	var/gen_overdose = 5
	for(var/i=1;i<=rand(1,11);i++) //We add 5 units to the overdose per cycle, min 5u, max 60u
		if(prob(30))//Deviating from 5 gets exponentially more rare.
			gen_overdose += 5
	var/gen_overdose_critical = gen_overdose + 5
	for(var/i=1;i<=rand(1,5);i++) //overdose_critical is min 5u, to max 30u + normal overdose
		if(prob(20))
			gen_overdose_critical += 5
	
	chemical_gen_stats_list["[src.id]"]["overdose"] = gen_overdose
	chemical_gen_stats_list["[src.id]"]["overdose_critical"] = gen_overdose_critical
	
	//Nutriment factor
	var/gen_nutriment_factor = 0
	if(prob(5)) //5% chance of even having a nutriment_factor > 0
		gen_nutriment_factor = 0.5
		src.add_property("nutritious") //add the property nutritious
		for(var/i=1;i<=rand(1,5);i++) //min 0.5, to max 3 (the nutriment factor of pure nutriment)
			if(prob(60))//Deviating from 0.5 gets exponentially more rare.
				gen_nutriment_factor += 0.5
		
	chemical_gen_stats_list["[src.id]"]["nutriment_factor"] = gen_nutriment_factor

	//Metabolism
	var/gen_custom_metabolism = 0.2
	var/direction = rand(0,1) //the direction we deviate from 0.2
	for(var/i=1;i<=rand(1,8);i++) //min of 0.01 (barely metabolizes, but chance is 0.00065%, so it deserves to be this miraculous) to max 0.4 (neuraline)
		if(prob(40)) //Deviating from 0.2 gets exponentially more rare
			if(direction)
				gen_custom_metabolism += 0.025
			else
				gen_custom_metabolism -= 0.025
				if(gen_custom_metabolism<0.01)
					gen_custom_metabolism = 0.01
	
	chemical_gen_stats_list["[src.id]"]["custom_metabolism"] = gen_custom_metabolism
	
	//Color
	var/gen_color = text("#[][][]",num2hex(rand(0,255)),num2hex(rand(0,255)),num2hex(rand(0,255)))
	chemical_gen_stats_list["[src.id]"]["color"] = gen_color
	
	return TRUE

/datum/proc/get_negative_chem_properties()
	var/list/negative_properties = list(PROPERTY_HYPOXEMIC,PROPERTY_TOXIC,PROPERTY_CAUSTIC,PROPERTY_BIOCIDIC,PROPERTY_RADIOACTIVE,PROPERTY_KETOGENIC,PROPERTY_HEMOLYTIC,PROPERTY_CARCINOGENIC,PROPERTY_PAINING,PROPERTY_NEUROINHIBITING,PROPERTY_ALCOHOLIC,PROPERTY_HALLUCINOGENIC,PROPERTY_HEPATOTOXIC,PROPERTY_NEPHROTOXIC,PROPERTY_PNEUMOTOXIC,PROPERTY_OCULOTOXIC,PROPERTY_CARDIOTOXIC,PROPERTY_NEUROTOXIC,PROPERTY_NEUROSEDATIVE)
	return negative_properties

/datum/proc/get_neutral_chem_properties()
	var/list/neutral_properties = list(PROPERTY_HYPERTHERMIC,PROPERTY_HYPOTHERMIC,PROPERTY_BALDING,PROPERTY_FLUFFING,PROPERTY_IRRITATING,PROPERTY_ENJOYABLE,PROPERTY_GASTROTOXIC,PROPERTY_PSYCHOSTIMULATING,PROPERTY_ANTIHALLUCINOGENIC)
	return neutral_properties

/datum/proc/get_positive_chem_properties()
	var/list/positive_properties = list(PROPERTY_ANTITOXIC,PROPERTY_ANTICAUSTIC,PROPERTY_BIOPEUTIC,PROPERTY_REPAIRING,PROPERTY_NERVESTIMULATING,PROPERTY_MUSCLESTIMULATING,PROPERTY_PAINKILLING,PROPERTY_HEPATOPEUTIC,PROPERTY_NEPHROPEUTIC,PROPERTY_PNEUMOPEUTIC,PROPERTY_OCULOPEUTIC,PROPERTY_CARDIOPEUTIC,PROPERTY_NEUROPEUTIC,PROPERTY_BONEMENDING,PROPERTY_FLUXING,PROPERTY_NEUROCRYOGENIC,PROPERTY_ANTIPARASITIC)
	return positive_properties

/datum/reagent/proc/add_property(var/my_property, var/my_potency)
	..()
	var/list/negative_properties = get_negative_chem_properties()
	var/list/neutral_properties = get_neutral_chem_properties()
	var/list/positive_properties = get_positive_chem_properties()
	
	//Determine potency modifier
	var/potency
	if(my_potency)
		potency = my_potency
	else
		potency = rand(0,100)
		if(potency<=45)
			potency = 1
		else if(potency<=80)
			potency = 2
		else if(potency<=95)
			potency = 3
		else
			potency = 4
		//We limit how potent tier 1 chems can be. So something that is just level 4 healing doesn't spawn too regularly.
		if(src.gen_tier < 2 && potency > 2)
			potency = 2
		//We also limit tier 2 a bit
		else if(src.gen_tier < 3 && potency > 3)
			potency = 2

	//Determine properties
	var/roll = rand(1,100)
	var/property
	if(my_property)
		property = my_property
	else
		switch(src.gen_tier)
			if(1)
				if(roll<=35)
					property = pick(negative_properties)
				else if (roll<=75)
					property = pick(neutral_properties)
				else
					property = pick(positive_properties)
			if(2)
				if(roll<=30)
					property = pick(negative_properties)
				else if (roll<=65)
					property = pick(neutral_properties)
				else
					property = pick(positive_properties)
			if(3)
				if(roll<=20)
					property = pick(negative_properties)
				else if (roll<=50)
					property = pick(neutral_properties)
				else
					property = pick(positive_properties)
			else
				if(roll<=15)
					property = pick(negative_properties)
				else if (roll<=40)
					property = pick(neutral_properties)
				else
					property = pick(positive_properties)
	
	//Override conflicting properties
	if(chemical_gen_stats_list["[src.id]"]["properties"])
		//The list below defines what properties should override each other.
		var/list/conflicting_properties = list(PROPERTY_TOXIC = PROPERTY_ANTITOXIC,PROPERTY_CAUSTIC = PROPERTY_ANTICAUSTIC,PROPERTY_BIOCIDIC = PROPERTY_BIOPEUTIC,PROPERTY_HYPERTHERMIC = PROPERTY_HYPOTHERMIC,PROPERTY_NUTRITIOUS = PROPERTY_KETOGENIC,PROPERTY_PAINING = PROPERTY_PAINKILLING,PROPERTY_HALLUCINOGENIC = PROPERTY_ANTIHALLUCINOGENIC,PROPERTY_HEPATOTOXIC = PROPERTY_HEPATOPEUTIC,PROPERTY_NEPHROTOXIC = PROPERTY_NEPHROPEUTIC,PROPERTY_PNEUMOTOXIC = PROPERTY_PNEUMOPEUTIC, PROPERTY_OCULOTOXIC = PROPERTY_OCULOPEUTIC, PROPERTY_CARDIOTOXIC = PROPERTY_CARDIOPEUTIC,PROPERTY_NEUROTOXIC = PROPERTY_NEUROPEUTIC, PROPERTY_FLUXING = PROPERTY_REPAIRING, PROPERTY_NEUROSEDATIVE = PROPERTY_MUSCLESTIMULATING)
		var/match
		for(var/P in chemical_gen_stats_list["[src.id]"]["properties"])
			if(P == property)
				match = P
			else
				for(var/C in conflicting_properties)
					if(property == C && P == conflicting_properties[C])
						match = P
						break
					else if (property == conflicting_properties[C] && C == P)
						match = P
						break
			if(match)
				chemical_gen_stats_list["[src.id]"]["properties"] -= match
				break
	
	//Still need to make a check to ensure we don't get conflicting properties
	var/list/property_potency[0]
	property_potency["[property]"] = potency
	chemical_gen_stats_list["[src.id]"]["properties"] += property_potency
	return property_potency

/////////////////////////RANDOMLY GENERATED CHEMICALS/////////////////////////
/datum/chemical_reaction/generated/
	result_amount = 1 //Makes it a bit harder to mass produce
	gen_tier = 0

/datum/reagent/generated/
	reagent_state = LIQUID //why isn't this default, seriously
	var/list/properties = list() //Decides properties
	chemclass = CHEM_CLASS_ULTRA
	objective_value = 10
	gen_tier = 0

/datum/reagent/generated/New()
	//Generate stats
	if(!chemical_gen_stats_list["[src.id]"])
		var/list/stats_holder = list("name","properties","overdose","overdose_critical","nutriment_factor","custom_metabolism","color")
		chemical_gen_stats_list["[src.id]"] += stats_holder
		generate_name()
		generate_stats()
	name = chemical_gen_stats_list["[src.id]"]["name"]
	properties = chemical_gen_stats_list["[src.id]"]["properties"]
	overdose = chemical_gen_stats_list["[src.id]"]["overdose"]
	overdose_critical = chemical_gen_stats_list["[src.id]"]["overdose_critical"]
	nutriment_factor = chemical_gen_stats_list["[src.id]"]["nutriment_factor"]
	custom_metabolism = chemical_gen_stats_list["[src.id]"]["custom_metabolism"]
	color = chemical_gen_stats_list["[src.id]"]["color"]

/datum/chemical_reaction/generated/New()
	//Generate recipe
	if(!chemical_gen_reactions_list)
		chemical_gen_reactions_list = list()
	if(!chemical_gen_reactions_list["[src.id]"])
		var/list/recipe_holder = list("required_reagents","required_catalysts")
		chemical_gen_reactions_list["[src.id]"] += recipe_holder
		generate_recipe()
	required_reagents = chemical_gen_reactions_list["[src.id]"]["required_reagents"]
	required_catalysts = chemical_gen_reactions_list["[src.id]"]["required_catalysts"]

/////////Tier 1
//alpha
/datum/chemical_reaction/generated/alpha
	id = "alpha"
	result = "alpha"
	gen_tier = 1
		
/datum/reagent/generated/alpha
	id = "alpha"
	gen_tier = 1
		
/datum/chemical_reaction/generated/beta
	id = "beta"
	result = "beta"
	gen_tier = 1
		
/datum/reagent/generated/beta
	id = "beta"
	gen_tier = 1
		
/datum/chemical_reaction/generated/gamma
	id = "gamma"
	result = "gamma"
	gen_tier = 1
		
/datum/reagent/generated/gamma
	id = "gamma"
	gen_tier = 1

/////////Tier 2
/datum/chemical_reaction/generated/delta
	id = "delta"
	result = "delta"
	gen_tier = 2
		
/datum/reagent/generated/delta
	id = "delta"
	gen_tier = 2

/datum/chemical_reaction/generated/epsilon
	id = "epsilon"
	result = "epsilon"
	gen_tier = 2

/datum/reagent/generated/epsilon
	id = "epsilon"
	gen_tier = 2

/datum/chemical_reaction/generated/zeta
	id = "zeta"
	result = "zeta"
	gen_tier = 2

/datum/reagent/generated/zeta
	id = "zeta"
	gen_tier = 2

/////////Tier 3 zeta
/datum/chemical_reaction/generated/eta
	id = "eta"
	result = "eta"
	gen_tier = 3

/datum/reagent/generated/eta
	id = "eta"
	gen_tier = 3

/datum/chemical_reaction/generated/theta
	id = "theta"
	result = "theta"
	gen_tier = 3

/datum/reagent/generated/theta
	id = "theta"
	gen_tier = 3

/datum/chemical_reaction/generated/iota
	id = "iota"
	result = "iota"
	gen_tier = 3

/datum/reagent/generated/eta
	id = "iota"
	gen_tier = 3

/////////Tier 4
/datum/chemical_reaction/generated/kappa
	id = "kappa"
	result = "kappa"
	gen_tier = 4

/datum/reagent/generated/kappa
	id = "kappa"
	gen_tier = 4

/////////////////////////PROCESS/////////////////////////
/*
	//Template
	if("keyword") //(in layman's terms)
				if(M.stat == DEAD) <-- add this if we don't want it to work while dead
					return
				if(overdose && volume >= overdose)
					//overdose stuff
					if(overdose_critical && volume > overdose_critical)
						//critical overdose stuff
				else
					//normal stff
*/
/datum/reagent/generated/on_mob_life(mob/living/M, alien)
	holder.remove_reagent(id, custom_metabolism) //By default it slowly disappears.
	var/is_OD
	var/is_COD
	if(overdose && volume >= overdose)
		is_OD = 1
		if(overdose_critical && volume > overdose_critical)
			is_COD = 1
		
	if(alien == IS_XENOS || alien == IS_YAUTJA || alien == IS_HORROR) return

	for(var/P in properties)
		var/potency = properties[P]
		if(!potency) continue
		switch(P)
/////////Negative Properties/////////
			if(PROPERTY_HYPOXEMIC) //(oxygen damage)
				if(is_OD)
					//overdose stuff
					M.apply_damages(potency*2, 0, potency*2)
					M.adjustOxyLoss(4*potency)
					if(is_COD)
						//critical overdose stuff
						M.apply_damages(potency*10, 0, potency*4)
				else
					//normal stuff
					M.adjustOxyLoss(2*potency)
				if(prob(10)) M.emote("gasp")
			if(PROPERTY_TOXIC) //toxin damage
				if(is_OD)
					M.adjustToxLoss(potency*2)
					if(is_COD)
						M.adjustToxLoss(potency*4)
				else
					M.adjustToxLoss(potency)
			if(PROPERTY_CAUSTIC) //burn damage
				if(is_OD)
					M.take_limb_damage(0,1*potency)
					if(is_COD)
						M.take_limb_damage(0,2*potency)
				else
					M.take_limb_damage(0,potency)
			if(PROPERTY_BIOCIDIC) //brute damage
				if(is_OD)
					M.take_limb_damage(1*potency)
					if(is_COD)
						M.take_limb_damage(2*potency)
				else
					M.take_limb_damage(potency)
			if(PROPERTY_RADIOACTIVE) //radiation damage
				if(is_OD)
					M.radiation += 2*potency
					if(is_COD)
						M.radiation += 4*potency
				else
					M.radiation += potency
			if(PROPERTY_KETOGENIC) //weight loss
				if(is_OD)
					M.nutrition = max(M.nutrition - 10*potency, 0)
					M.overeatduration = 0
					if(is_COD)
						M.apply_damages(2*potency, 2*potency)
				else
					M.nutrition = max(M.nutrition - 5*potency, 0)
					M.overeatduration = 0
			if(PROPERTY_HEMOLYTIC) //blood loss
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(C)
						if(is_OD)
							C.blood_volume -= 6*potency
							if(is_COD)
								C.blood_volume -= 6*potency
						else
							C.blood_volume = max(C.blood_volume-4*potency,0)
			if(PROPERTY_CARCINOGENIC) //clone damage
				if(is_OD)
					M.adjustCloneLoss(2*potency)
					if(is_COD)
						var/mob/living/carbon/human/C = M
						if(C)
							var/datum/limb/L = pick(C.limbs)
							if(L && L.name != "head" && prob(10*potency))
								L.droplimb()
				else
					M.adjustCloneLoss(0.5*potency)
			if(PROPERTY_PAINING) //pain
				if(is_OD)
					M.reagent_pain_modifier += 50*potency
					M.take_limb_damage(1*potency)
					if(is_COD)
						M.take_limb_damage(2*potency)
				else
					M.reagent_pain_modifier += 50*potency
			if(PROPERTY_NEUROINHIBITING) //disabilities
				if(is_OD)
					M.adjustBrainLoss(potency)
					M.disabilities = NERVOUS
					if(is_COD)
						M.adjustBrainLoss(2*potency)
				if(potency > 1)
					M.sdisabilities = BLIND
				else
					M.disabilities = NEARSIGHTED
				if(potency > 2)
					M.sdisabilities = DEAF
				if(potency > 3)
					M.sdisabilities = MUTE
			if(PROPERTY_ALCOHOLIC) //drunkness
				if(is_OD)
					M.confused += 2*potency
					M.drowsyness += 2*potency
					M.adjustToxLoss(0.5*potency)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
						if(L)
							L.damage += 0.5*potency
							if(is_COD)
								L.damage += 2*potency
				else
					M.confused += potency
					M.drowsyness += potency
			if(PROPERTY_HALLUCINOGENIC) //hallucinations
				if(prob(10)) M.emote(pick("twitch","drool","moan","giggle"))
				if(is_OD)
					if(isturf(M.loc) && !istype(M.loc, /turf/open/space))
						if(M.canmove && !M.is_mob_restrained())
							if(prob(10)) step(M, pick(cardinal))
					M.hallucination += 10
					M.make_jittery(5)
					M.knocked_out = max(M.knocked_out, 20)
					if(is_COD)
						M.adjustBrainLoss(1*potency)
				else
					if(potency>2)
						M.hallucination += potency
					M.druggy += potency
					M.make_jittery(5)
					M.drowsyness += 0.25*potency
			if(PROPERTY_HEPATOTOXIC) //liver damage 
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_NEPHROTOXIC) //kidney damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/kidneys/L = H.internal_organs_by_name["kidneys"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_PNEUMOTOXIC) //lung damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/lungs/L = H.internal_organs_by_name["lungs"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_OCULOTOXIC) //eye damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/eyes/L = H.internal_organs_by_name["eyes"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							if(is_COD)
								M.adjustBrainLoss(0.5*potency)
						else
							L.damage += 1.75*potency
			if(PROPERTY_CARDIOTOXIC) //heart damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_NEUROTOXIC) //brain damage
				if(is_OD)
					M.adjustBrainLoss(1*potency)
					M.jitteriness = max(M.jitteriness + potency,0)
					if(prob(50)) M.drowsyness = max(M.drowsyness+potency, 3)
					if(prob(10)) M.emote("drool")
					if(is_COD)
						if(prob(15*potency))
							apply_neuro(M, 2*potency, FALSE)
				else
					M.adjustBrainLoss(1.75*potency)
			if(PROPERTY_NEUROSEDATIVE) //slows movement
				if(is_OD)
					if(prob(15*potency))
						M.KnockOut(potency)
					if(is_COD)
						//heart stops beating
						M.adjustOxyLoss(potency)
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
							if(E)
								E.damage += 0.75*potency
				else
					M.reagent_move_delay_modifier += 1*potency
					if(prob(10)) M.emote("yawn")
/////////Neutral Properties///////// 
			if(PROPERTY_HYPERTHERMIC) //increase bodytemperature
				if(prob(10)) M.emote("gasp")
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature+4*potency,0)
					M.drowsyness  = max(M.drowsyness, 40)
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.bodytemperature = max(M.bodytemperature+1.5*potency,0)
			if(PROPERTY_HYPOTHERMIC) //decrease bodytemperature
				if(prob(10)) M.emote("shiver")
				if(is_OD)
					M.drowsyness  = max(M.drowsyness, 40)
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.bodytemperature = max(M.bodytemperature-potency,0)
			if(PROPERTY_BALDING) //unga
				if(is_OD)
					M.adjustCloneLoss(0.5*potency)
					if(is_COD)
						M.adjustCloneLoss(1*potency)
				if(prob(5*potency))
					var/mob/living/carbon/human/H = M
					if(H)
						if((H.h_style != "Bald" || H.f_style != "Shaved"))
							to_chat(M, SPAN_WARNING("Your hair falls out."))
							H.h_style = "Bald"
							H.f_style = "Shaved"
							H.update_hair()
			if(PROPERTY_FLUFFING) //hair growth
				if(is_OD)
					if(prob(5*potency))
						to_chat(M, SPAN_WARNING("You feel itchy all over!"))
						M.take_limb_damage(potency) //Hair growing inside your body
						if(is_COD)
							to_chat(M, SPAN_WARNING("You feel like something is penetrating your skull!"))
							M.adjustBrainLoss(potency)//Hair growing into brain
				if(prob(5*potency))
					var/mob/living/carbon/human/H = M
					if(H)
						H.h_style = "Bald"
						H.f_style = "Shaved"
						H.h_style = random_hair_style(H.gender, H.species)
						H.f_style = random_facial_hair_style(MALE, H.species)
						H.update_hair()
						to_chat(M, SPAN_NOTICE("Your head feels different..."))
			if(PROPERTY_IRRITATING) //sneezing, itching etc.
				if(prob(5*potency)) M.emote(pick("sneeze","blink","cough"))
			if(PROPERTY_ENJOYABLE) //HAHAHAHA
				if(is_OD)
					if(prob(5*potency)) M.emote("collapse") //ROFL
				if(prob(5*potency)) M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))
			if(PROPERTY_GASTROTOXIC) //vomiting
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H)
						if(is_OD)
							M.adjustToxLoss(0.5*potency)
							if(is_COD)
								M.adjustToxLoss(0.5*potency)
						else
							H.vomit() //vomit() already has a timer on in
			if(PROPERTY_PSYCHOSTIMULATING) //calming messages
				if(is_OD)
					M.adjustBrainLoss(potency)
					if(is_COD)
						M.hallucination += 200
						M.adjustBrainLoss(4*potency)
				else
					if(volume <= 0.1) if(data != -1)
						data = -1
						if(potency == 1)
							to_chat(M, SPAN_WARNING("Your mind feels a little less stable..."))
						else if(potency == 2)
							to_chat(M, SPAN_WARNING("You lose focus..."))
						else if(potency == 3)
							to_chat(M, SPAN_WARNING("Your mind feels much less stable..."))
						else 
							to_chat(M, SPAN_WARNING("You lose your perfect focus..."))
					else
						if(world.time > data + 3000)
							data = world.time
							if(potency == 1)
								to_chat(M, SPAN_NOTICE("Your mind feels stable.. a little stable."))
								M.confused = max(M.confused-1,0)
							else if(potency == 2)
								to_chat(M, SPAN_NOTICE("Your mind feels focused and undivided."))
								M.confused = max(M.confused-2,0)
							else if(potency == 3)
								to_chat(M, SPAN_NOTICE("Your mind feels much more stable."))
								M.confused = max(M.confused-3,0)
							else
								to_chat(M, SPAN_NOTICE("Your mind feels perfectly focused."))
								M.confused = 0
			if(PROPERTY_ANTIHALLUCINOGENIC) //removes hallucinations
				if(is_OD)
					M.apply_damage(potency, TOX)
					if(is_COD)
						M.apply_damages(potency, potency, 3*potency)
				else
					holder.remove_reagent("mindbreaker", 5)
					holder.remove_reagent("space_drugs", 5)
					M.hallucination = max(0, M.hallucination - 10)
					M.druggy = max(0, M.druggy - 10)
/////////Positive Properties///////// 
			if(PROPERTY_NUTRITIOUS) //only picked if nutriment factor > 0
				M.nutrition += nutriment_factor * potency
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(C.blood_volume < BLOOD_VOLUME_NORMAL)
						C.blood_volume += 0.2 * nutriment_factor * potency
			if(PROPERTY_ANTITOXIC) //toxin healing
				if(is_OD)
					M.drowsyness  = max(M.drowsyness, 30)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
						if(E)
							E.damage += potency
						if(is_COD)
							E.damage += 2*potency
				else
					M.adjustToxLoss(-(0.25+potency))
			if(PROPERTY_ANTICAUSTIC) //burn healing
				if(is_OD)
					M.apply_damages(potency, 0, potency) //Mixed brute/tox damage
					if(is_COD)
						M.apply_damages(potency*2, 0, potency*2) //Massive brute/tox damage
				else
					M.heal_limb_damage(0, 0.25+potency)
			if(PROPERTY_BIOPEUTIC) //brute healing
				if(is_OD)
					M.apply_damage(potency, BURN)
					if(is_COD)
						M.apply_damages(0, 4*potency, 2*potency)
				else
					M.heal_limb_damage(0.25+potency, 0)
			if(PROPERTY_REPAIRING) //cybernetic repairing
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(4*potency)
				else
					var/mob/living/carbon/human/C = M
					if(C)
						var/datum/limb/L = pick(C.limbs)
						if(L)
							if(L.status & LIMB_ROBOT)
								L.heal_damage(2*potency,2*potency,0,1)
			if(PROPERTY_NERVESTIMULATING) //stun decrease
				if(prob(10)) M.emote("twitch")
				if(is_OD)
					M.adjustBrainLoss(1*potency)
					M.jitteriness = max(M.jitteriness + potency,0)
					if(prob(50)) M.drowsyness = max(M.drowsyness+potency, 3)
					if(is_COD)
						M.KnockOut(potency*2)
				else
					if(potency>2)
						M.AdjustKnockedout(-potency)
						M.AdjustStunned(-potency)
						M.AdjustKnockeddown(-potency)
					else
						M.AdjustStunned(-0.5*potency)
					M.stuttering = max(M.stuttering-2*potency, 0)
					M.confused = max(M.confused-2*potency, 0)
					M.eye_blurry = max(M.eye_blurry-2*potency, 0)
					M.drowsyness = max(M.drowsyness-2*potency, 0)
					M.dizziness = max(M.dizziness-2*potency, 0)
					M.jitteriness = max(M.jitteriness-2*potency, 0)

			if(PROPERTY_MUSCLESTIMULATING) //increases movement
				if(prob(10)) M.emote(pick("twitch","blink_r","shiver"))
				if(is_OD)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
						if(E)
							E.damage += 0.5*potency
							if(is_COD)
								E.damage += 1*potency
								M.take_limb_damage(0.5*potency)
				else
					M.reagent_move_delay_modifier -= 0.2*potency
			if(PROPERTY_PAINKILLING) //painkiller
				if(is_OD)
					M.hallucination = max(M.hallucination, potency) //Hallucinations and tox damage
					M.apply_damage(potency, TOX)
					if(is_COD)
						M.apply_damage(potency*2, TOX) //Massive liver damage
				else
					M.reagent_pain_modifier += -30*potency
			if(PROPERTY_HEPATOPEUTIC) //liver healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_NEPHROPEUTIC) //kidney healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/kidneys/L = H.internal_organs_by_name["kidneys"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_PNEUMOPEUTIC) //lung healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/lungs/L = H.internal_organs_by_name["lungs"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_OCULOPEUTIC) //eye healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
					if(is_OD)
						M.apply_damage(2, TOX)
						if(E)
							E.damage += potency
						if(is_COD)
							M.adjustBrainLoss(potency)
					else
						if(E)
							if(E.damage > 0)
								E.damage = max(E.damage - 0.5*potency, 0)
			if(PROPERTY_CARDIOPEUTIC) //heart healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_NEUROPEUTIC) //brain healing
				if(is_OD)
					M.apply_damage(potency, TOX)
					if(is_COD)
						M.adjustBrainLoss(3 * potency)
						M.AdjustStunned(potency)
				else
					M.adjustBrainLoss(-3 * potency)
			if(PROPERTY_BONEMENDING) //repairs bones
				var/mob/living/carbon/human/C = M
				if(C)
					var/datum/limb/L = pick(C.limbs)
					if(L)
						if(is_OD)
							M.take_limb_damage(potency)
							if(is_COD)
								L.fracture()
						else
							if(prob(10*potency))
								if(L.knitting_time > 0) break // only one knits at a time
								switch(L.name)
									if("groin","chest")
										L.time_to_knit = 1200 // 10 mins
									if("head")
										L.time_to_knit = 1200 // 10 mins
									if("l_hand","r_hand","r_foot","l_foot")
										L.time_to_knit = 600 // 5 mins
									if("r_leg","r_arm","l_leg","l_arm")
										L.time_to_knit = 600 // 5 mins
								if(L.time_to_knit && (L.status & LIMB_BROKEN))
									if(L.knitting_time == -1 && (L.status & LIMB_SPLINTED))
										var/total_knitting_time = world.time + L.time_to_knit - 150*potency
										L.knitting_time = total_knitting_time
										L.start_processing()
										to_chat(M, SPAN_NOTICE("You feel the bones in your [L.display_name] starting to knit together."))			
			if(PROPERTY_FLUXING) //dissolves metal shrapnel
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(4*potency)
				else
					var/mob/living/carbon/human/C = M
					if(C)
						var/datum/limb/L = pick(C.limbs)
						if(L && prob(10*potency))
							if(L.status & LIMB_ROBOT)
								L.take_damage(0,2*potency)
								break
							if(L.implants)
								var/obj/implanted_object = pick(L.implants)
								if(implanted_object)
									L.implants -= implanted_object
			if(PROPERTY_ANTIPARASITIC) //potency 1 is enough to pause embryo growth. Higher will degrade it)
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(4*potency)
				else
					var/mob/living/carbon/human/H = M
					if(H)
						for(var/content in H.contents)
							var/obj/item/alien_embryo/A = content
							if(A)
								if(A.counter)
									A.counter = max(A.counter - 1+potency,0)
									H.take_limb_damage(0,0.2*potency)
								else
									A.stage--
									if(A.stage <= 0)//if we reach this point, the embryo dies and the occupant takes a nasty amount of acid damage
										A.Dispose()
										H.take_limb_damage(0,rand(20,40))
										H.vomit()
									else
										A.counter = 90

			if(PROPERTY_NEUROCRYOGENIC) //slows brain death
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature-5*potency,0)
					if(is_COD)
						M.adjustBrainLoss(5 * potency)
				else //effects while dead are handled by handle_necro_chemicals_in_body()
					if(prob(20)) to_chat(M, SPAN_WARNING("You feel like you have the worst brain freeze ever!"))
					M.knocked_out = max(M.knocked_out, 20)
					M.stunned = max(M.stunned,21)
/////////ADMIN ONLY PROPERTIES/////////
/*
Ideas for admin properties:
	 - Properties to allow metabolization in xenos and predators
	 - Adminorazine (omnipotent)
	 - Gives larva infection
	 - Zombie infection
	 - Monkey infection
*/