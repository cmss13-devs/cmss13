#define PREFFILE_VERSION_MIN	3
#define PREFFILE_VERSION_MAX	3

/datum/entity/statistic
	var/name = null
	var/value = null

/datum/entity/player_entity
	var/name
	var/ckey // "cakey"
	var/list/datum/entity/player_stats = list()
	var/list/datum/entity/death_stats = list()
	var/menu = 0
	var/subMenu = 0
	var/dataMenu = 0
	var/data[0]
	var/path
	var/savefile_version
	var/save_loaded = FALSE

/datum/entity/player_entity/proc/get_playtime(var/branch, var/type)
	var/playtime = 0
	if(player_stats["[branch]"])
		var/datum/entity/player_stats/branch_stat = player_stats["[branch]"]
		playtime += branch_stat.get_playtime(type)
	return playtime

/datum/entity/player_entity/proc/setup_human_stats()
	if(player_stats["human"])
		return player_stats["human"]
	var/datum/entity/player_stats/human/new_stat = new()
	new_stat.player = src
	player_stats["human"] = new_stat
	return new_stat

/datum/entity/player_entity/proc/setup_xeno_stats()
	if(player_stats["xeno"])
		return player_stats["xeno"]
	var/datum/entity/player_stats/xeno/new_stat = new()
	new_stat.player = src
	player_stats["xeno"] = new_stat
	return new_stat
