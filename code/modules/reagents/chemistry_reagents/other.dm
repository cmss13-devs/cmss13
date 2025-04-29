
//*****************************************************************************************************/
//********************************************Blood****************************************************/
//*****************************************************************************************************/

/datum/reagent/blood
	name = "Blood"
	id = "blood"
	description = "Blood is classified as a connective tissue and consists of two main components: Plasma, which is a clear extracellular fluid. Formed elements, which are made up of the blood cells and platelets."
	reagent_state = LIQUID
	color = "#A10808"
	data_properties = new/list("blood_type"=null,"blood_color"= "#A10808","viruses"=null,"resistances"=null)
	chemclass = CHEM_CLASS_RARE


/datum/reagent/blood/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	var/datum/reagent/blood/self = src
	src = null
	if(self.data_properties && self.data_properties["viruses"])
		for(var/datum/disease/D in self.data_properties["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS)
				continue

			if(method == TOUCH)
				M.contract_disease(D)
			else //injected
				M.contract_disease(D, 1, 0)


/datum/reagent/blood/reaction_turf(turf/T, volume)//splash the blood all over the place
	if(!istype(T))
		return
	var/datum/reagent/blood/self = src
	src = null
	if(!(volume >= 3))
		return

	T.add_blood(self.color)



/datum/reagent/blood/yaut_blood
	name = "Green Blood"
	id = "greenblood"
	description = "A thick green blood, definitely not human."
	color = BLOOD_COLOR_YAUTJA
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE

/datum/reagent/blood/synth_blood
	name = "Synthetic Blood"
	id = "whiteblood"
	color = BLOOD_COLOR_SYNTHETIC
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
	color = BLOOD_COLOR_XENO
	description = "A corrosive blood like substance. Makeup appears to be made out of acids and blood plasma."
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE
	properties = list(PROPERTY_CORROSIVE = 3)

/datum/reagent/blood/xeno_blood/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.toxins += 3*volume
	processing_tray.plant_health += -volume
	if(prob(10))
		var/turf/c_turf = get_turf(processing_tray)
		var/removed_chem = pick(processing_tray.seed.chems)
		processing_tray.seed = processing_tray.seed.diverge()
		if(length(processing_tray.seed.chems) > 1)
			c_turf.visible_message(SPAN_WARNING("[capitalize_first_letters(processing_tray.seed.display_name)] sizzles and pops!"))
			processing_tray.seed.chems.Remove(removed_chem)
		if(length(processing_tray.seed.chems) <= 1)
			if (!isnull(processing_tray.seed.chems["xenoblood"]))
				return
			processing_tray.seed.chems += list("xenoblood" = list(1,2))
			c_turf.visible_message(SPAN_NOTICE("[capitalize_first_letters(processing_tray.seed.display_name)]'s sizzling sputters out, you smell [lowertext(name)]!"))

/datum/reagent/blood/xeno_blood/royal
	name = "Dark Acidic Blood"
	id = "xenobloodroyal"
	color = BLOOD_COLOR_XENO_ROYAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_CORROSIVE = 6)

/datum/reagent/blood/xeno_blood/royal/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	if(!processing_tray.seed)
		return
	processing_tray.toxins += 6*volume
	processing_tray.plant_health += -4*volume
	processing_tray.chem_add_counter += 1*volume
	if(processing_tray.chem_add_counter >= 5 && prob(60))
		var/turf/c_turf = get_turf(processing_tray)
		processing_tray.chem_add_counter += -5
		processing_tray.seed = processing_tray.seed.diverge()
		if(length(processing_tray.seed.chems) > 10)
			return
		if(!isnull(processing_tray.seed.chems["xenoblood"]))
			var/list/new_chem = list(pick( GLOB.chemical_gen_classes_list["H1"]) = list(1,rand(2,3)))
			var/datum/reagent/new_chem_datum = GLOB.chemical_reagents_list[new_chem[1]]
			processing_tray.seed.chems += new_chem
			c_turf.visible_message(SPAN_NOTICE("[capitalize_first_letters(processing_tray.seed.display_name)] flashes an erie green, you smell [new_chem_datum.name]!"))

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#C81040" // rgb: 200, 16, 64
	properties = list(PROPERTY_CURING = 4)

/datum/reagent/vaccine/reaction_mob(mob/M, method=TOUCH, volume, permeable)
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
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	chemclass = CHEM_CLASS_BASIC
	chemfiresupp = TRUE
	intensitymod = -3

/datum/reagent/water/reaction_turf(turf/T, volume)
	if(!istype(T))
		return
	src = null
	if(volume >= 3)
		T.wet_floor(FLOOR_WET_WATER)

/datum/reagent/water/reaction_obj(obj/O, volume)
	src = null
	O.extinguish()

/datum/reagent/water/reaction_mob(mob/living/M, method=TOUCH, volume, permeable)//Splashing people with water can help put them out!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(-(volume / 10))
		if(M.fire_stacks <= 0)
			M.ExtinguishMob()

/datum/reagent/water/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	processing_tray.waterlevel += 0.5*volume

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
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
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

/datum/reagent/sleen
	name = "Sleen"
	id = "sleen"
	description = " A favorite of marine medics, it is an illicit mixture of name brand lime soda and oxycodone, known for it's distinct red hue. Overdosing can cause hallucinations, loss of coordination, seizures, brain damage, respiratory failure, and death."
	reagent_state = LIQUID
	color = "#C21D24" // rgb: 194, 29, 36
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 3)

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
	color = COLOR_GRAY
	chemfiresupp = TRUE
	properties = list(PROPERTY_OXIDIZING = 2)
	intensitymod = 0.75
	radiusmod = -0.08
	burncolor = "#58daff"
	burncolormod = 2
	chemclass = CHEM_CLASS_BASIC
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "Chemical element of atomic number 29. A solfe malleable red metal with high thermal and electrical conductivity."
	color = "#6E3B08" // rgb: 110, 59, 8
	chemfiresupp = TRUE
	burncolor = "#78be5a"
	burncolormod = 4
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "Chemical element of atomic number 7. Liquid nitrogen is commonly used in cryogenics, with its melting point of 63.15 kelvin. Nitrogen is a component of many explosive compounds and fertilizers."
	reagent_state = GAS
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)


