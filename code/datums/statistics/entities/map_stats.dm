/datum/entity/map_stats
	var/name = null // "Taiho Labs"
	var/datum/entity/round_stats/linked_round = null // reference to current round entity
	var/list/datum/entity/death_stats/death_stats_list = list() // list of types /datum/entity/death_stats
	var/list/victories = list() // list of type /datum/entity/statistic, "xeno_minor" = 10, "marine_major" = 2
	var/total_rounds = 1 // 152
