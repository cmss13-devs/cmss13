
// All reagents related to medicine



/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients. If the lungs are functional, inaprovaline will allow respiration while under cardiac arrest. Slows down bleeding and acts as a weak painkiller. Overdosing may cause severe damage to cardiac tissue."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 2)

/datum/reagent/inaprovaline/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return

	M.reagent_shock_modifier += PAIN_REDUCTION_LIGHT

	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath-5)

	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)

/datum/reagent/inaprovaline/on_overdose(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.make_jittery(5) //Overdose causes a spasm
	M.knocked_out = max(M.knocked_out, 20)

/datum/reagent/inaprovaline/on_overdose_critical(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.drowsyness = max(M.drowsyness, 20)
	if(ishuman(M)) //Critical overdose causes total blackout and heart damage. Too much stimulant
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		E.damage += 0.5
		if(prob(10))
			M.emote(pick("twitch","blink_r","shiver"))

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn repairs genetic defects, mutations and abnormalities through a catalytic process. Used to treat genetic eye and vision problems. Overdosing on ryetalyn is very toxic and can impair sense of balance."
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/ryetalyn/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.disabilities = 0
	M.sdisabilities = 0

/datum/reagent/ryetalyn/on_overdose(mob/living/M)
	M.confused = max(M.confused, 20) //Confusion and some toxins
	M.apply_damage(1, TOX)

/datum/reagent/ryetalyn/on_overdose_critical(mob/living/M)
	M.knocked_out = max(M.knocked_out, 20) //Total DNA collapse
	M.apply_damage(1, TOX)
	M.apply_damage(3, CLONE)

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Also known as Tylenol, this is a moderate long lasting painkiller that has been commonly available since 1950. Paracetamol is capable of both analgesic and antipyretic activity but no anti-inflammatory action. Overdosing on paracetamol is toxic, may induce hallucinations, and cause acute liver failure."
	reagent_state = LIQUID
	color = "#C855DC"
	scannable = 1
	custom_metabolism = 0.025 // Lasts 10 minutes for 15 units
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 4)

/datum/reagent/paracetamol/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_pain_modifier += PAIN_REDUCTION_HEAVY

/datum/reagent/paracetamol/on_overdose(mob/living/M)
	M.hallucination = max(M.hallucination, 2) //Hallucinations and tox damage
	M.apply_damage(1, TOX)

/datum/reagent/paracetamol/on_overdose_critical(mob/living/M)
	M.apply_damage(4, TOX) //Massive liver damage


/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "Tramadol is a centrally acting analgesic and is considered to be a relatively safe. The analgesic potency is claimed to be about one tenth that of morphine. It is used to treat both acute and chronic pain of moderate to (moderately) severe intensity. Tramadol is generally considered as a medicinal drug with a low potential for dependence relative to morphine. Overdosing on tramadol is highly toxic."
	reagent_state = LIQUID
	color = "#C8A5DC"
	scannable = 1
	custom_metabolism = 0.1 // Lasts 10 minutes for 15 units
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 6)

/datum/reagent/tramadol/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_pain_modifier += PAIN_REDUCTION_VERY_HEAVY


/datum/reagent/tramadol/on_overdose(mob/living/M)
	M.apply_damage(1, OXY)
	M.apply_damage(1, TOX)

/datum/reagent/tramadol/on_overdose_critical(mob/living/M)
	M.apply_damage(3, OXY)
	M.apply_damage(2, TOX)
	M.adjustBrainLoss(1)


/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "Oxycodone is an opioid agonist with addiction potential similar to that of morphine. It is approved for the treatment of patients with moderate to severe pain who are expected to need continuous opioids for an extended period of time. Overdosing on oxycodone can cause hallucinations, brain damage and be highly toxic."
	reagent_state = LIQUID
	color = "#C805DC"
	scannable = 1
	custom_metabolism = 0.2 // Lasts 5 minutes for 15 units
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 8)

/datum/reagent/oxycodone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_pain_modifier += PAIN_REDUCTION_FULL

/datum/reagent/oxycodone/on_overdose(mob/living/M)
	M.apply_damage(1, OXY)
	M.apply_damage(1, TOX)

