/*
	For more info about about this generation process, and for tables describing the generator, check the FDS: https://docs.google.com/document/d/1JHmMm48j-MlUN6hKBfw42grwBDuftbSabZHUxSHWqV8/edit?usp=sharing
	
	Important keywords:
		chemclass 						Determines how often a chemical will show up in the generation process
			CHEM_CLASS_NONE             0 Default. Chemicals not used in the generator
			CHEM_CLASS_BASIC            1 Chemicals that can be dispensed directly from the dispenser (iron, oxygen)
			CHEM_CLASS_COMMON           2 Chemicals that can be vended directly or have a very simple recipe (bicardine, ammonia, table salt)
			CHEM_CLASS_UNCOMMON         3 Chemicals which recipe is uncommonly known and made (spacedrugs, foaming agent)
			CHEM_CLASS_RARE             4 Chemicals without a recipe but can be obtained on the Almayer, or requires rare components
			CHEM_CLASS_SPECIAL          5 Chemicals without a recipe and can't be obtained on the Almayer, or requires special components
		gen_tier						Determines how many properties a generated chemical gets, the chance of the properties being good/negative, and how rare the required reagents are
		potency							Determines how strong the paired property is. Is an associative variable to each property

	- TobiNerd July 2019
*/

///////////////////////////////RECIPE GENERATOR///////////////////////////////
/datum/chemical_reaction/proc/generate_recipe()
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
		if(i==3 && (check_duplicate() || check_reaction_uses_all_default_medical()))
			required_reagents = list()
			i = 0

	//pick catalyst
	if(prob(40) || gen_tier >= 4)//chance of requiring a catalyst
		add_component(null,5,TRUE)
	
	return TRUE

/datum/chemical_reaction/proc/add_component(var/my_chemid,var/my_modifier,var/is_catalyst)
	var/chem_id		//The id of the picked chemical
	var/modifier	//The number of required reagents

	if(my_modifier) //Do we want a specific modifier?
		modifier = my_modifier
	else
		modifier = 1

	for(var/i=0,i<1,i++)
		if(my_chemid) //Do we want a specific chem?
			chem_id = my_chemid
		else
			var/roll = rand(0,100)
			switch(gen_tier)
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
				if(2)
					if(roll<=30)
						chem_id = pick(chemical_gen_classes_list["C1"])
					else if(roll<=55)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=70)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else
						chem_id = pick(chemical_gen_classes_list["C4"])
				if(3)
					if(roll<=10)
						chem_id = pick(chemical_gen_classes_list["C1"])
					else if(roll<=30)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=50)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else if(roll<=70)
						chem_id = pick(chemical_gen_classes_list["C4"])
					else
						chem_id = pick(chemical_gen_classes_list["C5"])
				else
					if(!required_reagents || is_catalyst)//first component is guaranteed special in chems tier 4 or higher, catalysts are always special in tier 4 or higher
						chem_id = pick(chemical_gen_classes_list["C5"])
					else if(roll<=15)
						chem_id = pick(chemical_gen_classes_list["C2"])
					else if(roll<=40)
						chem_id = pick(chemical_gen_classes_list["C3"])
					else if(roll<=65)
						chem_id = pick(chemical_gen_classes_list["C4"])

					else
						chem_id = pick(chemical_gen_classes_list["C5"])

		//if we are already using this reagent, try again
		if(required_reagents && required_reagents.Find(chem_id))
			if(my_chemid) //If this was a manually set chemid, return FALSE so we don't cause an infinite loop
				return FALSE
			else
				i--
				continue
		else if(is_catalyst)

			if(required_catalysts && required_catalysts.Find(chem_id))
				if(my_chemid) //If this was a manually set chemid, return FALSE so we don't cause an infinite loop
					return FALSE
				else
					i--
					continue
		var/list/component_modifier[0]
		component_modifier["[chem_id]"] = modifier
		if(is_catalyst) 
			required_catalysts += component_modifier
		else 
			required_reagents += component_modifier



	return chem_id

////////////////////////////////NAME GENERATOR////////////////////////////////
/datum/reagent/proc/generate_name()
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
	name = gen_name
	return name

