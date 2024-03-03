GLOBAL_LIST_INIT_TYPED(borer_chemicals, /datum/borer_chem, generate_borer_chems())

/proc/generate_borer_chems()
	var/list/chem_list = list()
	for(var/chem_datum in subtypesof(/datum/borer_chem/human))
		chem_list += new chem_datum
	for(var/chem_datum in subtypesof(/datum/borer_chem/yautja))
		chem_list += new chem_datum
	return chem_list

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

	var/species = "UNSET"


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

/datum/borer_chem/human/epinephrine
	chem_name = "Epinephrine"
	chem_id = "adrenaline"
	desc = "Useful for restarting the heart. Overdosing may stress the heart and cause tissue damage."


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
/datum/borer_chem/human/enzyme
	chem_name = "Cortical Enzyme"
	chem_id = "benzyme"
	desc = "An enzyme focused on consuming chemicals in the bloodstream. Helps fight addictions. This will work as a preventative measure against anti-parasite drugs so long as it is in the bloodstream. Can cause brain damage."
	cost = 150
	quantity = 8
	category = BORER_CAT_SELF
	impure = FALSE

/datum/borer_chem/yautja/enzyme
	chem_name = "Cortical Enzyme"
	chem_id = "benzyme"
	desc = "An enzyme focused on consuming chemicals in the bloodstream. Helps fight addictions. This will work as a preventative measure against anti-parasite drugs so long as it is in the bloodstream. Can cause brain damage."
	cost = 150
	quantity = 6
	category = BORER_CAT_SELF
	impure = FALSE
