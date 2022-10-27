#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	18

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefile_update(savefile/S)
	if(!isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN)	//lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in preferences_datums)
			var/datum/preferences/D = preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return 0

	if(savefile_version < 12) //we've split toggles into toggles_sound and toggles_chat
		S["toggles_sound"] << TOGGLES_SOUND_DEFAULT
		S["toggles_chat"] << TOGGLES_CHAT_DEFAULT

	if(savefile_version < 13)
		var/sound_toggles
		S["toggles_sound"] >> sound_toggles
		sound_toggles |= SOUND_INTERNET
		S["toggles_sound"] << sound_toggles

	if(savefile_version < 14) //toggle unnest flashing on by default
		var/flash_toggles
		S["toggles_flashing"] >> flash_toggles
		flash_toggles |= FLASH_UNNEST
		S["toggles_flashing"] << flash_toggles

	if(savefile_version < 15) //toggles on membership publicity by default because forgot to six months ago
		var/pref_toggles
		S["toggle_prefs"] >> pref_toggles
		pref_toggles |= TOGGLE_MEMBER_PUBLIC
		S["toggle_prefs"] << pref_toggles

	if(savefile_version < 16) //toggle unpool flashing on by default
		var/flash_toggles_two
		S["toggles_flashing"] >> flash_toggles_two
		flash_toggles_two |= FLASH_POOLSPAWN
		S["toggles_flashing"] << flash_toggles_two

	if(savefile_version < 17) //toggle middle click swap hands on by default
		var/pref_middle_click_swap
		S["toggle_prefs"] >> pref_middle_click_swap
		pref_middle_click_swap |= TOGGLE_MIDDLE_MOUSE_SWAP_HANDS
		S["toggle_prefs"] << pref_middle_click_swap

	if(savefile_version < 17) //remove omniglots
		var/list/language_traits = list()
		S["traits"] >> language_traits
		if(language_traits)
			if(language_traits.len > 1)
				language_traits = null
		S["traits"] << language_traits

	if(savefile_version < 18) // adds ambient occlusion by default
		var/pref_toggles
		S["toggle_prefs"] >> pref_toggles
		pref_toggles |= TOGGLE_AMBIENT_OCCLUSION
		S["toggle_prefs"] << pref_toggles

	savefile_version = SAVEFILE_VERSION_MAX
	return 1

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/proc/sanitize_keybindings(value)
	var/list/base_bindings = sanitize_islist(value, null)
	if(!base_bindings)
		base_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key)
	for(var/key in base_bindings)
		base_bindings[key] = base_bindings[key] & GLOB.keybindings_by_name
		if(!length(base_bindings[key]))
			base_bindings -= key
	return base_bindings