//////////////////////////////REAGENT GENERATOR//////////////////////////////
/datum/reagent/proc/generate_stats(var/no_properties)
	//Properties
	if(!no_properties)
		var/gen_value
		for(var/i=0;i<gen_tier+1;i++)
			if(i == 0) //The first property is random to offset the value balance
				if(gen_tier > 3 || (gen_tier == 3 && prob(30)))
					gen_value = add_property(null,null,0,TRUE) //Give rare property
				else
					gen_value = add_property()
			else if(gen_value == gen_tier * 2 - 1) //If we are balanced, don't add any more
				break
			else
				gen_value += add_property(0,0, gen_tier - gen_value - 1) //add property based on our offset from the prefered balance

	//OD ratios
	overdose = 5
	for(var/i=1;i<=rand(1,11);i++) //We add 5 units to the overdose per cycle, min 5u, max 60u
		if(prob(40))//Deviating from 5 gets exponentially more rare.
			overdose += 5
	overdose_critical = overdose + 5
	for(var/i=1;i<=rand(1,5);i++) //overdose_critical is min 5u, to max 30u + normal overdose
		if(prob(20))
			overdose_critical += 5
		
	//Metabolism
	var/direction = rand(0,1) //the direction we deviate from 0.2
	for(var/i=1;i<=rand(1,8);i++) //min of 0.01 (barely metabolizes, but chance is 0.00065%, so it deserves to be this miraculous) to max 0.4 (neuraline)
		if(prob(40)) //Deviating from 0.2 gets exponentially more rare
			if(direction)
				custom_metabolism += 0.025
			else
				custom_metabolism -= 0.025
				if(custom_metabolism<0.01)
					custom_metabolism = 0.01
	
	//Color
	color = text("#[][][]",num2hex(rand(0,255)),num2hex(rand(0,255)),num2hex(rand(0,255)))
	burncolor = color
	
	//Description
	generate_description()
	return TRUE

/datum/reagent/proc/add_property(var/my_property, var/my_level, var/value_offset = 0, var/make_rare = FALSE)
	//Determine level modifier
	var/level
	if(my_level)
		level = my_level
	else
		level = rand(0,100)
		if(level<=25)
			level = 1 //25%
		else if(level<=46)
			level = 2 //21%
		else if(level<=64)
			level = 3 //18%
		else if(level<=79)
			level = 4 //15%
		else if(level<=89)
			level = 5 //10%
		else if(level<=95)
			level = 6 //7%
		else if(level<=98)
			level = 7 //3%
		else
			level = 8 //2%
		//We limit how potent chems can be. So something that is just level 8 healing doesn't spawn too regularly.
		level = min(level, gen_tier + 2)

	//Determine properties
	if(my_property)
		return insert_property(my_property, level)

	var/property
	var/roll = rand(1,100)
	if(make_rare)
		property = pick(chemical_properties_list["rare"])
	//Pick the property by value and roll
	else if(value_offset > 0) //Balance the value of our chemical
		property = pick(chemical_properties_list["positive"])
	else if(value_offset < 0)
		if(roll <= gen_tier*10)
			property = pick(chemical_properties_list["negative"])
		else
			property = pick(chemical_properties_list["neutral"])
	else
		switch(gen_tier)
			if(1)
				if(roll<=35)
					property = pick(chemical_properties_list["negative"])
				else if (roll<=75)
					property = pick(chemical_properties_list["neutral"])
				else
					property = pick(chemical_properties_list["positive"])
			if(2)
				if(roll<=30)
					property = pick(chemical_properties_list["negative"])
				else if (roll<=65)
					property = pick(chemical_properties_list["neutral"])
				else
					property = pick(chemical_properties_list["positive"])
			if(3)
				if(roll<=20)
					property = pick(chemical_properties_list["negative"])
				else if (roll<=50)
					property = pick(chemical_properties_list["neutral"])
				else
					property = pick(chemical_properties_list["positive"])
			else
				if(roll<=15)
					property = pick(chemical_properties_list["negative"])
				else if (roll<=40)
					property = pick(chemical_properties_list["neutral"])
				else
					property = pick(chemical_properties_list["positive"])
	
	var/datum/chem_property/P = chemical_properties_list[property]
	//Calculate what our chemical value is with our level
	var/new_value
	if(isNegativeProperty(P))
		new_value = -1 * level
	else if(isNeutralProperty(P))
		new_value = round(-1 * level / 2)
	else
		new_value = level

	insert_property(property, level)
	return new_value

