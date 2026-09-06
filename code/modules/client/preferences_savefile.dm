#define SAVEFILE_VERSION_MIN 8
#define SAVEFILE_VERSION_MAX 37

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, returns FALSE to delete it and start again
//if a file was updated, returns TRUE
/datum/preferences/proc/savefile_update()
	if(!isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN) //lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in GLOB.preferences_datums)
			var/datum/preferences/D = GLOB.preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[ckey[1]]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return FALSE

	if(savefile_version < 12) //we've split toggles into toggles_sound and toggles_chat
		savefile.tree["toggles_sound"] = TOGGLES_SOUND_DEFAULT
		savefile.tree["toggles_chat"] = TOGGLES_CHAT_DEFAULT

	if(savefile_version < 13)
		var/sound_toggles
		sound_toggles = savefile.tree["toggles_sound"]
		sound_toggles |= SOUND_INTERNET
		savefile.tree["toggles_sound"] = sound_toggles

	if(savefile_version < 14) //toggle unnest flashing on by default
		var/flash_toggles
		flash_toggles = savefile.tree["toggles_flashing"]
		flash_toggles |= FLASH_UNNEST
		savefile.tree["toggles_flashing"] = flash_toggles

	if(savefile_version < 15) //toggles on membership publicity by default because forgot to six months ago
		var/pref_toggles
		pref_toggles = savefile.tree["toggle_prefs"]
		pref_toggles |= TOGGLE_MEMBER_PUBLIC
		savefile.tree["toggle_prefs"] = pref_toggles

	if(savefile_version < 16) //toggle unpool flashing on by default
		var/flash_toggles_two
		flash_toggles_two = savefile.tree["toggles_flashing"]
		flash_toggles_two |= FLASH_POOLSPAWN
		savefile.tree["toggles_flashing"] = flash_toggles_two

	if(savefile_version < 17) //toggle middle click swap hands on by default
		var/pref_middle_click_swap
		pref_middle_click_swap = savefile.tree["toggle_prefs"]
		pref_middle_click_swap |= TOGGLE_MIDDLE_MOUSE_SWAP_HANDS
		savefile.tree["toggle_prefs"] = pref_middle_click_swap

	if(savefile_version < 17) //remove omniglots
		var/list/language_traits = list()
		language_traits = savefile.tree["traits"]
		if(LAZYLEN(language_traits) > 1)
			language_traits = null
		savefile.tree["traits"] = language_traits

	if(savefile_version < 18) // adds ambient occlusion by default
		var/pref_toggles
		pref_toggles = savefile.tree["toggle_prefs"]
		pref_toggles |= TOGGLE_AMBIENT_OCCLUSION
		savefile.tree["toggle_prefs"] = pref_toggles

	if(savefile_version < 19) // toggles vending to hand by default
		var/pref_toggle_vend_item_tohand
		pref_toggle_vend_item_tohand = savefile.tree["toggle_prefs"]
		pref_toggle_vend_item_tohand |= TOGGLE_VEND_ITEM_TO_HAND
		savefile.tree["toggle_prefs"] = pref_toggle_vend_item_tohand

	if(savefile_version < 20) // adds midi and atmospheric sounds on by default
		var/sound_toggles
		sound_toggles = savefile.tree["toggles_sound"]
		sound_toggles |= (SOUND_ADMIN_MEME|SOUND_ADMIN_ATMOSPHERIC)
		savefile.tree["toggles_sound"] = sound_toggles

	if(savefile_version < 21)
		var/pref_toggles
		pref_toggles = savefile.tree["toggle_prefs"]
		if(pref_toggles & TOGGLE_ALTERNATING_DUAL_WIELD)
			dual_wield_pref = DUAL_WIELD_SWAP
		else
			dual_wield_pref = DUAL_WIELD_FIRE
		savefile.tree["dual_wield_pref"] = dual_wield_pref

	if(savefile_version < 22)
		var/sound_toggles
		sound_toggles = savefile.tree["toggles_sound"]
		sound_toggles |= SOUND_OBSERVER_ANNOUNCEMENTS
		savefile.tree["toggles_sound"] = sound_toggles

	if(savefile_version < 23)
		var/ethnicity
		var/skin_color = "pale2"
		ethnicity = savefile.tree["ethnicity"]
		switch(ethnicity)
			if("anglo")
				skin_color = "pale2"
			if("western")
				skin_color = "tan2"
			if("germanic")
				skin_color = "pale2"
			if("scandinavian")
				skin_color = "pale3"
			if("baltic")
				skin_color = "pale3"
			if("sinoorient")
				skin_color = "pale1"
			if("southorient")
				skin_color = "tan1"
			if("indian")
				skin_color = "tan3"
			if("sino")
				skin_color = "tan1"
			if("mesoamerican")
				skin_color = "tan3"
			if("northamerican")
				skin_color = "tan3"
			if("southamerican")
				skin_color = "tan2"
			if("circumpolar")
				skin_color = "tan1"
			if("northafrican")
				skin_color = "tan3"
			if("centralafrican")
				skin_color = "dark1"
			if("costalafrican")
				skin_color = "dark3"
			if("persian")
				skin_color = "tan3"
			if("levant")
				skin_color = "tan3"
			if("australasian")
				skin_color = "dark2"
			if("polynesian")
				skin_color = "tan3"
		savefile.tree["skin_color"] = skin_color

	if(savefile_version < 24) // adds fax machine sounds on by default
		var/sound_toggles
		sound_toggles = savefile.tree["toggles_sound"]
		sound_toggles |= (SOUND_FAX_MACHINE)
		savefile.tree["toggles_sound"] = sound_toggles

	if(savefile_version < 25) //renemes nanotrasen to wy
		var/relation
		relation = savefile.tree["nanotrasen_relation"]
		savefile.tree["weyland_yutani_relation"] = relation

	if(savefile_version < 26)
		// Removes TOGGLE_MIDDLE_MOUSE_CLICK (1<<2) and replaces it with a new pref
		var/toggle_prefs = 0
		toggle_prefs = savefile.tree["toggle_prefs"]
		if(toggle_prefs & (1<<2))
			savefile.tree["xeno_ability_click_mode"] = XENO_ABILITY_CLICK_MIDDLE
		else
			savefile.tree["xeno_ability_click_mode"] = XENO_ABILITY_CLICK_SHIFT

	if(savefile_version < 27)
		// Gives staff afk protection by default.
		savefile.tree["toggles_admin"] = TOGGLES_ADMIN_DEFAULT
		// Updates default chat settings to enable FF logs for new staff.
		var/chat_settings = 0
		chat_settings = savefile.tree["toggles_chat"]
		chat_settings &= ~CHAT_ATTACKLOGS
		chat_settings |= CHAT_FFATTACKLOGS
		savefile.tree["toggles_chat"] = chat_settings

	if(savefile_version < 28)
		var/tutorial_string = ""
		tutorial_string = savefile.tree["completed_tutorials"]
		tutorial_savestring_to_list(tutorial_string)
		if("requisitions_line" in completed_tutorials)
			completed_tutorials -= "requisitions_line"
			completed_tutorials += "marine_req_1"
		savefile.tree["completed_tutorials"] = tutorial_list_to_savestring()

	if(savefile_version < 29)
		var/hair_style = ""
		hair_style = savefile.tree["hair_style_name"]

		switch(hair_style)
			if("Shoulder-length Hair Alt")
				hair_style = "Long Fringe"
			if("Long Hair Alt")
				hair_style = "Longer Fringe"

		savefile.tree["hair_style_name"] = hair_style

	if(savefile_version < 30)
		var/be_special = 0
		be_special = savefile.tree["be_special"]
		be_special &= ~BE_KING
		savefile.tree["be_special"] = be_special

	if(savefile_version < 31)
		for(var/i in 1 to MAX_SAVE_SLOTS)
			var/character_tree_key = "character[i]"
			var/list/character_data = savefile.get_entry(character_tree_key, list())

			var/list/existing_gear = character_data["gear"]

			var/list/new_list = list()
			for(var/entry in existing_gear)
				var/datum/gear/gear = GLOB.gear_datums_by_name[entry]
				if(!gear)
					continue

				new_list += "[gear.type]"

			character_data["gear"] = new_list

	if(savefile_version < 32)
		var/pref_toggles
		pref_toggles = savefile.tree["toggle_prefs"]
		pref_toggles |= TOGGLE_LEADERSHIP_SPOKEN_ORDERS // Enables it by default for new saves
		savefile.tree["toggle_prefs"] = pref_toggles

	if(savefile_version < 33)
		var/pref_toggles
		pref_toggles = savefile.tree["toggle_prefs"]
		pref_toggles |= TOGGLE_COCKING_TO_HAND // enabled by default for new saves
		savefile.tree["toggle_prefs"] = pref_toggles

	if(savefile_version < 34)
		var/pref_toggles
		pref_toggles = savefile.tree["toggle_prefs"]
		pref_toggles |= TOGGLE_WIELD_ASSIST // enabled by default for new saves
		savefile.tree["toggle_prefs"] = pref_toggles

	if(savefile_version < 35) // we have removed Tab from the default binds, allow users to bind it back if they want. needs to be async after logging in
		updated_from = savefile_version

	if(savefile_version < 36)
		var/toggles_insert
		toggles_insert = savefile.tree["toggles_insert"]
		toggles_insert |= (PLAY_INSERT_STANDARD|PLAY_INSERT_CORPORATE|PLAY_INSERT_LEADER|PLAY_INSERT_MEDIC|PLAY_INSERT_ENGINEER|PLAY_INSERT_SPECIALIST|PLAY_INSERT_SMARTGUNNER|PLAY_INSERT_SYNTH|PLAY_INSERT_CO) // enabled by default for new saves
		savefile.tree["toggles_insert"] = toggles_insert

	if(savefile_version < 37)
		var/toggles_insert
		toggles_insert = savefile.tree["toggles_sound"]
		toggles_insert |= (SOUND_ROUND_END)
		savefile.tree["toggles_sound"] = toggles_insert

	if(updated_from)
		RegisterSignal(owner, COMSIG_CLIENT_LOGGED_IN, PROC_REF(handle_logged_in))

	savefile_version = SAVEFILE_VERSION_MAX
	save_preferences()
	return TRUE

