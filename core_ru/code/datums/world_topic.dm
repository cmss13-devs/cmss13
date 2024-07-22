/datum/world_topic/status/Run(list/input)
	. = ..()
	data = list()
	data["round_name"] = "Loading..."

	data["round_id"] = "Loading..."
	if(SSperf_logging.round?.id)
		data["round_id"] = SSperf_logging.round.id

	data["map_name"] = "Loading..."
	if(SSmapping.configs?[GROUND_MAP])
		data["map_name"] = SSmapping.configs[GROUND_MAP].map_name
	if(SSmapping.next_map_configs?[GROUND_MAP])
		data["next_map_name"] = SSmapping.next_map_configs[GROUND_MAP].map_name

	data["ship_map_name"] = "Loading..."
	if(SSmapping.configs?[SHIP_MAP])
		data["ship_map_name"] = SSmapping.configs[SHIP_MAP].map_name
	if(SSmapping.next_map_configs?[SHIP_MAP])
		data["next_ship_map_name"] = SSmapping.next_map_configs[SHIP_MAP].map_name

	data["players"] = length(GLOB.clients)

	data["mode"] = "Loading..."
	if(SSticker.mode)
		if(GLOB.round_statistics)
			data["round_name"] = GLOB.round_statistics.round_name
		if(SSticker.mode.round_finished)
			data["round_end_state"] = SSticker.mode.end_round_message()
		data["mode"] = SSticker.mode.name

	data["revision"] = GLOB.revdata.commit
	data["revision_date"] = GLOB.revdata.date

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	data["admins"] = length(presentmins) + length(afkmins) //equivalent to the info gotten from adminwho
	data["gamestate"] = SSticker.current_state

	data["round_duration"] = ROUND_TIME
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	data["mcpu"] = world.map_cpu
	data["cpu"] = world.cpu

	statuscode = 200
	response = "Status retrieved"
