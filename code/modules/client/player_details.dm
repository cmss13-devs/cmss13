GLOBAL_LIST_EMPTY(player_details) // ckey -> /datum/player_details

/datum/player_details
	var/list/player_actions = list()
	var/list/logging = list()
	var/list/post_login_callbacks = list()
	var/list/post_logout_callbacks = list()
	var/list/played_names = list() //List of names this key played under this round
	var/byond_version = "Unknown"
	/// The descriminator for larva queue ordering: Generally set to timeofdeath except for facehuggers/admin z-level play
	var/larva_queue_time

/datum/player_details/New()
	larva_queue_time = world.time
	return ..()

/proc/log_played_names(ckey, ...)
	if(!ckey)
		return
	if(length(args) < 2)
		return
	var/list/names = args.Copy(2)
	var/datum/player_details/P = GLOB.player_details[ckey]
	if(!P)
		return
	for(var/name in names)
		if(name)
			P.played_names |= name
