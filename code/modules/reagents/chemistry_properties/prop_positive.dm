/datum/chem_property/positive
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE
	value = 2

/datum/chem_property/positive/antitoxic
	name = PROPERTY_ANTITOXIC
	code = "ATX"
	description = "Absorbs and neutralizes toxic chemicals in the bloodstream and allowing them to be excreted safely."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/antitoxic/process(mob/living/M, var/potency = 1)
	M.apply_damage(-(potency), TOX)
	M.reagents.remove_all_type(/datum/reagent/toxin, REM, 0, 1)

/datum/chem_property/positive/antitoxic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_internal_damage(potency, "eyes")

/datum/chem_property/positive/antitoxic/process_critical(mob/living/M, var/potency = 1)
	M.drowsyness  = max(M.drowsyness, 30)

/datum/chem_property/positive/anticorrosive
	name = PROPERTY_ANTICORROSIVE
	code = "ACR"
	description = "Accelerates cell division around corroded areas in order to replace the lost tissue. Excessive use can trigger apoptosis."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/anticorrosive/process(mob/living/M, var/potency = 1)
	M.heal_limb_damage(0, potency)

/datum/chem_property/positive/anticorrosive/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damages(potency, 0, potency) //Mixed brute/tox damage

/datum/chem_property/positive/anticorrosive/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(4*potency, 0, 4*potency) //Massive brute/tox damage

/datum/chem_property/positive/neogenetic
	name = PROPERTY_NEOGENETIC
	code = "NGN"
	description = "Regenerates ruptured membranes resulting in the repair of damaged organic tissue. High concentrations can corrode the cell membranes."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/neogenetic/process(mob/living/M, var/potency = 1)
	M.heal_limb_damage(potency, 0)

/datum/chem_property/positive/neogenetic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(potency, BURN)

/datum/chem_property/positive/neogenetic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(0, 4*potency, 2*potency)

/datum/chem_property/positive/repairing
	name = PROPERTY_REPAIRING
	code = "REP"
	description = "Repairs cybernetic organs by <B>REDACTED</B>."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_MEDICINE
	value = 2

/datum/chem_property/positive/repairing/process(mob/living/M, var/potency = 1)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/human/C = M
	var/obj/limb/L = pick(C.limbs)
	if(L && L.status & LIMB_ROBOT)
		L.heal_damage(2*potency,2*potency,0,1)

/datum/chem_property/positive/repairing/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, TOX)

/datum/chem_property/positive/repairing/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(4*potency, TOX)

/datum/chem_property/positive/hemogenic
	name = PROPERTY_HEMOGENIC
	code = "HMG"
	description = "Increases the production of erythrocytes (red blood cells) in the bonemarrow, leading to polycythemia, an elevated volume of erythrocytes in the blood."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/hemogenic/process(mob/living/M, var/potency = 1)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	C.blood_volume = min(C.blood_volume+potency,BLOOD_VOLUME_MAXIMUM+100)
	if(potency > 3 && C.blood_volume > BLOOD_VOLUME_MAXIMUM) //Too many red blood cells thickens the blood and leads to clotting
		M.take_limb_damage(potency)
		M.apply_damage(2*potency, OXY)
		M.reagent_move_delay_modifier += potency
		M.recalculate_move_delay = TRUE

/datum/chem_property/positive/hemogenic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, TOX)

/datum/chem_property/positive/hemogenic/process_critical(mob/living/M, var/potency = 1)
	M.nutrition = max(M.nutrition - 5*potency, 0)

