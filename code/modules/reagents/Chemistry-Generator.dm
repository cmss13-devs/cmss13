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
		if(i==3 && check_duplicate())
			required_reagents = list()
			i = 0	
			chemical_objective_list[id] = 10
	
	//pick catalyst
	if(prob(40) || gen_tier >= 4)//chance of requiring a catalyst
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
					if(!required_reagents || is_catalyst)//first component is guaranteed special in chems tier 4 or higher, catalysts are always special in tier 4 or higher
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
		if(required_reagents && required_reagents.Find(chem_id))
			if(my_chemid) //If this was a manually set chemid, return FALSE so we don't cause an infinite loop
				return FALSE
			else
				i--
				continue
		else if(is_catalyst)
			new_objective_value += 20 //Worth a little more if it doesn't use up the rare reagent!
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

		chemical_objective_list[id] = chemical_objective_list[id] + new_objective_value

	return chem_id

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
	name = gen_name
	return name

/datum/reagent/proc/generate_stats(var/no_properties)
	..()
	//Properties
	if(!no_properties)
		var/gen_value
		for(var/i=0;i<gen_tier+1;i++)
			if(i == 0) //The first property is random to offset the value balance
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

//For properties that change stats
/datum/reagent/proc/update_stats()
	if(!properties)
		return
	for(var/P in properties)
		var/potency = properties[P] * 0.5
		switch(P)
			if(PROPERTY_NUTRITIOUS)
				nutriment_factor = potency
			if(PROPERTY_FUELING)
				chemfiresupp = TRUE
				durationmod = 0.4 * potency
				intensitymod = 0.2 * potency
			if(PROPERTY_OXIDIZING)
				chemfiresupp = TRUE
				durationmod = 0.2 * potency
				intensitymod = 0.4 * potency
			if(PROPERTY_FLOWING)
				chemfiresupp = TRUE
				radiusmod = 0.05 * potency
				durationmod = 0.1 * potency
				intensitymod = 0.1 * potency
			if(PROPERTY_VISCOUS)
				chemfiresupp = TRUE
				radiusmod = 0.05 * potency
				durationmod = 0.1 * potency
				intensitymod = 0.1 * potency
			if(PROPERTY_EXPLOSIVE)
				explosive = TRUE
				power = potency
				falloff_modifier =  2 / potency

/proc/get_negative_chem_properties(var/special_properties)
	var/list/negative_properties = list(PROPERTY_HYPOXEMIC = "Reacts with hemoglobin in red blood cells preventing oxygen from being absorbed, resulting in hypoxemia.",\
										PROPERTY_TOXIC = "Poisonous substance which causes harm on contact with or through absorption by organic tissues, resulting in bad health or severe illness.",\
										PROPERTY_CORROSIVE = "Damages or destroys other substances on contact through a chemical reaction. Causes chemical burns on contact with living tissue.",\
										PROPERTY_BIOCIDIC = "Ruptures cell membranes on contact, destroying most types of organic tissue.",\
										PROPERTY_HEMOLYTIC = "Causes intravascular hemolysis, resulting in the destruction of erythrocytes (red blood cells) in the bloodstream. This can result in Hemoglobinemia, where a high concentration of hemoglobin is released into the blood plasma.",\
										PROPERTY_HEMORRAGING = "Ruptures endothelial cells making up bloodvessels, causing blood to escape from the circulatory system.",\
										PROPERTY_CARCINOGENIC = "Penetrates the cell nucleus causing direct damage to the deoxyribonucleic acid in cells resulting in cancer and abnormal cell proliferation. In extreme cases causing hyperactive apoptosis and potentially atrophy.",\
										PROPERTY_HEPATOTOXIC = "Damages hepatocytes in the liver, resulting in liver deterioration and eventually liver failure.",\
										PROPERTY_NEPHROTOXIC = "Causes deterioration and damage to podocytes in the kidney resulting in potential kidney failure.",\
										PROPERTY_PNEUMOTOXIC = "Toxic substance which causes damage to connective tissue that forms the support structure (the interstitium) of the alveoli in the lungs.",\
										PROPERTY_OCULOTOXIC = "Damages the photoreceptive cells in the eyes impairing neural transmissions to the brain, resulting in loss of sight or blindness.",\
										PROPERTY_CARDIOTOXIC = "Attacks cardiomyocytes when passing through the heart in the bloodstream. This disrupts the cardiac cycle and can lead to cardiac arrest.",\
										PROPERTY_NEUROTOXIC = "Breaks down neurons causing widespread damage to the central nervous system and brain functions.")
										
	if(special_properties)
		negative_properties += list(	PROPERTY_EMBRYONIC = "The chemical agent carries causes an infection of type REDACTED parasitic embryonic organism.",\
										PROPERTY_TRANSFORMING = "The chemical agent carries REDACTED, altering the host psychologically and physically.",\
										PROPERTY_RAVENING = "The chemical agent carries the X-65 biological organism.")
	return negative_properties

