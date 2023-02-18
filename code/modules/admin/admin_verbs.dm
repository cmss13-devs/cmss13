//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel, /*shows an interface for individual players, with various links (links require additional flags*/
	/client/proc/toggleadminhelpsound, /*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/becomelarva, /*lets you forgo your larva protection as staff member. */
	/client/proc/deadmin_self, /*destroys our own admin datum so we can play as a regular player*/
	/client/proc/open_STUI, // This proc can be used by all admins but depending on your rank you see diffrent stuff.
	/client/proc/debug_variables, /*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/debug_global_variables,
	/client/proc/xooc, // Xeno OOC
	/client/proc/mooc, // Marine OOC
	/client/proc/yooc, // Yautja OOC
	/client/proc/view_faxes,
	/client/proc/create_custom_paper,
	/client/proc/cmd_admin_change_their_name,
	/client/proc/cmd_admin_changekey,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_object_narrate,
	/client/proc/cmd_admin_xeno_report,  //Allows creation of IC reports by the Queen Mother
	/client/proc/cmd_admin_create_AI_report,  //Allows creation of IC reports by the ships AI utilizing Almayer General channel. Relies on ARES being intact and tcomms being powered.
	/client/proc/cmd_admin_create_AI_shipwide_report,  //Allows creation of IC reports by the ships AI utilizing announcement code. Will be shown to every conscious human on Almayer z-level regardless of ARES and tcomms status.
	/client/proc/cmd_admin_create_AI_apollo_report,  //Allows creation of IC reports to the Apollo subprocessor, transmitting to Working Joes and Maintenance Drones.
	/client/proc/cmd_admin_create_centcom_report, //Messages from USCM command/other factions.
	/client/proc/cmd_admin_create_predator_report, //Predator ship AI report
	/client/proc/admin_ghost, /*allows us to ghost/reenter body at will*/
	/client/proc/invismin,
	/client/proc/set_explosive_antigrief,
	/client/proc/check_explosive_antigrief,
	/client/proc/cmd_mod_say,
	/client/proc/dsay,
	/client/proc/chem_panel, /*chem panel, allows viewing, editing and creation of reagent and chemical_reaction datums*/
	/client/proc/player_panel_new, /*shows an interface for all players, with links to various panels*/
	/client/proc/cmd_admin_pm_context, /*right-click adminPM interface*/
	/client/proc/toggledebuglogs,
	/client/proc/togglestatpanelsplit,
	/client/proc/togglenichelogs,
	/datum/admins/proc/display_tags,
	/datum/admins/proc/player_notes_show,
	/datum/admins/proc/toggleooc, /*toggles ooc on/off for everyone*/
	/datum/admins/proc/togglelooc, /*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggledsay, /*toggles dsay on/off for everyone*/
	/client/proc/check_antagonists,
	/client/proc/check_round_status,
	/client/proc/toggleattacklogs,
	/client/proc/toggleffattacklogs,
	/datum/admins/proc/show_player_panel,
	/client/proc/hide_admin_verbs,
	/client/proc/vehicle_panel,
	/client/proc/in_view_panel, /*allows application of aheal/sleep in an AOE*/
	/client/proc/toggle_lz_resin,
	/client/proc/rejuvenate_all_in_view,
	/client/proc/rejuvenate_all_humans_in_view,
	/client/proc/rejuvenate_all_revivable_humans_in_view,
	/client/proc/rejuvenate_all_xenos_in_view,
	/datum/admins/proc/togglesleep,
	/datum/admins/proc/sleepall,
	/datum/admins/proc/wakeall,
	/client/proc/toggle_lz_protection,
	/client/proc/jump_to_object,
	/client/proc/jumptomob,
	/client/proc/toggle_own_ghost_vis,
	/client/proc/cmd_admin_check_contents,
	/client/proc/clear_mutineers,
	/datum/admins/proc/directnarrateall,
	/datum/admins/proc/subtlemessageall,
	/datum/admins/proc/alertall,
	/datum/admins/proc/imaginary_friend,
	)

