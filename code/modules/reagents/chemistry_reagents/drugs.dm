//*****************************************************************************************************/
//*****************************HARD DRUGS AND NARCOTICS*****************************************************/
//*****************************************************************************************************/

/datum/reagent/narcotics // parent
	name = "Generic Narcotics"
	description = "Generic mess of narcotics. Probably shouldn't have this."
	reagent_state = LIQUID
	preferred_delivery = INGESTION | CONTROLLED_INGESTION | INJECTION

/datum/reagent/narcotics/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A legal highly addictive stimulant extracted from the tobacco plant. It is one of the most commonly abused drugs."
	color = "#181818" // rgb: 24, 24, 24
	chemclass = CHEM_CLASS_RARE
	flags = REAGENT_SCANNABLE
	preferred_delivery = INGESTION | INHALATION

/datum/reagent/narcotics/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal compound that causes hallucinations, visual artefacts and loss of balance."
	color = "#60A584" // rgb: 96, 165, 132
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HALLUCINOGENIC = 2)

/datum/reagent/narcotics/sleen
	name = "Sleen"
	id = "sleen"
	description = " A favorite of marine medics, it is an illicit mixture of name brand lime soda and oxycodone, known for it's distinct red hue. Overdosing can cause hallucinations, loss of coordination, seizures, brain damage, respiratory failure, and death."
	color = "#C21D24" // rgb: 194, 29, 36
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 3)

/datum/reagent/narcotics/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's neural abilities by slowing down the higher brain cell functions. Can cause serious brain damage."
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEUROTOXIC = 2, PROPERTY_RELAXING = 1)
