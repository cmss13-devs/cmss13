/datum/chem_property/positive
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE
	value = 2

/datum/chem_property/positive/antitoxic
	name = PROPERTY_ANTITOXIC
	code = "ATX"
	description = "Absorbs and neutralizes toxic chemicals in the bloodstream and allowing them to be excreted safely."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = 1

/datum/chem_property/positive/antitoxic/process(mob/living/M, potency = 1)
	M.apply_damage(-(potency * POTENCY_MULTIPLIER_MEDIUM), TOX)
	M.reagents.remove_all_type(/datum/reagent/toxin, REM, 0, 1)

/datum/chem_property/positive/antitoxic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_internal_damage(0.5 * potency * delta_time, "eyes")

/datum/chem_property/positive/antitoxic/process_critical(mob/living/M, potency = 1, delta_time)
	M.drowsyness  = max(M.drowsyness, 30)

/datum/chem_property/positive/anticorrosive
	name = PROPERTY_ANTICORROSIVE
	code = "ACR"
	description = "Accelerates cell division around corroded areas in order to replace the lost tissue. Excessive use can trigger apoptosis."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = 1

/datum/chem_property/positive/anticorrosive/process(mob/living/M, potency = 1)
	M.heal_limb_damage(0, potency)
	if(potency > CREATE_MAX_TIER_1)
		M.heal_limb_damage(0, potency * POTENCY_MULTIPLIER_LOW)

/datum/chem_property/positive/anticorrosive/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damages(0.5 * potency * delta_time, 0, 0.5 * potency * delta_time) //Mixed brute/tox damage

/datum/chem_property/positive/anticorrosive/process_critical(mob/living/M, potency = 1)
	M.apply_damages(POTENCY_MULTIPLIER_VHIGH*potency, 0, POTENCY_MULTIPLIER_VHIGH*potency) //Massive brute/tox damage

/datum/chem_property/positive/neogenetic
	name = PROPERTY_NEOGENETIC
	code = "NGN"
	description = "Regenerates ruptured membranes resulting in the repair of damaged organic tissue. High concentrations can corrode the cell membranes."
	rarity = PROPERTY_COMMON
	starter = TRUE
	value = 1

/datum/chem_property/positive/neogenetic/process(mob/living/M, potency = 1)
	M.heal_limb_damage(potency, 0)
	if(potency > CREATE_MAX_TIER_1)
		M.heal_limb_damage(potency * POTENCY_MULTIPLIER_LOW, 0)

/datum/chem_property/positive/neogenetic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BURN)