/// Attempts to load a preferences.sav for the owner and migrate it to a save tree
/datum/preferences/proc/try_savefile_tree_migration()
	load_path(owner.ckey, "preferences.sav") // old save file
	var/old_path = path
	load_path(owner.ckey)
	if(!fexists(old_path))
		return
	var/datum/byond_save_tree/byond_save_tree = new(path)
	byond_save_tree.import_byond_savefile(new /savefile(old_path))
	byond_save_tree.save()
	return TRUE

/// SIGNAL_HANDLER for COMSIG_CLIENT_LOGGED_IN to perform handle_controlstyle_update
/datum/preferences/proc/handle_logged_in()
	SIGNAL_HANDLER

	handle_controlstyle_update(updated_from)

/// Displays savefile updates that require user input
/datum/preferences/proc/handle_controlstyle_update(updated_from)
	set waitfor = FALSE

	if(updated_from == /datum/preferences::savefile_version)
		return

	if(updated_from < 34)
		var/question = tgui_alert(owner, "Tab is no longer bound to switching between the map and the command bar. Restore this bind?", "Default Bind Changed", list("No", "Yes"))
		if(question == "Yes")
			LAZYADD(key_bindings["Tab"], /datum/keybinding/client/switch_input::name)
			owner?.update_special_keybinds()
			save_preferences()

/// Assigns the path for the provided ckey and filename
/datum/preferences/proc/load_path(ckey, filename="preferences_tree.sav")
	if(!ckey)
		return
	path = "data/player_saves/[ckey[1]]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/// Loads the save tree for the assigned path
/datum/preferences/proc/load_savefile()
	if(!path)
		CRASH("Attempted to load savefile without first loading a path!")
	savefile = new /datum/byond_save_tree(path)

