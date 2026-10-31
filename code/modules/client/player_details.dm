GLOBAL_LIST_EMPTY(player_details) // ckey -> /datum/player_details

/datum/player_details
	var/list/player_actions = list()
	var/list/logging = list()
	var/list/post_login_callbacks = list()
	var/list/post_logout_callbacks = list()
	var/list/played_names = list() //List of names this key played under this round
	var/orientation_leaflet_opened = FALSE
	var/byond_version = "Unknown"
	/// The descriminator for larva pool ordering: Generally set to timeofdeath except for facehuggers/admin z-level play.
	/// Will be null if the player hasn't ever observed or died yet.
	var/larva_pool_time = null

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
