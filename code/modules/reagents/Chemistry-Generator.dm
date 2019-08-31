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
	if(chemical_gen_stats_list["[src.id]"]["properties"] && PROPERTY_NUTRITIOUS in chemical_gen_stats_list["[src.id]"]["properties"])
		gen_nutriment_factor = 0.5
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

/datum/proc/get_negative_chem_properties(var/admin_properties)
	var/list/negative_properties = list(PROPERTY_HYPOXEMIC = "Reacts with hemoglobin in red blood cells preventing oxygen from being absorbed, resulting in hypoxemia.",\
										PROPERTY_TOXIC = "Poisonous substance which causes harm on contact with or through absorption by organic tissues, resulting in bad health or severe illness.",\
										PROPERTY_CORROSIVE = "Damages or destroys other substances on contact through a chemical reaction. Causes chemical burns on contact with living tissue.",\
										PROPERTY_BIOCIDIC = "Ruptures cell membranes on contact, destroying most types of organic tissue.",\
										PROPERTY_RADIOACTIVE = "The elements in the compound are unstable, causing an emission of ionizing radiation.",\
										PROPERTY_HEMOLYTIC = "Causes intravascular hemolysis, resulting in the destruction of erythrocytes (red blood cells) in the bloodstream. This can result in Hemoglobinemia, where a high concentration of hemoglobin is released into the blood plasma.",\
										PROPERTY_HEMORRAGING = "Ruptures endothelial cells making up bloodvessels, causing blood to escape from the circulatory system.",\
										PROPERTY_CARCINOGENIC = "Penetrates the cell nucleus causing direct damage to the deoxyribonucleic acid in cells resulting in cancer and abnormal cell proliferation. In extreme cases causing hyperactive apoptosis and potentially atrophy.",\
										PROPERTY_NECROTIZING = "The chemical eats through and rots flesh, causing infections and necrosis. High concentrations may penetrate the bone tissue and cause osteonecrosis.",\
										PROPERTY_HEPATOTOXIC = "Damages hepatocytes in the liver, resulting in liver deterioration and eventually liver failure.",\
										PROPERTY_NEPHROTOXIC = "Causes deterioration and damage to podocytes in the kidney resulting in potential kidney failure.",\
										PROPERTY_PNEUMOTOXIC = "Toxic substance which causes damage to connective tissue that forms the support structure (the interstitium) of the alveoli in the lungs.",\
										PROPERTY_OCULOTOXIC = "Damages the photoreceptive cells in the eyes impairing neural transmissions to the brain, resulting in loss of sight or blindness.",\
										PROPERTY_CARDIOTOXIC = "Attacks cardiomyocytes when passing through the heart in the bloodstream. This disrupts the cardiac cycle and can lead to cardiac arrest.",\
										PROPERTY_NEUROTOXIC = "Breaks down neurons causing widespread damage to the central nervous system and brain functions.")
										
	if(admin_properties)
		negative_properties += list(	PROPERTY_EMBRYONIC = "The chemical agent carries causes an infection of type REDACTED parasitic embryonic organism.",\
										PROPERTY_TRANSFORMING = "The chemical agent carries REDACTED, altering the host psychologically and physically.",\
										PROPERTY_RAVENING = "Binds to and neutralizes the X-65 biological organism.")
	return negative_properties