/datum/reagent/hydrogen
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

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "Chemical element of atomic number 19. Is a soft and highly reactive metal and causes an extremely violent exothermic reaction with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "Chemical element of atomic number 80. It is the only elemental metal that is liquid at room temperature. Used in many industrial chemical purposes. The low vapor pressure of mercury causes it to create toxic fumes. Mercury poisoning is extremely dangerous and can cause large amounts of brain damage."
	reagent_state = LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NEUROTOXIC = 4, PROPERTY_NEUROCRYOGENIC = 1, PROPERTY_DISRUPTING = 1)

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "Chemical element of atomic number 16. Sulfur is an essential element for all life, as a component in amino acids and vitamins. Industrial uses of sulfur include the production of gunpowder and sulfuric acid."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/carbon
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

/datum/reagent/carbon/reaction_turf(turf/T, volume)
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
	color = COLOR_GRAY
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_BIOCIDIC = 1)

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "Chemical element of atomic number 9. It is a very reactive and highly toxic pale yellow gas at standard conditions. Mostly used for medical and dental purposes."
	reagent_state = GAS
	color = COLOR_GRAY
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_NEUTRALIZING = 1)

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "Chemical element of atomic number 11. Pure it is a soft and very reactive metal. Many salt compounds contain sodium, such as sodium chloride and sodium bicarbonate. There are more uses for sodium as a salt than as a metal."
	reagent_state = SOLID
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

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

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/lithium
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

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste. The most simple form of sugar, glucose, is the only form of nutriment for red blood cells as they have no mitocondria. Sugar can therefore be used to improve blood regeneration as a nutriment, although ineffective."
	reagent_state = SOLID
	color = COLOR_WHITE
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NUTRITIOUS = 1)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity, often used in medicines and beverages. Used in the production of plastic, nitroglycerin and other explosives."
	reagent_state = LIQUID
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_RARE

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Chemical element of atomic number 88. Radium is a highly radioactive metal that emits alpha and gamma radiation upon decay. Exposure to radium can cause cancer and other disorders."
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_CARCINOGENIC = 2, PROPERTY_HEMORRAGING = 1)