/datum/chem_property/positive/nervestimulating
	name = PROPERTY_NERVESTIMULATING
	code = "NST"
	description = "Increases neuron communication speed across synapses resulting in improved reaction time, awareness and muscular control."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/nervestimulating/process(mob/living/M, var/potency = 1)
	M.AdjustKnockedout(potency*-1)
	M.AdjustStunned(potency*-1)
	M.AdjustKnockeddown(potency*-1)
	M.AdjustStunned(-0.5*potency)
	if(potency > 2)
		M.stuttering = max(M.stuttering-2*potency, 0)
		M.confused = max(M.confused-2*potency, 0)
		M.eye_blurry = max(M.eye_blurry-2*potency, 0)
		M.drowsyness = max(M.drowsyness-2*potency, 0)
		M.dizziness = max(M.dizziness-2*potency, 0)
		M.jitteriness = max(M.jitteriness-2*potency, 0)

/datum/chem_property/positive/nervestimulating/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, TOX)

/datum/chem_property/positive/nervestimulating/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(potency, potency, 3*potency)

/datum/chem_property/positive/musclestimulating
	name = PROPERTY_MUSCLESTIMULATING
	code = "MST"
	description = "Stimulates neuromuscular junctions increasing the force of muscle contractions, resulting in increased strength. High doses might exhaust the cardiac muscles."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/musclestimulating/process(mob/living/M, var/potency = 1)
	M.reagent_move_delay_modifier -= 0.25 * potency
	M.recalculate_move_delay = TRUE
	if(prob(10))
		M.emote(pick("twitch","blink_r","shiver"))

/datum/chem_property/positive/musclestimulating/process_overdose(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(potency, "heart")

/datum/chem_property/positive/musclestimulating/process_critical(mob/living/M, var/potency = 1)
	M.take_limb_damage(potency)

/datum/chem_property/positive/painkilling
	name = PROPERTY_PAINKILLING
	code = "PNK"
	description = "Binds to opioid receptors in the brain and spinal cord reducing the amount of pain signals being sent to the brain."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/painkilling/on_delete(mob/living/M)
	..()

	M.pain.reset_pain_reduction()

/datum/chem_property/positive/painkilling/process(mob/living/M, var/potency = 1)
	if(!..())
		return

	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * potency)

/datum/chem_property/positive/painkilling/process_overdose(mob/living/M, var/potency = 1)
	if(!..())
		return

	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * potency)
	M.hallucination = max(M.hallucination, potency) //Hallucinations and tox damage
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/painkilling/process_critical(mob/living/M, var/potency = 1)
	M.apply_internal_damage(3 * potency, "liver")
	M.apply_damage(potency, BRAIN)
	M.apply_damage(3, OXY)

/datum/chem_property/positive/hepatopeutic
	name = PROPERTY_HEPATOPEUTIC
	code = "HPP"
	description = "Treats deteriorated hepatocytes and damaged tissues in the liver, restoring organ functions."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/hepatopeutic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-(0.5 * potency), "liver")

/datum/chem_property/positive/hepatopeutic/process_overdose(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(2 * potency, "liver")

/datum/chem_property/positive/hepatopeutic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(5*potency, TOX)

/datum/chem_property/positive/nephropeutic
	name = PROPERTY_NEPHROPEUTIC
	code = "NPP"
	description = "Heals damaged and deteriorated podocytes in the kidney, restoring organ functions."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/nephropeutic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-(0.5 * potency), "kidneys")

/datum/chem_property/positive/nephropeutic/process_overdose(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(2 * potency, "kidneys")

/datum/chem_property/positive/nephropeutic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(5*potency, TOX)

/datum/chem_property/positive/pneumopeutic
	name = PROPERTY_PNEUMOPEUTIC
	code = "PNP"
	description = "Mends the interstitium tissue of the alveoli restoring respiratory functions in the lungs."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/pneumopeutic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-(0.5 * potency), "lungs")

