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
	/// Hash of nightmare parser types to config file paths
	var/list/nightmare

	var/traits = null
	var/space_empty_levels = 1
	var/list/environment_traits = list()
	var/armor_style = "default"
	var/list/gamemodes = list()

	var/allow_custom_shuttles = TRUE
	var/shuttles = list()

	var/announce_text = ""

	var/squads_max_num = 4

	var/weather_holder

	var/list/survivor_types = list(
		"Survivor - Scientist",
		"Survivor - Doctor",
		"Survivor - Chef",
		"Survivor - Chaplain",
		"Survivor - Miner",
		"Survivor - Colonial Marshall",
		"Survivor - Engineer"
	)

	var/list/defcon_triggers = list(5150, 4225, 2800, 1000, 0.0)

	var/survivor_message = "You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks... until now."

	var/map_item_type

	var/force_mode

	var/list/monkey_types = list(/mob/living/carbon/human/monkey)

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
		else filename = MAP_TO_FILENAME[i]
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

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]
	CHECK_EXISTS("map_path")
	map_path = json["map_path"]

	map_file = json["map_file"]
	// "map_file": "BoxStation.dmm"
	if (istext(map_file))
		if (!fexists("maps/[map_path]/[map_file]"))
			log_world("Map file ([map_file]) does not exist!")
			return
	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("maps/[map_path]/[file]"))
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

	if(json["armor"])
		armor_style = json["armor"]

	if(json["survivor_message"])
		survivor_message = json["survivor_message"]

	if(json["force_mode"])
		force_mode = json["force_mode"]

	if(json["announce_text"])
		announce_text = replacetext(json["announce_text"], "###SHIPNAME###", MAIN_SHIP_NAME)

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

	if(json["nightmare"])
		if(!islist(json["nightmare"]))
			log_world("map_config nightmare is not a list!")
			return			
		nightmare = json["nightmare"]

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
	if (istext(map_file))
		return list("maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "maps/[map_path]/[file]"


/datum/map_config/proc/MakeNextMap(maptype = GROUND_MAP)
	if(CONFIG_GET(flag/ephemeral_map_mode))
		message_staff("NOTICE: Running in ephemeral mode - map change request ignored")
		return TRUE
	if(maptype == GROUND_MAP)
		return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")
	else if(maptype == SHIP_MAP)
		return config_filename == "data/next_ship.json" || fcopy(config_filename, "data/next_ship.json")
