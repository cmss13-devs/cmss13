/*
Basics, the most important.
*/
/datum/config_entry/string/servername // The name used for the server almost universally.

/datum/config_entry/string/serversqlname // Short form of the previous used for the DB.

/datum/config_entry/string/server // If you set this location, it sends you there instead of trying to reconnect.

/datum/config_entry/string/title //The title of the main window

/datum/config_entry/string/hostedby // Sets the hosted by name on unix platforms.

/datum/config_entry/string/resource_url

/datum/config_entry/string/new_round_alert_channel

/datum/config_entry/string/new_round_alert_role_id

/datum/config_entry/flag/hub // if the game appears on the hub or not

/datum/config_entry/string/wikiurl

/datum/config_entry/string/wikiarticleurl

/datum/config_entry/string/forumurl

/datum/config_entry/string/staffreport

/datum/config_entry/string/playerreport

/datum/config_entry/string/rulesurl

/datum/config_entry/string/githuburl

/datum/config_entry/string/discordurl

/datum/config_entry/string/banappeals

/datum/config_entry/string/endofroundblurb

/datum/config_entry/string/dburl

/// Server to notify of game events
/datum/config_entry/string/manager_url

/// URL for the CentCom Galactic Ban DB API
/datum/config_entry/string/centcom_ban_db

/// Host of the webmap
/datum/config_entry/string/webmap_host
	config_entry_value = "https://affectedarc07.github.io/SS13WebMap/CMSS13/"

/datum/config_entry/string/python_path

/datum/config_entry/string/restart_message

/datum/config_entry/flag/guest_ban

/*
Administrative related.
*/
/datum/config_entry/flag/no_localhost_rank
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/admin_legacy_system //Defines whether the server uses the legacy admin system with admins.txt or the SQL system
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/protect_legacy_admins //Stops any admins loaded by the legacy system from having their rank edited by the permissions panel
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/protect_legacy_ranks //Stops any ranks loaded by the legacy system from having their flags edited by the permissions panel
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/load_legacy_ranks_only //Loads admin ranks only from legacy admin_ranks.txt, while enabled ranks are mirrored to the database
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/log_adminchat
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/log_adminwarn
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/log_hrefs
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/debug_admin_hrefs

/datum/config_entry/flag/popup_admin_pm

/datum/config_entry/flag/log_debug

/datum/config_entry/flag/log_asset

/datum/config_entry/flag/log_ooc

/datum/config_entry/flag/log_looc

/datum/config_entry/flag/log_access

/datum/config_entry/flag/log_say

/datum/config_entry/flag/log_telecomms

/datum/config_entry/flag/log_hivemind

/datum/config_entry/flag/log_runtime

/datum/config_entry/flag/log_prayer

/datum/config_entry/flag/log_game

/datum/config_entry/flag/log_overwatch

/datum/config_entry/flag/log_interact

/datum/config_entry/flag/log_idmod

/datum/config_entry/flag/log_vote

/datum/config_entry/flag/log_whisper

/datum/config_entry/flag/log_attack

/datum/config_entry/flag/log_emote

/datum/config_entry/flag/log_world_topic

/datum/config_entry/flag/log_manifest

/datum/config_entry/flag/allow_admin_ooccolor // Allows admins to customize their OOC color.

/datum/config_entry/flag/allow_vote_adjustment_callback

/// logs all timers in buckets on automatic bucket reset (Useful for timer debugging)
/datum/config_entry/flag/log_timers_on_bucket_reset

/datum/config_entry/number/vote_adjustment_callback
	config_entry_value = 0.1

/datum/config_entry/string/ooc_color_normal
	config_entry_value = "#1c52f5"

/datum/config_entry/string/ooc_color_other
	config_entry_value = "#2e78d9"

/datum/config_entry/string/ooc_color_mods
	config_entry_value = "#ffbf00"

/datum/config_entry/string/ooc_color_debug
	config_entry_value = "#6bd1b4"

/datum/config_entry/string/ooc_color_admin
	config_entry_value = "#ff8000"

/datum/config_entry/string/ooc_color_default
	config_entry_value = "#b82e00"

/datum/config_entry/flag/usewhitelist

/datum/config_entry/flag/usealienwhitelist

/datum/config_entry/flag/use_age_restriction_for_jobs //Do jobs use account age restrictions? --requires database

/datum/config_entry/flag/use_exp_tracking

/datum/config_entry/flag/use_exp_restrictions_admin_bypass

/datum/config_entry/flag/use_exp_restrictions_command

/datum/config_entry/number/use_exp_restrictions_command_hours
	config_entry_value = 0
	integer = FALSE
	min_val = 0