/proc/get_neutral_chem_properties(var/special_properties)
	var/list/neutral_properties = list( PROPERTY_NUTRITIOUS = "The compound can be used as, or be broken into, nutrition for cell metabolism.",\
										PROPERTY_KETOGENIC = "Activates ketosis causing the liver to rapidly burn fatty acids and alcohols in the body, resulting in weight loss. Can cause ketoacidosis in high concentrations, resulting in a buildup of acids and lowered pH levels in the blood.",\
										PROPERTY_PAINING = "Activates the somatosensory system causing neuropathic pain all over the body. Unlike nociceptive pain, this is not caused to any tissue damage and is solely perceptive.",\
										PROPERTY_NEUROINHIBITING = "Inhibits neurological processes in the brain such to sight, hearing and speech which can result in various associated disabilities. Restoration will require surgery.",\
										PROPERTY_ALCOHOLIC = "Binds to glutamate neurotransmitters and gamma aminobutyric acid (GABA), slowing brain functions response to stimuli. This effect is also known as intoxication.",\
										PROPERTY_HALLUCINOGENIC = "Causes perception-like experiences that occur without an external stimulus, which are vivid and clear, with the full force and impact of normal perceptions, though not under voluntary control.",\
										PROPERTY_RELAXING = "Has a sedative effect on neuromuscular junctions depressing the force of muscle contractions. High concentrations can cause respiratory failure and cardiac arrest.",\
										PROPERTY_HYPERTHERMIC = "Causes an exothermic reaction when metabolized in the body, increasing internal body temperature. Warning: this can ignite chemicals on reaction.",\
										PROPERTY_HYPOTHERMIC = "Causes an endothermic reaction when metabolized in the body, decreasing internal body temperature.",\
										PROPERTY_BALDING = "Damages the hair follicles in the skin causing extreme alopecia, also refered to as baldness.",\
										PROPERTY_FLUFFING = "Accelerates cell division in the hair follicles resulting in random and excessive hairgrowth.",\
										PROPERTY_ALLERGENIC = "Creates a hyperactive immune response in the body, resulting in irritation.",\
										PROPERTY_CRYOMETABOLIZING = "The chemical is passively metabolized with no other effects in temperatures above 170 kelvin.",\
										PROPERTY_EUPHORIC = "Causes the release of endorphin hormones resulting intense excitement and happiness.",\
										PROPERTY_EMETIC = "Acts on the enteric nervous system to induce emesis, the forceful emptying of the stomach.",\
										PROPERTY_PSYCHOSTIMULATING = "Stimulates psychological functions causing increased awareness, focus and anti-depressing effects.",\
										PROPERTY_VISCOUS = "The chemical is thick and gooey due to high surface tension. It will not spread very far when spilled. This would decrease the radius of a chemical fire.",\
										PROPERTY_ANTIHALLUCINOGENIC = "Stabilizes perseptive abnormalities such as hallucinations caused by mindbreaker toxin.")
	if(special_properties)
		neutral_properties += list(		PROPERTY_CROSSMETABOLIZING = "The chemical can be metabolized in other humanoid lifeforms.")
	return neutral_properties

