/datum/chem_property/negative
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_TOXICANT
	value = -2

/datum/chem_property/negative/process(mob/living/M, potency = 1, delta_time)
	M.last_damage_data = create_cause_data("Harmful substance", holder.last_source_mob?.resolve())

	return ..()

/datum/chem_property/negative/can_cause_harm()
	return TRUE

/datum/chem_property/negative/hypoxemic
	name = PROPERTY_HYPOXEMIC
	code = "HPX"
	description = "Reacts with hemoglobin in red blood cells preventing oxygen from being absorbed, resulting in hypoxemia."
	rarity = PROPERTY_COMMON
	value = -1

/datum/chem_property/negative/hypoxemic/process(mob/living/M, potency = 1, delta_time)
	..()
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, OXY)
	if(prob(10))
		M.emote("gasp")

/datum/chem_property/negative/hypoxemic/process_overdose(mob/living/M, potency = 1)
	M.apply_damages(potency, 0, potency)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/negative/hypoxemic/process_critical(mob/living/M, potency = 1)
	M.apply_damages(POTENCY_MULTIPLIER_VHIGH * potency, 0, POTENCY_MULTIPLIER_MEDIUM*potency)

/datum/chem_property/negative/toxic
	name = PROPERTY_TOXIC
	code = "TXC"
	description = "Poisonous substance which causes harm on contact with or through absorption by organic tissues, resulting in bad health or severe illness."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/toxic/process(mob/living/M, potency = 1, delta_time)
	..()
	M.apply_damage(0.5 * potency * delta_time, TOX)

/datum/chem_property/negative/toxic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(potency * delta_time, TOX)

/datum/chem_property/negative/toxic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(potency * POTENCY_MULTIPLIER_VHIGH, TOX)

/datum/chem_property/negative/toxic/reaction_obj(obj/O, volume, potency = 1)
	if(istype(O,/obj/effect/alien/weeds/))
		var/obj/effect/alien/weeds/alien_weeds = O
		alien_weeds.take_damage(25 * potency) // Kills alien weeds on touch
		return
	if(istype(O,/obj/effect/glowshroom))
		qdel(O)
		return
	if(istype(O,/obj/effect/plantsegment))
		if(prob(50))
			qdel(O)

/datum/chem_property/negative/toxic/reaction_mob(mob/living/M, method=TOUCH, volume, potency = 1)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	if(C.wear_mask) // Wearing a mask
		return
	C.apply_damage(potency, TOX)  // applies potency toxin damage

/datum/chem_property/negative/toxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.health += -1.5*(potency*2)*volume
	processing_tray.toxins += (potency*2)*volume

/datum/chem_property/negative/corrosive
	name = PROPERTY_CORROSIVE
	code = "CRS"
	description = "Damages or destroys other substances on contact through a chemical reaction. Causes chemical burns on contact with living tissue."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = 1 //has a combat use
	cost_penalty = FALSE

/datum/chem_property/negative/corrosive/process(mob/living/M, potency = 1, delta_time)
	..()
	M.take_limb_damage(0, 0.5 * potency * delta_time)

/datum/chem_property/negative/corrosive/process_overdose(mob/living/M, potency = 1)
	M.take_limb_damage(0,POTENCY_MULTIPLIER_MEDIUM*potency)

/datum/chem_property/negative/corrosive/process_critical(mob/living/M, potency = 1)
	M.take_limb_damage(0,POTENCY_MULTIPLIER_VHIGH*potency)

/datum/chem_property/negative/corrosive/reaction_mob(mob/living/M, method=TOUCH, volume, potency) //from sacid
	var/meltprob = potency * POTENCY_MULTIPLIER_HIGH
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.head)
				if(prob(meltprob) && !H.head.unacidable)
					to_chat(H, SPAN_DANGER("Your headgear melts away but protects you from the acid!"))
					qdel(H.head)
					H.update_inv_head(0)
					H.update_hair(0)
				else
					to_chat(H, SPAN_WARNING("Your headgear protects you from the acid."))
				return

			if(H.wear_mask)
				if(prob(meltprob) && !H.wear_mask.unacidable)
					to_chat(H, SPAN_DANGER("Your mask melts away but protects you from the acid!"))
					qdel(H.wear_mask)
					H.update_inv_wear_mask(0)
					H.update_hair(0)
				else
					to_chat(H, SPAN_WARNING("Your mask protects you from the acid."))
				return

			if(H.glasses)
				if(prob(meltprob) && !H.glasses.unacidable)
					to_chat(H, SPAN_DANGER("Your glasses melts away!"))
					qdel(H.glasses)
					H.update_inv_glasses(0)
				return

		if(!M.unacidable) //nothing left to melt, apply acid effects
			if(istype(M, /mob/living/carbon/human) && volume >= 10)
				var/mob/living/carbon/human/H = M
				var/obj/limb/affecting = H.get_limb("head")
				if(affecting)
					if(affecting.take_damage(4, 2))
						H.UpdateDamageIcon()
					if(prob(meltprob))
						if(H.pain.feels_pain)
							H.emote("scream")
			else
				M.take_limb_damage(min(6, volume))
			return
	else
		if(!M.unacidable)
			M.take_limb_damage(min(6, volume))
	if(isxeno(M))
		var/mob/living/carbon/xenomorph/xeno = M
		if(potency > POTENCY_MAX_TIER_1) //Needs level 7+ to have any effect
			xeno.AddComponent(/datum/component/status_effect/toxic_buildup, potency * volume * 0.25)

