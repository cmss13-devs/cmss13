/datum/status_effect/fortification
	id = "fortification"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 0 // handled in the proc below
	var/shield_duration = 4 SECONDS

/datum/status_effect/fortification/on_apply()
	. = ..()
	if(!.)
		return

	var/list/player_list = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_PLAYER_DATUM, player_list)

	var/datum/moba_player/player = player_list[1]
	switch(player.level)
		if(1 to 4)
			duration = 12 SECONDS + shield_duration
		if(5 to 8)
			duration = 11 SECONDS + shield_duration
		else
			duration = 10 SECONDS + shield_duration

	var/list/bonus_hp_list = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_BONUS_HP, bonus_hp_list)

	var/mob/living/carbon/xenomorph/xeno = owner

	// configure shield amt function here
	var/shield_amount = 45 + (player.level * 15) + (bonus_hp_list[1] * 0.2)
	shield_amount *= 1 + (xeno.armor_deflection / 50)

	xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_FORTIFICATION, duration = shield_duration, decay_amount_per_second = shield_amount * 0.25, add_shield_on = TRUE, max_shield = INFINITY) // >:3
	xeno.flick_heal_overlay(1 SECONDS, "#ffa800")
	xeno.xeno_jitter(15)