/datum/chem_property/positive/neogenetic/process_critical(mob/living/M, potency = 1)
	M.apply_damages(0, POTENCY_MULTIPLIER_VHIGH * potency, POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/positive/neogenetic/reaction_mob(mob/M, method=TOUCH, volume, potency)
	if(!isxeno(M))
		return
	var/mob/living/carbon/xenomorph/X = M
	if(potency > 2) //heals at levels 5+
		X.gain_health(potency * volume * POTENCY_MULTIPLIER_LOW)

/datum/chem_property/positive/repairing
	name = PROPERTY_REPAIRING
	code = "REP"
	description = "Repairs cybernetic organs by the use of REDACTED property of REDACTED element."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_MEDICINE
	value = 2

/datum/chem_property/positive/repairing/process(mob/living/M, potency = 1, delta_time)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/human/C = M
	var/obj/limb/L = pick(C.limbs)
	if(L && (L.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
		L.heal_damage(POTENCY_MULTIPLIER_MEDIUM * potency, POTENCY_MULTIPLIER_MEDIUM * potency, robo_repair = TRUE)

/datum/chem_property/positive/repairing/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/repairing/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, TOX)

/datum/chem_property/positive/repairing/reaction_mob(mob/M, method=TOUCH, volume, potency)
	if(!ishuman(M) || method != TOUCH) //heals when sprayed on limbs
		return
	var/mob/living/carbon/human/H = M
	for(var/obj/limb/T in H.limbs)
		if(!(T.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			continue
		T.heal_damage(potency * volume,potency * volume, robo_repair = TRUE)

/datum/chem_property/positive/hemogenic
	name = PROPERTY_HEMOGENIC
	code = "HMG"
	description = "Increases the production of erythrocytes (red blood cells) in the bonemarrow, leading to polycythemia, an elevated volume of erythrocytes in the blood."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/hemogenic/process(mob/living/M, potency = 1, delta_time)
	if(!iscarbon(M))
		return
	if(M.nutrition < 200)
		return

	handle_nutrition_loss(M, potency, delta_time)
	M.blood_volume = min(M.blood_volume + potency, M.limit_blood)
	if(potency > POTENCY_MAX_TIER_1 && M.blood_volume > (M.max_blood + 10) && !isyautja(M)) //Too many red blood cells thickens the blood and leads to clotting, doesn't impact Yautja
		M.take_limb_damage(potency)
		M.apply_damage(POTENCY_MULTIPLIER_MEDIUM*potency, OXY)
		M.reagent_move_delay_modifier += potency
		M.recalculate_move_delay = TRUE

/datum/chem_property/positive/hemogenic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/hemogenic/process_critical(mob/living/M, potency = 1)
	M.nutrition = max(M.nutrition - POTENCY_MULTIPLIER_VHIGH*potency, 0)

/datum/chem_property/positive/hemogenic/proc/handle_nutrition_loss(mob/living/M, potency = 1, delta_time)
	M.nutrition = max(M.nutrition - potency, 0)

/datum/chem_property/positive/hemogenic/predator
	name = PROPERTY_YAUTJA_HEMOGENIC
	code = "YHM"
	rarity = PROPERTY_DISABLED

/datum/chem_property/positive/hemogenic/predator/handle_nutrition_loss(mob/living/M, potency = 1, delta_time)
	return

/datum/chem_property/positive/hemostatic
	name = PROPERTY_HEMOSTATIC
	code = "HSC"
	description = "Vastly improves the blood's natural ability to coagulate and stop bleeding by heightening platelet production and effectiveness. Overdosing will cause extreme blood clotting, resulting in severe tissue damage."
	rarity = PROPERTY_UNCOMMON
	max_level = 1
	value = 2

/datum/chem_property/positive/hemostatic/process(mob/living/affected_mob, potency = 1, delta_time)
	var/mob/living/carbon/human/effected_human = affected_mob
	effected_human.chem_effect_flags |= CHEM_EFFECT_NO_BLEEDING

/datum/chem_property/positive/hemostatic/on_delete(mob/living/affected_mob)
	var/mob/living/carbon/human/effected_human = affected_mob
	effected_human.chem_effect_flags &= CHEM_EFFECT_NO_BLEEDING

/datum/chem_property/positive/hemostatic/process_overdose(mob/living/affected_mob, potency = 1)
	affected_mob.apply_damage(potency, BRUTE)

/datum/chem_property/positive/hemostatic/process_critical(mob/living/affected_mob, potency = 1)
	affected_mob.apply_damage(potency * 9, BRUTE)
	affected_mob.apply_damage(potency * 9, BURN)
	affected_mob.apply_damage(potency * 9, TOX)

/datum/chem_property/positive/nervestimulating
	name = PROPERTY_NERVESTIMULATING
	code = "NST"
	description = "Increases neuron communication speed across synapses resulting in improved reaction time, awareness and muscular control."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT
	value = 3

/datum/chem_property/positive/nervestimulating/process(mob/living/M, potency = 1)
	M.adjust_effect(potency*-1, PARALYZE)
	M.adjust_effect(potency*-1, STUN)
	M.adjust_effect(potency*-1, WEAKEN)
	M.adjust_effect(-0.5*potency, STUN)
	if(potency > CREATE_MAX_TIER_1)
		M.stuttering = max(M.stuttering - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
		M.confused = max(M.confused - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
		M.ReduceEyeBlur(POTENCY_MULTIPLIER_MEDIUM * potency)
		M.drowsyness = max(M.drowsyness - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
		M.dizziness = max(M.dizziness - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
		M.jitteriness = max(M.jitteriness - POTENCY_MULTIPLIER_MEDIUM * potency, 0)

/datum/chem_property/positive/nervestimulating/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM*potency, TOX)

/datum/chem_property/positive/nervestimulating/process_critical(mob/living/M, potency = 1)
	M.apply_damages(potency, potency, POTENCY_MULTIPLIER_HIGH*potency)

/datum/chem_property/positive/nervestimulating/reaction_mob(mob/M, method=TOUCH, volume, potency)
	if(isxeno_human(M) && potency > POTENCY_MAX_TIER_1) //can stim on touch at level 7+
		M.set_effect(0, WEAKEN)
		M.set_effect(0, STUN)
		M.set_effect(0, DAZE)

/datum/chem_property/positive/musclestimulating
	name = PROPERTY_MUSCLESTIMULATING
	code = "MST"
	description = "Stimulates neuromuscular junctions increasing the force of muscle contractions, resulting in increased strength. High doses might exhaust the cardiac muscles."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/musclestimulating/process(mob/living/M, potency = 1)
	M.reagent_move_delay_modifier -= POTENCY_MULTIPLIER_VLOW * potency
	M.recalculate_move_delay = TRUE
	M.nutrition = max(0, M.nutrition - 0.5 * HUNGER_FACTOR)
	if(prob(10))
		M.emote(pick("twitch","blink_r","shiver"))

/datum/chem_property/positive/musclestimulating/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(0.5 * potency * delta_time, "heart")

/datum/chem_property/positive/musclestimulating/process_critical(mob/living/M, potency = 1, delta_time)
	M.take_limb_damage(0.5 * potency * delta_time)

/datum/chem_property/positive/musclestimulating/reaction_mob(mob/M, method = TOUCH, volume, potency = 1)
	if(!isxeno_human(M))
		return
	M.AddComponent(/datum/component/status_effect/speed_modifier, volume, TRUE, AMOUNT_PER_TIME(1, potency SECONDS), potency*volume) //Long-lasting speed for beans, stamina for humans

/datum/chem_property/positive/painkilling
	name = PROPERTY_PAINKILLING
	code = "PNK"
	description = "Binds to opioid receptors in the brain and spinal cord reducing the amount of pain signals being sent to the brain."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT
	value = 1
	cost_penalty = FALSE

/datum/chem_property/positive/painkilling/on_delete(mob/living/M)
	..()

	M.pain.reset_pain_reduction()

/datum/chem_property/positive/painkilling/process(mob/living/M, potency = 1, delta_time)
	if(!..())
		return
	var/effective_potency = (CHECK_BITFIELD(M.disabilities, OPIATE_RECEPTOR_DEFICIENCY) ? potency * 0.25 : potency)
	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * effective_potency)

/datum/chem_property/positive/painkilling/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!..())
		return
	var/effective_potency = (CHECK_BITFIELD(M.disabilities, OPIATE_RECEPTOR_DEFICIENCY) ? potency * 0.25 : potency)
	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * effective_potency)
	M.hallucination = max(M.hallucination, POTENCY_MULTIPLIER_MEDIUM * effective_potency) //Hallucinations and tox damage
	M.apply_damage(effective_potency * delta_time, TOX)

/datum/chem_property/positive/painkilling/process_critical(mob/living/M, potency = 1)
	var/effective_potency = (CHECK_BITFIELD(M.disabilities, OPIATE_RECEPTOR_DEFICIENCY) ? potency * 0.25 : potency)
	M.apply_internal_damage(POTENCY_MULTIPLIER_VVHIGH * effective_potency, "liver")
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * effective_potency, BRAIN)
	M.apply_damage(3, OXY)

/datum/chem_property/positive/hepatopeutic
	name = PROPERTY_HEPATOPEUTIC
	code = "HPP"
	description = "Treats deteriorated hepatocytes and damaged tissues in the liver, restoring organ functions."
	rarity = PROPERTY_UNCOMMON
	value = 1

/datum/chem_property/positive/hepatopeutic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-(POTENCY_MULTIPLIER_LOW * potency), "liver")

/datum/chem_property/positive/hepatopeutic/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(POTENCY_MULTIPLIER_MEDIUM * potency, "liver")

/datum/chem_property/positive/hepatopeutic/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, TOX)

/datum/chem_property/positive/nephropeutic
	name = PROPERTY_NEPHROPEUTIC
	code = "NPP"
	description = "Heals damaged and deteriorated podocytes in the kidney, restoring organ functions."
	rarity = PROPERTY_UNCOMMON
	value = 1

/datum/chem_property/positive/nephropeutic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-(POTENCY_MULTIPLIER_LOW * potency), "kidneys")

