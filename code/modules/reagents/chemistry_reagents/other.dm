///////////////////////////////////////////BLOOD////////////////////////////////////////////////////////////

/datum/reagent/blood
	name = "Blood"
	id = "blood"
	description = "Blood is classified as a connective tissue and consists of two main components: Plasma, which is a clear extracellular fluid. Formed elements, which are made up of the blood cells and platelets."
	reagent_state = LIQUID
	color = "#A10808"
	data_properties = new/list("blood_type"=null,"blood_colour"= "#A10808","viruses"=null,"resistances"=null)
	chemclass = CHEM_CLASS_RARE


/datum/reagent/blood/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	var/datum/reagent/blood/self = src
	src = null
	if(self.data_properties && self.data_properties["viruses"])
		for(var/datum/disease/D in self.data_properties["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS) continue

			if(method == TOUCH)
				M.contract_disease(D)
			else //injected
				M.contract_disease(D, 1, 0)


/datum/reagent/blood/reaction_turf(var/turf/T, var/volume)//splash the blood all over the place
	if(!istype(T)) return
	var/datum/reagent/blood/self = src
	src = null
	if(!(volume >= 3)) return

	T.add_blood(self.color)



/datum/reagent/blood/yaut_blood
	name = "Green Blood"
	id = "greenblood"
	description = "A thick green blood, definitely not human."
	color = "#20d450"
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE

/datum/reagent/blood/synth_blood
	name = "Synthetic Blood"
	id = "whiteblood"
	color = "#EEEEEE"
	description = "A synthetic blood-like liquid used by all Synthetics. Very effective as a medium for liquid cooling of electronics."
	chemclass = CHEM_CLASS_NONE

/datum/reagent/blood/zomb_blood
	name = "Grey Blood"
	id = "greyblood"
	color = "#333333"
	description = "A greyish liquid with the same consistency as blood."
	chemclass = CHEM_CLASS_NONE

/datum/reagent/blood/xeno_blood
	name = "Acidic Blood"
	id = "xenoblood"
	color = "#dffc00"
	description = "A corrosive blood like substance. Makeup appears to be made out of acids and blood plasma."
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE
	properties = list(PROPERTY_CORROSIVE = 3)

/datum/reagent/blood/xeno_blood/royal
	name = "Dark Acidic Blood"
	id = "xenobloodroyal"
	color = "#bbb900"
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_CORROSIVE = 6)

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#C81040" // rgb: 200, 16, 64
	properties = list(PROPERTY_CURING = 4)

/datum/reagent/vaccine/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	if(has_species(M,"Horror"))
		return
	var/datum/reagent/vaccine/self = src
	src = null
	if(self.data_properties && method == INGEST)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == self.data_properties)
					D.cure()
			else
				if(D.type == self.data_properties)
					D.cure()

		M.resistances += self.data_properties
	return

/datum/reagent/water
	name = "Water"
	id = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen. It is a vital component to all known forms of organic life, even though it provides no calories or organic nutrients. It is also an effective solvent and can be used for cleaning."
	reagent_state = LIQUID
	color = "#0064C8" // rgb: 0, 100, 200
	custom_metabolism = 0.01
	chemclass = CHEM_CLASS_BASIC
	chemfiresupp = TRUE
	intensitymod = -3

/datum/reagent/water/reaction_turf(var/turf/T, var/volume)
	if(!istype(T)) return
	src = null
	if(volume >= 3)
		T.wet_floor(FLOOR_WET_WATER)

/datum/reagent/water/reaction_obj(var/obj/O, var/volume)
	src = null
	if(istype(O,/obj/item/reagent_container/food/snacks/monkeycube))
		var/obj/item/reagent_container/food/snacks/monkeycube/cube = O
		if(!cube.package)
			cube.Expand()

/datum/reagent/water/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//Splashing people with water can help put them out!
	if(!istype(M, /mob/living))
		return
	return
	if(method == TOUCH)
		M.adjust_fire_stacks(-(volume / 10))
		if(M.fire_stacks <= 0)
			M.ExtinguishMob()
		return

/datum/reagent/water/holywater
	name = "Holy Water"
	id = "holywater"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#E0E8EF" // rgb: 224, 232, 239
	chemclass = CHEM_CLASS_NONE

/datum/reagent/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic. Not safe to eat."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.01
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal compound that causes hallucinations, visual artefacts and loss of balance."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HALLUCINOGENIC = 2)