/datum/chem_property/positive/pneumopeutic/process_overdose(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(2 * potency, "lungs")

/datum/chem_property/positive/pneumopeutic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(5*potency, OXY)

/datum/chem_property/positive/oculopeutic
	name = PROPERTY_OCULOPEUTIC
	code = "OCP"
	description = "Restores sensory capabilities of photoreceptive cells in the eyes returning lost vision."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/oculopeutic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(-potency, "eyes")
	M.eye_blurry = max(M.eye_blurry-5*potency , 0)
	M.eye_blind = max(M.eye_blind-5*potency , 0)

/datum/chem_property/positive/oculopeutic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(potency * 2, TOX)

/datum/chem_property/positive/oculopeutic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(potency, potency, 3 * potency)
	M.apply_damage(potency, BRAIN)

/datum/chem_property/positive/cardiopeutic
	name = PROPERTY_CARDIOPEUTIC
	code = "CDP"
	description = "Regenerates damaged cardiomyocytes and recovers a correct cardiac cycle and heart functionality."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/cardiopeutic/on_delete(mob/living/M)
	..()

	M.pain.recalculate_pain()

/datum/chem_property/positive/cardiopeutic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M) || !(..()))
		return
	M.apply_internal_damage(-(0.5 * potency), "heart")

/datum/chem_property/positive/cardiopeutic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, OXY)

/datum/chem_property/positive/cardiopeutic/process_critical(mob/living/M, var/potency = 1)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_CARDIOPEUTIC_PAIN_CRITICAL)

/datum/chem_property/positive/neuropeutic
	name = PROPERTY_NEUROPEUTIC
	code = "NRP"
	description = "Rebuilds damaged and broken neurons in the central nervous system re-establishing brain functionality."
	rarity = PROPERTY_COMMON

/datum/chem_property/positive/neuropeutic/process(mob/living/M, var/potency = 1)
	M.apply_damage(-3 * potency, BRAIN)

/datum/chem_property/positive/neuropeutic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/neuropeutic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(3 * potency, BRAIN)
	M.AdjustStunned(potency)

/datum/chem_property/positive/bonemending
	name = PROPERTY_BONEMENDING
	code = "BNM"
	description = "Rapidly increases the production of osteoblasts and chondroblasts while also accelerating the process of endochondral ossification. This allows broken bone tissue to be re-wowen and restored quickly if the bone is correctly positioned. Overdosing may result in the bone structure growing abnormally and can have adverse effects on the skeletal structure."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/bonemending/process(mob/living/M, var/potency = 1)
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
				potency -= 2.5 // It'll work, but we're effectively 5 level lower.
			if(potency > 0)
				var/total_knitting_time = world.time + L.time_to_knit - min(150*potency, L.time_to_knit - 50)
				L.knitting_time = total_knitting_time
				L.start_processing()
				to_chat(M, SPAN_NOTICE("You feel the bones in your [L.display_name] starting to knit together."))

/datum/chem_property/positive/bonemending/process_overdose(mob/living/M, var/potency = 1)
	M.take_limb_damage(2*potency)

/datum/chem_property/positive/bonemending/process_critical(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L)
		L.fracture()

/datum/chem_property/positive/fluxing
	name = PROPERTY_FLUXING
	code = "FLX"
	description = "Liquifies large crystalline and metallic structures under bodytemperature in the body and allows it to migrate to and be excreted through the skin."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/positive/fluxing/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/limb/L = pick(H.limbs)
	if(L && prob(10*potency))
		if(L.status & LIMB_ROBOT)
			L.take_damage(0,2*potency)
			return
		if(L.implants && L.implants.len > 0)
			var/obj/implanted_object = pick(L.implants)
			if(implanted_object)
				L.implants -= implanted_object

/datum/chem_property/positive/fluxing/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damages(2*potency, 0, 2*potency)

/datum/chem_property/positive/fluxing/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(4*potency, 0, 4*potency) //Mixed brute/tox damage

/datum/chem_property/positive/neurocryogenic
	name = PROPERTY_NEUROCRYOGENIC
	code = "NRC"
	description = "Causes a temporal freeze of all neurological processes and cellular respirations in the brain. This allows the brain to be preserved for long periods of time."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/positive/neurocryogenic/process(mob/living/M, var/potency = 1)
	if(prob(20))
		to_chat(M, SPAN_WARNING("You feel like you have the worst brain freeze ever!"))
	M.knocked_out = max(M.knocked_out, 20)
	M.stunned = max(M.stunned,21)