/datum/preferences/proc/load_preferences()
	if(!savefile)
		stack_trace("Attempted to load the preferences of [owner] without a savefile; did you forget to call load_savefile?")
		load_savefile()
		if(!savefile)
			stack_trace("Failed to load the savefile for [owner] after manually calling load_savefile; something is very wrong.")
			return FALSE

	if(!fexists(path))
		load_preferences_sanitize() // Ensure a new player gets same defaults as returning players
		return FALSE

	//Conversion
	savefile_version = savefile.tree["version"]
	if(!savefile_version || !isnum(savefile_version) || savefile_version != SAVEFILE_VERSION_MAX)
		if(!savefile_update())  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_character()
			save_preferences() // This one writes to disk
			return FALSE

	//general preferences
	ooccolor = savefile.tree["ooccolor"]
	lastchangelog = savefile.tree["lastchangelog"]
	be_special = savefile.tree["be_special"]
	default_slot = savefile.tree["default_slot"]
	toggles_chat = savefile.tree["toggles_chat"]
	chat_display_preferences = savefile.tree["chat_display_preferences"]
	toggles_ghost = savefile.tree["toggles_ghost"]
	toggles_langchat = savefile.tree["toggles_langchat"]
	toggles_sound = savefile.tree["toggles_sound"]
	volume_preferences = savefile.tree["volume_preferences"]
	toggle_prefs = savefile.tree["toggle_prefs"]
	xeno_ability_click_mode = savefile.tree["xeno_ability_click_mode"]
	dual_wield_pref = savefile.tree["dual_wield_pref"]
	toggles_flashing = savefile.tree["toggles_flashing"]
	toggles_ert = savefile.tree["toggles_ert"]
	toggles_survivor = savefile.tree["toggles_survivor"]
	toggles_insert = savefile.tree["toggles_insert"]
	toggles_ert_pred = savefile.tree["toggles_ert_pred"]
	toggles_admin = savefile.tree["toggles_admin"]
	UI_style = savefile.tree["UI_style"]
	tgui_say = savefile.tree["tgui_say"]
	UI_style_color = savefile.tree["UI_style_color"]
	UI_style_alpha = savefile.tree["UI_style_alpha"]
	item_animation_pref_level = savefile.tree["item_animation_pref_level"]
	pain_overlay_pref_level = savefile.tree["pain_overlay_pref_level"]
	flash_overlay_pref = savefile.tree["flash_overlay_pref"]
	crit_overlay_pref = savefile.tree["crit_overlay_pref"]
	allow_flashing_lights_pref = savefile.tree["allow_flashing_lights_pref"]
	stylesheet = savefile.tree["stylesheet"]
	window_skin = savefile.tree["window_skin"]
	fps = savefile.tree["fps"]
	ghost_vision_pref = savefile.tree["ghost_vision_pref"]
	ghost_orbit = savefile.tree["ghost_orbit"]
	auto_observe = savefile.tree["auto_observe"]
	CMTV_toggle_optout = savefile.tree["CMTV_toggle_optout"]

	human_name_ban = savefile.tree["human_name_ban"]

	xeno_prefix = savefile.tree["xeno_prefix"]
	xeno_postfix = savefile.tree["xeno_postfix"]
	xeno_name_ban = savefile.tree["xeno_name_ban"]
	playtime_perks = savefile.tree["playtime_perks"]
	skip_playtime_ranks = savefile.tree["skip_playtime_ranks"]
	show_queen_name = savefile.tree["show_queen_name"]
	show_minimap_ceiling_protection = savefile.tree["show_minimap_ceiling_protection"]
	xeno_vision_level_pref = savefile.tree["xeno_vision_level_pref"]
	xeno_defensive_grab_pref = savefile.tree["xeno_defensive_grab_pref"]
	View_MC = savefile.tree["view_controller"]
	observer_huds = savefile.tree["observer_huds"]
	pref_special_job_options = savefile.tree["pref_special_job_options"]
	pref_job_slots = savefile.tree["pref_job_slots"]

	synthetic_name = savefile.tree["synth_name"]
	synthetic_type = savefile.tree["synth_type"]
	synth_specialisation = savefile.tree["synth_specialisation"]
	predator_name = savefile.tree["pred_name"]
	predator_gender = savefile.tree["pred_gender"]
	predator_age = savefile.tree["pred_age"]
	predator_use_legacy = savefile.tree["pred_use_legacy"]
	predator_use_unique = savefile.tree["pred_use_unique"]
	predator_translator_type = savefile.tree["pred_trans_type"]
	predator_invisibility_sound = savefile.tree["pred_invis_sound"]
	predator_mask_type = savefile.tree["pred_mask_type"]
	predator_accessory_type = savefile.tree["pred_accessory_type"]
	predator_armor_type = savefile.tree["pred_armor_type"]
	predator_boot_type = savefile.tree["pred_boot_type"]
	predator_mask_material = savefile.tree["pred_mask_mat"]
	predator_armor_material = savefile.tree["pred_armor_mat"]
	predator_greave_material = savefile.tree["pred_greave_mat"]
	predator_caster_material = savefile.tree["pred_caster_mat"]
	predator_bracer_material = savefile.tree["pred_bracer_mat"]
	predator_cape_color = savefile.tree["pred_cape_color"]
	predator_h_style = savefile.tree["pred_h_style"]
	predator_skin_color = savefile.tree["pred_skin_color"]
	predator_flavor_text = savefile.tree["pred_flavor_text"]

	commander_status = savefile.tree["commander_status"]
	commander_sidearm = savefile.tree["co_sidearm"]
	affiliation = savefile.tree["co_affiliation"]
	co_career_path = savefile.tree["co_command_path"]
	yautja_status = savefile.tree["yautja_status"]
	synth_status = savefile.tree["synth_status"]

	fax_name_uscm = savefile.tree["fax_name_uscm"]
	fax_name_pvst = savefile.tree["fax_name_pvst"]
	fax_name_wy = savefile.tree["fax_name_wy"]
	fax_name_upp = savefile.tree["fax_name_upp"]
	fax_name_twe = savefile.tree["fax_name_twe"]
	fax_name_cmb = savefile.tree["fax_name_cmb"]
	fax_name_press = savefile.tree["fax_name_press"]
	fax_name_clf = savefile.tree["fax_name_clf"]

	ff_log_color = savefile.tree["ff_log_color"]
	ffd_log_color = savefile.tree["ffd_log_color"]

	lang_chat_disabled = savefile.tree["lang_chat_disabled"]
	show_permission_errors = savefile.tree["show_permission_errors"]
	hear_vox = savefile.tree["hear_vox"]
	hide_statusbar = savefile.tree["hide_statusbar"]
	no_radials_preference = savefile.tree["no_radials_preference"]
	no_radial_labels_preference = savefile.tree["no_radial_labels_preference"]
	hotkeys = savefile.tree["hotkeys"]

	custom_cursors = savefile.tree["custom_cursors"]
	auto_fit_viewport = savefile.tree["autofit_viewport"]
	adaptive_zoom = savefile.tree["adaptive_zoom"]
	tooltips = savefile.tree["tooltips"]
	key_bindings = savefile.tree["key_bindings"]

	custom_keybinds = savefile.tree["custom_keybinds"]

	tgui_lock = savefile.tree["tgui_lock"]
	tgui_fancy = savefile.tree["tgui_fancy"]
	window_scale = savefile.tree["window_scale"]

	var/tutorial_string = ""
	tutorial_string = savefile.tree["completed_tutorials"]
	tutorial_savestring_to_list(tutorial_string)

	var/list/remembered_key_bindings
	remembered_key_bindings = savefile.tree["remembered_key_bindings"]
	remembered_key_bindings = sanitize_islist(remembered_key_bindings, null)

	lastchangelog = savefile.tree["lastchangelog"]

	loadout = savefile.tree["job_loadout"]
	loadout_slot_names = savefile.tree["job_loadout_names"]

	show_cooldown_messages = savefile.tree["show_cooldown_messages"]

	chem_presets = savefile.tree["chem_presets"]

	//Sanitize
	load_preferences_sanitize()

	check_keybindings()
	savefile.tree["key_bindings"] = key_bindings

	if(remembered_key_bindings)
		for(var/i in GLOB.keybindings_by_name)
			if(!(i in remembered_key_bindings))
				var/datum/keybinding/instance = GLOB.keybindings_by_name[i]
				// Classic
				if(LAZYLEN(instance.classic_keys))
					for(var/bound_key in instance.classic_keys)
						LAZYADD(key_bindings[bound_key], list(instance.name))

				// Hotkey
				if(LAZYLEN(instance.hotkey_keys))
					for(var/bound_key in instance.hotkey_keys)
						LAZYADD(key_bindings[bound_key], list(instance.name))

	savefile.tree["remembered_key_bindings"] = GLOB.keybindings_by_name

	load_custom_keybinds()

	if(toggles_chat & SHOW_TYPING)
		owner.typing_indicators = FALSE
	else
		owner.typing_indicators = TRUE

	return TRUE