var/list/admin_verbs_admin = list(
	/datum/admins/proc/togglejoin, /*toggles whether people can join the current game*/
	/datum/admins/proc/announce, /*priority announce something to all clients.*/
	/datum/admins/proc/view_txt_log, /*shows the server log (diary) for today*/
	/client/proc/cmd_admin_delete, /*delete an instance/object/mob/etc*/
	/client/proc/giveruntimelog, /*allows us to give access to runtime logs to somebody*/
	/client/proc/getserverlog, /*allows us to fetch server logs (diary) for other days*/
	/client/proc/toggleprayers, /*toggles prayers on/off*/
	/client/proc/toggle_hear_radio, /*toggles whether we hear the radio*/
	/client/proc/event_panel,
	/client/proc/cmd_admin_say, /*admin-only ooc chat*/
	/client/proc/free_slot, /*frees slot for chosen job*/
	/client/proc/modify_slot,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/cmd_admin_remove_clamp,
	/client/proc/cmd_admin_repair_multitile,
	/datum/admins/proc/admin_force_selfdestruct,
	/client/proc/check_round_statistics,
	/client/proc/force_ground_shuttle,
	/client/proc/force_teleporter,
	/client/proc/matrix_editor,
	/datum/admins/proc/open_shuttlepanel
)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel
	// /client/proc/jobbans // Disabled temporarily due to 15-30 second lag spikes. Don't forget the comma in the line above when uncommenting this!
)
var/list/admin_verbs_sounds = list(
	/client/proc/play_web_sound,
	/client/proc/play_sound,
	/client/proc/stop_web_sound,
	/client/proc/stop_sound,
	/client/proc/cmd_admin_vox_panel
)
var/list/admin_verbs_minor_event = list(
	/client/proc/cmd_admin_change_custom_event,
	/datum/admins/proc/admin_force_distress,
	/datum/admins/proc/admin_force_ERT_shuttle,
	/client/proc/force_shuttle,
	/datum/admins/proc/force_predator_round, //Force spawns a predator round.
	/client/proc/adjust_predator_round,
	/client/proc/cmd_admin_world_narrate, /*sends text to all players with no padding*/
	/client/proc/cmd_admin_object_narrate,
	/client/proc/cmd_admin_create_centcom_report, //Messages from USCM command/other factions.
	/client/proc/cmd_admin_create_predator_report, //Predator ship AI report
	/client/proc/toggle_ob_spawn,
	/client/proc/toggle_sniper_upgrade,
	/client/proc/toggle_attack_dead,
	/client/proc/toggle_strip_drag,
	/client/proc/toggle_uniform_strip,
	/client/proc/toggle_strong_defibs,
	/client/proc/toggle_blood_optimization,
	/client/proc/toggle_combat_cas,
	/client/proc/toggle_lz_protection, //Mortar hitting LZ
	/client/proc/cmd_admin_medals_panel, // Marine and Xeno medals editor panel
	/client/proc/force_event,
	/client/proc/toggle_events,
	/client/proc/toggle_shipside_sd
)
var/list/admin_verbs_major_event = list(
	/client/proc/enable_event_mob_verbs,
	/client/proc/cmd_admin_dress_all,
	/client/proc/free_all_mobs_in_view,
	/client/proc/drop_bomb,
	/client/proc/set_ooc_color_global,
	/client/proc/announce_random_fact,
	/client/proc/set_autoreplacer,
	/client/proc/deactivate_autoreplacer,
	/client/proc/rerun_decorators,
	/client/proc/toogle_door_control,
	/client/proc/map_template_load,
	/client/proc/load_event_level,
	/client/proc/cmd_fun_fire_ob,
	/client/proc/map_template_upload,
	/client/proc/enable_podlauncher,
	/client/proc/change_taskbar_icon,
	/client/proc/change_weather
)
var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_atom,
	/client/proc/game_panel,
	/client/proc/create_humans,
	/client/proc/create_xenos
)
var/list/admin_verbs_server = list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/end_round,
	/datum/admins/proc/change_ground_map,
	/datum/admins/proc/change_ship_map,
	/datum/admins/proc/vote_ground_map,
	/client/proc/cmd_admin_delete, /*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/datum/admins/proc/togglejoin,
	/datum/admins/proc/view_txt_log
)
var/list/admin_verbs_debug = list(
	/client/proc/getruntimelog,  /*allows us to access runtime logs to somebody*/
	/client/proc/debug_role_authority,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_list_processing_items,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/reload_admins,
	/client/proc/reload_whitelist,
	/client/proc/restart_controller,
	/client/proc/debug_controller,
	/client/proc/cmd_debug_toggle_should_check_for_win,
	/client/proc/enable_debug_verbs,
	/client/proc/toggledebuglogs,
	/client/proc/togglenichelogs,
	/client/proc/cmd_admin_change_hivenumber,
	/client/proc/spawn_wave,
	/client/proc/toggle_log_hrefs,
	/client/proc/matrix_editor,
	/client/proc/generate_sound_queues,
	/client/proc/sound_debug_query,
	/client/proc/debug_game_history,
	/client/proc/construct_env_dmm,
	/client/proc/enter_tree,
	/client/proc/set_tree_points,
	/client/proc/purge_data_tab,
)