/datum/chem_property/positive/nephropeutic/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(POTENCY_MULTIPLIER_MEDIUM * potency, "kidneys")

/datum/chem_property/positive/nephropeutic/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, TOX)

/datum/chem_property/positive/pneumopeutic
	name = PROPERTY_PNEUMOPEUTIC
	code = "PNP"
	description = "Mends the interstitium tissue of the alveoli restoring respiratory functions in the lungs."
	rarity = PROPERTY_UNCOMMON
	value = 1

/datum/chem_property/positive/pneumopeutic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-(POTENCY_MULTIPLIER_LOW * potency), "lungs")

/datum/chem_property/positive/pneumopeutic/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(POTENCY_MULTIPLIER_MEDIUM * potency, "lungs")

/datum/chem_property/positive/pneumopeutic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH*potency, OXY)

/datum/chem_property/positive/oculopeutic
	name = PROPERTY_OCULOPEUTIC
	code = "OCP"
	description = "Restores sensory capabilities of photoreceptive cells in the eyes returning lost vision."
	rarity = PROPERTY_COMMON
	value = 1

/datum/chem_property/positive/oculopeutic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-potency, "eyes")
	M.ReduceEyeBlur(POTENCY_MULTIPLIER_VHIGH*potency)
	M.ReduceEyeBlind(POTENCY_MULTIPLIER_VHIGH*potency)

/datum/chem_property/positive/oculopeutic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/oculopeutic/process_critical(mob/living/M, potency = 1)
	M.apply_damages(potency, potency, POTENCY_MULTIPLIER_HIGH * potency)
	M.apply_damage(potency, BRAIN)

/datum/chem_property/positive/cardiopeutic
	name = PROPERTY_CARDIOPEUTIC
	code = "CDP"
	description = "Regenerates damaged cardiomyocytes and recovers a correct cardiac cycle and heart functionality."
	rarity = PROPERTY_UNCOMMON
	value = 1

/datum/chem_property/positive/cardiopeutic/on_delete(mob/living/M)
	..()

	M.pain.recalculate_pain()

/datum/chem_property/positive/cardiopeutic/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M) || !(..()))
		return
	M.apply_internal_damage(-(POTENCY_MULTIPLIER_LOW * potency), "heart")

/datum/chem_property/positive/cardiopeutic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM*potency, OXY)

/datum/chem_property/positive/cardiopeutic/process_critical(mob/living/M, potency = 1, delta_time)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_CARDIOPEUTIC_PAIN_CRITICAL)

/datum/chem_property/positive/neuropeutic
	name = PROPERTY_NEUROPEUTIC
	code = "NRP"
	description = "Rebuilds damaged and broken neurons in the central nervous system re-establishing brain functionality."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/neuropeutic/process(mob/living/M, potency = 1)
	M.apply_damage(-POTENCY_MULTIPLIER_HIGH * potency, BRAIN)

/datum/chem_property/positive/neuropeutic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, TOX)

/datum/chem_property/positive/neuropeutic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_HIGH * potency, BRAIN)
	M.adjust_effect(potency, STUN)

