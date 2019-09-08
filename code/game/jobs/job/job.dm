/datum/job

	//The name of the job
	var/title = ""				 //The internal title for the job, used for the job ban system and so forth. Don't change these, change the disp_title instead.
	var/special_role 			 //In case they have some special role on spawn.
	var/disp_title				 //Determined on new(). Usually the same as the title, but doesn't have to be. Set this to override what the player sees in the game as their title.

	var/faction 			= "Marine" //Players will be allowed to spawn in as jobs that are set to "Marine". Other factions are special game mode spawns.
	var/total_positions 	= 0 //How many players can be this job
	var/spawn_positions 	= 0 //How many players can spawn in as this job
	var/allow_additional	= 0 //Can admins modify positions to it
	var/scaled = 0
	var/current_positions 	= 0 //How many players have this job
	var/supervisors 		= "" //Supervisors, who this person answers to directly. Should be a string, shown to the player when they enter the game.
	var/selection_color 	= "#ffffff" //Sellection screen color.
	var/list/alt_titles 	//List of alternate titles, if any.
	//If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age 	= 0
	//var/flags_role				= NOFLAGS
	var/flag = NOFLAGS //TODO robust this later.
	//var/flags_department 			= NOFLAGS
	var/department_flag = NOFLAGS //TODO robust this later.
	var/flags_startup_parameters 	= NOFLAGS //These flags are used to determine how to load the role, and some other parameters.
	var/flags_whitelist 			= NOFLAGS //Only used by whitelisted roles. Can be a single whitelist flag, or a combination of them.

	var/gear_preset //Gear preset name used for this job
	var/gear_preset_council //Gear preset name used for council snowflakes ;)

	New()
		..()
		if(!disp_title) disp_title = title


/datum/job/proc/get_access()
	if(!gear_preset)
		return null
	if(gear_presets_list[gear_preset])
		return gear_presets_list[gear_preset].access
	return null

/datum/job/proc/get_skills()
	if(!gear_preset)
		return null
	if(gear_presets_list[gear_preset])
		return gear_presets_list[gear_preset].skills
	return null

/datum/job/proc/get_paygrade()
	if(!gear_preset)
		return ""
	if(gear_presets_list[gear_preset])
		return gear_presets_list[gear_preset].paygrade
	return ""

/datum/job/proc/get_comm_title()
	if(!gear_preset)
		return ""
	if(gear_presets_list[gear_preset])
		return gear_presets_list[gear_preset].role_comm_title
	return ""

/datum/job/proc/get_alternative_title(mob/living/M, lowercase)
	if(istype(M) && M.client && M.client.prefs)
		. = M.client.prefs.GetPlayerAltTitle(src)
		if(. && lowercase) . = lowertext(.)

/datum/job/proc/set_spawn_positions(var/count) return spawn_positions

/datum/job/proc/generate_entry_message() return //The job description that characters get, along with anything else that may be appropriate.

/datum/job/proc/announce_entry_message(mob/living/carbon/human/H, datum/money_account/M) //The actual message that is displayed to the mob when they enter the game as a new player.
	set waitfor = 0
	sleep(10)
	if(H && H.loc && H.client)
		var/title_given
		var/title_alt
		title_alt = get_alternative_title(H,1)
		title_given = title_alt ? title_alt : lowertext(disp_title)

		//Document syntax cannot have tabs for proper formatting.
		var/t = {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are \a [title_given]![flags_startup_parameters & ROLE_ADMIN_NOTIFY? "\nYou are playing a job that is important for game progression. If you have to disconnect, please notify the admins via adminhelp." : ""]</span>
<span class='role_body'>[generate_entry_message(H)]
As the [title_given] you answer to [supervisors]. Special circumstances may change this.[M ? "\nYour account number is: <b>[M.account_number]</b>. Your account pin is: <b>[M.remote_access_pin]</b>." : ""]</span>
<span class='role_body'>|______________________|</span>
		"}
		to_chat(H, t)

/datum/job/proc/generate_entry_conditions(mob/living/M) return //Anything special that should happen to the mob upon entering the world.

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0) return 1	//If available in 0 days, the player is old enough to play. Can be compared to null, but I think this is clearer.

/datum/job/proc/available_in_days(client/C)
	//Checking the player's age is only possible through a db connection, so if there isn't one, player age will be a text string instead.
	if(!istype(C) || !config.use_age_restriction_for_jobs || !isnum(C.player_age) || !isnum(minimal_player_age)) return 0 //One of the few times when returning 0 is the proper behavior.
	return max(0, minimal_player_age - C.player_age)

//This lets you scale max jobs at runtime
//All you have to do is rewrite the inheritance
/datum/job/proc/get_total_positions(var/latejoin)
	return latejoin ? spawn_positions : total_positions
