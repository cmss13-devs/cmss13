/datum/entity/player_stats/caste
	var/name = null
	var/total_hits = 0
	var/list/abilities_used = list() // types of /datum/entity/statistic, "tail sweep" = 10, "screech" = 2

/datum/entity/player_stats/caste/proc/setup_ability(ability)
	if(!ability)
		return
	var/ability_key = strip_improper(ability)
	if(abilities_used["[ability_key]"])
		return abilities_used["[ability_key]"]
	var/datum/entity/statistic/stat = new()
	stat.name = ability_key
	stat.value = 0
	abilities_used["[ability_key]"] = stat
	return stat

/datum/entity/player_stats/caste/proc/track_personal_abilities_used(ability, amount = 1)
	var/datum/entity/statistic/stat = setup_ability(ability)
	stat.value += amount