/datum/chem_property/positive/bonemending
	name = PROPERTY_BONEMENDING
	code = "BNM"
	description = "Rapidly increases the production of osteoblasts and chondroblasts while also accelerating the process of endochondral ossification. This allows broken bone tissue to be re-woven and restored quickly if the bone is correctly positioned. Overdosing may result in the bone structure growing abnormally and can have adverse effects on the skeletal structure."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/bonemending/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L)
		if(L.knitting_time > 0)
			return // only one knits at a time
		switch(L.name)
			if("groin","chest")
				L.time_to_knit = 1200 // 12 mins
			if("head")
				L.time_to_knit = 1000 // 10 mins
			if("l_hand","r_hand","r_foot","l_foot")
				L.time_to_knit = 300 // 3 mins
			if("r_leg","r_arm","l_leg","l_arm")
				L.time_to_knit = 600 // 6 mins
		if(L.time_to_knit && (L.status & LIMB_BROKEN) && L.knitting_time == -1)
			if(!(L.status & LIMB_SPLINTED))
				potency -= 1 // It'll work, but we're effectively 2 levels lower.
			if(potency > 0)
				var/total_knitting_time = world.time + L.time_to_knit - min(150*potency, L.time_to_knit - 50)
				L.knitting_time = total_knitting_time
				L.start_processing()
				to_chat(M, SPAN_NOTICE("You feel the bones in your [L.display_name] starting to knit together."))

/datum/chem_property/positive/bonemending/process_overdose(mob/living/M, potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM*potency)

/datum/chem_property/positive/bonemending/process_critical(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L)
		L.fracture(100)

/datum/chem_property/positive/fluxing
	name = PROPERTY_FLUXING
	code = "FLX"
	description = "Liquifies large crystalline and metallic structures under bodytemperature in the body and allows it to migrate to and be excreted through the skin."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/positive/fluxing/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L && prob(5 * potency * delta_time))
		if(L.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			L.take_damage(0, potency)
			return
		if(LAZYLEN(L.implants) > 0)
			var/obj/implanted_object = pick(L.implants)
			if(implanted_object)
				L.implants -= implanted_object

/datum/chem_property/positive/fluxing/process_overdose(mob/living/M, potency = 1)
	M.apply_damages(POTENCY_MULTIPLIER_MEDIUM*potency, 0, potency)

/datum/chem_property/positive/fluxing/process_critical(mob/living/M, potency = 1)
	M.apply_damages(POTENCY_MULTIPLIER_MEDIUM*potency, 0, POTENCY_MULTIPLIER_MEDIUM*potency) //Mixed brute/tox damage

/datum/chem_property/positive/neurocryogenic
	name = PROPERTY_NEUROCRYOGENIC
	code = "NRC"
	description = "Causes a temporal freeze of all neurological processes and cellular respirations in the brain. This allows the brain to be preserved for long periods of time."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT
	cost_penalty = FALSE

/datum/chem_property/positive/neurocryogenic/process(mob/living/M, potency = 1, delta_time)
	if(prob(10 * delta_time))
		to_chat(M, SPAN_WARNING("You feel like you have the worst brain freeze ever!"))
	M.apply_effect(20, PARALYZE)
	M.apply_effect(20, STUN)

/datum/chem_property/positive/neurocryogenic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.bodytemperature = max(BODYTEMP_CRYO_LIQUID_THRESHOLD, M.bodytemperature - 2.5 * potency * delta_time)

/datum/chem_property/positive/neurocryogenic/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_damage(2.5 * potency * delta_time, BRAIN)

/datum/chem_property/positive/neurocryogenic/process_dead(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	H.revive_grace_period += 2.5 SECONDS * potency * delta_time
	return TRUE

/datum/chem_property/positive/neurocryogenic/reaction_mob(mob/M, method = TOUCH, volume, potency = 1)
	if(!isxeno_human(M))
		return
	M.AddComponent(/datum/component/status_effect/speed_modifier, potency * volume * 0.5) //Brainfreeze

/datum/chem_property/positive/antiparasitic
	name = PROPERTY_ANTIPARASITIC
	code = "APS"
	description = "Antimicrobial property specifically targeting parasitic pathogens in the body disrupting their growth and potentially killing them."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/antiparasitic/process(mob/living/current_mob, potency = 1, delta_time)
	if(!ishuman(current_mob))
		return
	var/mob/living/carbon/human/current_human = current_mob
	for(var/content in current_human.contents)
		var/obj/item/alien_embryo/embryo = content
		if(embryo && istype(embryo))
			if(embryo.counter > 0)
				embryo.counter = embryo.counter - (potency * delta_time)
				current_human.take_limb_damage(0, POTENCY_MULTIPLIER_MEDIUMLOW*potency)
			else
				embryo.stage--
				if(embryo.stage <= 0)//if we reach this point, the embryo dies and the occupant takes a nasty amount of acid damage
					qdel(embryo)
					current_human.take_limb_damage(0,rand(20,40))
					current_human.vomit()
				else
					embryo.counter = embryo.per_stage_hugged_time - (potency * delta_time)

/datum/chem_property/positive/antiparasitic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/antiparasitic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH*potency, TOX)

/datum/chem_property/positive/organstabilize
	name = PROPERTY_ORGANSTABILIZE
	code = "OGS"
	description = "Stabilizes internal organ damage, stopping internal damage symptoms."
	rarity = PROPERTY_DISABLED
	value = 2

/datum/chem_property/positive/organstabilize/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.chem_effect_flags |= CHEM_EFFECT_ORGAN_STASIS

/datum/chem_property/positive/organstabilize/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRUTE)

/datum/chem_property/positive/organstabilize/process_critical(mob/living/M, potency = 1)
	M.apply_damages(POTENCY_MULTIPLIER_HIGH * potency, POTENCY_MULTIPLIER_HIGH * potency, POTENCY_MULTIPLIER_HIGH * potency)

