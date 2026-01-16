//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	// Metadata
	var/config_filename = "maps/LV624.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1

	// Config actually from the JSON - default values
	var/map_name = "LV624"
	var/map_path = "map_files/LV624"
	var/map_file = "LV624.dmm"

	var/webmap_url
	var/short_name

	var/traits = null
	var/space_empty_levels = 1
	var/list/environment_traits = list()
	var/list/gamemodes = list()

	var/camouflage_type = "classic"

	var/allow_custom_shuttles = TRUE
	var/shuttles = list()

	var/announce_text = ""
	var/infection_announce_text = ""
	var/liaison_briefing = ""

	var/squads_max_num = 4

	var/weather_holder

	var/list/survivor_types
	var/list/survivor_types_by_variant

	var/list/synth_survivor_types
	var/list/synth_survivor_types_by_variant

	var/list/CO_survivor_types
	var/list/CO_survivor_types_by_variant

	var/list/CO_insert_survivor_types
	var/list/CO_insert_survivor_types_by_variant

	var/list/defcon_triggers = list(5150, 4225, 2800, 1000, 0.0)

	var/survivor_message = "You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks... until now."

	var/map_item_type

	var/force_mode

	var/perf_mode

	var/disable_ship_map = FALSE

	var/list/monkey_types = list(/mob/living/carbon/human/monkey)

	var/list/xvx_hives = list(XENO_HIVE_ALPHA = 0, XENO_HIVE_BRAVO = 0)

	var/vote_cycle = 1

	var/nightmare_path

	/// If truthy this is config for a round overridden map: search for override maps in data/, instead of using a path in maps/
	var/override_map

/datum/map_config/New()
	survivor_types = list(
		/datum/equipment_preset/survivor/scientist,
		/datum/equipment_preset/survivor/doctor,
		/datum/equipment_preset/survivor/chef,
		/datum/equipment_preset/survivor/chaplain,
		/datum/equipment_preset/survivor/miner,
		/datum/equipment_preset/survivor/colonial_marshal,
		/datum/equipment_preset/survivor/engineer,
	)

	synth_survivor_types = list(
		/datum/equipment_preset/synth/survivor/doctor_synth,
		/datum/equipment_preset/synth/survivor/surgeon_synth,
		/datum/equipment_preset/synth/survivor/emt_synth_teal,
		/datum/equipment_preset/synth/survivor/emt_synth_red,
		/datum/equipment_preset/synth/survivor/scientist_synth,
		/datum/equipment_preset/synth/survivor/biohazard_synth,
		/datum/equipment_preset/synth/survivor/archaeologist_synth,
		/datum/equipment_preset/synth/survivor/engineer_synth,
		/datum/equipment_preset/synth/survivor/firefighter_synth,
		/datum/equipment_preset/synth/survivor/miner_synth,
		/datum/equipment_preset/synth/survivor/chef_synth,
		/datum/equipment_preset/synth/survivor/teacher_synth,
		/datum/equipment_preset/synth/survivor/surveyor_synth,
		/datum/equipment_preset/synth/survivor/freelancer_synth,
		/datum/equipment_preset/synth/survivor/trucker_synth,
		/datum/equipment_preset/synth/survivor/bartender_synth,
		/datum/equipment_preset/synth/survivor/fisher_synth,
		/datum/equipment_preset/synth/survivor/hydro_synth,
		/datum/equipment_preset/synth/survivor/journalist_synth,
		/datum/equipment_preset/synth/survivor/atc_synth,
		/datum/equipment_preset/synth/survivor/cmb_synth,
		/datum/equipment_preset/synth/survivor/wy/security_synth,
		/datum/equipment_preset/synth/survivor/wy/corporate_synth,
		/datum/equipment_preset/synth/survivor/detective_synth,
		/datum/equipment_preset/synth/survivor/icc_synth,
		/datum/equipment_preset/synth/survivor/pilot_synth,
		/datum/equipment_preset/synth/survivor/radiation_synth,
	)

/proc/load_map_config(filename, default, delete_after, error_if_missing = TRUE)
	var/datum/map_config/config = new
	if(default)
		return config
	if(!config.LoadConfig(filename, error_if_missing))
		qdel(config)
		config = new /datum/map_config
	if(delete_after)
		fdel(filename)
	return config