/datum/config_entry/flag/use_exp_restrictions_command_department

/datum/config_entry/flag/use_exp_restrictions_other

/datum/config_entry/flag/prevent_dupe_names

/datum/config_entry/flag/kick_inactive //force disconnect for inactive players

/datum/config_entry/flag/automute_on //enables automuting/spam prevention

/datum/config_entry/flag/autooocmute

/datum/config_entry/flag/mentor_tools // Extra tooling for mentors that might otherwise be staff only
	config_entry_value = FALSE

/datum/config_entry/flag/show_mentors
	config_entry_value = TRUE

/datum/config_entry/flag/show_mods
	config_entry_value = TRUE

/datum/config_entry/flag/show_devs
	config_entry_value = TRUE

/datum/config_entry/flag/show_manager
	config_entry_value = TRUE

/datum/config_entry/flag/looc_enabled

/datum/config_entry/number/lobby_countdown
	config_entry_value = 180

/datum/config_entry/number/round_end_countdown
	config_entry_value = 120

/datum/config_entry/flag/see_own_notes

/datum/config_entry/number/note_fresh_days
	config_entry_value = 30
	min_val = 0
	integer = FALSE

/datum/config_entry/number/note_stale_days
	config_entry_value = 180
	min_val = 0
	integer = FALSE

/datum/config_entry/flag/use_account_age_for_jobs

/datum/config_entry/number/notify_new_player_age
	min_val = -1

/datum/config_entry/flag/allow_shutdown
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/tgs3_commandline_path
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN
	config_entry_value = "C:\\Program Files (x86)\\TG Station Server\\TGCommandLine.exe"

/datum/config_entry/number/minute_topic_limit
	config_entry_value = 250
	min_val = 0

/datum/config_entry/number/second_topic_limit
	config_entry_value = 15
	min_val = 0

/datum/config_entry/number/minute_click_limit
	config_entry_value = 400
	min_val = 0

/datum/config_entry/number/second_click_limit
	config_entry_value = 15
	min_val = 0

/datum/config_entry/number/afk_period //time in ds until a player is considered inactive
	config_entry_value = 3000
	integer = FALSE
	min_val = 0

/datum/config_entry/number/glide_size_mod
	config_entry_value = 80
/*
Voting
*/
/datum/config_entry/flag/allow_vote_restart

/datum/config_entry/flag/allow_vote_mode

/datum/config_entry/flag/default_no_vote

/datum/config_entry/flag/no_dead_vote

// Gamemode to auto-switch to at the start of the round
/datum/config_entry/string/gamemode_default
	config_entry_value = "Extended"

/datum/config_entry/number/rounds_until_hard_restart
	config_entry_value = -1 // -1 is disabled by default, 0 is every round, x is after so many rounds

/datum/config_entry/number/vote_delay // Minimum time between voting sessions. (deciseconds, 10 minute default)
	config_entry_value = 6000
	integer = FALSE
	min_val = 0

/datum/config_entry/number/vote_period  // length of voting period (deciseconds, default 1 minute)
	config_entry_value = 600
	integer = FALSE
	min_val = 0

/*
Master controller and performance related.
*/
/datum/config_entry/number/mc_tick_rate/base_mc_tick_rate
	integer = FALSE
	config_entry_value = 1

/datum/config_entry/number/mc_tick_rate/high_pop_mc_tick_rate
	integer = FALSE
	config_entry_value = 1.1

/datum/config_entry/number/mc_tick_rate/high_pop_mc_mode_amount
	config_entry_value = 65

/datum/config_entry/number/mc_tick_rate/disable_high_pop_mc_mode_amount
	config_entry_value = 60

/datum/config_entry/number/mc_tick_rate
	abstract_type = /datum/config_entry/number/mc_tick_rate

/datum/config_entry/number/mc_tick_rate/ValidateAndSet(str_val)
	. = ..()
	if(.)
		Master.UpdateTickRate()

/datum/config_entry/number/fps
	config_entry_value = 20
	integer = FALSE
	min_val = 1
	max_val = 100   //byond will start crapping out at 50, so this is just ridic
	var/sync_validate = FALSE

/datum/config_entry/number/fps/ValidateAndSet(str_val)
	. = ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/ticklag/TL = config.entries_by_type[/datum/config_entry/number/ticklag]
		if(!TL.sync_validate)
			TL.ValidateAndSet("[10 / config_entry_value]")
		sync_validate = FALSE

/datum/config_entry/number/ticklag
	config_entry_value = 0.9
	integer = FALSE
	var/sync_validate = FALSE

