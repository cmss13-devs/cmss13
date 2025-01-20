SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	runlevels = ALL

	var/list/datum/map_config/configs
	var/list/datum/map_config/next_map_configs

	///Name of all maps
	var/list/map_templates = list()
	///Name of all shuttles
	var/list/shuttle_templates = list()
	var/list/all_shuttle_templates = list()
	///map_id of all tents
	var/list/tent_type_templates = list()

	var/list/areas_in_z = list()

	var/list/turf/unused_turfs = list() //Not actually unused turfs they're unused but reserved for use for whatever requests them. "[zlevel_of_turf]" = list(turfs)
	var/list/datum/turf_reservations //list of turf reservations
	var/list/used_turfs = list() //list of turf = datum/turf_reservation
	/// List of lists of turfs to reserve
	var/list/lists_to_reserve = list()

	var/list/reservation_ready = list()
	var/clearing_reserved_turfs = FALSE

	// Z-manager stuff
	var/ground_start  // should only be used for maploading-related tasks
	///list of all z level datums in the order of their z (z level 1 is at index 1, etc.)
	var/list/datum/space_level/z_list
	var/datum/space_level/transit
	var/num_of_res_levels = 1

	/// True when in the process of adding a new Z-level, global locking
	var/adding_new_zlevel = FALSE
	/// list of traits and their associated z leves
	var/list/z_trait_levels = list()

	/// list of lazy templates that have been loaded
	var/list/loaded_lazy_templates

//dlete dis once #39770 is resolved
/datum/controller/subsystem/mapping/proc/HACK_LoadMapConfig()
	if(!configs)
		configs = load_map_configs(ALL_MAPTYPES, error_if_missing = FALSE)
		world.name = "[CONFIG_GET(string/title)] - [SSmapping.configs[SHIP_MAP].map_name]"

/datum/controller/subsystem/mapping/Initialize(timeofday)
	HACK_LoadMapConfig()
	if(initialized)
		return SS_INIT_SUCCESS

	for(var/i in ALL_MAPTYPES)
		var/datum/map_config/MC = configs[i]
		if(MC.defaulted)
			var/old_config = configs[i]
			configs[i] = global.config.defaultmaps[i]
			if(!configs || configs[i].defaulted)
				to_chat(world, SPAN_BOLDANNOUNCE("Unable to load next or default map config, defaulting."))
				configs[i] = old_config

	loadWorld()
	repopulate_sorted_areas()
	preloadTemplates()
	// Add the first transit level
	var/datum/space_level/base_transit = add_reservation_zlevel()
	initialize_reserved_level(base_transit.z_value)
	repopulate_sorted_areas()

	if(configs[GROUND_MAP])
		send2chat(new /datum/tgs_message_content("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Round restarted! Map is [configs[GROUND_MAP].map_name]"), CONFIG_GET(string/new_round_alert_channel))
	else
		send2chat(new /datum/tgs_message_content("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Round started!"), CONFIG_GET(string/new_round_alert_channel))

	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapping/fire(resumed)
	// Cache for sonic speed
	var/list/unused_turfs = src.unused_turfs
	// CM TODO: figure out if these 2 are needed. Might be required by updated versions of map reader
	//var/list/world_contents = GLOB.areas_by_type[world.area].contents
	//var/list/world_turf_contents = GLOB.areas_by_type[world.area].contained_turfs
	var/list/lists_to_reserve = src.lists_to_reserve
	var/index = 0
	while(index < length(lists_to_reserve))
		var/list/packet = lists_to_reserve[index + 1]
		var/packetlen = length(packet)
		while(packetlen)
			if(MC_TICK_CHECK)
				if(index)
					lists_to_reserve.Cut(1, index)
				return
			var/turf/T = packet[packetlen]
			T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE, null, TRUE)
			LAZYINITLIST(unused_turfs["[T.z]"])
			unused_turfs["[T.z]"] |= T
			//var/area/old_area = T.loc
			//old_area.turfs_to_uncontain += T
			T.turf_flags |= UNUSED_RESERVATION_TURF
			//world_contents += T
			//world_turf_contents += T
			packet.len--
			packetlen = length(packet)

		index++
	lists_to_reserve.Cut(1, index)