/////////////////////////GENERATOR HELPER PROCS/////////////////////////

/datum/reagent/proc/insert_property(var/property, var/level)
	//The list below defines what properties should override each other.
	var/list/conflicting_properties = list(	PROPERTY_NUTRITIOUS = PROPERTY_HEMORRAGING,		PROPERTY_NUTRITIOUS = PROPERTY_HEMOLYTIC,		PROPERTY_TOXIC = PROPERTY_ANTITOXIC,\
											PROPERTY_CORROSIVE = PROPERTY_ANTICORROSIVE,	PROPERTY_BIOCIDIC = PROPERTY_NEOGENETIC,		PROPERTY_HYPERTHERMIC = PROPERTY_HYPOTHERMIC,\
											PROPERTY_NUTRITIOUS = PROPERTY_KETOGENIC,		PROPERTY_PAINING = PROPERTY_PAINKILLING,		PROPERTY_HALLUCINOGENIC = PROPERTY_ANTIHALLUCINOGENIC,\
											PROPERTY_HEPATOTOXIC = PROPERTY_HEPATOPEUTIC,	PROPERTY_NEPHROTOXIC = PROPERTY_NEPHROPEUTIC,	PROPERTY_PNEUMOTOXIC = PROPERTY_PNEUMOPEUTIC,\
											PROPERTY_OCULOTOXIC = PROPERTY_OCULOPEUTIC, 	PROPERTY_CARDIOTOXIC = PROPERTY_CARDIOPEUTIC,	PROPERTY_NEUROTOXIC = PROPERTY_NEUROPEUTIC,\
											PROPERTY_FLUXING = PROPERTY_REPAIRING, 			PROPERTY_RELAXING = PROPERTY_MUSCLESTIMULATING,	PROPERTY_HEMOGENIC = PROPERTY_HEMOLYTIC,\
											PROPERTY_HEMOGENIC = PROPERTY_HEMORRAGING,		PROPERTY_NUTRITIOUS = PROPERTY_EMETIC,\
											PROPERTY_HYPERGENETIC = PROPERTY_NEOGENETIC, 	PROPERTY_HYPERGENETIC = PROPERTY_HEPATOPEUTIC,	PROPERTY_HYPERGENETIC = PROPERTY_NEPHROPEUTIC,\
											PROPERTY_HYPERGENETIC = PROPERTY_PNEUMOPEUTIC,	PROPERTY_HYPERGENETIC = PROPERTY_OCULOPEUTIC, 	PROPERTY_HYPERGENETIC = PROPERTY_CARDIOPEUTIC,\
											PROPERTY_HYPERGENETIC = PROPERTY_NEUROPEUTIC,	PROPERTY_ADDICTIVE = PROPERTY_ANTIADDICTIVE,	PROPERTY_NEUROSHIELDING = PROPERTY_NEUROTOXIC,\
											PROPERTY_HYPOMETABOLIC = PROPERTY_HYPERMETABOLIC, PROPERTY_HYPERTHROTTLING = PROPERTY_NEUROINHIBITING,
											PROPERTY_FOCUSING = PROPERTY_NERVESTIMULATING, 	PROPERTY_THERMOSTABILIZING = PROPERTY_HYPERTHERMIC, PROPERTY_THERMOSTABILIZING = PROPERTY_HYPOTHERMIC,
											PROPERTY_AIDING = PROPERTY_NEUROINHIBITING, 	PROPERTY_OXYGENATING = PROPERTY_HYPOXEMIC,		PROPERTY_ANTICARCINOGENIC = PROPERTY_CARCINOGENIC, \
											PROPERTY_CIPHERING = PROPERTY_CIPHERING_PREDATOR)
	//The list below defines which properties should be combined into a combo property
	var/list/combining_properties = list(	PROPERTY_DEFIBRILLATING 	= list(PROPERTY_MUSCLESTIMULATING, PROPERTY_CARDIOPEUTIC),\
											PROPERTY_THANATOMETABOL 	= list(PROPERTY_HYPOXEMIC, PROPERTY_CRYOMETABOLIZING, PROPERTY_NEUROCRYOGENIC),\
											PROPERTY_HYPERDENSIFICATING = list(PROPERTY_MUSCLESTIMULATING, PROPERTY_BONEMENDING, PROPERTY_CARCINOGENIC),\
											PROPERTY_HYPERTHROTTLING 	= list(PROPERTY_PSYCHOSTIMULATING, PROPERTY_HALLUCINOGENIC),\
											PROPERTY_NEUROSHIELDING 	= list(PROPERTY_ALCOHOLIC, PROPERTY_BALDING),\
											PROPERTY_ANTIADDICTIVE		= list(PROPERTY_PSYCHOSTIMULATING, PROPERTY_ANTIHALLUCINOGENIC),\
											PROPERTY_ADDICTIVE 			= list(PROPERTY_PSYCHOSTIMULATING, PROPERTY_NEUROTOXIC),\
											PROPERTY_CIPHERING_PREDATOR = list(PROPERTY_CIPHERING, PROPERTY_CROSSMETABOLIZING))
	var/datum/chem_property/match
	var/datum/chem_property/initial_property
	for(var/datum/chem_property/P in properties)
		if(P.name == property)
			match = P
		else
			//Handle properties that combine
			for(var/C in combining_properties)
				var/list/combo = combining_properties[C]
				if(!combo.Find(property) || !combo.Find(P.name))
					continue
				var/pieces = 0
				for(var/piece in combo)
					if(piece == property || get_property(piece))
						pieces++
				if(pieces >= length(combo))
					initial_property = property
					property = C
					level = max(level - P.level, P.level - level, 1)
					for(var/datum/chem_property/R in properties)
						if(combo.Find(R.name) && !(R.category & PROPERTY_TYPE_CATALYST))
							R.level -= level
							if(R.level <= 0)
								properties.Remove(R)
					break
			//Handle properties that conflict
			for(var/C in conflicting_properties)
				if(property == C && P.name == conflicting_properties[C])
					match = P
					break
				else if (property == conflicting_properties[C] && C == P.name)
					match = P
					break
		if(match)
			//Handle changes in level
			if(match.level > level) //Decrease
				match.level -= level
				return FALSE
			else if(match.level < level) //Override
				level -= match.level
				remove_property(match.name)
			else //Cancelled out
				remove_property(match.name)
				return FALSE
			break
	//Insert the property
	var/datum/chem_property/P = chemical_properties_list[property]
	P = new P.type()
	P.level = level
	P.holder = src
	properties += P

   	//Special case: If it's a catalyst property, add it nonetheless.
	if(initial_property && initial_property != property)
		P =	chemical_properties_list[initial_property]
		if(P.category & PROPERTY_TYPE_CATALYST)
			P = new P.type()
			P.level = level
			P.holder = src
			properties += P

	recalculate_variables()
	return TRUE