var/list/admin_verbs_debug_advanced = list(
	/client/proc/callproc_datum,
	/client/proc/callproc,
	/client/proc/SDQL2_query,
)

var/list/clan_verbs = list(
	/client/proc/usr_create_new_clan
)

var/list/debug_verbs = list(
	/client/proc/Cell,
	/client/proc/cmd_assume_direct_control,
	/client/proc/ticklag,
	/client/proc/hide_debug_verbs,
	/client/proc/view_power_update_stats_area,
	/client/proc/view_power_update_stats_machines,
	/client/proc/toggle_power_update_profiling,
	/client/proc/nanomapgen_DumpImage,
)

var/list/admin_verbs_possess = list(
	/client/proc/possess,
	/client/proc/release
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
	/client/proc/possess,
	/client/proc/release,
	/client/proc/cmd_admin_grantfullaccess,
	/client/proc/cmd_admin_grantallskills,
	/client/proc/admin_create_account
)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/client/proc/release,
	/client/proc/possess,
	/client/proc/callproc_datum,
	/client/proc/jump_to_object,
	/client/proc/jumptomob,
	/client/proc/hide_admin_verbs,
	/client/proc/cmd_admin_change_their_name,
	/client/proc/cmd_admin_changekey,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_object_narrate,
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
	/client/proc/teleport_panel, /*teleport panel, for jumping to things/places and getting things/places */
	/client/proc/jumptocoord,
	/client/proc/jumptooffsetcoord,
	/client/proc/jumptomob,
	/client/proc/jump_to_object,
	/client/proc/jump_to_turf,
	/client/proc/jump_to_area,
	/client/proc/jumptokey,
	/client/proc/Getmob,
	/client/proc/Getkey,
	/client/proc/toggle_noclip
)

var/list/roundstart_mod_verbs = list(
	/client/proc/toggle_ob_spawn
)

/client/proc/add_admin_verbs()
	if(!admin_holder)
		return
	if(CLIENT_IS_STAFF(src))
		add_verb(src, admin_verbs_default)
	if(CLIENT_HAS_RIGHTS(src, R_MOD))
		add_verb(src, admin_verbs_ban)
		add_verb(src, admin_verbs_teleport)
	if(CLIENT_HAS_RIGHTS(src, R_EVENT))
		add_verb(src, admin_verbs_minor_event)
	if(CLIENT_HAS_RIGHTS(src, R_ADMIN))
		add_verb(src, admin_verbs_admin)
		add_verb(src, admin_verbs_major_event)
	if(CLIENT_HAS_RIGHTS(src, R_MENTOR))
		add_verb(src, /client/proc/cmd_mentor_say)
		add_verb(src, /datum/admins/proc/imaginary_friend)
	if(CLIENT_HAS_RIGHTS(src, R_BUILDMODE))
		add_verb(src, /client/proc/togglebuildmodeself)
	if(CLIENT_HAS_RIGHTS(src, R_SERVER))
		add_verb(src, admin_verbs_server)
	if(CLIENT_HAS_RIGHTS(src, R_DEBUG))
		add_verb(src, admin_verbs_debug)
		if(!CONFIG_GET(flag/debugparanoid) || CLIENT_HAS_RIGHTS(src, R_ADMIN))
			add_verb(src, admin_verbs_debug_advanced)  // Right now it's just callproc but we can easily add others later on.
	if(CLIENT_HAS_RIGHTS(src, R_POSSESS))
		add_verb(src, admin_verbs_possess)
	if(CLIENT_HAS_RIGHTS(src, R_PERMISSIONS))
		add_verb(src, admin_verbs_permissions)
	if(CLIENT_HAS_RIGHTS(src, R_COLOR))
		add_verb(src, admin_verbs_color)
	if(CLIENT_HAS_RIGHTS(src, R_SOUNDS))
		add_verb(src, admin_verbs_sounds)
	if(CLIENT_HAS_RIGHTS(src, R_SPAWN))
		add_verb(src, admin_verbs_spawn)
	if(RoleAuthority && (RoleAuthority.roles_whitelist[ckey] & WHITELIST_YAUTJA_LEADER))
		add_verb(src, clan_verbs)

