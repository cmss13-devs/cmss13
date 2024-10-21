// TODO: Some day do custom count effect on stats updated, so don't copy this procs and also do it flexible like right now (I don't wanna change it, because on next merge upstream in this rep it will fuck up all calls on that and fixing more flexible shit will be harder)
// Also, make it wait and count like every +-30 minutes, so our DB don't fuck up in INF!, funny... (Right now if you tru to update that very often it will fuck up all, so better make it affect already taken rows, in case if no rows, just make new)

// Ignore above TODO and funny comment, I'll leave it remain here, until it's merged and I'll do new pr with creating finnal touchs (originaly this comment from mine offstream, but I forgot to remove it, plus this contain really useful information about what to do next with this to increase it realability and prettyisdajghhfh)

/////////////////////////////////////////////////////////////////////////////////////
//Mob

/mob/proc/can_track_statistic()
	if(statistic_exempt || statistic_tracked || !client?.player_data || !faction)
		return FALSE
	return TRUE

/mob/proc/track_death_calculations()
	if(!can_track_statistic())
		return FALSE

	statistic_tracked = TRUE
	return TRUE

/mob/proc/count_statistic_stat(statistic_name, amount = 1, weapon)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_steps_walked()
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_hit(weapon, amount = 1, statistic_name = STATISTICS_HIT)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_friendly_hit(weapon, amount = 1, statistic_name = STATISTICS_FF_HIT)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_shot(weapon, amount = 1, statistic_name = STATISTICS_SHOT)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_shot_hit(weapon, mob/shot_mob, amount = 1, statistic_name = STATISTICS_SHOT_HIT)
	if(!can_track_statistic())
		return FALSE

	if(GLOB.round_statistics)
		GLOB.round_statistics.total_projectiles_hit += amount
		if(shot_mob)
			if(ishuman(shot_mob))
				GLOB.round_statistics.total_projectiles_hit_human += amount
			else if(isxeno(shot_mob))
				GLOB.round_statistics.total_projectiles_hit_xeno += amount
	return TRUE

/mob/proc/track_damage(weapon, mob/damaged_mob, amount = 1, statistic_name = STATISTICS_DAMAGE)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_friendly_damage(weapon, mob/damaged_mob, amount = 1, statistic_name = STATISTICS_FF_DAMAGE)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_heal_damage(weapon, mob/healed_mob, amount = 1, statistic_name = STATISTICS_HEALED_DAMAGE)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_friendly_fire(weapon, amount = 1, statistic_name = STATISTICS_FF_SHOT_HIT)
	if(!can_track_statistic())
		return FALSE

	if(GLOB.round_statistics)
		GLOB.round_statistics.total_friendly_fire_instances += amount

	return TRUE

/mob/proc/track_revive(amount = 1, statistic_name = STATISTICS_REVIVED)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_life_saved(amount = 1, statistic_name = STATISTICS_REVIVE)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_scream(amount = 1, statistic_name = STATISTICS_SCREAM)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/mob/proc/track_slashes(caste, amount = 1, statistic_name = STATISTICS_SLASH)
	if(!can_track_statistic())
		return FALSE

	if(GLOB.round_statistics)
		GLOB.round_statistics.total_slashes += amount

	return TRUE

/mob/proc/track_ability_usage(ability, caste, amount = 1)
	if(!can_track_statistic())
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////////////////////////////////
//Human


/mob/living/carbon/human/track_death_calculations()
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), STATISTICS_ROUNDS_PLAYED, 1, client.player_data)

/mob/living/carbon/human/count_statistic_stat(statistic_name, amount = 1, weapon)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_steps_walked(amount = 1, statistic_name = STATISTICS_STEPS_WALKED)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_hit(weapon, amount = 1, statistic_name = STATISTICS_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_friendly_hit(weapon, amount = 1, statistic_name = STATISTICS_FF_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_shot(weapon, amount = 1, statistic_name = STATISTICS_SHOT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_shot_hit(weapon, mob/shot_mob, amount = 1, statistic_name = STATISTICS_SHOT_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_damage(weapon, mob/damaged_mob, amount = 1, statistic_name = STATISTICS_DAMAGE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_friendly_damage(weapon, mob/damaged_mob, amount = 1, statistic_name = STATISTICS_FF_DAMAGE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_heal_damage(weapon, mob/healed_mob, amount = 1, statistic_name = STATISTICS_HEALED_DAMAGE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_friendly_fire(weapon, amount = 1, statistic_name = STATISTICS_FF_SHOT_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_revive(amount = 1, statistic_name = STATISTICS_REVIVED)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_life_saved(amount = 1, statistic_name = STATISTICS_REVIVE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)

/mob/living/carbon/human/track_scream(amount = 1, statistic_name = STATISTICS_SCREAM)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_JOB, get_role_name(), statistic_name, amount, client.player_data)

/////////////////////////////////////////////////////////////////////////////////////
//Xenomorph

/mob/living/carbon/xenomorph/track_death_calculations()
	. = ..()
	if(!. || !faction)
		return

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), STATISTICS_ROUNDS_PLAYED, 1, client.player_data)

/mob/living/carbon/xenomorph/count_statistic_stat(statistic_name, amount = 1, weapon)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, caste_type, statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_steps_walked(amount = 1, statistic_name = STATISTICS_STEPS_WALKED)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, caste_type, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_hit(weapon, amount = 1, statistic_name = STATISTICS_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_friendly_hit(weapon, amount = 1, statistic_name = STATISTICS_FF_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_shot(weapon, amount = 1, statistic_name = STATISTICS_SHOT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_shot_hit(weapon, mob/shot_mob, amount = 1, statistic_name = STATISTICS_SHOT_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_damage(weapon, mob/damaged_mob, amount = 1, statistic_name = STATISTICS_DAMAGE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_friendly_damage(weapon, mob/damaged_mob, amount = 1, statistic_name = STATISTICS_FF_DAMAGE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_heal_damage(weapon, mob/healed_mob, amount = 1, statistic_name = STATISTICS_HEALED_DAMAGE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_friendly_fire(weapon, amount = 1, statistic_name = STATISTICS_FF_SHOT_HIT)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)
	if(weapon)
		track_statistic_earned(faction, STATISTIC_TYPE_WEAPON, weapon, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_revive(amount = 1, statistic_name = STATISTICS_REVIVED)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_life_saved(amount = 1, statistic_name = STATISTICS_REVIVE)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_scream(amount = 1, statistic_name = STATISTICS_SCREAM)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, get_role_name(), statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_slashes(caste, amount = 1, statistic_name = STATISTICS_SLASH)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, caste, statistic_name, amount, client.player_data)

/mob/living/carbon/xenomorph/track_ability_usage(ability, caste, amount = 1)
	. = ..()
	if(!.)
		return FALSE

	track_statistic_earned(faction, STATISTIC_TYPE_CASTE_ABILITIES, caste, ability, amount, client.player_data)
	track_statistic_earned(faction, STATISTIC_TYPE_CASTE, caste, STATISTICS_ABILITES, amount, client.player_data)
