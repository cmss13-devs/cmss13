/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	recalculate_move_delay = TRUE

	// Each damagetype has a unique multiplier that gets rolled into traumatic_shock
	// TODO: Purge shock_stage altogether, JUST use traumatic_shock 
	// or do a more comprehensive code rework that includes effects rather than just scaling changes
	traumatic_shock = 	  					    \
	OXY_TRAUMA_MULTIPLIER	 * getOxyLoss()   + \
	TOX_TRAUMA_MULTIPLIER	 * getToxLoss()   + \
	BRUTE_TRAUMA_MULTILPLIER * getBruteLoss() + \
	FIRE_TRAUMA_MULTIPLIER   * getFireLoss()  + \
	CLONE_TRAUMA_MULTIPLIER  * getCloneLoss()

	traumatic_shock += reagent_shock_modifier

	if(slurring) 								
		traumatic_shock -= 20
	if(analgesic) 								
		traumatic_shock = 0


	//Broken or ripped off organs and limbs will add quite a bit of pain
	if(ishuman(src))
		var/mob/living/carbon/human/M = src
		for(var/obj/limb/O in M.limbs)
			if((O.status & LIMB_DESTROYED) && !(O.status & LIMB_AMPUTATED))
				traumatic_shock += 80
			else if(O.status & LIMB_BROKEN || O.surgery_open_stage)
				if(O.status & !LIMB_SPLINTED)
					traumatic_shock += 30
				else
					traumatic_shock += 10

		//Internal organs hurt too
		for(var/datum/internal_organ/O in M.internal_organs)
			if(O.damage) 											
				traumatic_shock += O.damage * 1.5

		if(M.protection_aura)
			traumatic_shock -= M.protection_aura * 10

	traumatic_shock = max(0, traumatic_shock)	//stuff below this has the potential to mask damage

	traumatic_shock += halloss //not affected by reagent shock reduction
	traumatic_shock += reagent_pain_modifier

	return traumatic_shock

/mob/living/carbon/proc/handle_shock()
	updateshock()