/datum/chem_property/negative/corrosive/reaction_obj(obj/O, volume, potency)
	if((istype(O,/obj/item) || istype(O,/obj/effect/glowshroom)) && prob(potency * 10))
		if(O.unacidable)
			return
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M as anything in viewers(5, O))
			to_chat(M, SPAN_WARNING("\The [O] melts."))
		qdel(O)

/datum/chem_property/negative/corrosive/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if(processing_tray.weedlevel > 0)
		processing_tray.weedlevel += -1*(potency*2)*volume
	if(processing_tray.pestlevel > 0)
		processing_tray.pestlevel += -1*(potency*2)*volume



/datum/chem_property/negative/biocidic
	name = PROPERTY_BIOCIDIC
	code = "BCD"
	description = "Ruptures cell membranes on contact, destroying most types of organic tissue."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/biocidic/process(mob/living/M, potency = 1, delta_time)
	..()
	M.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/negative/biocidic/process_overdose(mob/living/M, potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/negative/biocidic/process_critical(mob/living/M, potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_VHIGH * potency)

/datum/chem_property/negative/biocidic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if(processing_tray.weedlevel > 0)
		processing_tray.weedlevel += -1*(potency*2)*volume
	if(processing_tray.pestlevel > 0)
		processing_tray.pestlevel += -1*(potency*2)*volume

/datum/chem_property/negative/paining
	name = PROPERTY_PAINING
	code = "PNG"
	description = "Activates the somatosensory system causing neuropathic pain all over the body. Unlike nociceptive pain, this is not caused to any tissue damage and is solely perceptive."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_STIMULANT
	value = -1

/datum/chem_property/negative/paining/on_delete(mob/living/M)
	..()

	M.pain.recalculate_pain()

/datum/chem_property/negative/paining/process(mob/living/M, potency = 1, delta_time)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_PAINING_PAIN * potency)

