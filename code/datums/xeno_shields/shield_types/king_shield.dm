/// Shield can be equal to a maximum of percent_maxhealth_damagecap of the receiver's max hp
/datum/xeno_shield/king_shield
	duration = 10 SECONDS
	decay_amount_per_second = 100
	/// The maximum damage multiplier of max health to apply in a hit
	var/percent_maxhealth_damagecap = 0.1

/datum/xeno_shield/king_shield/on_hit(damage)
	var/relative_damage_cap = linked_xeno.maxHealth * percent_maxhealth_damagecap

	if(damage > relative_damage_cap)
		damage = relative_damage_cap
	return ..(damage)


/datum/xeno_shield/king_shield/on_removal()
	. = ..()
	if(linked_xeno)
		// Remove the shield overlay early
		linked_xeno.remove_suit_layer()