/datum/reagent/oxycodone/on_overdose_critical(mob/living/M)
	M.apply_damage(3, OXY)
	M.apply_damage(2, TOX)
	M.adjustBrainLoss(1)

/datum/reagent/oxycodone/on_overdose(mob/living/M)
	M.apply_damage(1, OXY)
	M.apply_damage(1, TOX)

/datum/reagent/oxycodone/on_overdose_critical(mob/living/M)
	M.apply_damage(3, OXY)
	M.apply_damage(2, TOX)
	M.adjustBrainLoss(1)

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "A sterilizer used to clean wounds in preparation for surgery. Its use has mostly been outclassed to the cheaper alternative of space cleaner."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "A drug used to treat hypothermia and hyperthermia. Stabilizes patient body temperture. Prevents the use of cryogenics. Overdosing on leporazine can cause extreme drowsyness."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/leporazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE

/datum/reagent/leporazine/on_overdose(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.knocked_out = max(M.knocked_out, 20)

/datum/reagent/leporazine/on_overdose_critical(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.drowsyness  = max(M.drowsyness, 30)

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Common medicine used to treat burns, caustic and corrosive trauma. Overdosing on kelotane can cause internal tissue damage."
	reagent_state = LIQUID
	color = "#D8C58C"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTICORROSIVE = 2)

/datum/reagent/kelotane/on_mob_life(var/mob/living/M)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	M.heal_limb_damage(0, 2 * REM)

/datum/reagent/kelotane/on_overdose(mob/living/M)
	M.apply_damages(1, 0, 1) //Mixed brute/tox damage

/datum/reagent/kelotane/on_overdose_critical(mob/living/M)
	M.apply_damages(4, 0, 4) //Massive brute/tox damage

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Advanced medicine used to treat severe burn trauma. Enables the body to restore even the direst heat-damaged tissue. Overdosing on dermaline can cause severe internal tissue damage."
	reagent_state = LIQUID
	color = "#F8C57C"
	overdose = LOWH_REAGENTS_OVERDOSE 
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTICORROSIVE = 4)

/datum/reagent/dermaline/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
		return
	if(!alien)
		M.heal_limb_damage(0, 3 * REM)

/datum/reagent/dermaline/on_overdose(mob/living/M)
	M.apply_damages(1, 0, 1) //Mixed brute/tox damage

/datum/reagent/dermaline/on_overdose_critical(mob/living/M)
	M.apply_damages(4, 0, 4) //Massive brute/tox damage

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation by feeding oxygen to red blood cells directly inside the bloodstream. Used as an antidote to lexorin poisoning."
	reagent_state = LIQUID
	color = "#C865FC"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/dexalin/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return  //See above, down and around. --Agouri

	if(!alien)
		M.adjustOxyLoss(-2*REM)

	holder.remove_reagent("lexorin", 2 * REM)

/datum/reagent/dexalin/on_overdose(mob/living/M)
	M.apply_damage(1, TOX) //Mixed brute/tox damage

/datum/reagent/dexalin/on_overdose_critical(mob/living/M)
	M.apply_damages(2, 0, 4) //Massive brute/tox damage

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is an upgraded form of Dexalin with added iron and carbon to quicken the rate which oxygen binds to the hemoglobin in red blood cells."
	reagent_state = LIQUID
	color = "#C8A5FC"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/dexalinp/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return

	if(!alien)
		M.adjustOxyLoss(-M.getOxyLoss())

	holder.remove_reagent("lexorin", 2*REM)

/datum/reagent/dexalinp/on_overdose(mob/living/M)
	M.apply_damage(1, TOX) //Mixed brute/tox damage

/datum/reagent/dexalinp/on_overdose_critical(mob/living/M)
	M.apply_damages(2, 0, 4) //Massive brute/tox damage

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#B865CC"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1)

/datum/reagent/tricordrazine/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	if(!alien)
		if(M.getOxyLoss()) M.adjustOxyLoss(-REM)
		if(M.getBruteLoss() && prob(80)) M.heal_limb_damage(REM, 0)
		if(M.getFireLoss() && prob(80)) M.heal_limb_damage(0, REM)
		if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-REM)

