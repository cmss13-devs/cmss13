/datum/reagent/borer
	reagent_state = LIQUID
	chemclass = CHEM_CLASS_SPECIAL
	flags = REAGENT_SCANNABLE|REAGENT_NO_GENERATION

/datum/reagent/borer/enzyme
	name = "Cortical Enzyme"
	id = "borerenzyme"
	description = "An enzyme secreted by a parasite that consumes certain chemicals from the bloodstream. Also seems to help fight addictions."
	color = "#25c08c"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_CROSSMETABOLIZING = 2, PROPERTY_ANTIADDICTIVE = 2)

/datum/reagent/borer/cure
	name = "Anti-Enzyme"
	id = "borercure"
	description = "An anti-parasite drug synthesised from parastic enzymes. Effectively fights toxins in the bloodstream."
	color = "#177052"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_CROSSMETABOLIZING = 2, PROPERTY_ANTITOXIN = 4, PROPERTY_ANTIPARASITIC = 2)

/datum/reagent/borer/shock
	name = "Neuroshock"
	id = "borershock"
	description = "A biosynthetic nerve agent that stimulates cardiomyocytes in critical condition."
	properties = list(PROPERTY_CROSSMETABOLIZING = 2, PROPERTY_DEFIBRILLATING = 5, PROPERTY_INTRAVENOUS = 1)

/datum/reagent/borer/brainsleep
	name = "Neurostasis"
	id = "borerbrainstasis"
	description = "A biosynthetic agent that preserves long term brain function at the cost of the short term."
	properties = list(PROPERTY_CROSSMETABOLIZING = 2, PROPERTY_NEUROCRYOGENIC = 3, PROPERTY_INTRAVENOUS = 1)

/datum/reagent/borer/transformative
	name = "Biomend"
	id = "borertransform"
	description = "A biosynthetic agent that mends damaged tissue while creating a toxic byproduct."
	properties = list(PROPERTY_CROSSMETABOLIZING = 2, PROPERTY_TRANSFORMATIVE = 2, PROPERTY_INTRAVENOUS = 1)

/datum/reagent/borer/super_brain
	name = "Synaptic Boost"
	id = "borersuperbrain"
	description = "An unusual bio-agent that appears to enhance the brain function of subjects. Lethal in high doses."
	color = "#32745e"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE
	properties = list(PROPERTY_CROSSMETABOLIZING = 2, PROPERTY_ENCEPHALOPHRASIVE = 1, PROPERTY_PAINKILLING = 1, PROPERTY_NEUROPEUTIC = 2, PROPERTY_HYPOMETABOLIC = 4, PROPERTY_HYPOMETABOLIC = 2)

////////////// BORER CHEM DATUMS USED IN THE SYNTHESISER MENU ///////////////////////

/datum/borer_chem
	var/chem_name = "Unset"
	/// Chemical identifier, used in the proc to create it.
	var/chem_id = "unset"
	var/desc = "This is a chemical"
	/// Synthetic chemicals.
	var/impure = TRUE
	var/cost = 50
	var/quantity = 10

	var/category = BORER_CAT_HEAL
	var/restricted = FALSE
	var/species = "UNSET"

/datum/borer_chem/synthesised
	desc = "A chemical replicated from exposure."
	category = BORER_CAT_REPLICATED

//Medical Chems
/datum/borer_chem/human
	species = SPECIES_HUMAN

/datum/borer_chem/human/tricordrazine
	chem_name = "Tricordrazine"
	chem_id = "tricordrazine"
	desc = "Can be used to treat a wide range of injuries."

/datum/borer_chem/human/anti_toxin
	chem_name = "Dylovene"
	chem_id = "anti_toxin"
	desc = "General use chemical that neutralizes most toxins in the bloodstream. Can be used as a mild anti-hallucinogen and to reduce tiredness."

/datum/borer_chem/human/dexalin
	chem_name = "Dexalin"
	chem_id = "dexalin"
	desc = "Feeds oxygen directly into red bloodcells. Used as an antidote to lexorin poisoning."

/datum/borer_chem/human/peridaxon
	chem_name = "Peridaxon"
	chem_id = "peridaxon"
	desc = "Prevents symptoms caused by damaged internal organs while in the bloodstream, but does not fix the organ damage. Overdosing will cause internal tissue damage."

/datum/borer_chem/human/imidazoline
	chem_name = "Imidazoline"
	chem_id = "imidazoline"
	desc = "Used for treating non-genetic eye trauma."
	cost = 90
	quantity = 5

/datum/borer_chem/human/alkysine
	chem_name = "Alkysine"
	chem_id = "alkysine"
	desc = "Small amounts can repair extensive brain trauma. Overdosing on alkysine is extremely toxic."
	cost = 80
	quantity = 5

