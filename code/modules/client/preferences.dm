#define MENU_MARINE "marine"
#define MENU_XENOMORPH "xeno"
#define MENU_CO "co"
#define MENU_SYNTHETIC "synth"
#define MENU_YAUTJA "yautja"
#define MENU_MENTOR "mentor"
#define MENU_SETTINGS "settings"
#define MENU_SPECIAL "special"

GLOBAL_LIST_EMPTY(preferences_datums)

GLOBAL_LIST_INIT(stylesheets, list(
	"Modern" = "common.css",
	"Legacy" = "legacy.css"
))

GLOBAL_LIST_INIT(bgstate_options, list(
	"blank",
	"outerhull",
	"sterile",
	"whitefull"
))

GLOBAL_LIST_INIT(be_special_flags, list(
	"Xenomorph after unrevivable death" = BE_ALIEN_AFTER_DEATH,
	"Agent" = BE_AGENT,
	"King" = BE_KING,
))

/datum/preferences
	var/client/owner
	var/atom/movable/screen/preview/preview_front
	var/mob/living/carbon/human/dummy/preview_dummy
	var/atom/movable/screen/rotate/alt/rotate_left
	var/atom/movable/screen/rotate/rotate_right

	var/static/datum/hair_picker/hair_picker = new
	var/static/datum/body_picker/body_picker = new
	var/static/datum/traits_picker/traits_picker = new
	var/static/datum/loadout_picker/loadout_picker = new

	var/static/datum/pred_picker/pred_picker = new

	//doohickeys for savefiles
	var/path
	var/default_slot = 1 //Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	var/tgui_say = TRUE
	var/tgui_say_light_mode = FALSE

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/fps = 60
	var/last_id
	var/save_cooldown = 0 //5s cooldown between saving slots
	var/reload_cooldown = 0 //5s cooldown between loading slots

	//game-preferences
	var/lastchangelog = "" // Saved changlog filesize to detect if there was a change
	var/ooccolor
	var/be_special = BE_KING // Special role selection
	var/toggle_prefs = TOGGLE_DIRECTIONAL_ATTACK|TOGGLE_MEMBER_PUBLIC|TOGGLE_AMBIENT_OCCLUSION|TOGGLE_VEND_ITEM_TO_HAND // flags in #define/mode.dm
	var/xeno_ability_click_mode = XENO_ABILITY_CLICK_MIDDLE
	var/auto_fit_viewport = FALSE
	var/adaptive_zoom = 0
	var/UI_style = "midnight"
	var/toggles_admin = TOGGLES_ADMIN_DEFAULT
	var/toggles_chat = TOGGLES_CHAT_DEFAULT
	var/toggles_ghost = TOGGLES_GHOST_DEFAULT
	var/toggles_langchat = TOGGLES_LANGCHAT_DEFAULT
	var/toggles_sound = TOGGLES_SOUND_DEFAULT
	var/toggles_flashing = TOGGLES_FLASHING_DEFAULT
	var/toggles_ert = TOGGLES_ERT_DEFAULT
	var/toggles_ert_pred = TOGGLES_ERT_GROUNDS
	var/list/volume_preferences = list(1, 0.5, 1, 0.6) // Game, music, admin midis, lobby music (this is also set in sanitize_volume_preferences() call)
	var/chat_display_preferences = CHAT_TYPE_ALL
	var/item_animation_pref_level = SHOW_ITEM_ANIMATIONS_ALL
	var/pain_overlay_pref_level = PAIN_OVERLAY_BLURRY
	var/flash_overlay_pref = FLASH_OVERLAY_WHITE
	var/crit_overlay_pref = CRIT_OVERLAY_WHITE
	var/allow_flashing_lights_pref = FALSE
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/View_MC = FALSE
	var/window_skin = 0
	var/list/observer_huds = list(
							"Medical HUD" = FALSE,
							"Security HUD" = FALSE,
							"Squad HUD" = FALSE,
							"Xeno Status HUD" = FALSE,
							HUD_MENTOR_SIGHT = FALSE
							)
	var/ghost_vision_pref = GHOST_VISION_LEVEL_MID_NVG
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/dual_wield_pref = DUAL_WIELD_FIRE

	//Synthetic specific preferences
	var/synthetic_name = "Undefined"
	var/synthetic_type = SYNTH_GEN_THREE
	//Predator specific preferences.
	var/predator_name = "Undefined"
	var/predator_gender = MALE
	var/predator_age = 100
	var/predator_h_style = "Standard"
	var/predator_skin_color = "tan"
	var/predator_use_legacy = "None"
	var/predator_translator_type = "Modern"
	var/predator_mask_type = 1
	var/predator_accessory_type = 0
	var/predator_armor_type = 1
	var/predator_boot_type = 1
	var/predator_armor_material = "ebony"
	var/predator_mask_material = "ebony"
	var/predator_greave_material = "ebony"
	var/predator_caster_material = "ebony"
	var/predator_cape_color = "#654321"
	var/predator_flavor_text = ""
	//CO-specific preferences
	var/commander_sidearm = "Mateba"
	var/co_career_path = "Infantry"
	var/affiliation = "Unaligned"
	//SEA specific preferences

	///holds our preferred job options for jobs
	var/list/pref_special_job_options = list()
	///Holds assignment of character slots to jobs.
	var/list/pref_job_slots = list()

	//WL Council preferences.
	var/yautja_status = WHITELIST_NORMAL
	var/commander_status = WHITELIST_NORMAL
	var/synth_status = WHITELIST_NORMAL

	// Fax Responder Names
	var/fax_name_uscm
	var/fax_name_pvst
	var/fax_name_wy
	var/fax_name_upp
	var/fax_name_twe
	var/fax_name_cmb
	var/fax_name_press
	var/fax_name_clf

	//character preferences
	var/real_name //our character's name
	var/be_random_name = FALSE //whether we are a random name every round
	var/human_name_ban = FALSE


	var/be_random_body = 0 //whether we have a random appearance every round
	var/gender = MALE //gender of character (well duh)
	var/body_presentation

	var/age = 19 //age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/underwear = "Boxers (Camo Conforming)" //underwear type
	var/undershirt = "Undershirt (Tan)" //undershirt type
	var/backbag = 2 //backpack type
	var/preferred_armor = "Random" //preferred armor type (from their primary prep vendor)

	var/h_style = "Crewcut" //Hair type
	var/r_hair = 0 //Hair color
	var/g_hair = 0 //Hair color
	var/b_hair = 0 //Hair color

	var/grad_style = "None" //Hair Gradient type
	var/r_gradient = 0 //Hair Gradient color
	var/g_gradient = 0 //Hair Gradient color
	var/b_gradient = 0 //Hair Gradient color

	var/f_style = "Shaved" //Face hair type
	var/r_facial = 0 //Face hair color
	var/g_facial = 0 //Face hair color
	var/b_facial = 0 //Face hair color

	var/r_skin = 0 //Skin color
	var/g_skin = 0 //Skin color
	var/b_skin = 0 //Skin color
	var/r_eyes = 0 //Eye color
	var/g_eyes = 0 //Eye color
	var/b_eyes = 0 //Eye color
	var/species = "Human"    //Species datum to use.
	var/ethnicity = "Western" //Legacy, kept to update save files
	var/skin_color = "Pale 2" // Skin color
	var/body_size = "Average" // Body Size
	var/body_type = "Lean" // Body Type
	var/language = "None" //Secondary language
	var/preferred_squad = "None"
	var/night_vision_preference = "Green"
	var/list/nv_color_list = list(
						"Green" = NV_COLOR_GREEN,
						"White" = NV_COLOR_WHITE,
						"Yellow" = NV_COLOR_YELLOW,
						"Orange" = NV_COLOR_ORANGE,
						"Red" = NV_COLOR_RED,
						"Blue" = NV_COLOR_BLUE
					)
		//Some faction information.
	var/origin = ORIGIN_USCM
	var/faction = "None" //Antag faction/general associated faction.
	var/religion = RELIGION_AGNOSTICISM  //Religious association.

		//Mob preview
	var/icon/preview_icon = null
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

		//Jobs, uses bitflags
	var/list/job_preference_list = list()

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = RETURN_TO_LOBBY //Be a marine.

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()

	var/list/flavor_texts = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	var/weyland_yutani_relation = "Neutral"

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

	// XENO NAMES
	var/xeno_prefix = "XX"
	var/xeno_postfix = ""
	var/xeno_name_ban = FALSE
	var/xeno_vision_level_pref = XENO_VISION_LEVEL_MID_NVG
	var/playtime_perks = TRUE
	var/show_queen_name = FALSE

	var/stylesheet = "Modern"

	var/lang_chat_disabled = FALSE

	var/show_permission_errors = TRUE

	var/key_buf // A buffer for setting macro keybinds
	var/list/key_mod_buf // A buffer for macro modifiers

	var/hotkeys = TRUE
	var/list/key_bindings = list()

	var/datum/tgui_macro/macros

	var/tgui_fancy = TRUE
	var/tgui_lock = FALSE

	var/hear_vox = TRUE

	var/hide_statusbar

	var/no_radials_preference = FALSE
	var/no_radial_labels_preference = FALSE

	var/bg_state = "blank" // the icon_state of the floortile background displayed behind the mannequin in character creation
	var/show_job_gear = TRUE // whether the job gear gets equipped to the mannequin in character creation

	//Byond membership status

	var/unlock_content = 0

	var/current_menu = MENU_MARINE

	/// if this client has custom cursors enabled
	var/custom_cursors = TRUE

	/// if this client has tooltips enabled
	var/tooltips = TRUE

	/// A list of tutorials that the client has completed, saved across rounds
	var/list/completed_tutorials = list()
	/// If this client has auto observe enabled, used by /datum/orbit_menu
	var/auto_observe = TRUE

	/// Fluff items that the user is equipped with on spawn.
	var/list/gear

	/// Loadout items that the user is equipped with on spawn.
	VAR_PRIVATE/list/loadout = list()

	/// Mapping of jobs to slot numbers to names, to allow users to customise slots
	var/list/loadout_slot_names

	/// Which slot is currently in use
	var/selected_loadout_slot = 1

	/// This contains any potential issues with the users' preferences, and presents them on the lobby screen
	var/errors = list()


/datum/preferences/New(client/C)
	key_bindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	macros = new(C, src)
	if(istype(C))
		owner = C
		if(!IsGuestKey(C.key))
			unlock_content = C.IsByondMember()
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return
	if(!ooccolor)
		ooccolor = CONFIG_GET(string/ooc_color_default)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender)
	gear = list()

/datum/preferences/proc/client_reconnected(client/C)
	owner = C
	macros.owner = C