/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite is a pyrotechnic composition of powdered iron oxides that is an extremely volatile explosive. It is used in hand grenades, incendiary bombs, for welding and ore processing."
	reagent_state = SOLID
	color = "#673910" // rgb: 103, 57, 16
	chemfiresupp = TRUE
	burncolor = "#ffb300"
	explosive = TRUE
	power = 0.5
	falloff_modifier = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_FUELING = 7, PROPERTY_OXIDIZING = 5, PROPERTY_VISCOUS = 4, PROPERTY_CORROSIVE = 2)

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
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_HEMOGENIC = 3)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

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

/datum/reagent/uranium/reaction_turf(turf/T, volume)
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
	//------------------//
	intensityfire = BURN_LEVEL_TIER_1
	durationfire = BURN_TIME_TIER_1
	burn_sprite = "red"
	rangefire = 4
	//------------------//
	explosive = TRUE
	power = 0.12
	falloff_modifier = -0.1
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_FUELING = 5, PROPERTY_OXIDIZING = 3, PROPERTY_VISCOUS = 4, PROPERTY_TOXIC = 1)

/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A synthetic cleaner that vaporizes quickly and isn't slippery like water. It is therefore used compound for cleaning in space and low gravity environments. Very effective at sterilizing surfaces."
	reagent_state = LIQUID
	color = "#A5F0EE" // rgb: 165, 240, 238
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/space_cleaner/reaction_obj(obj/O, volume)
	if(istype(O, /obj/effect/decal/cleanable))
		var/obj/effect/decal/cleanable/C = O
		C.cleanup_cleanable()
	else if(O)
		O.clean_blood()

/datum/reagent/space_cleaner/reaction_turf(turf/T, volume)
	if(volume >= 1 && istype(T))
		T.clean_cleanables()

/datum/reagent/space_cleaner/reaction_mob(mob/M, method=TOUCH, volume, permeable)
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

//*****************************************************************************************************/

/datum/reagent/oxidizing_agent
	name = "Oxidizing Agent"
	id = "oxidizing_agent"
	description = "A synthesized, highly-refined oxidizing agent that is most likely extremely unhealthy for human consumption."
	reagent_state = GAS
	color = "#c4c4c4"
	chemfiresupp = TRUE
	properties = list(PROPERTY_OXIDIZING = 6)
	intensitymod = 1
	radiusmod = -0.12
	burncolor = "#a9ecff"
	burncolormod = 2
	chemclass = CHEM_CLASS_RARE
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	flags = REAGENT_NO_GENERATION

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/xenomicrobes/reaction_mob(mob/M, method=TOUCH, volume, permeable)
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

/datum/reagent/foaming_agent/stabilized
	name = "Stabilized metallic foam"
	id = "stablefoam"
	description = "Stabilized metallic foam that solidifies when exposed to an open flame"
	reagent_state = LIQUID
	color = "#d4b8d1"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 8)

/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A legal highly addictive stimulant extracted from the tobacco plant. It is one of the most commonly abused drugs."
	reagent_state = LIQUID
	color = "#181818" // rgb: 24, 24, 24
	chemclass = CHEM_CLASS_RARE
	flags = REAGENT_SCANNABLE

/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizers or household cleaners."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/ammonia/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += 0.5*volume
	processing_tray.yield_mod += 0.1*volume
	processing_tray.nutrilevel += 2*volume

