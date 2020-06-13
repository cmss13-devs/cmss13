/datum/xeno_shield/crusher
	amount = 200

/datum/xeno_shield/crusher/on_hit(damage)
	damage -= 10
	if (damage <= 0)
		return 0
	return ..(damage)

	