/datum/preferences/Del()
	. = ..()

	// Preferences should not be getting deleted because they are reffed in a list
	var/client_qdeled = isnull(owner) || QDELETED(owner)
	var/client_status = client_qdeled ? "client is null or disposed" : "client is OK"
	var/client_mob_status
	if (client_qdeled)
		client_mob_status = "no client for mob"
	else if (isnull(owner.mob) || QDELETED(owner.mob))
		client_mob_status = "client mob is null or disposed"
	else
		client_mob_status = "client mob is OK"
	CRASH("Preferences deleted unexpectedly: [client_status]; [client_mob_status]")

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	update_preview_icon()

	var/dat = "<style>"
	dat += "#column1 {width: 30%; float: left;}"
	dat += "#column2 {width: 30%; float: left;}"
	dat += "#column3 {width: 40%; float: left;}"
	dat += ".square {width: 15px; height: 15px; display: inline-block;}"
	dat += "</style>"
	dat += "<body onselectstart='return false;'>"

	if(!path)
		dat += "Please create an account to save your preferences."
		return

	dat += "<center>"
	dat += "<a href=\"byond://?src=\ref[user];preference=open_load_dialog\"><b>Load Slot</b></a> - "
	dat += "<a href=\"byond://?src=\ref[user];preference=save\"><b>Save Slot</b></a> - "
	dat += "<a href=\"byond://?src=\ref[user];preference=reload\"><b>Reload Slot</b></a>"
	dat += "</center>"

	dat += "<hr>"

	dat += "<center>"
	dat += "<a[current_menu == MENU_MARINE ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_MARINE]\"><b>Human</b></a> - "
	dat += "<a[current_menu == MENU_XENOMORPH ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_XENOMORPH]\"><b>Xenomorph</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_COMMANDER))
		dat += "<a[current_menu == MENU_CO ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_CO]\"><b>Commanding Officer</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_SYNTHETIC))
		dat += "<a[current_menu == MENU_SYNTHETIC ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SYNTHETIC]\"><b>Synthetic</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_YAUTJA))
		dat += "<a[current_menu == MENU_YAUTJA ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=yautja\"><b>Yautja</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_MENTOR))
		dat += "<a[current_menu == MENU_MENTOR ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_MENTOR]\"><b>Mentor</b></a> - "
	dat += "<a[current_menu == MENU_SETTINGS ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SETTINGS]\"><b>Settings</b></a> - "
	dat += "<a[current_menu == MENU_SPECIAL ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SPECIAL]\"><b>Special Roles</b></a>"
	dat += "</center>"

	dat += "<hr>"

	switch(current_menu)
		if(MENU_MARINE)
			dat += "<div id='column1'>"
			dat += "<h1><u><b>Name:</b></u> "
			dat += "<a href='byond://?_src_=prefs;preference=name;task=input'><b>[real_name]</b></a>"
			dat += "<a href='byond://?_src_=prefs;preference=name;task=random'>&reg</A></h1>"
			dat += "<b>Always Pick Random Name:</b> <a href='byond://?_src_=prefs;preference=rand_name'><b>[be_random_name ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Always Pick Random Appearance:</b> <a href='byond://?_src_=prefs;preference=rand_body'><b>[be_random_body ? "Yes" : "No"]</b></a><br><br>"

			dat += "<h2><b><u>Physical Information:</u></b>"
			dat += "<a href='byond://?_src_=prefs;preference=all;task=random'>&reg;</A></h2>"
			dat += "<b>Age:</b> <a href='byond://?_src_=prefs;preference=age;task=input'><b>[age]</b></a><br>"
			dat += "<b>Gender:</b> <a href='byond://?_src_=prefs;preference=gender'><b>[gender == MALE ? "Male" : "Female"]</b></a><br><br>"

			dat += "<b>Skin Color:</b> [skin_color]<br>"
			dat += "<b>Body Size:</b> [body_size]<br>"
			dat += "<b>Body Muscularity:</b> [body_type]<br>"
			dat += "<b>Edit Body:</b> <a href='byond://?_src_=prefs;preference=body;task=input'><b>Picker</b></a><br><br>"

			dat += "<b>Traits:</b> <a href='byond://?src=\ref[user];preference=traits'><b>Character Traits</b></a>"
			dat += "<br>"

			dat += "<h2><b><u>Occupation Choices:</u></b></h2>"
			dat += "<br>"
			dat += "\t<a href='byond://?_src_=prefs;preference=job;task=menu'><b>Set Role Preferences</b></a>"
			dat += "<br>"
			dat += "\t<a href='byond://?_src_=prefs;preference=job_slot;task=menu'><b>Assign Character Slots to Roles</b></a>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>Hair and Eyes:</u></b></h2>"
			dat += "<b>Hair:</b> [h_style]"
			dat += " | "
			dat += "<span class='square' style='background-color: #[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)];'></span>"
			dat += "<br>"

			dat += "<b>Facial Hair:</b> [f_style]"
			dat += " | "
			dat += "<span class='square' style='background-color: #[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)];'></span>"
			dat += "<br>"

			if(/datum/character_trait/hair_dye in traits)
				dat += "<b>Hair Gradient:</b> [grad_style]"
				dat += " | "
				dat += "<span class='square' style='background-color: #[num2hex(r_gradient, 2)][num2hex(g_gradient, 2)][num2hex(b_gradient)];'></span>"
				dat += "<br>"

			dat += "<b>Edit Hair:</b> <a href='byond://?_src_=prefs;preference=hair;task=input'><b>Picker</b></a><br><br>"

			dat += "<b>Eye:</b> "
			dat += "<a href='byond://?_src_=prefs;preference=eyes;task=input'>"
			dat += "<b>Color</b> <span class='square' style='background-color: #[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)];'></span>"
			dat += "</a>"
			dat += "<br><br>"

			dat += "<h2><b><u>Marine Gear:</u></b></h2>"
			dat += "<b>Underwear:</b> <a href='byond://?_src_=prefs;preference=underwear;task=input'><b>[underwear]</b></a><br>"
			dat += "<b>Undershirt:</b> <a href='byond://?_src_=prefs;preference=undershirt;task=input'><b>[undershirt]</b></a><br>"

			dat += "<b>Backpack Type:</b> <a href='byond://?_src_=prefs;preference=bag;task=input'><b>[GLOB.backbaglist[backbag]]</b></a><br>"

			dat += "<b>Preferred Armor:</b> <a href='byond://?_src_=prefs;preference=prefarmor;task=input'><b>[preferred_armor]</b></a><br>"

			dat += "<b>Show Job Gear:</b> <a href='byond://?_src_=prefs;preference=toggle_job_gear'><b>[show_job_gear ? "True" : "False"]</b></a><br>"
			dat += "<b>Background:</b> <a href='byond://?_src_=prefs;preference=cycle_bg'><b>Cycle Background</b></a><br><br>"
			dat += "<b>Night Vision Color:</b> <a href='byond://?_src_=prefs;preference=prefnvg;task=input'><b>[night_vision_preference]</b></a><br>"

			dat += "<b>Custom Loadout:</b> "
			var/total_cost = 0

			if(!islist(gear))
				gear = list()

			if(length(gear))
				dat += "<br>"
				for(var/i = 1; i <= length(gear); i++)
					var/datum/gear/G = GLOB.gear_datums_by_type[gear[i]]
					if(G)
						total_cost += G.fluff_cost
						var/fluff_cost = G.fluff_cost ? " ([G.fluff_cost] fluff point\s)" : ""
						var/loadout_cost = G.loadout_cost ? " ([G.loadout_cost]) loadout point\s" : ""
						dat += "[G.display_name][fluff_cost][loadout_cost]<br>"

				dat += "<b>Used:</b> [total_cost] points"
			else
				dat += "None"

			dat += "<br><a href='byond://?src=\ref[user];preference=loadout'><b>Open Loadout</b></a>"

			dat += "</div>"

			dat += "<div id='column3'>"
			dat += "<h2><b><u>Background Information:</u></b></h2>"
			dat += "<b>Origin:</b> <a href='byond://?_src_=prefs;preference=origin;task=input'><b>[origin]</b></a><br/>"
			dat += "<b>Religion:</b> <a href='byond://?_src_=prefs;preference=religion;task=input'><b>[religion]</b></a><br/>"

			dat += "<b>Corporate Relation:</b> <a href='byond://?_src_=prefs;preference=wy_relation;task=input'><b>[weyland_yutani_relation]</b></a><br>"
			dat += "<b>Preferred Squad:</b> <a href='byond://?_src_=prefs;preference=prefsquad;task=input'><b>[preferred_squad]</b></a><br>"

			dat += "<h2><b><u>Fluff Information:</u></b></h2>"
			if(jobban_isbanned(user, "Records"))
				dat += "<b>You are banned from using character records.</b><br>"
			else
				dat += "<b>Records:</b> <a href=\"byond://?src=\ref[user];preference=records;record=1\"><b>Character Records</b></a><br>"

			dat += "<b>Flavor Text:</b> <a href='byond://?src=\ref[user];preference=flavor_text;task=open'><b>[TextPreview(flavor_texts["general"], 15)]</b></a><br>"
			dat += "</div>"

		if(MENU_XENOMORPH)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>Xenomorph Information:</u></b></h2>"
			var/display_prefix = xeno_prefix ? xeno_prefix : "------"
			var/display_postfix = xeno_postfix ? xeno_postfix : "------"
			dat += "<b>Xeno prefix:</b> <a href='byond://?_src_=prefs;preference=xeno_prefix;task=input'><b>[display_prefix]</b></a><br>"
			dat += "<b>Xeno postfix:</b> <a href='byond://?_src_=prefs;preference=xeno_postfix;task=input'><b>[display_postfix]</b></a><br>"

			dat += "<b>Enable Playtime Perks:</b> <a href='byond://?_src_=prefs;preference=playtime_perks'><b>[playtime_perks? "Yes" : "No"]</b></a><br>"
			dat += "<b>Show Queen Name:</b> <a href='byond://?_src_=prefs;preference=show_queen_name'><b>[show_queen_name? "Yes" : "No"]</b></a><br>"
			dat += "<b>Default Xeno Night Vision Level:</b> <a href='byond://?_src_=prefs;preference=xeno_vision_level_pref;task=input'><b>[xeno_vision_level_pref]</b></a><br>"

			var/tempnumber = rand(1, 999)
			var/postfix_text = xeno_postfix ? ("-"+xeno_postfix) : ""
			var/prefix_text = xeno_prefix ? xeno_prefix : "XX"
			var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"

			dat += "<b>Xeno sample name:</b> [xeno_text]<br>"
			dat += "<br>"
			dat += "</div>"

		if(MENU_CO)
			if(owner.check_whitelist_status(WHITELIST_COMMANDER))
				dat += "<div id='column1'>"
				dat += "<h2><b><u>Commander Settings:</u></b></h2>"
				dat += "<b>Commander Whitelist Status:</b> <a href='byond://?_src_=prefs;preference=commander_status;task=input'><b>[commander_status]</b></a><br>"
				dat += "<b>Commander Sidearm:</b> <a href='byond://?_src_=prefs;preference=co_sidearm;task=input'><b>[commander_sidearm]</b></a><br>"
				dat += "<b>Commander Affiliation:</b> <a href='byond://?_src_=prefs;preference=co_affiliation;task=input'><b>[affiliation]</b></a><br>"
				dat += "<b>Commander Career Path:</b> <a href='byond://?_src_=prefs;preference=co_career_path;task=input'><b>[co_career_path]</b></a><br>"
				dat += "</div>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"
		if(MENU_SYNTHETIC)
			if(owner.check_whitelist_status(WHITELIST_SYNTHETIC))
				dat += "<div id='column1'>"
				dat += "<h2><b><u>Synthetic Settings:</u></b></h2>"
				dat += "<b>Synthetic Name:</b> <a href='byond://?_src_=prefs;preference=synth_name;task=input'><b>[synthetic_name]</b></a><br>"
				dat += "<b>Synthetic Type:</b> <a href='byond://?_src_=prefs;preference=synth_type;task=input'><b>[synthetic_type]</b></a><br>"
				dat += "<b>Synthetic Whitelist Status:</b> <a href='byond://?_src_=prefs;preference=synth_status;task=input'><b>[synth_status]</b></a><br>"
				dat += "</div>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"

		if(MENU_MENTOR)
			if(owner.check_whitelist_status(WHITELIST_MENTOR))
				dat += "<b>New Player Ghost HUD:</b> <a href='byond://?_src_=prefs;preference=newplayer_ghost_hud'><b>[observer_huds[HUD_MENTOR_SIGHT] ? "Enabled" : "Disabled"]</b></a><br>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"
		if(MENU_SETTINGS)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>Input Settings:</u></b></h2>"
			dat += "<b>Mode:</b> <a href='byond://?_src_=prefs;preference=hotkeys'><b>[(hotkeys) ? "Hotkeys Mode" : "Send to Chat"]</b></a><br>"
			dat += "<b>Keybinds:</b> <a href='byond://?_src_=prefs;preference=viewmacros'><b>View Keybinds</b></a><br>"
			dat += "<br><b>Say Input Style:</b> <a href='byond://?_src_=prefs;preference=inputstyle'><b>[tgui_say ? "Modern (default)" : "Legacy"]</b></a><br>"
			dat += "<b>Say Input Color:</b> <a href='byond://?_src_=prefs;preference=inputcolor'><b>[tgui_say_light_mode ? "Lightmode" : "Darkmode (default)"]</b></a><br>"

			dat += "<h2><b><u>UI Customization:</u></b></h2>"
			dat += "<b>Style:</b> <a href='byond://?_src_=prefs;preference=ui'><b>[UI_style]</b></a><br>"
			dat += "<b>Color:</b> <a href='byond://?_src_=prefs;preference=UIcolor'><b>[UI_style_color]</b> <table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></table></a><br>"
			dat += "<b>Alpha:</b> <a href='byond://?_src_=prefs;preference=UIalpha'><b>[UI_style_alpha]</b></a><br><br>"
			dat += "<b>Stylesheet:</b> <a href='byond://?_src_=prefs;preference=stylesheet'><b>[stylesheet]</b></a><br>"
			dat += "<b>Hide Statusbar:</b> <a href='byond://?_src_=prefs;preference=hide_statusbar'><b>[hide_statusbar ? "TRUE" : "FALSE"]</b></a><br>"
			dat += "<b>Prefer input drop down menus to radial menus, where possible:</b> <a href='byond://?_src_=prefs;preference=no_radials_preference'><b>[no_radials_preference ? "TRUE" : "FALSE"]</b></a><br>"
			if(!no_radials_preference)
				dat += "<b>Hide Radial Menu Labels:</b> <a href='byond://?_src_=prefs;preference=no_radial_labels_preference'><b>[no_radial_labels_preference ? "TRUE" : "FALSE"]</b></a><br>"
			dat += "<b>Custom Cursors:</b> <a href='byond://?_src_=prefs;preference=customcursors'><b>[custom_cursors ? "Enabled" : "Disabled"]</b></a><br>"

			dat += "<h2><b><u>Chat Settings:</u></b></h2>"
			if(CONFIG_GET(flag/ooc_country_flags))
				dat += "<b>OOC Country Flag:</b> <a href='byond://?_src_=prefs;preference=ooc_flag'><b>[(toggle_prefs & TOGGLE_OOC_FLAG) ? "Enabled" : "Disabled"]</b></a><br>"
			if(user.client.admin_holder && user.client.admin_holder.rights & R_DEBUG)
				dat += "<b>View Master Controller Tab:</b> <a href='byond://?_src_=prefs;preference=ViewMC'><b>[View_MC ? "TRUE" : "FALSE"]</b></a>"
			if(unlock_content)
				dat += "<b>BYOND Membership Publicity:</b> <a href='byond://?_src_=prefs;preference=publicity'><b>[(toggle_prefs & TOGGLE_MEMBER_PUBLIC) ? "Public" : "Hidden"]</b></a><br>"
			dat += "<b>Ghost Ears:</b> <a href='byond://?_src_=prefs;preference=ghost_ears'><b>[(toggles_chat & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a><br>"
			dat += "<b>Ghost Sight:</b> <a href='byond://?_src_=prefs;preference=ghost_sight'><b>[(toggles_chat & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a><br>"
			dat += "<b>Ghost Radio:</b> <a href='byond://?_src_=prefs;preference=ghost_radio'><b>[(toggles_chat & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a><br>"
			dat += "<b>Ghost Spy Radio:</b> <a href='byond://?_src_=prefs;preference=ghost_spyradio'><b>[(toggles_chat & CHAT_LISTENINGBUG) ? "Hear" : "Silence"] listening devices</b></a><br>"
			dat += "<b>Ghost Hivemind:</b> <a href='byond://?_src_=prefs;preference=ghost_hivemind'><b>[(toggles_chat & CHAT_GHOSTHIVEMIND) ? "Show Hivemind" : "Hide Hivemind"]</b></a><br>"
			dat += "<b>Abovehead Chat:</b> <a href='byond://?_src_=prefs;preference=lang_chat_disabled'><b>[lang_chat_disabled ? "Hide" : "Show"]</b></a><br>"
			dat += "<b>Abovehead Emotes:</b> <a href='byond://?_src_=prefs;preference=langchat_emotes'><b>[(toggles_langchat & LANGCHAT_SEE_EMOTES) ? "Show" : "Hide"]</b></a><br>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>Game Settings:</u></b></h2>"
			dat += "<b>Ambient Occlusion:</b> <a href='byond://?_src_=prefs;preference=ambientocclusion'><b>[toggle_prefs & TOGGLE_AMBIENT_OCCLUSION ? "Enabled" : "Disabled"]</b></a><br>"
			dat += "<b>Fit Viewport:</b> <a href='byond://?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
			dat += "<b>Adaptive Zoom:</b> <a href='byond://?_src_=prefs;preference=adaptive_zoom'>[adaptive_zoom ? "[adaptive_zoom * 2]x" : "Disabled"]</a><br>"
			dat += "<b>Tooltips:</b> <a href='byond://?_src_=prefs;preference=tooltips'><b>[tooltips ? "Enabled" : "Disabled"]</b></a><br>"
			dat += "<b>tgui Window Mode:</b> <a href='byond://?_src_=prefs;preference=tgui_fancy'><b>[(tgui_fancy) ? "Fancy (default)" : "Compatible (slower)"]</b></a><br>"
			dat += "<b>tgui Window Placement:</b> <a href='byond://?_src_=prefs;preference=tgui_lock'><b>[(tgui_lock) ? "Primary monitor" : "Free (default)"]</b></a><br>"
			dat += "<b>Play Admin Sounds:</b> <a href='byond://?_src_=prefs;preference=hear_admin_sounds'><b>[(toggles_sound & SOUND_MIDI) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Play Announcement Sounds As Ghost:</b> <a href='byond://?_src_=prefs;preference=hear_observer_announcements'><b>[(toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Play Fax Sounds As Ghost:</b> <a href='byond://?_src_=prefs;preference=hear_faxes'><b>[(toggles_sound & SOUND_FAX_MACHINE) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Toggle Meme or Atmospheric Sounds:</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_admin_sound_types'>Toggle</a><br>"
			dat += "<b>Set Eye Blur Type:</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_eye_blur_type'>Set</a><br>"
			dat += "<b>Set Flash Type:</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_flash_type'>Set</a><br>"
			dat += "<b>Set Crit Type:</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_crit_type'>Set</a><br>"
			dat += "<b>Allow Flashing Lights:</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_flashing_lights_pref'>Set</a><br>"
			dat += "<b>Play Lobby Music:</b> <a href='byond://?_src_=prefs;preference=lobby_music'><b>[(toggles_sound & SOUND_LOBBY) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Play VOX Announcements:</b> <a href='byond://?_src_=prefs;preference=sound_vox'><b>[(hear_vox) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Default Ghost Night Vision Level:</b> <a href='byond://?_src_=prefs;preference=ghost_vision_pref;task=input'><b>[ghost_vision_pref]</b></a><br>"
			dat += "<b>Button To Activate Xenomorph Abilities:</b> <a href='byond://?_src_=prefs;preference=mouse_button_activation;task=input'><b>[xeno_ability_mouse_pref_to_string(xeno_ability_click_mode)]</b></a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/receive_random_tip'>Read Random Tip of the Round</a><br>"
			if(CONFIG_GET(flag/allow_Metadata))
				dat += "<b>OOC Notes:</b> <a href='byond://?_src_=prefs;preference=metadata;task=input'> Edit </a>"
			dat += "</div>"

			dat += "<div id='column3'>"
			dat += "<h2><b><u>Gameplay Toggles:</u></b></h2>"
			dat += "<b>Toggle Being Able to Hurt Yourself: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_IGNORE_SELF]'><b>[toggle_prefs & TOGGLE_IGNORE_SELF ? "Off" : "On"]</b></a><br>"
			dat += "<b>Toggle Help Intent Safety: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_HELP_INTENT_SAFETY]'><b>[toggle_prefs & TOGGLE_HELP_INTENT_SAFETY ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Automatic Shove: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_SHOVE_OFF]'><b>[toggle_prefs & TOGGLE_AUTO_SHOVE_OFF ? "Off" : "On"]</b></a><br>"
			dat += "<b>Toggle Ability Deactivation: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_ABILITY_DEACTIVATION_OFF]'><b>[toggle_prefs & TOGGLE_ABILITY_DEACTIVATION_OFF ? "Off" : "On"]</b></a><br>"
			dat += "<b>Toggle Directional Assist: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_DIRECTIONAL_ATTACK]'><b>[toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Magazine Auto-Ejection: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_EJECT_MAGAZINE_OFF];flag_undo=[TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND]'><b>[!(toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF) ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Magazine Auto-Ejection to Offhand: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND];flag_undo=[TOGGLE_AUTO_EJECT_MAGAZINE_OFF]'><b>[toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Magazine Manual Ejection to Offhand: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_EJECT_MAGAZINE_TO_HAND]'><b>[toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Automatic Punctuation: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTOMATIC_PUNCTUATION]'><b>[toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Combat Click-Drag Override: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_COMBAT_CLICKDRAG_OVERRIDE]'><b>[toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Middle-Click Swap Hands: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_MIDDLE_MOUSE_SWAP_HANDS]'><b>[toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Vendors Vending to Hands: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_VEND_ITEM_TO_HAND]'><b>[toggle_prefs & TOGGLE_VEND_ITEM_TO_HAND ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Semi-Auto Ammo Display Limiter: \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AMMO_DISPLAY_TYPE]'><b>[toggle_prefs & TOGGLE_AMMO_DISPLAY_TYPE ? "On" : "Off"]</b></a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/switch_item_animations'>Toggle Item Animations Detail Level</a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_dualwield'>Toggle Dual Wield Functionality</a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_auto_shove'>Toggle Auto Shove</a><br>"
		if(MENU_SPECIAL) //wart
			dat += "<div id='column1'>"
			dat += "<h2><b><u>ERT Settings:</u></b></h2>"
			dat += "<b>Spawn as Leader:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_LEADER]'><b>[toggles_ert & PLAY_LEADER ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Medic:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_MEDIC]'><b>[toggles_ert & PLAY_MEDIC ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Engineer:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_ENGINEER]'><b>[toggles_ert & PLAY_ENGINEER ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Specialist:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_HEAVY]'><b>[toggles_ert & PLAY_HEAVY ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Smartgunner:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_SMARTGUNNER]'><b>[toggles_ert & PLAY_SMARTGUNNER ? "Yes" : "No"]</b></a><br>"

			if(owner.check_whitelist_status(WHITELIST_SYNTHETIC))
				dat += "<b>Spawn as Synth:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_SYNTH]'><b>[toggles_ert & PLAY_SYNTH ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Miscellaneous:</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_MISC]'><b>[toggles_ert & PLAY_MISC ? "Yes" : "No"]</b></a><br>"

			dat += "<br><h2><b><u>Special Roles:</u></b></h2>"

			for(var/role_name in GLOB.be_special_flags)
				var/flag = GLOB.be_special_flags[role_name]

				var/ban_check_name
				switch(role_name)
					if("Xenomorph after unrevivable death")
						ban_check_name = JOB_XENOMORPH

					if("Agent")
						ban_check_name = "Agent"

				if(ban_check_name && jobban_isbanned(user, ban_check_name))
					dat += "<b>Be [role_name]:</b> <font color=red><b>\[BANNED]</b></font><br>"
				else if(!can_play_special_job(user.client, ban_check_name))
					dat += "<b>Be [role_name]:</b> <font color=red><b>\[TIMELOCKED]</b></font><br>"
				else
					dat += "<b>Be [role_name]:</b> <a href='byond://?_src_=prefs;preference=be_special;num=[flag]'><b>[be_special & flag ? "Yes" : "No"]</b></a><br>"



			dat += "</div>"
			dat += "<div id='column2'>"
			dat += "<h2><b><u>Hunting Ground ERT Settings:</u></b></h2>"
			dat += "<b>Spawn as Mercenary:</b> <a href='byond://?_src_=prefs;preference=toggles_ert_pred;flag=[PLAY_MERC]'><b>[toggles_ert_pred & PLAY_MERC ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Royal Marine:</b> <a href='byond://?_src_=prefs;preference=toggles_ert_pred;flag=[PLAY_TWE]'><b>[toggles_ert_pred & PLAY_TWE ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as UPP:</b> <a href='byond://?_src_=prefs;preference=toggles_ert_pred;flag=[PLAY_UPP]'><b>[toggles_ert_pred & PLAY_UPP ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as CLF:</b> <a href='byond://?_src_=prefs;preference=toggles_ert_pred;flag=[PLAY_CLF]'><b>[toggles_ert_pred & PLAY_CLF ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Xeno T2:</b> <a href='byond://?_src_=prefs;preference=toggles_ert_pred;flag=[PLAY_XENO_T2]'><b>[toggles_ert_pred & PLAY_XENO_T2 ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Xeno T3:</b> <a href='byond://?_src_=prefs;preference=toggles_ert_pred;flag=[PLAY_XENO_T3]'><b>[toggles_ert_pred & PLAY_XENO_T3 ? "Yes" : "No"]</b></a><br>"
			dat += "</div>"
			dat += "</body>"
			if(owner.check_whitelist_status(WHITELIST_FAX_RESPONDER))
				dat += "<div id='column3'>"
				dat += "<h2><b><u>Fax Responder Names:</u></b></h2>"
				dat += "<b>USCM High Command:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=uscm'><b>[fax_name_uscm]</b></a><br>"
				dat += "<b>USCM Provost:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=pvst'><b>[fax_name_pvst]</b></a><br>"
				dat += "<b>Weyland-Yutani:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=wy'><b>[fax_name_wy]</b></a><br>"
				dat += "<b>UPP Command:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=upp'><b>[fax_name_upp]</b></a><br>"
				dat += "<b>TWE Command:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=twe'><b>[fax_name_twe]</b></a><br>"
				dat += "<b>Colonial Marshal Bureau:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=cmb'><b>[fax_name_cmb]</b></a><br>"
				dat += "<b>Free Press:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=press'><b>[fax_name_press]</b></a><br>"
				dat += "<b>CLF Command:</b> <a href='byond://?_src_=prefs;preference=fax_name;task=input;fax_faction=clf'><b>[fax_name_clf]</b></a><br>"
				dat += "</div>"


	dat += "</div></body>"

	winshow(user, "preferencewindow", TRUE)
	show_browser(user, dat, "Preferences", "preferencewindow")
	onclose(user, "preferencewindow", src)

