/datum/job
	//The name of the job
	var/title = null //The internal title for the job, used for the job ban system and so forth. Don't change these, change the disp_title instead.
	var/disp_title //Determined on new(). Usually the same as the title, but doesn't have to be. Set this to override what the player sees in the game as their title.
	var/role_ban_alternative // If the roleban title needs to be an extra check, like Xenomorphs = Alien.

	var/total_positions = 0 //How many players can be this job
	var/spawn_positions = 0 //How many players can spawn in as this job
	var/total_positions_so_far = 0 //How many slots were open in this round. Used to prevent slots locking with decreasing amount of alive players
	var/allow_additional = 0 //Can admins modify positions to it
	var/scaled = 0
	var/current_positions = 0 //How many players have this job
	var/supervisors = "" //Supervisors, who this person answers to directly. Should be a string, shown to the player when they enter the game.
	var/selection_class = "" // Job Selection span class (for background color)

	var/late_joinable = TRUE

	var/flags_startup_parameters = NO_FLAGS //These flags are used to determine how to load the role, and some other parameters.
	var/flags_whitelist = NO_FLAGS //Only used by whitelisted roles. Can be a single whitelist flag, or a combination of them.

	//If you have use_timelocks config option enabled, this option will add a requirement for players to have the prerequisite roles have at least x minimum playtime before unlocking.
	var/list/minimum_playtimes

	var/minimum_playtime_as_job = 3 HOURS

	var/datum/equipment_preset/gear_preset //Gear preset name used for this job
	var/list/gear_preset_whitelist = list()//Gear preset name used for council snowflakes ;)

	//For generating entry messages
	var/entry_message_intro
	var/entry_message_body
	var/entry_message_end

	/// When set to true, SSticker won't call spawn_in_player, instead calling the job's spawn_and_equip proc
	var/handle_spawn_and_equip = FALSE

	/// When set you will be able to choose between the different job options when selecting your role.
	/// Associated list. Main list elements - actual options, associated values - shorthands for job preferences menu (keep those short).
	var/job_options
	/// If TRUE, this job will spawn w/ a cryo emergency kit during evac/red alert
	var/gets_emergency_kit = TRUE
	/// Under what faction menu the job gets displayed in lobby
	var/faction_menu = FACTION_NEUTRAL //neutral to cover uscm jobs for now as loads of them are under civil and stuff mainly ment for other faction

	/// How many points people with this role selected get to pick from
	var/loadout_points = 0

/datum/job/New()
	. = ..()

	RegisterSignal(SSdcs, COMSIG_GLOB_CONFIG_LOADED, PROC_REF(on_config_load))

	minimum_playtimes = setup_requirements(list())
	if(!disp_title)
		disp_title = title

	if(global.config.is_loaded)
		on_config_load()

/datum/job/proc/on_config_load()
	if(entry_message_body)
		entry_message_body = replace_placeholders(entry_message_body)

/datum/job/proc/replace_placeholders(replacement_string)
	replacement_string = replacetextEx(replacement_string, WIKI_PLACEHOLDER, generate_wiki_link())
	replacement_string = replacetextEx(replacement_string, LAW_PLACEHOLDER, "[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_LAW]")
	return replacement_string

/datum/job/proc/generate_wiki_link()
	if(!CONFIG_GET(string/wikiarticleurl))
		return ""
	return "[CONFIG_GET(string/wikiarticleurl)]/[replacetext(title, " ", "_")]"

/datum/job/proc/get_whitelist_status(client/player)
	return WHITELIST_NORMAL

/datum/timelock
	var/name
	var/time_required
	var/roles

/datum/timelock/New(name, time_required, list/roles)
	. = ..()
	if(name)
		src.name = name
	if(time_required)
		src.time_required = time_required
	if(roles)
		src.roles = roles

/datum/job/proc/setup_requirements(list/L)
	var/list/to_return = list()
	for(var/PT in L)
		if(ispath(PT))
			LAZYADD(to_return, new PT(time_required = L[PT]))
		else
			LAZYADD(to_return, TIMELOCK_JOB(PT, L[PT]))

	return to_return

/datum/timelock/proc/can_play(client/C)
	if(islist(roles))
		var/total = 0
		for(var/role_required in roles)
			total += get_job_playtime(C, role_required)

		return total >= time_required
	else
		return get_job_playtime(C, roles) >= time_required

/datum/timelock/proc/get_role_requirement(client/C)
	if(islist(roles))
		var/total = 0
		for(var/role_required in roles)
			total += get_job_playtime(C, role_required)

		return time_required - total
	else
		return time_required - get_job_playtime(C, roles)

