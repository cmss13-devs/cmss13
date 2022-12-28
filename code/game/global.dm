//////////////
GLOBAL_LIST_INIT(paper_tag_whitelist, list("center","p","div","span","h1","h2","h3","h4","h5","h6","hr","pre",	\
	"big","small","font","i","u","b","s","sub","sup","tt","br","hr","ol","ul","li","caption","col",	\
	"table","td","th","tr"))

///////////////

GLOBAL_VAR(diary)
GLOBAL_VAR(round_stats)
GLOBAL_VAR(round_scheduler_stats)
GLOBAL_VAR(mutator_logs)
GLOBAL_VAR(href_logfile)
GLOBAL_VAR_INIT(command_name, "Central Command")
GLOBAL_VAR_INIT(station_name, "[MAIN_SHIP_NAME]")
GLOBAL_VAR_INIT(game_version, "Colonial Marines")
GLOBAL_VAR_INIT(game_year, "2182")

GLOBAL_VAR_INIT(going, 1.0)
GLOBAL_VAR_INIT(secret_force_mode, "secret") // if this is anything but "secret", the secret rotation will forceably choose this mode

GLOBAL_VAR(host)
GLOBAL_VAR_INIT(ooc_allowed, TRUE)
GLOBAL_VAR_INIT(looc_allowed, TRUE)
GLOBAL_VAR_INIT(dsay_allowed, TRUE)
GLOBAL_VAR_INIT(dooc_allowed, TRUE)
GLOBAL_VAR_INIT(dlooc_allowed, FALSE)
GLOBAL_VAR_INIT(abandon_allowed, TRUE)
GLOBAL_VAR_INIT(enter_allowed, TRUE)
GLOBAL_VAR_INIT(shuttle_frozen, FALSE)
GLOBAL_VAR_INIT(shuttle_left, FALSE)
GLOBAL_VAR_INIT(midi_playing, FALSE)
GLOBAL_VAR_INIT(heard_midi, 0)
GLOBAL_VAR_INIT(total_silenced, 0)

GLOBAL_LIST_EMPTY(admin_log)
GLOBAL_LIST_EMPTY(asset_log)

GLOBAL_VAR(VehicleElevatorConsole)
GLOBAL_VAR(VehicleGearConsole)

//Spawnpoints.
GLOBAL_LIST_EMPTY(fallen_list)
GLOBAL_LIST_INIT(cardinal, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(diagonals, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(reverse_dir, list(2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63))

GLOBAL_LIST_EMPTY(combatlog)
GLOBAL_LIST_EMPTY(IClog)
GLOBAL_LIST_EMPTY(OOClog)
GLOBAL_LIST_EMPTY(adminlog)

GLOBAL_VAR_INIT(Debug, FALSE)	// global debug switch

GLOBAL_DATUM_INIT(mods, /datum/moduletypes, new)

GLOBAL_VAR(join_motd)
GLOBAL_VAR(current_tms)

// GLOB.nanomanager, the manager for Nano UIs
GLOBAL_DATUM_INIT(nanomanager, /datum/nanomanager, new)

GLOBAL_LIST_INIT(BorgWireColorToFlag, RandomBorgWires())
GLOBAL_LIST_EMPTY(BorgIndexToFlag)
GLOBAL_LIST_EMPTY(BorgIndexToWireColor)
GLOBAL_LIST_EMPTY(BorgWireColorToIndex)
GLOBAL_LIST_INIT(AAlarmWireColorToFlag, RandomAAlarmWires())
GLOBAL_LIST_EMPTY(AAlarmIndexToFlag)
GLOBAL_LIST_EMPTY(AAlarmIndexToWireColor)
GLOBAL_LIST_EMPTY(AAlarmWireColorToIndex)

	// MySQL configuration

GLOBAL_VAR_INIT(sqladdress, "localhost")
GLOBAL_VAR_INIT(sqlport, "3306")
GLOBAL_VAR_INIT(sqldb, "cmdb")
GLOBAL_VAR_INIT(sqllogin, "root")
GLOBAL_VAR_INIT(sqlpass, "")


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
GLOBAL_VAR_INIT(distress_cancel, 0)
GLOBAL_VAR_INIT(destroy_cancel, 0)

//Coordinate obsfucator
//Used by the rangefinders and linked systems to prevent coords collection/prefiring
GLOBAL_VAR_INIT(obfs_x, 0) //A number between -500 and 500
GLOBAL_VAR_INIT(obfs_y, 0) //A number between -500 and 500

// Which lobby art is on display
// This is updated by the lobby art turf when it initializes
GLOBAL_VAR_INIT(displayed_lobby_art, -1)

// Last global ID that was assigned to a mob (for round recording purposes)
GLOBAL_VAR_INIT(last_mob_gid, 0)

// be careful messing with this. the section names are hardcoded here, while defines are used everywhere else
// see the big commented block for an explanation
GLOBAL_LIST_INIT(almayer_ship_sections, list(
	"Upper deck Foreship",
	"Upper deck Midship",
	"Upper deck Aftship",
	"Lower deck Foreship",
	"Lower deck Midship",
	"Lower deck Aftship"

	/*
	why the fuck is the code below commented you may ask? its a much cleaner solution, isn't it? i agree, but look at this:

		Upper deck Aftship Lower deck Foreship Lower deck Midship Lower deck Aftship
		Upper deck Aftship Lower deck Foreship Lower deck Midship Lower deck Aftship
		Upper deck Aftship Lower deck Foreship Lower deck Midship Lower deck Aftship
		almayer_ship_sections almayer_ship_sections



	these are actual, real debug prints of the contents of the list if it is defined with the code below.
	i'm not fucking with you, dm really grabbed all the drugs it had on hand, stuffed it in the dishwasher,
	sniffed the fumes and licked every plate clean after.

	it even managed to get the VARIABLE NAME in the fucking list AS AN ELEMENT. THE VARIABLE NAME.

	this is by far the most cursed code i have ever written, someone needs to hire a fucking excorcist

	(UPPER_DECK + " " + FORESHIP),
	(UPPER_DECK + " " + MIDSHIP),
	(UPPER_DECK + " " + AFTSHIP),
	(LOWER_DECK + " " + FORESHIP),
	(LOWER_DECK + " " + MIDSHIP),
	(LOWER_DECK + " " + AFTSHIP)
	*/
))