/datum/chem_property/positive/neurocryogenic/process_overdose(mob/living/M, var/potency = 1)
	M.bodytemperature = max(M.bodytemperature-5*potency,0)

/datum/chem_property/positive/neurocryogenic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(5 * potency, BRAIN)

/datum/chem_property/positive/neurocryogenic/process_dead(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	H.revive_grace_period += SECONDS_5 * potency
	return TRUE

/datum/chem_property/positive/antiparasitic
	name = PROPERTY_ANTIPARASITIC
	code = "APS"
	description = "Antimicrobial property specifically targeting parasitic pathogens in the body disrupting their growth and potentially killing them."
	rarity = PROPERTY_UNCOMMON

/datum/chem_property/positive/antiparasitic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/content in H.contents)
		var/obj/item/alien_embryo/A = content
		if(A && istype(A))
			if(A.counter > 0)
				A.counter = A.counter - potency
				H.take_limb_damage(0,0.2*potency)
			else
				A.stage--
				if(A.stage <= 0)//if we reach this point, the embryo dies and the occupant takes a nasty amount of acid damage
					qdel(A)
					H.take_limb_damage(0,rand(20,40))
					H.vomit()
				else
					A.counter = 90

/datum/chem_property/positive/antiparasitic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, TOX)

/datum/chem_property/positive/antiparasitic/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(4*potency, TOX)

/datum/chem_property/positive/electrogenetic
	name = PROPERTY_ELECTROGENETIC
	code = "EGN"
	description = "Stimulates cardiac muscles when exposed to electric shock and provides general healing. Useful in restarting the heart in combination with a defibrilator. Can not be ingested."
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_REACTANT

/datum/chem_property/positive/electrogenetic/trigger(var/A)
	if(isliving(A))
		var/mob/living/M = A
		M.apply_damage(-4*level, BRUTE)
		M.apply_damage(-4*level, BURN)
		M.apply_damage(-4*level, TOX)
		M.updatehealth()

/datum/chem_property/positive/electrogenetic/reset_reagent()
	holder.ingestible = initial(holder.ingestible)
	..()

/datum/chem_property/positive/electrogenetic/update_reagent()
	holder.ingestible = FALSE
	..()

/datum/chem_property/positive/defibrillating
	name = PROPERTY_DEFIBRILLATING
	code = "DFB"
	description = "Causes an electrochemical reaction in the cardiac muscles, forcing the heart to continue pumping. May cause irregular heart rhythms."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_REACTANT
	value = 3

/datum/chem_property/positive/defibrillating/on_delete(mob/living/M)
	..()

	M.pain.recalculate_pain()

/datum/chem_property/positive/defibrillating/process(mob/living/M, var/potency = 1)
	if(prob(10))
		M.emote("twitch")

/datum/chem_property/positive/defibrillating/process_overdose(mob/living/M, var/potency = 1)
	if(!(..()))
		return

	M.pain.apply_pain(PROPERTY_DEFIBRILLATING_PAIN_OD)
	M.apply_damage(2*potency, OXY)