/proc/sanitize_keybindings(value)
	var/list/base_bindings = sanitize_islist(value, list())
	if(!length(base_bindings))
		base_bindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key)
	for(var/key in base_bindings)
		base_bindings[key] = base_bindings[key] & GLOB.keybindings_by_name
		if(!length(base_bindings[key]))
			base_bindings -= key
	return base_bindings

/proc/sanitize_volume_preferences(list/pref_list, list/default_volume_preferences)
	var/list/volume_preferences = sanitize_islist(pref_list, default_volume_preferences)
	if(length(volume_preferences) != length(default_volume_preferences))
		volume_preferences = default_volume_preferences
	for(var/i in 1 to length(volume_preferences))
		var/num = sanitize_float(volume_preferences[i], 0, 1, 1)
		volume_preferences[i] = num
	return volume_preferences

/// Sanitizes general preferences (not characters)
/// Does not alter the save tree
/datum/preferences/proc/load_preferences_sanitize()
	ooccolor = sanitize_hexcolor(ooccolor, CONFIG_GET(string/ooc_color_default))
	lastchangelog = sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style = sanitize_inlist(UI_style, list("white", "dark", "midnight", "orange", "old"), initial(UI_style))
	tgui_say = sanitize_integer(tgui_say, FALSE, TRUE, TRUE)
	be_special = sanitize_integer(be_special, 0, SHORT_REAL_LIMIT, initial(be_special))
	default_slot = sanitize_integer(default_slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	toggles_chat = sanitize_integer(toggles_chat, 0, SHORT_REAL_LIMIT, initial(toggles_chat))
	chat_display_preferences = sanitize_integer(chat_display_preferences, 0, SHORT_REAL_LIMIT, initial(chat_display_preferences))
	toggles_ghost = sanitize_integer(toggles_ghost, 0, SHORT_REAL_LIMIT, initial(toggles_ghost))
	toggles_langchat = sanitize_integer(toggles_langchat, 0, SHORT_REAL_LIMIT, initial(toggles_langchat))
	toggles_sound = sanitize_integer(toggles_sound, 0, SHORT_REAL_LIMIT, initial(toggles_sound))
	toggle_prefs = sanitize_integer(toggle_prefs, 0, SHORT_REAL_LIMIT, initial(toggle_prefs))
	xeno_ability_click_mode = sanitize_integer(xeno_ability_click_mode, 1, XENO_ABILITY_CLICK_MAX, initial(xeno_ability_click_mode))
	dual_wield_pref = sanitize_integer(dual_wield_pref, 0, 2, initial(dual_wield_pref))
	toggles_flashing= sanitize_integer(toggles_flashing, 0, SHORT_REAL_LIMIT, initial(toggles_flashing))
	toggles_ert = sanitize_integer(toggles_ert, 0, SHORT_REAL_LIMIT, initial(toggles_ert))
	toggles_survivor = sanitize_integer(toggles_survivor, 0, SHORT_REAL_LIMIT, initial(toggles_survivor))
	toggles_insert = sanitize_integer(toggles_insert, 0, SHORT_REAL_LIMIT, initial(toggles_insert))
	toggles_ert_pred = sanitize_integer(toggles_ert_pred, 0, SHORT_REAL_LIMIT, initial(toggles_ert_pred))
	toggles_admin = sanitize_integer(toggles_admin, 0, SHORT_REAL_LIMIT, initial(toggles_admin))
	UI_style_color = sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha = sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))
	item_animation_pref_level = sanitize_integer(item_animation_pref_level, SHOW_ITEM_ANIMATIONS_NONE, SHOW_ITEM_ANIMATIONS_ALL, SHOW_ITEM_ANIMATIONS_ALL)
	pain_overlay_pref_level = sanitize_integer(pain_overlay_pref_level, PAIN_OVERLAY_BLURRY, PAIN_OVERLAY_LEGACY, PAIN_OVERLAY_BLURRY)
	flash_overlay_pref = sanitize_integer(flash_overlay_pref, FLASH_OVERLAY_WHITE, FLASH_OVERLAY_DARK)
	crit_overlay_pref = sanitize_integer(crit_overlay_pref, CRIT_OVERLAY_WHITE, CRIT_OVERLAY_DARK)
	allow_flashing_lights_pref = sanitize_integer(allow_flashing_lights_pref, FALSE, TRUE, FALSE)
	window_skin = sanitize_integer(window_skin, 0, SHORT_REAL_LIMIT, initial(window_skin))
	ghost_vision_pref = sanitize_inlist(ghost_vision_pref, list(GHOST_VISION_LEVEL_NO_NVG, GHOST_VISION_LEVEL_MID_NVG, GHOST_VISION_LEVEL_HIGH_NVG, GHOST_VISION_LEVEL_FULL_NVG), GHOST_VISION_LEVEL_MID_NVG)
	ghost_orbit = sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
	auto_observe = sanitize_integer(auto_observe, 0, 1, 1)
	CMTV_toggle_optout = sanitize_integer(CMTV_toggle_optout, 0, 1, 0)
	playtime_perks = sanitize_integer(playtime_perks, 0, 1, 1)
	skip_playtime_ranks = sanitize_integer(skip_playtime_ranks, 0, 1, 1)
	show_queen_name = sanitize_integer(show_queen_name, FALSE, TRUE, FALSE)
	show_minimap_ceiling_protection = sanitize_integer(show_minimap_ceiling_protection, FALSE, TRUE, FALSE)
	xeno_vision_level_pref = sanitize_inlist(xeno_vision_level_pref, list(XENO_VISION_LEVEL_NO_NVG, XENO_VISION_LEVEL_MID_NVG, XENO_VISION_LEVEL_HIGH_NVG, XENO_VISION_LEVEL_FULL_NVG), XENO_VISION_LEVEL_MID_NVG)
	xeno_defensive_grab_pref = sanitize_islist(xeno_defensive_grab_pref, alist())
	hear_vox = sanitize_integer(hear_vox, FALSE, TRUE, TRUE)
	hide_statusbar = sanitize_integer(hide_statusbar, FALSE, TRUE, FALSE)
	no_radials_preference = sanitize_integer(no_radials_preference, FALSE, TRUE, FALSE)
	no_radial_labels_preference = sanitize_integer(no_radial_labels_preference, FALSE, TRUE, FALSE)
	auto_fit_viewport = sanitize_integer(auto_fit_viewport, FALSE, TRUE, TRUE)
	adaptive_zoom = sanitize_integer(adaptive_zoom, 0, 2, 0)
	tooltips = sanitize_integer(tooltips, FALSE, TRUE, TRUE)

	synthetic_name = synthetic_name ? sanitize_text(synthetic_name, initial(synthetic_name)) : initial(synthetic_name)
	synthetic_type = sanitize_inlist(synthetic_type, PLAYER_SYNTHS, initial(synthetic_type))
	synth_specialisation = sanitize_inlist(synth_specialisation, list("Generalised", "Engineering", "Medical", "Intel", "Military Police", "Command", "Research"), initial(synth_specialisation))
	predator_name = predator_name ? sanitize_text(predator_name, initial(predator_name)) : initial(predator_name)
	predator_gender = sanitize_text(predator_gender, initial(predator_gender))
	predator_age = sanitize_integer(predator_age, 100, 10000, initial(predator_age))
	predator_use_legacy = sanitize_inlist(predator_use_legacy, PRED_LEGACIES, initial(predator_use_legacy))
	predator_use_unique = sanitize_inlist(predator_use_unique, PRED_UNIQUES, initial(predator_use_unique))
	predator_translator_type = sanitize_inlist(predator_translator_type, PRED_TRANSLATORS, initial(predator_translator_type))
	predator_invisibility_sound = sanitize_inlist(predator_invisibility_sound, PRED_INVIS_SOUNDS, initial(predator_invisibility_sound))
	predator_mask_type = sanitize_integer(predator_mask_type,1,1000000,initial(predator_mask_type))
	predator_accessory_type = sanitize_integer(predator_accessory_type,0,3, initial(predator_accessory_type))
	predator_armor_type = sanitize_integer(predator_armor_type,1,1000000,initial(predator_armor_type))
	predator_boot_type = sanitize_integer(predator_boot_type,1,1000000,initial(predator_boot_type))
	predator_mask_material = sanitize_inlist(predator_mask_material, PRED_MATERIALS, initial(predator_mask_material))
	predator_armor_material = sanitize_inlist(predator_armor_material, PRED_MATERIALS, initial(predator_armor_material))
	predator_greave_material = sanitize_inlist(predator_greave_material, PRED_MATERIALS, initial(predator_greave_material))
	predator_caster_material = sanitize_inlist(predator_caster_material, PRED_RETRO_MATERIALS, initial(predator_caster_material))
	predator_bracer_material = sanitize_inlist(predator_bracer_material, PRED_RETRO_MATERIALS, initial(predator_bracer_material))
	predator_cape_color = sanitize_hexcolor(predator_cape_color, initial(predator_cape_color))
	predator_h_style = sanitize_inlist(predator_h_style, GLOB.yautja_hair_styles_list, initial(predator_h_style))
	predator_skin_color = sanitize_inlist(predator_skin_color, PRED_SKIN_COLOR, initial(predator_skin_color))
	predator_flavor_text = predator_flavor_text ? sanitize_text(predator_flavor_text, initial(predator_flavor_text)) : initial(predator_flavor_text)
	commander_status = sanitize_inlist(commander_status, GLOB.whitelist_hierarchy, initial(commander_status))
	commander_sidearm   = sanitize_inlist(commander_sidearm, (CO_GUNS + COUNCIL_CO_GUNS), initial(commander_sidearm))
	co_career_path = sanitize_inlist(co_career_path, list("Infantry", "Engineering", "Medical", "Intel", "Logistics", "Aviation", "Tanker"), initial(co_career_path))
	affiliation = sanitize_inlist(affiliation, FACTION_ALLEGIANCE_USCM_COMMANDER, initial(affiliation))
	yautja_status = sanitize_inlist(yautja_status, GLOB.whitelist_hierarchy + list("Elder"), initial(yautja_status))
	synth_status = sanitize_inlist(synth_status, GLOB.whitelist_hierarchy, initial(synth_status))

	window_scale = sanitize_integer(window_scale, FALSE, TRUE, initial(window_scale))
	tgui_lock = sanitize_integer(tgui_lock, FALSE, TRUE, initial(tgui_lock))
	tgui_fancy = sanitize_integer(tgui_fancy, FALSE, TRUE, initial(tgui_fancy))

	fax_name_uscm = fax_name_uscm ? sanitize_text(fax_name_uscm, initial(fax_name_uscm)) : generate_name(FACTION_MARINE)
	fax_name_pvst = fax_name_pvst ? sanitize_text(fax_name_pvst, initial(fax_name_pvst)) : generate_name(FACTION_MARINE)
	fax_name_wy = fax_name_wy ? sanitize_text(fax_name_wy, initial(fax_name_wy)) : generate_name(FACTION_WY)
	fax_name_upp = fax_name_upp ? sanitize_text(fax_name_upp, initial(fax_name_upp)) : generate_name(FACTION_UPP)
	fax_name_twe = fax_name_twe ? sanitize_text(fax_name_twe, initial(fax_name_twe)) : generate_name(FACTION_TWE)
	fax_name_cmb = fax_name_cmb ? sanitize_text(fax_name_cmb, initial(fax_name_cmb)) : generate_name(FACTION_MARSHAL)
	fax_name_press = fax_name_press ? sanitize_text(fax_name_press, initial(fax_name_press)) : generate_name(FACTION_COLONIST)
	fax_name_clf = fax_name_clf ? sanitize_text(fax_name_clf, initial(fax_name_clf)) : generate_name(FACTION_CLF)

	ff_log_color = sanitize_hexcolor(ff_log_color, initial(ff_log_color))
	ffd_log_color = sanitize_hexcolor(ffd_log_color, initial(ffd_log_color))

	key_bindings = sanitize_keybindings(key_bindings)
	hotkeys = sanitize_integer(hotkeys, FALSE, TRUE, TRUE)
	custom_cursors = sanitize_integer(custom_cursors, FALSE, TRUE, TRUE)
	pref_special_job_options = sanitize_islist(pref_special_job_options, list())
	pref_job_slots = sanitize_islist(pref_job_slots, list())

	loadout = sanitize_loadout(loadout, owner)
	loadout_slot_names = sanitize_islist(loadout_slot_names, list())

	show_cooldown_messages = sanitize_integer(show_cooldown_messages, FALSE, TRUE, FALSE)

	chem_presets = sanitize_islist(chem_presets, list())

	if(!observer_huds)
		observer_huds = list("Medical HUD" = FALSE, "Security HUD" = FALSE, "Squad HUD" = FALSE, "Xeno Status HUD" = FALSE, "Hunter HUD"= FALSE, HUD_MENTOR_SIGHT = FALSE)

	volume_preferences = sanitize_volume_preferences(volume_preferences, list(1, 0.5, 1, 0.6)) // Game, music, admin midis, lobby music

	if(!islist(custom_keybinds))
		custom_keybinds = new /list(KEYBIND_CUSTOM_MAX)

	if(length(custom_keybinds) != KEYBIND_CUSTOM_MAX)
		custom_keybinds.len = KEYBIND_CUSTOM_MAX