/datum/reagent/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	reagent_state = LIQUID
	color = "#202040" // rgb: 20, 20, 40
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_ALLERGENIC = 2)

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "Chemical element of atomic number 8. It is an oxidizing agent that forms oxides with most elements and many other compounds. Dioxygen is used in cellular respiration and is nessesary to sustain organic life."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	chemfiresupp = TRUE
	intensitymod = 0.75
	radiusmod = -0.075
	burncolor = "#58daff"
	burncolormod = 2
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_OXIDIZING = 4, PROPERTY_VISCOUS = 3)

	custom_metabolism = 0.01

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "Chemical element of atomic number 29. A solfe malleable red metal with high thermal and electrical conductivity."
	color = "#6E3B08" // rgb: 110, 59, 8
	chemfiresupp = TRUE
	burncolor = "#78be5a"
	burncolormod = 4
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = 0.01

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "Chemical element of atomic number 7. Liquid nitrogen is commonly used in cryogenics, with its melting point of 63.15 kelvin. Nitrogen is a component of many explosive compounds and fertilizers."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = 0.01


/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "Chemical element of atomic number 1. Is the most abundant chemical element in the Universe. Liquid hydrogen was used as one of the first fuel sources for space travel. Very combustible and is used in many chemical reactions."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	chemfiresupp = TRUE
	durationmod = -0.5
	radiusmod = 0.14
	intensitymod = -0.75
	burncolor = "#b6f8ff"
	burncolormod = 2
	explosive = TRUE
	power = 0.15
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_FLOWING = 1)

	custom_metabolism = 0.01

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "Chemical element of atomic number 19. Is a soft and highly reactive metal and causes an extremely violent exothermic reaction with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = 0.01

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "Chemical element of atomic number 80. It is the only elemental metal that is liquid at room temperature. Used in many industrial chemical purposes. The low vapor pressure of mercury causes it to create toxic fumes. Mercury poisoning is extremely dangerous and can cause large amounts of brain damage."
	reagent_state = LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NEUROTOXIC = 4)

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "Chemical element of atomic number 16. Sulfur is an essential element for all life, as a component in amino acids and vitamins. Industrial uses of sulfur include the production of gunpowder and sulfuric acid."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = 0.01

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "Chemical element of atomic number 6. A very abundant element that occurs in all known organic life and in more than half of all known compounds. Used as fuel, in the production of steel, for nanotechnology and many other industrial purposes."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	chemfiresupp = TRUE
	durationmod = 0.8
	burncolor = "#ffd700"
	burncolormod = 3
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_FUELING = 4)

	custom_metabolism = 0.01

/datum/reagent/carbon/reaction_turf(var/turf/T, var/volume)
	src = null
	if(!istype(T, /turf/open/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if(!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume*30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha+volume*30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "Chemical element of atomic number 17. High concentrations of elemental chlorine is highly reactive and poisonous for all living organisms. Chlorine gas has been used as a chemical warfare agent. Industrially used in the production of disinfectants, medicines, plastics and purification of water."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_BIOCIDIC = 1)

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "Chemical element of atomic number 9. It is a very reactive and highly toxic pale yellow gas at standard conditions. Mostly used for medical and dental purposes."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "Chemical element of atomic number 11. Pure it is a soft and very reactive metal. Many salt compounds contain sodium, such as sodium chloride and sodium bicarbonate. There are more uses for sodium as a salt than as a metal."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = 0.01

/datum/reagent/phosphorus
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
	properties = list(PROPERTY_OXIDIZING = 5)

	custom_metabolism = 0.01

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "Chemical element of atomic number 3. Is a soft alkali metal commonly used in the production of batteries. Highly reactive and flammable. Used as an antidepressant and for treating bipolar disorder."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	chemfiresupp = TRUE
	intensitymod = 0.15
	burncolor = "#ff356f"
	burncolormod = 5
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_OXIDIZING = 1, PROPERTY_PSYCHOSTIMULATING = 1)

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste. The most simple form of sugar, glucose, is the only form of nutriment for red blood cells as they have no mitocondria. Sugar can therefore be used to improve blood regeneration as a nutriment, although ineffective."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NUTRITIOUS = 1)

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity, often used in medicines and beverages. Used in the production of plastic, nitroglycerin and other explosives."
	reagent_state = LIQUID
	color = "#808080" // rgb: 128, 128, 128
	chemclass = CHEM_CLASS_RARE

	custom_metabolism = 0.01

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Chemical element of atomic number 88. Radium is a highly radioactive metal that emits alpha and gamma radiation upon decay. Exposure to radium can cause cancer and other disorders."
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_CARCINOGENIC = 2)