/**
 * Job Preferences: Preferences for role at round start.
 *
 * Arguments:
 * * limit - The amount of jobs allowed per column.
 * * splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads.
 * * width - Screen' width.
 * * height - Screen's height.
 */
/datum/preferences/proc/SetChoices(mob/user, limit = 21, list/splitJobs = list(JOB_CHIEF_REQUISITION, JOB_WO_CMO), width = 950, height = 750)
	if(!GLOB.RoleAuthority)
		return

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br><br>"
	HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0' style='color: black;'><tr><td valign='top' width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.

	var/list/active_role_names = GLOB.gamemode_roles[GLOB.master_mode]
	if(!active_role_names)
		active_role_names = GLOB.ROLES_DISTRESS_SIGNAL

	for(var/role_name as anything in active_role_names)
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role_name]
		if(!job)
			debug_log("Missing job for prefs: [role_name]")
			continue
		if(job.flags_startup_parameters & ROLE_HIDDEN)
			continue
		index++
		if((index >= limit) || (job.title in splitJobs))
			HTML += "</table></td><td valign='top' width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr class='[job.selection_class]'><td width='40%' align='right'>"

		if(jobban_isbanned(user, job.title))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='10%' align='center'></td><td><b>BANNED</b></td></tr>"
			continue
		else if(!job.check_whitelist_status(user))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='10%' align='center'></td><td>WHITELISTED</td></tr>"
			continue
		else if(!job.can_play_role(user.client))
			var/list/missing_requirements = job.get_role_requirements(user.client)
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='10%' align='center'></td><td>TIMELOCKED</td></tr>"
			for(var/r in missing_requirements)
				var/datum/timelock/T = r
				HTML += "<tr class='[job.selection_class]'><td width='40%' align='middle'>[T.name]</td><td width='10%' align='center'></td><td>[duration2text(missing_requirements[r])] Hours</td></tr>"
			continue

		HTML += "<b>[job.disp_title]</b></td><td width='10%' align='center'>"

		if(job.job_options)
			if(pref_special_job_options)
				pref_special_job_options[role_name] = sanitize_inlist(pref_special_job_options[role_name], job.job_options, job.job_options[1])
			else
				pref_special_job_options[role_name] = job.job_options[1]

			var/txt = job.job_options[pref_special_job_options[role_name]]
			HTML += "<a href='byond://?_src_=prefs;preference=special_job_select;task=input;text=[job.title]'><b>[txt]</b></a>"

		HTML += "</td><td width='50%'>"

		var/cur_priority = get_job_priority(job.title)

		var/b_color
		var/priority_text
		for (var/j in NEVER_PRIORITY to LOW_PRIORITY)
			switch (j)
				if(NEVER_PRIORITY)
					b_color = "red"
					priority_text = "NEVER"
				if(HIGH_PRIORITY)
					b_color = "blue"
					priority_text = "HIGH"
				if(MED_PRIORITY)
					b_color = "green"
					priority_text = "MEDIUM"
				if(LOW_PRIORITY)
					b_color = "orange"
					priority_text = "LOW"

			HTML += "<a class='[j == cur_priority ? b_color : "inactive"]' href='byond://?_src_=prefs;preference=job;task=input;text=[job.title];target_priority=[j];'>[priority_text]</a>"
			if (j < 4)
				HTML += "&nbsp"

		HTML += "</td></tr>"

	HTML += "</td></tr></table>"
	HTML += "</center></table>"

	if(user.client?.prefs) //Just makin sure
		var/b_color = "green"
		var/msg = "Get random job if preferences unavailable"

		if(user.client.prefs.alternate_option == BE_MARINE)
			b_color = "red"
			msg = "Be marine if preference unavailable"
		else if(user.client.prefs.alternate_option == RETURN_TO_LOBBY)
			b_color = "purple"
			msg = "Return to lobby if preference unavailable"
		else if(user.client.prefs.alternate_option == BE_XENOMORPH)
			b_color = "orange"
			msg = "Be Xenomorph if preference unavailable"

		HTML += "<center><br><a class='[b_color]' href='byond://?_src_=prefs;preference=job;task=random'>[msg]</a></center><br>"

	HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=reset'>Reset</a></center>"
	HTML += "</tt></body>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "Job Preferences", "mob_occupation", "size=[width]x[height]")
	onclose(user, "mob_occupation", user.client, list("_src_" = "prefs", "preference" = "job", "task" = "close"))
	return

