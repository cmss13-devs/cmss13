/datum/chem_property/negative
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_TOXICANT
	value = -2

/datum/chem_property/negative/process(mob/living/victim, potency = 1, delta_time)
	victim.last_damage_data = create_cause_data("Harmful substance", holder.last_source_mob?.resolve())

	return ..()

/datum/chem_property/negative/can_cause_harm()
	return TRUE

/datum/chem_property/negative/hypoxemic
	name = PROPERTY_HYPOXEMIC
	code = "HPX"
	description = "Reacts with hemoglobin in red blood cells preventing oxygen from being absorbed, resulting in hypoxemia."
	rarity = PROPERTY_COMMON
	value = -1

/datum/chem_property/negative/hypoxemic/process(mob/living/victim, potency = 1, delta_time)
	..()
	victim.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, OXY)
	if(prob(10))
		victim.emote("gasp")

/datum/chem_property/negative/hypoxemic/process_overdose(mob/living/victim, potency = 1)
	victim.apply_damages(potency, 0, potency)
	victim.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/negative/hypoxemic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damages(POTENCY_MULTIPLIER_VHIGH * potency, 0, POTENCY_MULTIPLIER_MEDIUM*potency)

/datum/chem_property/negative/toxic
	name = PROPERTY_TOXIC
	code = "TXC"
	description = "Poisonous substance which causes harm on contact with or through absorption by organic tissue, resulting in bad health, severe illness, or plant death."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/toxic/process(mob/living/victim, potency = 1, delta_time)
	..()
	victim.apply_damage(0.5 * potency * delta_time, TOX)

/datum/chem_property/negative/toxic/process_overdose(mob/living/victim, potency = 1, delta_time)
	victim.apply_damage(potency * delta_time, TOX)

/datum/chem_property/negative/toxic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(potency * POTENCY_MULTIPLIER_VHIGH, TOX)

/datum/chem_property/negative/toxic/reaction_mob(mob/living/victim, method=TOUCH, volume, potency = 1)
	if(!iscarbon(victim))
		return
	var/mob/living/carbon/humanoid = victim
	if(humanoid.wear_mask) // Wearing a mask
		return
	humanoid.apply_damage(potency, TOX)  // applies potency toxin damage

/datum/chem_property/negative/toxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.health += -1.5*(potency*2)*volume
	processing_tray.toxins += (potency*2)*volume

/datum/chem_property/negative/corrosive
	name = PROPERTY_CORROSIVE
	code = "CRS"
	description = "Damages or destroys other substances on contact through a chemical reaction. Causes chemical burns on contact with living tissue. Reduces pest and weed populations."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = 1 //has a combat use
	cost_penalty = FALSE

/datum/chem_property/negative/corrosive/process(mob/living/victim, potency = 1, delta_time)
	..()
	victim.take_limb_damage(0, 0.5 * potency * delta_time)

/datum/chem_property/negative/corrosive/process_overdose(mob/living/victim, potency = 1)
	victim.take_limb_damage(0,POTENCY_MULTIPLIER_MEDIUM*potency)

/datum/chem_property/negative/corrosive/process_critical(mob/living/victim, potency = 1)
	victim.take_limb_damage(0,POTENCY_MULTIPLIER_VHIGH*potency)