/// Assigns the generals preferences and will by default write to disk
/datum/preferences/proc/save_preferences(write=TRUE)
	if(!savefile)
		CRASH("Attempted to save the preferences of [owner] without a savefile. This should have been handled by load_preferences()")

	savefile.tree["version"] = savefile_version

	//general preferences
	savefile.tree["ooccolor"] = ooccolor
	savefile.tree["lastchangelog"] = lastchangelog
	savefile.tree["UI_style"] = UI_style
	savefile.tree["UI_style_color"] = UI_style_color
	savefile.tree["UI_style_alpha"] = UI_style_alpha
	savefile.tree["tgui_say"] = tgui_say
	savefile.tree["item_animation_pref_level"] = item_animation_pref_level
	savefile.tree["pain_overlay_pref_level"] = pain_overlay_pref_level
	savefile.tree["flash_overlay_pref"] = flash_overlay_pref
	savefile.tree["crit_overlay_pref"] = crit_overlay_pref
	savefile.tree["allow_flashing_lights_pref"] = allow_flashing_lights_pref
	savefile.tree["stylesheet"] = stylesheet
	savefile.tree["be_special"] = be_special
	savefile.tree["default_slot"] = default_slot
	savefile.tree["toggles_chat"] = toggles_chat
	savefile.tree["chat_display_preferences"] = chat_display_preferences
	savefile.tree["toggles_ghost"] = toggles_ghost
	savefile.tree["toggles_langchat"] = toggles_langchat
	savefile.tree["toggles_sound"] = toggles_sound
	savefile.tree["volume_preferences"] = volume_preferences
	savefile.tree["toggle_prefs"] = toggle_prefs
	savefile.tree["xeno_ability_click_mode"] = xeno_ability_click_mode
	savefile.tree["dual_wield_pref"] = dual_wield_pref
	savefile.tree["toggles_flashing"] = toggles_flashing
	savefile.tree["toggles_ert"] = toggles_ert
	savefile.tree["toggles_survivor"] = toggles_survivor
	savefile.tree["toggles_insert"] = toggles_insert
	savefile.tree["toggles_ert_pred"] = toggles_ert_pred
	savefile.tree["toggles_admin"] = toggles_admin
	savefile.tree["window_skin"] = window_skin
	savefile.tree["fps"] = fps
	savefile.tree["ghost_vision_pref"] = ghost_vision_pref
	savefile.tree["ghost_orbit"] = ghost_orbit
	savefile.tree["auto_observe"] = auto_observe
	savefile.tree["CMTV_toggle_optout"] = CMTV_toggle_optout

	savefile.tree["human_name_ban"] = human_name_ban

	savefile.tree["xeno_prefix"] = xeno_prefix
	savefile.tree["xeno_postfix"] = xeno_postfix
	savefile.tree["xeno_name_ban"] = xeno_name_ban
	savefile.tree["xeno_vision_level_pref"] = xeno_vision_level_pref
	savefile.tree["xeno_defensive_grab_pref"] = xeno_defensive_grab_pref
	savefile.tree["playtime_perks"] = playtime_perks
	savefile.tree["skip_playtime_ranks"] = skip_playtime_ranks
	savefile.tree["show_queen_name"] = show_queen_name
	savefile.tree["show_minimap_ceiling_protection"] = show_minimap_ceiling_protection

	savefile.tree["view_controller"] = View_MC
	savefile.tree["observer_huds"] = observer_huds
	savefile.tree["pref_special_job_options"] = pref_special_job_options
	savefile.tree["pref_job_slots"] = pref_job_slots

	savefile.tree["synth_name"] = synthetic_name
	savefile.tree["synth_type"] = synthetic_type
	savefile.tree["synth_specialisation"] = synth_specialisation
	savefile.tree["pred_name"] = predator_name
	savefile.tree["pred_gender"] = predator_gender
	savefile.tree["pred_age"] = predator_age
	savefile.tree["pred_use_legacy"] = predator_use_legacy
	savefile.tree["pred_use_unique"] = predator_use_unique
	savefile.tree["pred_trans_type"] = predator_translator_type
	savefile.tree["pred_invis_sound"] = predator_invisibility_sound
	savefile.tree["pred_mask_type"] = predator_mask_type
	savefile.tree["pred_accessory_type"] = predator_accessory_type
	savefile.tree["pred_armor_type"] = predator_armor_type
	savefile.tree["pred_boot_type"] = predator_boot_type
	savefile.tree["pred_mask_mat"] = predator_mask_material
	savefile.tree["pred_armor_mat"] = predator_armor_material
	savefile.tree["pred_greave_mat"] = predator_greave_material
	savefile.tree["pred_caster_mat"] = predator_caster_material
	savefile.tree["pred_bracer_mat"] = predator_bracer_material
	savefile.tree["pred_cape_color"] = predator_cape_color
	savefile.tree["pred_h_style"] = predator_h_style
	savefile.tree["pred_skin_color"] = predator_skin_color
	savefile.tree["pred_flavor_text"] = predator_flavor_text

	savefile.tree["commander_status"] = commander_status
	savefile.tree["co_sidearm"] = commander_sidearm
	savefile.tree["co_command_path"] = co_career_path
	savefile.tree["co_affiliation"] = affiliation
	savefile.tree["yautja_status"] = yautja_status
	savefile.tree["synth_status"] = synth_status

	savefile.tree["fax_name_uscm"] = fax_name_uscm
	savefile.tree["fax_name_pvst"] = fax_name_pvst
	savefile.tree["fax_name_wy"] = fax_name_wy
	savefile.tree["fax_name_upp"] = fax_name_upp
	savefile.tree["fax_name_twe"] = fax_name_twe
	savefile.tree["fax_name_cmb"] = fax_name_cmb
	savefile.tree["fax_name_press"] = fax_name_press
	savefile.tree["fax_name_clf"] = fax_name_clf

	savefile.tree["ff_log_color"] = ff_log_color
	savefile.tree["ffd_log_color"] = ffd_log_color

	savefile.tree["lang_chat_disabled"] = lang_chat_disabled
	savefile.tree["show_permission_errors"] = show_permission_errors
	savefile.tree["key_bindings"] = key_bindings
	savefile.tree["hotkeys"] = hotkeys

	savefile.tree["autofit_viewport"] = auto_fit_viewport
	savefile.tree["adaptive_zoom"] = adaptive_zoom

	savefile.tree["hear_vox"] = hear_vox

	savefile.tree["hide_statusbar"] = hide_statusbar
	savefile.tree["no_radials_preference"] = no_radials_preference
	savefile.tree["no_radial_labels_preference"] = no_radial_labels_preference
	savefile.tree["custom_cursors"] = custom_cursors

	savefile.tree["completed_tutorials"] = tutorial_list_to_savestring()

	savefile.tree["lastchangelog"] = lastchangelog

	savefile.tree["job_loadout"] = save_loadout(loadout)
	savefile.tree["job_loadout_names"] = loadout_slot_names

	savefile.tree["tgui_fancy"] = tgui_fancy
	savefile.tree["tgui_lock"] = tgui_lock
	savefile.tree["window_scale"] = window_scale

	savefile.tree["show_cooldown_messages"] = show_cooldown_messages

	savefile.tree["chem_presets"] = chem_presets

	savefile.tree["custom_keybinds"] = custom_keybinds

	if(write)
		savefile.save()

	return TRUE

