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


//Medical Chems
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

/datum/borer_chem/human/quickclot
	chem_name = "Quickclot"
	chem_id = "quickclot"
	desc = "Vastly improves the blood's natural ability to coagulate and stop bleeding. Overdosing will result in severe tissue damage."
	cost = 90
	quantity = 5

/datum/borer_chem/human/iron
	chem_id = "Iron"
	chem_id = "iron"
	desc = "Promotes production of blood. Overdosing on iron is extremely toxic."
	cost = 20
	impure = FALSE

/datum/borer_chem/human/oxycodone
	chem_id = "Oxycodone"
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
	quantity = 1
	category = BORER_CAT_STIM

/datum/borer_chem/human/stimulant_muscle
	chem_name = "Musculature Stimulant"
	chem_id = "speed_stimulant"
	desc = "A powerful stimulant that enhances musculature. Lethal in high doses. Lasts one minute per unit."
	cost = 300
	quantity = 1
	category = BORER_CAT_STIM

/datum/borer_chem/human/neurotoxin
	chem_name = "Neurotoxin"
	chem_id = PLASMA_NEUROTOXIN
	desc = "A potent and hallucinagenic neurotoxin."
	cost = 125
	quantity = 1
	category = BORER_CAT_PUNISH

/datum/borer_chem/human/antineurotoxin
	chem_name = "Anti-Neurotoxin"
	chem_id = "antineurotoxin"
	desc = "A bioagent that counteracts neurotoxins."
	cost = 100
	category = BORER_CAT_PUNISH



//Yautja chemicals
/datum/borer_chem/yautja/thwei
	chem_name = "Thwei"
	chem_id = "thwei"
	desc = "A synthetic cocktail of chemicals used to accelerate healing in the Yautja species. It has no effect on humans."
	cost = 150
	quantity = 20



//Anti-Sugar
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