/datum/reagent/hexamine
	name = "Hexamine"
	id = "hexamine"
	description = "A crystalline compound that sees many uses varying from food additives, making plastics, treating urinary tract infections, as a smokeless heating element in military rations, and the creation of several explosives."
	reagent_state = SOLID
	color = "#F0F0F0"
	chemfiresupp = TRUE
	durationmod = 0.5
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_RARE

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

/datum/reagent/diethylamine/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += 0.8*volume
	processing_tray.yield_mod += 0.3*volume
	processing_tray.nutrilevel += 2*volume

/datum/reagent/blackgoo
	name = "Black goo"
	id = "blackgoo"
	description = "A strange dark liquid of unknown origin and effect."
	reagent_state = LIQUID
	color = "#222222"
	custom_metabolism = 100 //disappears immediately
	properties = list(PROPERTY_RAVENING = 1)

/datum/reagent/blackgoo/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Human")
			H.contract_disease(new /datum/disease/black_goo)

/datum/reagent/blackgoo/reaction_turf(turf/T, volume)
	if(!istype(T))
		return
	if(volume < 3)
		return
	if(!(locate(/obj/effect/decal/cleanable/blackgoo) in T))
		new /obj/effect/decal/cleanable/blackgoo(T)

/datum/reagent/viroxeno
	name = "Xenogenetic Catalyst"
	id = "xenogenic"
	description = "A catalyst chemical that is extremely aggresive towards any organic substance before swiftly turning it into itself."
	reagent_state = LIQUID
	color = "#a244d8"
	overdose = 10
	overdose_critical = 20
	chemclass = CHEM_CLASS_SPECIAL
	flags = REAGENT_NO_GENERATION
	properties = list(PROPERTY_DNA_DISINTEGRATING = 5, PROPERTY_HEMOSITIC = 2)


// Chemfire supplements

/datum/reagent/napalm
	name = "Napalm"
	id = "napalm"
	description = "This will probably ignite before you get to read this."
	reagent_state = LIQUID
	color = "#ffb300"
	chemfiresupp = TRUE
	burncolor = "#D05006"
	burn_sprite = "red"
	properties = list(PROPERTY_OXIDIZING = 6, PROPERTY_FUELING = 7, PROPERTY_FLOWING = 1)

/datum/reagent/napalm/sticky
	name = "Sticky-Napalm"
	id = "stickynapalm"
	description = "A custom napalm mix, stickier and lasts longer but lower damage"
	reagent_state = LIQUID
	color = "#f8e3b2"
	burncolor = "#f8e3b2"
	burn_sprite = "dynamic"
	intensitymod = -1.5
	durationmod = -5
	radiusmod = -0.5
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 5,
	)

/datum/reagent/napalm/high_damage
	name = "High-Combustion Napalm Fuel"
	id = "highdamagenapalm"
	description = "A custom napalm mix, higher damage but not as sticky"
	reagent_state = LIQUID
	color = "#c51c1c"
	burncolor = "#c51c1c"
	burn_sprite = "dynamic"
	intensitymod = -4.5
	durationmod = -1
	radiusmod = -0.5
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_8,
		PROPERTY_DURATION = BURN_TIME_TIER_1,
		PROPERTY_RADIUS = 5,
	)

// This is the regular flamer fuel and pyro regular flamer fuel.
/datum/reagent/napalm/ut
	name = "UT-Napthal Fuel"
	id = "utnapthal"
	description = "Known as Ultra Thick Napthal Fuel, a sticky combustible liquid chemical, typically used with flamethrowers."
	burncolor = "#EE6515"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_5,
		PROPERTY_DURATION = BURN_TIME_TIER_2,
		PROPERTY_RADIUS = 5,
	)