/// Attempts to load a character slot, will update default_slot if needed, and sanitizes character values
/datum/preferences/proc/load_character(slot)
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		savefile.tree["default_slot"] = slot

	var/tree_key = "character[slot]"
	var/list/save_data = savefile.tree[tree_key]
	if(islist(save_data))
		//Character
		metadata = save_data["OOC_Notes"]
		real_name = save_data["real_name"]
		be_random_name = save_data["name_is_always_random"]
		be_random_body = save_data["body_is_always_random"]
		gender = save_data["gender"]
		age = save_data["age"]
		ethnicity = save_data["ethnicity"]
		skin_color = save_data["skin_color"]
		body_type = save_data["body_type"]
		body_size = save_data["body_size"]
		body_presentation = save_data["body_presentation"]
		language = save_data["language"]
		spawnpoint = save_data["spawnpoint"]

		//colors to be consolidated into hex strings (requires some work with dna code)
		r_hair = save_data["hair_red"]
		g_hair = save_data["hair_green"]
		b_hair = save_data["hair_blue"]
		r_gradient = save_data["grad_red"]
		g_gradient = save_data["grad_green"]
		b_gradient = save_data["grad_blue"]
		r_facial = save_data["facial_red"]
		g_facial = save_data["facial_green"]
		b_facial = save_data["facial_blue"]
		r_skin = save_data["skin_red"]
		g_skin = save_data["skin_green"]
		b_skin = save_data["skin_blue"]
		h_style = save_data["hair_style_name"]
		grad_style = save_data["hair_gradient_name"]
		f_style = save_data["facial_style_name"]
		r_eyes = save_data["eyes_red"]
		g_eyes = save_data["eyes_green"]
		b_eyes = save_data["eyes_blue"]
		underwear = save_data["underwear"]
		undershirt = save_data["undershirt"]
		backbag = save_data["backbag"]
		//blood_type = save_data["blood_type"]

		//Jobs
		alternate_option = save_data["alternate_option"]
		job_preference_list = save_data["job_preference_list"]

		//Flavour Text
		flavor_texts["general"] = save_data["flavor_texts_general"]
		flavor_texts["head"] = save_data["flavor_texts_head"]
		flavor_texts["face"] = save_data["flavor_texts_face"]
		flavor_texts["eyes"] = save_data["flavor_texts_eyes"]
		flavor_texts["torso"] = save_data["flavor_texts_torso"]
		flavor_texts["arms"] = save_data["flavor_texts_arms"]
		flavor_texts["hands"] = save_data["flavor_texts_hands"]
		flavor_texts["legs"] = save_data["flavor_texts_legs"]
		flavor_texts["feet"] = save_data["flavor_texts_feet"]
		flavor_texts["helmet"] = save_data["flavor_texts_helmet"]
		flavor_texts["armor"] = save_data["flavor_texts_armor"]

		//Miscellaneous
		med_record = save_data["med_record"]
		sec_record = save_data["sec_record"]
		gen_record = save_data["gen_record"]
		organ_data = save_data["organ_data"]
		gear = save_data["gear"]
		origin = save_data["origin"]
		faction = save_data["faction"]
		religion = save_data["religion"]
		traits = save_data["traits"]

		preferred_squad = save_data["preferred_squad"]
		preferred_spec = save_data["preferred_spec"]
		preferred_armor = save_data["preferred_armor"]
		night_vision_preference = save_data["night_vision_preference"]
		weyland_yutani_relation = save_data["weyland_yutani_relation"]
		//skin_style = save_data["skin_style"]

		uplinklocation = save_data["uplinklocation"]
		exploit_record = save_data["exploit_record"]

	//Sanitize
	metadata = sanitize_text(metadata, initial(metadata))
	real_name = reject_bad_name(real_name)

	if(isnull(language))
		language = "None"
	if(isnull(spawnpoint))
		spawnpoint = "Arrivals Shuttle"
	if(isnull(weyland_yutani_relation))
		weyland_yutani_relation = initial(weyland_yutani_relation)
	if(!real_name)
		real_name = random_name(gender)
	be_random_name = sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
	be_random_body = sanitize_integer(be_random_body, 0, 1, initial(be_random_body))
	gender = sanitize_gender(gender)
	body_presentation = sanitize_gender(body_presentation)
	age = sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	skin_color = sanitize_skin_color(skin_color)
	body_type = sanitize_body_type(body_type)
	body_size = sanitize_body_size(body_size)
	r_hair = sanitize_integer(r_hair, 0, 255, initial(r_hair))
	g_hair = sanitize_integer(g_hair, 0, 255, initial(g_hair))
	b_hair = sanitize_integer(b_hair, 0, 255, initial(b_hair))
	r_facial = sanitize_integer(r_facial, 0, 255, initial(r_facial))
	g_facial = sanitize_integer(g_facial, 0, 255, initial(g_facial))
	b_facial = sanitize_integer(b_facial, 0, 255, initial(b_facial))
	r_skin = sanitize_integer(r_skin, 0, 255, initial(r_skin))
	g_skin = sanitize_integer(g_skin, 0, 255, initial(g_skin))
	b_skin = sanitize_integer(b_skin, 0, 255, initial(b_skin))
	h_style = sanitize_inlist(h_style, GLOB.hair_styles_list, initial(h_style))
	r_gradient = sanitize_integer(r_gradient, 0, 255, initial(r_gradient))
	g_gradient = sanitize_integer(g_gradient, 0, 255, initial(g_gradient))
	b_gradient = sanitize_integer(b_gradient, 0, 255, initial(b_gradient))
	grad_style = sanitize_inlist(grad_style, GLOB.hair_gradient_list, initial(grad_style))
	var/datum/sprite_accessory/hair_style_datum = GLOB.hair_styles_list[h_style]
	if(!hair_style_datum.selectable) // shouldn't be using this hair
		h_style = random_hair_style(gender, species)
	f_style = sanitize_inlist(f_style, GLOB.facial_hair_styles_list, initial(f_style))
	var/datum/sprite_accessory/facial_style_datum = GLOB.facial_hair_styles_list[f_style]
	if(!facial_style_datum.selectable) // shouldn't be using this hair
		f_style = random_facial_hair_style(gender, species)
	r_eyes = sanitize_integer(r_eyes, 0, 255, initial(r_eyes))
	g_eyes = sanitize_integer(g_eyes, 0, 255, initial(g_eyes))
	b_eyes = sanitize_integer(b_eyes, 0, 255, initial(b_eyes))
	underwear = sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear))
	undershirt = sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))
	backbag = sanitize_integer(backbag, 1, length(GLOB.backbaglist), initial(backbag))
	preferred_armor = sanitize_inlist(preferred_armor, GLOB.armor_style_list, "Random")
	night_vision_preference = sanitize_inlist(night_vision_preference, GLOB.nvg_color_list, "Green")
	//blood_type = sanitize_text(blood_type, initial(blood_type))

	alternate_option = sanitize_integer(alternate_option, 0, 3, initial(alternate_option))
	if(!job_preference_list)
		ResetJobs()
	else
		for(var/job in job_preference_list)
			job_preference_list[job] = sanitize_integer(job_preference_list[job], 0, 3, initial(job_preference_list[job]))

	check_slot_prefs()

	if(!organ_data)
		organ_data = list()

	gear = sanitize_gear(gear, owner)

	traits = sanitize_list(traits)
	read_traits = FALSE
	trait_points = initial(trait_points)

	if(!origin)
		origin = ORIGIN_USCM
	if(!faction)
		faction = "None"
	if(!religion)
		religion = RELIGION_AGNOSTICISM
	if(!preferred_squad)
		preferred_squad = "None"
	preferred_spec = sanitize_list(preferred_spec, allow=GLOB.specialist_set_name_dict)

	return TRUE