/datum/reagent/proc/generate_description()
	var/info
	for(var/datum/chem_property/P in properties)
		info += "<BR><B>[capitalize(P.name)] Level [P.level]</B> - [P.description]<BR>"
		if(P == PROPERTY_HYPERTHERMIC)
			info += "<I>WARNING: Mixing too much at a time can cause spontanous ignition! Beware mixing more than the OD threshold!</I>"
		else if(P == PROPERTY_EXPLOSIVE)
			info += "<I>WARNING: Mixing too much at a time can cause spontanous explosion! Do not mix more than the OD threshold!</I>"
	description = info

/datum/reagent/proc/calculate_gen_tier(var/value)
	gen_tier = min(max(round(value / 4 - 1), 1), 4)

/datum/reagent/proc/calculate_value()
	var/value = 0
	for(var/datum/chem_property/P in properties)
		value += P.value * P.level
	return max(value, 3)

/datum/reagent/proc/generate_assoc_recipe()
	var/datum/chemical_reaction/generated/C = new /datum/chemical_reaction/generated
	C.id = id
	C.result = id
	C.name = name
	C.gen_tier = gen_tier
	C.generate_recipe()
	chemical_reactions_list[C.id] = C
	var/filter_id = C.get_filter()
	if(filter_id)
		chemical_reactions_filtered_list[filter_id] += C
	return C