/datum/borer_chem/human/iron
	chem_name = "Iron"
	chem_id = "iron"
	desc = "Promotes production of blood. Overdosing on iron is extremely toxic."
	cost = 20
	impure = FALSE

/datum/borer_chem/human/oxycodone
	chem_name = "Oxycodone"
	chem_id = "oxycodone"
	desc = "An extremely strong painkiller."
	cost = 120
	quantity = 5


//"Speciality" Chems
/datum/borer_chem/universal/restarter
	chem_name = "Neuroshock"
	chem_id = "borershock"
	desc = "A powerful nerve agent that stimulates the heart. Useful for keeping your host alive. Lethal in high doses."
	cost = 300
	quantity = 2
	restricted = TRUE
	impure = FALSE

/datum/borer_chem/universal/neurostasis
	chem_name = "Neurostasis"
	chem_id = "borerbrainstasis"
	desc = "A biosynthetic agent that preserves long term brain function at the cost of the short term."
	cost = 300
	quantity = 10
	restricted = TRUE
	impure = FALSE

/datum/borer_chem/universal/biomend
	chem_name = "Biomend"
	chem_id = "borertransform"
	desc = "A biosynthetic agent that mends damage tissue while creating a toxic byproduct."
	cost = 250
	quantity = 10
	restricted = TRUE
	impure = FALSE

//"Motivation" Chems
/datum/borer_chem/human/stimulant_brain
	chem_name = "Neurological Stimulant"
	chem_id = "brain_stimulant"
	desc = "A powerful stimulant that enhances brain function. Lethal in high doses. Lasts one minute per unit."
	cost = 300
	quantity = 2
	category = BORER_CAT_STIM

/datum/borer_chem/human/stimulant_muscle
	chem_name = "Musculature Stimulant"
	chem_id = "speed_stimulant"
	desc = "A powerful stimulant that enhances musculature. Lethal in high doses. Lasts one minute per unit."
	cost = 300
	quantity = 2
	category = BORER_CAT_STIM

/datum/borer_chem/human/neurotoxin
	chem_name = "Neurotoxin"
	chem_id = PLASMA_NEUROTOXIN
	desc = "A potent and hallucinagenic neurotoxin."
	cost = 125
	quantity = 2
	category = BORER_CAT_PUNISH

/datum/borer_chem/human/antineurotoxin
	chem_name = "Anti-Neurotoxin"
	chem_id = "antineurotoxin"
	desc = "A bioagent that counteracts neurotoxins."
	cost = 100
	category = BORER_CAT_STIM

/datum/borer_chem/human/chloralhydrate
	chem_name = "Chloral Hydrate"
	chem_id = "chloralhydrate"
	desc = "A powerful sedative which causes near instant sleepiness, but can be deadly in large quantities."
	cost = 125
	quantity = 5
	category = BORER_CAT_PUNISH

/datum/borer_chem/human/potassium_chlorophoride
	chem_name = "Potassium Chlorophoride"
	chem_id = "potassium_chlorophoride"
	desc = "A powerful chemical based on Potassium Chloride that causes instant cardiac arrest."
	cost = 300
	quantity = 5
	category = BORER_CAT_PUNISH

/datum/borer_chem/human/death_powder
	chem_name = "Living Death"
	chem_id = "zombiepowder"
	desc = "A strong neurotoxin that puts the subject into a death-like state."
	cost = 300
	quantity = 5
	category = BORER_CAT_PUNISH
	impure = FALSE

/datum/borer_chem/human/super_brain
	chem_name = "Synaptic Boost"
	chem_id = "borersuperbrain"
	desc = "A biological agent that boosts a subject's brain function, repairing damage and causing a mild form of telepathy."
	cost = 300
	quantity = 3
	category = BORER_CAT_STIM
	impure = FALSE

//Yautja chemicals
/datum/borer_chem/yautja
	species = SPECIES_YAUTJA

/datum/borer_chem/yautja/thwei
	chem_name = "Thwei"
	chem_id = "thwei"
	desc = "A synthetic cocktail of chemicals used to accelerate healing in the Yautja species. It has no effect on humans."
	cost = 150
	quantity = 20



//Anti-Anti-Parasite
/datum/borer_chem/universal
	species = "Universal"

/datum/borer_chem/universal/enzyme
	chem_name = "Cortical Enzyme"
	chem_id = "borerenzyme"
	desc = "An enzyme focused on consuming chemicals in the bloodstream. Helps fight addictions. This will work as a preventative measure against anti-parasite drugs so long as it is in the bloodstream. Can cause brain damage."
	cost = 150
	quantity = 6
	category = BORER_CAT_SELF
	impure = FALSE
