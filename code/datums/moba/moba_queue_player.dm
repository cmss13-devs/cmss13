/datum/moba_queue_player
	var/datum/moba_player/player
	var/role
	var/datum/moba_caste/caste

/datum/moba_queue_player/New(datum/moba_player/player, role, datum/moba_caste/caste)
	. = ..()
	src.player = player
	src.role = role
	src.caste = caste

/datum/moba_queue_player/Destroy(force, ...)
	player = null
	caste = null
	return ..()
