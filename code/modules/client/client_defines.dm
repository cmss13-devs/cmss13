/client
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/admin_holder = null //Datum for storing admin permissions and other admin stuff
	var/datum/buildmode/buildmode = null

	// Holds the client's current mentorhelp thread
	var/datum/mentorhelp/current_mhelp = null

	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.
	var/talked = 0
	var/chatWarn = 0

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/move_delay = 0
	var/next_movement = 0
	var/moving = null
	var/adminobs = null
	var/area = null
	var/time_died_as_mouse = null //when the client last died as a mouse

	var/donator = 0
	var/adminhelped = 0

	var/obj/screen/click_catcher/void

		///////////////
		//SOUND STUFF//
		///////////////
	var/played			= 0
	var/midi_silenced	= 0
	var/datum/soundOutput/soundOutput
	var/list/volume_preferences = list(1, 0.5, 1, 0.85)//Game, music, admin midis, lobby music

		////////////
		//SECURITY//
		////////////
	var/next_allowed_topic_time = 10
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	var/received_irc_pm = -99999
	var/irc_admin			//IRC admin that spoke with them last.
	var/mute_irc = 0


		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id

	//Statpanel stuff
	var/last_statpanel = null 	// The statpanel the client last registered
	var/stat_fast_update = 0	// Helps with forcing client to render statpanels in client/Stat()
	var/stat_force_fast_update = 0	// Helps with forcing client to render statpanels from outside of client/Stat()

	var/xeno_prefix = "XX"
	var/xeno_postfix = ""
	var/xeno_name_ban = FALSE

	var/datum/entity/player_entity/player_entity = null

	//Chat stuff
	var/datum/chatOutput/chatOutput

	//Asset cache
	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

	///world.time they connected
	var/connection_time

	preload_rsc = 0 // This is 0 so we can set it to an URL once the player logs in and have them download the resources from a different server.

	var/list/datum/coords/player/qtrees = list()