/proc/load_map_configs(list/maptypes, default, delete_after, error_if_missing = TRUE)
	var/list/configs = list()

	for(var/i in maptypes)
		var/filename
		if(CONFIG_GET(flag/ephemeral_map_mode) && i == GROUND_MAP)
			filename = CONFIG_GET(string/ephemeral_ground_map)
		else
			filename = MAP_TO_FILENAME[i]
		var/datum/map_config/config = new
		if(default)
			configs[i] = config
			continue
		if(!config.LoadConfig(filename, error_if_missing, i))
			qdel(config)
			config = new /datum/map_config
		if(delete_after)
			fdel(filename)
		configs[i] = config
	return configs

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }
/datum/map_config/proc/LoadConfig(filename, error_if_missing, maptype)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	config_filename = filename

	override_map = json["override_map"]

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]

	webmap_url = json["webmap_url"]
	short_name = json["short_name"]

	map_file = json["map_file"]

	var/dirpath = "maps/"
	if(override_map)
		dirpath = "data/"
		map_path = "/"
		map_file = OVERRIDE_MAPS_TO_FILENAME[maptype]
	else
		CHECK_EXISTS("map_path")
		map_path = json["map_path"]
		dirpath = "[dirpath]/[map_path]"

	// "map_file": "BoxStation.dmm"
	if (istext(map_file))
		if (!fexists("[dirpath]/[map_file]"))
			log_world("Map file ([map_file]) does not exist!")
			return
	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("[dirpath]/[file]"))
				log_world("Map file ([file]) does not exist!")
				return
	else
		log_world("map_file missing from json!")
		return

	if (islist(json["shuttles"]))
		var/list/L = json["shuttles"]
		for(var/key in L)
			var/value = L[key]
			shuttles[key] = value
	else if ("shuttles" in json)
		log_world("map_config shuttles is not a list!")
		return

	if (islist(json["survivor_types"]))
		survivor_types = json["survivor_types"]
	else if ("survivor_types" in json)
		log_world("map_config survivor_types is not a list!")
		return

	var/list/pathed_survivor_types = list()
	for(var/surv_type in survivor_types)
		var/survivor_typepath = surv_type
		if(!ispath(survivor_typepath))
			survivor_typepath = text2path(surv_type)
			if(!ispath(survivor_typepath))
				log_world("[surv_type] isn't a proper typepath, removing from survivor_types list")
				continue
		pathed_survivor_types += survivor_typepath
	survivor_types = pathed_survivor_types.Copy()

	survivor_types_by_variant = list()
	for(var/surv_type in survivor_types)
		var/datum/equipment_preset/survivor/surv_equipment = surv_type
		var/survivor_variant = initial(surv_equipment.survivor_variant)
		if(!survivor_types_by_variant[survivor_variant])
			survivor_types_by_variant[survivor_variant] = list()
		survivor_types_by_variant[survivor_variant] += surv_type

	if(islist(json["synth_survivor_types"]))
		synth_survivor_types = json["synth_survivor_types"]
	else if ("synth_survivor_types" in json)
		log_world("map_config synth_survivor_types is not a list!")
		return

	var/list/pathed_synth_survivor_types = list()
	for(var/synth_surv_type in synth_survivor_types)
		var/synth_survivor_typepath = synth_surv_type
		if(!ispath(synth_survivor_typepath))
			synth_survivor_typepath = text2path(synth_surv_type)
			if(!ispath(synth_survivor_typepath))
				log_world("[synth_surv_type] isn't a proper typepath, removing from synth_survivor_types list")
				continue
		pathed_synth_survivor_types += synth_survivor_typepath
	synth_survivor_types = pathed_synth_survivor_types.Copy()

	synth_survivor_types_by_variant = list()
	for(var/surv_type in synth_survivor_types)
		var/datum/equipment_preset/synth/survivor/surv_equipment = surv_type
		var/survivor_variant = initial(surv_equipment.survivor_variant)
		if(!synth_survivor_types_by_variant[survivor_variant])
			synth_survivor_types_by_variant[survivor_variant] = list()
		synth_survivor_types_by_variant[survivor_variant] += surv_type

	if(islist(json["CO_survivor_types"]))
		CO_survivor_types = json["CO_survivor_types"]
	else if ("CO_survivor_types" in json)
		log_world("map_config CO_survivor_types is not a list!")
		return

	var/list/pathed_CO_survivor_types = list()
	for(var/CO_surv_type in CO_survivor_types)
		var/CO_survivor_typepath = CO_surv_type
		if(!ispath(CO_survivor_typepath))
			CO_survivor_typepath = text2path(CO_surv_type)
			if(!ispath(CO_survivor_typepath))
				log_world("[CO_surv_type] isn't a proper typepath, removing from CO_survivor_types list")
				continue
		pathed_CO_survivor_types += CO_survivor_typepath
	CO_survivor_types = pathed_CO_survivor_types.Copy()

	if(islist(json["CO_insert_survivor_types"]))
		CO_insert_survivor_types = json["CO_insert_survivor_types"]
	else if ("CO_insert_survivor_types" in json)
		log_world("map_config CO_insert_survivor_types is not a list!")
		return

	var/list/pathed_CO_insert_survivor_types = list()
	for(var/CO_insert_surv_type in CO_insert_survivor_types)
		var/CO_insert_survivor_typepath = CO_insert_surv_type
		if(!ispath(CO_insert_survivor_typepath))
			CO_insert_survivor_typepath = text2path(CO_insert_surv_type)
			if(!ispath(CO_insert_survivor_typepath))
				log_world("[CO_insert_surv_type] isn't a proper typepath, removing from CO_insert_survivor_types list")
				continue
		pathed_CO_insert_survivor_types += CO_insert_survivor_typepath
	CO_insert_survivor_types = pathed_CO_insert_survivor_types.Copy()

	if (islist(json["monkey_types"]))
		monkey_types = list()
		for(var/monkey in json["monkey_types"])
			switch(monkey)
				if("farwa")
					monkey_types += /mob/living/carbon/human/farwa
				if("monkey")
					monkey_types += /mob/living/carbon/human/monkey
				if("neaera")
					monkey_types += /mob/living/carbon/human/neaera
				if("stok")
					monkey_types += /mob/living/carbon/human/stok
				if("yiren")
					monkey_types += /mob/living/carbon/human/yiren
				else
					log_world("map_config monkey_types has invalid name!")
					return
	else if ("monkey_types" in json)
		log_world("map_config monkey_types is not a list!")
		return

	if (islist(json["xvx_hives"]))
		xvx_hives = json["xvx_hives"]
	else if ("xvx_hives" in json)
		log_world("map_config xvx_hives is not a list!")
		return

	if (islist(json["defcon_triggers"]))
		defcon_triggers = json["defcon_triggers"]
	else if ("defcon_triggers" in json)
		log_world("map_config defcon_triggers is not a list!")
		return

	traits = json["traits"]
	if(islist(traits))
		for(var/list/ztraits in traits) // Defaults to ground map if not specified
			if(!ztraits[ZTRAIT_GROUND] && !ztraits[ZTRAIT_MARINE_MAIN_SHIP])
				ztraits[ZTRAIT_GROUND] = TRUE
	else if(traits)
		log_world("map_config traits is not a list!")
		return

	var/temp = json["space_empty_levels"]
	if (isnum(temp))
		space_empty_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_empty_levels is not a number!")
		return

	temp = json["squads"]
	if(isnum(temp))
		squads_max_num = temp
	else if(!isnull(temp))
		log_world("map_config squads_max_num is not a number!")
		return

	allow_custom_shuttles = json["allow_custom_shuttles"] != FALSE

	if(json["camouflage"])
		camouflage_type = json["camouflage"]

	if(json["survivor_message"])
		survivor_message = json["survivor_message"]

	if(json["force_mode"])
		force_mode = json["force_mode"]

	if(json["disable_ship_map"])
		disable_ship_map = json["disable_ship_map"]

	if(json["perf_mode"])
		perf_mode = json["perf_mode"]

	if(json["vote_cycle"])
		vote_cycle = json["vote_cycle"]

	if(json["announce_text"])
		announce_text = json["announce_text"]

	if(json["infection_announce_text"])
		infection_announce_text = json["infection_announce_text"]

	if(json["liaison_briefing"])
		liaison_briefing = json["liaison_briefing"]

	if(json["weather_holder"])
		weather_holder = text2path(json["weather_holder"])
		if(!weather_holder)
			log_world("map_config weather_holder is not a proper typepath!")
			return

	if(json["map_item_type"])
		map_item_type = text2path(json["map_item_type"])
		if(!map_item_type)
			log_world("map_config map_item_type is not a proper typepath!")
			return

	if(json["nightmare_path"])
		nightmare_path = json["nightmare_path"]

	if(islist(json["environment_traits"]))
		environment_traits = json["environment_traits"]
	else if(!isnull(json["environment_traits"]))
		log_world("map_config environment_traits is not a list!")
		return

	var/list/gamemode_names = list()
	for(var/t in subtypesof(/datum/game_mode))
		var/datum/game_mode/G = t
		gamemode_names += initial(G.config_tag)

	if(islist(json["gamemodes"]))
		for(var/g in json["gamemodes"])
			if(!(g in gamemode_names))
				log_world("map_config has an invalid gamemode name!")
				return
			if(g == "Extended") // always allow extended
				continue
			gamemodes += g
		gamemodes += "Extended"
	else if(!isnull(json["gamemodes"]))
		log_world("map_config gamemodes is not a list!")
		return
	else
		for(var/a in subtypesof(/datum/game_mode))
			var/datum/game_mode/G = a
			gamemodes += initial(G.config_tag)

	defaulted = FALSE
	return TRUE
#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	var/dirpath = "maps/[map_path]"
	if(override_map)
		dirpath = "data/[map_path]"
	if (istext(map_file))
		return list("[dirpath]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "[dirpath]/[file]"


/datum/map_config/proc/MakeNextMap(maptype = GROUND_MAP)
	if(CONFIG_GET(flag/ephemeral_map_mode))
		message_admins("NOTICE: Running in ephemeral mode - map change request ignored")
		return TRUE
	if(maptype == GROUND_MAP)
		return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")
	else if(maptype == SHIP_MAP)
		return config_filename == "data/next_ship.json" || fcopy(config_filename, "data/next_ship.json")