// This is gellie fuel. Green Flames.
/datum/reagent/napalm/gel
	name = "Napalm B-Gel"
	id = "napalmgel"
	description = "Unlike its liquid contemporaries, this gelled variant of napalm is easily extinguished, but shoots far and lingers on the ground in a viscous mess, while reacting with inorganic materials to ignite them."
	flameshape = FLAMESHAPE_LINE
	color = COLOR_GREEN
	burncolor = COLOR_GREEN
	burn_sprite = "green"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 7,
	)
	fire_type = FIRE_VARIANT_TYPE_B //Armor Shredding Greenfire

// This is the blue flamer fuel for the pyro.
/datum/reagent/napalm/blue
	name = "Napalm X"
	id = "napalmx"
	description = "A sticky combustible liquid chemical that burns extremely hot."
	color = "#00b8ff"
	burncolor = "#00b8ff"
	burn_sprite = "blue"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_7,
		PROPERTY_DURATION = BURN_TIME_TIER_4,
		PROPERTY_RADIUS = 6,
	)

// This is the green flamer fuel for the pyro.
/datum/reagent/napalm/green
	name = "Napalm B"
	id = "napalmb"
	description = "A special variant of napalm that's unable to cling well to anything, but disperses over a wide area while burning slowly. The composition reacts with inorganic materials to ignite them, causing severe damage."
	flameshape = FLAMESHAPE_TRIANGLE
	color = COLOR_GREEN
	burncolor = COLOR_GREEN
	burn_sprite = "green"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 6,
	)
	fire_type = FIRE_VARIANT_TYPE_B //Armor Shredding Greenfire

/datum/reagent/napalm/penetrating
	name = "Napalm E"
	id = "napalme"
	description = "A sticky combustible liquid chemical that penetrates the best fire retardants."
	color = COLOR_PURPLE
	burncolor = COLOR_PURPLE
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 6,
		PROPERTY_FIRE_PENETRATING = 1,
	)

/datum/reagent/napalm/deathsquad //version of fuel for dsquad flamers.
	name = "Napalm EX"
	id = "napalmex"
	description = "A sticky combustible liquid chemical made up of a combonation of rare and dangerous reagents both that penetrates the best fire retardants, and burns extremely hot."
	color = "#641dd6"
	burncolor = "#641dd6"
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY 			= BURN_LEVEL_TIER_7,
		PROPERTY_DURATION 			= BURN_TIME_TIER_4,
		PROPERTY_RADIUS 			= 6,
		PROPERTY_FIRE_PENETRATING	= 1
	)

/datum/reagent/napalm/upp
	name = "R189"
	id = "R189"
	description = "A UPP chemical, it burns at an extremely high tempature and is designed to melt directly through fortified positions or bunkers."
	color = "#ffe49c"
	burncolor = "#ffe49c"
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_9,
		PROPERTY_DURATION = BURN_TIME_TIER_3,
		PROPERTY_RADIUS = 6,
		PROPERTY_FIRE_PENETRATING = 1,
	)

/datum/reagent/chlorinetrifluoride
	name = "Chlorine Trifluoride"
	id = "chlorine trifluoride"
	description = "A highly reactive interhalogen compound capaple of self ignition. A very strong oxidizer and is extremely reactive with most organic and inorganic materials."
	reagent_state = LIQUID
	color = COLOR_CYAN
	custom_metabolism = 100
	chemfiresupp = TRUE
	burncolor = "#ff9300"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CORROSIVE = 8, PROPERTY_TOXIC = 6, PROPERTY_OXIDIZING = 9, PROPERTY_IGNITING = 1)

/datum/reagent/methane
	name = "Methane"
	id = "methane"
	description = "An easily combustible hydrocarbon that can very rapidly expand a fire, even explosively at the right concentrations. It is used primarily as fuel to make heat and light or manufacturing of organic chemicals."
	reagent_state = LIQUID
	color = "#0064C8"
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	chemfiresupp = TRUE
	burncolor = "#00a5ff"
	burncolormod = 1.5
	explosive = TRUE
	power = 0.15
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_TOXIC = 2, PROPERTY_FLOWING = 3, PROPERTY_VISCOUS = 3, PROPERTY_FUELING = 2)