/datum/proc/get_neutral_chem_properties(var/admin_properties)
	var/list/neutral_properties = list( PROPERTY_KETOGENIC = "Activates ketosis causing the liver to rapidly burn fatty acids and alcohols in the body, resulting in weight loss. Can cause ketoacidosis in high concentrations, resulting in a buildup of acids and lowered pH levels in the blood.",\
										PROPERTY_PAINING = "Activates the somatosensory system causing neuropathic pain all over the body. Unlike nociceptive pain, this is not caused to any tissue damage and is solely perceptive.",\
										PROPERTY_NEUROINHIBITING = "Inhibits neurological processes in the brain such to sight, hearing and speech which can result in various associated disabilities. Restoration will require surgery.",\
										PROPERTY_ALCOHOLIC = "Binds to glutamate neurotransmitters and gamma aminobutyric acid (GABA), slowing brain functions response to stimuli. This effect is also known as intoxication.",\
										PROPERTY_HALLUCINOGENIC = "Causes perception-like experiences that occur without an external stimulus, which are vivid and clear, with the full force and impact of normal perceptions, though not under voluntary control.",\
										PROPERTY_RELAXING = "Has a sedative effect on neuromuscular junctions depressing the force of muscle contractions. High concentrations can cause respiratory failure and cardiac arrest.",\
										PROPERTY_HYPERTHERMIC = "Causes an endothermic reaction when metabolized in the body, decreasing internal body temperature.",\
										PROPERTY_HYPOTHERMIC = "Causes an exothermic reaction when metabolized in the body, increasing internal body temperature.",\
										PROPERTY_BALDING = "Damages the hair follicles in the skin causing extreme alopecia, also refered to as baldness.",\
										PROPERTY_FLUFFING = "Accelerates cell division in the hair follicles resulting in random and excessive hairgrowth.",\
										PROPERTY_ALLERGENIC = "Creates a hyperactive immune response in the body, resulting in irritation.",\
										PROPERTY_CRYOMETABOLIZING = "The chemical is passively metabolized with no other effects in temperatures above 170 kelvin.",\
										PROPERTY_EUPHORIC = "Causes the release of endorphin hormones resulting intense excitement and happiness.",\
										PROPERTY_EMETIC = "Acts on the enteric nervous system to induce emesis, the forceful emptying of the stomach.",\
										PROPERTY_PSYCHOSTIMULATING = "Stimulates psychological functions causing increased awareness, focus and anti-depressing effects.",\
										PROPERTY_ANTIHALLUCINOGENIC = "Stabilizes perseptive abnormalities such as hallucinations caused by mindbreaker toxin.")
	if(admin_properties)
		neutral_properties += list(		PROPERTY_CROSSMETABOLIZING = "The chemical can be metabolized in other humanoid lifeforms.")
	return neutral_properties

/datum/proc/get_positive_chem_properties(var/admin_properties)
	var/list/positive_properties = list(PROPERTY_NUTRITIOUS = "The compound can be used as, or be broken into, nutrition for cell metabolism.",\
										PROPERTY_ANTITOXIC = "Absorbs and neutralizes toxic chemicals in the bloodstream and allowing them to be excreted safely.",\
										PROPERTY_ANTICORROSIVE = "Accelerates cell division around corroded areas in order to replace the lost tissue. Excessive use can trigger apoptosis.",\
										PROPERTY_NEOGENETIC = "Regenerates ruptured membranes resulting in the repair of damaged organic tissue. High concentrations can corrode the cell membranes.",\
										PROPERTY_REPAIRING = "Repairs cybernetic organs by <B>REDACTED</B>.",\
										PROPERTY_HEMOGENIC = "Increases the production of erythrocytes (red blood cells) in the bonemarrow, leading to polycythemia, an elevated volume of erythrocytes in the blood.",\
										PROPERTY_NERVESTIMULATING = "Increases neuron communication speed across synapses resulting in improved reaction time, awareness and muscular control.",\
										PROPERTY_MUSCLESTIMULATING = "Stimulates neuromuscular junctions increasing the force of muscle contractions, resulting in increased strength. High doses might exhaust the cardiac muscles.",\
										PROPERTY_PAINKILLING = "Binds to opioid receptors in the brain and spinal cord reducing the amount of pain signals being sent to the brain.",\
										PROPERTY_ANTISEPTIC = "Powerful antiseptic that removes internal infections by killing germs. High concentrations are toxic, but is more effective and can potentially remove necrosis.",\
										PROPERTY_HEPATOPEUTIC = "Treats deteriorated hepatocytes and damaged tissues in the liver, restoring organ functions.",\
										PROPERTY_NEPHROPEUTIC = "Heals damaged and deteriorated podocytes in the kidney, restoring organ functions.",\
										PROPERTY_PNEUMOPEUTIC = "Mends the interstitium tissue of the alveoli restoring respiratory functions in the lungs.",\
										PROPERTY_OCULOPEUTIC = "Restores sensory capabilities of photoreceptive cells in the eyes returning lost vision.",\
										PROPERTY_CARDIOPEUTIC = "Regenerates damaged cardiomyocytes and recovers a correct cardiac cycle and heart functionality.",\
										PROPERTY_NEUROPEUTIC = "Rebuilds damaged and broken neurons in the central nervous system re-establishing brain functionality.",\
										PROPERTY_BONEMENDING = "Rapidly increases the production of osteoblasts and chondroblasts while also accelerating the process of endochondral ossification. This allows broken bone tissue to be re-wowen and restored quickly if the bone is correctly positioned. Overdosing may result in the bone structure growing abnormally and can have adverse effects on the skeletal structure.",\
										PROPERTY_FLUXING = "Liquifies large crystalline and metallic structures under bodytemperature in the body and allows it to migrate to and be excreted through the skin.",\
										PROPERTY_NEUROCRYOGENIC = "Causes a temporal freeze of all neurological processes and cellular respirations in the brain. This allows the brain to be preserved for long periods of time.",\
										PROPERTY_ANTIPARASITIC = "Antimicrobial property specifically targeting parasitic pathogens in the body disrupting their growth and potentially killing them.")
	if(admin_properties)
		positive_properties += list(	PROPERTY_OMNIPOTENT = "Fully revitalizes all bodily functions.",\
										PROPERTY_CURING = "Binds to and neutralizes the X-65 biological organism.")
	return positive_properties

