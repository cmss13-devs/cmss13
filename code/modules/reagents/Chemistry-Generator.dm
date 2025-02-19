/*
	For more info about about this generation process, and for tables describing the generator, check the FDS: https://docs.google.com/document/d/1JHmMm48j-MlUN6hKBfw42grwBDuftbSabZHUxSHWqV8/edit?usp=sharing

	Important keywords:
		chemclass Determines how often a chemical will show up in the generation process
			CHEM_CLASS_NONE  0 Default. Chemicals not used in the generator
			CHEM_CLASS_BASIC 1 Chemicals that can be dispensed directly from the dispenser (iron, oxygen)
			CHEM_CLASS_COMMON    2 Chemicals that can be vended directly or have a very simple recipe (bicaridine, ammonia, table salt)
			CHEM_CLASS_UNCOMMON  3 Chemicals which recipe is uncommonly known and made (spacedrugs, foaming agent)
			CHEM_CLASS_RARE  4 Chemicals without a recipe but can be obtained on the Almayer, or requires rare components
			CHEM_CLASS_SPECIAL   5 Chemicals without a recipe and can't be obtained on the Almayer, or requires special components
		gen_tier Determines how many properties a generated chemical gets, the chance of the properties being good/negative, and how rare the required reagents are
		potency Determines how strong the paired property is. Is an associative variable to each property

	- TobiNerd July 2019
*/


//*****************************************************************************************************/
//***************************************Recipe Generator**********************************************/
//*****************************************************************************************************/

/datum/chemical_reaction/proc/generate_recipe(list/complexity)
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

	var/failed_attempts = 0 //safety for if a recipe can not be found
	//pick components
	for(var/i = 1, i <= 3, i++)
		if(i >= 2) //only the first component should have a modifier higher than 1
			modifier = 1
		if(complexity)
			add_component(my_modifier = modifier, class = complexity[i])
		else
			add_component(null, modifier)
		//make sure the final recipe is not already being used. If it is, start over.
		if(i == 3 && (check_duplicate() || check_reaction_uses_all_default_medical()))
			required_reagents = list()
			if(failed_attempts > 10)
				return FALSE
			i = 0
			failed_attempts++

	//pick catalyst
	if(prob(40) || gen_tier >= 4)//chance of requiring a catalyst
		add_component(null,5,TRUE)

	return TRUE

/datum/chemical_reaction/proc/add_component(my_chemid, my_modifier, is_catalyst, tier, class)
	var/chem_id //The id of the picked chemical
	var/modifier //The number of required reagents

	if(my_modifier) //Do we want a specific modifier?
		modifier = my_modifier
	else
		modifier = 1

	if(!tier)
		tier = gen_tier

	for(var/i = 0, i < 1, i++)
		if(my_chemid) //Do we want a specific chem?
			chem_id = my_chemid
		else if(class) //do we want a specific class?
			chem_id = pick(GLOB.chemical_gen_classes_list["C[class]"])
		else
			var/roll = rand(0,100)
			switch(tier)
				if(0)
					chem_id = pick(GLOB.chemical_gen_classes_list["C"])//If tier is 0, we can add any classed chemical
				if(1)
					if(roll<=35)
						chem_id = pick(GLOB.chemical_gen_classes_list["C1"])
					else if(roll<=65)
						chem_id = pick(GLOB.chemical_gen_classes_list["C2"])
					else if(roll<=85)
						chem_id = pick(GLOB.chemical_gen_classes_list["C3"])
					else
						chem_id = pick(GLOB.chemical_gen_classes_list["C4"])
				if(2)
					if(roll<=30)
						chem_id = pick(GLOB.chemical_gen_classes_list["C1"])
					else if(roll<=55)
						chem_id = pick(GLOB.chemical_gen_classes_list["C2"])
					else if(roll<=70)
						chem_id = pick(GLOB.chemical_gen_classes_list["C3"])
					else
						chem_id = pick(GLOB.chemical_gen_classes_list["C4"])
				if(3)
					if(roll<=10)
						chem_id = pick(GLOB.chemical_gen_classes_list["C1"])
					else if(roll<=30)
						chem_id = pick(GLOB.chemical_gen_classes_list["C2"])
					else if(roll<=50)
						chem_id = pick(GLOB.chemical_gen_classes_list["C3"])
					else if(roll<=70)
						chem_id = pick(GLOB.chemical_gen_classes_list["C4"])
					else
						chem_id = pick(GLOB.chemical_gen_classes_list["C5"])
				else
					if(!required_reagents || is_catalyst)//first component is more likely to be special in chems tier 4 or higher, catalysts are always special in tier 4 or higher
						if (prob(50))
							chem_id = pick(GLOB.chemical_gen_classes_list["C5"])
						else
							chem_id = pick(GLOB.chemical_gen_classes_list["C4"])
					else if(roll<=15)
						chem_id = pick(GLOB.chemical_gen_classes_list["C2"])
					else if(roll<=40)
						chem_id = pick(GLOB.chemical_gen_classes_list["C3"])
					else if(roll<=65)
						chem_id = pick(GLOB.chemical_gen_classes_list["C4"])

					else
						chem_id = pick(GLOB.chemical_gen_classes_list["C5"])

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

