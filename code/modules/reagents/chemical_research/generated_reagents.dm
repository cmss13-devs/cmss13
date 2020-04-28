/////////////////////////RANDOMLY GENERATED CHEMICALS/////////////////////////
/datum/chemical_reaction/generated/
	result_amount = 1 //Makes it a bit harder to mass produce

/datum/reagent/generated/
	reagent_state = LIQUID //why isn't this default, seriously
	chemclass = CHEM_CLASS_ULTRA
	objective_value = 10
	scannable = 1

/datum/reagent/generated/New()
	//Generate stats
	if(!id) //So we can initiate a new datum without generating it
		return
	if(!chemical_reagents_list[id])
		generate_name()
		generate_stats()
		update_stats()
		chemical_reagents_list[id] = src
	make_alike(chemical_reagents_list[id])

/datum/chemical_reaction/generated/New()
	//Generate recipe
	if(!id) //So we can initiate a new datum without generating it
		return
	if(!chemical_reactions_list[id])
		generate_recipe()
		chemical_reactions_list[id] = src
	make_alike(chemical_reactions_list[id])

/////////Tier 1
//alpha
/datum/chemical_reaction/generated/alpha
	id = "alpha"
	result = "alpha"
	gen_tier = 1
		
/datum/reagent/generated/alpha
	id = "alpha"
	gen_tier = 1
		
/datum/chemical_reaction/generated/beta
	id = "beta"
	result = "beta"
	gen_tier = 1
		
/datum/reagent/generated/beta
	id = "beta"
	gen_tier = 1
		
/datum/chemical_reaction/generated/gamma
	id = "gamma"
	result = "gamma"
	gen_tier = 1
		
/datum/reagent/generated/gamma
	id = "gamma"
	gen_tier = 1

/datum/chemical_reaction/generated/delta
	id = "delta"
	result = "delta"
	gen_tier = 1
		
/datum/reagent/generated/delta
	id = "delta"
	gen_tier = 1

/datum/chemical_reaction/generated/epsilon
	id = "epsilon"
	result = "epsilon"
	gen_tier = 1

/datum/reagent/generated/epsilon
	id = "epsilon"
	gen_tier = 1

/////////Tier 2
/datum/chemical_reaction/generated/zeta
	id = "zeta"
	result = "zeta"
	gen_tier = 2

/datum/reagent/generated/zeta
	id = "zeta"
	gen_tier = 2

/datum/chemical_reaction/generated/eta
	id = "eta"
	result = "eta"
	gen_tier = 2

/datum/reagent/generated/eta
	id = "eta"
	gen_tier = 2

/datum/chemical_reaction/generated/theta
	id = "theta"
	result = "theta"
	gen_tier = 2

/datum/reagent/generated/theta
	id = "theta"
	gen_tier = 2

/////////Tier 3 zeta
/datum/chemical_reaction/generated/iota
	id = "iota"
	result = "iota"
	gen_tier = 3

/datum/reagent/generated/iota
	id = "iota"
	gen_tier = 3

/datum/chemical_reaction/generated/kappa
	id = "kappa"
	result = "kappa"
	gen_tier = 3

/datum/reagent/generated/kappa
	id = "kappa"
	gen_tier = 3

/////////Tier 4
/datum/chemical_reaction/generated/lambda
	id = "lambda"
	result = "lambda"
	gen_tier = 4

/datum/reagent/generated/lambda
	id = "lambda"
	gen_tier = 4

