
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
	preferred_delivery = IMPLANTATION // for all intents and purposes, blood is considered implanted via IV drip or transfusion


/datum/reagent/blood/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	var/datum/reagent/blood/self = src
	src = null
	if(self.data_properties && self.data_properties["viruses"])
		for(var/datum/disease/D in self.data_properties["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS)
				continue

			if(method == ANY_DELIVERY) // gee
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
	preferred_delivery = INJECTION | CONTROLLED_INGESTION // i dont know if touching this ruins anything, actually

/datum/reagent/vaccine/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	if(has_species(M,"Horror"))
		return
	var/datum/reagent/vaccine/self = src
	src = null
	if(self.data_properties && method == CONTROLLED_INGESTION | method == INJECTION)
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

//*****************************************************************************************************/

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102
	preferred_delivery = ANY_DELIVERY

/datum/reagent/xenomicrobes/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	src = null
	if(prob(10) && method==ANY_DELIVERY)
		M.contract_disease(new /datum/disease/xeno_transformation(0),1)

/datum/reagent/blackgoo
	name = "Black goo"
	id = "blackgoo"
	description = "A strange dark liquid of unknown origin and effect."
	reagent_state = LIQUID
	color = "#222222"
	custom_metabolism = 100 //disappears immediately
	properties = list(PROPERTY_RAVENING = 1)
	preferred_delivery = ANY_DELIVERY

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
	flags = REAGENT_TYPE_SPECIALIST
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
	flags = REAGENT_TYPE_SPECIALIST
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
	properties = list(PROPERTY_CORROSIVE = 6, PROPERTY_TOXIC = 6, PROPERTY_OXIDIZING = 9, PROPERTY_IGNITING = 1)

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
	properties = list(PROPERTY_HALLUCINOGENIC = 8, PROPERTY_NERVESTIMULATING = 3)

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

/datum/reagent/plasma/nutrient
	name = "Nutrient Plasma"
	id = PLASMA_NUTRIENT
	description = "A tarquise plasma..."
	color = "#2fbe88"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_FUELING = 1, PROPERTY_VISCOUS = 3, PROPERTY_ADDICTIVE = 4, PROPERTY_NUTRITIOUS = 3)

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
