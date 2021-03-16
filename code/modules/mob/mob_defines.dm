/mob
	density = 1
	layer = MOB_LAYER
	animate_movement = 2
	rebounds = TRUE
	var/mob_flags = NO_FLAGS
	var/datum/mind/mind

	// An ID that uniquely identifies this mob through the full round
	var/gid = 0

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	var/chatWarn = 0 //Tracks how many times someone has spammed and gives them a no-no timer
	var/talked = 0 //Won't let someone say something again in under a second.

	var/obj/screen/hands = null //robot

	var/adminhelp_marked = 0 // Prevents marking an Adminhelp more than once. Making this a client define will cause runtimes and break some Adminhelps
	var/adminhelp_marked_admin = "" // Ckey of last marking admin

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/obj/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/zone_selected = "chest"

	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/damageoverlaytemp = 0
	var/computer_id = null //to track the players
	var/lastattacker = null
	var/lastattacked = null
	var/attack_log = list( )
	var/atom/movable/interactee //the thing that the mob is currently interacting with (e.g. a computer, another mob (stripping a mob), manning a hmg)
	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon
	var/atom/movable/pulling = null
	var/next_move = null
	var/next_move_slowdown = 0	// Amount added during the next movement_delay(), then is reset.
	var/speed = 0 //Speed that modifies the movement delay of a given mob
	var/recalculate_move_delay = TRUE // Whether move delay needs to be recalculated, on by default so that new mobs actually get movement delay calculated upon creation
	var/monkeyizing = null	//Carbon
	var/hand = null
	var/eye_blind = null	//Carbon
	var/eye_blurry = null	//Carbon
	var/ear_deaf = null		//Carbon
	var/ear_damage = null	//Carbon
	var/stuttering = null	//Carbon
	var/slurring = null		//Carbon
	var/real_name = null
	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/blinded = null
	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/paralyzed = 0		//Carbon
	var/lying = FALSE
	var/lying_prev = 0
	var/canmove = 1
	var/lastpuke = 0
	unacidable = FALSE
	var/mob_size = MOB_SIZE_HUMAN
	var/list/embedded = list()          // Embedded items, since simple mobs don't have organs.
	var/list/languages = list()         // For speaking/listening.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes

	var/name_archive //For admin things like possession

	var/luminosity_total = 0 //For max luminosity stuff.

	var/statistic_exempt = FALSE
	var/statistic_tracked = FALSE //So we don't repeat log the same data on death/ghost/cryo
	var/life_time_start = 0
	var/life_time_total = 0
	var/timeofdeath = 0.0//Living
	var/life_steps_total = 0
	var/life_kills_total = 0

	var/bodytemperature = 310.055	//98.7 F
	var/old_x = 0
	var/old_y = 0
	var/drowsyness = 0.0//Carbon
	var/dizziness = 0//Carbon
	var/is_dizzy = 0
	var/is_jittery = 0
	var/jitteriness = 0//Carbon
	var/is_floating = 0
	var/floatiness = 0
	var/charges = 0.0
	var/nutrition = NUTRITION_NORMAL//Carbon

	var/overeatduration = 0		// How long this guy is overeating //Carbon
	var/knocked_out = 0.0
	var/stunned = 0.0
	var/frozen = 0.0
	var/knocked_down = 0.0
	var/losebreath = 0.0//Carbon
	var/dazed = 0.0
	var/slowed = 0.0 // X_SLOW_AMOUNT
	var/superslowed = 0.0 // X_SUPERSLOW_AMOUNT
	var/shakecamera = 0
	var/recovery_constant = 1
	var/a_intent = INTENT_HELP//Living
	var/lastKnownIP = null
	var/obj/buckled = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/back = null//Human/Monkey
	var/obj/item/tank/internal = null//Human/Monkey
	var/obj/item/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon

	var/able_to_speak = TRUE

	var/datum/hud/hud_used = null

	var/grab_level = GRAB_PASSIVE //if we're pulling a mob, tells us how aggressive our grab is.

	var/list/mapobjs = list()

	var/throw_mode = THROW_MODE_OFF

	var/coughedtime = null

	var/inertia_dir = 0

	var/voice_name = "unidentifiable voice"

	var/job = null					// Internal job title used when mob is spawned. Preds are "Predator", Xenos are "Xenomorph", Marines have their actual job title
	var/comm_title = ""
	var/faction = FACTION_NEUTRAL //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/faction_group

	var/datum/skills/skills = null //the knowledge you have about certain abilities and actions (e.g. do you how to do surgery?)
									//see skills.dm in #define folder and code/datums/skills.dm for more info
	var/obj/item/legcuffs/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.

	var/list/viruses = list() //List of active diseases

//Monkey/infected mode
	var/list/resistances = list()

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/status_flags = CANSTUN|CANKNOCKDOWN|CANKNOCKOUT|CANPUSH|CANDAZE|CANSLOW	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null

	var/list/radar_blips = list() // list of screen objects, radar blips
	var/radar_open = 0 	// nonzero is radar is open


	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_understand = 0 // Set to 1 to enable the mob to understand everyone, not necessarily speak

	var/immune_to_ssd = 0

	var/list/tile_contents = list()  //the contents of the turf being examined in the stat panel
	var/tile_contents_change = 0

	var/STUI_log = 1

	var/away_timer = 0 //How long the player has been disconnected

	var/recently_pointed_to = 0 //used as cooldown for the pointing verb.

	var/list/image/hud_list //This mob's HUD (med/sec, etc) images. Associative list.

	var/list/hud_possible //HUD images that this mob can provide.

	var/action_busy //whether the mob is currently doing an action that takes time (do_after proc)
	var/resisting // whether the mob is currently resisting (primarily for do_after proc)
	var/clicked_something 	// a list of booleans for if a mob did a specific click
							// only left click, shift click, right click, and middle click

	var/last_damage_source // for tracking whatever damaged us last, mainly for stat tracking
	var/last_damage_mob // for tracking last hits on mob death, for kill stat tracking and moderation

	var/ambience_playing = FALSE

	var/noclip = FALSE

	var/next_delay_update = 0 // when next update of move delay should happen
	var/next_delay_delay = 10 // how much time we wait for next calc of move delay
	var/move_delay

	var/list/datum/action/actions = list()

	can_block_movement = TRUE

	appearance_flags = TILE_BOUND
	var/mouse_icon = null

	var/datum/player_panel/mob_panel

	var/datum/focus

	///the current turf being examined in the stat panel
	var/turf/listed_turf = null

	var/list/list/item_verbs = list()

	var/max_implants = 2
	var/list/implants

	var/move_on_shuttle = TRUE // Can move on the shuttle.

	var/list/important_radio_channels = list()