/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite is a pyrotechnic composition of powdered iron oxides that is an extremely volatile explosive. It is used in hand grenades, incendiary bombs, for welding and ore processing."
	reagent_state = SOLID
	color = "#673910" // rgb: 103, 57, 16
	chemfiresupp = TRUE
	intensitymod = 0.25
	durationmod = 1
	radiusmod = -0.10
	burncolor = "#ffb300"
	explosive = TRUE
	power = 0.5
	falloff_modifier = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_FUELING = 4, PROPERTY_OXIDIZING = 1, PROPERTY_VISCOUS = 4, PROPERTY_CORROSIVE = 2)

/datum/reagent/thermite/reaction_turf(turf/T, volume)
	src = null
	if(istype(T, /turf/closed/wall))
		var/turf/closed/wall/W = T
		W.thermite += volume
		W.overlays += image('icons/effects/effects.dmi',icon_state = "#673910")

/datum/reagent/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Chemical element of atomic number 26. Has a broad range of uses in multiple industries particularly in engineering and construction. Iron is an important component of hemoglobin, the substance in red blood cells that carries oxygen. Overdosing on iron is extremely toxic."
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_HEMOGENIC = 3)

/datum/reagent/gold
	name = "Gold"
	id = "gold"
	description = "Chemical element of atomic number 79. Gold is a dense, soft, shiny metal and the most malleable and ductile metal known. Used many industries including electronics, jewelry and medical."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	chemclass = CHEM_CLASS_RARE

/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "Chemical element of atomic number 47. A soft, white, lustrous transition metal. Has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	chemclass = CHEM_CLASS_RARE

/datum/reagent/uranium
	name ="Uranium"
	id = "uranium"
	description = "Chemical element of atomic number 92. A silvery-white metallic chemical element in the actinide series, weakly radioactive. Has been historically used for nuclear power and in the creation of nuclear bombs."
	reagent_state = SOLID
	color = "#B8B8C0" // rgb: 184, 184, 192
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_CARCINOGENIC = 2)

/datum/reagent/uranium/reaction_turf(var/turf/T, var/volume)
	src = null
	if(volume >= 3)
		if(!istype(T, /turf/open/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "Chemical element of atomic number 13. A silvery-white soft metal of the boron group. Because of its low density it is often uses as a structural material in aircrafts."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	chemclass = CHEM_CLASS_BASIC

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "Chemical element of atomic number 14. Commonly used as a semiconductor in electronics and is the main component of sand and glass."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	chemclass = CHEM_CLASS_BASIC

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Liquid industrial grade blowtorch fuel."
	reagent_state = LIQUID
	color = "#660000" // rgb: 102, 0, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemfiresupp = TRUE
	intensitymod = 0.15
	durationmod = 0.75
	radiusmod = -0.075
	//------------------//
	// THESE NEED TO BE HERE DURING COMPILE TIME. THEY CANNOT BE IN A New() PROC
	intensityfire = 10 // config.min_burnlevel REPLACE WITH AN ENUM IF POSSIBLE
	durationfire = 10 // config.min_burntime REPLACE WITH AN ENUM IF POSSIBLE
	rangefire = 4 // config.min_shell_range REPLACE WITH AN ENUM IF POSSIBLE
	//------------------//
	explosive = TRUE
	power = 0.12
	falloff_modifier = -0.1
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_FUELING = 4, PROPERTY_OXIDIZING = 1, PROPERTY_VISCOUS = 3, PROPERTY_TOXIC = 1)

/datum/reagent/fuel/reaction_obj(var/obj/O, var/volume)
	var/turf/the_turf = get_turf(O)
	if(!the_turf)
		return //No sense trying to start a fire if you don't have a turf to set on fire. --NEO
	new /obj/effect/decal/cleanable/liquid_fuel(the_turf, volume)

/datum/reagent/fuel/reaction_turf(var/turf/T, var/volume)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)

/datum/reagent/fuel/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//Splashing people with welding fuel to make them easy to ignite!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 10)

/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A synthetic cleaner that vaporizes quickly and isn't slippery like water. It is therefore used compound for cleaning in space and low gravity environments. Very effective at sterilizing surfaces."
	reagent_state = LIQUID
	color = "#A5F0EE" // rgb: 165, 240, 238
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/space_cleaner/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/effect/decal/cleanable))
		qdel(O)
	else
		if(O)
			O.clean_blood()