/datum/chem_property/negative/corrosive/reaction_mob(mob/living/victim, method=TOUCH, volume, potency) //from sacid
	var/meltprob = potency * POTENCY_MULTIPLIER_HIGH
	if(!istype(victim, /mob/living))
		return
	if(method == TOUCH)
		if(ishuman(victim))
			var/mob/living/carbon/human/human = victim
			if(human.head)
				if(prob(meltprob) && !human.head.unacidable)
					to_chat(human, SPAN_DANGER("Your headgear melts away but protects you from the acid!"))
					qdel(human.head)
					human.update_inv_head(0)
					human.update_hair(0)
				else
					to_chat(human, SPAN_WARNING("Your headgear protects you from the acid."))
				return

			if(human.wear_mask)
				if(prob(meltprob) && !human.wear_mask.unacidable)
					to_chat(human, SPAN_DANGER("Your mask melts away but protects you from the acid!"))
					qdel(human.wear_mask)
					human.update_inv_wear_mask(0)
					human.update_hair(0)
				else
					to_chat(human, SPAN_WARNING("Your mask protects you from the acid."))
				return

			if(human.glasses)
				if(prob(meltprob) && !human.glasses.unacidable)
					to_chat(human, SPAN_DANGER("Your [human.glasses] melt[human.glasses.gender != PLURAL ? "s" : ""] away!"))
					qdel(human.glasses)
					human.update_inv_glasses(0)
				return

		if(!victim.unacidable) //nothing left to melt, apply acid effects
			if(istype(victim, /mob/living/carbon/human) && volume >= 10)
				var/mob/living/carbon/human/human = victim
				var/obj/limb/affecting = human.get_limb("head")
				if(affecting)
					affecting.take_damage(4, 2)
					if(prob(meltprob))
						if(human.pain.feels_pain)
							human.emote("scream")
			else
				victim.take_limb_damage(min(6, volume))
			return
	else
		if(!victim.unacidable)
			victim.take_limb_damage(min(6, volume))
	if(isxeno(victim))
		var/mob/living/carbon/xenomorph/xeno = victim
		if(potency > POTENCY_MAX_TIER_1) //Needs level 7+ to have any effect
			xeno.AddComponent(/datum/component/status_effect/toxic_buildup, potency * volume * 0.25)

/datum/chem_property/negative/corrosive/reaction_obj(obj/reacting_object, volume, potency)
	if((istype(reacting_object,/obj/item) || istype(reacting_object,/obj/effect/glowshroom)) && prob(potency * 10))
		if(reacting_object.unacidable)
			return
		var/obj/effect/decal/cleanable/molten_item/int_bleeding =new/obj/effect/decal/cleanable/molten_item(reacting_object.loc)
		int_bleeding.desc = "Looks like this was \an [reacting_object] some time ago."
		for(var/mob/viewer as anything in viewers(5, reacting_object))
			to_chat(viewer, SPAN_WARNING("\The [reacting_object] melts."))
		qdel(reacting_object)

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
	description = "Ruptures cell membranes on contact, destroying most types of organic tissue. Reduces pest and weed populations."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = -1

/datum/chem_property/negative/biocidic/process(mob/living/victim, potency = 1, delta_time)
	..()
	victim.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/negative/biocidic/process_overdose(mob/living/victim, potency = 1)
	victim.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/negative/biocidic/process_critical(mob/living/victim, potency = 1)
	victim.take_limb_damage(POTENCY_MULTIPLIER_VHIGH * potency)

/datum/chem_property/negative/biocidic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if(processing_tray.weedlevel > 0)
		processing_tray.weedlevel += -1*(potency*2)*volume
	if(processing_tray.pestlevel > 0)
		processing_tray.pestlevel += -1*(potency*2)*volume

/datum/chem_property/negative/neuropathic
	name = PROPERTY_NEUROPATHIC
	code = "NPT"
	description = "Activates the somatosensory system causing neuropathic pain all over the body. Unlike nociceptive pain, this is not caused to any tissue damage and is solely perceptive."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_STIMULANT
	value = -1

/datum/chem_property/negative/neuropathic/on_delete(mob/living/victim)
	..()

	victim.pain.recalculate_pain()

/datum/chem_property/negative/neuropathic/process(mob/living/victim, potency = 1, delta_time)
	if(!(..()))
		return

	victim.pain.apply_pain(PROPERTY_NEUROPATHIC_PAIN * potency)