/datum/chem_property/positive/electrogenetic
	name = PROPERTY_ELECTROGENETIC
	code = "EGN"
	description = "Stimulates cardiac muscles when exposed to electric shock and provides general healing. Useful in restarting the heart in combination with a defibrillator."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_REACTANT
	value = 1
	cost_penalty = FALSE

/datum/chem_property/positive/electrogenetic/trigger(A)
	if(isliving(A))
		var/mob/living/M = A
		M.apply_damage(-POTENCY_MULTIPLIER_EXTREME * level, BRUTE)
		M.apply_damage(-POTENCY_MULTIPLIER_EXTREME * level, BURN)
		M.apply_damage(-POTENCY_MULTIPLIER_EXTREME * level, TOX)
		M.updatehealth()

/datum/chem_property/positive/defibrillating
	name = PROPERTY_DEFIBRILLATING
	code = "DFB"
	description = "Causes an electrochemical reaction in the cardiac muscles, forcing the heart to continue pumping. May cause irregular heart rhythms."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_REACTANT
	value = 3
	cost_penalty = FALSE
	var/revivetimerid
	COOLDOWN_DECLARE(revive_notif)

/datum/chem_property/positive/defibrillating/on_delete(mob/living/M)
	..()

	M.pain.recalculate_pain()

/datum/chem_property/positive/defibrillating/process(mob/living/M, potency = 1, delta_time)
	if(prob(5 * delta_time))
		M.emote("twitch")

/datum/chem_property/positive/defibrillating/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_DEFIBRILLATING_PAIN_OD)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM*potency, OXY)

/datum/chem_property/positive/defibrillating/process_critical(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(0.5 * potency * delta_time, "heart")

/datum/chem_property/positive/defibrillating/process_dead(mob/living/affected_mob, potency = 1, delta_time)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/dead = affected_mob
	var/revivable = dead.check_tod() && dead.is_revivable()
	if(!revivable)
		return

	if(revivetimerid)
		if(dead.health <= HEALTH_THRESHOLD_DEAD) //If the mob got damaged to below the threshold while the timer was ticking then we reset
			deltimer(revivetimerid)
			revivetimerid = null
		return

	for(var/datum/reagent/electrogenetic_reagent in affected_mob.reagents.reagent_list)
		var/datum/chem_property/property = electrogenetic_reagent.get_property(PROPERTY_ELECTROGENETIC) //Adrenaline helps greatly at restarting the heart
		if(property)
			property.trigger(affected_mob)
			affected_mob.reagents.remove_reagent(electrogenetic_reagent.id, 1)
			break
	if(dead.health > HEALTH_THRESHOLD_DEAD)
		revivetimerid = addtimer(CALLBACK(dead, TYPE_PROC_REF(/mob/living/carbon/human, handle_revive)), 5 SECONDS, TIMER_STOPPABLE)
		if(!COOLDOWN_FINISHED(src, revive_notif))
			return
		COOLDOWN_START(src, revive_notif, 10 SECONDS)
		to_chat(dead, SPAN_NOTICE("You feel your heart struggling as you suddenly feel a spark, making it desperately try to continue pumping."))
		playsound_client(dead.client, 'sound/effects/heart_beat_short.ogg', 35)
		var/mob/dead/observer/ghost = dead.get_ghost()
		if(ghost?.client)
			playsound_client(ghost.client, 'sound/effects/adminhelp_new.ogg')
			to_chat(ghost, SPAN_BOLDNOTICE("Your heart is struggling to pump! There is a chance you might get up!(Verbs -> Ghost -> Re-enter corpse, or <a href='byond://?src=\ref[ghost];reentercorpse=1'>click here!</a>)"))
	else if ((potency >= 1) && dead.health <= HEALTH_THRESHOLD_DEAD) //heals on all level above 1. This is however, minimal.
		to_chat(dead, SPAN_NOTICE("You feel a faint spark in your chest."))
		dead.apply_damage(-potency * POTENCY_MULTIPLIER_VLOW, BRUTE)
		dead.apply_damage(-potency * POTENCY_MULTIPLIER_VLOW, BURN)
		dead.apply_damage(-potency * POTENCY_MULTIPLIER_VLOW, TOX)
		dead.apply_damage(-potency * POTENCY_MULTIPLIER_VLOW, CLONE)
		dead.apply_damage(-dead.getOxyLoss(), OXY)
		if(potency > CREATE_MAX_TIER_1) //heal more if higher levels
			dead.apply_damage(-potency * POTENCY_MULTIPLIER_LOW, BRUTE)
			dead.apply_damage(-potency * POTENCY_MULTIPLIER_LOW, BURN)
			dead.apply_damage(-potency * POTENCY_MULTIPLIER_LOW, TOX)
			dead.apply_damage(-potency * POTENCY_MULTIPLIER_LOW, CLONE)
	return TRUE

/datum/chem_property/positive/hyperdensificating
	name = PROPERTY_HYPERDENSIFICATING
	code = "HDN"
	description = "Causes the muscles and bones to become super dense, providing superior resistance towards the bones fracturing."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT
	value = 3
	max_level = 1

/datum/chem_property/positive/hyperdensificating/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.chem_effect_flags & CHEM_EFFECT_RESIST_FRACTURE)
		return
	H.chem_effect_flags |= CHEM_EFFECT_RESIST_FRACTURE
	if(prob(5 * delta_time))
		to_chat(M, SPAN_NOTICE("Your body feels incredibly tense."))

