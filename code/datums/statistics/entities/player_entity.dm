#define PREFFILE_VERSION_MIN 3
#define PREFFILE_VERSION_MAX 3

/datum/entity/statistic
	var/name = null
	var/value = null

/datum/entity/player_entity
	var/name
	var/ckey // "cakey"
	var/list/player_stats = list() //! Indeed list of /datum/entity/player_stats
	var/list/death_stats = list() //! Indexed list of /datum/entity/statistic/death
	var/menu = 0
	var/subMenu = 0
	var/dataMenu = 0
	var/data[0]
	var/path
	var/savefile_version
	var/save_loaded = FALSE

/datum/entity/player_entity/Destroy(force)
	QDEL_LIST_ASSOC_VAL(player_stats)
	QDEL_LIST_ASSOC_VAL(death_stats)
	return ..()

/datum/entity/player_entity/proc/get_playtime(branch, type)
	var/playtime = 0
	if(player_stats["[branch]"])
		var/datum/entity/player_stats/branch_stat = player_stats["[branch]"]
		playtime += branch_stat.get_playtime(type)
	return playtime

/datum/entity/player_entity/proc/setup_human_stats()
	if(player_stats["human"] && !isnull(player_stats["human"]))
		return player_stats["human"]
	var/datum/entity/player_stats/human/new_stat = new()
	new_stat.player = src
	player_stats["human"] = new_stat
	return new_stat

/datum/entity/player_entity/proc/setup_xeno_stats()
	if(player_stats["xeno"] && !isnull(player_stats["xeno"]))
		return player_stats["xeno"]
	var/datum/entity/player_stats/xeno/new_stat = new()
	new_stat.player = src
	player_stats["xeno"] = new_stat
	return new_stat
