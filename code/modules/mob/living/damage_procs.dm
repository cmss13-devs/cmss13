/*
	Apply damage to a mob with their armour considered.
	If no def_zone is supplied, one will be picked at random.
*/
/mob/living/proc/apply_armoured_damage(var/damage = 0, var/armour_type = ARMOR_MELEE, var/damage_type = BRUTE, var/def_zone = null, var/penetration = 0, var/armour_break_pr_pen = 0, var/armour_break_flat = 0)
	apply_damage(damage, damage_type, def_zone)
	return damage

/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/used_weapon = null, var/sharp = 0, var/edge = 0, var/force = FALSE)
	if(!damage)
		return FALSE

	var/list/damagedata = list("damage" = damage)
	if(SEND_SIGNAL(src, COMSIG_MOB_TAKE_DAMAGE, damagedata, damagetype) & COMPONENT_BLOCK_DAMAGE) return
	damage = damagedata["damage"]

	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage)
		if(BURN)
			adjustFireLoss(damage)
		if(TOX)
			adjustToxLoss(damage)
		if(OXY)
			adjustOxyLoss(damage)
		if(CLONE)
			adjustCloneLoss(damage)
		if(HALLOSS)
			adjustHalLoss(damage)
		if(BRAIN)
			adjustBrainLoss(damage)
			damage = damage * PAIN_ORGAN_DAMAGE_MULTIPLIER
	pain?.apply_pain(damage, damagetype)
	updatehealth()
	return 1

/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/brain = 0, var/def_zone = null)
	if(brute)	apply_damage(brute, BRUTE, def_zone)
	if(burn)	apply_damage(burn, BURN, def_zone)
	if(tox)		apply_damage(tox, TOX, def_zone)
	if(oxy)		apply_damage(oxy, OXY, def_zone)
	if(clone)	apply_damage(clone, CLONE, def_zone)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone)
	if(brain)	apply_damage(brain, BRAIN, def_zone)
	return 1

/mob/living/proc/apply_internal_damage(var/damage = 0, var/organ)
	return


/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN)
	if(!effect)
		return FALSE
	switch(effecttype)
		if(STUN)
			Stun(effect)
		if(WEAKEN)
			KnockDown(effect)
		if(PARALYZE)
			KnockOut(effect)
		if(DAZE)
			Daze(effect)
		if(SLOW)
			Slow(effect)
		if(SUPERSLOW)
			Superslow(effect)
		if(AGONY)
			halloss += effect // Useful for objects that cause "subdual" damage. PAIN!
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering, effect)
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, effect)
		if(DROWSY)
			drowsyness = max(drowsyness, effect)
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0)
	if(stun)		apply_effect(stun, STUN)
	if(weaken)		apply_effect(weaken, WEAKEN)
	if(paralyze)	apply_effect(paralyze, PARALYZE)
	if(stutter)		apply_effect(stutter, STUTTER)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR)
	if(drowsy)		apply_effect(drowsy, DROWSY)
	if(agony)		apply_effect(agony, AGONY)
	return 1