/datum/chem_property/negative/neuropathic/process_overdose(mob/living/victim, potency = 1, delta_time)
	if(!(..()))
		return

	victim.pain.apply_pain(PROPERTY_NEUROPATHIC_PAIN_OD * potency)
	victim.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/negative/neuropathic/process_critical(mob/living/victim, potency = 1)
	victim.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/negative/hemolytic
	name = PROPERTY_HEMOLYTIC
	code = "HML"
	description = "Causes intravascular hemolysis, resulting in the destruction of erythrocytes (red blood cells) in the bloodstream. This can result in Hemoglobinemia, where a high concentration of hemoglobin is released into the blood plasma."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hemolytic/process(mob/living/victim, potency = 1, delta_time)
	if(!iscarbon(victim))
		return
	var/mob/living/carbon/humanoid = victim
	..()
	humanoid.blood_volume = max(humanoid.blood_volume - POTENCY_MULTIPLIER_VHIGH * potency,0)

/datum/chem_property/negative/hemolytic/process_overdose(mob/living/victim, potency = 1, delta_time)
	if(!iscarbon(victim))
		return
	var/mob/living/carbon/humanoid = victim
	humanoid.blood_volume = max(humanoid.blood_volume - 4 * potency *  delta_time, 0)
	victim.drowsiness = min(victim.drowsiness + 0.5 * potency * delta_time, 15 * potency)
	victim.reagent_move_delay_modifier += potency
	victim.recalculate_move_delay = TRUE
	if(prob(5 * delta_time))
		victim.emote(pick("yawn","gasp"))

/datum/chem_property/negative/hemolytic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/negative/hemorrhaging
	name = PROPERTY_HEMORRHAGING
	code = "HMR"
	description = "Ruptures endothelial cells making up blood vessels, causing blood to escape from the circulatory system. Persistent mutagen to plants."
	rarity = PROPERTY_UNCOMMON
	value = 1
	cost_penalty = FALSE