/datum/reagent/space_cleaner/reaction_turf(var/turf/T, var/volume)
	if(volume >= 1 && istype(T))
		T.clean_dirt()

/datum/reagent/space_cleaner/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.r_hand)
			C.r_hand.clean_blood()
		if(C.l_hand)
			C.l_hand.clean_blood()
		if(C.wear_mask)
			if(C.wear_mask.clean_blood())
				C.update_inv_wear_mask(0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = C
			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
			if(H.shoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
			else
				H.clean_blood(1)
				return
		M.clean_blood()

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "A component to making spaceacilin."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's neural abilities by slowing down the higher brain cell functions. Can cause serious brain damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEUROTOXIC = 2, PROPERTY_RELAXING = 1)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/nanites
	name = "Nanomachines"
	id = "nanites"
	description = "Microscopic construction robots."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/nanites/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	src = null
	if((prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/robotic_transformation(0),1)

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/xenomicrobes/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	src = null
	if((prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/xeno_transformation(0),1)

/datum/reagent/fluorosurfactant//foam precursor
	name = "Fluorosurfactant"
	id = "fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	reagent_state = LIQUID
	color = "#9E6B38" // rgb: 158, 107, 56
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "An agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A legal highly addictive stimulant extracted from the tobacco plant. It is one of the most commonly abused drugs."
	reagent_state = LIQUID
	color = "#181818" // rgb: 24, 24, 24
	chemclass = CHEM_CLASS_RARE
	scannable = 1

/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizers or household cleaners."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/hexamine
	name = "Hexamine"
	id = "hexamine"
	description = "A crystalline compound that sees many uses varying from food additives, making plastics, treating urinary tract infections, as a smokeless heating element in military rations, and the creation of several explosives."
	reagent_state = SOLID
	color = "#F0F0F0"
	chemfiresupp = TRUE
	durationmod = 0.5
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC" // rgb: 255, 255, 204

/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "Diethylamine is used as a potent fertilizer and as an alternative to ammonia. Also used in the preparation rubber processing chemicals, agricultural chemicals, and pharmaceuticals."
	reagent_state = LIQUID
	color = "#604030" // rgb: 96, 64, 48
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/blackgoo
	name = "Black goo"
	id = "blackgoo"
	description = "A strange dark liquid of unknown origin and effect."
	reagent_state = LIQUID
	color = "#222222"
	custom_metabolism = 100 //disappears immediately
	properties = list(PROPERTY_RAVENING = 1)

/datum/reagent/blackgoo/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Human")
			H.contract_disease(new /datum/disease/black_goo)

/datum/reagent/blackgoo/reaction_turf(var/turf/T, var/volume)
	if(!istype(T)) return
	if(volume < 3) return
	if(!(locate(/obj/effect/decal/cleanable/blackgoo) in T))
		new /obj/effect/decal/cleanable/blackgoo(T)


// Chemfire supplements

/datum/reagent/napalm
	name = "Napalm"
	id = "napalm"
	description = "This will probably ignite before you get to read this."
	reagent_state = LIQUID
	color = "#ffb300"
	chemfiresupp = TRUE
	intensitymod = 0.4
	radiusmod = 0.085
	durationmod = 1
	burncolor = "#D05006"

/datum/reagent/napalm/ut
	name = "UT-Napthal Fuel"
	id = "utnapthal"
	description = "Known as Ultra Thick Napthal Fuel, a sticky combustable liquid chemical, typically used with flamethrowers."
	burncolor = "#D05006"

/datum/reagent/napalm/ut/New()
	properties += list(
		PROPERTY_INTENSITY 	= config.med_burnlevel,
		PROPERTY_DURATION 	= config.low_burntime,
		PROPERTY_RADIUS 	= config.close_shell_range
	)
	. = ..()

/datum/reagent/napalm/gel
	name = "Napthal Gel"
	id = "napalmgel"
	description = "Unlike its liquid contemporaries, this stuff shoots far, and burns up fast, but it doesn't burn anywhere near as hot."
	color = "#00ff00"
	intensityfire = 7
	durationfire = 6
	burncolor = "#00ff00"

/datum/reagent/napalm/gel/New()
	properties += list(
		PROPERTY_INTENSITY 	= config.low_burnlevel,
		PROPERTY_DURATION 	= config.instant_burntime,
		PROPERTY_RADIUS 	= config.near_shell_range
	)
	. = ..()

/datum/reagent/napalm/blue
	name = "Napalm X"
	id = "napalmx"
	description = "A sticky combustable liquid chemical that burns extremely hot."
	intensityfire = 30
	durationfire = 50
	rangefire = 7
	color = "#00b8ff"
	burncolor = "#00b8ff"

/datum/reagent/napalm/blue/New()
	properties += list(
		PROPERTY_INTENSITY 	= config.high_burnlevel,
		PROPERTY_DURATION 	= config.high_burntime,
		PROPERTY_RADIUS 	= config.near_shell_range
	)
	. = ..()

/datum/reagent/napalm/green
	name = "Napalm B"
	id = "napalmb"
	description = "A wide-spreading sticky combustable liquid chemical that burns slowly with a low temperature."
	flameshape = FLAMESHAPE_TRIANGLE
	color = "#00ff00"
	burncolor = "#00ff00"

/datum/reagent/napalm/green/New()
	properties += list(
		PROPERTY_INTENSITY 	= config.med_burnlevel,
		PROPERTY_DURATION 	= config.max_burntime,
		PROPERTY_RADIUS 	= config.near_shell_range
	)
	. = ..()

/datum/reagent/chlorinetrifluoride
	name = "Chlorine Trifluoride"
	id = "chlorine trifluoride"
	description = "A highly reactive interhalogen compound capaple of self ignition. A very strong oxidizer and is extremely reactive with most organic and inorganic materials."
	reagent_state = LIQUID
	color = "#00FFFF"
	custom_metabolism = 100
	chemfiresupp = TRUE
	intensitymod = 1.5
	durationmod = -1
	radiusmod = -0.075
	burncolor = "#ff9300"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CORROSIVE = 8, PROPERTY_TOXIC = 6, PROPERTY_OXIDIZING = 8, PROPERTY_VISCOUS = 3)

/datum/reagent/chlorinetrifluoride/on_mob_life(var/mob/living/M) // Not a good idea, instantly messes you up from the inside out.
	. = ..()
	M.adjust_fire_stacks(max(M.fire_stacks, 15))
	M.IgniteMob()
	to_chat(M, SPAN_DANGER("It burns! It burns worse than you could ever have imagined!"))

/datum/reagent/chlorinetrifluoride/reaction_mob(var/mob/M, var/method = TOUCH, var/volume) // Spilled on you? Not good either, but not /as/ bad.
	var/mob/living/L = M
	if(istype(L))
		L.adjust_fire_stacks(max(L.fire_stacks, 10))
		L.IgniteMob()

/datum/reagent/methane
	name = "Methane"
	id = "methane"
	description = "An easily combustible hydrocarbon that can very rapidly expand a fire, even explosively at the right concentrations. It is used primarily as fuel to make heat and light or manufacturing of organic chemicals."
	reagent_state = LIQUID
	color = "#0064C8"
	custom_metabolism = 0.4
	chemfiresupp = TRUE
	intensitymod = -1
	radiusmod = 0.1
	burncolor = "#00a5ff"
	burncolormod = 1.5
	explosive = TRUE
	power = 0.15
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_TOXIC = 2, PROPERTY_FLOWING = 4)

///////////////////////////////////////////Explosives////////////////////////////////////////////////////////////

/datum/reagent/potassium_hydroxide
	name = "Potassium hydroxide"
	id = "potassium_hydroxide"
	description = "This will probably explode before you manage to read this."
	explosive = TRUE
	power = 0.5

/datum/reagent/ammoniumnitrate
	name = "Ammonium Nitrate"
	id = "ammonium_nitrate"
	description = "A white crystalline compound that is used in agriculture as a high-nitrogen fertilizer. On its own, ammonium nitrate is not explosive, but rapidly becomes so when mixed with fuel oil."
	reagent_state = SOLID
	color = "#E5E5E5"
	explosive = TRUE
	power = 0.4
	falloff_modifier = 1.5
	chemfiresupp = TRUE
	durationmod = -0.2
	intensitymod = 0.5
	burncolor = "#ff9900"

/datum/reagent/anfo
	name = "Ammonium nitrate fuel oil"
	id = "anfo"
	color = "#E0E0E0"
	description = "Ammonium nitrate fuel oil (ANFO) is a low cost bulk explosive commonly used for mining and construction operations."
	explosive = TRUE
	power = 1
	falloff_modifier = -0.6

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol. Despite being a highly volatile material, it is used for many medical purposes."
	reagent_state = LIQUID
	color = "#808080" // rgb: 128, 128, 128
	custom_metabolism = 0.01
	explosive = TRUE
	power = 1
	falloff_modifier = -0.5

/datum/reagent/cyclonite
	name = "Cyclonite"
	id = "cyclonite"
	description = "Cyclonite is a low sensitivity highly explosive compound, commonly known as RDX. It is considered as one of the most energetic military high explosives. It is also sometimes used as a rat poison by civilians."
	reagent_state = SOLID
	color = "#E3E0BA"
	explosive = TRUE
	power = 1.5
	falloff_modifier = -0.4

/datum/reagent/cyclonite/on_mob_life(var/mob/living/M)
	. = ..()
	M.apply_damage(1, TOX)

/datum/reagent/octogen
	name = "Octogen"
	id = "octogen"
	description = "Octogen, also known as HMX or Her Majesty's Explosive, is a powerful and relatively insensitive explosive. It is one of the most potent chemical explosives available, exceeding that of cyclonite (RDX)."
	reagent_state = SOLID
	color = "#F5F5F5"
	explosive = TRUE
	power = 2
	falloff_modifier = -0.2
	chemfiresupp = TRUE
	durationmod = -0.2
	intensitymod = 0.5

///////////////////////////////////////////Blood plasmas////////////////////////////////////////////////////////////
/datum/reagent/plasma
	name = "plasma"
	id = "plasma"
	description = "A clear extracellular fluid separated from blood."
	reagent_state = LIQUID
	color = "#f1e8cf"
	custom_metabolism = 0.4

/datum/reagent/plasma/pheromone
	name = "Pheromone Plasma"
	id = PLASMA_PHEROMONE
	description = "A funny smelling plasma..."
	color = "#a2e7d6"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HALLUCINOGENIC = 8, PROPERTY_NERVESTIMULATING = 6)

/datum/reagent/plasma/chitin
	name = "Chitin Plasma"
	id = PLASMA_CHITIN
	description = "A very thick fibrous plasma..."
	color = "#6d7694"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HYPERDENSIFICATING = 1)

