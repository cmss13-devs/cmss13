/datum/job
	//The name of the job
	var/title = ""				 //The internal title for the job, used for the job ban system and so forth. Don't change these, change the disp_title instead.
	var/disp_title				 //Determined on new(). Usually the same as the title, but doesn't have to be. Set this to override what the player sees in the game as their title.
	var/role_ban_alternative	// If the roleban title needs to be an extra check, like Xenomorphs = Alien.

	var/total_positions 	= 0 //How many players can be this job
	var/spawn_positions 	= 0 //How many players can spawn in as this job
	var/total_positions_so_far = 0 //How many slots were open in this round. Used to prevent slots locking with decreasing amount of alive players
	var/allow_additional	= 0 //Can admins modify positions to it
	var/scaled = 0
	var/current_positions 	= 0 //How many players have this job
	var/fake_positions 		= 0 // Purely used for roundstart pop calculations
	var/supervisors 		= "" //Supervisors, who this person answers to directly. Should be a string, shown to the player when they enter the game.
	var/selection_class 	= "" // Job Selection span class (for background color)

	var/late_joinable 		= TRUE

	var/flags_startup_parameters = NO_FLAGS //These flags are used to determine how to load the role, and some other parameters.
	var/flags_whitelist = NO_FLAGS 			//Only used by whitelisted roles. Can be a single whitelist flag, or a combination of them.

	//If you have use_timelocks config option enabled, this option will add a requirement for players to have the prerequisite roles have at least x minimum playtime before unlocking.
	var/list/minimum_playtimes = list(
		JOB_SQUAD_ROLES_LIST = HOURS_3
	)

	var/minimum_playtime_as_job = HOURS_3

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
	
	if(client.admin_holder && (client.admin_holder.rights & (R_NOLOCK | R_ADMIN)))
		return TRUE

	if(get_job_playtime(client, title) > minimum_playtime_as_job)
		return TRUE
	
	for(var/prereq in minimum_playtimes)
		if(islist(prereq))
			var/total = 0
			for(var/prequisite_added in prereq)
				total += get_job_playtime(client, prequisite_added)

			if(total < LAZYACCESS(minimum_playtimes, prereq))
				return FALSE
		else
			if(get_job_playtime(client, prereq) < LAZYACCESS(minimum_playtimes, prereq))
				return FALSE

	return TRUE

/datum/job/proc/get_role_requirements(var/client/C)
	var/list/return_requirements = list()
	for(var/prereq in minimum_playtimes)
		var/playtime = get_job_playtime(C, prereq)
		var/prereq_name = prereq

		if(islist(prereq))
			var/list/L = prereq
			for(var/prequisite_added in prereq)
				playtime += get_job_playtime(C, prequisite_added)
			
			prereq_name = LAZYACCESS(L, 1)

		if(playtime < LAZYACCESS(minimum_playtimes, prereq))
			return_requirements[prereq_name] = LAZYACCESS(minimum_playtimes, prereq) - playtime
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

/datum/job/proc/spawn_in_player(var/mob/new_player/NP)
	if(!istype(NP))
		return

	NP.spawning = TRUE
	NP.close_spawn_windows()

	var/mob/living/carbon/human/new_character = new(NP.loc)
	new_character.lastarea = get_area(NP.loc)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		NP.client.prefs.real_name = random_name(new_character.gender)
		NP.client.prefs.randomize_appearance(new_character)
	else
		NP.client.prefs.copy_all_to(new_character)

	if (NP.client.prefs.be_random_body)
		var/datum/preferences/TP = new()
		TP.randomize_appearance(new_character)

	new_character.job = NP.job
	new_character.name = NP.real_name
	new_character.voice = NP.real_name

	if(NP.client.prefs.disabilities)
		new_character.disabilities |= NEARSIGHTED

	if(NP.mind)
		NP.mind_initialize()
		NP.mind.transfer_to(new_character, TRUE)
		NP.mind.setup_human_stats()

	// Update the character icons
	// This is done in set_species when the mob is created as well, but 
	INVOKE_ASYNC(new_character, /mob/living/carbon/human.proc/regenerate_icons)
	INVOKE_ASYNC(new_character, /mob/living/carbon/human.proc/update_body, 1, 0)
	INVOKE_ASYNC(new_character, /mob/living/carbon/human.proc/update_hair)

	return new_character

/datum/job/proc/equip_job(var/mob/living/M)
	if(!istype(M))
		return

	var/obj/effect/landmark/S //Starting mark.
	for(var/i in landmarks_list)
		var/obj/effect/landmark/L = i
		if(L && L.name == title && !locate(/mob/living) in L.loc)
			S = L
			break
	if(!S)
		S = locate("start*[title]") //Old type spawn.
	if(istype(S) && istype(S.loc, /turf))
		M.loc = S.loc

	if(ishuman(M))
		var/mob/living/carbon/H = M
		H.job = title

		var/datum/money_account/A
		//Give them an account in the database.
		if(!(flags_startup_parameters & ROLE_NO_ACCOUNT))
			A = create_account(H.real_name, rand(50,500)*10, null)
			if(H.mind)
				var/remembered_info = ""
				remembered_info += "<b>Your account number is:</b> #[A.account_number]<br>"
				remembered_info += "<b>Your account pin is:</b> [A.remote_access_pin]<br>"
				remembered_info += "<b>Your account funds are:</b> $[A.money]<br>"

				if(A.transaction_log.len)
					var/datum/transaction/T = A.transaction_log[1]
					remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
				H.mind.store_memory(remembered_info)
				H.mind.initial_account = A

		var/job_whitelist = title
		var/whitelist_status = get_whitelist_status(RoleAuthority.roles_whitelist, H.client)

		if(whitelist_status)
			job_whitelist = "[title][whitelist_status]"

		if(gear_preset_whitelist[job_whitelist])
			arm_equipment(H, gear_preset_whitelist[job_whitelist], FALSE, TRUE)
			announce_entry_message(H, A, whitelist_status) //Tell them their spawn info.
			generate_entry_conditions(H, whitelist_status) //Do any other thing that relates to their spawn.
		else
			arm_equipment(H, gear_preset, FALSE, TRUE) //After we move them, we want to equip anything else they should have.
			announce_entry_message(H, A) //Tell them their spawn info.
			generate_entry_conditions(H) //Do any other thing that relates to their spawn.

		if(flags_startup_parameters & ROLE_ADD_TO_SQUAD) //Are we a muhreen? Randomize our squad. This should go AFTER IDs. //TODO Robust this later.
			RoleAuthority.randomize_squad(H)

		if(Check_WO() && job_squad_roles.Find(H.job))	//activates self setting proc for marine headsets for WO
			var/datum/game_mode/whiskey_outpost/WO = ticker.mode
			WO.self_set_headset(H)

		H.sec_hud_set_ID()
		H.hud_set_squad()

		SSround_recording.recorder.track_player(H)

	return TRUE