//*****************************************************************************************************/
//*****************************************Explosives**************************************************/
//*****************************************************************************************************/

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
	color = COLOR_GRAY
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
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

/datum/reagent/cyclonite/on_mob_life(mob/living/M)
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
	properties = list(PROPERTY_OXIDIZING = 2)

//*****************************************************************************************************/
//****************************************Blood plasmas************************************************/
//*****************************************************************************************************/

/datum/reagent/plasma
	name = "plasma"
	id = "plasma"
	description = "A clear extracellular fluid separated from blood."
	reagent_state = LIQUID
	color = "#f1e8cf"
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)

/datum/reagent/plasma/pheromone
	name = "Pheromone Plasma"
	id = PLASMA_PHEROMONE
	description = "A funny smelling plasma..."
	color = "#a2e7d6"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HALLUCINOGENIC = 8)

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

/datum/reagent/plasma/egg/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC) || !H.huggable)
			volume = 0
			return
		if(volume < overdose_critical)
			return
		//it turns into an actual embryo at this point
		volume = 0
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		if(data_properties && data_properties["hive_number"])
			embryo.hivenumber = data_properties["hive_number"]
		else
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
	properties = list(PROPERTY_NEUROTOXIC = 4, PROPERTY_EXCRETING = 2, PROPERTY_HALLUCINOGENIC = 6)

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

/datum/reagent/plasma/purple/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.pestlevel += 2*volume
	processing_tray.nutrilevel += -2*volume
	if(processing_tray.seed.production <= 1)
		return
	processing_tray.production_time_counter += volume
	if (processing_tray.production_time_counter >= 30)
		var/turf/c_turf = get_turf(processing_tray)
		processing_tray.seed = processing_tray.seed.diverge()
		processing_tray.seed.production += -1
		if(prob(50))
			c_turf.visible_message(SPAN_NOTICE("[processing_tray.seed.display_name] bristles and sways towards you!"))
		processing_tray.production_time_counter = 0

/datum/reagent/plasma/royal
	name = "Royal Plasma"
	id = PLASMA_ROYAL
	description = "A dark purple-ish plasma..."
	color = "#ffeb9c"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_ABSOLUTE_VALUE
	properties = list(PROPERTY_BIOCIDIC = 4, PROPERTY_ADDICTIVE = 1, PROPERTY_HALLUCINOGENIC = 4, PROPERTY_ENCRYPTED = 1)

/datum/reagent/fruit_resin
	name = "Fruit Resin"
	id = "fruit_resin"
	description = "A strange green fluid found in certain xenomorphic structures. Seems to have regenerative properties."
	reagent_state = LIQUID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#12911d" // rgb: 102, 67, 48
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_TRANSFORMATIVE = 4, PROPERTY_NUTRITIOUS = 3, PROPERTY_HEMOGENIC = 1)
	flags = REAGENT_SCANNABLE

/datum/reagent/forensic_spray
	name = "Forensic Spray"
	id = "forensic_spray"
	description = "A dye-containing spray that binds to the skin oils left behind by fingerprints."
	reagent_state = LIQUID
	color = "#79847a"
	chemclass = CHEM_CLASS_RARE
	flags = REAGENT_NO_GENERATION

/datum/reagent/forensic_spray/reaction_obj(obj/reacting_on, volume)
	if(!istype(reacting_on, /obj/effect/decal/prints))
		return

	var/obj/effect/decal/prints/reacting_prints = reacting_on
	reacting_prints.set_visiblity(TRUE)

	addtimer(CALLBACK(reacting_prints, TYPE_PROC_REF(/obj/effect/decal/prints, set_visiblity), FALSE), 1 MINUTES, TIMER_UNIQUE|TIMER_OVERRIDE)