/datum/preferences/proc/load_preferences()
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] >> savefile_version
	//Conversion
	if(!savefile_version || !isnum(savefile_version) || savefile_version != SAVEFILE_VERSION_MAX)
		if(!savefile_update(S))  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return 0

	//general preferences
	S["ooccolor"]			>> ooccolor
	S["lastchangelog"]		>> lastchangelog
	S["be_special"]			>> be_special
	S["default_slot"]		>> default_slot
	S["toggles_chat"]		>> toggles_chat
	S["chat_display_preferences"] >> chat_display_preferences
	S["toggles_ghost"]		>> toggles_ghost
	S["toggles_langchat"]	>> toggles_langchat
	S["toggles_sound"]		>> toggles_sound
	S["toggle_prefs"]		>> toggle_prefs
	S["toggles_flashing"]	>> toggles_flashing
	S["toggles_ert"]		>> toggles_ert
	S["UI_style"]			>> UI_style
	S["UI_style_color"]		>> UI_style_color
	S["UI_style_alpha"]		>> UI_style_alpha
	S["stylesheet"] 		>> stylesheet
	S["window_skin"]		>> window_skin
	S["fps"]				>> fps
	S["ghost_vision_pref"]	>> ghost_vision_pref
	S["ghost_orbit"]		>> ghost_orbit

	S["human_name_ban"] >> human_name_ban

	S["xeno_prefix"]		>> xeno_prefix
	S["xeno_postfix"]		>> xeno_postfix
	S["xeno_name_ban"]		>> xeno_name_ban
	S["playtime_perks"]		>> playtime_perks
	S["xeno_vision_level_pref"]		>> xeno_vision_level_pref
	S["view_controller"]	>> View_MC
	S["observer_huds"]		>> observer_huds

	S["synth_name"]			>> synthetic_name
	S["synth_type"]			>> synthetic_type
	S["pred_name"]			>> predator_name
	S["pred_gender"]		>> predator_gender
	S["pred_age"]			>> predator_age
	S["pred_trans_type"]	>> predator_translator_type
	S["pred_mask_type"]		>> predator_mask_type
	S["pred_armor_type"]	>> predator_armor_type
	S["pred_boot_type"]		>> predator_boot_type
	S["pred_mask_mat"]		>> predator_mask_material
	S["pred_armor_mat"]		>> predator_armor_material
	S["pred_greave_mat"]	>> predator_greave_material
	S["pred_caster_mat"]	>> predator_caster_material
	S["pred_cape_type"]		>> predator_cape_type
	S["pred_cape_color"]	>> predator_cape_color
	S["pred_h_style"]		>> predator_h_style
	S["pred_flavor_text"]	>> predator_flavor_text

	S["commander_status"]	>> commander_status
	S["co_sidearm"]			>> commander_sidearm
	S["yautja_status"]		>> yautja_status
	S["synth_status"]		>> synth_status
	S["key_bindings"] 		>> key_bindings

	S["grade_path"]			>> sea_path
	var/list/remembered_key_bindings
	S["remembered_key_bindings"] >> remembered_key_bindings

	S["lang_chat_disabled"]	>> lang_chat_disabled
	S["show_permission_errors"] >> show_permission_errors
	S["hear_vox"] >> hear_vox
	S["hide_statusbar"] >> hide_statusbar
	S["no_radials_preference"] >> no_radials_preference
	S["no_radial_labels_preference"] >> no_radial_labels_preference
	S["hotkeys"] >> hotkeys

	//Sanitize
	ooccolor		= sanitize_hexcolor(ooccolor, CONFIG_GET(string/ooc_color_default))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("white", "dark", "midnight", "orange", "old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	toggles_chat	= sanitize_integer(toggles_chat, 0, 65535, initial(toggles_chat))
	chat_display_preferences	= sanitize_integer(chat_display_preferences, 0, 65535, initial(chat_display_preferences))
	toggles_ghost	= sanitize_integer(toggles_ghost, 0, 65535, initial(toggles_ghost))
	toggles_langchat			= sanitize_integer(toggles_langchat, 0, 65535, initial(toggles_langchat))
	toggles_sound	= sanitize_integer(toggles_sound, 0, 65535, initial(toggles_sound))
	toggle_prefs	= sanitize_integer(toggle_prefs, 0, 65535, initial(toggle_prefs))
	toggles_flashing= sanitize_integer(toggles_flashing, 0, 65535, initial(toggles_flashing))
	toggles_ert		= sanitize_integer(toggles_ert, 0, 65535, initial(toggles_ert))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))
	window_skin		= sanitize_integer(window_skin, 0, 65535, initial(window_skin))
	ghost_vision_pref = sanitize_inlist(ghost_vision_pref, list(GHOST_VISION_LEVEL_NO_NVG, GHOST_VISION_LEVEL_MID_NVG, GHOST_VISION_LEVEL_FULL_NVG), GHOST_VISION_LEVEL_MID_NVG)
	ghost_orbit		= sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
	playtime_perks   = sanitize_integer(playtime_perks, 0, 1, 1)
	xeno_vision_level_pref = sanitize_inlist(xeno_vision_level_pref, list(XENO_VISION_LEVEL_NO_NVG, XENO_VISION_LEVEL_MID_NVG, XENO_VISION_LEVEL_FULL_NVG), XENO_VISION_LEVEL_MID_NVG)
	hear_vox  		= sanitize_integer(hear_vox, FALSE, TRUE, TRUE)
	hide_statusbar = sanitize_integer(hide_statusbar, FALSE, TRUE, FALSE)
	no_radials_preference = sanitize_integer(no_radials_preference, FALSE, TRUE, FALSE)
	no_radial_labels_preference = sanitize_integer(no_radial_labels_preference, FALSE, TRUE, FALSE)

	synthetic_name 		= synthetic_name ? sanitize_text(synthetic_name, initial(synthetic_name)) : initial(synthetic_name)
	synthetic_type		= sanitize_inlist(synthetic_type, PLAYER_SYNTHS, initial(synthetic_type))
	predator_name 		= predator_name ? sanitize_text(predator_name, initial(predator_name)) : initial(predator_name)
	predator_gender 	= sanitize_text(predator_gender, initial(predator_gender))
	predator_age 		= sanitize_integer(predator_age, 100, 10000, initial(predator_age))
	predator_translator_type = sanitize_inlist(predator_translator_type, PRED_TRANSLATORS, initial(predator_translator_type))
	predator_mask_type 	= sanitize_integer(predator_mask_type,1,1000000,initial(predator_mask_type))
	predator_armor_type = sanitize_integer(predator_armor_type,1,1000000,initial(predator_armor_type))
	predator_boot_type 	= sanitize_integer(predator_boot_type,1,1000000,initial(predator_boot_type))
	predator_mask_material = sanitize_inlist(predator_mask_material, PRED_MATERIALS, initial(predator_mask_material))
	predator_armor_material = sanitize_inlist(predator_armor_material, PRED_MATERIALS, initial(predator_armor_material))
	predator_greave_material = sanitize_inlist(predator_greave_material, PRED_MATERIALS, initial(predator_greave_material))
	predator_caster_material = sanitize_inlist(predator_caster_material, PRED_MATERIALS + "retro", initial(predator_caster_material))
	predator_cape_type = sanitize_inlist(predator_cape_type, GLOB.all_yautja_capes + "None", initial(predator_cape_type))
	predator_cape_color = sanitize_hexcolor(predator_cape_color, initial(predator_cape_color))
	predator_h_style = sanitize_inlist(predator_h_style, GLOB.yautja_hair_styles_list, initial(predator_h_style))
	predator_flavor_text = predator_flavor_text ? sanitize_text(predator_flavor_text, initial(predator_flavor_text)) : initial(predator_flavor_text)
	commander_status	= sanitize_inlist(commander_status, whitelist_hierarchy, initial(commander_status))
	commander_sidearm   = sanitize_inlist(commander_sidearm, list("Mateba","Colonel's Mateba","Golden Desert Eagle","Desert Eagle"), initial(commander_sidearm))
	sea_path			= sanitize_inlist(sea_path, list("Command", "Technical"), initial(sea_path))
	yautja_status		= sanitize_inlist(yautja_status, whitelist_hierarchy + list("Elder"), initial(yautja_status))
	synth_status		= sanitize_inlist(synth_status, whitelist_hierarchy, initial(synth_status))
	key_bindings 		= sanitize_keybindings(key_bindings)
	remembered_key_bindings = sanitize_islist(remembered_key_bindings, null)
	hotkeys  			= sanitize_integer(hotkeys, FALSE, TRUE, TRUE)
	vars["fps"] = fps

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

	S["remembered_key_bindings"] << GLOB.keybindings_by_name

	if(!observer_huds)
		observer_huds = list("Medical HUD" = FALSE, "Security HUD" = FALSE, "Squad HUD" = FALSE, "Xeno Status HUD" = FALSE)

	return 1

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	S["version"] << savefile_version

	//general preferences
	S["ooccolor"]			<< ooccolor
	S["lastchangelog"]		<< lastchangelog
	S["UI_style"]			<< UI_style
	S["UI_style_color"]		<< UI_style_color
	S["UI_style_alpha"]		<< UI_style_alpha
	S["stylesheet"] 		<< stylesheet
	S["be_special"]			<< be_special
	S["default_slot"]		<< default_slot
	S["toggles_chat"]		<< toggles_chat
	S["chat_display_preferences"] << chat_display_preferences
	S["toggles_ghost"]		<< toggles_ghost
	S["toggles_langchat"]	<< toggles_langchat
	S["toggles_sound"]		<< toggles_sound
	S["toggle_prefs"]		<< toggle_prefs
	S["toggles_flashing"]	<< toggles_flashing
	S["toggles_ert"]		<< toggles_ert
	S["window_skin"]		<< window_skin
	S["fps"]				<< fps
	S["ghost_vision_pref"]	<< ghost_vision_pref
	S["ghost_orbit"]		<< ghost_orbit

	S["human_name_ban"] << human_name_ban

	S["xeno_prefix"]		<< xeno_prefix
	S["xeno_postfix"]		<< xeno_postfix
	S["xeno_name_ban"]		<< xeno_name_ban
	S["xeno_vision_level_pref"]		<< xeno_vision_level_pref
	S["playtime_perks"] 		<< playtime_perks

	S["view_controller"]	<< View_MC
	S["observer_huds"]		<< observer_huds

	S["synth_name"] 		<< synthetic_name
	S["synth_type"]			<< synthetic_type
	S["pred_name"] 			<< predator_name
	S["pred_gender"] 		<< predator_gender
	S["pred_age"]			<< predator_age
	S["pred_trans_type"]	<< predator_translator_type
	S["pred_mask_type"] 	<< predator_mask_type
	S["pred_armor_type"] 	<< predator_armor_type
	S["pred_boot_type"] 	<< predator_boot_type
	S["pred_mask_mat"]		<< predator_mask_material
	S["pred_armor_mat"]		<< predator_armor_material
	S["pred_greave_mat"]	<< predator_greave_material
	S["pred_caster_mat"]	<< predator_caster_material
	S["pred_cape_type"]		<< predator_cape_type
	S["pred_cape_color"]	<< predator_cape_color
	S["pred_h_style"]		<< predator_h_style
	S["pred_flavor_text"]	<< predator_flavor_text

	S["commander_status"] 	<< commander_status
	S["co_sidearm"]			<< commander_sidearm
	S["yautja_status"]		<< yautja_status
	S["synth_status"]		<< synth_status
	S["grade_path"]			<< sea_path

	S["lang_chat_disabled"] << lang_chat_disabled
	S["show_permission_errors"] << show_permission_errors
	S["key_bindings"] << key_bindings
	S["hotkeys"] << hotkeys

	S["hear_vox"] << hear_vox

	S["hide_statusbar"] << hide_statusbar
	S["no_radials_preference"] << no_radials_preference
	S["no_radial_labels_preference"] << no_radial_labels_preference

	return TRUE

