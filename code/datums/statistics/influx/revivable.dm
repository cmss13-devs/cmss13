/datum/influx_player_stats/revivable
	name = "Revivable"
	key = "current_revivable"

/datum/influx_player_stats/revivable/is_relevant(mob/target)
	if(!ishuman(target) || target.stat != DEAD)
		return FALSE
	var/mob/living/carbon/human/human_target = target
	return human_target.is_revivable(ignore_heart = TRUE) && human_target.check_tod()