/**
 * Job Assignments window: Assign unique characters to a particular job.
 *
 * Arguments:
 * * limit - The amount of jobs allowed per column.
 * * splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads.
 * * width - Screen' width.
 * * height - Screen's height.
 */
/datum/preferences/proc/set_job_slots(mob/user, limit = 21, list/splitJobs = list(JOB_CHIEF_REQUISITION, JOB_WO_CMO), width = 950, height = 750)
	if(!GLOB.RoleAuthority)
		return

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Assign character slots to jobs.</b><br>Unavailable occupations are crossed out.<br><br>"
	HTML += "<center><a href='byond://?_src_=prefs;preference=job_slot;task=close'>Done</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0' style='color: black;'><tr><td valign='top' width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.

	var/list/active_role_names = GLOB.gamemode_roles[GLOB.master_mode]
	if(!active_role_names)
		active_role_names = GLOB.ROLES_DISTRESS_SIGNAL

	for(var/role_name as anything in active_role_names)
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role_name]
		if(!job)
			debug_log("Missing job for prefs: [role_name]")
			continue
		index++
		if((index >= limit) || (job.title in splitJobs))
			HTML += "</table></td><td valign='top' width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr class='[job.selection_class]'><td width='40%' align='right'>"
		if(jobban_isbanned(user, job.title))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='60%'><b>BANNED</b></td></tr>"
			continue
		else if(!job.check_whitelist_status(user))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='60%'>WHITELISTED</td></tr>"
			continue
		else if(!job.can_play_role(user.client))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='60%'>TIMELOCKED</td></tr>"
			continue

		HTML += "<b>[job.disp_title]</b></td>"

		var/slot_name = get_job_slot_name(job.title)
		HTML += "<td width='60%'><a href='byond://?_src_=prefs;preference=job_slot;task=assign;target_job=[job.title];'>[slot_name]</a>"
		HTML += "</td></tr>"

	HTML += "</td></tr></table>"
	HTML += "</center></table><br>"

	var/b_color
	var/msg
	if(toggle_prefs & TOGGLE_START_JOIN_CURRENT_SLOT)
		b_color = "red"
		msg = "This preference is ignored when joining at the start of the round."
	else
		b_color = "green"
		msg = "This preference is used when joining at the start of the round."
	HTML += "<center><a class='[b_color]' href='byond://?_src_=prefs;preference=job_slot;task=start_join'>[msg]</a></center>"
	if(toggle_prefs & TOGGLE_LATE_JOIN_CURRENT_SLOT)
		b_color = "red"
		msg = "This preference is ignored when joining a round in progress."
	else
		b_color = "green"
		msg = "This preference is used when joining a round in progress."
	HTML += "<center><a class='[b_color]' href='byond://?_src_=prefs;preference=job_slot;task=late_join'>[msg]</a></center>"

	HTML += "<center><a href='byond://?_src_=prefs;preference=job_slot;task=reset'>Reset</a></center>"
	HTML += "</tt></body>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "Job Assignment", "job_slots_assignment", "size=[width]x[height]")
	onclose(user, "job_slots_assignment", user.client, list("_src_" = "prefs", "preference" = "job_slot", "task" = "close"))
	return

/datum/preferences/proc/SetRecords(mob/user)
	var/HTML = "<body onselectstart='return false;'>"
	HTML += "<tt><center>"
	HTML += "<b>Set Character Records</b><br>"

	HTML += "<a href=\"byond://?src=\ref[user];preference=records;task=med_record\">Medical Records</a><br>"

	HTML += TextPreview(med_record,40)

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=gen_record\">Employment Records</a><br>"

	HTML += TextPreview(gen_record,40)

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=sec_record\">Security Records</a><br>"

	HTML += TextPreview(sec_record,40)

	HTML += "<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preference=records;records=-1\">Done</a>"
	HTML += "</center></tt>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "Set Records", "records", "size=350x300")
	return

/datum/preferences/proc/SetFlavorText(mob/user)
	var/HTML = "<body>"
	HTML += "<tt>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='byond://?src=\ref[user];preference=flavor_text;task=done'>Done</a>"
	HTML += "<tt>"
	close_browser(user, "preferences")
	show_browser(user, HTML, "Set Flavor Text", "flavor_text;size=430x300")
	return

/datum/preferences/proc/SetJob(mob/user, role, priority)
	var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role]
	if(!job)
		close_browser(user, "mob_occupation")
		ShowChoices(user)
		return

	SetJobDepartment(job, priority)

	SetChoices(user)

	check_slot_prefs()
	return 1

/datum/preferences/proc/ResetJobs()
	if(length(job_preference_list))
		for(var/job in job_preference_list)
			job_preference_list[job] = NEVER_PRIORITY
		return

	if(!GLOB.RoleAuthority)
		return

	job_preference_list = list()
	for(var/role in GLOB.RoleAuthority.roles_by_path)
		var/datum/job/J = GLOB.RoleAuthority.roles_by_path[role]
		job_preference_list[J.title] = NEVER_PRIORITY

	check_slot_prefs()

/datum/preferences/proc/get_job_priority(J)
	if(!J)
		return FALSE

	if(!length(job_preference_list))
		ResetJobs()

	return job_preference_list[J]

