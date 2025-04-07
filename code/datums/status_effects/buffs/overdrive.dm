/datum/status_effect/overdrive
	id = "overdrive"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	duration = 20 SECONDS
	alert_type = null
	var/acid_power = 33
	var/movespeed_bonus = -0.2
	var/armor_bonus = 15
	var/health_plasma_regen_bonus = 7

/datum/status_effect/overdrive/on_creation(mob/living/new_owner, acid_power, movespeed_bonus, armor_bonus, health_plasma_regen_bonus)
	src.acid_power = acid_power
	src.movespeed_bonus = movespeed_bonus
	src.armor_bonus = armor_bonus
	src.health_plasma_regen_bonus = health_plasma_regen_bonus
	return ..()

/datum/status_effect/overdrive/on_apply()
	. = ..()
	var/datum/component/moba_player/player_component = owner.GetComponent(/datum/component/moba_player) // sigh
	player_component.add_ap(acid_power)
	player_component.healing_value_standing += health_plasma_regen_bonus
	player_component.plasma_value_standing += health_plasma_regen_bonus
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.armor_deflection_buff += armor_bonus
	xeno.acid_armor_buff += armor_bonus
	xeno.ability_speed_modifier += movespeed_bonus
	xeno.balloon_alert_to_viewers("goes into overdrive!")

/datum/status_effect/overdrive/on_remove()
	. = ..()
	var/datum/component/moba_player/player_component = owner.GetComponent(/datum/component/moba_player)
	player_component.remove_ap(acid_power)
	player_component.healing_value_standing -= health_plasma_regen_bonus
	player_component.plasma_value_standing -= health_plasma_regen_bonus
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.armor_deflection_buff -= armor_bonus
	xeno.acid_armor_buff -= armor_bonus
	xeno.ability_speed_modifier -= movespeed_bonus
	xeno.balloon_alert_to_viewers("stops being in overdrive.")

/datum/status_effect/overdrive/tick(seconds_between_ticks)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.xeno_jitter(1.2 SECONDS)
