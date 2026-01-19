//*****************************************************************************************************/
//*****************************Compounds and chemical mixtures*****************************************/
//*****************************************************************************************************/

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
	preferred_delivery = INGESTION | CONTROLLED_INGESTION

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

/datum/reagent/compound/plasticide // fictional
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic. Not safe to eat."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/compound/serotrotium // this is apparently a fictional compound
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans." // i dont think this properly reflects its property
	reagent_state = LIQUID
	color = "#202040" // rgb: 20, 20, 40
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_ALLERGENIC = 2)

/datum/reagent/compound/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A synthetic cleaner that vaporizes quickly and isn't slippery like water. It is therefore used as a compound for cleaning in space and low gravity environments. Very effective at sterilizing surfaces."
	reagent_state = LIQUID
	color = "#A5F0EE" // rgb: 165, 240, 238
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/compound/space_cleaner/reaction_obj(obj/O, volume)
	if(istype(O, /obj/effect/decal/cleanable))
		var/obj/effect/decal/cleanable/C = O
		C.cleanup_cleanable()
	else if(O)
		O.clean_blood()

/datum/reagent/compound/space_cleaner/reaction_turf(turf/T, volume)
	if(volume >= 1 && istype(T))
		T.clean_cleanables()

/datum/reagent/compound/space_cleaner/reaction_mob(mob/M, method=TOUCH, volume, permeable)
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

/datum/reagent/compound/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "A component to making spaceacilin."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/compound/fluorosurfactant//foam precursor
	name = "Fluorosurfactant"
	id = "fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	reagent_state = LIQUID
	color = "#9E6B38" // rgb: 158, 107, 56
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/compound/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "An agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/compound/foaming_agent/stabilized
	name = "Stabilized metallic foam"
	id = "stablefoam"
	description = "Stabilized metallic foam that solidifies when exposed to an open flame"
	reagent_state = LIQUID
	color = "#d4b8d1"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 8)

/datum/reagent/compound/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizers or household cleaners."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/compound/ammonia/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += 0.5*volume
	processing_tray.yield_mod += 0.1*volume
	processing_tray.nutrilevel += 2*volume

/datum/reagent/compound/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC" // rgb: 255, 255, 204

/datum/reagent/compound/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "Diethylamine is used as a potent fertilizer and as an alternative to ammonia. Also used in the preparation rubber processing chemicals, agricultural chemicals, and pharmaceuticals."
	reagent_state = LIQUID
	color = "#604030" // rgb: 96, 64, 48
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/compound/diethylamine/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += 0.8*volume
	processing_tray.yield_mod += 0.3*volume
	processing_tray.nutrilevel += 2*volume