/// Assigns the save data for the character in default_slot but notably does not write to disk by default
/datum/preferences/proc/save_character(write=FALSE)
	if(!path)
		return FALSE

	var/tree_key = "character[default_slot]"
	if(!(tree_key in savefile.tree))
		savefile.tree[tree_key] = list()
	var/save_data = savefile.tree[tree_key]

	//Character
	save_data["OOC_Notes"] = metadata
	save_data["real_name"] = real_name
	save_data["name_is_always_random"] = be_random_name
	save_data["body_is_always_random"] = be_random_body
	save_data["gender"] = gender
	save_data["age"] = age
	save_data["ethnicity"] = ethnicity
	save_data["skin_color"] = skin_color
	save_data["body_type"] = body_type
	save_data["body_size"] = body_size
	save_data["body_presentation"] = body_presentation
	save_data["language"] = language
	save_data["hair_red"] = r_hair
	save_data["hair_green"] = g_hair
	save_data["hair_blue"] = b_hair
	save_data["grad_red"] = r_gradient
	save_data["grad_green"] = g_gradient
	save_data["grad_blue"] = b_gradient
	save_data["facial_red"] = r_facial
	save_data["facial_green"] = g_facial
	save_data["facial_blue"] = b_facial
	save_data["skin_red"] = r_skin
	save_data["skin_green"] = g_skin
	save_data["skin_blue"] = b_skin
	save_data["hair_style_name"] = h_style
	save_data["hair_gradient_name"] = grad_style
	save_data["facial_style_name"] = f_style
	save_data["eyes_red"] = r_eyes
	save_data["eyes_green"] = g_eyes
	save_data["eyes_blue"] = b_eyes
	save_data["underwear"] = underwear
	save_data["undershirt"] = undershirt
	save_data["backbag"] = backbag
	//save_data["blood_type"] = blood_type
	save_data["spawnpoint"] = spawnpoint

	//Jobs
	save_data["alternate_option"] = alternate_option
	save_data["job_preference_list"] = job_preference_list

	//Flavour Text
	save_data["flavor_texts_general"] = flavor_texts["general"]
	save_data["flavor_texts_head"] = flavor_texts["head"]
	save_data["flavor_texts_face"] = flavor_texts["face"]
	save_data["flavor_texts_eyes"] = flavor_texts["eyes"]
	save_data["flavor_texts_torso"] = flavor_texts["torso"]
	save_data["flavor_texts_arms"] = flavor_texts["arms"]
	save_data["flavor_texts_hands"] = flavor_texts["hands"]
	save_data["flavor_texts_legs"] = flavor_texts["legs"]
	save_data["flavor_texts_feet"] = flavor_texts["feet"]
	save_data["flavor_texts_helmet"] = flavor_texts["helmet"]
	save_data["flavor_texts_armor"] = flavor_texts["armor"]

	//Miscellaneous
	save_data["med_record"] = med_record
	save_data["sec_record"] = sec_record
	save_data["gen_record"] = gen_record
	save_data["organ_data"] = organ_data
	save_data["gear"] = save_gear(gear)
	save_data["job_loadout"] = save_loadout(loadout)
	save_data["origin"] = origin
	save_data["faction"] = faction
	save_data["religion"] = religion
	save_data["traits"] = traits

	save_data["weyland_yutani_relation"] = weyland_yutani_relation
	save_data["preferred_squad"] = preferred_squad
	save_data["preferred_spec"] = preferred_spec
	save_data["preferred_armor"] = preferred_armor
	save_data["night_vision_preference"] = night_vision_preference
	//save_data["skin_style"] = skin_style

	save_data["uplinklocation"] = uplinklocation
	save_data["exploit_record"] = exploit_record

	if(write)
		savefile.save()

	return TRUE