/proc/get_positive_chem_properties(var/special_properties)
	var/list/positive_properties = list(PROPERTY_ANTITOXIC = "Absorbs and neutralizes toxic chemicals in the bloodstream and allowing them to be excreted safely.",\
										PROPERTY_ANTICORROSIVE = "Accelerates cell division around corroded areas in order to replace the lost tissue. Excessive use can trigger apoptosis.",\
										PROPERTY_NEOGENETIC = "Regenerates ruptured membranes resulting in the repair of damaged organic tissue. High concentrations can corrode the cell membranes.",\
										PROPERTY_REPAIRING = "Repairs cybernetic organs by <B>REDACTED</B>.",\
										PROPERTY_HEMOGENIC = "Increases the production of erythrocytes (red blood cells) in the bonemarrow, leading to polycythemia, an elevated volume of erythrocytes in the blood.",\
										PROPERTY_NERVESTIMULATING = "Increases neuron communication speed across synapses resulting in improved reaction time, awareness and muscular control.",\
										PROPERTY_MUSCLESTIMULATING = "Stimulates neuromuscular junctions increasing the force of muscle contractions, resulting in increased strength. High doses might exhaust the cardiac muscles.",\
										PROPERTY_PAINKILLING = "Binds to opioid receptors in the brain and spinal cord reducing the amount of pain signals being sent to the brain.",\
										PROPERTY_HEPATOPEUTIC = "Treats deteriorated hepatocytes and damaged tissues in the liver, restoring organ functions.",\
										PROPERTY_NEPHROPEUTIC = "Heals damaged and deteriorated podocytes in the kidney, restoring organ functions.",\
										PROPERTY_PNEUMOPEUTIC = "Mends the interstitium tissue of the alveoli restoring respiratory functions in the lungs.",\
										PROPERTY_OCULOPEUTIC = "Restores sensory capabilities of photoreceptive cells in the eyes returning lost vision.",\
										PROPERTY_CARDIOPEUTIC = "Regenerates damaged cardiomyocytes and recovers a correct cardiac cycle and heart functionality.",\
										PROPERTY_NEUROPEUTIC = "Rebuilds damaged and broken neurons in the central nervous system re-establishing brain functionality.",\
										PROPERTY_BONEMENDING = "Rapidly increases the production of osteoblasts and chondroblasts while also accelerating the process of endochondral ossification. This allows broken bone tissue to be re-wowen and restored quickly if the bone is correctly positioned. Overdosing may result in the bone structure growing abnormally and can have adverse effects on the skeletal structure.",\
										PROPERTY_FLUXING = "Liquifies large crystalline and metallic structures under bodytemperature in the body and allows it to migrate to and be excreted through the skin.",\
										PROPERTY_NEUROCRYOGENIC = "Causes a temporal freeze of all neurological processes and cellular respirations in the brain. This allows the brain to be preserved for long periods of time.",\
										PROPERTY_ANTIPARASITIC = "Antimicrobial property specifically targeting parasitic pathogens in the body disrupting their growth and potentially killing them.",\
										PROPERTY_FUELING = "The chemical can be burned as a fuel, expanding the burn time of a chemical fire. However, this also lowers heat intensity.",\
										PROPERTY_OXIDIZING = "The chemical is oxidizing, increasing the intensity of chemical fires. However, the fuel is also burned faster because of it.",\
										PROPERTY_FLOWING = "The chemical is the opposite of viscous, and it tends to spill everywhere. This could probably be used to expand the radius of a chemical fire.",\
										PROPERTY_EXPLOSIVE = "The chemical is highly explosive. Do not ignite. Careful when handling, sensitivity is based off the OD threshold, which can lead to spontanous detonation.")
	if(special_properties)
		positive_properties += list(	PROPERTY_DEFIBRILLATING = "Causes an electrochemical reaction in the cardiac muscles, forcing the heart to continue pumping. May cause irregular heart rhythms.",\
										PROPERTY_OMNIPOTENT = "Fully revitalizes all bodily functions.",\
										PROPERTY_CURING = "Binds to and neutralizes the X-65 biological organism.")
	return positive_properties

/datum/reagent/proc/add_property(var/my_property, var/my_potency, var/value_offset = 0)
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
		if(potency<=25)
			potency = 1 //25%
		else if(potency<=46)
			potency = 2 //21%
		else if(potency<=64)
			potency = 3 //18%
		else if(potency<=79)
			potency = 4 //15%
		else if(potency<=89)
			potency = 5 //10%
		else if(potency<=95)
			potency = 6 //7%
		else if(potency<=98)
			potency = 7 //3%
		else
			potency = 8 //2%
		//We limit how potent chems can be. So something that is just level 8 healing doesn't spawn too regularly.
		potency = min(potency, gen_tier + 2)

	//Determine properties
	var/roll = rand(1,100)
	var/property
	if(my_property)
		property = my_property
	else if(value_offset > 0) //Balance the value of our chemical
		property = pick(positive_properties)
	else if(value_offset < 0)
		if(roll <= gen_tier*10)
			property = pick(negative_properties)
		else
			property = pick(neutral_properties)
	else
		switch(gen_tier)
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
	
	//Calculate what our chemical value is with our potency
	var/new_value
	if(negative_properties.Find(property))
		new_value = -1 * potency
	else if(neutral_properties.Find(property))
		new_value = round(-1 * potency / 2)
	else
		new_value = potency

	insert_property(property, potency)
	return new_value