/datum/chem_property/positive/defibrillating/process_critical(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(potency, "heart")

/datum/chem_property/positive/defibrillating/process_dead(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.apply_damage(-H.getOxyLoss(), OXY)
	if(H.check_tod() && H.is_revivable() && H.health > HEALTH_THRESHOLD_DEAD)
		to_chat(H, SPAN_NOTICE("You feel your heart struggling as you suddenly feel a spark, making it desperately try to continue pumping."))
		playsound_client(H.client, 'sound/effects/Heart Beat Short.ogg', 35)
		add_timer(CALLBACK(H, /mob/living/carbon/human.proc/handle_revive), 50, TIMER_UNIQUE)
	return TRUE

/datum/chem_property/positive/hyperdensificating
	name = PROPERTY_HYPERDENSIFICATING
	code = "HDN"
	description = "Causes the muscles and bones to become super dense, providing superior resistance towards the bones fracturing."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT
	value = 3

/datum/chem_property/positive/hyperdensificating/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.chem_effect_flags & CHEM_EFFECT_RESIST_FRACTURE)
		return
	H.chem_effect_flags |= CHEM_EFFECT_RESIST_FRACTURE
	if(prob(10))
		to_chat(M, SPAN_NOTICE("Your body feels incredibly tense."))

/datum/chem_property/positive/hyperdensificating/process_overdose(mob/living/M, var/potency = 1)
	M.reagent_move_delay_modifier += 2*potency
	if(prob(10))
		to_chat(M, SPAN_NOTICE("It is really hard to move your body."))

/datum/chem_property/positive/hyperdensificating/process_critical(mob/living/M, var/potency = 1)
	M.take_limb_damage(3*potency)

/datum/chem_property/positive/neuroshielding
	name = PROPERTY_NEUROSHIELDING
	code = "NRS"
	description = "Protects the brain from neurological damage caused by toxins."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT
	value = 3

/datum/chem_property/positive/neuroshielding/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
		return
	H.chem_effect_flags |= CHEM_EFFECT_RESIST_NEURO
	to_chat(M, SPAN_NOTICE("Your skull feels incredibly thick."))
	M.dazed = 0

/datum/chem_property/positive/neuroshielding/process_overdose(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	M.apply_internal_damage(potency, "liver")

/datum/chem_property/positive/neuroshielding/process_critical(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, BRAIN)

/datum/chem_property/positive/antiaddictive
	name = PROPERTY_ANTIADDICTIVE
	code = "AAD"
	description = "Stops all bodily cravings towards addictive chemical substances."
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/antiaddictive/process(mob/living/M, var/potency = 1)
	for(var/datum/disease/addiction/D in M.viruses)
		if(potency >= 4)
			D.cure()
			return
		D.withdrawal_progression -= 2*potency
		D.addiction_progression -= 2*potency
		if(D.addiction_progression < potency)
			D.cure()

/datum/chem_property/positive/antiaddictive/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, BRAIN)

/datum/chem_property/positive/antiaddictive/process_critical(mob/living/M, var/potency = 1)
	M.hallucination = max(M.hallucination, potency)

/datum/chem_property/positive/fire
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT
	value = 2

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
	
	holder.rangefire = max(holder.rangefire + range_per_level * level, 1)
	holder.durationfire = max(holder.durationfire + duration_per_level * level, 1)
	holder.intensityfire = max(holder.intensityfire + intensity_per_level * level, 1)
	
	..()

/datum/chem_property/positive/fire/fueling
	name = PROPERTY_FUELING
	code = "FUL"
	description = "The chemical can be burned as a fuel, expanding the burn time of a chemical fire. However, this also lowers heat intensity."
	rarity = PROPERTY_COMMON
	intensity_per_level = -3
	duration_per_level = 6

	intensitymod_per_level = -0.1
	durationmod_per_level = 0.2
	radiusmod_per_level = 0.01

/datum/chem_property/positive/fire/oxidizing
	name = PROPERTY_OXIDIZING
	code = "OXI"
	description = "The chemical is oxidizing, increasing the intensity of chemical fires. However, the fuel is also burned faster because of it."
	rarity = PROPERTY_COMMON
	intensity_per_level = 6
	duration_per_level = -3

	intensitymod_per_level = 0.2
	durationmod_per_level = -0.1
	radiusmod_per_level = -0.01

/datum/chem_property/positive/fire/flowing
	name = PROPERTY_FLOWING
	code = "FLW"
	description = "The chemical is the opposite of viscous, and it tends to spill everywhere. This could probably be used to expand the radius of a chemical fire."
	rarity = PROPERTY_COMMON
	range_per_level = 1
	duration_per_level = -2
	intensity_per_level = -2

	intensitymod_per_level = -0.05
	radiusmod_per_level = 0.05
	durationmod_per_level = -0.05

/datum/chem_property/positive/explosive
	name = PROPERTY_EXPLOSIVE
	code = "EXP"
	description = "The chemical is highly explosive. Do not ignite. Careful when handling, sensitivity is based off the OD threshold, which can lead to spontanous detonation."
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_REACTANT

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

//PROPERTY_DISABLED (in random generation)
/datum/chem_property/positive/cardiostabilizing
	name = PROPERTY_CARDIOSTABILIZING
	code = "CSL"
	description = "Stabilizes the cardiac cycle when under shock."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/positive/cardiostabilizing/on_delete(mob/living/M)
	..()

	M.pain.reset_pain_reduction()

/datum/chem_property/positive/cardiostabilizing/process(mob/living/M, var/potency = 1)
	if(!..())
		return

	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * potency)

	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath-5*potency)