/datum/reagent/proc/add_property(var/my_property, var/my_potency)
	..()
	var/list/negative_properties = get_negative_chem_properties()
	var/list/neutral_properties = get_neutral_chem_properties()
	var/list/positive_properties = get_positive_chem_properties()
	var/list/all_properties = negative_properties + neutral_properties + positive_properties
	
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
	var/info
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
		var/list/conflicting_properties = list(PROPERTY_TOXIC = PROPERTY_ANTITOXIC,PROPERTY_CORROSIVE = PROPERTY_ANTICORROSIVE,PROPERTY_BIOCIDIC = PROPERTY_NEOGENETIC,PROPERTY_HYPERTHERMIC = PROPERTY_HYPOTHERMIC,PROPERTY_NUTRITIOUS = PROPERTY_KETOGENIC,PROPERTY_PAINING = PROPERTY_PAINKILLING,PROPERTY_HALLUCINOGENIC = PROPERTY_ANTIHALLUCINOGENIC,PROPERTY_HEPATOTOXIC = PROPERTY_HEPATOPEUTIC,PROPERTY_NEPHROTOXIC = PROPERTY_NEPHROPEUTIC,PROPERTY_PNEUMOTOXIC = PROPERTY_PNEUMOPEUTIC, PROPERTY_OCULOTOXIC = PROPERTY_OCULOPEUTIC, PROPERTY_CARDIOTOXIC = PROPERTY_CARDIOPEUTIC,PROPERTY_NEUROTOXIC = PROPERTY_NEUROPEUTIC, PROPERTY_FLUXING = PROPERTY_REPAIRING, PROPERTY_RELAXING = PROPERTY_MUSCLESTIMULATING,PROPERTY_ANTISEPTIC = PROPERTY_NECROTIZING,PROPERTY_HEMOGENIC = PROPERTY_HEMOLYTIC,PROPERTY_HEMOGENIC = PROPERTY_HEMORRAGING)
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
	//Handle description
			else
				info += text("<BR><B>[]</B> - []<BR>",capitalize(P),all_properties["[P]"]) //We only keep the description we didn't override
	
	info += text("<BR><B>[]</B> - []<BR>",capitalize(property),all_properties["[property]"]) //We add the description for the new property

	var/list/property_potency[0]
	property_potency["[property]"] = potency
	chemical_gen_stats_list["[src.id]"]["properties"] += property_potency
	chemical_gen_stats_list["[src.id]"]["description"] = info
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
		var/list/stats_holder = list("name","properties","description","overdose","overdose_critical","nutriment_factor","custom_metabolism","color")
		chemical_gen_stats_list["[src.id]"] += stats_holder
		generate_name()
		generate_stats()
	name = chemical_gen_stats_list["[src.id]"]["name"]
	properties = chemical_gen_stats_list["[src.id]"]["properties"]
	description = chemical_gen_stats_list["[src.id]"]["description"]
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