/// checks through keybindings for outdated unbound keys and updates them
/datum/preferences/proc/check_keybindings()
	if(!owner)
		return
	var/list/user_binds = list()
	for(var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)
	var/list/notadded = list()
	for(var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		if(length(user_binds[kb.name]))
			continue // key is unbound and or bound to something
		var/addedbind = FALSE
		if(hotkeys)
			for(var/hotkeytobind in kb.hotkey_keys)
				if(!length(key_bindings[hotkeytobind]) || hotkeytobind == "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					LAZYADD(key_bindings[hotkeytobind], kb.name)
					addedbind = TRUE
		else
			for(var/classickeytobind in kb.classic_keys)
				if(!length(key_bindings[classickeytobind]) || classickeytobind == "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					LAZYADD(key_bindings[classickeytobind], kb.name)
					addedbind = TRUE
		if(!addedbind)
			notadded += kb

	if(length(notadded))
		addtimer(CALLBACK(src, PROC_REF(announce_conflict), notadded), 5 SECONDS)

/// Checks if any job selected has a loadout, and if this is not selected, prompt the user to select it on the lobby screen
/datum/preferences/proc/check_slot_prefs()
	errors = list()

	for(var/job in GLOB.roles_with_gear)
		if(!job_preference_list[job])
			continue

		if(has_loadout_for_role(job))
			continue

		errors += "Job [job] has loadout available, but none has been selected."

/datum/preferences/proc/announce_conflict(list/notadded)
	to_chat(owner, SPAN_ALERTWARNING("<u>Keybinding Conflict</u>"))
	to_chat(owner, SPAN_ALERTWARNING("There are new <a href='byond://?_src_=prefs;preference=viewmacros'>keybindings</a> that default to keys you've already bound. The new ones will be unbound."))
	for(var/datum/keybinding/conflicted as anything in notadded)
		to_chat(owner, SPAN_DANGER("[conflicted.category]: [conflicted.full_name] needs updating."))

		if(hotkeys)
			for(var/entry in conflicted.hotkey_keys)
				LAZYREMOVE(key_bindings[entry], conflicted.name)
		else
			for(var/entry in conflicted.classic_keys)
				LAZYREMOVE(key_bindings[entry], conflicted.name)

		LAZYADD(key_bindings["Unbound"], conflicted.name) // set it to unbound to prevent this from opening up again in the future

/datum/preferences/proc/load_custom_keybinds()
	key_to_custom_keybind = list()

	for(var/keybind in custom_keybinds)
		if(!("keybinding" in keybind))
			continue // unbound

		var/datum/keybinding/custom/custom_key = new
		custom_key.keybind_type = keybind["type"]
		custom_key.contents = keybind["contents"]
		custom_key.when_human = keybind["when_human"]
		custom_key.when_xeno = keybind["when_xeno"]
		custom_key.when_yautja = keybind["when_yautja"]
		custom_key.when_synth = keybind["when_synth"]

		key_to_custom_keybind[keybind["keybinding"]] = custom_key

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
