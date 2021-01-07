//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/becomelarva,			/*lets you forgo your larva protection as staff member. */
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/open_STUI, 			// This proc can be used by all admins but depending on your rank you see diffrent stuff.
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/debug_global_variables
	)

var/list/admin_verbs_admin = list(
	/datum/admins/proc/togglejoin,		/*toggles whether people can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/view_txt_log,	/*shows the server log (diary) for today*/
	/client/proc/cmd_stickyban,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/giveruntimelog,		/*allows us to give access to runtime logs to somebody*/
	/client/proc/getserverlog,			/*allows us to fetch server logs (diary) for other days*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_create_centcom_report, //Messages from USCM command.
	/client/proc/cmd_admin_create_AI_report,  //Allows creation of IC reports by the ships AI utilizing Almayer General channel. Relies on ARES being intact and tcomms being powered.
	/client/proc/cmd_admin_create_AI_shipwide_report,  //Allows creation of IC reports by the ships AI utilizing announcement code. Will be shown to every conscious human on Almayer z-level regardless of ARES and tcomms status.
	/client/proc/cmd_admin_create_predator_report, //Predator ship AI report
	/client/proc/toggleprayers,			/*toggles prayers on/off*/
	/client/proc/toggle_hear_radio,		/*toggles whether we hear the radio*/
	/client/proc/event_panel,
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/free_slot,				/*frees slot for chosen job*/
	/client/proc/modify_slot,
	/client/proc/adjust_predator_round,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/cmd_admin_remove_clamp,
	/client/proc/cmd_admin_repair_multitile,
	/datum/admins/proc/admin_force_distress,
	/datum/admins/proc/admin_force_ERT_shuttle,
	/datum/admins/proc/admin_force_selfdestruct,
	/datum/admins/proc/force_predator_round, //Force spawns a predator round.
	/client/proc/check_round_statistics,
	/client/proc/force_shuttle,
	/client/proc/force_ground_shuttle,
	/client/proc/force_teleporter,
	/client/proc/toggle_grenade_antigrief,
	/client/proc/matrix_editor
)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel
	// /client/proc/jobbans // Disabled temporarily due to 15-30 second lag spikes. Don't forget the comma in the line above when uncommenting this!
)
var/list/admin_verbs_sounds = list(
	/client/proc/play_web_sound,
	/client/proc/play_sound
)
var/list/admin_verbs_fun = list(
	/client/proc/enable_event_mob_verbs,
	/client/proc/cmd_admin_dress_all,
	/client/proc/free_all_mobs_in_view,
	/client/proc/drop_bomb,
	/client/proc/set_ooc_color_global,
	/client/proc/announce_random_fact,
	/client/proc/construct_env,
	/client/proc/construct_env_dmm,
	/client/proc/set_autoreplacer,
	/client/proc/deactivate_autoreplacer,
	/client/proc/rerun_decorators,
	/client/proc/toogle_door_control
)
var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_atom,
	/client/proc/game_panel,
	/client/proc/create_humans
)
var/list/admin_verbs_server = list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/end_round,
	/datum/admins/proc/change_ground_map,
	/datum/admins/proc/vote_ground_map,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
)
var/list/admin_verbs_debug = list(
    /client/proc/getruntimelog,                     /*allows us to access runtime logs to somebody*/
	/client/proc/debug_role_authority,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_fire_ob,
	/client/proc/cmd_debug_list_processing_items,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/reload_admins,
	/client/proc/reload_whitelist,
	/client/proc/restart_controller,
	/client/proc/cmd_debug_toggle_should_check_for_win,
	/client/proc/enable_debug_verbs,
	/client/proc/proccall_advanced,
	/client/proc/proccall_atom,
	/client/proc/toggledebuglogs,
	/client/proc/togglenichelogs,
	/client/proc/cmd_admin_change_hivenumber,
	/client/proc/spawn_wave,
	/client/proc/run_all_tests,
	/client/proc/run_test_set,
	/client/proc/run_individual_test,
	/client/proc/toggle_log_hrefs,
	/client/proc/matrix_editor,
	/client/proc/generate_sound_queues,
	/client/proc/sound_debug_query,
	/client/proc/bulk_fetcher,
	/client/proc/debug_game_history,
	/client/proc/construct_env_dmm
)