/datum/config_entry/number/ticklag/New() //ticklag weirdly just mirrors fps
	var/datum/config_entry/CE = /datum/config_entry/number/fps
	config_entry_value = 10 / initial(CE.config_entry_value)
	return ..()

/datum/config_entry/number/ticklag/ValidateAndSet(str_val)
	. = text2num(str_val) > 0 && ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/fps/FPS = config.entries_by_type[/datum/config_entry/number/fps]
		if(!FPS.sync_validate)
			FPS.ValidateAndSet("[10 / config_entry_value]")
		sync_validate = FALSE

/datum/config_entry/number/tick_limit_mc_init //SSinitialization throttling
	config_entry_value = TICK_LIMIT_MC_INIT_DEFAULT
	min_val = 0 //oranges warned us
	integer = FALSE

/datum/config_entry/flag/resume_after_initializations

/datum/config_entry/flag/resume_after_initializations/ValidateAndSet(str_val)
	. = ..()
	if(. && Master.current_runlevel)
		world.sleep_offline = !config_entry_value

/*
System command that invokes youtube-dl, used by Play Internet Sound.
You can install youtube-dl with
"pip install youtube-dl" if you have pip installed
from https://github.com/rg3/youtube-dl/releases
or your package manager
The default value assumes youtube-dl is in your system PATH
*/
/datum/config_entry/string/invoke_youtubedl
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/string/cobalt_base_api
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN


/datum/config_entry/string/cobalt_api_key
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/number/error_cooldown // The "cooldown" time for each occurrence of a unique error
	config_entry_value = 600
	integer = FALSE
	min_val = 0


/datum/config_entry/number/error_limit // How many occurrences before the next will silence them
	config_entry_value = 50


/datum/config_entry/number/error_silence_time // How long a unique error will be silenced for
	config_entry_value = 6000
	integer = FALSE


/datum/config_entry/number/error_msg_delay // How long to wait between messaging admins about occurrences of a unique error
	config_entry_value = 50
	integer = FALSE


/datum/config_entry/number/soft_popcap
	min_val = 0


/datum/config_entry/number/hard_popcap
	min_val = 0


/datum/config_entry/number/extreme_popcap
	min_val = 0


/datum/config_entry/string/soft_popcap_message
	config_entry_value = "The server is currently serving a high number of users, joining the round may get disabled soon."


/datum/config_entry/string/hard_popcap_message
	config_entry_value = "The server is currently serving a high number of users, You cannot currently join, but you can observe or wait for the number of living crew to decline."


/datum/config_entry/string/extreme_popcap_message
	config_entry_value = "The server is currently serving a high number of users, joining the server has been disabled."


/datum/config_entry/flag/byond_member_bypass_popcap


/datum/config_entry/flag/panic_bunker


/datum/config_entry/string/panic_server_name


/datum/config_entry/string/panic_server_name/ValidateAndSet(str_val)
	return str_val != "\[Put the name here\]" && ..()


/datum/config_entry/string/panic_server_address //Reconnect a player this linked server if this server isn't accepting new players


/datum/config_entry/string/panic_server_address/ValidateAndSet(str_val)
	return str_val != "byond://address:port" && ..()


/datum/config_entry/string/panic_bunker_message
	config_entry_value = "Sorry but the server is currently not accepting connections from never before seen players."


/datum/config_entry/string/default_view
	config_entry_value = "15x15"

/datum/config_entry/string/default_view_square
	config_entry_value = "15x15"

/*
This maintains a list of ip addresses that are able to bypass topic filtering.
*/
/datum/config_entry/keyed_list/topic_filtering_whitelist
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/ff_damage_threshold
	min_val = 0
	config_entry_value = 250

/datum/config_entry/number/ff_damage_reset
	min_val = 0
	config_entry_value = 30 SECONDS

/datum/config_entry/flag/ghost_interaction

/datum/config_entry/flag/allow_drone_spawn

/datum/config_entry/number/drone_build_time

/datum/config_entry/number/max_maint_drones

/datum/config_entry/flag/duplicate_notes_to_file

/datum/config_entry/number/limit_players

/datum/config_entry/flag/allow_Metadata

/datum/config_entry/flag/guest_jobban

/datum/config_entry/number/vote_autogamemode_timeleft

/datum/config_entry/flag/vote_no_default

/datum/config_entry/flag/vote_no_dead

/datum/config_entry/number/STUI_length
	config_entry_value = 150

/datum/config_entry/flag/use_timelocks

/datum/config_entry/flag/debugparanoid

/datum/config_entry/flag/respawn

/datum/config_entry/flag/ooc_country_flags

/datum/config_entry/flag/record_rounds

/datum/config_entry/str_list/lobby_art_images

