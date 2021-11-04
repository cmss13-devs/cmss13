
//procs directly related to mob health


/mob/living/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))

/mob/living/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))

/mob/living/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth







// heal ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_limb_damage(var/brute, var/burn)
	apply_damage(-brute, BRUTE)
	apply_damage(-burn, BURN)
	src.updatehealth()

// damage ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/take_limb_damage(var/brute, var/burn)
	if(status_flags & GODMODE)	return 0	//godmode
	apply_damage(brute, BRUTE)
	apply_damage(burn, BURN)
	src.updatehealth()

// heal MANY limbs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	apply_damage(-brute, BRUTE)
	apply_damage(-burn, BURN)
	src.updatehealth()

// damage MANY limbs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	apply_damage(brute, BRUTE)
	apply_damage(burn, BURN)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive(keep_viruses)
	rejuvenate()


/mob/living/proc/rejuvenate()
	heal_all_damage()

	SEND_SIGNAL(src, COMSIG_LIVING_REJUVENATED)

	// shut down ongoing problems
	nutrition = NUTRITION_NORMAL
	bodytemperature = T20C
	recalculate_move_delay = TRUE
	sdisabilities = 0
	disabilities = 0
	drowsyness = 0
	hallucination = 0

	// restore all of a human's blood
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.restore_blood()
		H.reagents.clear_reagents() //and clear all reagents in them
		SShuman.processable_human_list |= H
		H.undefibbable = FALSE
		H.chestburst = 0
		H.update_headshot_overlay() //They don't have their brains blown out anymore, if they did.

	// fix all of our organs
	restore_all_organs()

	//Reset any surgeries.
	active_surgeries = DEFENSE_ZONES_LIVING
	initialize_incision_depths()

	// remove the character from the list of the dead
	if(stat == DEAD)
		GLOB.dead_mob_list -= src
		GLOB.alive_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to conciousness
	stat = CONSCIOUS
	regenerate_all_icons()


/mob/living/proc/heal_all_damage()
	// shut down various types of badness
	heal_overall_damage(getBruteLoss(), getFireLoss())
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetKnockedout(0)
	SetStunned(0)
	SetDazed(0)
	SetSlowed(0)
	SetSuperslowed(0)
	SetKnockeddown(0)
	ExtinguishMob()
	fire_stacks = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	SetEarDeafness(0)
	ear_damage = 0
	paralyzed = 0
	confused = 0
	druggy = 0

/mob/living/proc/regenerate_all_icons()
	// make the icons look correct
	regenerate_icons()
	med_hud_set_status()
	med_hud_set_health()
	med_hud_set_armor()
	reload_fullscreens()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.update_body()

/mob/living/keybind_face_direction(direction)
	if(!canface())
		return
	if(stat >= UNCONSCIOUS)
		return
	return ..()
