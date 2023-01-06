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
	if(damagetype != HALLOSS && damage > 0)
		life_damage_taken_total += damage
	updatehealth()
	return 1

/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/brain = 0, var/def_zone = null)
	if(brute) apply_damage(brute, BRUTE, def_zone)
	if(burn) apply_damage(burn, BURN, def_zone)
	if(tox) apply_damage(tox, TOX, def_zone)
	if(oxy) apply_damage(oxy, OXY, def_zone)
	if(clone) apply_damage(clone, CLONE, def_zone)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone)
	if(brain) apply_damage(brain, BRAIN, def_zone)
	return 1

/mob/living/proc/apply_internal_damage(var/damage = 0, var/organ)
	return

#define EFFECT_FLAG_LIFE (1<<0)
#define EFFECT_FLAG_DEFAULT (1<<1)
//Examples for future usage!
//#define EFFECT_FLAG_EXPLOSIVE
//#define EFFECT_FLAG_XENOMORPH
//#define EFFECT_FLAG_CHEMICAL

/mob/proc/apply_effect()
	return FALSE

/mob/living/apply_effect(var/effect = 0,var/effect_type = STUN, var/effect_flags = EFFECT_FLAG_DEFAULT)

	if(SEND_SIGNAL(src, COMSIG_LIVING_APPLY_EFFECT, effect, effect_type, effect_flags) & COMPONENT_CANCEL_EFFECT)
		return

	if(!effect)
		return FALSE

	switch(effect_type)
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
			EyeBlur(effect)
		if(DROWSY)
			drowsyness = max(drowsyness, effect)
	updatehealth()
	return TRUE

/mob/proc/adjust_effect()
	return FALSE

/mob/living/adjust_effect(var/effect = 0,var/effect_type = STUN, var/effect_flags = EFFECT_FLAG_DEFAULT)

	if(SEND_SIGNAL(src, COMSIG_LIVING_ADJUST_EFFECT, effect, effect_type, effect_flags) & COMPONENT_CANCEL_EFFECT)
		return

	if(!effect)
		return FALSE

	switch(effect_type)
		if(STUN)
			AdjustStun(effect)
		if(WEAKEN)
			AdjustKnockDown(effect)
		if(PARALYZE)
			AdjustKnockOut(effect)
		if(DAZE)
			AdjustDaze(effect)
		if(SLOW)
			AdjustSlow(effect)
		if(SUPERSLOW)
			AdjustSuperslow(effect)
		if(AGONY)
			halloss += effect // Useful for objects that cause "subdual" damage. PAIN!
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = POSITIVE(stuttering + effect)
		if(EYE_BLUR)
			AdjustEyeBlur(effect)
		if(DROWSY)
			drowsyness = POSITIVE(drowsyness + effect)
	updatehealth()
	return TRUE

/mob/proc/set_effect()
	return FALSE

/mob/living/set_effect(var/effect = 0,var/effect_type = STUN, var/effect_flags = EFFECT_FLAG_DEFAULT)

	if(SEND_SIGNAL(src, COMSIG_LIVING_SET_EFFECT, effect, effect_type, effect_flags) & COMPONENT_CANCEL_EFFECT)
		return

	switch(effect_type)
		if(STUN)
			SetStun(effect)
		if(WEAKEN)
			SetKnockDown(effect)
		if(PARALYZE)
			SetKnockOut(effect)
		if(DAZE)
			SetDaze(effect)
		if(SLOW)
			SetSlow(effect)
		if(SUPERSLOW)
			SetSuperslow(effect)
		if(AGONY)
			halloss += effect // Useful for objects that cause "subdual" damage. PAIN!
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = POSITIVE(effect)
		if(EYE_BLUR)
			SetEyeBlur(effect)
		if(DROWSY)
			drowsyness = POSITIVE(effect)
	updatehealth()
	return TRUE

/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0)
	if(stun) apply_effect(stun, STUN)
	if(weaken) apply_effect(weaken, WEAKEN)
	if(paralyze) apply_effect(paralyze, PARALYZE)
	if(stutter) apply_effect(stutter, STUTTER)
	if(eyeblur) apply_effect(eyeblur, EYE_BLUR)
	if(drowsy) apply_effect(drowsy, DROWSY)
	if(agony) apply_effect(agony, AGONY)
	return 1
