/datum/chem_property/neutral
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_IRRITANT
	value = -1

/datum/chem_property/neutral/cryometabolizing
	name = PROPERTY_CRYOMETABOLIZING
	code = "CMB"
	description = "The chemical is passively metabolized with no other effects in temperatures above 170 kelvin. Below however, the chemical will metabolize with increased effect."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE
	value = 1

/datum/chem_property/neutral/cryometabolizing/pre_process(mob/living/M)
	if(M.bodytemperature > 170)
		return list(REAGENT_CANCEL = TRUE)
	return list(REAGENT_BOOST = 0.5 * level)

/datum/chem_property/neutral/thanatometabolizing
	name = PROPERTY_THANATOMETABOL
	code = "TMB"
	description = "This chemical requires either low oxygen levels or low bloodflow to function. The potency of this property will affect the efficiency of other properties."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_METABOLITE
	value = 1

/datum/chem_property/neutral/thanatometabolizing/pre_process(mob/living/M)
	if(M.stat != DEAD && M.oxyloss < 50 && round(M.blood_volume) > BLOOD_VOLUME_BAD)
		return list(REAGENT_CANCEL = TRUE)
	var/effectiveness = 1
	if(M.stat != DEAD)
		effectiveness = min(max(max(M.oxyloss / 10, M.blood_volume / BLOOD_VOLUME_NORMAL) * 0.1 * level, 0.1), 1)
	return list(REAGENT_FORCE = TRUE, REAGENT_EFFECT = effectiveness)

/datum/chem_property/neutral/excreting
	name = PROPERTY_EXCRETING
	code = "EXT"
	description = "Excretes all chemicals contained in the blood stream by using the kidneys to turn it into urine."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/excreting/pre_process(mob/living/M)
	return list(REAGENT_PURGE = level)

/datum/chem_property/neutral/nutritious
	name = PROPERTY_NUTRITIOUS
	code = "NTR"
	description = "The compound can be used as, or be broken into, nutrition for cell metabolism."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/neutral/nutritious/pre_process(mob/living/M)
	if(M.stat == DEAD)
		return
	M.nutrition += holder.nutriment_factor * level
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.blood_volume < BLOOD_VOLUME_NORMAL)
			C.blood_volume = max(0.2 * level,BLOOD_VOLUME_NORMAL)

/datum/chem_property/neutral/nutritious/update_reagent(var/update = TRUE)
	holder.nutriment_factor = initial(holder.nutriment_factor) + level * update
	..()

/datum/chem_property/neutral/ketogenic
	name = PROPERTY_KETOGENIC
	code = "KTG"
	description = "Activates ketosis causing the liver to rapidly burn fatty acids and alcohols in the body, resulting in weight loss. Can cause ketoacidosis in high concentrations, resulting in a buildup of acids and lowered pH levels in the blood."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/neutral/ketogenic/process(mob/living/M, var/potency = 1)
	M.nutrition = max(M.nutrition - 5*potency, 0)
	M.overeatduration = 0
	if(M.reagents.remove_all_type(/datum/reagent/ethanol, potency, 0, 1)) //Ketosis causes rapid metabolization of alcohols
		M.confused = min(M.confused + potency,10*potency)
		M.drowsyness = min(M.drowsyness + potency,15*potency)