/////////////////////////GENERATOR HELPER PROCS/////////////////////////

/datum/reagent/proc/insert_property(var/property, var/potency)
	if(properties)
		//The list below defines what properties should override each other.
		var/list/conflicting_properties = list(	PROPERTY_NUTRITIOUS = PROPERTY_HEMORRAGING,		PROPERTY_NUTRITIOUS = PROPERTY_HEMOLYTIC,		PROPERTY_TOXIC = PROPERTY_ANTITOXIC,\
												PROPERTY_CORROSIVE = PROPERTY_ANTICORROSIVE,	PROPERTY_BIOCIDIC = PROPERTY_NEOGENETIC,		PROPERTY_HYPERTHERMIC = PROPERTY_HYPOTHERMIC,\
												PROPERTY_NUTRITIOUS = PROPERTY_KETOGENIC,		PROPERTY_PAINING = PROPERTY_PAINKILLING,		PROPERTY_HALLUCINOGENIC = PROPERTY_ANTIHALLUCINOGENIC,\
												PROPERTY_HEPATOTOXIC = PROPERTY_HEPATOPEUTIC,	PROPERTY_NEPHROTOXIC = PROPERTY_NEPHROPEUTIC,	PROPERTY_PNEUMOTOXIC = PROPERTY_PNEUMOPEUTIC,\
												PROPERTY_OCULOTOXIC = PROPERTY_OCULOPEUTIC, 	PROPERTY_CARDIOTOXIC = PROPERTY_CARDIOPEUTIC,	PROPERTY_NEUROTOXIC = PROPERTY_NEUROPEUTIC,\
												PROPERTY_FLUXING = PROPERTY_REPAIRING, 			PROPERTY_RELAXING = PROPERTY_MUSCLESTIMULATING,	PROPERTY_HEMOGENIC = PROPERTY_HEMOLYTIC,\
												PROPERTY_HEMOGENIC = PROPERTY_HEMORRAGING,		PROPERTY_NUTRITIOUS = PROPERTY_EMETIC, 			PROPERTY_FLOWING = PROPERTY_VISCOUS)
		//The list below defines which properties should be combined into a combo property
		var/list/combining_properties = list(	PROPERTY_DEFIBRILLATING = list(PROPERTY_MUSCLESTIMULATING, PROPERTY_CARDIOPEUTIC))
		var/match
		for(var/P in properties)
			if(P == property)
				match = P
			else
				//Handle properties that combine
				for(var/C in combining_properties)
					var/list/combo = combining_properties[C]
					if(combo.Find(property))
						for(var/piece in combo)
							if(properties.Find(piece))
								property = C
								potency = max(potency - properties[P], properties[P] - potency, 1)
								properties -= P
								break
				//Handle properties that conflict
				for(var/C in conflicting_properties)
					if(property == C && P == conflicting_properties[C])
						match = P
						break
					else if (property == conflicting_properties[C] && C == P)
						match = P
						break
			if(match)
				//Handle changes in potency
				if(properties[match] > potency) //Decrease
					properties[match] -= potency
					return FALSE
				else if(properties[match] < potency) //Override
					potency -= properties[match]
					properties -= match
				else //Cancelled out
					properties -= match
					return FALSE
				break
		//Add the property
		var/list/property_potency[0]
		property_potency["[property]"] = potency
		properties += property_potency
		return TRUE

/datum/reagent/proc/generate_description()
	var/list/all_properties = get_negative_chem_properties(TRUE) + get_neutral_chem_properties(TRUE) + get_positive_chem_properties(TRUE)
	var/info
	for(var/P in properties)
		info += "<BR><B>[capitalize(P)] Level [properties[P]]</B> - [all_properties[P]]<BR>"
		if(P == PROPERTY_HYPERTHERMIC)
			info += "<I>WARNING: Mixing too much at a time can cause spontanous ignition!</I>"
		else if(P == PROPERTY_EXPLOSIVE)
			info += "<I>WARNING: Mixing too much at a time can cause spontanous explosion!</I>"
	description = info
