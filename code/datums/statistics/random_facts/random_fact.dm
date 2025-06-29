/// How many facts per faction (marine/xeno) to announce
#define MAX_FACTION_FACTS_TO_ANNOUNCE 5

/datum/random_fact
	/// The noun for this statistic in the announcement
	var/statistic_name = null
	/// The verb for this statistic in the announcement
	var/statistic_verb = null
	/// Whether this statistic can apply to humans
	var/check_human = TRUE
	/// Whether this statistic can apply to xenos
	var/check_xeno = TRUE
	/// The prob dead are checked for this statistic
	var/prob_check_dead = 50
	/// The min stat required to be noted
	var/min_required = 1

/datum/random_fact/New(check_human=TRUE, check_xeno=TRUE)
	. = ..()
	src.check_human = initial(src.check_human) && check_human
	src.check_xeno = initial(src.check_human) && check_xeno

/// Announces this random_fact to world if possible (returns TRUE if sent)
/datum/random_fact/proc/announce()
	var/message = generate_announcement_message()
	if(message)
		to_world(SPAN_CENTERBOLD(message))
		return TRUE
	return FALSE

/// Returns the /datum/entity/statistic/death for a random still connected player that has min_required for this stat
/datum/random_fact/proc/find_death_to_report()
	RETURN_TYPE(/datum/entity/statistic/death)

	if(!GLOB.round_statistics)
		return null
	if(!length(GLOB.round_statistics.death_stats_list))
		return null

	var/list/list_to_check = shuffle(GLOB.round_statistics.death_stats_list)
	for(var/datum/entity/statistic/death/death as anything in list_to_check)
		if(death.is_xeno)
			if(!check_xeno)
				continue
		else
			if(!check_human)
				continue
		var/datum/entity/player/player_record = DB_ENTITY(/datum/entity/player, death.player_id)
		if(!player_record)
			debug_log("/datum/entity/player lookup failed for '[death.player_id]' during [type]'s find_death_to_report")
			continue
		if(!(player_record.ckey in GLOB.directory))
			continue // Not connected anymore
		if(death_grab_stat(death) >= min_required)
			return death // Success

/// Returns the /mob/living/carbon for a random still connected player that has min_required for this stat
/datum/random_fact/proc/find_living_to_report()
	RETURN_TYPE(/mob/living/carbon)

	var/list/list_to_check = list()
	if(check_human)
		list_to_check += GLOB.alive_human_list
	if(check_xeno)
		list_to_check += GLOB.living_xeno_list
	list_to_check = shuffle(list_to_check)

	for(var/mob/living/carbon/checked_mob as anything in list_to_check)
		if(!(checked_mob.persistent_ckey in GLOB.directory))
			continue // We don't care about NPCs or people disconnected
		if(life_grab_stat(checked_mob) >= min_required)
			return checked_mob // Success

/// Attempts to get a statistic to report on and returns the string of the message otherwise null if no one met requirements
/datum/random_fact/proc/generate_announcement_message()
	if(!check_xeno && !check_human)
		return null

	var/datum/entity/statistic/death/death_to_report = null
	var/mob/mob_to_report = null

	var/dead_attempted = FALSE
	if(prob(prob_check_dead))
		dead_attempted = TRUE
		death_to_report = find_death_to_report()
	if(!death_to_report && prob_check_dead < 100)
		mob_to_report = find_living_to_report()
	if(!mob_to_report && prob_check_dead > 0 && !dead_attempted)
		death_to_report = find_death_to_report()

	if(!death_to_report && !mob_to_report)
		return null

	var/name = ""
	var/stat_gotten = 0
	var/additional_message = ""
	if(death_to_report)
		name = death_to_report.mob_name
		stat_gotten = death_grab_stat(death_to_report)
		additional_message = "before dying"
		if(death_to_report.cause_name)
			additional_message += " to <b>[death_to_report.cause_name]</b>"
		additional_message += ". Good work!"
	else
		name = mob_to_report.real_name
		stat_gotten = life_grab_stat(mob_to_report)
		additional_message = "and survived! Great work!"

	return "<b>[name]</b> [statistic_verb] <b>[stat_gotten] [statistic_name]</b> [additional_message]"

/// Override this to specify what value on a mob to get for this statistic
/datum/random_fact/proc/life_grab_stat(mob/fact_mob)
	return 0

/// Override this to specify what value on a death to get for this statistic
/datum/random_fact/proc/death_grab_stat(datum/entity/statistic/death/fact_death)
	return 0