/datum/controller/subsystem/mapping/proc/wipe_reservations(wipe_safety_delay = 100)
	if(clearing_reserved_turfs || !initialized) //in either case this is just not needed.
		return
	clearing_reserved_turfs = TRUE
	message_admins("Clearing dynamic reservation space.")
	// /tg/ Shuttles have extra handling here to avoid them being desallocated
	do_wipe_turf_reservations()
	clearing_reserved_turfs = FALSE

/datum/controller/subsystem/mapping/proc/get_reservation_from_turf(turf/T)
	RETURN_TYPE(/datum/turf_reservation)
	return used_turfs[T]

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	initialized = SSmapping.initialized
	map_templates = SSmapping.map_templates

	shuttle_templates = SSmapping.shuttle_templates
	unused_turfs = SSmapping.unused_turfs
	turf_reservations = SSmapping.turf_reservations
	used_turfs = SSmapping.used_turfs
	areas_in_z = SSmapping.areas_in_z

	configs = SSmapping.configs
	next_map_configs = SSmapping.next_map_configs

	clearing_reserved_turfs = SSmapping.clearing_reserved_turfs

	z_list = SSmapping.z_list

#define INIT_ANNOUNCE(X) to_chat(world, "<span class='notice'>[X]</span>"); log_world(X)
/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, override_map_path = "maps/")
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "[override_map_path]/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits)
	else if (total_z != length(traits))  // mismatch
		INIT_ANNOUNCE("WARNING: [length(traits)] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < length(traits))  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > length(traits))  // fall back to defaults on extra levels
			traits += list(default_traits)

	// preload the relevant space_level datums
	var/start_z = world.maxz + 1
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level, contain_turfs = FALSE)
		++i

	// ================== CM Change ==================
	// For some reason /tg/ SSmapping attempts to center the map in new Z-Level
	// but because it's done before loading, it's calculated before performing
	// X/Y world expansion. When loading a map bigger than world, this results
	// in a negative offset and the start of the map to not be loaded.

	// load the maps
	for (var/datum/parsed_map/pm as anything in parsed_maps)
		var/bounds = pm.bounds
		var/x_offset = 1
		var/y_offset = 1
		if(bounds && world.maxx > bounds[MAP_MAXX])
			x_offset = floor(world.maxx / 2 - bounds[MAP_MAXX] / 2) + 1
		if(bounds && world.maxy > bounds[MAP_MAXY])
			y_offset = floor(world.maxy / 2 - bounds[MAP_MAXY] / 2) + 1
		if (!pm.load(x_offset, y_offset, start_z + parsed_maps[pm], no_changeturf = TRUE, new_z = TRUE))
			errorList |= pm.original_path
		// CM Snowflake for Mass Screenshot dimensions auto detection
		for(var/z in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
			var/datum/space_level/zlevel = z_list[start_z + z - 1]
			zlevel.bounds = list(bounds[MAP_MINX], bounds[MAP_MINY], z, bounds[MAP_MAXX], bounds[MAP_MAXY], z)

	// =============== END CM Change =================

	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")
	return parsed_maps

/datum/controller/subsystem/mapping/proc/Loadship(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, override_map_path = "maps/")
	LoadGroup(errorList, name, path, files, traits, default_traits, silent, override_map_path = override_map_path)

/datum/controller/subsystem/mapping/proc/Loadground(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, override_map_path = "maps/")
	LoadGroup(errorList, name, path, files, traits, default_traits, silent, override_map_path = override_map_path)

/datum/controller/subsystem/mapping/proc/loadWorld()
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()

	// ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

	// load the ground level
	ground_start = world.maxz + 1

	var/datum/map_config/ground_map = configs[GROUND_MAP]
	INIT_ANNOUNCE("Loading [ground_map.map_name]...")
	var/ground_base_path = "maps/"
	if(ground_map.override_map)
		ground_base_path = "data/"
	Loadground(FailedZs, ground_map.map_name, ground_map.map_path, ground_map.map_file, ground_map.traits, ZTRAITS_GROUND, override_map_path = ground_base_path)

	if(!ground_map.disable_ship_map)
		var/datum/map_config/ship_map = configs[SHIP_MAP]
		var/ship_base_path = "maps/"
		if(ship_map.override_map)
			ship_base_path = "data/"
		INIT_ANNOUNCE("Loading [ship_map.map_name]...")
		Loadship(FailedZs, ship_map.map_name, ship_map.map_path, ship_map.map_file, ship_map.traits, ZTRAITS_MAIN_SHIP, override_map_path = ship_base_path)

	if(LAZYLEN(FailedZs)) //but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(length(FailedZs) > 1)
			for(var/I in 2 to length(FailedZs))
				msg += ", [FailedZs[I]]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)
#undef INIT_ANNOUNCE

/datum/controller/subsystem/mapping/proc/changemap(datum/map_config/VM, maptype = GROUND_MAP)
	LAZYINITLIST(next_map_configs)
	if(maptype == GROUND_MAP)
		if(!VM.MakeNextMap(maptype))
			next_map_configs[GROUND_MAP] = load_map_configs(list(maptype), default = TRUE)
			message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
			return

		next_map_configs[GROUND_MAP] = VM
		return TRUE

	else if(maptype == SHIP_MAP)
		if(!VM.MakeNextMap(maptype))
			next_map_configs[SHIP_MAP] = load_map_configs(list(maptype), default = TRUE)
			message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
			return

		next_map_configs[SHIP_MAP] = VM
		return TRUE

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadShuttleTemplates()
	preload_tent_templates()

/proc/generateMapList(filename)
	. = list()
	var/list/Lines = file2list(filename)

	if(!length(Lines))
		return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (t[1] == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))

		else
			name = lowertext(t)

		if (!name)
			continue

		. += t