/datum/chem_property/negative/hemorrhaging/process(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	var/mob/living/carbon/human/human = victim
	var/obj/limb/limb = pick(human.limbs)
	if(!limb || limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		return
	..()
	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		var/datum/wound/internal_bleeding/int_bleeding =new (0)
		limb.add_bleeding(int_bleeding, TRUE)
		limb.wounds += int_bleeding
		limb.owner.custom_pain("You feel something rip in your [limb.display_name]!", 1)

	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		spawn limb.owner.emote("me", 1, "coughs up blood!")
		limb.owner.drip(10)

/datum/chem_property/negative/hemorrhaging/process_overdose(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	var/mob/living/carbon/human/human = victim
	var/obj/limb/limb = pick(human.limbs)
	if(limb.internal_organs)
		var/datum/internal_organ/organ = pick(limb.internal_organs)//Organs can't bleed, so we just damage them
		organ.take_damage(POTENCY_MULTIPLIER_LOW * potency)

/datum/chem_property/negative/hemorrhaging/process_critical(mob/living/victim, potency = 1, delta_time)
	if(prob(10 * potency * delta_time) && ishuman(victim))
		var/mob/living/carbon/human/human = victim
		var/obj/limb/limb = pick(human.limbs)
		var/datum/wound/internal_bleeding/int_bleeding =new (0)
		limb.owner.custom_pain("You feel something burst in your [limb.display_name]!", 1)
		limb.add_bleeding(int_bleeding, TRUE)
		limb.wounds += int_bleeding

/datum/chem_property/negative/hemorrhaging/reaction_mob(mob/victim, method = TOUCH, volume, potency)
	victim.AddComponent(/datum/component/status_effect/healing_reduction, potency * volume * POTENCY_MULTIPLIER_VLOW) //deals brute DOT to humans, prevents healing for xenos

/datum/chem_property/negative/hemorrhaging/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += -0.2*(potency*2)*volume
	processing_tray.mutation_mod+= 0.2*(potency*2)*volume


/datum/chem_property/negative/carcinogenic
	name = PROPERTY_CARCINOGENIC
	code = "CRG"
	description = "Penetrates the cell nucleus causing direct damage to the deoxyribonucleic acid in cells resulting in cancer, abnormal cell proliferation, and mutation in plants. In extreme cases causing hyperactive apoptosis, potentially atrophy."
	rarity = PROPERTY_COMMON

/datum/chem_property/negative/carcinogenic/process(mob/living/victim, potency = 1, delta_time)
	..()
	victim.adjustCloneLoss(POTENCY_MULTIPLIER_LOW*potency)

/datum/chem_property/negative/carcinogenic/process_overdose(mob/living/victim, potency = 1)
	victim.adjustCloneLoss(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/negative/carcinogenic/process_critical(mob/living/victim, potency = 1)
	victim.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)//Hyperactive apoptosis

/datum/chem_property/negative/carcinogenic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.toxins += 1.5*(potency*2)*volume
	processing_tray.mutation_level += 10*(potency*2)*volume + processing_tray.mutation_mod


/datum/chem_property/negative/hepatotoxic
	name = PROPERTY_HEPATOTOXIC
	code = "HPT"
	description = "Damages hepatocytes in the liver, resulting in liver deterioration and eventually liver failure. Prevents some negative mutations in plants."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/hepatotoxic/process(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	..()
	victim.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "liver")

/datum/chem_property/negative/hepatotoxic/process_overdose(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, TOX)

/datum/chem_property/negative/hepatotoxic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, TOX)

//Applies mutation cancel onto hydrotray plants, negative affects like increasing consumption and lowering life
/datum/chem_property/negative/hepatotoxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if (processing_tray.mutation_controller["Plant Cancer"] > potency*-2)
		processing_tray.mutation_controller["Plant Cancer"] = potency*-2
	if (processing_tray.mutation_controller["Gluttony"] > potency*-2)
		processing_tray.mutation_controller["Gluttony"] = potency*-2

/datum/chem_property/negative/intravenous
	name = PROPERTY_INTRAVENOUS
	code = "INV"
	description = "Due to chemical composition, this chemical can only be administered intravenously."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/negative/intravenous/pre_process(mob/living/victim)
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
	description = "Causes deterioration and damage to podocytes in the kidney resulting in potential kidney failure. Prevents the tolerance to light, weeds, and toxins from mutating in plants."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/nephrotoxic/process(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	..()
	victim.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "kidneys")

/datum/chem_property/negative/nephrotoxic/process_overdose(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, TOX)

/datum/chem_property/negative/nephrotoxic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, TOX)

//Applies mutation cancel onto hydrotray plants, prevents tolerance adjustment, parasitic and carnivorous
/datum/chem_property/negative/nephrotoxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if (processing_tray.mutation_controller["Light Tolerance"] > potency*-2)
		processing_tray.mutation_controller["Light Tolerance"] = potency*-2
	if (processing_tray.mutation_controller["Weed Tolerance"] > potency*-2)
		processing_tray.mutation_controller["Weed Tolerance"] = potency*-2
	if (processing_tray.mutation_controller["Toxin Tolerance"] > potency*-2)
		processing_tray.mutation_controller["Toxin Tolerance"] = potency*-2

/datum/chem_property/negative/pneumotoxic
	name = PROPERTY_PNEUMOTOXIC
	code = "PNT"
	description = "Toxic substance which causes damage to connective tissue that forms the support structure (the interstitium) of the alveoli in the lungs. Prevents growth speed and health from mutation in plants."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/pneumotoxic/process(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	..()
	victim.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "lungs")

/datum/chem_property/negative/pneumotoxic/process_overdose(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, OXY)

/datum/chem_property/negative/pneumotoxic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

//Applies mutation cancel onto hydrotray plants, prevents plant life, yield, grow times and repeat harvest mutation
/datum/chem_property/negative/pneumotoxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if (processing_tray.mutation_controller["Endurance"] > potency*-2)
		processing_tray.mutation_controller["Endurance"] = potency*-2
	if (processing_tray.mutation_controller["Production"] > potency*-2)
		processing_tray.mutation_controller["Production"] = potency*-2
	if (processing_tray.mutation_controller["Lifespan"] > potency*-2)
		processing_tray.mutation_controller["Lifespan"] = potency*-2
	if (processing_tray.mutation_controller["Maturity"] > potency*-2)
		processing_tray.mutation_controller["Maturity"] = potency*-2


/datum/chem_property/negative/oculotoxic
	name = PROPERTY_OCULOTOXIC
	code = "OCT"
	description = "Damages the photoreceptive cells in the eyes impairing neural transmissions to the brain, resulting in loss of sight or blindness. Prevents potency from mutation in plants."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/negative/oculotoxic/process(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	..()
	var/mob/living/carbon/human/human = victim
	var/datum/internal_organ/eyes/eyes = human.internal_organs_by_name["eyes"]
	if(eyes)
		eyes.take_damage(POTENCY_MULTIPLIER_LOW * potency)

/datum/chem_property/negative/oculotoxic/process_overdose(mob/living/victim, potency = 1, delta_time)
	victim.sdisabilities |= DISABILITY_BLIND

/datum/chem_property/negative/oculotoxic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_LOW * potency, BRAIN)

//Applies mutation cancel onto hydrotray plants, prevents potency, glowing or flowers mutations
/datum/chem_property/negative/oculotoxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if (processing_tray.mutation_controller["Potency"] > potency*-2)
		processing_tray.mutation_controller["Potency"] = potency*-2
	if (processing_tray.mutation_controller["Bioluminescence"] > potency*-2)
		processing_tray.mutation_controller["Bioluminescence"] = potency*-2
	if (processing_tray.mutation_controller["Flowers"] > potency*-2)
		processing_tray.mutation_controller["Flowers"] = potency*-2

/datum/chem_property/negative/cardiotoxic
	name = PROPERTY_CARDIOTOXIC
	code = "CDT"
	description = "Attacks cardiomyocytes when passing through the heart in the bloodstream. This disrupts the cardiac cycle and can lead to cardiac arrest. Prevents produced chemicals from mutation in plants."
	rarity = PROPERTY_COMMON

/datum/chem_property/negative/cardiotoxic/process(mob/living/victim, potency = 1, delta_time)
	if(!ishuman(victim))
		return
	..()
	victim.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "heart")