/datum/chem_property/positive/hyperdensificating/process_overdose(mob/living/M, potency = 1)
	M.reagent_move_delay_modifier += POTENCY_MULTIPLIER_MEDIUM*potency
	if(prob(10))
		to_chat(M, SPAN_NOTICE("It is really hard to move your body."))

/datum/chem_property/positive/hyperdensificating/process_critical(mob/living/M, potency = 1, delta_time)
	M.take_limb_damage(1.5 * potency * delta_time)

/datum/chem_property/positive/neuroshielding
	name = PROPERTY_NEUROSHIELDING
	code = "NRS"
	description = "Protects the brain from neurological damage caused by toxins."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT
	value = 3
	max_level = 1

/datum/chem_property/positive/neuroshielding/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
		return
	H.chem_effect_flags |= CHEM_EFFECT_RESIST_NEURO
	to_chat(M, SPAN_NOTICE("Your skull feels incredibly thick."))
	M.SetDaze(0)

/datum/chem_property/positive/neuroshielding/process_overdose(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	M.apply_internal_damage(0.5 * potency * delta_time, "liver")

/datum/chem_property/positive/neuroshielding/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM*potency, BRAIN)

/datum/chem_property/positive/antiaddictive
	name = PROPERTY_ANTIADDICTIVE
	code = "AAD"
	description = "Stops all bodily cravings towards addictive chemical substances."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/antiaddictive/process(mob/living/M, potency = 1, delta_time)
	for(var/datum/disease/addiction/D in M.viruses)
		if(potency > POTENCY_MAX_TIER_1)
			D.cure()
			return
		D.withdrawal_progression -= POTENCY_MULTIPLIER_MEDIUM*potency
		D.addiction_progression -= POTENCY_MULTIPLIER_MEDIUM*potency
		if(D.addiction_progression < potency)
			D.cure()

/datum/chem_property/positive/antiaddictive/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(potency * delta_time, BRAIN)

/datum/chem_property/positive/antiaddictive/process_critical(mob/living/M, potency = 1, delta_time)
	M.hallucination = max(M.hallucination, potency)

/datum/chem_property/positive/fire
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_COMBUSTIBLE
	value = 2
	cost_penalty = FALSE

	var/intensitymod_per_level = 0
	var/radiusmod_per_level = 0
	var/durationmod_per_level = 0

	var/intensity_per_level = 0
	var/range_per_level = 0
	var/duration_per_level = 0

/datum/chem_property/positive/fire/reset_reagent()
	holder.chemfiresupp = initial(holder.chemfiresupp)
	holder.radiusmod = initial(holder.radiusmod)
	holder.durationmod = initial(holder.durationmod)
	holder.intensitymod = initial(holder.intensitymod)

	holder.rangefire = initial(holder.rangefire)
	holder.durationfire = initial(holder.durationfire)
	holder.intensityfire = initial(holder.intensityfire)

	..()

/datum/chem_property/positive/fire/update_reagent()
	holder.chemfiresupp = TRUE

	holder.radiusmod += radiusmod_per_level * level
	holder.durationmod += durationmod_per_level * level
	holder.intensitymod += intensitymod_per_level * level

	holder.rangefire += range_per_level * level
	holder.durationfire += duration_per_level * level
	holder.intensityfire += intensity_per_level * level

	..()

/datum/chem_property/positive/fire/post_update_reagent()
	holder.rangefire = max(holder.rangefire, 1)
	holder.durationfire = max(holder.durationfire, 1)
	holder.intensityfire = max(holder.intensityfire, 1)

	if(holder.intensityfire >= 50 && istype(holder, /datum/reagent/generated))
		holder.burncolor = "#ffffff"
	else
		holder.burncolor = holder.color

/datum/chem_property/positive/fire/fueling
	name = PROPERTY_FUELING
	code = "FUL"
	description = "The chemical can be burned as a fuel, expanding the burn time of a chemical fire. However, this also slightly lowers heat intensity."
	rarity = PROPERTY_COMMON
	value = 1
	intensity_per_level = -2
	duration_per_level = 6

	intensitymod_per_level = -0.1
	durationmod_per_level = 0.2
	radiusmod_per_level = 0.01

/datum/chem_property/positive/fire/fueling/reaction_mob(mob/M, method = TOUCH, volume, potency = 1)
	var/mob/living/L = M
	if(istype(L) && method == TOUCH)//makes you more flammable if sprayed/splashed on you
		L.adjust_fire_stacks(volume / (2/potency))

/datum/chem_property/positive/fire/fueling/reaction_turf(turf/T, volume, potency = 1)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)

/datum/chem_property/positive/fire/fueling/reaction_obj(obj/O, volume, potency)
	var/turf/the_turf = get_turf(O) //tries to splash fuel on object's turf
	if(!the_turf)
		return
	new /obj/effect/decal/cleanable/liquid_fuel(the_turf, volume)

/datum/chem_property/positive/fire/oxidizing
	name = PROPERTY_OXIDIZING
	code = "OXI"
	description = "The chemical is oxidizing, increasing the intensity of chemical fires. However, the fuel is also burned slightly faster because of it."
	rarity = PROPERTY_COMMON
	value = 1
	intensity_per_level = 6
	duration_per_level = -2

	intensitymod_per_level = 0.2
	durationmod_per_level = -0.1
	radiusmod_per_level = -0.01

	var/static/ignite_threshold = 4

