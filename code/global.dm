//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define MAIN_SHIP_NAME SSmapping.get_main_ship_name()
#define MAIN_SHIP_DEFAULT_NAME "USS Almayer"
//=================================================
//Please don't edit these values without speaking to Errorage first	~Carn
//Admin Permissions
#define R_BUILDMODE		(1<<0)
#define R_ADMIN			(1<<1)
#define R_BAN			(1<<2)
#define R_SERVER		(1<<3)
#define R_DEBUG			(1<<4)
#define R_POSSESS		(1<<5)
#define R_PERMISSIONS	(1<<6)
#define R_STEALTH		(1<<7)
#define R_REJUVINATE	(1<<8)
#define R_COLOR			(1<<9)
#define R_VAREDIT		(1<<10)
#define R_SOUNDS		(1<<11)
#define R_SPAWN			(1<<12)
#define R_MOD			(1<<13)
#define R_MENTOR		(1<<14)
#define R_HOST			(1<<15)
#define R_PROFILER		(1<<16)
#define R_NOLOCK		(1<<17)

#define R_EVERYTHING	((1<<18)-1) //the sum of all other rank permissions
// 512.1430 increases maximum bit flags from 16 to 24, so the following flags should be available for future changes:
//=================================================

#define CLIENT_HAS_RIGHTS(cli, flags) ((cli?.admin_holder?.rights & flags) == flags)
#define CLIENT_IS_STAFF(cli) (cli?.admin_holder?.rights & (R_MOD|R_ADMIN))

#define AHOLD_IS_MOD(ahold) (ahold && (ahold.rights & R_MOD))
#define AHOLD_IS_ADMIN(ahold) (ahold && (ahold.rights & R_ADMIN))

		//items that ask to be called every cycle

//////////////
var/list/paper_tag_whitelist = list("center","p","div","span","h1","h2","h3","h4","h5","h6","hr","pre",	\
	"big","small","font","i","u","b","s","sub","sup","tt","br","hr","ol","ul","li","caption","col",	\
	"table","td","th","tr")

///////////////

var/diary = null
var/round_stats = null
var/round_scheduler_stats = null
var/mutator_logs = null
var/href_logfile = null
var/command_name = "Central Command"
var/station_name = "[MAIN_SHIP_NAME]"
var/game_version = "Colonial Marines"
var/game_year = "2182"

var/going = 1.0
var/master_mode = "Distress Signal"
var/secret_force_mode = "secret" // if this is anything but "secret", the secret rotation will forceably choose this mode

var/host = null
var/ooc_allowed = 1
var/looc_allowed = 1
var/dsay_allowed = 1
var/dooc_allowed = 1
var/dlooc_allowed = 0
var/abandon_allowed = 1
var/enter_allowed = 1
var/shuttle_frozen = 0
var/shuttle_left = 0
var/midi_playing = 0
var/heard_midi = 0
var/total_silenced = 0

var/list/admin_log = list()
var/list/asset_log = list()

var/CELLRATE = 0.006	// multiplier for watts per tick <> cell storage (eg: 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
						//It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
var/CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)

var/VehicleElevatorConsole
var/VehicleGearConsole

//Spawnpoints.
var/list/fallen_list = list()
var/list/cardinal = list(NORTH, SOUTH, EAST, WEST)
var/list/diagonals = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list(2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63)

var/list/combatlog = list()
var/list/IClog = list()
var/list/OOClog = list()
var/list/adminlog = list()

var/Debug = 0	// global debug switch

var/datum/moduletypes/mods = new()

var/join_motd = null

// nanomanager, the manager for Nano UIs
var/datum/nanomanager/nanomanager = new()

var/list/BorgWireColorToFlag = RandomBorgWires()
var/list/BorgIndexToFlag
var/list/BorgIndexToWireColor
var/list/BorgWireColorToIndex
var/list/AAlarmWireColorToFlag = RandomAAlarmWires()
var/list/AAlarmIndexToFlag
var/list/AAlarmIndexToWireColor
var/list/AAlarmWireColorToIndex

//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN 1024
#define MAX_EMOTE_LEN 256
#define MAX_PAPER_MESSAGE_LEN 3072
#define MAX_BOOK_MESSAGE_LEN 9216
#define MAX_NAME_LEN 26

#define shuttle_time_in_station 3 MINUTES // 3 minutes in the station
#define shuttle_time_to_arrive 10 MINUTES // 10 minutes to arrive

	// MySQL configuration

var/sqladdress = "localhost"
var/sqlport = "3306"
var/sqldb = "cmdb"
var/sqllogin = "root"
var/sqlpass = ""


	// For FTP requests. (i.e. downloading runtime logs.)
	// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
/var/list/tagger_locations = list()

//added for Xenoarchaeology, might be useful for other stuff
var/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
var/list/alphabet_lowercase = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")

var/list/greek_letters = list("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omnicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega")
var/list/nato_phonetic_alphabet = list("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-Ray", "Yankee", "Zulu")

//Used for autocall procs on ERT
var/distress_cancel = 0
var/destroy_cancel = 0

//Coordinate obsfucator
//Used by the rangefinders and linked systems to prevent coords collection/prefiring
var/global/obfs_x = 0 //A number between -500 and 500
var/global/obfs_y = 0 //A number between -500 and 500

// Which lobby art is on display
// This is updated by the lobby art turf when it initializes
var/displayed_lobby_art = -1

// Last global ID that was assigned to a mob (for round recording purposes)
var/last_mob_gid = 0

// be careful messing with this. the section names are hardcoded here, while defines are used everywhere else
// see the big commented block for an explanation
var/list/almayer_ship_sections = list(
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
)
