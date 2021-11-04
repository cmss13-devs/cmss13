/datum/internal_organ/liver
	name = "liver"
	removed_type = /obj/item/organ/liver
	robotic_type = /obj/item/organ/liver/prosthetic
	min_bruised_integrity = LIMB_INTEGRITY_SERIOUS
	min_broken_integrity = LIMB_INTEGRITY_NONE
	organ_tag = ORGAN_LIVER

/datum/internal_organ/liver/on_malfunction(trait_source)
	..()
	RegisterSignal(owner, COMSIG_MOB_INGESTION, .proc/ingestion_cancel)

/datum/internal_organ/liver/proc/ingestion_cancel(mob/living/carbon/human/H, obj/item/reagent_container/ingested)
	SIGNAL_HANDLER
	var/turf/T = get_turf(H)
	to_chat(H, SPAN_WARNING("You violently throw up a chunk of the contents of \the [ingested] as your body fails to properly digest it!")) // hey maybe you should go to a doctor MAYBE
	H.nutrition -= 20
	H.apply_damage(-3, TOX)
	playsound(T, 'sound/effects/splat.ogg', 25, 1, 7)
	T.add_vomit_floor(H)

	for(var/datum/reagent/R in ingested.reagents.reagent_list)
		H.reagents.remove_reagent(R.id, R.volume/2)

/*
/datum/internal_organ/liver/process()
	..()

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else
				var/datum/internal_organ/O = pick(owner.internal_organs)
				if(O)
					O.damage += 0.2  * PROCESS_ACCURACY

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_malf_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(!(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS))
			if(is_bruised())
				filter_effect -= 1
			if(is_broken())
				filter_effect -= 2

		// Do some reagent filtering/processing.
		for(var/datum/reagent/R in owner.reagents.reagent_list)
			// Damaged liver means some chemicals are very dangerous
			// The liver is also responsible for clearing out alcohol and toxins.
			// Ethanol and all drinks are bad.K
			if(istype(R, /datum/reagent/ethanol))
				if(filter_effect < 3)
					owner.apply_damage(0.1 * PROCESS_ACCURACY, TOX)
				owner.reagents.remove_reagent(R.id, R.custom_metabolism*filter_effect)

		//Deal toxin damage if damaged
		if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
			return
		if(is_bruised() && prob(25))
			owner.apply_damage(0.1 * (damage/2), TOX)
		else if(is_broken() && prob(50))
			owner.apply_damage(0.3 * (damage/2), TOX)

*/

/datum/internal_organ/liver/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/liver/prosthetic
