/datum/status_effect/passive_gold
	id = "passive_gold"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 5 SECONDS
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	duration = -1
	alert_type = null
	var/gold_per_5_sec = 3

/datum/status_effect/passive_gold/on_creation(mob/living/new_owner, gold_per_5_sec = 3)
	src.gold_per_5_sec = gold_per_5_sec
	return ..()

/datum/status_effect/passive_gold/tick(seconds_between_ticks)
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOBA_GIVE_GOLD, gold_per_5_sec, TRUE)

/datum/status_effect/passive_gold/support