var/list/clan_verbs = list(
	/client/proc/usr_create_new_clan
)

var/list/debug_verbs = list(
    /client/proc/Cell,
    /client/proc/cmd_assume_direct_control,
    /client/proc/ticklag,
    /client/proc/cmd_admin_grantfullaccess,
    /client/proc/cmd_admin_grantallskills,
    /client/proc/hide_debug_verbs,
    /client/proc/view_power_update_stats_area,
    /client/proc/view_power_update_stats_machines,
    /client/proc/toggle_power_update_profiling,
	/client/proc/nanomapgen_DumpImage,
)

var/list/admin_verbs_paranoid_debug = list(
	/client/proc/proccall_advanced,
	/client/proc/proccall_atom,
)

var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
)
var/list/admin_verbs_permissions = list(
	/client/proc/ToRban
)
var/list/admin_verbs_color = list(
	/client/proc/set_ooc_color_self
)

var/list/admin_mob_event_verbs_hideable = list(
	/client/proc/hide_event_mob_verbs,
	/client/proc/cmd_admin_select_mob_rank,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/editappear,
	/client/proc/cmd_admin_addhud,
	/client/proc/cmd_admin_change_their_hivenumber,
	/client/proc/cmd_assume_direct_control,
	/client/proc/free_mob_for_ghosts,
	/proc/possess,
	/proc/release
)

//verbs which can be hidden - needs work
var/list/admin_mob_verbs_hideable = list(
	/client/proc/hide_admin_mob_verbs,
	/client/proc/cmd_admin_change_their_name,
	/client/proc/cmd_admin_changekey,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_pm_context,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/show_player_panel,
	/client/proc/cmd_admin_delete,
	/datum/admins/proc/togglesleep,
	/client/proc/debug_variables,
	/client/proc/debug_global_variables
)

var/list/admin_verbs_teleport = list(
	/client/proc/teleport_panel,			/*teleport panel, for jumping to things/places and getting things/places */
	/client/proc/jumptocoord,
	/client/proc/jumptomob,
	/client/proc/jump_to_object,
	/client/proc/jump_to_turf,
	/client/proc/jump_to_area,
	/client/proc/jumptokey,
	/client/proc/Getmob,
	/client/proc/Getkey,
	/client/proc/toggle_noclip
)

var/list/admin_verbs_mod = list(
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game.*/
	/client/proc/debug_global_variables,
	/client/proc/toggledebuglogs,
	/client/proc/togglenichelogs,
	/datum/admins/proc/player_notes_show,
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/invismin,
	/client/proc/cmd_mod_say,
	/client/proc/dsay,
	/client/proc/chem_panel,			/*chem panel, allows viewing, editing and creation of reagent and chemical_reaction datums*/
	/client/proc/vehicle_panel,
	/client/proc/in_view_panel,
	/client/proc/rejuvenate_all_in_view,
	/client/proc/rejuvenate_all_humans_in_view,
	/client/proc/rejuvenate_all_revivable_humans_in_view,
	/client/proc/rejuvenate_all_xenos_in_view,
	/datum/admins/proc/togglesleep,
	/datum/admins/proc/sleepall,
	/datum/admins/proc/togglejoin,
	/client/proc/jump_to_object,
	/client/proc/jumptomob,
	/client/proc/toggle_own_ghost_vis,
	/client/proc/check_antagonists,
	/client/proc/check_round_status,
	/client/proc/toggleattacklogs,
	/client/proc/toggleffattacklogs,
	/client/proc/xooc,					// Xeno OOC
	/client/proc/mooc,					// Marine OOC
	/client/proc/yooc,					// Yautja OOC
	/datum/admins/proc/view_txt_log,
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/togglelooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggledsay,		/*toggles dsay on/off for everyone*/
	/client/proc/cmd_admin_xeno_report,  //Allows creation of IC reports by the Queen Mother
	/datum/admins/proc/viewUnheardAhelps,
	/client/proc/view_faxes,
	/client/proc/cmd_admin_change_their_name,
	/client/proc/cmd_admin_changekey,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_pm_context,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/show_player_panel,
	/client/proc/show_objectives_status,
	/client/proc/hide_admin_mob_verbs,
	/client/proc/clear_mutineers
)