/datum/chem_property/neutral/ketogenic/process_overdose(mob/living/M, var/potency = 1)
	M.nutrition = max(M.nutrition - 10*potency, 0)
	M.apply_damage(potency, TOX)
	if(prob(5*potency) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit()

/datum/chem_property/neutral/ketogenic/process_critical(mob/living/M, var/potency = 1)
	M.knocked_out = max(M.knocked_out, 20)

/datum/chem_property/neutral/neuroinhibiting
	name = PROPERTY_NEUROINHIBITING
	code = "NIH"
	description = "Inhibits neurological processes in the brain such to sight, hearing and speech which can result in various associated disabilities. Restoration will require surgery."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_TOXICANT
	value = -2

/datum/chem_property/neutral/neuroinhibiting/process(mob/living/M, var/potency = 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return
	if(potency > 1)
		M.sdisabilities |= BLIND
	else
		M.disabilities |= NEARSIGHTED
	if(potency > 2)
		M.sdisabilities |= DEAF
	if(potency > 3)
		M.sdisabilities |= MUTE

/datum/chem_property/neutral/neuroinhibiting/process_overdose(mob/living/M, var/potency = 1)
	M.adjustBrainLoss(potency)
	M.disabilities |= NERVOUS

/datum/chem_property/neutral/neuroinhibiting/process_critical(mob/living/M, var/potency = 1)
	M.adjustBrainLoss(2*potency)

/datum/chem_property/neutral/alcoholic
	name = PROPERTY_ALCOHOLIC
	code = "AOL"
	description = "Binds to glutamate neurotransmitters and gamma aminobutyric acid (GABA), slowing brain functions response to stimuli. This effect is also known as intoxication."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/alcoholic/process(mob/living/M, var/potency = 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return
	M.confused = min(M.confused + potency,10*potency)
	M.drowsyness = min(M.drowsyness + potency,15*potency)

/datum/chem_property/neutral/alcoholic/process_overdose(mob/living/M, var/potency = 1)
	M.confused += min(M.confused + potency*2,20*potency)
	M.drowsyness += min(M.drowsyness + potency*2,30*potency)
	M.apply_damage(0.5*potency, TOX)

/datum/chem_property/neutral/alcoholic/process_critical(mob/living/M, var/potency = 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
		if(L)
			L.damage += 0.5*potency

/datum/chem_property/neutral/hallucinogenic
	name = PROPERTY_HALLUCINOGENIC
	code = "HLG"
	description = "Causes perception-like experiences that occur without an external stimulus, which are vivid and clear, with the full force and impact of normal perceptions, though not under voluntary control."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/hallucinogenic/process(mob/living/M, var/potency = 1)
	if(prob(10))
		M.emote(pick("twitch","drool","moan","giggle"))
	if(potency>2)
		M.hallucination = min(M.hallucination + potency, potency * 10)
		M.make_jittery(5)
	M.druggy = min(M.druggy + potency, potency * 10)

/datum/chem_property/neutral/hallucinogenic/process_overdose(mob/living/M, var/potency = 1)
	if(isturf(M.loc) && !istype(M.loc, /turf/open/space) && M.canmove && !M.is_mob_restrained())
		step(M, pick(cardinal))
	M.hallucination += 10
	M.make_jittery(5)

/datum/chem_property/neutral/hallucinogenic/process_critical(mob/living/M, var/potency = 1)
	M.adjustBrainLoss(potency)
	M.knocked_out = max(M.knocked_out, 20)

/datum/chem_property/neutral/relaxing
	name = PROPERTY_RELAXING
	code = "RLX"
	description = "Has a sedative effect on neuromuscular junctions depressing the force of muscle contractions. High concentrations can cause respiratory failure and cardiac arrest."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/relaxing/process(mob/living/M, var/potency = 1)
	M.reagent_move_delay_modifier += potency
	if(prob(10))
		M.emote("yawn")
	M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/relaxing/process_overdose(mob/living/M, var/potency = 1)
	//heart beats slower
	M.reagent_move_delay_modifier += 2*potency
	if(prob(10)) 
		to_chat(M, SPAN_WARNING("You feel incredibly weak!"))

/datum/chem_property/neutral/relaxing/process_critical(mob/living/M, var/potency = 1)
	//heart stops beating, lungs stop working
	if(prob(15*potency))
		M.KnockOut(potency)
	M.apply_damage(potency, OXY)
	if(prob(5))
		to_chat(M, SPAN_WARNING("You can hardly breathe!"))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 0.75*potency

/datum/chem_property/neutral/hyperthermic
	name = PROPERTY_HYPERTHERMIC
	code = "HPR"
	description = "Causes an exothermic reaction when metabolized in the body, increasing internal body temperature. Warning: this can ignite chemicals on reaction."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/neutral/hyperthermic/process(mob/living/M, var/potency = 1)
	if(prob(10))
		M.emote("gasp")
		to_chat(M, SPAN_DANGER("<b>Your insides feel uncomfortably hot !</b>"))
	M.bodytemperature = max(M.bodytemperature+2*potency,0)
	if(potency >= 2)
		M.make_dizzy(potency*2)
		M.apply_effect(potency,AGONY,0)
	M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/hyperthermic/process_overdose(mob/living/M, var/potency = 1)
	M.bodytemperature = max(M.bodytemperature+4*potency,0)
	M.apply_effect(2*potency,AGONY,0)

/datum/chem_property/neutral/hyperthermic/process_critical(mob/living/M, var/potency = 1)
	M.knocked_out = max(M.knocked_out, 20)

/datum/chem_property/neutral/hypothermic
	name = PROPERTY_HYPOTHERMIC
	code = "HPO"
	description = "Causes an endothermic reaction when metabolized in the body, decreasing internal body temperature."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/neutral/hypothermic/process(mob/living/M, var/potency = 1)
	if(prob(10))
		M.emote("shiver")
	M.bodytemperature = max(M.bodytemperature-2*potency,0)
	M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/hypothermic/process_overdose(mob/living/M, var/potency = 1)
	M.bodytemperature = max(M.bodytemperature-4*potency,0)
	M.drowsyness  = max(M.drowsyness, 30)

/datum/chem_property/neutral/hypothermic/process_critical(mob/living/M, var/potency = 1)
	M.knocked_out = max(M.knocked_out, 20)

/datum/chem_property/neutral/balding
	name = PROPERTY_BALDING
	code = "BLD"
	description = "Damages the hair follicles in the skin causing extreme alopecia, also refered to as baldness."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/balding/process(mob/living/M, var/potency = 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((H.h_style != "Bald" || H.f_style != "Shaved"))
			to_chat(M, SPAN_WARNING("Your hair falls out!"))
			H.h_style = "Bald"
			H.f_style = "Shaved"
			H.update_hair()

/datum/chem_property/neutral/balding/process_overdose(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(0.5*potency)

/datum/chem_property/neutral/balding/process_critical(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(potency)

/datum/chem_property/neutral/fluffing
	name = PROPERTY_FLUFFING
	code = "FLF"
	description = "Accelerates cell division in the hair follicles resulting in random and excessive hairgrowth."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/fluffing/process(mob/living/M, var/potency = 1)
	if(prob(5*potency) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.h_style = "Bald"
		H.f_style = "Shaved"
		H.h_style = pick(hair_styles_list)
		H.f_style = pick(facial_hair_styles_list)
		H.update_hair()
		to_chat(M, SPAN_NOTICE("Your head feels different..."))

/datum/chem_property/neutral/fluffing/process_overdose(mob/living/M, var/potency = 1)
	if(prob(5*potency))
		to_chat(M, SPAN_WARNING("You feel itchy all over!"))
		M.take_limb_damage(potency) //Hair growing inside your body

/datum/chem_property/neutral/fluffing/process_critical(mob/living/M, var/potency = 1)
	to_chat(M, SPAN_WARNING("You feel like something is penetrating your skull!"))
	M.adjustBrainLoss(potency)//Hair growing into brain

/datum/chem_property/neutral/allergenic
	name = PROPERTY_ALLERGENIC
	code = "ALG"
	description = "Creates a hyperactive immune response in the body, resulting in irritation."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/allergenic/process(mob/living/M, var/potency = 1)
	if(prob(5*potency))
		M.emote(pick("sneeze","blink","cough"))

/datum/chem_property/neutral/euphoric
	name = PROPERTY_EUPHORIC
	code = "EPH"
	description = "Causes the release of endorphin hormones resulting intense excitement and happiness."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/euphoric/on_delete(mob/living/M)
	..()
	
	M.pain.reset_pain_reduction()

/datum/chem_property/neutral/euphoric/process(mob/living/M, var/potency = 1)
	if(!..())
		return

	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * potency) //Endorphins are natural painkillers
	if(prob(5*potency))
		M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))

/datum/chem_property/neutral/euphoric/process_overdose(mob/living/M, var/potency = 1)
	if(prob(5*potency))
		M.emote("collapse") //ROFL

/datum/chem_property/neutral/euphoric/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(3*potency, OXY)
	to_chat(M, SPAN_WARNING("You are laughing so much you can't breathe!"))

/datum/chem_property/neutral/emetic
	name = PROPERTY_EMETIC
	code = "EME"
	description = "Acts on the enteric nervous system to induce emesis, the forceful emptying of the stomach."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/emetic/process(mob/living/M, var/potency = 1)
	if(prob(holder.volume*potency) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit() //vomit() already has a timer on in

/datum/chem_property/neutral/emetic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(0.5*potency, TOX)

/datum/chem_property/neutral/emetic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(0.5*potency, TOX)

/datum/chem_property/neutral/psychostimulating
	name = PROPERTY_PSYCHOSTIMULATING
	code = "PST"
	description = "Stimulates psychological functions causing increased awareness, focus and anti-depressing effects."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/psychostimulating/process(mob/living/M, var/potency = 1)
	if(holder.volume <= 0.1 && holder.data != -1)
		holder.data = -1
		if(potency == 1)
			to_chat(M, SPAN_WARNING("Your mind feels a little less stable..."))
		else if(potency == 2)
			to_chat(M, SPAN_WARNING("You lose focus..."))
		else if(potency == 3)
			to_chat(M, SPAN_WARNING("Your mind feels much less stable..."))
		else 
			to_chat(M, SPAN_WARNING("You lose your perfect focus..."))
	else
		if(world.time > holder.data + ANTIDEPRESSANT_MESSAGE_DELAY)
			holder.data = world.time
			if(potency == 1)
				to_chat(M, SPAN_NOTICE("Your mind feels stable.. a little stable."))
				M.confused = max(M.confused-1,0)
			else if(potency == 2)
				to_chat(M, SPAN_NOTICE("Your mind feels focused and undivided."))
				M.confused = max(M.confused-2,0)
			else if(potency == 3)
				to_chat(M, SPAN_NOTICE("Your mind feels much more stable."))
				M.confused = max(M.confused-3,0)
			else
				to_chat(M, SPAN_NOTICE("Your mind feels perfectly focused."))
				M.confused = 0

/datum/chem_property/neutral/psychostimulating/process_overdose(mob/living/M, var/potency = 1)
	M.adjustBrainLoss(potency)

/datum/chem_property/neutral/psychostimulating/process_critical(mob/living/M, var/potency = 1)
	M.hallucination = min(200, M.hallucination)
	M.adjustBrainLoss(4*potency)

/datum/chem_property/neutral/antihallucinogenic
	name = PROPERTY_ANTIHALLUCINOGENIC
	code = "AHL"
	description = "Stabilizes perseptive abnormalities such as hallucinations caused by mindbreaker toxin."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/antihallucinogenic/process(mob/living/M, var/potency = 1)
	M.reagents.remove_reagent("mindbreaker", 5)
	M.reagents.remove_reagent("space_drugs", 5)
	M.hallucination = max(0, M.hallucination - 10*potency)
	M.druggy = max(0, M.druggy - 10*potency)

/datum/chem_property/neutral/antihallucinogenic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/neutral/antihallucinogenic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(potency, potency, 3*potency)

/datum/chem_property/neutral/hypometabolic
	name = PROPERTY_HYPOMETABOLIC
	code = "OMB"
	description = "Takes longer for this chemical to metabolize, resulting in it being in the bloodstream for more time per unit."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_METABOLITE
	value = 2

/datum/chem_property/neutral/hypometabolic/update_reagent(var/update = TRUE)
	holder.custom_metabolism = max(initial(holder.custom_metabolism) - 0.025 * level * update, 0.005)
	..()

/datum/chem_property/neutral/sedative
	name = PROPERTY_SEDATIVE
	code = "SDT"
	description = "Causes the body to release melatonin resulting in increased sleepiness."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/sedative/process(mob/living/M, var/potency = 1)
	M.paralyzed += potency
	M.KnockDown(2*potency)	// move this to paralyzed, adjust the number
	M.paralyzed += 2*potency
	M.confused += 2*potency
	if(M.paralyzed > potency * 4)
		M.AdjustSleeping(potency)
	else if(prob(10))
		M.emote("yawn")

/datum/chem_property/neutral/sedative/process_overdose(mob/living/M, var/potency = 1)
	M.AdjustKnockedout(potency)

/datum/chem_property/neutral/sedative/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(5*potency, OXY)

/datum/chem_property/neutral/hyperthrottling
	name = PROPERTY_HYPERTHROTTLING
	code = "HTR"
	description = "Causes the brain to operate at several thousand times the normal speed. For some reason, this allows one to understand all languages spoken before them, even without knowing the language."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/hyperthrottling/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	M.reagent_move_delay_modifier += 4*potency
	M.recalculate_move_delay = TRUE
	M.druggy = min(M.druggy + potency, 10)
	if(H.chem_effect_flags & CHEM_EFFECT_HYPER_THROTTLE)
		return
	H.chem_effect_flags |= CHEM_EFFECT_HYPER_THROTTLE
	to_chat(M, SPAN_NOTICE("You feel like you're in a dream. It is as if the world is standing still."))
	M.universal_understand = TRUE //Brain is working so fast it can understand the intension of everything it hears

/datum/chem_property/neutral/hyperthrottling/process_overdose(mob/living/M, var/potency = 1)
	M.adjustBrainLoss(3*potency)

/datum/chem_property/neutral/hyperthrottling/process_critical(mob/living/M, var/potency = 1)
	M.KnockOut(potency*2)

/datum/chem_property/neutral/viscous
	name = PROPERTY_VISCOUS
	code = "VIS"
	description = "The chemical is thick and gooey due to high surface tension. It will not spread very far when spilled. This would decrease the radius of a chemical fire."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/neutral/viscous/update_reagent(var/update = TRUE)
	holder.chemfiresupp = TRUE
	holder.radiusmod = initial(holder.radiusmod) + 0.05 * level * update
	holder.durationmod = initial(holder.durationmod) + 0.1 * level * update
	holder.intensitymod = initial(holder.intensitymod) + 0.1 * level * update
	..()

//PROPERTY_DISABLED (in generation)
/datum/chem_property/neutral/thermostabilizing
	name = PROPERTY_THERMOSTABILIZING
	code = "TSL"
	description = "Causes a mix of endothermic and exothermic reactions in the bloodstream in order to stabilize internal body temperature."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/neutral/thermostabilizing/process(mob/living/M, var/potency = 1)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * potency * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * potency * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/thermostabilizing/process_overdose(mob/living/M, var/potency = 1)
	M.knocked_out = max(M.knocked_out, 20)

/datum/chem_property/neutral/thermostabilizing/process_critical(mob/living/M, var/potency = 1)
	M.drowsyness  = max(M.drowsyness, 30)

/datum/chem_property/neutral/focusing
	name = PROPERTY_FOCUSING
	code = "FCS"
	description = "Removes common alcoholic substances from the bloodstream and increases focus."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/focusing/process(mob/living/M, var/potency = 1)
	M.reagents.remove_all_type(/datum/reagent/ethanol, potency, 0, 1)
	M.stuttering = max(M.stuttering-2*potency, 0)
	M.confused = max(M.confused-2*potency, 0)
	M.eye_blurry = max(M.eye_blurry-2*potency, 0)
	M.drowsyness = max(M.drowsyness-2*potency, 0)
	M.dizziness = max(M.dizziness-2*potency, 0)
	M.jitteriness = max(M.jitteriness-2*potency, 0)
	if(potency >= 3)
		M.eye_blind = 0
		M.silent = 0

/datum/chem_property/neutral/focusing/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(1, TOX)

/datum/chem_property/neutral/focusing/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(4, TOX)

/datum/chem_property/neutral/unknown
	name = PROPERTY_UNKNOWN
	code = "UNK"
	description = "The chemical has a unique property which can not be defined by the Synthesis Simulator. This property might no longer work if the chemical is modified."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS|PROPERTY_TYPE_UNADJUSTABLE

/datum/chem_property/neutral/unknown/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(potency, BRUTE)

/datum/chem_property/neutral/unknown/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(3*potency, 3*potency, 3*potency)
