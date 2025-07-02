/mob/verb/view_round_stats()
	set name = "View My Stats"
	set category = "OOC"

	if(!client)
		return
	var/datum/round_stats/round_stats = new()
	round_stats.tgui_interact(src)

/mob/living/carbon/xenomorph/track_mob_death(datum/cause_data/cause_data, turf/death_loc)
	. = ..()
	if(cause_data?.ckey)
		var/datum/entity/player_entity/killer = GLOB.player_entities["[cause_data.ckey]"]
		var/datum/entity/player_stats/stats
		if(cause_data.role in ALL_XENO_CASTES)
			stats = killer.setup_xeno_stats()
		else
			stats = killer.setup_human_stats()
		stats.count_xeno_kill(caste, cause_data.cause_name, cause_data.role)
		stats.count_xeno_kill_feed(real_name)

/mob/living/carbon/human/track_mob_death(datum/cause_data/cause_data, turf/death_loc)
	. = ..()
	if(cause_data?.ckey)
		var/datum/entity/player_entity/killer = GLOB.player_entities["[cause_data.ckey]"]
		var/datum/entity/player_stats/stats
		if(cause_data.role in ALL_XENO_CASTES)
			stats = killer.setup_xeno_stats()
		else
			stats = killer.setup_human_stats()
		stats.count_human_kill(job, cause_data.cause_name, cause_data.role)
		stats.count_human_kill_feed(real_name)
