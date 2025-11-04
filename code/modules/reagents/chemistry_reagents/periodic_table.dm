//*****************************************************************************************************/
//******File containing elements from the periodic table, for easier readability***********************/
//*****************************************************************************************************/

// ELEMENTS THAT ARE BIOLOGICALLY SAFE AND VITAL FOR BIOLOGICAL PROCESSES

/datum/reagent/periodic_table/safe/carbon
	name = "Carbon"
	id = "carbon"
	description = "Chemical element of atomic number 6. A very abundant element that occurs in all known organic life and in more than half of all known compounds. Used as fuel, in the production of steel, for nanotechnology and many other industrial purposes."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	chemfiresupp = TRUE
	durationmod = 1
	burncolor = "#ffd700"
	burncolormod = 3
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/carbon/reaction_turf(turf/T, volume)
	src = null
	if(!istype(T, /turf/open/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if(!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume*30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha+volume*30, 255)

/datum/reagent/periodic_table/safe/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "Chemical element of atomic number 8. It is an oxidizing agent that forms oxides with most elements and many other compounds. Dioxygen is used in cellular respiration and is nessesary to sustain organic life."
	reagent_state = GAS
	color = COLOR_GRAY
	chemfiresupp = TRUE
	properties = list(PROPERTY_OXIDIZING = 2)
	intensitymod = 0.75
	radiusmod = -0.08
	burncolor = "#58daff"
	burncolormod = 2
	chemclass = CHEM_CLASS_BASIC
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	preferred_delivery = INHALATION // believe it or not

/datum/reagent/periodic_table/safe/sodium
	name = "Sodium"
	id = "sodium"
	description = "Chemical element of atomic number 11. Pure it is a soft and very reactive metal. Many salt compounds contain sodium, such as sodium chloride and sodium bicarbonate. There are more uses for sodium as a salt than as a metal."
	reagent_state = SOLID
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "Chemical element of atomic number 15. A highly reactive element, that is essential for life as a component of DNA, RNA and ATP. White phospherous is used in many types of tracer and incendiary munitions due to its smoke production and high flammability."
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	chemfiresupp = TRUE
	intensitymod = 1
	durationmod = 0.1
	radiusmod = -0.12
	burncolor = "#ffdba4"
	burncolormod = 5
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "Chemical element of atomic number 16. Sulfur is an essential element for all life, as a component in amino acids and vitamins. Industrial uses of sulfur include the production of gunpowder and sulfuric acid."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/copper // believe it or not, humans are able to ingest copper in trace amounts
	name = "Copper"
	id = "copper"
	description = "Chemical element of atomic number 29. A solfe malleable red metal with high thermal and electrical conductivity."
	color = "#6E3B08" // rgb: 110, 59, 8
	chemfiresupp = TRUE
	burncolor = "#78be5a"
	burncolormod = 4
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/iron
	name = "Iron"
	id = "iron"
	description = "Chemical element of atomic number 26. Has a broad range of uses in multiple industries particularly in engineering and construction. Iron is an important component of hemoglobin, the substance in red blood cells that carries oxygen. Overdosing on iron is extremely toxic."
	reagent_state = SOLID
	color = "#a19d94" // rgb: 161, 157, 148 - actual iron color
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_HEMOGENIC = 3)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/periodic_table/safe/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "Chemical element of atomic number 7. Liquid nitrogen is commonly used in cryogenics, with its melting point of 63.15 kelvin. Nitrogen is a component of many explosive compounds and fertilizers."
	reagent_state = GAS
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "Chemical element of atomic number 1. Is the most abundant chemical element in the Universe. Liquid hydrogen was used as one of the first fuel sources for space travel. Very combustible and is used in many chemical reactions."
	reagent_state = GAS
	color = COLOR_GRAY
	chemfiresupp = TRUE
	durationmod = -0.5
	radiusmod = 0.2
	intensitymod = -0.5
	burncolor = "#b6f8ff"
	burncolormod = 2
	explosive = TRUE
	power = 0.15
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/periodic_table/safe/potassium
	name = "Potassium"
	id = "potassium"
	description = "Chemical element of atomic number 19. Is a soft and highly reactive metal and causes an extremely violent exothermic reaction with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

// ELEMENTS THAT ARE TYPICALLY NEUTRAL BUT GENERALLY SAFE IN EXPOSURE

/datum/reagent/periodic_table/neutral/gold
	name = "Gold"
	id = "gold"
	description = "Chemical element of atomic number 79. Gold is a dense, soft, shiny metal and the most malleable and ductile metal known. Used many industries including electronics, jewelry and medical."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	chemclass = CHEM_CLASS_RARE

/datum/reagent/periodic_table/neutral/silver
	name = "Silver"
	id = "silver"
	description = "Chemical element of atomic number 47. A soft, white, lustrous transition metal. Has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	chemclass = CHEM_CLASS_RARE

/datum/reagent/periodic_table/neutral/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "Chemical element of atomic number 13. A silvery-white soft metal of the boron group. Because of its low density it is often uses as a structural material in aircrafts."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	chemclass = CHEM_CLASS_BASIC

/datum/reagent/periodic_table/neutral/silicon
	name = "Silicon"
	id = "silicon"
	description = "Chemical element of atomic number 14. Commonly used as a semiconductor in electronics and is the main component of sand and glass."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	chemclass = CHEM_CLASS_BASIC

/datum/reagent/periodic_table/neutral/lithium
	name = "Lithium"
	id = "lithium"
	description = "Chemical element of atomic number 3. Is a soft alkali metal commonly used in the production of batteries. Highly reactive and flammable. Used as an antidepressant and for treating bipolar disorder."
	reagent_state = SOLID
	color = COLOR_GRAY
	chemfiresupp = TRUE
	intensitymod = 0.15
	burncolor = "#ff356f"
	burncolormod = 5
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_OXIDIZING = 1, PROPERTY_PSYCHOSTIMULATING = 1)

