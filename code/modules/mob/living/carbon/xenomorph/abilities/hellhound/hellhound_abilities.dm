/datum/action/xeno_action/activable/pounce/gorge // charge them with your spikes
	name = "Gorge"
	action_icon_state = "headbite"
	action_type = XENO_ACTION_CLICK
	ability_primacy =  XENO_PRIMARY_ACTION_1
	xeno_cooldown = 5 SECONDS
	plasma_cost = 0

	freeze_self = FALSE
	can_be_shield_blocked = FALSE
	var/gorge_damage = 30

/datum/action/xeno_action/onclick/sense_owner // tells them where the pred is
	name = "Find Owner"
	action_icon_state = "mark_hosts"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS // relatively short since we want them to be close most of the time
	plasma_cost = 0
	xeno_cooldown = 1 SECONDS