/datum/reagent/generated/iota
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
	if("keyword")
				if(M.stat == DEAD) <-- add this if we don't want it to work while dead
					return
				if(is_OD)
					//overdose stuff
					if(is_COD)
						//critical overdose stuff
				else
					//normal stuff
*/
/datum/reagent/generated/on_mob_life(mob/living/M, alien)
	holder.remove_reagent(id, custom_metabolism) //By default it slowly disappears.
	
	if((alien == IS_XENOS || alien == IS_YAUTJA || alien == IS_HORROR) && !(properties[PROPERTY_CROSSMETABOLIZING])) return
	if(properties[PROPERTY_CRYOMETABOLIZING] && M.bodytemperature > 170) return

	var/is_OD
	var/is_COD
	if(overdose && volume >= overdose)
		M.last_damage_source = "Experimental chemical overdose"
		M.last_damage_mob = last_source_mob
		is_OD = 1
		if(overdose_critical && volume > overdose_critical)
			is_COD = 1

	for(var/P in properties)
		
		if(!is_OD && P in get_negative_chem_properties(1))
			M.last_damage_source = "Experimental chemical overdose"
			M.last_damage_mob = last_source_mob

		var/potency = properties[P]
		if(!potency) continue
		switch(P)
/////////Negative Properties/////////
			if(PROPERTY_HYPOXEMIC) //(oxygen damage)
				if(is_OD)
					//overdose stuff
					M.apply_damages(potency, 0, potency)
					M.adjustOxyLoss(5*potency)
					if(is_COD)
						//critical overdose stuff
						M.apply_damages(potency*5, 0, 2*potency)
				else
					//normal stuff
					M.adjustOxyLoss(2*potency)
				if(prob(10)) M.emote("gasp")
			if(PROPERTY_TOXIC) //toxin damage
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(potency*4)
				else
					M.adjustToxLoss(potency)
			if(PROPERTY_CORROSIVE) //burn damage
				if(is_OD)
					M.take_limb_damage(0,2*potency)
					if(is_COD)
						M.take_limb_damage(0,4*potency)
				else
					M.take_limb_damage(0,potency)
			if(PROPERTY_BIOCIDIC) //brute damage
				if(is_OD)
					M.take_limb_damage(2*potency)
					if(is_COD)
						M.take_limb_damage(4*potency)
				else
					M.take_limb_damage(potency)
			if(PROPERTY_RADIOACTIVE) //radiation damage
				if(is_OD)
					M.radiation += 2*potency
					if(is_COD)
						M.radiation += 4*potency
				else
					M.radiation += potency
			if(PROPERTY_HEMOLYTIC) //blood loss
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(C)
						if(is_OD)
							C.blood_volume = max(C.blood_volume-8*potency,0)
							M.drowsyness = min(M.drowsyness + potency,15*potency)
							M.reagent_move_delay_modifier += potency
							if(prob(10)) M.emote(pick("yawn","gasp"))
							if(is_COD)
								M.adjustOxyLoss(4*potency)
						else
							C.blood_volume = max(C.blood_volume-4*potency,0)
			if(PROPERTY_HEMORRAGING) //internal bleeding
				var/mob/living/carbon/human/C = M
				if(C)
					var/datum/limb/L = pick(C.limbs)
					if(L && !(L.status & LIMB_ROBOT))
						if(is_OD)
							L.germ_level += 10*potency //germs entering the bloodstream. Think gutbacteria etc
							if(L.internal_organs)
								var/datum/internal_organ/O = pick(L.internal_organs)//Organs can't bleed, so we just damage them
								O.damage += 0.5*potency
							if(is_COD)
								if(prob(20*potency))
									var/datum/wound/internal_bleeding/I = new (rand(5*potency, 20*potency))
									L.wounds += I
						else if(prob(5*potency))
							var/datum/wound/internal_bleeding/I = new (rand(potency, 5*potency))
							L.wounds += I
						if(prob(5*potency))
							spawn L.owner.emote("me", 1, "coughs up blood!")
							L.owner.drip(10)
			if(PROPERTY_CARCINOGENIC) //clone damage
				if(is_OD)
					M.adjustCloneLoss(2*potency)
					if(is_COD)
						M.take_limb_damage(2*potency)//Hyperactive apoptosis
				else
					M.adjustCloneLoss(0.5*potency)
			if(PROPERTY_NECROTIZING) //Kills and rots flesh
				var/mob/living/carbon/human/C = M
				if(C)
					var/datum/limb/L = pick(C.limbs)
					if(L && !(L.status & LIMB_ROBOT))
						if(!L.wounds || !L.wounds.len)
							L.wounds += new /datum/wound/bruise
						var/datum/wound/W = pick(L.wounds)
						W.damage += potency
						if(is_OD)
							W.germ_level += 200 * potency
							if(is_COD)
								if(L.name != "head" && L.germ_level > 1000) //the limb is so rotten it falls off
									L.droplimb(0,0, "dangerous chemicals")
						else
							W.germ_level += 25 * potency
						if(L.germ_level > INFECTION_LEVEL_THREE)
							if(!(L.status & LIMB_NECROTIZED))
								L.status |= LIMB_NECROTIZED
								to_chat(M, SPAN_NOTICE("You can't feel your [L.display_name] anymore..."))
								L.owner.update_body(1)
						if(W.germ_level > 200)//At this point the infection becomes internal
							L.germ_level = W.germ_level
						L.update_wounds()
						L.update_germs()
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
					M.adjustBrainLoss(3*potency)
					M.jitteriness = max(M.jitteriness + potency,0)
					if(prob(50)) M.drowsyness = max(M.drowsyness+potency, 3)
					if(prob(10)) M.emote("drool")
					if(is_COD)
						if(prob(15*potency))
							apply_neuro(M, 2*potency, FALSE)
				else
					M.adjustBrainLoss(1.75*potency)