// ELEMENTS THAT ARE BIOLOGICALLY UNSAFE AND DEFINITELY NOT VITAL FOR BIOLOGICAL PROCESSES AT BASE FORM

/datum/reagent/periodic_table/risky/mercury
	name = "Mercury"
	id = "mercury"
	description = "Chemical element of atomic number 80. It is the only elemental metal that is liquid at room temperature. Used in many industrial chemical purposes. The low vapor pressure of mercury causes it to create toxic fumes. Mercury poisoning is extremely dangerous and can cause large amounts of brain damage."
	reagent_state = LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NEUROTOXIC = 4, PROPERTY_NEUROCRYOGENIC = 1, PROPERTY_DISRUPTING = 1)

/datum/reagent/periodic_table/risky/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "Chemical element of atomic number 17. High concentrations of elemental chlorine is highly reactive and poisonous for all living organisms. Chlorine gas has been used as a chemical warfare agent. Industrially used in the production of disinfectants, medicines, plastics and purification of water."
	reagent_state = GAS
	color = COLOR_GRAY
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_BIOCIDIC = 1)

/datum/reagent/periodic_table/risky/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "Chemical element of atomic number 9. It is a very reactive and highly toxic pale yellow gas at standard conditions. Mostly used for medical and dental purposes."
	reagent_state = GAS
	color = COLOR_GRAY
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_NEUTRALIZING = 1)

/datum/reagent/periodic_table/risky/radium
	name = "Radium"
	id = "radium"
	description = "Chemical element of atomic number 88. Radium is a highly radioactive metal that emits alpha and gamma radiation upon decay. Exposure to radium can cause cancer and other disorders."
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_CARCINOGENIC = 2, PROPERTY_HEMORRAGING = 1)

/datum/reagent/periodic_table/risky/uranium
	name ="Uranium"
	id = "uranium"
	description = "Chemical element of atomic number 92. A silvery-white metallic chemical element in the actinide series, weakly radioactive. Has been historically used for nuclear power and in the creation of nuclear bombs."
	reagent_state = SOLID
	color = "#B8B8C0" // rgb: 184, 184, 192
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_CARCINOGENIC = 2)

/datum/reagent/periodic_table/risky/uranium/reaction_turf(turf/T, volume)
	src = null
	if(volume >= 3)
		if(!istype(T, /turf/open/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