/datum/chem_property/positive/fire/oxidizing/reaction_mob(mob/M, method = TOUCH, volume, potency = 1)
	var/mob/living/L = M
	if(istype(L) && method == TOUCH)//Oxidizing 6+ makes a fire, otherwise it just adjusts fire stacks
		L.adjust_fire_stacks(max(L.fire_stacks, volume * potency))
		if(potency > /datum/chem_property/positive/fire/oxidizing::ignite_threshold)
			L.IgniteMob(TRUE)

/datum/chem_property/positive/fire/oxidizing/can_cause_harm()
	. = ..()

	if(level * LEVEL_TO_POTENCY_MULTIPLIER > /datum/chem_property/positive/fire/oxidizing::ignite_threshold)
		return TRUE

/datum/chem_property/positive/fire/flowing
	name = PROPERTY_FLOWING
	code = "FLW"
	description = "The chemical is the opposite of viscous, and it tends to spill everywhere. This could probably be used to expand the radius of a chemical fire."
	rarity = PROPERTY_COMMON
	value = 1
	range_per_level = 1

	intensitymod_per_level = -0.05
	radiusmod_per_level = 0.05
	durationmod_per_level = -0.05

/datum/chem_property/positive/explosive
	name = PROPERTY_EXPLOSIVE
	code = "EXP"
	description = "The chemical is highly explosive. Do not ignite. Careful when handling, sensitivity is based off the OD threshold, which can lead to spontanous detonation."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_COMBUSTIBLE
	volatile = TRUE

/datum/chem_property/positive/explosive/reset_reagent()
	holder.explosive = initial(holder.explosive)
	holder.power = initial(holder.power)
	holder.falloff_modifier = initial(holder.falloff_modifier)
	..()

/datum/chem_property/positive/explosive/update_reagent()
	holder.explosive = TRUE
	holder.power += level
	holder.falloff_modifier += -3 / level
	..()

//properties for CAS matrixes
/datum/chem_property/positive/photosensitive
	name = PROPERTY_PHOTOSENSITIVE
	code = "PTS"
	description = "Reacts with any amount of light. Can be useful to create light-sensitive objects. Not safe to administer."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_TOXICANT
	max_level = 1

/datum/chem_property/positive/photosensitive/process(mob/living/M, potency = 1)
	to_chat(M, SPAN_WARNING("Your feel a horrible migraine!"))
	M.apply_internal_damage(potency, "brain")

/datum/chem_property/positive/crystallization
	name = PROPERTY_CRYSTALLIZATION
	code = "CRL"
	description = "The chemical structure of the chemical forms itself in a lens. passing light wider, while also keeping focus. Not safe to administer"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_TOXICANT
	max_level = 1

/datum/chem_property/positive/crystallization/process(mob/living/M, potency = 1)
	to_chat(M, SPAN_WARNING("You feel like many razor sharp blades cut through your insides!"))
	M.take_limb_damage(brute = 0.5 * potency)
	M.apply_internal_damage(potency, "liver")

//properties with combat uses
/datum/chem_property/positive/disrupting
	name = PROPERTY_DISRUPTING
	code = "DSR"
	description = "Disrupts certain neurological processes related to communication in animals."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_TOXICANT
	cost_penalty = FALSE

/datum/chem_property/positive/disrupting/process(mob/living/M, potency = 1)
	to_chat(M, SPAN_NOTICE("Your mind feels oddly... quiet."))

/datum/chem_property/positive/disrupting/process_overdose(mob/living/M, potency = 1)
	M.apply_internal_damage(potency, "brain")

/datum/chem_property/positive/disrupting/process_critical(mob/living/M, potency = 1)
	M.apply_effect(potency, PARALYZE)

/datum/chem_property/positive/disrupting/reaction_mob(mob/M, method=TOUCH, volume, potency)
	if(!isxeno(M))
		return
	var/mob/living/carbon/xenomorph/xeno = M
	xeno.AddComponent(/datum/component/status_effect/interference, volume * potency, 90)

/datum/chem_property/positive/neutralizing
	name = PROPERTY_NEUTRALIZING
	code = "NEU"
	description = "Neutralizes certain reactive chemicals and plasmas on contact. Unsafe to administer intravenously."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT
	cost_penalty = FALSE

/datum/chem_property/positive/neutralizing/process(mob/living/M, potency = 1)
	M.apply_damages(0, potency, potency * POTENCY_MULTIPLIER_LOW)

/datum/chem_property/positive/neutralizing/process_overdose(mob/living/M, potency = 1)
	M.apply_damages(0, POTENCY_MULTIPLIER_MEDIUM * potency, potency)

/datum/chem_property/positive/neutralizing/process_critical(mob/living/M, potency = 1)
	M.apply_internal_damage(potency, "liver")

/datum/chem_property/positive/neutralizing/reaction_mob(mob/M, method=TOUCH, volume, potency)
	if(!isliving(M))
		return
	var/mob/living/L = M
	L.ExtinguishMob() //Extinguishes mobs on contact
	if(isxeno(L))
		var/mob/living/carbon/xenomorph/xeno = M
		xeno.plasma_stored = max(xeno.plasma_stored - POTENCY_MULTIPLIER_HIGH * volume * potency, 0)
		to_chat(xeno, SPAN_WARNING("You feel your plasma reserves being drained!"))