/datum/job/proc/can_play_role(client/client)
	if(!CONFIG_GET(flag/use_timelocks))
		return TRUE

	if(client.admin_holder && (client.admin_holder.rights & (R_NOLOCK | R_ADMIN)))
		return TRUE

	if(get_job_playtime(client, title) > minimum_playtime_as_job)
		return TRUE

	for(var/prereq in minimum_playtimes)
		var/datum/timelock/T = prereq
		if(!T.can_play(client))
			return FALSE

	return TRUE

/// Whether the client passes requirements for the scenario
/datum/job/proc/can_play_role_in_scenario(client/client)
	return TRUE

/datum/job/proc/get_role_requirements(client/C)
	var/list/return_requirements = list()
	for(var/prereq in minimum_playtimes)
		var/datum/timelock/T = prereq
		var/time_required = T.get_role_requirement(C)
		if(time_required > 0)
			return_requirements[T] = time_required

	return return_requirements

/datum/job/proc/get_access()
	if(!gear_preset)
		return null
	if(GLOB.gear_path_presets_list[gear_preset])
		return GLOB.gear_path_presets_list[gear_preset].access
	return null

/datum/job/proc/get_skills()
	if(!gear_preset)
		return null
	if(GLOB.gear_path_presets_list[gear_preset])
		return GLOB.gear_path_presets_list[gear_preset].skills
	return null

/datum/job/proc/get_paygrade()
	if(!gear_preset)
		return ""
	if(GLOB.gear_path_presets_list[gear_preset])
		return GLOB.gear_path_presets_list[gear_preset].paygrades[1]
	return ""

/datum/job/proc/get_comm_title()
	if(!gear_preset)
		return ""
	if(GLOB.gear_path_presets_list[gear_preset])
		return GLOB.gear_path_presets_list[gear_preset].role_comm_title
	return ""

/datum/job/proc/set_spawn_positions(count)
	return spawn_positions

/datum/job/proc/spawn_and_equip(mob/new_player/player)
	CRASH("A job without a set spawn_and_equip proc has handle_spawn_and_equip set to TRUE!")

/datum/job/proc/generate_money_account(mob/living/carbon/human/account_user)

	var/datum/money_account/generated_account
	//Give them an account in the database.
	if(!(flags_startup_parameters & ROLE_NO_ACCOUNT))
		var/obj/item/card/id/card = account_user.get_idcard()
		var/user_has_preexisting_account = account_user.mind?.initial_account
		if(card && !user_has_preexisting_account)
			var/datum/paygrade/account_paygrade = GLOB.paygrades[card.paygrade]
			generated_account = create_account(account_user.real_name, rand(30, 50), account_paygrade)
			card.associated_account_number = generated_account.account_number
			if(account_user.mind)
				var/remembered_info = ""
				remembered_info += "<b>Your account number is:</b> #[generated_account.account_number]<br>"
				remembered_info += "<b>Your account pin is:</b> [generated_account.remote_access_pin]<br>"
				remembered_info += "<b>Your account funds are:</b> $[generated_account.money]<br>"

				if(length(generated_account.transaction_log))
					var/datum/transaction/T = generated_account.transaction_log[1]
					remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
				account_user.mind.store_memory(remembered_info)
				account_user.mind.initial_account = generated_account
	return generated_account

/datum/job/proc/generate_entry_message()
	if(!entry_message_intro)
		entry_message_intro = "You are the [title]!"
	if(!entry_message_end)
		entry_message_end = "As the [title] you answer to [supervisors]. Special circumstances may change this!"
	return "[entry_message_intro]<br>[entry_message_body]<br>[entry_message_end]"

/datum/job/proc/announce_entry_message(mob/living/carbon/human/H, datum/money_account/M, whitelist_status) //The actual message that is displayed to the mob when they enter the game as a new player.
	set waitfor = 0
	sleep(10)
	if(H && H.loc && H.client)
		var/title_given
		title_given = lowertext(disp_title)

		//Document syntax cannot have tabs for proper formatting.
		var/entrydisplay = boxed_message("\
			[SPAN_ROLE_BODY("|______________________|")] \n\
			[SPAN_ROLE_HEADER("You are \a [title_given]")] \n\
			[flags_startup_parameters & ROLE_ADMIN_NOTIFY ? SPAN_ROLE_HEADER("You are playing a job that is important for game progression. If you have to disconnect, please notify the admins via adminhelp.") : ""] \n\
			[SPAN_ROLE_BODY("[generate_entry_message(H)]<br>[M ? "Your account number is: <b>[M.account_number]</b>. Your account pin is: <b>[M.remote_access_pin]</b>." : "You do not have a bank account."]")] \n\
			[SPAN_ROLE_BODY("|______________________|")] \
		")
		to_chat_spaced(H, html = entrydisplay)