/datum/chem_property/negative/paining/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_PAINING_PAIN_OD * potency)
	M.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/negative/paining/process_critical(mob/living/M, potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/negative/hemolytic
	name = PROPERTY_HEMOLYTIC
	code = "HML"
	description = "Causes intravascular hemolysis, resulting in the destruction of erythrocytes (red blood cells) in the bloodstream. This can result in Hemoglobinemia, where a high concentration of hemoglobin is released into the blood plasma."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hemolytic/process(mob/living/M, potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	..()
	C.blood_volume = max(C.blood_volume - POTENCY_MULTIPLIER_VHIGH * potency,0)

/datum/chem_property/negative/hemolytic/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	C.blood_volume = max(C.blood_volume - 4 * potency *  delta_time, 0)
	M.drowsyness = min(M.drowsyness + 0.5 * potency * delta_time, 15 * potency)
	M.reagent_move_delay_modifier += potency
	M.recalculate_move_delay = TRUE
	if(prob(5 * delta_time))
		M.emote(pick("yawn","gasp"))

/datum/chem_property/negative/hemolytic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/negative/hemorrhaging
	name = PROPERTY_HEMORRAGING
	code = "HMR"
	description = "Ruptures endothelial cells making up bloodvessels, causing blood to escape from the circulatory system."
	rarity = PROPERTY_UNCOMMON
	value = 2
	cost_penalty = FALSE

/datum/chem_property/negative/hemorrhaging/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(!L || L.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		return
	..()
	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		var/datum/wound/internal_bleeding/I = new (0)
		L.add_bleeding(I, TRUE)
		L.wounds += I
	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		spawn L.owner.emote("me", 1, "coughs up blood!")
		L.owner.drip(10)

/datum/chem_property/negative/hemorrhaging/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L.internal_organs)
		var/datum/internal_organ/O = pick(L.internal_organs)//Organs can't bleed, so we just damage them
		O.take_damage(POTENCY_MULTIPLIER_LOW * potency)

/datum/chem_property/negative/hemorrhaging/process_critical(mob/living/M, potency = 1, delta_time)
	if(prob(10 * potency * delta_time) && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/limb/L = pick(H.limbs)
		var/datum/wound/internal_bleeding/I = new (0)
		L.add_bleeding(I, TRUE)
		L.wounds += I

/datum/chem_property/negative/hemorrhaging/reaction_mob(mob/M, method = TOUCH, volume, potency)
	M.AddComponent(/datum/component/status_effect/healing_reduction, potency * volume * POTENCY_MULTIPLIER_VLOW) //deals brute DOT to humans, prevents healing for xenos

/datum/chem_property/negative/hemorrhaging/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += -1*(potency*2)*volume
	processing_tray.mutation_mod+= 0.2*(potency*2)*volume


/datum/chem_property/negative/carcinogenic
	name = PROPERTY_CARCINOGENIC
	code = "CRG"
	description = "Penetrates the cell nucleus causing direct damage to the deoxyribonucleic acid in cells resulting in cancer and abnormal cell proliferation. In extreme cases causing hyperactive apoptosis and potentially atrophy."
	rarity = PROPERTY_COMMON

/datum/chem_property/negative/carcinogenic/process(mob/living/M, potency = 1, delta_time)
	..()
	M.adjustCloneLoss(POTENCY_MULTIPLIER_LOW*potency)

/datum/chem_property/negative/carcinogenic/process_overdose(mob/living/M, potency = 1)
	M.adjustCloneLoss(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/negative/carcinogenic/process_critical(mob/living/M, potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)//Hyperactive apoptosis

/datum/chem_property/negative/carcinogenic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.toxins += 1.5*(potency*2)*volume
	processing_tray.mutation_level += 10*(potency*2)*volume + processing_tray.mutation_mod


/datum/chem_property/negative/hepatotoxic
	name = PROPERTY_HEPATOTOXIC
	code = "HPT"
	description = "Damages hepatocytes in the liver, resulting in liver deterioration and eventually liver failure."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hepatotoxic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "liver")

/datum/chem_property/negative/hepatotoxic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, TOX)

/datum/chem_property/negative/hepatotoxic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, TOX)

/datum/chem_property/negative/intravenous
	name = PROPERTY_INTRAVENOUS
	code = "INV"
	description = "Due to chemical composition, this chemical can only be administered intravenously. The side effect is improving absorption on the chemical, although this is less effective than natural absorption"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/negative/intravenous/pre_process(mob/living/M)
	return list(REAGENT_BOOST = level)

/datum/chem_property/negative/intravenous/reset_reagent()
	holder.flags = initial(holder.flags)
	holder.custom_metabolism = initial(holder.custom_metabolism)
	return ..()

/datum/chem_property/negative/intravenous/update_reagent()
	holder.flags |= REAGENT_NOT_INGESTIBLE
	holder.custom_metabolism = holder.custom_metabolism * (level)
	return ..()

/datum/chem_property/negative/nephrotoxic
	name = PROPERTY_NEPHROTOXIC
	code = "NPT"
	description = "Causes deterioration and damage to podocytes in the kidney resulting in potential kidney failure."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/nephrotoxic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "kidneys")

/datum/chem_property/negative/nephrotoxic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, TOX)

/datum/chem_property/negative/nephrotoxic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, TOX)

/datum/chem_property/negative/pneumotoxic
	name = PROPERTY_PNEUMOTOXIC
	code = "PNT"
	description = "Toxic substance which causes damage to connective tissue that forms the support structure (the interstitium) of the alveoli in the lungs."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/pneumotoxic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "lungs")

/datum/chem_property/negative/pneumotoxic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, OXY)

/datum/chem_property/negative/pneumotoxic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/negative/oculotoxic
	name = PROPERTY_OCULOTOXIC
	code = "OCT"
	description = "Damages the photoreceptive cells in the eyes impairing neural transmissions to the brain, resulting in loss of sight or blindness."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/oculotoxic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	var/mob/living/carbon/human/H = M
	var/datum/internal_organ/eyes/L = H.internal_organs_by_name["eyes"]
	if(L)
		L.take_damage(POTENCY_MULTIPLIER_LOW * potency)

/datum/chem_property/negative/oculotoxic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.sdisabilities |= DISABILITY_BLIND

/datum/chem_property/negative/oculotoxic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_LOW * potency, BRAIN)

/datum/chem_property/negative/cardiotoxic
	name = PROPERTY_CARDIOTOXIC
	code = "CDT"
	description = "Attacks cardiomyocytes when passing through the heart in the bloodstream. This disrupts the cardiac cycle and can lead to cardiac arrest."
	rarity = PROPERTY_COMMON

/datum/chem_property/negative/cardiotoxic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	..()
	M.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "heart")

/datum/chem_property/negative/cardiotoxic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, OXY)

/datum/chem_property/negative/cardiotoxic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/negative/neurotoxic
	name = PROPERTY_NEUROTOXIC
	code = "NRT"
	description = "Breaks down neurons causing widespread damage to the central nervous system and brain functions. Exposure may cause disorientation or unconsciousness to affected persons."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_TOXICANT|PROPERTY_TYPE_STIMULANT
	cost_penalty = FALSE

