//*****************************************************************************************************/
//******File containing dangerous mixtures and compounds, typically of the warcrime variety************/
//*****************************************************************************************************/

// Chemfire supplements

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

// reactive compounds, of both napalm and explosive variety

/datum/reagent/reactant_compound/oxidizing_agent // you can probably guess that its a generic oxidizer
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

/datum/reagent/reactant_compound/chlorinetrifluoride
	name = "Chlorine Trifluoride"
	id = "chlorine trifluoride"
	description = "A highly reactive interhalogen compound capable of self ignition. A very strong oxidizer and is extremely reactive with most organic and inorganic materials."
	reagent_state = LIQUID
	color = COLOR_CYAN
	custom_metabolism = 100
	chemfiresupp = TRUE
	burncolor = "#ff9300"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CORROSIVE = 6, PROPERTY_TOXIC = 6, PROPERTY_OXIDIZING = 9, PROPERTY_IGNITING = 1)

/datum/reagent/reactant_compound/methane
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

/datum/reagent/reactant_compound/potassium_hydroxide
	name = "Potassium hydroxide"
	id = "potassium_hydroxide"
	description = "This will probably explode before you manage to read this."
	explosive = TRUE
	power = 0.5

/datum/reagent/reactant_compound/ammoniumnitrate
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

/datum/reagent/reactant_compound/anfo //technically a mixture but for all intents and purposes, its a compound
	name = "Ammonium nitrate fuel oil"
	id = "anfo"
	color = "#E0E0E0"
	description = "Ammonium nitrate fuel oil (ANFO) is a low cost bulk explosive commonly used for mining and construction operations."
	explosive = TRUE
	power = 1
	falloff_modifier = -0.6

/datum/reagent/reactant_compound/glycerol //not explosive by itself, but it can be flammable, and can be synthesized into more evil, so yknow
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity, often used in medicines and beverages. Used in the production of plastic, nitroglycerin and other explosives."
	reagent_state = LIQUID
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_RARE

/datum/reagent/reactant_compound/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol. Despite being a highly volatile material, it is used for many medical purposes."
	reagent_state = LIQUID
	color = COLOR_GRAY
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	explosive = TRUE
	power = 1
	falloff_modifier = -0.5

/datum/reagent/reactant_compound/cyclonite
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

/datum/reagent/reactant_compound/octogen //HER MAJESTY'S EXPLOSIVE LOOOOOOL
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

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/reactant_compound/thermite
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

/datum/reagent/reactant_compound/thermite/reaction_turf(turf/T, volume)
	src = null
	if(istype(T, /turf/closed/wall))
		var/turf/closed/wall/W = T
		W.thermite += volume
		W.overlays += image('icons/effects/effects.dmi',icon_state = "#673910")

/datum/reagent/reactant_compound/hexamine
	name = "Hexamine"
	id = "hexamine"
	description = "A crystalline compound that sees many uses varying from food additives, making plastics, treating urinary tract infections, as a smokeless heating element in military rations, and the creation of several explosives."
	reagent_state = SOLID
	color = "#F0F0F0"
	chemfiresupp = TRUE
	durationmod = 0.5
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_RARE