/datum/preferences/proc/SetJobDepartment(datum/job/J, priority)
	if(!J || priority < 0 || priority > 4)
		return FALSE


	if(!length(job_preference_list))
		ResetJobs()

	// Need to set old HIGH priority to 2
	if(priority == HIGH_PRIORITY)
		for(var/job in job_preference_list)
			if(job_preference_list[job] == HIGH_PRIORITY)
				job_preference_list[job] = MED_PRIORITY

	job_preference_list[J.title] = priority
	return TRUE

/datum/preferences/proc/assign_job_slot(mob/user, target_job)
	var/list/slot_options = list(JOB_SLOT_RANDOMISED_TEXT = JOB_SLOT_RANDOMISED_SLOT, JOB_SLOT_CURRENT_TEXT = JOB_SLOT_CURRENT_SLOT)
	var/savefile/S = new /savefile(path)
	var/slot_name
	for(var/slot in 1 to MAX_SAVE_SLOTS)
		S.cd = "/character[slot]"
		S["real_name"] >> slot_name
		if(slot_name)
			slot_options["[slot_name] (slot #[slot])"] = slot
	var/chosen_slot = tgui_input_list(user, "Assign character for [target_job] job", "Slot assignment", slot_options)
	if(chosen_slot)
		pref_job_slots[target_job] = slot_options[chosen_slot]
	set_job_slots(user)

/datum/preferences/proc/get_job_slot_name(job_title)
	. = JOB_SLOT_CURRENT_TEXT
	if(!(job_title in pref_job_slots))
		return
	var/slot_number = pref_job_slots[job_title]
	switch(slot_number)
		if(JOB_SLOT_RANDOMISED_SLOT)
			return JOB_SLOT_RANDOMISED_TEXT
		if(1 to MAX_SAVE_SLOTS)
			var/savefile/S = new /savefile(path)
			S.cd = "/character[slot_number]"
			return "[S["real_name"]] (slot #[slot_number])"

/datum/preferences/proc/reset_job_slots()
	pref_job_slots = list()
	var/datum/job/J
	for(var/role in GLOB.RoleAuthority.roles_by_path)
		J = GLOB.RoleAuthority.roles_by_path[role]
		pref_job_slots[J.title] = JOB_SLOT_CURRENT_SLOT