//*****************************************************************************************************/
//****************************************Name Generator***********************************************/
//*****************************************************************************************************/

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
		for(var/datum/reagent/R in GLOB.chemical_reagents_list)
			if(R.name == gen_name)//if we are already using this name, try again
				gen_name = ""
	//set name
	name = gen_name
	return name

//*****************************************************************************************************/
//***********************************Reagent Generator*************************************************/
//*****************************************************************************************************/

/datum/reagent/proc/generate_stats(no_properties)
	//Properties
	if(!no_properties)
		var/gen_value
		for(var/i=0;i<gen_tier+1;i++)
			if(i == 0) //The first property is random to offset the value balance
				if(gen_tier > 2)
					gen_value = add_property(null,null,0,TRUE) //Give rare property
				else
					gen_value = add_property(null,null,0,FALSE,TRUE)
			else if(gen_value == gen_tier * 2 - 1) //If we are balanced, don't add any more
				break
			else if(gen_tier < 3)
				gen_value += add_property(0,0, gen_tier - gen_value - 1,FALSE,TRUE) //add property based on our offset from the prefered balance
			else
				gen_value += add_property(0,0, gen_tier - gen_value - 1)
		while(LAZYLEN(properties) < gen_tier + 1) //We lost properties somewhere to conflicts, so add a random one until we're full
			add_property()

	//OD ratios
	overdose = 5
	for(var/i=1;i<=rand(1,11);i++) //We add 5 units to the overdose per cycle, min 5u, max 60u
		if(prob(50 + 5*gen_tier))//Deviating from 5 gets exponentially more rare, deviation scales with chem level
			overdose += 5
	overdose_critical = overdose + 5
	for(var/i=1;i<=rand(1,5);i++) //overdose_critical is min 5u, to max 30u + normal overdose
		if(prob(20 + 2*gen_tier))
			overdose_critical += 5

	//Color
	color = text("#[][][]",num2hex(rand(0,255)),num2hex(rand(0,255)),num2hex(rand(0,255)))
	burncolor = color

	//Description
	generate_description()
	return TRUE

/datum/reagent/proc/add_property(my_property, my_level, value_offset = 0, make_rare = FALSE, track_added_properties = FALSE)
	//Determine level modifier
	var/level
	if(my_level)
		level = my_level
	else
		level = rand(0,100)
		if(level<=20)
			level = 1 //20%
		else if(level<=40)
			level = 2 //20%
		else if(level<=60)
			level = 3 //20%
		else if(level<=75)
			level = 4 //25%
		else if(level<=85)
			level = 5 //10%
		else if(level<=90)
			level = 6 //5%
		else if(level<=95)
			level = 7 //5%
		else
			level = 8 //5%
		//We limit how potent chems can be. So something that is just level 8 healing doesn't spawn too regularly.
		level = min(level, gen_tier + 3)

	//Determine properties
	if(my_property)
		return insert_property(my_property, level)

	var/property
	var/roll = rand(1,100)
	if(make_rare)
		property = pick(GLOB.chemical_properties_list["rare"])
	//Pick the property by value and roll
	else if(value_offset > 0) //Balance the value of our chemical
		property = pick(GLOB.chemical_properties_list["positive"])
	else if(value_offset < 0)
		if(roll <= gen_tier*10)
			property = pick(GLOB.chemical_properties_list["negative"])
		else
			property = pick(GLOB.chemical_properties_list["neutral"])
	else
		switch(gen_tier)
			if(1)
				if(roll<=20)
					property = pick(GLOB.chemical_properties_list["negative"])
				else if (roll<=50)
					property = pick(GLOB.chemical_properties_list["neutral"])
				else
					property = pick(GLOB.chemical_properties_list["positive"])
			if(2)
				if(roll<=25)
					property = pick(GLOB.chemical_properties_list["negative"])
				else if (roll<=45)
					property = pick(GLOB.chemical_properties_list["neutral"])
				else
					property = pick(GLOB.chemical_properties_list["positive"])
			if(3)
				if(roll<=15)
					property = pick(GLOB.chemical_properties_list["negative"])
				else if (roll<=40)
					property = pick(GLOB.chemical_properties_list["neutral"])
				else
					property = pick(GLOB.chemical_properties_list["positive"])
			else
				if(roll<=15)
					property = pick(GLOB.chemical_properties_list["negative"])
				else if (roll<=40)
					property = pick(GLOB.chemical_properties_list["neutral"])
				else
					property = pick(GLOB.chemical_properties_list["positive"])

	if(track_added_properties) //Generated effects are more unique for lower-tier chemicals, but not higher-tier ones
		var/property_checks = 0
		while(!check_generated_properties(property) && property_checks < 4)
			property_checks++
			if(LAZYISIN(GLOB.chemical_properties_list["negative"], property))
				property = pick(GLOB.chemical_properties_list["negative"])
			else if(LAZYISIN(GLOB.chemical_properties_list["neutral"], property))
				property = pick(GLOB.chemical_properties_list["neutral"])
			else
				property = pick(GLOB.chemical_properties_list["positive"])

	var/datum/chem_property/P = GLOB.chemical_properties_list[property]
	if (level > P.max_level)
		level = min(P.max_level, level)

	//Calculate what our chemical value is with our level
	var/new_value
	if(isNegativeProperty(P))
		new_value = -1 * level
	else if(isNeutralProperty(P))
		new_value = floor(-1 * level / 2)
	else
		new_value = level

	insert_property(property, level)
	return new_value

