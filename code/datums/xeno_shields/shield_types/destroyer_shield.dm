/datum/xeno_shield/destroyer_shield
	duration = 10 SECONDS
	decay_amount_per_second = 100
	var/ammo_type = /datum/ammo/xeno/bone_chips/spread/short_range
	var/percent_maxhealth_damagecap = 0.1

/datum/xeno_shield/destroyer_shield/on_hit(damage)
	var/relative_damage_cap = linked_xeno.maxHealth * percent_maxhealth_damagecap

	if(damage > relative_damage_cap)
		damage = relative_damage_cap
	return ..(damage)


/datum/xeno_shield/destroyer_shield/on_removal()
	. = ..()
	if(linked_xeno)
		// Remove the shield overlay early
		linked_xeno.remove_suit_layer()