/client/proc/add_admin_whitelists()
	if(CLIENT_HAS_RIGHTS(src, R_MENTOR))
		RoleAuthority.roles_whitelist[ckey] |= WHITELIST_MENTOR
	if(CLIENT_IS_STAFF(src))
		RoleAuthority.roles_whitelist[ckey] |= WHITELIST_JOE

/client/proc/remove_admin_verbs()
	remove_verb(src, list(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_minor_event,
		admin_verbs_major_event,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_debug_advanced,
		admin_verbs_possess,
		admin_verbs_permissions,
		admin_verbs_color,
		admin_verbs_sounds,
		admin_verbs_spawn,
		admin_verbs_teleport,
		admin_mob_event_verbs_hideable,
		admin_verbs_hideable,
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
	set category = "Admin.Panels"
	if(admin_holder)
		admin_holder.Game()
	return

/client/proc/set_ooc_color_self()
	set category = "OOC.OOC"
	set name = "OOC Text Color - Self"
	if(!admin_holder && !donator) return
	var/new_ooccolor = input(src, "Please select your OOC color.", "OOC color") as color|null
	if(new_ooccolor)
		prefs.ooccolor = new_ooccolor
		prefs.save_preferences()
	return


#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN)) return

	if(!warned_ckey || !istext(warned_ckey)) return
	if(warned_ckey in admin_datums)
		to_chat(usr, "<font color='red'>Error: warn(): You can't warn admins.</font>")
		return

	var/datum/entity/player/P = get_player_from_key(warned_ckey) // you may not be logged in, but I will find you and I will ban you

	if(!P)
		to_chat(src, "<font color='red'>Error: warn(): No such ckey found.</font>")
		return

	if(++P.warning_count >= MAX_WARNS) //uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(P.owning_client)
			message_admins("[key_name_admin(src)] has warned [ckey] resulting in a [AUTOBANTIME] minute ban.")
			to_chat_forced(P.owning_client, "<font color='red'><BIG><B>You have been autobanned due to a warning by [key_name_admin(P.owning_client)].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")

		P.add_timed_ban("Autobanning due to too many formal warnings", AUTOBANTIME)
	else
		if(P.owning_client)
			to_chat(P.owning_client, "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>")
			message_admins("[key_name_admin(src)] has warned [key_name_admin(P.owning_client)]. They have [MAX_WARNS-P.warning_count] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-P.warning_count] strikes remaining.")

/client/proc/give_disease(mob/T as mob in GLOB.mob_list) // -- Giacom
	set category = "Admin.Fun"
	set name = "Give Disease (old)"
	set desc = "Gives a (tg-style) Disease to a mob."
	var/list/disease_names = list()
	for(var/v in diseases)
		disease_names.Add(copytext("[v]", 16, 0))
	var/datum/disease/D = tgui_input_list(usr, "Choose the disease to give to that guy", "ACHOO", disease_names)
	if(!D) return
	var/path = text2path("/datum/disease/[D]")
	T.contract_disease(new path, 1)

	message_admins("[key_name_admin(usr)] gave [key_name(T)] the disease [D].")


/client/proc/object_talk(msg as text) // -- TLE
	set category = "Admin.Events"
	set name = "Object Say"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", SHOW_MESSAGE_AUDIBLE)


/client/proc/toggle_log_hrefs()
	set name = "Toggle href Logging"
	set category = "Server"
	if(!admin_holder) return
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

	if(!check_rights(R_ADMIN)) return

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
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in GLOB.hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in GLOB.facial_hair_styles_list
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

// TODO Port this to Statpanel Options Window probably
/client/proc/togglestatpanelsplit()
	set name = "Toggle Split Tabs"
	set category = "Preferences"
	prefs.toggles_admin ^= SPLIT_ADMIN_TABS
	if(prefs.toggles_chat & SPLIT_ADMIN_TABS)
		to_chat(usr, SPAN_BOLDNOTICE("You enabled split admin tabs in Statpanel."))
	else
		to_chat(usr, SPAN_BOLDNOTICE("You disabled split admin tabs in Statpanel."))

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

	message_admins("[key_name(usr)] announced a random fact.")
	SSticker.mode?.declare_fun_facts()


#undef MAX_WARNS
#undef AUTOBANTIME