/datum/chem_property/negative/neurotoxic/process(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, BRAIN)

/datum/chem_property/negative/neurotoxic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_HIGH * potency, BRAIN)
	M.jitteriness = min(M.jitteriness + potency, POTENCY_MULTIPLIER_HIGH * potency)
	if(prob(50))
		M.drowsyness = min(M.drowsyness + potency, POTENCY_MULTIPLIER_HIGH * potency)
	if(prob(10))
		M.emote("drool")

/datum/chem_property/negative/neurotoxic/process_critical(mob/living/M, potency = 1)
	if(prob(15*potency))
		apply_neuro(M, POTENCY_MULTIPLIER_MEDIUM * potency, FALSE)

/datum/chem_property/negative/neurotoxic/reaction_mob(mob/M, method = TOUCH, volume, potency)
	if(ishuman(M))
		var/mob/living/carbon/human/human = M
		human.Daze(potency * volume * POTENCY_MULTIPLIER_VLOW)
		to_chat(human, SPAN_WARNING("You start to go numb."))
	if(isxeno(M))
		var/mob/living/carbon/xenomorph/xeno = M
		xeno.AddComponent(/datum/component/status_effect/daze, volume * potency * POTENCY_MULTIPLIER_LOW, 30)

/datum/chem_property/negative/hypermetabolic
	name = PROPERTY_HYPERMETABOLIC
	code = "EMB"
	description = "Takes less time for this chemical to metabolize, resulting in it being in the bloodstream for less time per unit."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/negative/hypermetabolic/reset_reagent()
	holder.custom_metabolism = initial(holder.custom_metabolism)
	..()

/datum/chem_property/negative/hypermetabolic/update_reagent()
	holder.custom_metabolism = holder.custom_metabolism * (1 + POTENCY_MULTIPLIER_VLOW * level)
	..()

/datum/chem_property/negative/hypermetabolic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.metabolism_adjust += clamp(-20*potency, 0, -130)



/datum/chem_property/negative/addictive
	name = PROPERTY_ADDICTIVE
	code = "ADT"
	description = "Causes addiction. Higher potency results in a higher chance of causing an addiction when metabolized."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/negative/addictive/process(mob/living/M, potency = 1, delta_time)
	var/has_addiction
	for(var/datum/disease/addiction/D in M.viruses)
		if(D.chemical_id == holder.id)
			D.handle_chem()
			has_addiction = TRUE
			break
	if(!has_addiction)
		var/datum/disease/addiction/D = new /datum/disease/addiction(holder.id, potency)
		M.contract_disease(D, TRUE)

/datum/chem_property/negative/addictive/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRAIN)

/datum/chem_property/negative/addictive/process_critical(mob/living/M, potency = 1, delta_time)
	M.disabilities |= NERVOUS

//PROPERTY_DISABLED (in generation)
/datum/chem_property/negative/hemositic
	name = PROPERTY_HEMOSITIC
	code = "HST"
	description = "The chemical shows parasitic behavior towards live erythrocytes (red blood cells) in order to produce more of itself."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 1

/datum/chem_property/negative/hemositic/pre_process(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.flags & IS_SYNTHETIC)
			return list(REAGENT_CANCEL = TRUE)

/datum/chem_property/negative/hemositic/process(mob/living/M, potency = 1, delta_time)
	if(!iscarbon(M))
		return
	..()
	var/mob/living/carbon/C = M
	if(M.nutrition >= NUTRITION_LOW)
		C.blood_volume = max(C.blood_volume - POTENCY_MULTIPLIER_HIGH * potency, 0)
		holder.volume++
	else
		C.blood_volume = max(C.blood_volume - POTENCY_MULTIPLIER_LOW * potency, 0)


/datum/chem_property/negative/hemositic/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	C.blood_volume = max(C.blood_volume-10*potency,0)
	holder.volume += potency * POTENCY_MULTIPLIER_MEDIUM

/datum/chem_property/negative/hemositic/process_critical(mob/living/M, potency = 1, delta_time)
	M.disabilities |= NERVOUS

/datum/chem_property/negative/igniting
	name = PROPERTY_IGNITING
	code = "IGT"
	description = "The chemical appears capable of self-igniting on contact with most materials."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_COMBUSTIBLE
	value = 1

/datum/chem_property/negative/igniting/process(mob/living/reacting_mob, potency, delta_time)
	. = ..()

	reacting_mob.adjust_fire_stacks(max(reacting_mob.fire_stacks, potency * 30))
	reacting_mob.IgniteMob(TRUE)
	to_chat(reacting_mob, SPAN_DANGER("It burns! It burns worse than you could ever have imagined!"))
