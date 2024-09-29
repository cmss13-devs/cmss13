/datum/entity/player_stats/caste
	var/name = null
	var/total_hits = 0
	var/list/abilities_used = list() // types of /datum/entity/statistic, "tail sweep" = 10, "screech" = 2

/datum/entity/player_stats/caste/Destroy(force)
	. = ..()
	QDEL_LIST_ASSOC_VAL(abilities_used)

/datum/entity/player_stats/caste/proc/setup_ability(ability)
	if(!ability)
		return
	var/ability_key = strip_improper(ability)
	if(abilities_used["[ability_key]"])
		return abilities_used["[ability_key]"]
	var/datum/entity/statistic/S = new()
	S.name = ability_key
	S.value = 0
	abilities_used["[ability_key]"] = S
	return S

/datum/entity/player_stats/caste/proc/track_personal_abilities_used(ability, amount = 1)
	var/datum/entity/statistic/S = setup_ability(ability)
	S.value += amount
