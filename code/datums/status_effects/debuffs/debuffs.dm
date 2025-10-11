//Largely negative status effects go here, even if they have small benificial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	tick_interval = -1
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	remove_on_fullheal = TRUE
//	heal_flag_necessary = HEAL_CC_STATUS
	var/needs_update_stat = FALSE

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		update_duration(set_duration)
	. = ..()
	if(. && needs_update_stat)
		owner.update_stat()


/datum/status_effect/incapacitating/on_remove()
	if(needs_update_stat ) //silicons need stat updates in addition to normal canmove updates
		owner.update_stat()
	return ..()

#define MAX_RESISTABLE_STUN (20 SECONDS)

//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"
	VAR_PROTECTED/resist_duration = -1
	var/last_amount = 0
//	alert_type = /atom/movable/screen/alert/status_effect/stun

/datum/status_effect/incapacitating/stun/on_creation(mob/living/new_owner, set_duration, resistable=FALSE)
	if(!resistable)
		if(new_owner)
			last_amount = set_duration / new_owner.GetStunDuration(1)
		return ..()

	resist_duration = world.time + MAX_RESISTABLE_STUN
	var/capped_amount = min(set_duration, MAX_RESISTABLE_STUN)
	if(new_owner)
		last_amount = capped_amount / new_owner.GetStunDuration(1)
	return ..(new_owner, capped_amount, resistable)

/datum/status_effect/incapacitating/stun/on_apply()
	. = ..()
	if(!.)
		return
	owner?.add_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED /*, TRAIT_HANDS_BLOCKED*/), TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/stun/on_remove()
	resist_duration = -1
	owner?.remove_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED /*, TRAIT_HANDS_BLOCKED*/), TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/stun/update_duration(amount, increment, resistable=FALSE)
	if(!resistable)
		if(owner)
			last_amount = amount / owner.GetStunDuration(1)
		return ..()

	if(resist_duration < 0)
		resist_duration = world.time + MAX_RESISTABLE_STUN

	var/capped_amount = min(amount, resist_duration - world.time)
	if(owner)
		last_amount = capped_amount / owner.GetStunDuration(1)
	return ..(capped_amount, increment)

/datum/status_effect/incapacitating/stun/adjust_duration(amount, resistable=FALSE)
	if(!resistable)
		if(owner)
			last_amount = amount / owner.GetStunDuration(1)
		return ..()

	if(resist_duration < 0)
		resist_duration = world.time + MAX_RESISTABLE_STUN

	var/capped_amount = min(amount, resist_duration - world.time)
	if(owner)
		last_amount = capped_amount / owner.GetStunDuration(1)
	return ..(capped_amount)

/atom/movable/screen/alert/status_effect/stun
	name = "Stunned"
	desc = "You are incapacitated. You may not move or act."
	icon_state = ALERT_INCAPACITATED

#undef MAX_RESISTABLE_STUN

//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"
//	alert_type = /atom/movable/screen/alert/status_effect/knockdown

/datum/status_effect/incapacitating/knockdown/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_traits(list(TRAIT_FLOORED, TRAIT_IMMOBILIZED), TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/knockdown/on_remove()
	owner.remove_traits(list(TRAIT_FLOORED, TRAIT_IMMOBILIZED), TRAIT_STATUS_EFFECT(id))
	return ..()

/atom/movable/screen/alert/status_effect/knockdown
	name = "Floored"
	desc = "You can't stand up!"
	icon_state = ALERT_FLOORED

//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"
//	alert_type = /atom/movable/screen/alert/status_effect/immobilized

/datum/status_effect/incapacitating/immobilized/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/immobilized/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	return ..()

/atom/movable/screen/alert/status_effect/immobilized
	name = "Immobilized"
	desc = "You can't move."
	icon_state = ALERT_IMMOBILIZED

//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"
	needs_update_stat = TRUE
//	alert_type = /atom/movable/screen/alert/status_effect/unconscious

/datum/status_effect/incapacitating/unconscious/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/unconscious/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/atom/movable/screen/alert/status_effect/unconscious
	name = "Unconscious"
	desc = "You've been knocked out."
	icon_state = ALERT_KNOCKEDOUT

/// DAZED:
/// This prevents talking as human or using abilities as Xenos, mainly
/datum/status_effect/incapacitating/dazed
	id = "dazed"
	needs_update_stat = TRUE

/datum/status_effect/incapacitating/dazed/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_DAZED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/dazed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_DAZED, TRAIT_STATUS_EFFECT(id))
	return ..()