/datum/chem_property/positive/neutralizing/reaction_turf(turf/T, volume, potency)
	if(!istype(T))
		return
	for(var/obj/flamer_fire/F in T) //Extinguishes fires and acid
		qdel(F)
	for(var/obj/effect/xenomorph/acid/A in T)
		qdel(A)

//PROPERTY_DISABLED (in random generation)
/datum/chem_property/positive/cardiostabilizing
	name = PROPERTY_CARDIOSTABILIZING
	code = "CSL"
	description = "Stabilizes the cardiac cycle when under shock."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_STIMULANT
	value = 1

/datum/chem_property/positive/cardiostabilizing/on_delete(mob/living/M)
	..()

	M.pain.reset_pain_reduction()

/datum/chem_property/positive/cardiostabilizing/process(mob/living/M, potency = 1, delta_time)
	if(!..())
		return

	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER_SMALL * potency)

	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath - 2.5 * potency * delta_time)

/datum/chem_property/positive/cardiostabilizing/process_overdose(mob/living/M, potency = 1, delta_time)
	M.make_jittery(5) //Overdose causes a spasm
	M.apply_effect(20, PARALYZE)

/datum/chem_property/positive/cardiostabilizing/process_critical(mob/living/M, potency = 1, delta_time)
	M.drowsyness = max(M.drowsyness, 20)
	if(!ishuman(M)) //Critical overdose causes total blackout and heart damage. Too much stimulant
		return
	M.apply_internal_damage(0.25 * delta_time, "heart")
	if(prob(5 * delta_time))
		M.emote(pick("twitch","blink_r","shiver"))

/datum/chem_property/positive/cardiostabilizing/reaction_mob(mob/M, method=TOUCH, volume, potency)
	if(!isxeno(M))
		return
	var/mob/living/carbon/xenomorph/X = M
	if(X.health < 0) //heals out of crit with enough potency/volume, otherwise reduces crit
		X.gain_health(min(potency * volume * 0.5, -X.health + 1))

/datum/chem_property/positive/aiding
	name = PROPERTY_AIDING
	code = "AID"
	description = "Fixes genetic defects, disfigurments and disabilities."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE
	value = 1
	max_level = 1

/datum/chem_property/positive/aiding/process(mob/living/M, potency = 1, delta_time)
	M.disabilities = 0
	M.sdisabilities = 0

/datum/chem_property/positive/aiding/process_overdose(mob/living/M, potency = 1, delta_time)
	M.confused = max(M.confused, 20 * potency) //Confusion and some toxins
	M.apply_damage(0.5 * potency * delta_time, TOX)

/datum/chem_property/positive/aiding/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_effect(20 * potency, PARALYZE) //Total DNA collapse // That's some long goddamn stun
	M.apply_damage(0.5 * potency * delta_time, TOX)
	M.apply_damage(1.5 * potency * delta_time, CLONE)

/datum/chem_property/positive/oxygenating
	name = PROPERTY_OXYGENATING
	code = "OXG"
	description = "Treats oxygen deprivation by improving the ability of erythrocytes to absorb oxygen and increases oxygen intake."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE
	value = 1
	max_level = 6

/datum/chem_property/positive/oxygenating/process(mob/living/M, potency = 1)
	if(potency >= CREATE_MAX_TIER_1)
		holder.holder.remove_reagent("lexorin", 1 * potency)
	if(potency >= POTENCY_MAX_TIER_1)
		M.apply_damage(-M.getOxyLoss(), OXY)
	else
		M.apply_damage(-1 * potency, OXY)


/datum/chem_property/positive/oxygenating/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_LOW * potency, TOX) //Mixed brute/tox damage

/datum/chem_property/positive/oxygenating/process_critical(mob/living/M, potency = 1)
	M.apply_damages(potency, 0, POTENCY_MULTIPLIER_MEDIUM * potency) //Massive brute/tox damage

/datum/chem_property/positive/anticarcinogenic
	name = PROPERTY_ANTICARCINOGENIC
	code = "ACG"
	description = "Fixes genetic damage in cells that have been exposed carcinogens."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE
	value = 1

/datum/chem_property/positive/anticarcinogenic/process(mob/living/M, potency = 1, delta_time)
	M.adjustCloneLoss(-0.5 * potency * delta_time)

/datum/chem_property/positive/anticarcinogenic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/anticarcinogenic/process_critical(mob/living/M, potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_MEDIUM * potency)//Hyperactive apoptosis

/datum/chem_property/positive/regulating
	name = PROPERTY_REGULATING
	code = "REG"
	description = "The chemical regulates its own metabolization, any amount overdosed is turned into sugar."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE
	max_level = 1
	value = 1

/datum/chem_property/positive/regulating/reset_reagent()
	holder.flags = initial(holder.flags)
	..()

/datum/chem_property/positive/regulating/update_reagent()
	holder.flags |= REAGENT_CANNOT_OVERDOSE
	..()

/datum/chem_property/positive/firepenetrating
	name = PROPERTY_FIRE_PENETRATING
	code = "PTR"
	description = "Gives the chemical a unique, anomalous combustion chemistry, causing the flame to react with flame-resistant material and obliterate through it."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_REACTANT
	value = 8
	max_level = 1

/datum/chem_property/positive/firepenetrating/reset_reagent()
	holder.fire_penetrating = initial(holder.fire_penetrating)
	..()

/datum/chem_property/positive/firepenetrating/update_reagent()
	holder.fire_penetrating = TRUE
	..()
