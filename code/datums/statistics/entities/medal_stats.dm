/datum/entity/medal_stats
	var/datum/entity/player = null
	var/medal_type = null
	var/recipient = null
	var/recipient_job = null
	var/citation = null

/datum/entity/medal_stats/New(var/new_player, var/new_medal_type, var/new_recipient, var/new_recipient_job, var/new_citation)
	..()
	medal_type = new_medal_type
	recipient = new_recipient
	recipient_job = new_recipient_job
	citation = new_citation

/datum/entity/player_entity/proc/track_medal_earned(var/new_medal_type, var/new_recipient, var/new_recipient_job, var/new_citation)
	if(!new_medal_type || !new_recipient || !new_recipient_job || !new_citation)
		return
	var/datum/entity/player_stats/human/human_stats = setup_human_stats()
	human_stats.count_niche_stat(STATISTICS_NICHE_MEDALS, 1, new_recipient_job)
	var/datum/entity/medal_stats/new_medal = new(src, new_medal_type, new_recipient, new_recipient_job, new_citation)
	human_stats.medal_list.Insert(1, new_medal)