/////////////////////////PROCESS/////////////////////////
/*
	//Template
	if("keyword")
				if(M.stat == DEAD) <-- add this if we don't want it to work while dead
					return
				if(is_OD)
					//overdose stuff
					if(is_COD)
						//critical overdose stuff
				else
					//normal stuff
*/
/datum/reagent/generated/on_mob_life(mob/living/M, alien)
	holder.remove_reagent(id, custom_metabolism) //By default it slowly disappears.
	
	if((alien == IS_XENOS || alien == IS_YAUTJA || alien == IS_HORROR) && !(properties[PROPERTY_CROSSMETABOLIZING])) return
	
	var/boost = 0
	var/effectiveness = 1
	var/is_OD = FALSE
	var/is_COD = FALSE
	var/can_OD = TRUE
	
	//Pre-metabolis effects here
	if(has_property(PROPERTY_BOOSTING))//Must go first before anything
		boost = properties[PROPERTY_BOOSTING]
	for(var/P in properties)
		var/potency = properties[P] * 0.5 + boost
		switch(P)
			if(PROPERTY_CRYOMETABOLIZING)
				if(M.bodytemperature > 170)
					return
			if(PROPERTY_THANATOMETABOL)
				if(M.oxyloss <  50 && round(M.blood_volume) > BLOOD_VOLUME_BAD)
					return
				effectiveness = max(0.1 * potency, 0.1)
			if(PROPERTY_REGULATING)
				can_OD = FALSE
			if(PROPERTY_EXCRETING)
				holder.remove_all_type(/datum/reagent,2*potency)
				return

	if(overdose && volume >= overdose && can_OD)
		M.last_damage_source = "Experimental chemical overdose"
		M.last_damage_mob = last_source_mob
		is_OD = 1
		if(overdose_critical && volume > overdose_critical)
			is_COD = 1

	for(var/P in properties)
		if(!is_OD && P in get_negative_chem_properties(1))
			M.last_damage_source = "Experimental chemical overdose"
			M.last_damage_mob = last_source_mob

		var/potency = effectiveness * (properties[P] * 0.5 + boost)
		if(!potency) continue
		switch(P)
/////////Negative Properties/////////
			if(PROPERTY_HYPOXEMIC) //(oxygen damage)
				if(is_OD)
					//overdose stuff
					M.apply_damages(potency, 0, potency)
					M.adjustOxyLoss(5*potency)
					if(is_COD)
						//critical overdose stuff
						M.apply_damages(potency*5, 0, 2*potency)
				else
					//normal stuff
					M.adjustOxyLoss(2*potency)
				if(prob(10)) M.emote("gasp")
			if(PROPERTY_TOXIC) //toxin damage
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(potency*4)
				else
					M.adjustToxLoss(potency)
			if(PROPERTY_CORROSIVE) //burn damage
				if(is_OD)
					M.take_limb_damage(0,2*potency)
					if(is_COD)
						M.take_limb_damage(0,4*potency)
				else
					M.take_limb_damage(0,potency)
			if(PROPERTY_BIOCIDIC) //brute damage
				if(is_OD)
					M.take_limb_damage(2*potency)
					if(is_COD)
						M.take_limb_damage(4*potency)
				else
					M.take_limb_damage(potency)
			if(PROPERTY_HEMOLYTIC) //blood loss
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(C)
						if(is_OD)
							C.blood_volume = max(C.blood_volume-8*potency,0)
							M.drowsyness = min(M.drowsyness + potency,15*potency)
							M.reagent_move_delay_modifier += potency
							M.recalculate_move_delay = TRUE
							if(prob(10)) M.emote(pick("yawn","gasp"))
							if(is_COD)
								M.adjustOxyLoss(4*potency)
						else
							C.blood_volume = max(C.blood_volume-4*potency,0)
			if(PROPERTY_HEMORRAGING) //internal bleeding
				var/mob/living/carbon/human/C = M
				if(C)
					var/obj/limb/L = pick(C.limbs)
					if(L && !(L.status & LIMB_ROBOT))
						if(is_OD)
							if(L.internal_organs)
								var/datum/internal_organ/O = pick(L.internal_organs)//Organs can't bleed, so we just damage them
								O.damage += 0.5*potency
							if(is_COD)
								if(prob(20*potency))
									var/datum/wound/internal_bleeding/I = new (0)
									L.add_bleeding(I, TRUE)
									L.wounds += I
						else if(prob(5*potency))
							var/datum/wound/internal_bleeding/I = new (0)
							L.add_bleeding(I, TRUE)
							L.wounds += I
						if(prob(5*potency))
							spawn L.owner.emote("me", 1, "coughs up blood!")
							L.owner.drip(10)
			if(PROPERTY_CARCINOGENIC) //clone damage
				if(is_OD)
					M.adjustCloneLoss(2*potency)
					if(is_COD)
						M.take_limb_damage(2*potency)//Hyperactive apoptosis
				else
					M.adjustCloneLoss(0.5*potency)
			if(PROPERTY_HEPATOTOXIC) //liver damage 
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_NEPHROTOXIC) //kidney damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/kidneys/L = H.internal_organs_by_name["kidneys"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_PNEUMOTOXIC) //lung damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/lungs/L = H.internal_organs_by_name["lungs"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_OCULOTOXIC) //eye damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/eyes/L = H.internal_organs_by_name["eyes"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							if(is_COD)
								M.adjustBrainLoss(0.5*potency)
						else
							L.damage += 1.75*potency
			if(PROPERTY_CARDIOTOXIC) //heart damage
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage += 0.75*potency
			if(PROPERTY_NEUROTOXIC) //brain damage
				if(is_OD)
					M.adjustBrainLoss(3*potency)
					M.jitteriness = max(M.jitteriness + potency,0)
					if(prob(50)) M.drowsyness = max(M.drowsyness+potency, 3)
					if(prob(10)) M.emote("drool")
					if(is_COD)
						if(prob(15*potency))
							apply_neuro(M, 2*potency, FALSE)
				else
					M.adjustBrainLoss(1.75*potency)
			if(PROPERTY_ADDICTIVE)
				var/has_addiction
				for(var/datum/disease/addiction/D in M.viruses)
					if(D.chemical_id == id)
						D.handle_chem()
						has_addiction = TRUE
						break
				if(!has_addiction)
					var/datum/disease/addiction/D = new /datum/disease/addiction()
					D.chemical_id = id
					D.addiction_multiplier = potency
					M.contract_disease(D, TRUE)
				if(is_OD)
					M.adjustBrainLoss(potency)
					if(is_COD)
						M.disabilities |= NERVOUS
			if(PROPERTY_DNA_DISINTEGRATING)
				M.adjustCloneLoss(10*potency)
				if(ishuman(M) && M.cloneloss >= 190)
					var/mob/living/carbon/human/H = M
					H.contract_disease(new /datum/disease/xeno_transformation(0),1) //This is the real reason PMCs are being sent to retrieve it.