/datum/controller/subsystem/mapping/proc/preloadShuttleTemplates()
	for(var/item in subtypesof(/datum/map_template/shuttle))
		var/datum/map_template/shuttle/shuttle_type = item

		var/datum/map_template/shuttle/S = new shuttle_type()

		shuttle_templates[S.shuttle_id] = S
		all_shuttle_templates[item] = S
		map_templates[S.shuttle_id] = S

/datum/controller/subsystem/mapping/proc/preload_tent_templates()
	for(var/template in subtypesof(/datum/map_template/tent))
		var/datum/map_template/tent/new_tent = new template()
		tent_type_templates[new_tent.map_id] = new_tent

/// Adds a new reservation z level. A bit of space that can be handed out on request
/// Of note, reservations default to transit turfs, to make their most common use, shuttles, faster
/datum/controller/subsystem/mapping/proc/add_reservation_zlevel(for_shuttles)
	num_of_res_levels++
	return add_new_zlevel("Transit/Reserved #[num_of_res_levels]", list(ZTRAIT_RESERVED = TRUE))

/// Requests a /datum/turf_reservation based on the given width, height, and z_size. You can specify a z_reservation to use a specific z level, or leave it null to use any z level.
/datum/controller/subsystem/mapping/proc/request_turf_block_reservation(
	width,
	height,
	z_size = 1,
	z_reservation = null,
	reservation_type = /datum/turf_reservation,
	turf_type_override = null,
)
	UNTIL((!z_reservation || reservation_ready["[z_reservation]"]) && !clearing_reserved_turfs)
	var/datum/turf_reservation/reserve = new reservation_type
	if(!isnull(turf_type_override))
		reserve.turf_type = turf_type_override
	if(!z_reservation)
		for(var/i in levels_by_trait(ZTRAIT_RESERVED))
			if(reserve.reserve(width, height, z_size, i))
				return reserve
		//If we didn't return at this point, theres a good chance we ran out of room on the exisiting reserved z levels, so lets try a new one
		var/datum/space_level/newReserved = add_reservation_zlevel()
		initialize_reserved_level(newReserved.z_value)
		if(reserve.reserve(width, height, z_size, newReserved.z_value))
			return reserve
	else
		if(!level_trait(z_reservation, ZTRAIT_RESERVED))
			qdel(reserve)
			return
		else
			if(reserve.reserve(width, height, z_size, z_reservation))
				return reserve
	QDEL_NULL(reserve)