/datum/config_entry/str_list/lobby_art_authors

/// Force map bypassing configuration, and ignore map changes
/datum/config_entry/flag/ephemeral_map_mode
	config_entry_value = FALSE

/// Map configuration file to use in ephemeral mode
/datum/config_entry/string/ephemeral_ground_map
	config_entry_value = "maps/testing.json"

/datum/config_entry/number/urgent_ahelp_cooldown
	default = 300

/datum/config_entry/string/urgent_ahelp_message
	default = "This ahelp is urgent!"

/datum/config_entry/string/ahelp_message
	default = ""

/datum/config_entry/string/urgent_ahelp_user_prompt
	default = "There are no admins currently on. Do not press the button below if your ahelp is a joke, a request or a question. Use it only for cases of obvious grief."

/datum/config_entry/string/urgent_adminhelp_webhook_url

/datum/config_entry/string/regular_adminhelp_webhook_url

/datum/config_entry/string/profiler_webhook_url

/datum/config_entry/string/adminhelp_webhook_pfp

/datum/config_entry/string/adminhelp_webhook_name

/datum/config_entry/string/adminhelp_ahelp_link

/datum/config_entry/string/round_results_webhook_url

/datum/config_entry/string/important_log_channel

/// InfluxDB v2 Host to connect to for sending statistics (over HTTP API)
/datum/config_entry/string/influxdb_host
/// InfluxDB v2 Bucket to send staistics to
/datum/config_entry/string/influxdb_bucket
/// InfluxDB v2 Organization to access buckets of
/datum/config_entry/string/influxdb_org
/// InfluxDB v2 API Token to access the organization and bucket
/datum/config_entry/string/influxdb_token

/// How often to snapshot general game statistics to influxdb driver
/datum/config_entry/number/influxdb_stats_period
	config_entry_value = 30
/// How often to snapshot MC statistics
/datum/config_entry/number/influxdb_mcstats_period
	config_entry_value = 60
/// How often to send queued influxdb statistics
/datum/config_entry/number/influxdb_send_period
	config_entry_value = 10

/// logs all timers in buckets on automatic bucket reset (Useful for timer debugging)
/datum/config_entry/flag/log_timers_on_bucket_reset

/datum/config_entry/number/hard_deletes_overrun_threshold
	integer = FALSE
	min_val = 0
	default = 0.5

/datum/config_entry/number/hard_deletes_overrun_limit
	default = 0
	min_val = 0

/datum/config_entry/string/bot_prefix
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/bot_command
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/certification_minutes
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/topic_max_size
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/log_world_topic
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/keyed_list/topic_tokens
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_TEXT
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/keyed_list/topic_tokens/ValidateListEntry(key_name, key_value)
	return key_value != "topic_token" && ..()


//Fail2Topic settings.
/datum/config_entry/number/topic_rate_limit
	config_entry_value = 5
	min_val = 1
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/number/topic_max_fails
	config_entry_value = 5
	min_val = 1
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/string/topic_rule_name
	config_entry_value = "_DD_Fail2topic"
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/number/topic_max_size
	config_entry_value = 500
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/topic_enabled
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/redis_enabled
	config_entry_value = FALSE
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/redis_logging
	config_entry_value = FALSE
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/string/redis_connection
	config_entry_value = "redis://127.0.0.1/"
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/string/instance_name
	config_entry_value = "game"
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/guest_ban

/datum/config_entry/flag/auto_profile

/// Relay Ping Browser configuration
/datum/config_entry/keyed_list/connection_relay_ping
	splitter = "|"
	key_mode = KEY_MODE_TEXT_UNALTERED
	value_mode = VALUE_MODE_TEXT

/datum/config_entry/keyed_list/connection_relay_con
	splitter = "|"
	key_mode = KEY_MODE_TEXT_UNALTERED
	value_mode = VALUE_MODE_TEXT

/datum/config_entry/number/client_warn_version
	default = null
	min_val = 500

/datum/config_entry/number/client_warn_build
	default = null
	min_val = 0

/datum/config_entry/string/client_warn_message
	default = "Your version of BYOND may have issues or be blocked from accessing this server in the future."

/datum/config_entry/flag/client_warn_popup

/datum/config_entry/number/client_error_version
	default = null
	min_val = 500

/datum/config_entry/number/client_error_build
	default = null
	min_val = 0

/datum/config_entry/string/client_error_message
	default = "Your version of BYOND is too old, may have issues, and is blocked from accessing this server."

// GitHub API, used for anonymous bug report handling.
/datum/config_entry/string/github_app_api
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/string/repo_name

/datum/config_entry/string/org
