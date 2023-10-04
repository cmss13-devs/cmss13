/datum/tackle_counter
	var/mob/living/carbon/human/tackled_mob
	var/tackle_count = 0
	var/min_tackles
	var/max_tackles
	var/tackle_reset_id

/datum/tackle_counter/New(mob/living/carbon/human/tackle_mob, min, max)
	tackled_mob = tackle_mob
	min_tackles = min
	max_tackles = max

#define TACKLE_HEALTH_CONSIDERATION_CAP 20
#define TACKLE_DAMAGE_CONSIDERATION_MAX 80

/datum/tackle_counter/proc/attempt_tackle()
	tackle_count++

	if (tackle_count >= max_tackles)
		return TRUE

	if (tackle_count < min_tackles)
		return FALSE

	var/tackle_mob_damage = 100 - max(tackled_mob.health, TACKLE_HEALTH_CONSIDERATION_CAP)
	var/tackle_tier_cut_offs = TACKLE_DAMAGE_CONSIDERATION_MAX / (max_tackles - min_tackles)
	var/tackle_tier_diff = tackle_mob_damage / tackle_tier_cut_offs
	var/tackles_required = max_tackles - tackle_tier_diff

	if(tackle_count >= tackles_required)
		return TRUE

	return FALSE

#undef TACKLE_HEALTH_CONSIDERATION_CAP
#undef TACKLE_DAMAGE_CONSIDERATION_MAX