/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot
	slot = sanitize_integer(slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		S["default_slot"] << slot
	S.cd = "/character[slot]"

	//Character
	S["OOC_Notes"]			>> metadata
	S["real_name"]			>> real_name
	S["name_is_always_random"] >> be_random_name
	S["body_is_always_random"] >> be_random_body
	S["gender"]				>> gender
	S["age"]				>> age
	S["ethnicity"]			>> ethnicity
	S["body_type"]			>> body_type
	S["language"]			>> language
	S["spawnpoint"]			>> spawnpoint

	//colors to be consolidated into hex strings (requires some work with dna code)
	S["hair_red"]			>> r_hair
	S["hair_green"]			>> g_hair
	S["hair_blue"]			>> b_hair
	S["facial_red"]			>> r_facial
	S["facial_green"]		>> g_facial
	S["facial_blue"]		>> b_facial
	S["skin_red"]			>> r_skin
	S["skin_green"]			>> g_skin
	S["skin_blue"]			>> b_skin
	S["hair_style_name"]	>> h_style
	S["facial_style_name"]	>> f_style
	S["eyes_red"]			>> r_eyes
	S["eyes_green"]			>> g_eyes
	S["eyes_blue"]			>> b_eyes
	S["underwear"]			>> underwear
	S["undershirt"]			>> undershirt
	S["backbag"]			>> backbag
	//S["b_type"]				>> b_type

	//Jobs
	S["alternate_option"]		>> alternate_option
	S["job_preference_list"]	>> job_preference_list

	//Flavour Text
	S["flavor_texts_general"]	>> flavor_texts["general"]
	S["flavor_texts_head"]		>> flavor_texts["head"]
	S["flavor_texts_face"]		>> flavor_texts["face"]
	S["flavor_texts_eyes"]		>> flavor_texts["eyes"]
	S["flavor_texts_torso"]		>> flavor_texts["torso"]
	S["flavor_texts_arms"]		>> flavor_texts["arms"]
	S["flavor_texts_hands"]		>> flavor_texts["hands"]
	S["flavor_texts_legs"]		>> flavor_texts["legs"]
	S["flavor_texts_feet"]		>> flavor_texts["feet"]

	//Miscellaneous
	S["med_record"]			>> med_record
	S["sec_record"]			>> sec_record
	S["gen_record"]			>> gen_record
	S["be_special"]			>> be_special
	S["disabilities"]		>> disabilities
	S["organ_data"]			>> organ_data
	S["gear"]				>> gear
	S["home_system"] 		>> home_system
	S["citizenship"] 		>> citizenship
	S["faction"] 			>> faction
	S["religion"] 			>> religion
	S["traits"]				>> traits

	S["preferred_squad"]		>> preferred_squad
	S["nanotrasen_relation"] 	>> nanotrasen_relation
	//S["skin_style"]			>> skin_style

	S["uplinklocation"] >> uplinklocation
	S["exploit_record"]	>> exploit_record

	//Sanitize
	metadata		= sanitize_text(metadata, initial(metadata))
	real_name		= reject_bad_name(real_name)

	if(isnull(language)) language = "None"
	if(isnull(spawnpoint)) spawnpoint = "Arrivals Shuttle"
	if(isnull(nanotrasen_relation)) nanotrasen_relation = initial(nanotrasen_relation)
	if(!real_name)	real_name = random_name(gender)
	be_random_name	= sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
	be_random_body	= sanitize_integer(be_random_body, 0, 1, initial(be_random_body))
	gender			= sanitize_gender(gender)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	ethnicity		= sanitize_ethnicity(ethnicity)
	body_type		= sanitize_body_type(body_type)
	r_hair			= sanitize_integer(r_hair, 0, 255, initial(r_hair))
	g_hair			= sanitize_integer(g_hair, 0, 255, initial(g_hair))
	b_hair			= sanitize_integer(b_hair, 0, 255, initial(b_hair))
	r_facial		= sanitize_integer(r_facial, 0, 255, initial(r_facial))
	g_facial		= sanitize_integer(g_facial, 0, 255, initial(g_facial))
	b_facial		= sanitize_integer(b_facial, 0, 255, initial(b_facial))
	r_skin			= sanitize_integer(r_skin, 0, 255, initial(r_skin))
	g_skin			= sanitize_integer(g_skin, 0, 255, initial(g_skin))
	b_skin			= sanitize_integer(b_skin, 0, 255, initial(b_skin))
	h_style			= sanitize_inlist(h_style, GLOB.hair_styles_list, initial(h_style))
	var/datum/sprite_accessory/HS = GLOB.hair_styles_list[h_style]
	if(!HS.selectable)	// delete this
		h_style = random_hair_style(gender, species)
		save_character()
	f_style			= sanitize_inlist(f_style, GLOB.facial_hair_styles_list, initial(f_style))
	var/datum/sprite_accessory/FS = GLOB.facial_hair_styles_list[f_style]
	if(!FS.selectable)	// delete this
		f_style = random_facial_hair_style(gender, species)
		save_character()
	r_eyes			= sanitize_integer(r_eyes, 0, 255, initial(r_eyes))
	g_eyes			= sanitize_integer(g_eyes, 0, 255, initial(g_eyes))
	b_eyes			= sanitize_integer(b_eyes, 0, 255, initial(b_eyes))
	underwear	= sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear))
	undershirt		= sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))
	backbag			= sanitize_integer(backbag, 1, backbaglist.len, initial(backbag))
	//b_type			= sanitize_text(b_type, initial(b_type))

	alternate_option = sanitize_integer(alternate_option, 0, 3, initial(alternate_option))
	if(!job_preference_list)
		ResetJobs()
	else
		for(var/job in job_preference_list)
			job_preference_list[job] = sanitize_integer(job_preference_list[job], 0, 3, initial(job_preference_list[job]))

	if(isnull(disabilities))
		disabilities = 0
	if(!organ_data)
		organ_data = list()

	gear = sanitize_list(gear)

	traits = sanitize_list(traits)

	//if(!skin_style) skin_style = "Default"

	if(!home_system) home_system = "Unset"
	if(!citizenship) citizenship = CITIZENSHIP_US
	if(!faction)     faction =     "None"
	if(!religion)    religion =    RELIGION_AGNOSTICISM
	if(!preferred_squad)	preferred_squad = "None"

	return 1

