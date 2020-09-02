/datum/job
	//The name of the job
	var/title = ""				 //The internal title for the job, used for the job ban system and so forth. Don't change these, change the disp_title instead.
	var/disp_title				 //Determined on new(). Usually the same as the title, but doesn't have to be. Set this to override what the player sees in the game as their title.

	var/total_positions 	= 0 //How many players can be this job
	var/spawn_positions 	= 0 //How many players can spawn in as this job
	var/total_positions_in_round = 0 //How many slots were open in this round. Used to prevent slots locking with decreasing amount of alive players
	var/allow_additional	= 0 //Can admins modify positions to it
	var/scaled = 0
	var/current_positions 	= 0 //How many players have this job
	var/supervisors 		= "" //Supervisors, who this person answers to directly. Should be a string, shown to the player when they enter the game.
	var/selection_class 	= "" // Job Selection span class (for background color)

	var/flag = NO_FLAGS 					//TODO robust this later.
	var/department_flag = NO_FLAGS 			//TODO robust this later.
	var/flags_startup_parameters = NO_FLAGS //These flags are used to determine how to load the role, and some other parameters.
	var/flags_whitelist = NO_FLAGS 			//Only used by whitelisted roles. Can be a single whitelist flag, or a combination of them.

	//If you have use_timelocks config option enabled, this option will add a requirement for players to have the prerequisite roles have at least x minimum playtime before unlocking.
	var/list/minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_3
	)

	var/gear_preset //Gear preset name used for this job
	var/list/gear_preset_whitelist = list()//Gear preset name used for council snowflakes ;)

	//For generating entry messages
	var/entry_message_intro
	var/entry_message_body
	var/entry_message_end

/datum/job/New()
	..()

	if(!disp_title) disp_title = title

/datum/job/proc/get_whitelist_status(var/list/roles_whitelist, var/client/player)
	if(!roles_whitelist)
		return FALSE

	return WHITELIST_NORMAL

/datum/job/proc/can_play_role(var/client/client)
	if(!config.use_timelocks)
		return TRUE
	var/datum/entity/player_entity/selected_entity = client.player_entity
	if(!minimum_playtimes.len || (client.admin_holder && (client.admin_holder.rights & R_ADMIN)) || selected_entity.get_playtime(STATISTIC_HUMAN, title) > 0)
		return TRUE
	for(var/prereq in minimum_playtimes)
		if(selected_entity.get_playtime(STATISTIC_HUMAN, prereq) < minimum_playtimes[prereq])
			return FALSE
	return TRUE

/datum/job/proc/get_role_requirements(var/datum/entity/player_entity/selected_entity)
	var/list/return_requirements = list()
	for(var/prereq in minimum_playtimes)
		var/playtime = selected_entity.get_playtime(STATISTIC_HUMAN, prereq)
		if(playtime < minimum_playtimes[prereq])
			return_requirements[prereq] = minimum_playtimes[prereq] - playtime
	return return_requirements

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

/datum/job/proc/set_spawn_positions(var/count)
	return spawn_positions

/datum/job/proc/generate_entry_message()
	if(!entry_message_intro)
		entry_message_intro = "You are the [title]!."
	if(!entry_message_end)
		entry_message_end = "As the [title] you answer to [supervisors]. Special circumstances may change this!"
	return "[entry_message_intro]<br>[entry_message_body]<br>[entry_message_end]"

/datum/job/proc/announce_entry_message(mob/living/carbon/human/H, datum/money_account/M, var/whitelist_status) //The actual message that is displayed to the mob when they enter the game as a new player.
	set waitfor = 0
	sleep(10)
	if(H && H.loc && H.client)
		var/title_given
		title_given = lowertext(disp_title)

		//Document syntax cannot have tabs for proper formatting.
		var/t = {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are \a [title_given]![flags_startup_parameters & ROLE_ADMIN_NOTIFY? "\nYou are playing a job that is important for game progression. If you have to disconnect, please notify the admins via adminhelp." : ""]</span>
<span class='role_body'>[generate_entry_message(H)].[M ? "\nYour account number is: <b>[M.account_number]</b>. Your account pin is: <b>[M.remote_access_pin]</b>." : ""]</span>
<span class='role_body'>|______________________|</span>
		"}
		to_chat(H, t)

/datum/job/proc/generate_entry_conditions(mob/living/M, var/whitelist_status)
	return //Anything special that should happen to the mob upon entering the world.

//This lets you scale max jobs at runtime
//All you have to do is rewrite the inheritance
/datum/job/proc/get_total_positions(var/latejoin)
	return latejoin ? spawn_positions : total_positions