/////////Neutral Properties///////// 
			if(PROPERTY_KETOGENIC) //weight loss
				if(is_OD)
					M.nutrition = max(M.nutrition - 10*potency, 0)
					M.adjustToxLoss(potency)
					if(prob(5*potency))
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							H.vomit()
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)	
				M.nutrition = max(M.nutrition - 5*potency, 0)
				M.overeatduration = 0
				if(M.reagents.remove_all_type(/datum/reagent/ethanol, potency, 0, 1)) //Ketosis causes rapid metabolization of alcohols
					M.confused = min(M.confused + potency,10*potency)
					M.drowsyness = min(M.drowsyness + potency,15*potency)
			if(PROPERTY_PAINING) //pain
				if(is_OD)
					M.reagent_pain_modifier += 100*potency
					M.take_limb_damage(potency)
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
					M.confused += min(M.confused + potency*2,20*potency)
					M.drowsyness += min(M.drowsyness + potency*2,30*potency)
					M.adjustToxLoss(0.5*potency)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
						if(L)
							L.damage += 0.5*potency
							if(is_COD)
								L.damage += 2*potency
					if(is_COD)
						M.adjustOxyLoss(4*potency)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.confused = min(M.confused + potency,10*potency)
					M.drowsyness = min(M.drowsyness + potency,15*potency)
			if(PROPERTY_HALLUCINOGENIC) //hallucinations
				if(prob(10)) M.emote(pick("twitch","drool","moan","giggle"))
				if(is_OD)
					if(isturf(M.loc) && !istype(M.loc, /turf/open/space))
						if(M.canmove && !M.is_mob_restrained())
							if(prob(10)) step(M, pick(cardinal))
					M.hallucination += 10
					M.make_jittery(5)
					if(is_COD)
						M.adjustBrainLoss(potency)
						M.knocked_out = max(M.knocked_out, 20)
				else
					if(potency>2)
						M.hallucination += potency
					M.druggy += potency
					M.make_jittery(5)
					M.drowsyness = min(M.drowsyness + 0.25*potency,15*potency)
			if(PROPERTY_RELAXING) //slows movement
				if(is_OD)
					//heart beats slower
					M.reagent_move_delay_modifier += 2*potency
					to_chat(M, SPAN_WARNING("You feel incredibly weak!"))
					if(is_COD)
						//heart stops beating, lungs stop working
						if(prob(15*potency))
							M.KnockOut(potency)
						M.adjustOxyLoss(potency)
						if(prob(5)) to_chat(M, SPAN_WARNING("You can hardly breathe!"))
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
							if(E)
								E.damage += 0.75*potency
				else
					M.reagent_move_delay_modifier += potency
					if(prob(10)) M.emote("yawn")
			if(PROPERTY_HYPERTHERMIC) //increase bodytemperature
				if(prob(10)) M.emote("gasp")
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature+4*potency,0)
					M.drowsyness  = max(M.drowsyness, 40)
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.bodytemperature = max(M.bodytemperature+2*potency,0)
			if(PROPERTY_HYPOTHERMIC) //decrease bodytemperature
				if(prob(10)) M.emote("shiver")
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature-4*potency,0)
					M.drowsyness  = max(M.drowsyness, 40)
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.bodytemperature = max(M.bodytemperature-2*potency,0)
			if(PROPERTY_BALDING) //unga
				if(is_OD)
					M.adjustCloneLoss(0.5*potency)
					if(is_COD)
						M.adjustCloneLoss(potency)
				if(prob(5*potency))
					var/mob/living/carbon/human/H = M
					if(H)
						if((H.h_style != "Bald" || H.f_style != "Shaved"))
							to_chat(M, SPAN_WARNING("Your hair falls out!"))
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
						H.h_style = pick(hair_styles_list)
						H.f_style = pick(facial_hair_styles_list)
						H.update_hair()
						to_chat(M, SPAN_NOTICE("Your head feels different..."))
			if(PROPERTY_ALLERGENIC) //sneezing etc.
				if(prob(5*potency)) M.emote(pick("sneeze","blink","cough"))
			if(PROPERTY_EUPHORIC) //HAHAHAHA
				if(is_OD)
					if(prob(5*potency)) M.emote("collapse") //ROFL
					if(is_COD)
						M.adjustOxyLoss(3*potency)
						M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))
						to_chat(M, SPAN_WARNING("You are laughing so much you can't breathe!"))
				if(!is_COD && prob(5*potency)) M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))
				M.reagent_pain_modifier += 20*potency //Endorphins are natural painkillers
			if(PROPERTY_EMETIC) //vomiting
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H)
						if(is_OD)
							M.adjustToxLoss(0.5*potency)
							if(is_COD)
								M.adjustToxLoss(0.5*potency)
						if(prob(volume*potency))
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
						C.blood_volume = max(0.2 * nutriment_factor * potency,BLOOD_VOLUME_NORMAL)
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
			if(PROPERTY_ANTICORROSIVE) //burn healing
				if(is_OD)
					M.apply_damages(2*potency, 0, potency) //Mixed brute/tox damage
					if(is_COD)
						M.apply_damages(4*potency, 0, 2*potency) //Massive brute/tox damage
				else
					M.heal_limb_damage(0, 0.25+potency)
			if(PROPERTY_NEOGENETIC) //brute healing
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
			if(PROPERTY_HEMOGENIC) //Blood production
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(is_OD)
						C.blood_volume = min(C.blood_volume+2*potency,BLOOD_VOLUME_MAXIMUM+100)
						M.nutrition = max(M.nutrition - 5*potency, 0)
						if(is_COD)
							M.adjustToxLoss(2*potency)
					else
						C.blood_volume = min(C.blood_volume+potency,BLOOD_VOLUME_MAXIMUM+100)
					if(C.blood_volume > BLOOD_VOLUME_MAXIMUM) //Too many red blood cells thickens the blood and leads to clotting
						M.take_limb_damage(potency)
						M.adjustOxyLoss(2*potency)
						M.reagent_move_delay_modifier += potency
			if(PROPERTY_NERVESTIMULATING) //stun decrease
				if(prob(10)) M.emote("twitch")
				if(is_OD)
					M.adjustBrainLoss(potency)
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
								E.damage += potency
								M.take_limb_damage(0.5*potency)
				else
					M.reagent_move_delay_modifier -= 0.2*potency
			if(PROPERTY_PAINKILLING) //painkiller
				if(is_OD)
					M.hallucination = max(M.hallucination, potency) //Hallucinations and tox damage
					M.apply_damage(potency, TOX)
					if(is_COD) //Massive liver damage
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
							if(L)
								L.damage += 3*potency
				else
					M.reagent_pain_modifier += -30*potency
			if(PROPERTY_ANTISEPTIC) //removes internal infections
				var/mob/living/carbon/human/C = M
				if(C)
					var/datum/limb/L = pick(C.limbs)
					if(L && !(L.status & LIMB_ROBOT))
						if(is_OD)
							L.germ_level = max(0,L.germ_level - 100*potency)
							M.adjustToxLoss(2*potency)
							if(L.status & LIMB_NECROTIZED)
								L.status &= ~LIMB_NECROTIZED
							if(is_COD)
								var/datum/internal_organ/O = pick(C.internal_organs_by_name)
								O.damage += 2*potency
						else
							L.germ_level = max(0,L.germ_level - 50*potency)
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
							M.take_limb_damage(2*potency)
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
					M.apply_damages(2*potency, 0, 2*potency)
					if(is_COD)
						M.apply_damages(4*potency, 0, 4*potency) //Mixed brute/tox damage
				else
					var/mob/living/carbon/human/C = M
					if(C)
						var/datum/limb/L = pick(C.limbs)
						if(L && prob(10*potency))
							if(L.status & LIMB_ROBOT)
								L.take_damage(0,2*potency)
								break
							if(L.implants && L.implants.len > 0)
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
			if(PROPERTY_EMBRYONIC) //Adds embryo's. 
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC)) //No effect if already infected
						continue
					for(var/i=1,i<=max((potency % 100)/10,1),i++)//10's determine number of embryos
						var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
						embryo.hivenumber = min(potency % 10,5) //1's determine hivenumber
			if(PROPERTY_TRANSFORMING) //Xenomorph Transformation
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.contract_disease(new /datum/disease/xeno_transformation(0),1)
			if(PROPERTY_RAVENING) //Zombie infection
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.contract_disease(new /datum/disease/black_goo, 1)
			if(PROPERTY_CURING) //Cures diseases
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.viruses)
						for(var/datum/disease/D in H.viruses)
							if(potency >= 4)
								D.cure()
								H.regenZ = 0
							else
								if(D.name == "Unknown Mutagenic Disease" && (potency == 1 || potency > 3))
									D.cure()
								if(D.name == "Black Goo" && potency >=2)
									D.cure()
									H.regenZ = 0
			if(PROPERTY_OMNIPOTENT)
				M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
				M.setCloneLoss(0)
				M.setOxyLoss(0)
				M.radiation = 0
				M.heal_limb_damage(5,5)
				M.adjustToxLoss(-5)
				M.hallucination = 0
				M.setBrainLoss(0)
				M.disabilities = 0
				M.sdisabilities = 0
				M.eye_blurry = 0
				M.eye_blind = 0
				M.SetKnockeddown(0)
				M.SetStunned(0)
				M.SetKnockedout(0)
				M.silent = 0
				M.dizziness = 0
				M.drowsyness = 0
				M.stuttering = 0
				M.confused = 0
				M.sleeping = 0
				M.jitteriness = 0
				var/mob/living/carbon/human/H = M
				if(H)
					for(var/datum/internal_organ/I in H.internal_organs)
						if(I.damage > 0)
							I.damage = max(I.damage - 1, 0)
				for(var/datum/disease/D in M.viruses)
					D.spread = "Remissive"
					D.stage--
					if(D.stage < 1)
						D.cure()