///Sets up a z level as reserved
///This is not for wiping reserved levels, use wipe_reservations() for that.
///If this is called after SSatom init, it will call Initialize on all turfs on the passed z, as its name promises
/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	UNTIL(!clearing_reserved_turfs) //regardless, lets add a check just in case.
	clearing_reserved_turfs = TRUE //This operation will likely clear any existing reservations, so lets make sure nothing tries to make one while we're doing it.
	if(!level_trait(z,ZTRAIT_RESERVED))
		clearing_reserved_turfs = FALSE
		CRASH("Invalid z level prepared for reservations.")
	var/block = block(SHUTTLE_TRANSIT_BORDER, SHUTTLE_TRANSIT_BORDER, z, world.maxx - SHUTTLE_TRANSIT_BORDER, world.maxy - SHUTTLE_TRANSIT_BORDER, z)
	for(var/turf/T as anything in block)
		// No need to empty() these, because they just got created and are already /turf/open/space/basic.
		T.turf_flags |= UNUSED_RESERVATION_TURF
		CHECK_TICK

	// Gotta create these suckers if we've not done so already
	if(SSatoms.initialized)
		SSatoms.InitializeAtoms(Z_TURFS(z))

	unused_turfs["[z]"] = block
	reservation_ready["[z]"] = TRUE
	clearing_reserved_turfs = FALSE

/// Schedules a group of turfs to be handed back to the reservation system's control
/// If await is true, will sleep until the turfs are finished work
/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turfs, await = FALSE)
	lists_to_reserve += list(turfs)
	if(await)
		UNTIL(!length(turfs))

//DO NOT CALL THIS PROC DIRECTLY, CALL wipe_reservations().
/datum/controller/subsystem/mapping/proc/do_wipe_turf_reservations()
	PRIVATE_PROC(TRUE)
	UNTIL(initialized) //This proc is for AFTER init, before init turf reservations won't even exist and using this will likely break things.
	for(var/i in turf_reservations)
		var/datum/turf_reservation/TR = i
		if(!QDELETED(TR))
			qdel(TR, TRUE)
	UNSETEMPTY(turf_reservations)
	var/list/clearing = list()
	for(var/l in unused_turfs) //unused_turfs is an assoc list by z = list(turfs)
		if(islist(unused_turfs[l]))
			clearing |= unused_turfs[l]
	clearing |= used_turfs //used turfs is an associative list, BUT, reserve_turfs() can still handle it. If the code above works properly, this won't even be needed as the turfs would be freed already.
	unused_turfs.Cut()
	used_turfs.Cut()
	reserve_turfs(clearing, await = TRUE)

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()

/// Takes a z level datum, and tells the mapping subsystem to manage it
/// Also handles things like plane offset generation, and other things that happen on a z level to z level basis
/datum/controller/subsystem/mapping/proc/manage_z_level(datum/space_level/new_z, filled_with_space, contain_turfs = TRUE)
	// First, add the z
	z_list += new_z
	// Then we build our lookup lists
	//var/z_value = new_z.z_value
	//TODO: All the Z-plane init stuff goes below here normally, we don't have that yet

/// Gets a name for the marine ship as per the enabled ship map configuration
/datum/controller/subsystem/mapping/proc/get_main_ship_name()
	if(!configs)
		return MAIN_SHIP_DEFAULT_NAME
	var/datum/map_config/MC = configs[SHIP_MAP]
	if(!MC)
		return MAIN_SHIP_DEFAULT_NAME
	return MC.map_name

/datum/controller/subsystem/mapping/proc/lazy_load_template(datum/lazy_template/template_to_load, force = FALSE)
	RETURN_TYPE(/datum/turf_reservation)

	UNTIL(initialized)
	var/static/lazy_loading = FALSE
	UNTIL(!lazy_loading)

	lazy_loading = TRUE
	. = _lazy_load_template(template_to_load, force)
	lazy_loading = FALSE
	return .

/datum/controller/subsystem/mapping/proc/_lazy_load_template(datum/lazy_template/template_to_load, force = FALSE)
	PRIVATE_PROC(TRUE)

	if(LAZYACCESS(loaded_lazy_templates, template_to_load) && !force)
		var/datum/lazy_template/template = GLOB.lazy_templates[template_to_load]
		return template.reservations[1]
	LAZYSET(loaded_lazy_templates, template_to_load, TRUE)

	var/datum/lazy_template/target = GLOB.lazy_templates[template_to_load]
	if(!target)
		CRASH("Attempted to lazy load a template key that does not exist: '[template_to_load]'")
	return target.lazy_load()
