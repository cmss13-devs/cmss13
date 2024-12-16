/datum/reagent/medical/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "A low-potent, long-lasting muscle stimulant. Damages heart."
	reagent_state = LIQUID
	color = "#e07823"
	custom_metabolism = AMOUNT_PER_TIME(15, 3 MINUTES) //15 units will last approximately 3 minutes
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_MUSCLESTIMULATING = 2, PROPERTY_CARDIOTOXIC = 1)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	result = "hyperzine"
	required_reagents = list("meralyne" = 1, "phoron" = 1)
	result_amount = 2

/datum/reagent/medical/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "A low-potent, long-lasting CNS stimulant. Damages brain."
	reagent_state = LIQUID
	color = "#7dc0ff"
	custom_metabolism = AMOUNT_PER_TIME(15, 3 MINUTES) //15 units will last approximately 3 minutes
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NERVESTIMULATING = 2, PROPERTY_NEUROTOXIC = 1)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = "synaptizine"
	required_reagents = list("alkysine" = 1, "phoron" = 1)
	result_amount = 2