/datum/reagent/tricordrazine/on_overdose(mob/living/M)
	M.make_jittery(5)
	M.adjustBrainLoss(1)

/datum/reagent/tricordrazine/on_overdose_critical(mob/living/M)
	M.apply_damages(5, 5, 5) //Massive damage bounceback if abused
	M.adjustBrainLoss(1)

/datum/reagent/anti_toxin
	name = "Dylovene"
	id = "anti_toxin"
	description = "General use anti-toxin, that neutralizes most toxins in the bloodstream. Commonly used in many advanced chemicals. Can be used as a mild anti-hallucinogen and to reduce tiredness."
	reagent_state = LIQUID
	color = "#A8F59C"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTITOXIC = 2)

/datum/reagent/anti_toxin/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.) return
	if(!alien)
		M.reagents.remove_all_type(/datum/reagent/toxin, REM, 0, 1)
		M.drowsyness = max(M.drowsyness- 2 * REM, 0)
		M.hallucination = max(0, M.hallucination -  5 * REM)
		M.adjustToxLoss(-2 * REM)

/datum/reagent/anti_toxin/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			E.damage += 0.41 //blurry after slightly more than 10u of overdose, blindness after ~15 or so

/datum/reagent/anti_toxin/on_overdose_critical(mob/living/M)
	M.apply_damages(3, 3) //Starts detoxing, hard
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			E.damage += 0.82

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "A magical substance created by gods to dissolve extreme amounts of salt."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/adminordrazine/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!.) return
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.heal_limb_damage(5,5)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetKnockeddown(0)
	M.SetStunned(0)
	M.SetKnockedout(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()

/datum/reagent/thwei //OP yautja chem
	name = "Thwei"
	id = "thwei"
	description = "A strange, alien liquid."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_SPECIAL

/datum/reagent/thwei/on_mob_life(mob/living/carbon/M,alien)
	. = ..()
	if(!.) return
	if(!isYautja(M)) return
	var/mob/living/carbon/human/Y = M
	for(var/obj/limb/L in Y.limbs)
		if(L.time_to_knit && (L.status & LIMB_BROKEN))
			if(L.knitting_time > 0) break // only one knits at a time
			if(L.knitting_time == -1)
				var/total_knitting_time = world.time + L.time_to_knit/2
				L.knitting_time = total_knitting_time
				L.start_processing()
				to_chat(Y, SPAN_NOTICE("You feel the bones in your [L.display_name] start to knit together."))
				break

	if(M.getBruteLoss() && prob(80)) M.heal_limb_damage(1*REM,0)
	if(M.getFireLoss() && prob(80)) M.heal_limb_damage(0,1*REM)
	if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-1*REM)
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.jitteriness = 0
	for(var/datum/internal_organ/I in M.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - 1, 0)
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "A controlled nervestimulant that treats hallucinations, drowsiness, improves reaction time and acts as a weak painkiller. Is mildly toxic and overdosing will cause extreme toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.1
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NERVESTIMULATING = 2)

/datum/reagent/synaptizine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_shock_modifier += PAIN_REDUCTION_MEDIUM
	M.drowsyness = max(M.drowsyness-5, 0)
	M.AdjustKnockedout(-1)
	M.AdjustStunned(-1)
	M.AdjustKnockeddown(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(80))	M.adjustToxLoss(1)

/datum/reagent/synaptizine/on_overdose(mob/living/M)
	M.apply_damage(2, TOX)

/datum/reagent/synaptizine/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 1, 3)

/datum/reagent/neuraline //injected by neurostimulator implant
	name = "Neuraline"
	id = "neuraline"
	description = "A chemical cocktail tailored to enhance or dampen specific neural processes."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.4
	overdose = 2
	overdose_critical = 3
	scannable = 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NERVESTIMULATING = 5)

