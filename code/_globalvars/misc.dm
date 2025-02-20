GLOBAL_VAR_INIT(game_year, 2182)

GLOBAL_VAR_INIT(ooc_allowed, TRUE)
GLOBAL_VAR_INIT(looc_allowed, TRUE)
GLOBAL_VAR_INIT(dsay_allowed, TRUE)
GLOBAL_VAR_INIT(dooc_allowed, TRUE)
GLOBAL_VAR_INIT(dlooc_allowed, FALSE)

GLOBAL_VAR_INIT(enter_allowed, TRUE)

GLOBAL_LIST_EMPTY(admin_log)
GLOBAL_LIST_EMPTY(asset_log)

// multiplier for watts per tick <> cell storage (eg: 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
//It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
#define CELLRATE 0.006

// Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
#define CHARGELEVEL 0.001

GLOBAL_VAR(VehicleElevatorConsole)
GLOBAL_VAR(VehicleGearConsole)

//Spawnpoints.
GLOBAL_LIST_EMPTY(fallen_list)
/// This is for dogtags placed on crosses- they will show up at the end-round memorial.
GLOBAL_LIST_EMPTY(fallen_list_cross)

GLOBAL_LIST_INIT(diagonals, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(reverse_dir, list(2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63))



GLOBAL_VAR(join_motd)
GLOBAL_VAR(current_tms)

GLOBAL_LIST_INIT(AAlarmWireColorToFlag, RandomAAlarmWires())
GLOBAL_LIST(AAlarmIndexToFlag)
GLOBAL_LIST(AAlarmIndexToWireColor)
GLOBAL_LIST(AAlarmWireColorToIndex)

/// 3 minutes in the station.
#define shuttle_time_in_station 3 MINUTES
/// 10 minutes to arrive.
#define shuttle_time_to_arrive 10 MINUTES

	// For FTP requests. (i.e. downloading runtime logs.)
	// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
GLOBAL_LIST_EMPTY(tagger_locations)

//added for Xenoarchaeology, might be useful for other stuff
GLOBAL_LIST_INIT(alphabet_uppercase, list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"))
GLOBAL_LIST_INIT(alphabet_lowercase, list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))

GLOBAL_LIST_INIT(greek_letters, list("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omnicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"))
GLOBAL_LIST_INIT(nato_phonetic_alphabet, list("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-Ray", "Yankee", "Zulu"))

//Used for autocall procs on ERT
GLOBAL_VAR_INIT(distress_cancel, FALSE)
GLOBAL_VAR_INIT(destroy_cancel, FALSE)

// Last global ID that was assigned to a mob (for round recording purposes)
GLOBAL_VAR_INIT(last_mob_gid, 0)

GLOBAL_LIST_INIT(almayer_ship_sections, list(
	"Upper deck Foreship",
	"Upper deck Midship",
	"Upper deck Aftship",
	"Lower deck Foreship",
	"Lower deck Midship",
	"Lower deck Aftship"
))


GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)

/// Global performance feature toggle flags
GLOBAL_VAR_INIT(perf_flags, NO_FLAGS)

GLOBAL_LIST_INIT(bitflags, list((1<<0), (1<<1), (1<<2), (1<<3), (1<<4), (1<<5), (1<<6), (1<<7), (1<<8), (1<<9), (1<<10), (1<<11), (1<<12), (1<<13), (1<<14), (1<<15), (1<<16), (1<<17), (1<<18), (1<<19), (1<<20), (1<<21), (1<<22), (1<<23)))

GLOBAL_VAR_INIT(master_mode, "Distress Signal")

GLOBAL_VAR_INIT(timezoneOffset, 0)

GLOBAL_LIST_INIT(pill_icon_mappings, map_pill_icons())

/// In-round override to default OOC color
GLOBAL_VAR(ooc_color_override)

// tacmap cooldown for xenos and marines
GLOBAL_VAR_INIT(uscm_canvas_cooldown, 0)
GLOBAL_VAR_INIT(xeno_canvas_cooldown, 0)

// getFlatIcon cooldown for xenos and marines
GLOBAL_VAR_INIT(uscm_flatten_map_icon_cooldown, 0)
GLOBAL_VAR_INIT(xeno_flatten_map_icon_cooldown, 0)

// latest unannounced flat tacmap for xenos and marines
GLOBAL_VAR(uscm_unannounced_map)
GLOBAL_VAR(xeno_unannounced_map)

//global tacmaps for action button access
GLOBAL_DATUM_INIT(uscm_tacmap_status, /datum/tacmap/drawing/status_tab_view, new)
GLOBAL_DATUM_INIT(xeno_tacmap_status, /datum/tacmap/drawing/status_tab_view/xeno, new)

/// List of roles that can be setup for each gamemode
GLOBAL_LIST_EMPTY(gamemode_roles)

GLOBAL_VAR_INIT(minimum_exterior_lighting_alpha, 255)

GLOBAL_DATUM_INIT(item_to_box_mapping, /datum/item_to_box_mapping, init_item_to_box_mapping())

/// Offset for the Operation time
GLOBAL_VAR_INIT(time_offset, setup_offset())

/// Sets the offset 2 lines above.
/proc/setup_offset()
	return rand(10 MINUTES, 24 HOURS)

/// The last count of possible candidates in the xeno larva queue (updated via get_alien_candidates)
GLOBAL_VAR(xeno_queue_candidate_count)

//Coordinate obsfucator
//Used by the rangefinders and linked systems to prevent coords collection/prefiring
/// A number between -500 and 500.
GLOBAL_VAR(obfs_x)
/// A number between -500 and 500.
GLOBAL_VAR(obfs_y)
/// A number between -10 and 10
GLOBAL_VAR(obfs_z)

/// The current amount of giant lizards that are alive.
GLOBAL_VAR_INIT(giant_lizards_alive, 0)