//*****************************************************************************************************/
//***********************************Generator Helper Procs********************************************/
//*****************************************************************************************************/

/datum/reagent/proc/insert_property(property, level)
	var/datum/chem_property/match
	var/datum/chem_property/initial_property
	for(var/datum/chem_property/P in properties)
		if(P.name == property)
			match = P
		else
			//Handle properties that combine
			for(var/C in GLOB.combining_properties)
				var/list/combo = GLOB.combining_properties[C]
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
								LAZYREMOVE(properties, R)
					break
			//Handle properties that conflict
			for(var/C in GLOB.conflicting_properties)
				if(property == C && P.name == GLOB.conflicting_properties[C])
					match = P
					break
				else if (property == GLOB.conflicting_properties[C] && C == P.name)
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
	var/datum/chem_property/P = GLOB.chemical_properties_list[property]
	if (level > P.max_level)
		level = min(P.max_level, level) // double checking, in case some combo property has a max level and we want that respected
	P = new P.type()
	P.level = level
	P.holder = src
	LAZYADD(properties, P)

	//Special case: If it's a catalyst property, add it nonetheless.
	if(initial_property && initial_property != property)
		P = GLOB.chemical_properties_list[initial_property]
		if(P.category & PROPERTY_TYPE_CATALYST)
			P = new P.type()
			P.level = level
			P.holder = src
			LAZYADD(properties, P)

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

/datum/reagent/proc/generate_assoc_recipe(list/complexity)
	var/datum/chemical_reaction/generated/C = new /datum/chemical_reaction/generated
	C.id = id
	C.result = id
	C.name = name
	C.gen_tier = gen_tier
	if(!C.generate_recipe(complexity))
		return //Generating a recipe failed, so return null
	GLOB.chemical_reactions_list[C.id] = C
	C.add_to_filtered_list()
	return C

//Returns false if a property has been generated in a previous reagent and all properties of that category haven't been generated yet.
/datum/reagent/proc/check_generated_properties(datum/chem_property/P)
	if(LAZYISIN(GLOB.chemical_properties_list["positive"], P))
		if(LAZYISIN(GLOB.generated_properties["positive"], P) && LAZYLEN(GLOB.generated_properties["positive"]) < LAZYLEN(GLOB.chemical_properties_list["positive"]))
			return FALSE
		GLOB.generated_properties["positive"] += P
	else if(LAZYISIN(GLOB.chemical_properties_list["negative"], P))
		if(LAZYISIN(GLOB.generated_properties["negative"], P) && LAZYLEN(GLOB.generated_properties["negative"]) < LAZYLEN(GLOB.chemical_properties_list["negative"]))
			return FALSE
		GLOB.generated_properties["negative"] += P
	else if(LAZYISIN(GLOB.chemical_properties_list["neutral"], P))
		if(LAZYISIN(GLOB.generated_properties["neutral"], P) && LAZYLEN(GLOB.generated_properties["neutral"]) < LAZYLEN(GLOB.chemical_properties_list["neutral"]))
			return FALSE
		GLOB.generated_properties["neutral"] += P
	return TRUE