/datum/reagent/neuraline/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_shock_modifier += PAIN_REDUCTION_FULL
	M.drowsyness = max(M.drowsyness-5, 0)
	M.dizziness = max(M.dizziness-5, 0)
	M.stuttering = max(M.stuttering-5, 0)
	M.confused = max(M.confused-5, 0)
	M.eye_blurry = max(M.eye_blurry-5, 0)
	M.AdjustKnockedout(-2)
	M.AdjustStunned(-2)
	M.AdjustKnockeddown(-1)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "A stabilized variant of dylovene. Its toxin-cleansing properties are weakened and there are harmful side effects, but it does not react with other compounds to create toxin."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTITOXIC = 1, PROPERTY_BIOCIDIC = 1)

/datum/reagent/arithrazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	M.adjustToxLoss(-1*REM)
	if(prob(15))
		M.take_limb_damage(1, 0)

/datum/reagent/arithrazine/on_overdose(mob/living/M)
	M.apply_damage(2, TOX)

/datum/reagent/arithrazine/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 1, 3)

/datum/reagent/russianred
	name = "Russian Red"
	id = "russianred"
	description = "An emergency radiation treatment, however it has extreme side effects."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 1
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/russianred/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.adjustToxLoss(-1*REM)
	if(prob(50))
		M.take_limb_damage(3, 0)

/datum/reagent/russianred/on_overdose(mob/living/M)
	M.apply_damages(1, 0, 0)

/datum/reagent/russianred/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 2, 2)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen and heal the damage to neurological tissue after a catastrophic injury. Small amounts can repair extensive brain trauma. Functions as a very weak painkiller. Overdosing on alkysine is extremely toxic."
	reagent_state = LIQUID
	color = "#E89599"
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 1, PROPERTY_NEUROPEUTIC = 2)

/datum/reagent/alkysine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_shock_modifier += PAIN_REDUCTION_VERY_LIGHT
	M.adjustBrainLoss(-3 * REM)

/datum/reagent/alkysine/on_overdose(mob/living/M)
	M.apply_damage(2, TOX)

/datum/reagent/alkysine/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 1, 3)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Used for treating non-genetic eye trauma. Generally prescribed as treatment for most cases of eye trauma instead of performing a surgical operation."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OCULOPEUTIC = 1)

/datum/reagent/imidazoline/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.eye_blurry = max(M.eye_blurry-5 , 0)
	M.eye_blind = max(M.eye_blind-5 , 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 1, 0)

/datum/reagent/imidazoline/on_overdose(mob/living/M)
		M.apply_damage(2, TOX)

/datum/reagent/imidazoline/on_overdose_critical(mob/living/M)
		M.apply_damages(1, 1, 3)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Prevents symptoms caused by damaged internal organs while in the bloodstream, but does not fix the organ damage. Recommended for patients awaiting internal organ surgery. Overdosing on peridaxon will cause internal tissue damage."
	reagent_state = LIQUID
	color = "#C845DC"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = 0.05
	scannable = 1
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/peridaxon/on_overdose(mob/living/M)
	M.apply_damage(2, BRUTE)

/datum/reagent/peridaxon/on_overdose_critical(mob/living/M)
	M.apply_damages(3, 3, 3)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat severe external blunt trauma and to stabilize patients. Overdosing will cause caustic burns, but can mend internal broken bloodvessels."
	reagent_state = LIQUID
	color = "#E8756C"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NEOGENETIC = 2)

/datum/reagent/bicaridine/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	M.heal_limb_damage(2*REM,0)

/datum/reagent/bicaridine/on_overdose(mob/living/M) // yes it cures IB, it's located in some other part of wound code for whatever reason
	M.apply_damage(1, BURN)

/datum/reagent/bicaridine/on_overdose_critical(mob/living/M)
	M.apply_damages(0, 4, 2)

/datum/reagent/quickclot
	name = "Quick Clot"
	id = "quickclot"
	description = "Vastly improves the blood's natural ability to coagulate and stop bleeding by hightening platelet production and effectiveness. Overdosing will cause extreme blood clotting, resulting in severe tissue damage."
	reagent_state = LIQUID
	color = "#CC00FF"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1 //scannable now.  HUZZAH.
	custom_metabolism = 0.05
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/quickclot/on_overdose(mob/living/M)
	M.apply_damage(3, BRUTE)

