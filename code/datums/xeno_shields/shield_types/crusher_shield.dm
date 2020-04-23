/datum/xeno_shield/crusher
	amount = 200

/datum/xeno_shield/crusher/on_hit(damage)
	damage -= 12.5
	if (damage <= 0)
		return
	return ..(damage)

	
