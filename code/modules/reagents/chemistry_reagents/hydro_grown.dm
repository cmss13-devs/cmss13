

//*****************************************************************************************************/
//*************************************Hydroponics stuff************************************************/
//*****************************************************************************************************/
// Anything hydro-exclusive goes here, obviously not if its a toxin or something


/datum/reagent/hydro
	reagent_state = LIQUID
	color = "#6ab04c" // rgb: 139, 166, 233 - fallback color
	chemclass = CHEM_CLASS_HYDRO

// HYDRO HARD TIER CHEMS

/datum/reagent/hydro/atropine //poppy
	name = "Atropine"
	id = "atropine"
	description = "Plant based chemical replaced and superseded by Epinephrine, it has a plethora of side effects but is considerably stronger than epinephrine" //I know, now stay shush

	color = "#B31008" // rgb: 139, 166, 233
	properties = list(PROPERTY_ELECTROGENETIC = 7, PROPERTY_INTRAVENOUS = 1, PROPERTY_NEUROTOXIC = 0.5)

/datum/reagent/hydro/thymol //some kind of thyme
	name = "Thymol"
	id = "thymol"
	description = "Known chemical used in the 20th century as innovative way to combat hookworm parasites and generally all kinds of infections, it was since used as natural pesticide."

	color = "#badb9e" // rgb: 139, 166, 233
	properties = list(PROPERTY_ANTIPARASITIC = 0.5)

/datum/reagent/hydro/psoralen //cabbage, doesnt make sense but eh
	name = "Psoralen"
	id = "psoralen"
	description = "Naturally occuring carcinogenic, used commonly as mutagen for DNA research."
	color = "#c9ca75" // rgb: 139, 166, 233
	properties = list(PROPERTY_CARCINOGENIC = 6)

/datum/reagent/hydro/coniine //carrot
	name = "Coniine"
	id = "coniine"
	description = "Potent neurotoxic chemical commonly used as a murder weapon, death is caused by respiration failure and paralysis"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	color = "#8f947b" // rgb: 139, 166, 233
	properties = list(PROPERTY_SEDATIVE = 5)

/datum/reagent/hydro/zygacine
	name = "Zygacine"
	id = "zygacine"
	description = "Causes convulsing of the heart muscles before blocking the contractions entirely"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	color = "#aaaaaa" // rgb: 139, 166, 233
	properties = list(PROPERTY_CARDIOTOXIC = 3)

/datum/reagent/hydro/digoxin
	name = "Digoxin"
	id = "digoxin"
	description = "One of the oldest chemicals to enter field in treating many heart conditions, besides few sides effects, it can be used to great effect."
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	color = "#9ec265" // rgb: 139, 166, 233
	properties = list(PROPERTY_CARDIOPEUTIC = 3, PROPERTY_FLUFFING = 1)

/datum/reagent/hydro/urishiol
	name = "Urishiol"
	id = "urishiol"
	description = "Potent skin and tissue irratant causing burns which lasts weeks after the contact is made, commonly encountered in plants like Poision Ivy, Poison Oak, and simular"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = AMOUNT_PER_TIME(15, 20 MINUTES)
	color = "#c0bf90" // rgb: 139, 166, 233
	properties = list(PROPERTY_ALLERGENIC = 6, PROPERTY_CORROSIVE = 3)

/datum/reagent/hydro/phenol
	name = "Phenol"
	id = "phenol"
	description = "Skin analgesic used for targeted operation and mild pain relief of an area. While safe on the skin, extremely lethal on injection."
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	color = "#c095c9" // rgb: 139, 166, 233
	properties = list(PROPERTY_INTRAVENOUS = 1, PROPERTY_NEUROTOXIC = 5)


//HARD TIER HYDRO END.