/datum/reagent/quickclot/on_overdose_critical(mob/living/M)
	M.apply_damages(2, 3, 3)

/datum/reagent/adrenaline
	name = "Epinephrine"
	id = "adrenaline"
	description = "A natural muscle and heart stimulant. Useful for restarting the heart. Overdosing may stress the heart and cause tissue damage."
	reagent_state = LIQUID
	ingestible = FALSE
	color = "FFE703" // Yellow-ish
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL 
	scannable = 1
	custom_metabolism = 0.4
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 3, PROPERTY_MUSCLESTIMULATING = 1)

/datum/reagent/adrenaline/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.reagent_move_delay_modifier -= 0.2
	M.reagent_shock_modifier += PAIN_REDUCTION_MEDIUM // half of tramadol
	M.recalculate_move_delay = TRUE

/datum/reagent/adrenaline/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 0.25

/datum/reagent/adrenaline/on_overdose_critical(mob/living/M, alien)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 1
		
/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "A potent long lasting muscle stimulant. Increases heart rate dramatically, which may damage cardiac tissue. Highly addictive. Controlled substance."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.2
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_MUSCLESTIMULATING = 1, PROPERTY_CARDIOTOXIC = 1)

/datum/reagent/hyperzine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.reagent_move_delay_modifier -= 0.5
	M.recalculate_move_delay = TRUE

	if(prob(1))
		M.emote(pick("twitch","blink_r","shiver"))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/datum/internal_organ/heart/F = H.internal_organs_by_name["heart"]
			F.damage += 1
			M.emote(pick("twitch","blink_r","shiver"))

/datum/reagent/hyperzine/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 0.5
		if(prob(10))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/hyperzine/on_overdose_critical(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 2
		if(prob(25))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/ultrazine
	name = "Ultrazine"
	id = "ultrazine"
	description = "A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.0167 //5 units will last approximately 10 minutes
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE

/datum/reagent/ultrazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.reagent_move_delay_modifier -= 10
	M.recalculate_move_delay = TRUE

	var/has_addiction

	for(var/datum/disease/addiction/D in M.viruses)
		if(D.chemical_id == id)
			D.handle_chem()
			has_addiction = TRUE
			break
	if(!has_addiction)
		M.contract_disease(new /datum/disease/addiction(id), 1)

/datum/reagent/ultrazine/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 0.5
		if(prob(10))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/ultrazine/on_overdose_critical(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 2
		if(prob(25))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "Industrial grade cryogenic medicine. Treats most types of tissue damage. Its main limitation is that the patient's body temperature must be under 170K to metabolise correctly."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 3, PROPERTY_NEOGENETIC = 2, PROPERTY_ANTICORROSIVE = 2, PROPERTY_ANTITOXIC = 2)

/datum/reagent/cryoxadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.adjustOxyLoss(-1)
		M.heal_limb_damage(1,1)
		M.adjustToxLoss(-1)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "Advanced cryogenic medicine made from cryoxadone. Treats most types of tissue damage. Requires temperatures below 170K to to metabolise correctly."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 6, PROPERTY_NEOGENETIC = 6, PROPERTY_ANTICORROSIVE = 6, PROPERTY_ANTITOXIC = 6)

/datum/reagent/clonexadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-3)
		M.adjustOxyLoss(-3)
		M.heal_limb_damage(3,3)
		M.adjustToxLoss(-3)

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/rezadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 15)
			M.adjustCloneLoss(-1)
			M.heal_limb_damage(1,1)
		if(15 to 35)
			M.adjustCloneLoss(-2)
			M.heal_limb_damage(2,1)
			M.status_flags &= ~DISFIGURED
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.name = H.get_visible_name()
		if(35 to INFINITY)
			M.adjustToxLoss(1)
			M.make_dizzy(5)
			M.make_jittery(5)

/datum/reagent/rezadone/on_overdose(mob/living/M)
		M.apply_damage(2, TOX)