/datum/preferences/proc/save_character()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[default_slot]"

	//Character
	S["OOC_Notes"]			<< metadata
	S["real_name"]			<< real_name
	S["name_is_always_random"] << be_random_name
	S["body_is_always_random"] << be_random_body
	S["gender"]				<< gender
	S["age"]				<< age
	S["ethnicity"]			<< ethnicity
	S["body_type"]			<< body_type
	S["language"]			<< language
	S["hair_red"]			<< r_hair
	S["hair_green"]			<< g_hair
	S["hair_blue"]			<< b_hair
	S["facial_red"]			<< r_facial
	S["facial_green"]		<< g_facial
	S["facial_blue"]		<< b_facial
	S["skin_red"]			<< r_skin
	S["skin_green"]			<< g_skin
	S["skin_blue"]			<< b_skin
	S["hair_style_name"]	<< h_style
	S["facial_style_name"]	<< f_style
	S["eyes_red"]			<< r_eyes
	S["eyes_green"]			<< g_eyes
	S["eyes_blue"]			<< b_eyes
	S["underwear"]			<< underwear
	S["undershirt"]			<< undershirt
	S["backbag"]			<< backbag
	//S["b_type"]				<< b_type
	S["spawnpoint"]			<< spawnpoint

	//Jobs
	S["alternate_option"]		<< alternate_option
	S["job_preference_list"]	<< job_preference_list

	//Flavour Text
	S["flavor_texts_general"]	<< flavor_texts["general"]
	S["flavor_texts_head"]		<< flavor_texts["head"]
	S["flavor_texts_face"]		<< flavor_texts["face"]
	S["flavor_texts_eyes"]		<< flavor_texts["eyes"]
	S["flavor_texts_torso"]		<< flavor_texts["torso"]
	S["flavor_texts_arms"]		<< flavor_texts["arms"]
	S["flavor_texts_hands"]		<< flavor_texts["hands"]
	S["flavor_texts_legs"]		<< flavor_texts["legs"]
	S["flavor_texts_feet"]		<< flavor_texts["feet"]

	//Miscellaneous
	S["med_record"]			<< med_record
	S["sec_record"]			<< sec_record
	S["gen_record"]			<< gen_record
	S["be_special"]			<< be_special
	S["disabilities"]		<< disabilities
	S["organ_data"]			<< organ_data
	S["gear"]				<< gear
	S["home_system"] 		<< home_system
	S["citizenship"] 		<< citizenship
	S["faction"] 			<< faction
	S["religion"] 			<< religion
	S["traits"]				<< traits

	S["nanotrasen_relation"] 	<< nanotrasen_relation
	S["preferred_squad"]		<< preferred_squad
	//S["skin_style"]			<< skin_style

	S["uplinklocation"] << uplinklocation
	S["exploit_record"]	<< exploit_record

	return 1


#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