/client/proc/add_admin_verbs()
	// mentors don't have access to admin verbs
	if(admin_holder && !AHOLD_IS_ONLY_MENTOR(admin_holder))
		add_verb(src, admin_verbs_default)
		if(admin_holder.rights & R_BUILDMODE)
			add_verb(src, /client/proc/togglebuildmodeself)
		if(admin_holder.rights & R_ADMIN)
			add_verb(src, admin_verbs_admin)
		if(admin_holder.rights & R_BAN)
			add_verb(src, admin_verbs_ban+admin_verbs_teleport)
		if(admin_holder.rights & R_FUN)
			add_verb(src, admin_verbs_fun)
		if(admin_holder.rights & R_SERVER)
			add_verb(src, admin_verbs_server)
		if(admin_holder.rights & R_DEBUG)
			add_verb(src, admin_verbs_debug)
			if(CONFIG_GET(flag/debugparanoid) && !check_rights(R_ADMIN))
				remove_verb(src, admin_verbs_paranoid_debug) //Right now it's just callproc but we can easily add others later on.
		if(admin_holder.rights & R_POSSESS)
			add_verb(src, admin_verbs_possess)
		if(admin_holder.rights & R_PERMISSIONS)
			add_verb(src, admin_verbs_permissions)
		if(admin_holder.rights & R_COLOR)
			add_verb(src, admin_verbs_color)
		if(admin_holder.rights & R_SOUNDS)
			add_verb(src, admin_verbs_sounds)
		if(admin_holder.rights & R_SPAWN)
			add_verb(src, admin_verbs_spawn)
		if(admin_holder.rights & R_MOD)
			add_verb(src, admin_verbs_mod)

		if(RoleAuthority && (RoleAuthority.roles_whitelist[ckey] & WHITELIST_YAUTJA_LEADER))
			add_verb(src, clan_verbs)
	if(admin_holder && admin_holder.rights & R_MENTOR)
		add_verb(src, /client/proc/cmd_mentor_say)

/client/proc/add_admin_whitelists()
	if(is_mentor(src) || AHOLD_IS_MOD(admin_holder))
		RoleAuthority.roles_whitelist[ckey] |= WHITELIST_MENTOR

/client/proc/remove_admin_verbs()
	remove_verb(src, list(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_mod,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		admin_verbs_color,
		admin_verbs_sounds,
		admin_verbs_spawn,
		admin_verbs_teleport,
		admin_mob_event_verbs_hideable,
		admin_mob_verbs_hideable,
		debug_verbs,
	))

/client/proc/jobbans()
	set name = "Display Job Bans"
	set category = "Admin"
	if(admin_holder)
		admin_holder.Jobbans()
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin.Game"
	if(admin_holder)
		admin_holder.Game()
	return

/client/proc/set_ooc_color_self()
	set category = "OOC.OOC"
	set name = "OOC Text Color - Self"
	if(!admin_holder && !donator)	return
	var/new_ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color|null
	if(new_ooccolor)
		prefs.ooccolor = new_ooccolor
		prefs.save_preferences()
	return