/////////Neutral Properties///////// 
			if(PROPERTY_KETOGENIC) //weight loss
				if(is_OD)
					M.nutrition = max(M.nutrition - 10*potency, 0)
					M.adjustToxLoss(potency)
					if(prob(5*potency))
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							H.vomit()
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)	
				M.nutrition = max(M.nutrition - 5*potency, 0)
				M.overeatduration = 0
				if(M.reagents.remove_all_type(/datum/reagent/ethanol, potency, 0, 1)) //Ketosis causes rapid metabolization of alcohols
					M.confused = min(M.confused + potency,10*potency)
					M.drowsyness = min(M.drowsyness + potency,15*potency)
			if(PROPERTY_PAINING) //pain
				if(is_OD)
					M.reagent_pain_modifier += 100*potency
					M.take_limb_damage(potency)
					if(is_COD)
						M.take_limb_damage(2*potency)
				else
					M.reagent_pain_modifier += 50*potency
			if(PROPERTY_NEUROINHIBITING) //disabilities
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
						continue
				if(is_OD)
					M.adjustBrainLoss(potency)
					M.disabilities |= NERVOUS
					if(is_COD)
						M.adjustBrainLoss(2*potency)
				if(potency > 1)
					M.sdisabilities |= BLIND
				else
					M.disabilities |= NEARSIGHTED
				if(potency > 2)
					M.sdisabilities |= DEAF
				if(potency > 3)
					M.sdisabilities |= MUTE
			if(PROPERTY_ALCOHOLIC) //drunkness
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
						continue
				if(is_OD)
					M.confused += min(M.confused + potency*2,20*potency)
					M.drowsyness += min(M.drowsyness + potency*2,30*potency)
					M.adjustToxLoss(0.5*potency)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
						if(L)
							L.damage += 0.5*potency
							if(is_COD)
								L.damage += 2*potency
					if(is_COD)
						M.adjustOxyLoss(4*potency)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.confused = min(M.confused + potency,10*potency)
					M.drowsyness = min(M.drowsyness + potency,15*potency)
			if(PROPERTY_HALLUCINOGENIC) //hallucinations
				if(prob(10)) M.emote(pick("twitch","drool","moan","giggle"))
				if(is_OD)
					if(isturf(M.loc) && !istype(M.loc, /turf/open/space))
						if(M.canmove && !M.is_mob_restrained())
							if(prob(10)) step(M, pick(cardinal))
					M.hallucination += 10
					M.make_jittery(5)
					if(is_COD)
						M.adjustBrainLoss(potency)
						M.knocked_out = max(M.knocked_out, 20)
				else
					if(potency>2)
						M.hallucination += potency
					M.druggy += potency
					M.make_jittery(5)
			if(PROPERTY_RELAXING) //slows movement
				if(is_OD)
					//heart beats slower
					M.reagent_move_delay_modifier += 2*potency
					to_chat(M, SPAN_WARNING("You feel incredibly weak!"))
					if(is_COD)
						//heart stops beating, lungs stop working
						if(prob(15*potency))
							M.KnockOut(potency)
						M.adjustOxyLoss(potency)
						if(prob(5)) to_chat(M, SPAN_WARNING("You can hardly breathe!"))
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
							if(E)
								E.damage += 0.75*potency
				else
					M.reagent_move_delay_modifier += potency
					if(prob(10)) M.emote("yawn")
				M.recalculate_move_delay = TRUE
			if(PROPERTY_HYPERTHERMIC) //increase bodytemperature
				if(prob(10)) M.emote("gasp")
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature+4*potency,0)
					M.drowsyness  = max(M.drowsyness, 40)
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.bodytemperature = max(M.bodytemperature+2*potency,0)
			if(PROPERTY_HYPOTHERMIC) //decrease bodytemperature
				if(prob(10)) M.emote("shiver")
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature-4*potency,0)
					M.drowsyness  = max(M.drowsyness, 40)
					if(is_COD)
						M.knocked_out = max(M.knocked_out, 20)
				else
					M.bodytemperature = max(M.bodytemperature-2*potency,0)
			if(PROPERTY_BALDING) //unga
				if(is_OD)
					M.adjustCloneLoss(0.5*potency)
					if(is_COD)
						M.adjustCloneLoss(potency)
				if(prob(5*potency))
					var/mob/living/carbon/human/H = M
					if(H)
						if((H.h_style != "Bald" || H.f_style != "Shaved"))
							to_chat(M, SPAN_WARNING("Your hair falls out!"))
							H.h_style = "Bald"
							H.f_style = "Shaved"
							H.update_hair()
			if(PROPERTY_FLUFFING) //hair growth
				if(is_OD)
					if(prob(5*potency))
						to_chat(M, SPAN_WARNING("You feel itchy all over!"))
						M.take_limb_damage(potency) //Hair growing inside your body
						if(is_COD)
							to_chat(M, SPAN_WARNING("You feel like something is penetrating your skull!"))
							M.adjustBrainLoss(potency)//Hair growing into brain
				if(prob(5*potency))
					var/mob/living/carbon/human/H = M
					if(H)
						H.h_style = "Bald"
						H.f_style = "Shaved"
						H.h_style = pick(hair_styles_list)
						H.f_style = pick(facial_hair_styles_list)
						H.update_hair()
						to_chat(M, SPAN_NOTICE("Your head feels different..."))
			if(PROPERTY_ALLERGENIC) //sneezing etc.
				if(prob(5*potency)) M.emote(pick("sneeze","blink","cough"))
			if(PROPERTY_EUPHORIC) //HAHAHAHA
				if(is_OD)
					if(prob(5*potency)) M.emote("collapse") //ROFL
					if(is_COD)
						M.adjustOxyLoss(3*potency)
						M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))
						to_chat(M, SPAN_WARNING("You are laughing so much you can't breathe!"))
				if(!is_COD && prob(5*potency)) M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))
				M.reagent_pain_modifier += 20*potency //Endorphins are natural painkillers
			if(PROPERTY_EMETIC) //vomiting
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H)
						if(is_OD)
							M.adjustToxLoss(0.5*potency)
							if(is_COD)
								M.adjustToxLoss(0.5*potency)
						if(prob(volume*potency))
							H.vomit() //vomit() already has a timer on in
			if(PROPERTY_PSYCHOSTIMULATING) //calming messages
				if(is_OD)
					M.adjustBrainLoss(potency)
					if(is_COD)
						M.hallucination += 200
						M.adjustBrainLoss(4*potency)
				else
					if(volume <= 0.1) if(data != -1)
						data = -1
						if(potency == 1)
							to_chat(M, SPAN_WARNING("Your mind feels a little less stable..."))
						else if(potency == 2)
							to_chat(M, SPAN_WARNING("You lose focus..."))
						else if(potency == 3)
							to_chat(M, SPAN_WARNING("Your mind feels much less stable..."))
						else 
							to_chat(M, SPAN_WARNING("You lose your perfect focus..."))
					else
						if(world.time > data + 3000)
							data = world.time
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
			if(PROPERTY_ANTIHALLUCINOGENIC) //removes hallucinations
				if(is_OD)
					M.apply_damage(potency, TOX)
					if(is_COD)
						M.apply_damages(potency, potency, 3*potency)
				else
					holder.remove_reagent("mindbreaker", 5)
					holder.remove_reagent("space_drugs", 5)
					M.hallucination = max(0, M.hallucination - 10*potency)
					M.druggy = max(0, M.druggy - 10*potency)
			if(PROPERTY_NUTRITIOUS) //only picked if nutriment factor > 0
				M.nutrition += nutriment_factor * potency
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(C.blood_volume < BLOOD_VOLUME_NORMAL)
						C.blood_volume = max(0.2 * potency,BLOOD_VOLUME_NORMAL)
			if(PROPERTY_SEDATIVE)
				M.paralyzed += potency
				if(M.paralyzed > potency * 2)
					M.AdjustSleeping(potency)
				if(prob(10)) M.emote("yawn")
				if(is_OD)
					M.AdjustKnockedout(potency)
					if(is_COD)
						M.adjustOxyLoss(5*potency)
			if(PROPERTY_HYPERTHROTTLING)
				if(!ishuman(M))
					continue
				if(is_OD)
					M.adjustBrainLoss(3*potency)
					if(is_COD)
						M.KnockOut(potency*2)
				var/mob/living/carbon/human/H = M
				M.reagent_move_delay_modifier += 4*potency
				M.recalculate_move_delay = TRUE
				M.druggy = min(M.druggy + potency, 10)
				if(H.chem_effect_flags & CHEM_EFFECT_HYPER_THROTTLE)
					continue
				H.chem_effect_flags |= CHEM_EFFECT_HYPER_THROTTLE
				to_chat(M, SPAN_NOTICE("You feel like you're in a dream. It is as if the world is standing still."))
				M.universal_understand = TRUE //Brain is working so fast it can understand the intension of everything it hears