/datum/reagent/rezadone/on_overdose_critical(mob/living/M)
		M.apply_damage(3, TOX)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "General use theta-lactam antibiotic. Prevents and cures mundane infections."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/spaceacillin/on_overdose(mob/living/M)
	M.apply_damage(1, TOX)

/datum/reagent/spaceacillin/on_overdose_critical(mob/living/M)
	M.apply_damage(4, TOX)

/datum/reagent/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "Neutralizes the effects of alcohol in the blood stream, by oxidizing it into water molecules. However, it does not stop immediate intoxication. Ethylredoxrazine being a powerful oxidizer, it becomes toxic in high doses."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/ethylredoxrazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/ethanol, REM, 0, 1)

/datum/reagent/ethylredoxrazine/on_overdose(mob/living/M)
	M.apply_damage(1, TOX)

/datum/reagent/ethylredoxrazine/on_overdose_critical(mob/living/M)
	M.apply_damage(4, TOX)

///////ANTIDEPRESSANTS///////

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "A commonly prescribed psychostimulant that increases activity of the central nervous system. Often used to treat attention deficit hyperactivity disorder (ADHD) and narcolepsy. This drug improves performance primarily in the executive function in the prefrontal cortex (reasoning, inhibiting behaviors, organizing, problem solving, planning ect.)"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 1)

/datum/reagent/antidepressant/methylphenidate/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(src.volume <= 0.1) if(data != -1)
		data = -1
		to_chat(M, SPAN_WARNING("You lose focus."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_NOTICE("Your mind feels focused and undivided."))

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Citalopram is a drug used to treat depression, obsessive-compulsive disorder and panic disorder. It is considered safe for consumption and has been commonly available since 1998."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 2)

/datum/reagent/antidepressant/citalopram/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(volume <= 0.1) if(data != -1)
		data = -1
		to_chat(M, SPAN_WARNING("Your mind feels a little less stable..."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_NOTICE("Your mind feels stable.. a little stable."))


/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Very powerful antidepressant used to treat: major depressive disorder (MDD), obsessive-compulsive disorder (OCD), social anxiety disorder (SAD), panic disorder, posttraumatic stress disorder (PTSD), generalized anxiety disorder (GAD) and prenmenstrual dysphoric disorder (PMDD). Prolonged use may have side effects."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 4, PROPERTY_HALLUCINOGENIC = 3)

/datum/reagent/antidepressant/paroxetine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(volume <= 0.1) if(data != -1)
		data = -1
		to_chat(M, SPAN_WARNING("Your mind feels much less stable..."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, SPAN_NOTICE("Your mind feels much more stable."))
			else
				to_chat(M, SPAN_WARNING("Your mind breaks apart..."))
				M.hallucination += 200

/datum/reagent/antized
	name = "Anti-Zed"
	id = "antiZed"
	description = "Destroy the zombie virus in living humans and prevents regeneration for those who have already turned."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antized/on_mob_life(mob/living/carbon/human/M)
	M.regenZ = 0
	. = ..()

// Surgery muscle relaxant & painkiller in one
// Uses paralyze - cannot move, talk, or emote but can hear; patient is safe to operate on
/datum/reagent/suxamorycin
	name = "Suxamorycin"
	id = "suxamorycin"
	description = "A fairly new, powerful muscle relaxant, engineered from suxamethonium chloride. Weston-Yamada takes great pride in its quick effect and short duration, albeit its long-term effects are not tested yet."
	reagent_state = LIQUID
	custom_metabolism = 0.5
	color = "#32a852"
	scannable = 1
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	data = 0
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_SEDATIVE = 4, PROPERTY_HALLUCINOGENIC = 1)

/datum/reagent/suxamorycin/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 3)
			M.druggy = max(M.druggy, 35)
		if(4 to INFINITY)
			M.KnockDown(2)	// move this to paralyzed, adjust the number
			M.druggy = max(M.druggy, 35)
			M.paralyzed += 2
			M.confused += 2.2

/datum/reagent/suxamorycin/on_overdose(mob/living/M)
	M.apply_damage(5, OXY)

/datum/reagent/suxamorycin/on_overdose_critical(mob/living/M)
	M.apply_damage(10, OXY)