/datum/job/proc/generate_entry_conditions(mob/living/M, whitelist_status)
	if (istype(M) && M.client)
		M.client.soundOutput.update_ambience()

	return //Anything special that should happen to the mob upon entering the world.

//This lets you scale max jobs at runtime
//All you have to do is rewrite the inheritance
/datum/job/proc/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions

/datum/job/proc/spawn_in_player(mob/new_player/NP)
	if(!istype(NP))
		return

	var/mob/living/carbon/human/new_character = new(NP.loc)
	new_character.lastarea = get_area(NP.loc)

	setup_human(new_character, NP)

	return new_character

/datum/job/proc/equip_job(mob/living/M)
	if(!istype(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/human = M

		var/job_whitelist = title
		var/whitelist_status = get_whitelist_status(human.client)

		if(whitelist_status)
			job_whitelist = "[title][whitelist_status]"

		human.job = title //TODO Why is this a mob variable at all?

		load_loadout(M)

		if(gear_preset_whitelist[job_whitelist])
			arm_equipment(human, gear_preset_whitelist[job_whitelist], FALSE, TRUE)
			var/generated_account = generate_money_account(human)
			announce_entry_message(human, generated_account, whitelist_status) //Tell them their spawn info.
			generate_entry_conditions(human, whitelist_status) //Do any other thing that relates to their spawn.
		else
			arm_equipment(human, gear_preset, FALSE, TRUE) //After we move them, we want to equip anything else they should have.
			var/generated_account = generate_money_account(human)
			announce_entry_message(human, generated_account) //Tell them their spawn info.
			generate_entry_conditions(human) //Do any other thing that relates to their spawn.

		if(flags_startup_parameters & ROLE_ADD_TO_SQUAD) //Are we a muhreen? Randomize our squad. This should go AFTER IDs. //TODO Robust this later.
			GLOB.RoleAuthority.randomize_squad(human)
		GLOB.RoleAuthority.prioritize_specialist(human)

		if(Check_WO() && GLOB.job_squad_roles.Find(GET_DEFAULT_ROLE(human.job))) //activates self setting proc for marine headsets for WO
			var/datum/game_mode/whiskey_outpost/WO = SSticker.mode
			WO.self_set_headset(human)

		var/assigned_squad
		if(human.assigned_squad)
			assigned_squad = human.assigned_squad.name

		var/turf/join_turf
		if(assigned_squad && GLOB.spawns_by_squad_and_job[assigned_squad] && GLOB.spawns_by_squad_and_job[assigned_squad][type])
			join_turf = get_turf(pick(GLOB.spawns_by_squad_and_job[assigned_squad][type]))
		else if(GLOB.spawns_by_job[type])
			join_turf = get_turf(pick(GLOB.spawns_by_job[type]))
		else if(assigned_squad && GLOB.latejoin_by_squad[assigned_squad])
			join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else if(GLOB.latejoin_by_job[title])
			join_turf = get_turf(pick(GLOB.latejoin_by_job[title]))
		else
			join_turf = get_turf(pick(GLOB.latejoin))
		human.forceMove(join_turf)

		for(var/cardinal in GLOB.cardinals)
			var/obj/structure/machinery/cryopod/pod = locate() in get_step(human, cardinal)
			if(pod)
				pod.go_in_cryopod(human, TRUE)
				break

		human.sec_hud_set_ID()
		human.hud_set_squad()

		SSround_recording.recorder.track_player(human)

	return TRUE

/// If we have one, equip our mob with their job gear
/datum/job/proc/load_loadout(mob/living/carbon/human/new_human)
	if(!new_human.client || !new_human.client.prefs)
		return

	var/equipment_slot = new_human.client.prefs.get_active_loadout(title)
	if(!length(equipment_slot))
		return

	for(var/gear_type in equipment_slot)
		var/datum/gear/current_gear = GLOB.gear_datums_by_type[gear_type]
		if(!current_gear)
			continue

		current_gear.equip_to_user(new_human)

/// Intended to be overwritten to handle when a job has variants that can be selected.
/datum/job/proc/handle_job_options(option)
	return

/// Intended to be overwritten to handle any requirements for specific job variations that can be selected
/datum/job/proc/filter_job_option(mob/job_applicant)
	return job_options

/datum/job/proc/check_whitelist_status(mob/user)
	if(!(flags_startup_parameters & ROLE_WHITELISTED))
		return TRUE

	if(user.client.check_whitelist_status(flags_whitelist))
		return TRUE

/// Called when the job owner enters deep cryogenic storage
/datum/job/proc/on_cryo(mob/living/carbon/human/cryoing)
	return

/// Returns the active player on this job, specifically for singleton jobs
/datum/job/proc/get_active_player_on_job()
	return