#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		to_chat(usr, "<font color='red'>Error: warn(): You can't warn admins.</font>")
		return

	var/datum/entity/player/P = get_player_from_key(warned_ckey) // you may not be logged in, but I will find you and I will ban you

	if(!P)
		to_chat(src, "<font color='red'>Error: warn(): No such ckey found.</font>")
		return

	if(++P.warning_count >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(P.owning_client)
			message_staff("[key_name_admin(src)] has warned [ckey] resulting in a [AUTOBANTIME] minute ban.")
			to_chat_forced(P.owning_client, "<font color='red'><BIG><B>You have been autobanned due to a warning by [key_name_admin(P.owning_client)].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes.")
		else
			message_staff("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")

		P.add_timed_ban("Autobanning due to too many formal warnings", AUTOBANTIME)
	else
		if(P.owning_client)
			to_chat(P.owning_client, "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>")
			message_staff("[key_name_admin(src)] has warned [key_name_admin(P.owning_client)]. They have [MAX_WARNS-P.warning_count] strikes remaining.")
		else
			message_staff("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-P.warning_count] strikes remaining.")

/client/proc/give_disease(mob/T as mob in GLOB.mob_list) // -- Giacom
	set category = "Admin.Fun"
	set name = "Give Disease (old)"
	set desc = "Gives a (tg-style) Disease to a mob."
	var/list/disease_names = list()
	for(var/v in diseases)
		disease_names.Add(copytext("[v]", 16, 0))
	var/datum/disease/D = input("Choose the disease to give to that guy", "ACHOO") as null|anything in disease_names
	if(!D) return
	var/path = text2path("/datum/disease/[D]")
	T.contract_disease(new path, 1)

	message_staff("[key_name_admin(usr)] gave [key_name(T)] the disease [D].")


/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Admin.Events"
	set name = "Object Say"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)


/client/proc/toggle_log_hrefs()
	set name = "Toggle href Logging"
	set category = "Server"
	if(!admin_holder)	return
	if(config)
		if(CONFIG_GET(flag/log_hrefs))
			CONFIG_SET(flag/log_hrefs, FALSE)
			to_chat(src, "<b>Stopped logging hrefs</b>")
		else
			CONFIG_SET(flag/log_hrefs, TRUE)
			to_chat(src, "<b>Started logging hrefs</b>")


/client/proc/editappear(mob/living/carbon/human/M as mob in GLOB.human_mob_list)
	set name = "Edit Appearance"
	set category = null

	if(!check_rights(R_FUN))	return

	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, SPAN_DANGER("You can only do this to humans!"))
		return
	switch(alert("Are you sure you wish to edit this mob's appearance?",,"Yes","No"))
		if("No")
			return
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))


	// hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	M.update_hair()
	M.update_body()


/client/proc/toggleattacklogs()
	set name = "Toggle Attack Log Messages"
	set category = "Preferences.Logs"

	prefs.toggles_chat ^= CHAT_ATTACKLOGS
	if (prefs.toggles_chat & CHAT_ATTACKLOGS)
		to_chat(usr, SPAN_BOLDNOTICE("You will now get attack log messages."))
	else
		to_chat(usr, SPAN_BOLDNOTICE("You will no longer get attack log messages."))


/client/proc/toggleffattacklogs()
	set name = "Toggle FF Attack Log Messages"
	set category = "Preferences.Logs"

	prefs.toggles_chat ^= CHAT_FFATTACKLOGS
	if (prefs.toggles_chat & CHAT_FFATTACKLOGS)
		to_chat(usr, SPAN_BOLDNOTICE("You will now get friendly fire attack log messages."))
	else
		to_chat(usr, SPAN_BOLDNOTICE("You will no longer get friendly fire attack log messages."))


/client/proc/toggledebuglogs()
	set name = "Toggle Debug Log Messages"
	set category = "Preferences.Logs"

	prefs.toggles_chat ^= CHAT_DEBUGLOGS
	if(prefs.toggles_chat & CHAT_DEBUGLOGS)
		to_chat(usr, SPAN_BOLDNOTICE("You will now get debug log messages."))
	else
		to_chat(usr, SPAN_BOLDNOTICE("You will no longer get debug log messages."))


/client/proc/togglenichelogs()
	set name = "Toggle Niche Log Messages"
	set category = "Preferences.Logs"

	prefs.toggles_chat ^= CHAT_NICHELOGS
	if(prefs.toggles_chat & CHAT_NICHELOGS)
		to_chat(usr, SPAN_BOLDNOTICE("You will now get niche log messages."))
	else
		to_chat(usr, SPAN_BOLDNOTICE("You will no longer get niche log messages."))


/client/proc/announce_random_fact()
	set name = "Announce Random Fact"
	set desc = "Tells everyone about a random statistic in the round."
	set category = "OOC"

	SSticker.mode?.declare_random_fact()


#undef MAX_WARNS
#undef AUTOBANTIME