/datum/chem_property/negative/cardiotoxic/process_overdose(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, OXY)

/datum/chem_property/negative/cardiotoxic/process_critical(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

//Applies mutation cancel onto hydrotray plants, prevents new chems from being added
/datum/chem_property/negative/cardiotoxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if (processing_tray.mutation_controller["New Chems"] > potency*-2)
		processing_tray.mutation_controller["New Chems"] = potency*-2
	if (processing_tray.mutation_controller["New Chems2"] > potency*-2)
		processing_tray.mutation_controller["New Chems2"] = potency*-2
	if (processing_tray.mutation_controller["New Chems3"] > potency*-2)
		processing_tray.mutation_controller["New Chems3"] = potency*-2

/datum/chem_property/negative/neurotoxic
	name = PROPERTY_NEUROTOXIC
	code = "NRT"
	description = "Breaks down neurons causing widespread damage to the central nervous system and brain functions. Exposure may cause disorientation or unconsciousness to affected persons. Prevents species mutation in plants."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_TOXICANT|PROPERTY_TYPE_STIMULANT
	cost_penalty = FALSE

/datum/chem_property/negative/neurotoxic/process(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, BRAIN)

/datum/chem_property/negative/neurotoxic/process_overdose(mob/living/victim, potency = 1)
	victim.apply_damage(POTENCY_MULTIPLIER_HIGH * potency, BRAIN)
	victim.jitteriness = min(victim.jitteriness + potency, POTENCY_MULTIPLIER_HIGH * potency)
	if(prob(50))
		victim.drowsiness = min(victim.drowsiness + potency, POTENCY_MULTIPLIER_HIGH * potency)
	if(prob(10))
		victim.emote("drool")

/datum/chem_property/negative/neurotoxic/process_critical(mob/living/victim, potency = 1)
	if(prob(15*potency))
		apply_neuro(victim, POTENCY_MULTIPLIER_MEDIUM * potency, FALSE)

/datum/chem_property/negative/neurotoxic/reaction_mob(mob/victim, method = TOUCH, volume, potency)
	if(ishuman(victim))
		var/mob/living/carbon/human/human = victim
		human.Daze(potency * volume * POTENCY_MULTIPLIER_VLOW)
		to_chat(human, SPAN_WARNING("You start to go numb."))
	if(isxeno(victim))
		var/mob/living/carbon/xenomorph/xeno = victim
		xeno.AddComponent(/datum/component/status_effect/daze, volume * potency * POTENCY_MULTIPLIER_LOW, 30)

//Applies mutation cancel onto hydrotray plants, prevents species mutation
/datum/chem_property/negative/neurotoxic/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	if (processing_tray.mutation_controller["Mutate Species"] > potency*-2)
		processing_tray.mutation_controller["Mutate Species"] = potency*-2

/datum/chem_property/negative/hypermetabolic
	name = PROPERTY_HYPERMETABOLIC
	code = "EMB"
	description = "Takes less time for this chemical to metabolize, resulting in it being in the bloodstream for less time per unit. Accelerates plant growth."
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

/datum/chem_property/negative/addictive/process(mob/living/victim, potency = 1, delta_time)
	var/has_addiction
	for(var/datum/disease/addiction/disease in victim.viruses)
		if(disease.chemical_id == holder.id)
			disease.handle_chem()
			has_addiction = TRUE
			break
	if(!has_addiction)
		var/datum/disease/addiction/disease = new /datum/disease/addiction(holder.id, potency)
		victim.contract_disease(disease, TRUE)

/datum/chem_property/negative/addictive/process_overdose(mob/living/victim, potency = 1, delta_time)
	victim.apply_damage(0.5 * potency * delta_time, BRAIN)

/datum/chem_property/negative/addictive/process_critical(mob/living/victim, potency = 1, delta_time)
	victim.disabilities |= NERVOUS

//PROPERTY_DISABLED (in generation)
/datum/chem_property/negative/hemositic
	name = PROPERTY_HEMOSITIC
	code = "HST"
	description = "The chemical shows parasitic behavior towards live erythrocytes (red blood cells) in order to produce more of itself."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 2

/datum/chem_property/negative/hemositic/pre_process(mob/living/victim)
	if(ishuman(victim))
		var/mob/living/carbon/human/human = victim
		if(human.species.flags & IS_SYNTHETIC)
			return list(REAGENT_CANCEL = TRUE)

/datum/chem_property/negative/hemositic/process(mob/living/victim, potency = 1, delta_time)
	if(!iscarbon(victim))
		return
	..()
	var/mob/living/carbon/humanoid = victim
	if(victim.nutrition >= NUTRITION_LOW)
		humanoid.blood_volume = max(humanoid.blood_volume - POTENCY_MULTIPLIER_HIGH * potency, 0)
		holder.volume++
	else
		humanoid.blood_volume = max(humanoid.blood_volume - POTENCY_MULTIPLIER_LOW * potency, 0)


/datum/chem_property/negative/hemositic/process_overdose(mob/living/victim, potency = 1, delta_time)
	if(!iscarbon(victim))
		return
	var/mob/living/carbon/humanoid = victim
	humanoid.blood_volume = max(humanoid.blood_volume-10*potency,0)
	holder.volume += potency * POTENCY_MULTIPLIER_MEDIUM

/datum/chem_property/negative/hemositic/process_critical(mob/living/victim, potency = 1, delta_time)
	victim.disabilities |= NERVOUS

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
	if(reacting_mob.IgniteMob() == IGNITE_IGNITED)
		to_chat(reacting_mob, SPAN_DANGER("It burns! It burns worse than you could ever have imagined!"))