/////////Positive Properties///////// 
			if(PROPERTY_ANTITOXIC) //toxin healing
				if(is_OD)
					M.drowsyness  = max(M.drowsyness, 30)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
						if(E)
							E.damage += potency
						if(is_COD)
							E.damage += 2*potency
				else
					M.adjustToxLoss(-(0.25+potency))
			if(PROPERTY_ANTICORROSIVE) //burn healing
				if(is_OD)
					M.apply_damages(2*potency, 0, potency) //Mixed brute/tox damage
					if(is_COD)
						M.apply_damages(4*potency, 0, 2*potency) //Massive brute/tox damage
				else
					M.heal_limb_damage(0, 0.25+potency)
			if(PROPERTY_NEOGENETIC) //brute healing
				if(is_OD)
					M.apply_damage(potency, BURN)
					if(is_COD)
						M.apply_damages(0, 4*potency, 2*potency)
				else
					M.heal_limb_damage(0.25+potency, 0)
			if(PROPERTY_REPAIRING) //cybernetic repairing
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(4*potency)
				else
					var/mob/living/carbon/human/C = M
					if(C)
						var/obj/limb/L = pick(C.limbs)
						if(L)
							if(L.status & LIMB_ROBOT)
								L.heal_damage(2*potency,2*potency,0,1)
			if(PROPERTY_HEMOGENIC) //Blood production
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(is_OD)
						C.blood_volume = min(C.blood_volume+2*potency,BLOOD_VOLUME_MAXIMUM+100)
						M.nutrition = max(M.nutrition - 5*potency, 0)
						if(is_COD)
							M.adjustToxLoss(2*potency)
					else
						C.blood_volume = min(C.blood_volume+potency,BLOOD_VOLUME_MAXIMUM+100)
					if(C.blood_volume > BLOOD_VOLUME_MAXIMUM) //Too many red blood cells thickens the blood and leads to clotting
						M.take_limb_damage(potency)
						M.adjustOxyLoss(2*potency)
						M.reagent_move_delay_modifier += potency
						M.recalculate_move_delay = TRUE
			if(PROPERTY_NERVESTIMULATING) //stun decrease
				if(prob(10)) M.emote("twitch")
				if(is_OD)
					M.adjustBrainLoss(potency)
					M.jitteriness = max(M.jitteriness + potency,0)
					if(prob(50)) M.drowsyness = max(M.drowsyness+potency, 3)
					if(is_COD)
						M.KnockOut(potency*2)
				else
					M.AdjustKnockedout(potency*-1)
					M.AdjustStunned(potency*-1)
					M.AdjustKnockeddown(potency*-1)
					M.AdjustStunned(-0.5*potency)
					M.stuttering = max(M.stuttering-2*potency, 0)
					M.confused = max(M.confused-2*potency, 0)
					M.eye_blurry = max(M.eye_blurry-2*potency, 0)
					M.drowsyness = max(M.drowsyness-2*potency, 0)
					M.dizziness = max(M.dizziness-2*potency, 0)
					M.jitteriness = max(M.jitteriness-2*potency, 0)
			if(PROPERTY_MUSCLESTIMULATING) //increases movement
				if(prob(10)) M.emote(pick("twitch","blink_r","shiver"))
				if(is_OD)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
						if(E)
							E.damage += 0.5*potency
							if(is_COD)
								E.damage += potency
								M.take_limb_damage(0.5*potency)
				else
					M.reagent_move_delay_modifier -= potency
					M.recalculate_move_delay = TRUE
			if(PROPERTY_PAINKILLING) //painkiller
				if(is_OD)
					M.hallucination = max(M.hallucination, potency) //Hallucinations and tox damage
					M.apply_damage(potency, TOX)
					if(is_COD) //Massive liver damage
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
							if(L)
								L.damage += 3*potency
				else
					M.reagent_pain_modifier += -30*potency
			if(PROPERTY_HEPATOPEUTIC) //liver healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_NEPHROPEUTIC) //kidney healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/kidneys/L = H.internal_organs_by_name["kidneys"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustToxLoss(2*potency)
							if(is_COD)
								M.adjustToxLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_PNEUMOPEUTIC) //lung healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/lungs/L = H.internal_organs_by_name["lungs"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
							if(L.damage < 1)
								L.rejuvenate()
							H.adjustOxyLoss(-2*potency)
			if(PROPERTY_OCULOPEUTIC) //eye healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
					if(is_OD)
						M.apply_damage(2, TOX)
						if(E)
							E.damage += potency
						if(is_COD)
							M.adjustBrainLoss(potency)
					else
						if(E)
							if(E.damage > 0)
								E.damage = max(E.damage - 0.5*potency, 0)
			if(PROPERTY_CARDIOPEUTIC) //heart healing
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
					if(L)
						if(is_OD)
							L.damage += 2*potency
							M.adjustOxyLoss(2*potency)
							if(is_COD)
								M.adjustOxyLoss(5*potency)
						else
							L.damage = max(L.damage - 0.5*potency, 0)
			if(PROPERTY_NEUROPEUTIC) //brain healing
				if(is_OD)
					M.apply_damage(potency, TOX)
					if(is_COD)
						M.adjustBrainLoss(3 * potency)
						M.AdjustStunned(potency)
				else
					M.adjustBrainLoss(-3 * potency)
			if(PROPERTY_BONEMENDING) //repairs bones
				var/mob/living/carbon/human/C = M
				if(C)
					var/obj/limb/L = pick(C.limbs)
					if(L)
						if(is_OD)
							M.take_limb_damage(2*potency)
							if(is_COD)
								L.fracture()
						else
							if(L.knitting_time > 0) break // only one knits at a time
							switch(L.name)
								if("groin","chest")
									L.time_to_knit = 1200 // 12 mins
								if("head")
									L.time_to_knit = 1000 // 10 mins
								if("l_hand","r_hand","r_foot","l_foot")
									L.time_to_knit = 300 // 3 mins
								if("r_leg","r_arm","l_leg","l_arm")
									L.time_to_knit = 600 // 6 mins
							if(L.time_to_knit && (L.status & LIMB_BROKEN))
								if(L.knitting_time == -1 && (L.status & LIMB_SPLINTED))
									var/total_knitting_time = world.time + L.time_to_knit - max(150*potency, L.time_to_knit + 50)
									L.knitting_time = total_knitting_time
									L.start_processing()
									to_chat(M, SPAN_NOTICE("You feel the bones in your [L.display_name] starting to knit together."))			
			if(PROPERTY_FLUXING) //dissolves metal shrapnel
				if(is_OD)
					M.apply_damages(2*potency, 0, 2*potency)
					if(is_COD)
						M.apply_damages(4*potency, 0, 4*potency) //Mixed brute/tox damage
				else
					var/mob/living/carbon/human/C = M
					if(C)
						var/obj/limb/L = pick(C.limbs)
						if(L && prob(10*potency))
							if(L.status & LIMB_ROBOT)
								L.take_damage(0,2*potency)
								break
							if(L.implants && L.implants.len > 0)
								var/obj/implanted_object = pick(L.implants)
								if(implanted_object)
									L.implants -= implanted_object
			if(PROPERTY_ANTIPARASITIC) //potency 1 is enough to pause embryo growth. Higher will degrade it)
				if(is_OD)
					M.adjustToxLoss(2*potency)
					if(is_COD)
						M.adjustToxLoss(4*potency)
				else
					var/mob/living/carbon/human/H = M
					if(H)
						for(var/content in H.contents)
							var/obj/item/alien_embryo/A = content
							if(A && istype(A))
								if(A.counter)
									A.counter = max(A.counter - 1+potency,0)
									H.take_limb_damage(0,0.2*potency)
								else
									A.stage--
									if(A.stage <= 0)//if we reach this point, the embryo dies and the occupant takes a nasty amount of acid damage
										qdel(A)
										H.take_limb_damage(0,rand(20,40))
										H.vomit()
									else
										A.counter = 90
			if(PROPERTY_HYPERGENETIC) //brute healing on everything
				var/mob/living/carbon/human/H = M
				if(!H)
					continue
				for(var/datum/internal_organ/O in H.internal_organs)
					if(is_OD)
						O.damage += 2*potency
						if(is_COD)
							O.damage += 4*potency
					else
						O.heal_damage(potency)
				if(is_OD)
					M.adjustCloneLoss(2*potency)
					if(is_COD)
						M.take_limb_damage(2*potency,2*potency)
					continue
				else
					M.heal_limb_damage(0.2+potency)
			if(PROPERTY_HYPERDENSIFICATING)
				if(!ishuman(M))
					continue
				var/mob/living/carbon/human/H = M
				if(H.chem_effect_flags & CHEM_EFFECT_RESIST_FRACTURE)
					continue
				H.chem_effect_flags |= CHEM_EFFECT_RESIST_FRACTURE
				to_chat(M, SPAN_NOTICE("Your body feels incredibly tense."))
			if(PROPERTY_NEUROSHIELDING)
				if(!ishuman(M))
					continue
				var/mob/living/carbon/human/H = M
				if(is_OD)
					var/datum/internal_organ/liver/L = H.internal_organs_by_name["liver"]
					L.damage += potency
					if(is_COD)
						L.damage += 2*potency
				if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
					continue
				H.chem_effect_flags |= CHEM_EFFECT_RESIST_NEURO
				to_chat(M, SPAN_NOTICE("Your skull feels incredibly thick."))
				M.dazed = 0
			if(PROPERTY_ANTIADDICTIVE)
				if(is_OD)
					M.adjustBrainLoss(2*potency)
					if(is_COD)
						M.hallucination = max(M.hallucination, potency)
				for(var/datum/disease/addiction/D in M.viruses)
					if(potency >= 4)
						D.cure()
						continue
					D.withdrawal_progression -= 2*potency
					D.addiction_progression -= 2*potency
					if(D.addiction_progression < potency)
						D.cure()
			//effects while dead are handled by handle_necro_chemicals_in_body()
			if(PROPERTY_NEUROCRYOGENIC) //slows brain death
				if(is_OD)
					M.bodytemperature = max(M.bodytemperature-5*potency,0)
					if(is_COD)
						M.adjustBrainLoss(5 * potency)
				else
					if(prob(20)) to_chat(M, SPAN_WARNING("You feel like you have the worst brain freeze ever!"))
					M.knocked_out = max(M.knocked_out, 20)
					M.stunned = max(M.stunned,21)
			if(PROPERTY_DEFIBRILLATING)
				if(is_OD)
					M.reagent_pain_modifier += 30*potency
					M.adjustOxyLoss(2*potency)
					if(is_COD && ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
						if(L)
							L.damage += potency
/////////ADMIN ONLY PROPERTIES/////////
			if(PROPERTY_EMBRYONIC) //Adds embryo's. 
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC)) //No effect if already infected
						continue
					for(var/i=1,i<=max((potency % 100)/10,1),i++)//10's determine number of embryos
						var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
						embryo.hivenumber = min(potency % 10,5) //1's determine hivenumber
			if(PROPERTY_TRANSFORMING) //Xenomorph Transformation
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.contract_disease(new /datum/disease/xeno_transformation(0),1)
			if(PROPERTY_RAVENING) //Zombie infection
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.contract_disease(new /datum/disease/black_goo, 1)
			if(PROPERTY_CURING) //Cures diseases
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.viruses)
						for(var/datum/disease/D in H.viruses)
							if(potency >= 4)
								D.cure()
								H.regenZ = 0
							else
								if(D.name == "Unknown Mutagenic Disease" && (potency == 1 || potency > 3))
									D.cure()
								if(D.name == "Black Goo" && potency >=2)
									D.cure()
									H.regenZ = 0
			if(PROPERTY_OMNIPOTENT)
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
				var/mob/living/carbon/human/H = M
				if(H)
					for(var/datum/internal_organ/I in H.internal_organs)
						if(I.damage > 0)
							I.damage = max(I.damage - 1, 0)
				for(var/datum/disease/D in M.viruses)
					D.spread = "Remissive"
					D.stage--
					if(D.stage < 1)
						D.cure()

/datum/chemical_reaction/generated/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/reagent/R = holder.reagent_list[id]
	if(!R || !R.properties)
		return
	for(var/P in R.properties)
		var/potency = R.properties[P] * 0.5
		if(!potency)
			continue
		switch(P)
			if(PROPERTY_HYPERTHERMIC)
				if(created_volume > R.overdose)
					holder.trigger_volatiles = TRUE
			if(PROPERTY_EXPLOSIVE)
				if(created_volume > R.overdose)
					holder.trigger_volatiles = TRUE