/datum/preferences/proc/process_link(mob/user, list/href_list)


	switch(href_list["preference"])
		if("job")
			switch(href_list["task"])
				if("close")
					close_browser(user, "mob_occupation")
					ShowChoices(user)
				if("reset")
					ResetJobs()
					SetChoices(user)
				if("random")
					if(alternate_option == GET_RANDOM_JOB || alternate_option == BE_MARINE || alternate_option == RETURN_TO_LOBBY)
						alternate_option++
					else if(alternate_option == BE_XENOMORPH)
						alternate_option = 0
					else
						return 0
					SetChoices(user)
				if("input")
					var/priority = text2num(href_list["target_priority"])
					SetJob(user, href_list["text"], priority)
					ShowChoices(user)
					update_all_pickers(user)
				else
					SetChoices(user)
			return TRUE
		if("job_slot")
			switch(href_list["task"])
				if("close")
					close_browser(user, "job_slots_assignment")
					ShowChoices(user)
				if("assign")
					assign_job_slot(user, href_list["target_job"])
				if("start_join")
					toggle_prefs ^= TOGGLE_START_JOIN_CURRENT_SLOT
					set_job_slots(user)
				if("late_join")
					toggle_prefs ^= TOGGLE_LATE_JOIN_CURRENT_SLOT
					set_job_slots(user)
				if("reset")
					reset_job_slots()
					set_job_slots(user)
				else
					set_job_slots(user)
			return TRUE
		if("loadout")
			loadout_picker.tgui_interact(user)
			return

		if("flavor_text")
			switch(href_list["task"])
				if("open")
					SetFlavorText(user)
					return
				if("done")
					close_browser(user, "flavor_text")
					ShowChoices(user)
					return
				if("general")
					var/msg = input(usr,"Give a physical description of your character. This will be shown regardless of clothing.","Flavor Text",html_decode(flavor_texts[href_list["task"]])) as message
					if(msg != null)
						msg = copytext(msg, 1, MAX_MESSAGE_LEN)
						msg = html_encode(msg)
					flavor_texts[href_list["task"]] = msg
				else
					var/msg = input(usr,"Set the flavor text for your [href_list["task"]].","Flavor Text",html_decode(flavor_texts[href_list["task"]])) as message
					if(msg != null)
						msg = copytext(msg, 1, MAX_MESSAGE_LEN)
						msg = html_encode(msg)
					flavor_texts[href_list["task"]] = msg
			SetFlavorText(user)
			return

		if("records")
			if(text2num(href_list["record"]) >= 1)
				SetRecords(user)
				return
			else
				close_browser(user, "records")

			switch(href_list["task"])
				if("med_record")
					var/medmsg = input(usr,"Set your medical notes here.","Medical Records",html_decode(med_record)) as message

					if(medmsg != null)
						medmsg = copytext(medmsg, 1, MAX_PAPER_MESSAGE_LEN)
						medmsg = html_encode(medmsg)

						med_record = medmsg
						SetRecords(user)

				if("sec_record")
					var/secmsg = input(usr,"Set your security notes here.","Security Records",html_decode(sec_record)) as message

					if(secmsg != null)
						secmsg = copytext(secmsg, 1, MAX_PAPER_MESSAGE_LEN)
						secmsg = html_encode(secmsg)

						sec_record = secmsg
						SetRecords(user)
				if("gen_record")
					var/genmsg = input(usr,"Set your employment notes here.","Employment Records",html_decode(gen_record)) as message

					if(genmsg != null)
						genmsg = copytext(genmsg, 1, MAX_PAPER_MESSAGE_LEN)
						genmsg = html_encode(genmsg)

						gen_record = genmsg
						SetRecords(user)

		if("hotkeys")
			hotkeys = !hotkeys
			if(hotkeys)
				winset(user, null, "input.focus=true")
			else
				winset(user, null, "input.focus=false")

		if("traits")
			traits_picker.tgui_interact(user)
			return

		if("toggle_job_gear")
			show_job_gear = !show_job_gear

		if("cycle_bg")
			bg_state = next_in_list(bg_state, GLOB.bgstate_options)

	switch (href_list["task"])
		if ("random")
			switch (href_list["preference"])
				if ("name")
					var/datum/origin/character_origin = GLOB.origins[origin]
					real_name = character_origin.generate_human_name(gender)
				if ("age")
					age = rand(AGE_MIN, AGE_MAX)
				if ("skin_color")
					skin_color = random_skin_color()
				if ("body_type")
					body_type = random_body_type()
				if ("body_size")
					body_size = random_body_size()
				if ("hair")
					r_hair = rand(0,255)
					g_hair = rand(0,255)
					b_hair = rand(0,255)
				if ("h_style")
					h_style = random_hair_style(gender, species)
				if ("facial")
					r_facial = rand(0,255)
					g_facial = rand(0,255)
					b_facial = rand(0,255)
				if ("f_style")
					f_style = random_facial_hair_style(gender, species)
				if ("underwear")
					underwear = gender == MALE ? pick(GLOB.underwear_m) : pick(GLOB.underwear_f)
					ShowChoices(user)
				if ("undershirt")
					undershirt = gender == MALE ? pick(GLOB.undershirt_m) : pick(GLOB.undershirt_f)
					ShowChoices(user)
				if ("eyes")
					r_eyes = rand(0,255)
					g_eyes = rand(0,255)
					b_eyes = rand(0,255)

				if ("s_color")
					r_skin = rand(0,255)
					g_skin = rand(0,255)
					b_skin = rand(0,255)
				if ("bag")
					backbag = rand(1,2)

				if ("all")
					randomize_appearance()
		if("input")
			var/datum/entity/player/player = get_player_from_key(user.ckey)
			var/whitelist_flags = player.whitelist_flags

			switch(href_list["preference"])
				if("name")
					if(human_name_ban)
						to_chat(user, SPAN_NOTICE("You are banned from custom human names."))
						return
					var/raw_name = input(user, "Choose your character's name:", "Character Preference")  as text|null
					if (!isnull(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("xeno_vision_level_pref")
					var/static/list/vision_level_choices = list(XENO_VISION_LEVEL_NO_NVG, XENO_VISION_LEVEL_MID_NVG, XENO_VISION_LEVEL_HIGH_NVG,  XENO_VISION_LEVEL_FULL_NVG)
					var/choice = tgui_input_list(user, "Choose your default xeno vision level", "Vision level", vision_level_choices, theme="hive_status")
					if(!choice)
						return
					xeno_vision_level_pref = choice
				if("ghost_vision_pref")
					var/static/list/vision_level_choices = list(GHOST_VISION_LEVEL_NO_NVG, GHOST_VISION_LEVEL_MID_NVG, GHOST_VISION_LEVEL_HIGH_NVG, GHOST_VISION_LEVEL_FULL_NVG)
					var/choice = tgui_input_list(user, "Choose your default ghost vision level", "Vision level", vision_level_choices)
					if(!choice)
						return
					ghost_vision_pref = choice
				if("mouse_button_activation")
					var/static/list/mouse_button_list = list(
						xeno_ability_mouse_pref_to_string(XENO_ABILITY_CLICK_MIDDLE) = XENO_ABILITY_CLICK_MIDDLE,
						xeno_ability_mouse_pref_to_string(XENO_ABILITY_CLICK_SHIFT) = XENO_ABILITY_CLICK_SHIFT,
						xeno_ability_mouse_pref_to_string(XENO_ABILITY_CLICK_RIGHT) = XENO_ABILITY_CLICK_RIGHT
					)
					var/choice = tgui_input_list(user, "Choose how you will activate your xenomorph and human abilities.", "Mouse Activation Button", mouse_button_list)
					if(!choice)
						return
					xeno_ability_click_mode = mouse_button_list[choice]
					// This isn't that great of a way to do it, but ability code is already not that modular considering
					// the fact that we have two datums for xeno/human abilities. Might need to refactor abilities as a whole in the future
					// so that the `activable` type is the parent of both xeno/human abilities - it would get rid of this headache in an instant.
					if(isxeno(user))
						var/mob/living/carbon/xenomorph/xeno = user
						if(xeno.selected_ability)
							var/datum/action/xeno_action/activable/ability = xeno.selected_ability
							xeno.set_selected_ability(null)
							xeno.set_selected_ability(ability)
					if(ishuman(user))
						var/mob/living/carbon/human/human = user
						if(human.selected_ability)
							var/datum/action/human_action/activable/ability = human.selected_ability
							human.set_selected_ability(null)
							human.set_selected_ability(ability)
				if("synth_name")
					var/raw_name = input(user, "Choose your Synthetic's name:", "Character Preference")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							synthetic_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
				if("synth_type")
					var/new_synth_type = tgui_input_list(user, "Choose your model of synthetic:", "Make and Model", PLAYER_SYNTHS)
					if(new_synth_type)
						synthetic_type = new_synth_type
				if("pred_name")
					var/raw_name = input(user, "Choose your Predator's name:", "Character Preference")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							predator_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
				if("pred_gender")
					predator_gender = predator_gender == MALE ? FEMALE : MALE
				if("pred_age")
					var/new_predator_age = tgui_input_number(user, "Choose your Predator's age(175 to 3000):", "Character Preference", 1234, 3000, 175)
					if(new_predator_age)
						predator_age = max(min( floor(text2num(new_predator_age)), 3000),175)
				if("pred_use_legacy")
					var/legacy_choice = tgui_input_list(user, "What legacy set do you wish to use?", "Legacy Set", PRED_LEGACIES)
					if(!legacy_choice)
						return
					predator_use_legacy = legacy_choice
				if("pred_trans_type")
					var/new_translator_type = tgui_input_list(user, "Choose your translator type.", "Translator Type", PRED_TRANSLATORS)
					if(!new_translator_type)
						return
					predator_translator_type = new_translator_type
				if("pred_mask_type")
					var/new_predator_mask_type = tgui_input_number(user, "Choose your mask type:\n(1-19)", "Mask Selection", 1, PRED_MASK_TYPE_MAX, 1)
					if(new_predator_mask_type)
						predator_mask_type = floor(text2num(new_predator_mask_type))
				if("pred_accessory_type")
					var/new_predator_accessory_type = tgui_input_number(user, "Choose your mask accessory type:\n(0-1)", "Accessory Selection", 0, PRED_MASK_ACCESSORY_TYPE_MAX, 0)
					if(new_predator_accessory_type)
						predator_accessory_type = floor(text2num(new_predator_accessory_type))
				if("pred_armor_type")
					var/new_predator_armor_type = tgui_input_number(user, "Choose your armor type:\n(1-8)", "Armor Selection", 1, PRED_ARMOR_TYPE_MAX, 1)
					if(new_predator_armor_type)
						predator_armor_type = floor(text2num(new_predator_armor_type))
				if("pred_boot_type")
					var/new_predator_boot_type = tgui_input_number(user, "Choose your greaves type:\n(1-4)", "Greave Selection", 1, PRED_GREAVE_TYPE_MAX, 1)
					if(new_predator_boot_type)
						predator_boot_type = floor(text2num(new_predator_boot_type))
				if("pred_mask_mat")
					var/new_pred_mask_mat = tgui_input_list(user, "Choose your mask material:", "Mask Material", PRED_MATERIALS)
					if(!new_pred_mask_mat)
						return
					predator_mask_material = new_pred_mask_mat
				if("pred_armor_mat")
					var/new_pred_armor_mat = tgui_input_list(user, "Choose your armor material:", "Armor Material", PRED_MATERIALS)
					if(!new_pred_armor_mat)
						return
					predator_armor_material = new_pred_armor_mat
				if("pred_greave_mat")
					var/new_pred_greave_mat = tgui_input_list(user, "Choose your greave material:", "Greave Material", PRED_MATERIALS)
					if(!new_pred_greave_mat)
						return
					predator_greave_material = new_pred_greave_mat
				if("pred_caster_mat")
					var/new_pred_caster_mat = tgui_input_list(user, "Choose your caster material:", "Caster Material", PRED_MATERIALS + "retro")
					if(!new_pred_caster_mat)
						return
					predator_caster_material = new_pred_caster_mat
				if("pred_cape_color")
					var/new_cape_color = input(user, "Choose your cape color:", "Cape Color", predator_cape_color) as color|null
					if(!new_cape_color)
						return
					predator_cape_color = new_cape_color
				if("pred_hair")
					var/new_h_style = input(user, "Choose your quill style:", "Quill Style") as null|anything in GLOB.yautja_hair_styles_list
					if(!new_h_style)
						return
					predator_h_style = new_h_style
				if("pred_skin")
					var/new_skin_color = tgui_input_list(user, "Choose your skin color:", "Skin Color", PRED_SKIN_COLOR)
					if(!new_skin_color)
						return
					predator_skin_color = new_skin_color
				if("pred_flavor_text")
					var/pred_flv_raw = input(user, "Choose your Predator's flavor text:", "Flavor Text", predator_flavor_text) as message
					if(!pred_flv_raw)
						predator_flavor_text = ""
						return
					predator_flavor_text = strip_html(pred_flv_raw, MAX_MESSAGE_LEN)

				if("commander_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & (WHITELIST_COMMANDER_LEADER|WHITELIST_COMMANDER_COLONEL))
						options += list("Leader" = WHITELIST_LEADER)

					var/new_commander_status = tgui_input_list(user, "Choose your new Commander Whitelist Status.", "Commander Status", options)

					if(!new_commander_status)
						return

					commander_status = options[new_commander_status]

				if("co_sidearm")
					var/list/options = CO_GUNS

					if(whitelist_flags & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
						options += COUNCIL_CO_GUNS
					else
						options -= COUNCIL_CO_GUNS

					var/new_co_sidearm = tgui_input_list(user, "Choose your preferred sidearm.", "Commanding Officer's Sidearm", options)
					if(!new_co_sidearm)
						return
					commander_sidearm = new_co_sidearm

				if("co_affiliation")
					var/new_co_affiliation = tgui_input_list(user, "Choose your faction affiliation.", "Commanding Officer's Affiliation", FACTION_ALLEGIANCE_USCM_COMMANDER)
					if(!new_co_affiliation)
						return
					affiliation = new_co_affiliation

				if("co_career_path")
					var/list/options = list("Infantry", "Engineering", "Medical", "Intel", "Logistics", "Aviation", "Tanker")

					var/new_career_path = tgui_input_list(user, "Choose your new Career Path.", "Career Path", options)

					if(!new_career_path)
						return

					co_career_path = new_career_path


				if("yautja_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & (WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY))
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_YAUTJA_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_yautja_status = tgui_input_list(user, "Choose your new Yautja Whitelist Status.", "Yautja Status", options)

					if(!new_yautja_status)
						return

					yautja_status = options[new_yautja_status]

				if("synth_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & (WHITELIST_SYNTHETIC_COUNCIL|WHITELIST_SYNTHETIC_COUNCIL_LEGACY))
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_SYNTHETIC_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_synth_status = tgui_input_list(user, "Choose your new Synthetic Whitelist Status.", "Synthetic Status", options)

					if(!new_synth_status)
						return

					synth_status = options[new_synth_status]

				if("fax_name")
					var/faction = href_list["fax_faction"]
					var/raw_name = tgui_input_text(user, "Choose your Fax Responder's name:", "Responder Name")
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(!new_name)
							to_chat(user, SPAN_RED("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
							return

						switch(faction)
							if("uscm")
								fax_name_uscm = new_name
							if("pvst")
								fax_name_pvst = new_name
							if("wy")
								fax_name_wy = new_name
							if("upp")
								fax_name_upp = new_name
							if("twe")
								fax_name_twe = new_name
							if("cmb")
								fax_name_cmb = new_name
							if("press")
								fax_name_press = new_name
							if("clf")
								fax_name_clf = new_name

				if("xeno_prefix")
					if(xeno_name_ban)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You are banned from xeno name picking.")))
						xeno_prefix = ""
						return

					var/new_xeno_prefix = input(user, "Choose your xenomorph prefix. One or two letters capitalized. Put empty text if you want to default it to 'XX'", "Xenomorph Prefix") as text|null
					new_xeno_prefix = uppertext(new_xeno_prefix)

					var/prefix_length = length(new_xeno_prefix)

					if(prefix_length>3)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("Invalid Xeno Prefix. Your Prefix can only be up to 3 letters long.")))
						return

					if(prefix_length==3)
						var/playtime = user.client.get_total_xeno_playtime()
						if(playtime < 124 HOURS)
							to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You need to play [time_left_until(124 HOURS, playtime, 1 HOURS)] more hours to unlock xeno three letter prefix.")))
							return
						if(xeno_postfix)
							to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You can't use three letter prefix with any postfix.")))
							return

					if(length(new_xeno_prefix)==0)
						xeno_prefix = "XX"
						owner.load_xeno_name()
					else
						var/all_ok = TRUE
						for(var/i=1, i<=length(new_xeno_prefix), i++)
							var/ascii_char = text2ascii(new_xeno_prefix,i)
							if(ascii_char < 65 || ascii_char > 90)
								all_ok = FALSE //everything else - won't
						if(all_ok)
							xeno_prefix = new_xeno_prefix
							owner.load_xeno_name()
						else
							to_chat(user, "<font color='red'>Invalid Xeno Prefix. Your Prefix can contain either single letter or two letters.</font>")

				if("xeno_postfix")
					if(xeno_name_ban)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You are banned from xeno name picking.")))
						xeno_postfix = ""
						return
					var/playtime = user.client.get_total_xeno_playtime()
					if(playtime < 24 HOURS)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You need to play [time_left_until(24 HOURS, playtime, 1 HOURS)] more hours to unlock xeno postfix.")))
						return

					if(length(xeno_prefix)==3)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You can't use three letter prefix with any postfix.")))
						return

					var/new_xeno_postfix = input(user, "Choose your xenomorph postfix. One capital letter with or without a digit at the end. Put empty text if you want to remove postfix", "Xenomorph Postfix") as text|null
					new_xeno_postfix = uppertext(new_xeno_postfix)
					if(length(new_xeno_postfix)>2)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("Invalid Xeno Postfix. Your Postfix can only be up to 2 letters long.")))
						return
					else if(length(new_xeno_postfix)==0)
						xeno_postfix = ""
						owner.load_xeno_name()
					else
						var/all_ok = TRUE
						var/first_char = TRUE
						for(var/i=1, i<=length(new_xeno_postfix), i++)
							var/ascii_char = text2ascii(new_xeno_postfix,i)
							switch(ascii_char)
								// A  .. Z
								if(65 to 90) //Uppercase Letters will work on first char

									if(length(xeno_prefix)!=2)
										to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You can't use three letter prefix with any postfix.")))
										return

									if(!first_char && playtime < 300 HOURS)
										to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You need to play [time_left_until(300 HOURS, playtime, 1 HOURS)] more hours to unlock double letter xeno postfix.")))
										all_ok = FALSE
								// 0  .. 9
								if(48 to 57) //Numbers will work if not the first char
									if(first_char)
										all_ok = FALSE
								else
									all_ok = FALSE //everything else - won't
							first_char = FALSE
						if(all_ok)
							xeno_postfix = new_xeno_postfix
							owner.load_xeno_name()
						else
							to_chat(user, "<font color='red'>Invalid Xeno Postfix. Your Postfix can contain single letter and an optional digit after it.</font>")

				if("age")
					var/new_age = tgui_input_number(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference", 19, AGE_MAX, AGE_MIN)
					if(new_age)
						age = max(min( floor(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
					if(new_metadata)
						metadata = strip_html(new_metadata)

				if("hair")
					hair_picker.tgui_interact(user)
					return

				if ("body")
					body_picker.tgui_interact(user)
					return

				if("underwear")
					var/list/underwear_options = gender == MALE ? GLOB.underwear_m : GLOB.underwear_f
					var/old_gender = gender
					var/new_underwear = tgui_input_list(user, "Choose your character's underwear:", "Character Preference", underwear_options)
					if(old_gender != gender)
						return
					if(new_underwear)
						underwear = new_underwear
					ShowChoices(user)

				if("undershirt")
					var/list/undershirt_options = gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f
					var/old_gender = gender
					var/new_undershirt = tgui_input_list(user, "Choose your character's undershirt:", "Character Preference", undershirt_options)
					if(old_gender != gender)
						return
					if(new_undershirt)
						undershirt = new_undershirt
					ShowChoices(user)

				if("eyes")
					var/new_eyes = tgui_color_picker(user, "Choose your character's eye color:", "Character Preference", rgb(r_eyes, g_eyes, b_eyes))

					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))


				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC color:", "Game Preference", ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in GLOB.backbaglist
					if(new_backbag)
						backbag = GLOB.backbaglist.Find(new_backbag)

				if("wy_relation")
					var/new_relation = input(user, "Choose your relation to the Weyland-Yutani company. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
					if(new_relation)
						weyland_yutani_relation = new_relation

				if("prefsquad")
					var/new_pref_squad = input(user, "Choose your preferred squad.", "Character Preference")  as null|anything in list("Alpha", "Bravo", "Charlie", "Delta", "None")
					if(new_pref_squad)
						preferred_squad = new_pref_squad

				if("prefnvg")
					var/new_nvg_color = tgui_input_list(user, "Choose the color of your night-vision", "Character Preferences", GLOB.nvg_color_list)
					if(!new_nvg_color)
						return
					night_vision_preference = new_nvg_color

				if("prefarmor")
					var/new_pref_armor = tgui_input_list(user, "Choose your character's default style of armor:", "Character Preferences", GLOB.armor_style_list)
					if(new_pref_armor)
						preferred_armor = new_pref_armor
						// Update the dummy with the new armor style.
						update_preview_icon()

				if("limbs")
					var/limb_name = tgui_input_list(user, "Which limb do you want to change?", list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand"))
					if(!limb_name)
						return

					var/limb = null
					var/second_limb = null // if you try to change the arm, the hand should also change
					var/third_limb = null  // if you try to unchange the hand, the arm should also change
					switch(limb_name)
						if("Left Leg")
							limb = "l_leg"
							second_limb = "l_foot"
						if("Right Leg")
							limb = "r_leg"
							second_limb = "r_foot"
						if("Left Arm")
							limb = "l_arm"
							second_limb = "l_hand"
						if("Right Arm")
							limb = "r_arm"
							second_limb = "r_hand"
						if("Left Foot")
							limb = "l_foot"
							third_limb = "l_leg"
						if("Right Foot")
							limb = "r_foot"
							third_limb = "r_leg"
						if("Left Hand")
							limb = "l_hand"
							third_limb = "l_arm"
						if("Right Hand")
							limb = "r_hand"
							third_limb = "r_arm"

					var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?", list("Normal","Prothesis")) //"Amputated")
					if(!new_state)
						return

					switch(new_state)
						if("Normal")
							organ_data[limb] = null
							if(third_limb)
								organ_data[third_limb] = null
						if("Prothesis")
							organ_data[limb] = "cyborg"
							if(second_limb)
								organ_data[second_limb] = "cyborg"
							if(third_limb && organ_data[third_limb] == "amputated")
								organ_data[third_limb] = null
				if("organs")
					var/organ_name = tgui_input_list(user, "Which internal function do you want to change?", list("Heart", "Eyes"))
					if(!organ_name)
						return

					var/organ = null
					switch(organ_name)
						if("Heart")
							organ = "heart"
						if("Eyes")
							organ = "eyes"

					var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "Organ state", list("Normal","Assisted","Mechanical"))
					if(!new_state)
						return

					switch(new_state)
						if("Normal")
							organ_data[organ] = null
						if("Assisted")
							organ_data[organ] = "assisted"
						if("Mechanical")
							organ_data[organ] = "mechanical"

				if("skin_style")
					var/skin_style_name = tgui_input_list(user, "Select a new skin style", "Skin style", list("default1", "default2", "default3"))
					if(!skin_style_name)
						return

				if("origin")
					var/choice = tgui_input_list(user, "Please choose your character's origin.", "Origin Selection", GLOB.player_origins)
					var/datum/origin/picked_choice = GLOB.origins[choice]
					if(!picked_choice)
						return
					if(tgui_alert(user, "You've selected [picked_choice.name]. [picked_choice.desc]", "Selected Origin", list("Confirm", "Cancel")) == "Cancel")
						return
					if(choice)
						origin = choice

				if("religion")
					var/choice = tgui_input_list(user, "Please choose a religion.", "Religion choice", GLOB.religion_choices + "Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter a religon.")  as text|null
						if(raw_choice)
							religion = strip_html(raw_choice) // This only updates itself in the UI when another change is made, eg. save slot or changing other char settings.
						return
					religion = choice

				if("special_job_select")
					var/datum/job/job = GLOB.RoleAuthority.roles_by_name[href_list["text"]]
					if(!job)
						close_browser(user, "mob_occupation")
						ShowChoices(user)
						return

					var/list/filtered_options = job.filter_job_option(user)

					var/new_special_job_variant = tgui_input_list(user, "Choose your preferred job variant:", "Preferred Job Variant", filtered_options)
					if(!new_special_job_variant)
						return
					pref_special_job_options[job.title] = new_special_job_variant

					SetChoices(user)
					return
		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggle_prefs ^= TOGGLE_MEMBER_PUBLIC

				if("ooc_flag")
					if(CONFIG_GET(flag/ooc_country_flags))
						toggle_prefs ^= TOGGLE_OOC_FLAG
					else
						to_chat(user, SPAN_WARNING("Country Flags in OOC are disabled in the current server configuration!"))

				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE
					underwear = sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear))
					undershirt = sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))

					// Refresh hair picker
					var/datum/tgui/picker_ui = SStgui.get_open_ui(user, hair_picker)
					if(picker_ui)
						picker_ui.send_update()

				if("hear_adminhelps")
					toggles_sound ^= SOUND_ADMINHELP

				if("ui")
					var/ui_style_choice = tgui_input_list(user, "Choose your UI style", "UI style", GLOB.custom_human_huds)
					if(ui_style_choice)
						UI_style = ui_style_choice

				if("UIcolor")
					var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!", UI_style_color) as color|null
					if(UI_style_color_new)
						UI_style_color = UI_style_color_new

				if("UIalpha")
					var/UI_style_alpha_new = tgui_input_number(user, "Select a new alpha (transparency) parameter for your UI, between 50 and 255", "Select alpha", 255, 255, 50)
					if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
						return
					UI_style_alpha = UI_style_alpha_new

				if("stylesheet")
					var/stylesheet_new = tgui_input_list(user, "Select a stylesheet to use (affects non-NanoUI interfaces)", "Select a stylesheet", GLOB.stylesheets)
					stylesheet = stylesheet_new

				if("hide_statusbar")
					hide_statusbar = !hide_statusbar
					if(hide_statusbar)
						winset(owner, "mapwindow.status_bar", "text=\"\"")
						winset(owner, "mapwindow.status_bar", "is-visible=false")
					else
						winset(owner, "mapwindow.status_bar", "is-visible=true")


				if("no_radials_preference")
					no_radials_preference = !no_radials_preference

				if("no_radial_labels_preference")
					no_radial_labels_preference = !no_radial_labels_preference

				if("ViewMC")
					if(user.client.admin_holder && user.client.admin_holder.rights & R_DEBUG)
						View_MC = !View_MC

				if("playtime_perks")
					playtime_perks = !playtime_perks

				if("show_queen_name")
					show_queen_name = !show_queen_name

				if("be_special")
					var/num = text2num(href_list["num"])
					be_special ^= num

				if("rand_name")
					be_random_name = !be_random_name

				if("rand_body")
					be_random_body = !be_random_body

				if("hear_admin_sounds")
					toggles_sound ^= SOUND_MIDI
					if(!(toggles_sound & SOUND_MIDI))
						user?.client?.tgui_panel?.stop_music()

				if("hear_observer_announcements")
					toggles_sound ^= SOUND_OBSERVER_ANNOUNCEMENTS

				if("hear_faxes")
					toggles_sound ^= SOUND_FAX_MACHINE

				if("lobby_music")
					toggles_sound ^= SOUND_LOBBY
					if(toggles_sound & SOUND_LOBBY)
						user << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
					else
						user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

				if("sound_vox")
					hear_vox = !hear_vox

				if("ghost_ears")
					toggles_chat ^= CHAT_GHOSTEARS

				if("ghost_sight")
					toggles_chat ^= CHAT_GHOSTSIGHT

				if("ghost_radio")
					toggles_chat ^= CHAT_GHOSTRADIO

				if("ghost_spyradio")
					toggles_chat ^= CHAT_LISTENINGBUG

				if("ghost_hivemind")
					toggles_chat ^= CHAT_GHOSTHIVEMIND

				if("langchat_emotes")
					toggles_langchat ^= LANGCHAT_SEE_EMOTES

				if("lang_chat_disabled")
					lang_chat_disabled = !lang_chat_disabled

				if("viewmacros")
					macros.tgui_interact(usr)

				if("toggle_prefs")
					var/flag = text2num(href_list["flag"])
					var/flag_undo = text2num(href_list["flag_undo"])
					toggle_prefs ^= flag
					if (toggle_prefs & flag && toggle_prefs & flag_undo)
						toggle_prefs ^= flag_undo

				if("switch_prefs") //wart
					var/list/pref_list = list(text2num(href_list["flag1"]), text2num(href_list["flag2"]), text2num(href_list["flag3"]))
					var/pref_new = tgui_input_list(user, "Select the preference tier you need", "Select preference tier", pref_list)
					for(var/flag in pref_list)
						//remove all flags in list
						if(CHECK_BITFIELD(toggle_prefs, flag))
							DISABLE_BITFIELD(toggle_prefs, flag)
					//add the new flag
					ENABLE_BITFIELD(toggle_prefs, pref_new)

				if("toggles_ert")
					var/flag = text2num(href_list["flag"])
					toggles_ert ^= flag

				if("toggles_ert_pred")
					var/flag = text2num(href_list["flag"])
					toggles_ert_pred ^= flag

				if("ambientocclusion")
					toggle_prefs ^= TOGGLE_AMBIENT_OCCLUSION
					var/atom/movable/screen/plane_master/game_world/plane_master = locate() in user?.client.screen
					if (!plane_master)
						return
					plane_master.backdrop(user?.client.mob)

				if("newplayer_ghost_hud")
					observer_huds[HUD_MENTOR_SIGHT] = !observer_huds[HUD_MENTOR_SIGHT]

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && owner)
						owner.fit_viewport()

				if("adaptive_zoom")
					adaptive_zoom += 1
					if(adaptive_zoom == 3)
						adaptive_zoom = 0
					owner?.adaptive_zoom()

				if("tooltips")
					tooltips = !tooltips
					save_preferences()

					if(!tooltips)
						closeToolTip()
						return

					if(!owner.tooltips)
						owner.tooltips = new(owner)

				if("inputstyle")
					var/result = tgui_alert(user, "Which input style do you want?", "Input Style", list("Modern", "Legacy"))
					if(!result)
						return
					if(result == "Legacy")
						tgui_say = FALSE
						to_chat(user, SPAN_NOTICE("You're now using the old interface."))
					else
						tgui_say = TRUE
						to_chat(user, SPAN_NOTICE("You're now using the new interface."))
					user?.client.update_special_keybinds()
					save_preferences()

				if("inputcolor")
					var/result = tgui_alert(user, "Which input color do you want?", "Input Style", list("Darkmode", "Lightmode"))
					if(!result)
						return
					if(result == "Lightmode")
						tgui_say_light_mode = TRUE
						to_chat(user, SPAN_NOTICE("You're now using the say interface whitemode."))
					else
						tgui_say_light_mode = FALSE
						to_chat(user, SPAN_NOTICE("You're now using the say interface darkmode."))
					user?.client.tgui_say?.load()
					save_preferences()

				if("customcursors")
					owner?.do_toggle_custom_cursors(owner?.mob)

				if("save")
					if(save_cooldown > world.time)
						to_chat(user, SPAN_WARNING("You need to wait [floor((save_cooldown-world.time)/10)] seconds before you can do that again."))
						return
					var/datum/origin/character_origin = GLOB.origins[origin]
					var/name_error = character_origin.validate_name(real_name)
					if(name_error)
						tgui_alert(user, name_error, "Invalid Name", list("OK"))
						return
					save_preferences()
					save_character()
					save_cooldown = world.time + 50

				if("reload")
					if(reload_cooldown > world.time)
						to_chat(user, SPAN_WARNING("You need to wait [floor((reload_cooldown-world.time)/10)] seconds before you can do that again."))
						return
					load_preferences()
					load_character()
					reload_cooldown = world.time + 50

					update_all_pickers(user)

				if("open_load_dialog")
					if(!IsGuestKey(user.key))
						open_load_dialog(user)
						return TRUE

				if("close_load_dialog")
					close_load_dialog(user)
					return TRUE

				if("changeslot")
					load_character(text2num(href_list["num"]))
					close_load_dialog(user)

					update_all_pickers(user)

				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock

				if("change_menu")
					current_menu = href_list["menu"]

				if("yautja")
					if(!owner.check_whitelist_status(WHITELIST_PREDATOR))
						return

					pred_picker.tgui_interact(user)
					return

	ShowChoices(user)
	return 1


/// Loads appropriate character slot for the given job as assigned in preferences.
/datum/preferences/proc/find_assigned_slot(job_title, is_late_join = FALSE)
	if(toggle_prefs & (is_late_join ? TOGGLE_LATE_JOIN_CURRENT_SLOT : TOGGLE_START_JOIN_CURRENT_SLOT))
		return
	var/slot_for_job = pref_job_slots[job_title]
	switch(slot_for_job)
		if(JOB_SLOT_RANDOMISED_SLOT)
			be_random_body = TRUE
			be_random_name = TRUE
		if(1 to MAX_SAVE_SLOTS)
			load_character(slot_for_job)

/// Transfers both physical characteristics and character information to character
/datum/preferences/proc/copy_all_to(mob/living/carbon/human/character, job_title, is_late_join = FALSE, check_datacore = FALSE)
	if(!istype(character))
		return

	if(job_title)
		find_assigned_slot(job_title, is_late_join)
	if(check_datacore && !(be_random_body && be_random_name))
		for(var/datum/data/record/record as anything in GLOB.data_core.locked)
			if(record.fields["name"] == real_name)
				be_random_body = TRUE
				be_random_name = TRUE
				break

	if(be_random_name)
		real_name = random_name(gender)

	if(CONFIG_GET(flag/humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace) //we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.real_name = real_name
	character.voice = real_name
	character.name = character.real_name

	if(!be_random_body)
		character.flavor_texts["general"] = flavor_texts["general"]
		character.flavor_texts["head"] = flavor_texts["head"]
		character.flavor_texts["face"] = flavor_texts["face"]
		character.flavor_texts["eyes"] = flavor_texts["eyes"]
		character.flavor_texts["torso"] = flavor_texts["torso"]
		character.flavor_texts["arms"] = flavor_texts["arms"]
		character.flavor_texts["hands"] = flavor_texts["hands"]
		character.flavor_texts["legs"] = flavor_texts["legs"]
		character.flavor_texts["feet"] = flavor_texts["feet"]

	if(!be_random_name)
		character.med_record = strip_html(med_record)
		character.sec_record = strip_html(sec_record)
		character.gen_record = strip_html(gen_record)
		character.exploit_record = strip_html(exploit_record)

	character.age = age
	character.gender = gender
	character.skin_color = skin_color
	character.body_type = body_type
	character.body_size = body_size
	character.body_presentation = get_body_presentation()

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	if(/datum/character_trait/hair_dye in traits)
		character.r_gradient = r_gradient
		character.g_gradient = g_gradient
		character.b_gradient = b_gradient
		character.grad_style = grad_style
	else
		character.r_gradient = initial(character.r_gradient)
		character.g_gradient = initial(character.g_gradient)
		character.b_gradient = initial(character.b_gradient)
		character.grad_style = initial(character.grad_style)

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.h_style = h_style
	character.f_style = f_style

	character.origin = origin
	character.personal_faction = faction
	character.religion = religion

	// Destroy/cyborgize organs

	for(var/name in organ_data)

		var/status = organ_data[name]
		var/obj/limb/O = character.get_limb(name)
		if(O)
// if(status == "amputated")
// O.amputated = 1
// O.status |= LIMB_DESTROYED
// O.destspawn = 1
			if(status == "cyborg")
				O.status |= LIMB_ROBOT
		else
			var/datum/internal_organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.mechanize()

	sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear)) //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))
	character.underwear = underwear
	character.undershirt = undershirt

	if(backbag > 2 || backbag < 1)
		backbag = 2 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

// Transfers the character's physical characteristics (age, gender, skin_color, etc) to the mob
/datum/preferences/proc/copy_appearance_to(mob/living/carbon/human/character, safety = 0)
	if(!istype(character))
		return

	character.age = age
	character.gender = gender
	character.skin_color = skin_color
	character.body_type = body_type
	character.body_size = body_size
	character.body_presentation = get_body_presentation()

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	if(/datum/character_trait/hair_dye in traits)
		character.r_gradient = r_gradient
		character.g_gradient = g_gradient
		character.b_gradient = b_gradient
		character.grad_style = grad_style
	else
		character.r_gradient = initial(character.r_gradient)
		character.g_gradient = initial(character.g_gradient)
		character.b_gradient = initial(character.b_gradient)
		character.grad_style = initial(character.grad_style)

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.h_style = h_style
	character.f_style = f_style

	// Destroy/cyborgize organs

	for(var/name in organ_data)

		var/status = organ_data[name]
		var/obj/limb/O = character.get_limb(name)
		if(O)
			if(status == "cyborg")
				O.status |= LIMB_ROBOT
		else
			var/datum/internal_organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.mechanize()

	sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear)) //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))
	character.underwear = underwear
	character.undershirt = undershirt

	if(backbag > 2 || backbag < 1)
		backbag = 2 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body onselectstart='return false;'>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<=MAX_SAVE_SLOTS, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)
				name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='byond://?_src_=prefs;preference=changeslot;num=[i];'>[name]</a><br>"

	dat += "<hr>"
	dat += "<a href='byond://?src=\ref[user];preference=close_load_dialog'>Close</a><br>"
	dat += "</center></tt>"
	show_browser(user, dat, "Load Character", "saves")