/datum/chem_property/positive/cardiostabilizing/process_overdose(mob/living/M, var/potency = 1)
	M.make_jittery(5) //Overdose causes a spasm
	M.knocked_out = max(M.knocked_out, 20)

/datum/chem_property/positive/cardiostabilizing/process_critical(mob/living/M, var/potency = 1)
	M.drowsyness = max(M.drowsyness, 20)
	if(!ishuman(M)) //Critical overdose causes total blackout and heart damage. Too much stimulant
		return
	M.apply_internal_damage(0.5, "heart")
	if(prob(10))
		M.emote(pick("twitch","blink_r","shiver"))

/datum/chem_property/positive/aiding
	name = PROPERTY_AIDING
	code = "AID"
	description = "Fixes genetic defects, disfigurments and disabilities."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/positive/aiding/process(mob/living/M, var/potency = 1)
	M.disabilities = 0
	M.sdisabilities = 0
	M.status_flags &= ~DISFIGURED
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.name = H.get_visible_name()

/datum/chem_property/positive/aiding/process_overdose(mob/living/M, var/potency = 1)
	M.confused = max(M.confused, 20 * potency) //Confusion and some toxins
	M.apply_damage(potency, TOX)

/datum/chem_property/positive/aiding/process_critical(mob/living/M, var/potency = 1)
	M.knocked_out = max(M.knocked_out, 20 * potency) //Total DNA collapse
	M.apply_damage(potency, TOX)
	M.apply_damage(3 * potency, CLONE)

/datum/chem_property/positive/oxygenating
	name = PROPERTY_OXYGENATING
	code = "OXG"
	description = "Treats oxygen deprivation by improving the ability of erythrocytes to absorb oxygen and increases oxygen intake."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/positive/oxygenating/process(mob/living/M, var/potency = 1)
	if(potency >= 2)
		holder.holder.remove_reagent("lexorin", 1 * potency)
	if(potency >= 3)
		M.apply_damage(-M.getOxyLoss(), OXY)
	else
		M.apply_damage(-1 * potency, OXY)


/datum/chem_property/positive/oxygenating/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(0.5 * potency, TOX) //Mixed brute/tox damage

/datum/chem_property/positive/oxygenating/process_critical(mob/living/M, var/potency = 1)
	M.apply_damages(potency, 0, 2 * potency) //Massive brute/tox damage

/datum/chem_property/positive/anticarcinogenic
	name = PROPERTY_ANTICARCINOGENIC
	code = "ACG"
	description = "Fixes genetic damage in cells that have been exposed carcinogens."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/positive/anticarcinogenic/process(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(-potency)

/datum/chem_property/positive/anticarcinogenic/process_overdose(mob/living/M, var/potency = 1)
	M.apply_damage(2*potency, TOX)

/datum/chem_property/positive/anticarcinogenic/process_critical(mob/living/M, var/potency = 1)
	M.take_limb_damage(2*potency)//Hyperactive apoptosis