/datum/reagent/plasma/catecholamine
	name = "Catecholamine Plasma"
	id = PLASMA_CATECHOLAMINE
	description = "A red-ish plasma..."
	color = "#cf7551"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_PAINING = 2, PROPERTY_MUSCLESTIMULATING = 6)

/datum/reagent/plasma/egg
	name = "Egg Plasma"
	id = PLASMA_EGG
	description = "A white-ish plasma high with a high concentration of protein..."
	color = "#c3c371"
	overdose = 80
	overdose_critical = 100
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HEMOSITIC = 4)

/datum/reagent/plasma/egg/on_mob_life(var/mob/living/M)
	. = ..()
	if(!.)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC))
			volume = 0
			return
		if(volume < overdose_critical)
			return
		//it turns into an actual embryo at this point
		volume = 0
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		embryo.hivenumber = XENO_HIVE_NORMAL
		to_chat(H, SPAN_WARNING("Your stomach cramps and you suddenly feel very sick!"))

/datum/reagent/plasma/neurotoxin
	name = "Neurotoxin Plasma"
	id = PLASMA_NEUROTOXIN
	description = "A plasma containing an unknown but potent neurotoxin."
	color = "#ba8216"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_NEUROTOXIC = 4, PROPERTY_TOXIC = 1, PROPERTY_HALLUCINOGENIC = 6)

/datum/reagent/plasma/antineurotoxin
	name = "Anti-Neurotoxin"
	id = "antineurotoxin"
	description = "A counteragent to Neurotoxin Plasma."
	color = "#afffc9"
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_MEDIUM_VALUE
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_NEUROSHIELDING = 1)

/datum/reagent/plasma/purple
	name = "Purple Plasma"
	id = PLASMA_PURPLE
	description = "A purple-ish plasma..."
	color = "#a65d7f"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_BIOCIDIC = 2)

/datum/reagent/plasma/royal
	name = "Royal Plasma"
	id = PLASMA_ROYAL
	description = "A dark purple-ish plasma..."
	color = "#ffeb9c"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_ABSOLUTE_VALUE
	properties = list(PROPERTY_BIOCIDIC = 4, PROPERTY_ADDICTIVE = 1, PROPERTY_HALLUCINOGENIC = 4, PROPERTY_CIPHERING = 1)