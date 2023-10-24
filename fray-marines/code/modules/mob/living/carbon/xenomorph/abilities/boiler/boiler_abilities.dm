/datum/action/xeno_action/onclick/shift_spits/boiler/can_use_action()
	if(..() == TRUE && action_cooldown_check()) /// Я пофиксил баг с кулдауном смены плевков за оффцм девов ~Danilcus
		return TRUE
	return FALSE