/datum/preferences/proc/close_load_dialog(mob/user)
	close_browser(user, "saves")

/datum/preferences/proc/parse_key_down(client/source, key)
	SIGNAL_HANDLER
	key = uppertext(key)

	if (key in key_mod_buf)
		return

	if (key in GLOB.key_mods)
		key_mod_buf.Add(key)

/datum/preferences/proc/set_key_buf(client/source, key)
	SIGNAL_HANDLER
	key_buf = ""

	var/key_upper = uppertext(key)

	for (var/mod in key_mod_buf)
		if (mod == key_upper)
			continue
		key_buf += "[mod]+"

	key_mod_buf = null

	key_buf += key

/datum/preferences/proc/read_key()
	// Null out key_buf (it's the main 'signal' for when button has been pressed)
	key_buf = null

	// Initialize key_mod_buf
	key_mod_buf = list()

	// Store the old macro set being used (gonna load back after key_buf is set)
	var/old = params2list(winget(owner, "mainwindow", "macro"))[1]

	alert("Press OK below, and then input the key sequence!")

	RegisterSignal(owner, COMSIG_CLIENT_KEY_DOWN, PROC_REF(parse_key_down))
	RegisterSignal(owner, COMSIG_CLIENT_KEY_UP, PROC_REF(set_key_buf))
	winset(owner, null, "mainwindow.macro=keyreader")
	UNTIL(key_buf)
	winset(owner, null, "mainwindow.macro=[old]")
	UnregisterSignal(owner, list(
		COMSIG_CLIENT_KEY_DOWN,
		COMSIG_CLIENT_KEY_UP,
	))

	alert("The key sequence is [key_buf].")
	return key_buf

