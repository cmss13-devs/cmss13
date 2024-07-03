/datum/xeno_shield/reaper
	var/mob/living/carbon/xenomorph/owner = null
	amount = 150

/datum/xeno_shield/reaper/on_hit(damage)
	var/damage_reduction = amount * 0.2 // If I am assuming shield code correctly, this means the damage reduction will scale actively with current shield amount
	damage -= damage_reduction
	if (damage <= 0)
		return 0
	return ..(damage)

/datum/xeno_shield/reaper/on_removal()
	. = ..()
	if(owner)
		owner.remove_suit_layer()