/// Converts a client's list of completed tutorials into a string for saving
/datum/preferences/proc/tutorial_list_to_savestring()
	if(!length(completed_tutorials))
		return ""

	var/return_string = ""
	var/last_id = completed_tutorials[length(completed_tutorials)]
	for(var/tutorial_id in completed_tutorials)
		return_string += tutorial_id + (tutorial_id != last_id ? ";" : "")
	return return_string

/// Converts a saved string of completed tutorials into a list for in-game use
/datum/preferences/proc/tutorial_savestring_to_list(savestring)
	completed_tutorials = splittext(savestring, ";")
	return completed_tutorials

/// Refreshes all open TGUI interfaces inside the character prefs menu
/datum/preferences/proc/update_all_pickers(mob/user)
	var/datum/tgui/picker_ui = SStgui.get_open_ui(user, hair_picker)
	picker_ui?.send_update()

	picker_ui = SStgui.get_open_ui(user, body_picker)
	picker_ui?.send_update()

	/// the loadout picker does a lot of work in static data, so
	picker_ui = SStgui.get_open_ui(user, loadout_picker)
	picker_ui?.send_full_update()

	picker_ui = SStgui.get_open_ui(user, traits_picker)
	picker_ui?.send_update()

/// Closes all the TGUI interfaces inside the character prefs menu
/datum/preferences/proc/close_all_pickers(mob/user)
	var/datum/tgui/picker_ui = SStgui.get_open_ui(user, hair_picker)
	picker_ui?.close()

	picker_ui = SStgui.get_open_ui(user, body_picker)
	picker_ui?.close()

	picker_ui = SStgui.get_open_ui(user, loadout_picker)
	picker_ui?.close()

	picker_ui = SStgui.get_open_ui(user, traits_picker)
	picker_ui?.close()

/datum/preferences/proc/get_body_presentation()
	return body_presentation || gender

#undef MENU_MARINE
#undef MENU_XENOMORPH
#undef MENU_CO
#undef MENU_SYNTHETIC
#undef MENU_YAUTJA
#undef MENU_MENTOR
#undef MENU_SETTINGS
#undef MENU_SPECIAL

/datum/preferences/proc/generate_name(faction = FACTION_MARINE)
	var/female = prob(50)
	var/name = "John Doe"
	if(female)
		name = "Jane Doe"

	switch(faction)
		if(FACTION_MARINE)
			if(female)
				name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
			else
				name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
		if(FACTION_WY, FACTION_TWE)
			if(female)
				name = "[pick(GLOB.first_names_female_pmc)] [pick(GLOB.last_names_pmc)]"
			else
				name = "[pick(GLOB.first_names_male_pmc)] [pick(GLOB.last_names_pmc)]"
		if(FACTION_COLONIST, FACTION_MARSHAL)
			if(female)
				name = "[pick(GLOB.first_names_female_colonist)] [pick(GLOB.last_names_colonist)]"
			else
				name = "[pick(GLOB.first_names_male_colonist)] [pick(GLOB.last_names_colonist)]"
		if(FACTION_UPP)
			if(female)
				name = "[pick(GLOB.first_names_female_upp)] [pick(GLOB.last_names_upp)]"
			else
				name = "[pick(GLOB.first_names_male_upp)] [pick(GLOB.last_names_upp)]"
		if(FACTION_CLF)
			if(female)
				name = "[pick(GLOB.first_names_female_clf)] [pick(GLOB.last_names_clf)]"
			else
				name = "[pick(GLOB.first_names_male_clf)] [pick(GLOB.last_names_clf)]"
	return name

/// If the role being equipped into has role-specific loadout, offer the player the option to change their slot
/datum/preferences/proc/update_slot(picked_job, timeout = FALSE)
	if(!(picked_job in GLOB.roles_with_gear))
		return TRUE

	var/loadout_for_role = has_loadout_for_role(picked_job)
	if(!loadout_for_role)
		if(!timeout)
			if(tgui_alert(owner, "You have not selected any loadout for this role. Do you want to select this now?", "Loadout", list("Yes", "No")) == "Yes")
				loadout_picker.tgui_interact(owner)
				return FALSE
		return TRUE

	var/options = list()

	for(var/slot in loadout_for_role)
		var/string_to_use = "Slot [slot]"
		if(loadout_slot_names[picked_job] && loadout_slot_names[picked_job][slot])
			string_to_use = loadout_slot_names[picked_job][slot]
		options[string_to_use] = slot

	owner.mob.sight = BLIND
	var/selected = tgui_input_list(owner, "You have loadout available - which slot would you like to use?", "Slot Selection", options, theme = "crtgreen", timeout = timeout)
	owner.mob.sight = owner.mob::sight

	if(!selected)
		return FALSE


	selected_loadout_slot = options[selected]
	return TRUE


/// Gets the currently selected loadout of the provided job, or the job selected on "High"
/datum/preferences/proc/get_active_loadout(job)
	if(!job)
		job = get_high_priority_job()

	if(!job)
		return

	if(!islist(loadout[job]))
		loadout[job] = list()

	if(!islist(loadout[job]["[selected_loadout_slot]"]))
		loadout[job]["[selected_loadout_slot]"] = list()

	return loadout[job]["[selected_loadout_slot]"]

/// If the user has any loadout pre-selected for the given role
/datum/preferences/proc/has_loadout_for_role(job)
	if(!job)
		return

	if(!loadout[job])
		return

	var/slots_with_stuff = list()
	for(var/slot in loadout[job])
		if(length(loadout[job][slot]))
			slots_with_stuff += slot

	if(!length(slots_with_stuff))
		return

	return slots_with_stuff
