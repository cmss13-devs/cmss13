#define MENU_MARINE "marine"
#define MENU_XENOMORPH "xeno"
#define MENU_CO "co"
#define MENU_SYNTHETIC "synth"
#define MENU_YAUTJA "yautja"
#define MENU_MENTOR "mentor"
#define MENU_SETTINGS "settings"
#define MENU_SPECIAL "special"

var/list/preferences_datums = list()

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

var/const/MAX_SAVE_SLOTS = 10

/datum/preferences
	var/client/owner
	var/atom/movable/screen/preview/preview_front
	var/mob/living/carbon/human/dummy/preview_dummy
	var/atom/movable/screen/rotate/alt/rotate_left
	var/atom/movable/screen/rotate/rotate_right

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
	var/fps = 20
	var/last_id
	var/save_cooldown = 0 //5s cooldown between saving slots
	var/reload_cooldown = 0 //5s cooldown between loading slots

	//game-preferences
	var/lastchangelog = "" // Saved changlog filesize to detect if there was a change
	var/ooccolor
	var/be_special = 0 // Special role selection
	var/toggle_prefs = TOGGLE_MIDDLE_MOUSE_CLICK|TOGGLE_DIRECTIONAL_ATTACK|TOGGLE_MEMBER_PUBLIC|TOGGLE_AMBIENT_OCCLUSION|TOGGLE_VEND_ITEM_TO_HAND // flags in #define/mode.dm
	var/auto_fit_viewport = FALSE
	var/UI_style = "midnight"
	var/toggles_admin = TOGGLES_ADMIN_DEFAULT
	var/toggles_chat = TOGGLES_CHAT_DEFAULT
	var/toggles_ghost = TOGGLES_GHOST_DEFAULT
	var/toggles_langchat = TOGGLES_LANGCHAT_DEFAULT
	var/toggles_sound = TOGGLES_SOUND_DEFAULT
	var/toggles_flashing = TOGGLES_FLASHING_DEFAULT
	var/toggles_ert = TOGGLES_ERT_DEFAULT
	var/chat_display_preferences = CHAT_TYPE_ALL
	var/item_animation_pref_level = SHOW_ITEM_ANIMATIONS_ALL
	var/pain_overlay_pref_level = PAIN_OVERLAY_BLURRY
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/View_MC = FALSE
	var/window_skin = 0
	var/list/observer_huds = list(
							"Medical HUD" = FALSE,
							"Security HUD" = FALSE,
							"Squad HUD" = FALSE,
							"Xeno Status HUD" = FALSE
							)
	var/ghost_vision_pref = GHOST_VISION_LEVEL_MID_NVG
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

	//Synthetic specific preferences
	var/synthetic_name = "Undefined"
	var/synthetic_type = SYNTH_GEN_THREE
	//Predator specific preferences.
	var/predator_name = "Undefined"
	var/predator_gender = MALE
	var/predator_age = 100
	var/predator_h_style = "Standard"
	var/predator_skin_color = "tan"
	var/predator_translator_type = "Modern"
	var/predator_mask_type = 1
	var/predator_armor_type = 1
	var/predator_boot_type = 1
	var/predator_armor_material = "ebony"
	var/predator_mask_material = "ebony"
	var/predator_greave_material = "ebony"
	var/predator_caster_material = "ebony"
	var/predator_cape_type = "None"
	var/predator_cape_color = "#654321"
	var/predator_flavor_text = ""
	//CO-specific preferences
	var/commander_sidearm = "Mateba"
	//SEA specific preferences
	var/sea_path = "Command"

	///holds our preferred job options for jobs
	var/pref_special_job_options = list()

	var/preferred_survivor_variant = ANY_SURVIVOR

	//WL Council preferences.
	var/yautja_status = WHITELIST_NORMAL
	var/commander_status = WHITELIST_NORMAL
	var/synth_status = WHITELIST_NORMAL

	//character preferences
	var/real_name //our character's name
	var/be_random_name = FALSE //whether we are a random name every round
	var/human_name_ban = FALSE


	var/be_random_body = 0 //whether we have a random appearance every round
	var/gender = MALE //gender of character (well duh)
	var/age = 19 //age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/underwear = "Boxers (Camo Conforming)" //underwear type
	var/undershirt = "Undershirt" //undershirt type
	var/backbag = 2 //backpack type

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
	var/ethnicity = "Western" // Ethnicity
	var/body_type = "Mesomorphic (Average)" // Body Type
	var/language = "None" //Secondary language
	var/list/gear //Custom/fluff item loadout.
	var/preferred_squad = "None"

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

	var/nanotrasen_relation = "Neutral"

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

/datum/preferences/New(client/C)
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
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
	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_COMMANDER)
		dat += "<a[current_menu == MENU_CO ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_CO]\"><b>Commanding Officer</b></a> - "
	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_SYNTHETIC)
		dat += "<a[current_menu == MENU_SYNTHETIC ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SYNTHETIC]\"><b>Synthetic</b></a> - "
	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_PREDATOR)
		dat += "<a[current_menu == MENU_YAUTJA ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_YAUTJA]\"><b>Yautja</b></a> - "
	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_MENTOR)
		dat += "<a[current_menu == MENU_MENTOR ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_MENTOR]\"><b>Mentor</b></a> - "
	dat += "<a[current_menu == MENU_SETTINGS ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SETTINGS]\"><b>Settings</b></a> - "
	dat += "<a[current_menu == MENU_SPECIAL ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SPECIAL]\"><b>Special Roles</b></a>"
	dat += "</center>"

	dat += "<hr>"

	switch(current_menu)
		if(MENU_MARINE)
			dat += "<div id='column1'>"
			dat += "<h1><u><b>Name:</b></u> "
			dat += "<a href='?_src_=prefs;preference=name;task=input'><b>[real_name]</b></a>"
			dat += "<a href='?_src_=prefs;preference=name;task=random'>&reg</A></h1>"
			dat += "<b>Always Pick Random Name:</b> <a href='?_src_=prefs;preference=rand_name'><b>[be_random_name ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Always Pick Random Appearance:</b> <a href='?_src_=prefs;preference=rand_body'><b>[be_random_body ? "Yes" : "No"]</b></a><br><br>"

			dat += "<h2><b><u>Physical Information:</u></b>"
			dat += "<a href='?_src_=prefs;preference=all;task=random'>&reg;</A></h2>"
			dat += "<b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'><b>[age]</b></a><br>"
			dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'><b>[gender == MALE ? "Male" : "Female"]</b></a><br>"
			dat += "<b>Ethnicity:</b> <a href='?_src_=prefs;preference=ethnicity;task=input'><b>[ethnicity]</b></a><br>"
			dat += "<b>Body Type:</b> <a href='?_src_=prefs;preference=body_type;task=input'><b>[body_type]</b></a><br>"
			dat += "<b>Traits:</b> <a href='byond://?src=\ref[user];preference=traits;task=open'><b>Character Traits</b></a>"
			dat += "<br>"

			dat += "<h2><b><u>Occupation Choices:</u></b></h2>"
			dat += "<br>"
			dat += "\t<a href='?_src_=prefs;preference=job;task=menu'><b>Set Role Preferences</b></a>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>Hair and Eyes:</u></b></h2>"
			dat += "<b>Hair:</b> "
			dat += "<a href='?_src_=prefs;preference=h_style;task=input'><b>[h_style]</b></a>"
			dat += " | "
			dat += "<a href='?_src_=prefs;preference=hair;task=input'>"
			dat += "<b>Color</b> <span class='square' style='background-color: #[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)];'></span>"
			dat += "</a>"
			dat += "<br>"

			if(/datum/character_trait/hair_dye in traits)
				dat += "<b>Hair Gradient:</b> "
				dat += "<a href='?_src_=prefs;preference=grad_style;task=input'><b>[grad_style]</b></a>"
				dat += " | "
				dat += "<a href='?_src_=prefs;preference=grad;task=input'>"
				dat += "<b>Color</b> <span class='square' style='background-color: #[num2hex(r_gradient, 2)][num2hex(g_gradient, 2)][num2hex(b_gradient)];'></span>"
				dat += "</a>"
				dat += "<br>"

			dat += "<b>Facial Hair:</b> "
			dat += "<a href='?_src_=prefs;preference=f_style;task=input'><b>[f_style]</b></a>"
			dat += " | "
			dat += "<a href='?_src_=prefs;preference=facial;task=input'>"
			dat += "<b>Color</b> <span class='square' style='background-color: #[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)];'></span>"
			dat += "</a>"
			dat += "<br>"

			dat += "<b>Eye:</b> "
			dat += "<a href='?_src_=prefs;preference=eyes;task=input'>"
			dat += "<b>Color</b> <span class='square' style='background-color: #[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)];'></span>"
			dat += "</a>"
			dat += "<br><br>"

			dat += "<h2><b><u>Marine Gear:</u></b></h2>"
			dat += "<b>Underwear:</b> <a href ='?_src_=prefs;preference=underwear;task=input'><b>[underwear]</b></a><br>"
			dat += "<b>Undershirt:</b> <a href='?_src_=prefs;preference=undershirt;task=input'><b>[undershirt]</b></a><br>"

			dat += "<b>Backpack Type:</b> <a href ='?_src_=prefs;preference=bag;task=input'><b>[backbaglist[backbag]]</b></a><br>"

			dat += "<b>Show Job Gear:</b> <a href ='?_src_=prefs;preference=toggle_job_gear'><b>[show_job_gear ? "True" : "False"]</b></a><br>"
			dat += "<b>Background:</b> <a href ='?_src_=prefs;preference=cycle_bg'><b>Cycle Background</b></a><br>"

			dat += "<b>Custom Loadout:</b> "
			var/total_cost = 0

			if(!islist(gear))
				gear = list()

			if(length(gear))
				dat += "<br>"
				for(var/i = 1; i <= gear.len; i++)
					var/datum/gear/G = gear_datums[gear[i]]
					if(G)
						total_cost += G.cost
						dat += "[gear[i]] ([G.cost] points) <a href='byond://?src=\ref[user];preference=loadout;task=remove;gear=[i]'><b>Remove</b></a><br>"

				dat += "<b>Used:</b> [total_cost] points"
			else
				dat += "None"

			if(total_cost < MAX_GEAR_COST)
				dat += " <a href='byond://?src=\ref[user];preference=loadout;task=input'><b>Add</b></a>"
				if(gear && gear.len)
					dat += " <a href='byond://?src=\ref[user];preference=loadout;task=clear'><b>Clear</b></a>"

			dat += "</div>"

			dat += "<div id='column3'>"
			dat += "<h2><b><u>Background Information:</u></b></h2>"
			dat += "<b>Origin:</b> <a href='?_src_=prefs;preference=origin;task=input'><b>[origin]</b></a><br/>"
			dat += "<b>Religion:</b> <a href='?_src_=prefs;preference=religion;task=input'><b>[religion]</b></a><br/>"

			dat += "<b>Corporate Relation:</b> <a href ='?_src_=prefs;preference=nt_relation;task=input'><b>[nanotrasen_relation]</b></a><br>"
			dat += "<b>Preferred Squad:</b> <a href ='?_src_=prefs;preference=prefsquad;task=input'><b>[preferred_squad]</b></a><br>"

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
			dat += "<b>Xeno prefix:</b> <a href='?_src_=prefs;preference=xeno_prefix;task=input'><b>[display_prefix]</b></a><br>"
			dat += "<b>Xeno postfix:</b> <a href='?_src_=prefs;preference=xeno_postfix;task=input'><b>[display_postfix]</b></a><br>"

			dat += "<b>Enable Playtime Perks:</b> <a href='?_src_=prefs;preference=playtime_perks'><b>[playtime_perks? "Yes" : "No"]</b></a><br>"
			dat += "<b>Default Xeno Night Vision Level:</b> <a href='?_src_=prefs;preference=xeno_vision_level_pref;task=input'><b>[xeno_vision_level_pref]</b></a><br>"

			var/tempnumber = rand(1, 999)
			var/postfix_text = xeno_postfix ? ("-"+xeno_postfix) : ""
			var/prefix_text = xeno_prefix ? xeno_prefix : "XX"
			var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"

			dat += "<b>Xeno sample name:</b> [xeno_text]<br>"
			dat += "<br>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>Occupation Choices:</u></b></h2>"
			var/n = 0
			var/list/special_roles = list(
			"Xenomorph after<br>unrevivably dead" = 1,
			"Agent" = 0,
			)

			for(var/role_name in special_roles)
				var/ban_check_name
				var/list/missing_requirements = list()

				switch(role_name)
					if("Xenomorph after<br>unrevivably dead")
						ban_check_name = JOB_XENOMORPH

					if("Agent")
						ban_check_name = "Agent"

				if(jobban_isbanned(user, ban_check_name))
					dat += "<b>Be [role_name]:</b> <font color=red><b>\[BANNED]</b></font><br>"
				else if(!can_play_special_job(user.client, ban_check_name))
					dat += "<b>Be [role_name]:</b> <font color=red><b>\[TIMELOCKED]</b></font><br>"
					for(var/r in missing_requirements)
						var/datum/timelock/T = r
						dat += "\t[T.name] - [duration2text(missing_requirements[r])] Hours<br>"
				else
					dat += "<b>Be [role_name]:</b> <a href='?_src_=prefs;preference=be_special;num=[n]'><b>[be_special & (1<<n) ? "Yes" : "No"]</b></a><br>"

				n++

			dat += "<br>"
			dat += "\t<a href='?_src_=prefs;preference=job;task=menu'><b>Set Role Preferences</b></a>"
			dat += "</div>"
		if(MENU_CO)
			if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_COMMANDER)
				dat += "<div id='column1'>"
				dat += "<h2><b><u>Commander Settings:</u></b></h2>"
				dat += "<b>Commander Whitelist Status:</b> <a href='?_src_=prefs;preference=commander_status;task=input'><b>[commander_status]</b></a><br>"
				dat += "<b>Commander Sidearm:</b> <a href='?_src_=prefs;preference=co_sidearm;task=input'><b>[commander_sidearm]</b></a><br>"
				dat += "</div>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"
		if(MENU_SYNTHETIC)
			if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_SYNTHETIC)
				dat += "<div id='column1'>"
				dat += "<h2><b><u>Synthetic Settings:</u></b></h2>"
				dat += "<b>Synthetic Name:</b> <a href='?_src_=prefs;preference=synth_name;task=input'><b>[synthetic_name]</b></a><br>"
				dat += "<b>Synthetic Type:</b> <a href='?_src_=prefs;preference=synth_type;task=input'><b>[synthetic_type]</b></a><br>"
				dat += "<b>Synthetic Whitelist Status:</b> <a href='?_src_=prefs;preference=synth_status;task=input'><b>[synth_status]</b></a><br>"
				dat += "</div>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"
		if(MENU_YAUTJA)
			if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_PREDATOR)
				dat += "<div id='column1'>"
				dat += "<h2><b><u>Yautja Information:</u></b></h2>"
				dat += "<b>Yautja Name:</b> <a href='?_src_=prefs;preference=pred_name;task=input'><b>[predator_name]</b></a><br>"
				dat += "<b>Yautja Gender:</b> <a href='?_src_=prefs;preference=pred_gender;task=input'><b>[predator_gender == MALE ? "Male" : "Female"]</b></a><br>"
				dat += "<b>Yautja Age:</b> <a href='?_src_=prefs;preference=pred_age;task=input'><b>[predator_age]</b></a><br>"
				dat += "<b>Yautja Quill Style:</b> <a href='?_src_=prefs;preference=pred_hair;task=input'><b>[predator_h_style]</b></a><br>"
				dat += "<b>Yautja Skin Color:</b> <a href='?_src_=prefs;preference=pred_skin;task=input'><b>[predator_skin_color]</b></a><br>"
				dat += "<b>Yautja Flavor Text:</b> <a href='?_src_=prefs;preference=pred_flavor_text;task=input'><b>[TextPreview(predator_flavor_text, 15)]</b></a><br>"
				dat += "<b>Yautja Whitelist Status:</b> <a href='?_src_=prefs;preference=yautja_status;task=input'><b>[yautja_status]</b></a>"
				dat += "</div>"

				dat += "<div id='column2'>"
				dat += "<h2><b><u>Equipment Setup:</u></b></h2>"
				dat += "<b>Translator Type:</b> <a href='?_src_=prefs;preference=pred_trans_type;task=input'><b>[predator_translator_type]</b></a><br>"
				dat += "<b>Mask Style:</b> <a href='?_src_=prefs;preference=pred_mask_type;task=input'><b>([predator_mask_type])</b></a><br>"
				dat += "<b>Armor Style:</b> <a href='?_src_=prefs;preference=pred_armor_type;task=input'><b>([predator_armor_type])</b></a><br>"
				dat += "<b>Greave Style:</b> <a href='?_src_=prefs;preference=pred_boot_type;task=input'><b>([predator_boot_type])</b></a><br>"
				dat += "<b>Mask Material:</b> <a href='?_src_=prefs;preference=pred_mask_mat;task=input'><b>[predator_mask_material]</b></a><br>"
				dat += "<b>Armor Material:</b> <a href='?_src_=prefs;preference=pred_armor_mat;task=input'><b>[predator_armor_material]</b></a><br>"
				dat += "<b>Greave Material:</b> <a href='?_src_=prefs;preference=pred_greave_mat;task=input'><b>[predator_greave_material]</b></a><br>"
				dat += "<b>Caster Material:</b> <a href='?_src_=prefs;preference=pred_caster_mat;task=input'><b>[predator_caster_material]</b></a>"
				dat += "</div>"

				dat += "<div id='column3'>"
				dat += "<h2><b><u>Clothing Setup:</u></b></h2>"
				dat += "<b>Cape Type:</b> <a href='?_src_=prefs;preference=pred_cape_type;task=input'><b>[capitalize_first_letters(predator_cape_type)]</b></a><br>"
				dat += "<b>Cape Color:</b> "
				dat += "<a href='?_src_=prefs;preference=pred_cape_color;task=input'>"
				dat += "<b>Color</b> <span class='square' style='background-color: [predator_cape_color];'></span>"
				dat += "</a><br><br>"
				dat += "<b>Background:</b> <a href ='?_src_=prefs;preference=cycle_bg'><b>Cycle Background</b></a>"
				dat += "</div>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"
		if(MENU_MENTOR)
			if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_MENTOR)
				dat += "<div id='column1'>"
				dat += "<h2><b><u>Mentor Settings:</u></b></h2>"
				dat += "<b>SEA Grade Path:</b> <a href='?_src_=prefs;preference=grade_path;task=input'><b>[sea_path]</b></a><br>"
				dat += "</div>"
			else
				dat += "<b>You do not have the whitelist for this role.</b>"
		if(MENU_SETTINGS)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>Input Settings:</u></b></h2>"
			dat += "<b>Mode:</b> <a href='?_src_=prefs;preference=hotkeys'><b>[(hotkeys) ? "Hotkeys Mode" : "Send to Chat"]</b></a><br>"
			dat += "<b>Keybinds:</b> <a href='?_src_=prefs;preference=viewmacros'><b>View Keybinds</b></a><br>"
			dat += "<br><b>Say Input Style:</b> <a href='?_src_=prefs;preference=inputstyle'><b>[tgui_say ? "Modern (default)" : "Legacy"]</b></a><br>"
			dat += "<b>Say Input Color:</b> <a href='?_src_=prefs;preference=inputcolor'><b>[tgui_say_light_mode ? "Lightmode" : "Darkmode (default)"]</b></a><br>"

			dat += "<h2><b><u>UI Customization:</u></b></h2>"
			dat += "<b>Style:</b> <a href='?_src_=prefs;preference=ui'><b>[UI_style]</b></a><br>"
			dat += "<b>Color:</b> <a href='?_src_=prefs;preference=UIcolor'><b>[UI_style_color]</b> <table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></table></a><br>"
			dat += "<b>Alpha:</b> <a href='?_src_=prefs;preference=UIalpha'><b>[UI_style_alpha]</b></a><br><br>"
			dat += "<b>Stylesheet:</b> <a href='?_src_=prefs;preference=stylesheet'><b>[stylesheet]</b></a><br>"
			dat += "<b>Hide Statusbar:</b> <a href='?_src_=prefs;preference=hide_statusbar'><b>[hide_statusbar ? "TRUE" : "FALSE"]</b></a><br>"
			dat += "<b>Prefer input drop down menus to radial menus, where possible:</b> <a href='?_src_=prefs;preference=no_radials_preference'><b>[no_radials_preference ? "TRUE" : "FALSE"]</b></a><br>"
			if(!no_radials_preference)
				dat += "<b>Hide Radial Menu Labels:</b> <a href='?_src_=prefs;preference=no_radial_labels_preference'><b>[no_radial_labels_preference ? "TRUE" : "FALSE"]</b></a><br>"
			dat += "<b>Custom Cursors:</b> <a href='?_src_=prefs;preference=customcursors'><b>[custom_cursors ? "Enabled" : "Disabled"]</b></a><br>"

			dat += "<h2><b><u>Chat Settings:</u></b></h2>"
			if(CONFIG_GET(flag/ooc_country_flags))
				dat += "<b>OOC Country Flag:</b> <a href='?_src_=prefs;preference=ooc_flag'><b>[(toggle_prefs & TOGGLE_OOC_FLAG) ? "Enabled" : "Disabled"]</b></a><br>"
			if(user.client.admin_holder && user.client.admin_holder.rights & R_DEBUG)
				dat += "<b>View Master Controller Tab:</b> <a href='?_src_=prefs;preference=ViewMC'><b>[View_MC ? "TRUE" : "FALSE"]</b></a>"
			if(unlock_content)
				dat += "<b>BYOND Membership Publicity:</b> <a href='?_src_=prefs;preference=publicity'><b>[(toggle_prefs & TOGGLE_MEMBER_PUBLIC) ? "Public" : "Hidden"]</b></a><br>"
			dat += "<b>Ghost Ears:</b> <a href='?_src_=prefs;preference=ghost_ears'><b>[(toggles_chat & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a><br>"
			dat += "<b>Ghost Sight:</b> <a href='?_src_=prefs;preference=ghost_sight'><b>[(toggles_chat & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a><br>"
			dat += "<b>Ghost Radio:</b> <a href='?_src_=prefs;preference=ghost_radio'><b>[(toggles_chat & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a><br>"
			dat += "<b>Ghost Hivemind:</b> <a href='?_src_=prefs;preference=ghost_hivemind'><b>[(toggles_chat & CHAT_GHOSTHIVEMIND) ? "Show Hivemind" : "Hide Hivemind"]</b></a><br>"
			dat += "<b>Abovehead Chat:</b> <a href='?_src_=prefs;preference=lang_chat_disabled'><b>[lang_chat_disabled ? "Hide" : "Show"]</b></a><br>"
			dat += "<b>Abovehead Emotes:</b> <a href='?_src_=prefs;preference=langchat_emotes'><b>[(toggles_langchat & LANGCHAT_SEE_EMOTES) ? "Show" : "Hide"]</b></a><br>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>Game Settings:</u></b></h2>"
			dat += "<b>Ambient Occlusion:</b> <a href='?_src_=prefs;preference=ambientocclusion'><b>[toggle_prefs & TOGGLE_AMBIENT_OCCLUSION ? "Enabled" : "Disabled"]</b></a><br>"
			dat += "<b>Fit Viewport:</b> <a href='?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
			dat += "<b>tgui Window Mode:</b> <a href='?_src_=prefs;preference=tgui_fancy'><b>[(tgui_fancy) ? "Fancy (default)" : "Compatible (slower)"]</b></a><br>"
			dat += "<b>tgui Window Placement:</b> <a href='?_src_=prefs;preference=tgui_lock'><b>[(tgui_lock) ? "Primary monitor" : "Free (default)"]</b></a><br>"
			dat += "<b>Play Admin Midis:</b> <a href='?_src_=prefs;preference=hear_midis'><b>[(toggles_sound & SOUND_MIDI) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Play Admin Internet Sounds:</b> <a href='?_src_=prefs;preference=hear_internet'><b>[(toggles_sound & SOUND_INTERNET) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Toggle Meme or Atmospheric Sounds:</b> <a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_admin_sound_types'>Toggle</a><br>"
			dat += "<b>Set Eye Blur Type:</b> <a href='?src=\ref[src];action=proccall;procpath=/client/proc/set_eye_blur_type'>Set</a><br>"
			dat += "<b>Play Lobby Music:</b> <a href='?_src_=prefs;preference=lobby_music'><b>[(toggles_sound & SOUND_LOBBY) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Play VOX Announcements:</b> <a href='?_src_=prefs;preference=sound_vox'><b>[(hear_vox) ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Default Ghost Night Vision Level:</b> <a href='?_src_=prefs;preference=ghost_vision_pref;task=input'><b>[ghost_vision_pref]</b></a><br>"
			dat += "<a href='?src=\ref[src];action=proccall;procpath=/client/proc/receive_random_tip'>Read Random Tip of the Round</a><br>"
			if(CONFIG_GET(flag/allow_Metadata))
				dat += "<b>OOC Notes:</b> <a href='?_src_=prefs;preference=metadata;task=input'> Edit </a>"
			dat += "</div>"

			dat += "<div id='column3'>"
			dat += "<h2><b><u>Gameplay Toggles:</u></b></h2>"
			dat += "<b>Toggle Being Able to Hurt Yourself: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_IGNORE_SELF]'><b>[toggle_prefs & TOGGLE_IGNORE_SELF ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Help Intent Safety: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_HELP_INTENT_SAFETY]'><b>[toggle_prefs & TOGGLE_HELP_INTENT_SAFETY ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Middle Mouse Ability Activation: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_MIDDLE_MOUSE_CLICK]'><b>[toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Directional Assist: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_DIRECTIONAL_ATTACK]'><b>[toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Magazine Auto-Ejection: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_EJECT_MAGAZINE_OFF];flag_undo=[TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND]'><b>[!(toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF) ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Magazine Auto-Ejection to Offhand: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND];flag_undo=[TOGGLE_AUTO_EJECT_MAGAZINE_OFF]'><b>[toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Magazine Manual Ejection to Offhand: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_EJECT_MAGAZINE_TO_HAND]'><b>[toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Automatic Punctuation: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTOMATIC_PUNCTUATION]'><b>[toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Combat Click-Drag Override: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_COMBAT_CLICKDRAG_OVERRIDE]'><b>[toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Alternate-Fire Dual Wielding: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_ALTERNATING_DUAL_WIELD]'><b>[toggle_prefs & TOGGLE_ALTERNATING_DUAL_WIELD ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Middle-Click Swap Hands: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_MIDDLE_MOUSE_SWAP_HANDS]'><b>[toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS ? "On" : "Off"]</b></a><br>"
			dat += "<b>Toggle Vendors Vending to Hands: \
					</b> <a href='?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_VEND_ITEM_TO_HAND]'><b>[toggle_prefs & TOGGLE_VEND_ITEM_TO_HAND ? "On" : "Off"]</b></a><br>"
			dat += "<a href='?src=\ref[src];action=proccall;procpath=/client/proc/switch_item_animations'>Toggle Item Animations Detail Level</a><br>"
		if(MENU_SPECIAL) //wart
			dat += "<div id='column1'>"
			dat += "<h2><b><u>ERT Settings:</u></b></h2>"
			dat += "<b>Spawn as Leader:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_LEADER]'><b>[toggles_ert & PLAY_LEADER ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Medic:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_MEDIC]'><b>[toggles_ert & PLAY_MEDIC ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Engineer:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_ENGINEER]'><b>[toggles_ert & PLAY_ENGINEER ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Specialist:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_HEAVY]'><b>[toggles_ert & PLAY_HEAVY ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Smartgunner:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_SMARTGUNNER]'><b>[toggles_ert & PLAY_SMARTGUNNER ? "Yes" : "No"]</b></a><br>"
			if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_SYNTHETIC)
				dat += "<b>Spawn as Synth:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_SYNTH]'><b>[toggles_ert & PLAY_SYNTH ? "Yes" : "No"]</b></a><br>"
			dat += "<b>Spawn as Miscellaneous:</b> <a href='?_src_=prefs;preference=toggles_ert;flag=[PLAY_MISC]'><b>[toggles_ert & PLAY_MISC ? "Yes" : "No"]</b></a><br>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>Survivor Settings:</u></b></h2>"
			dat += "<b>Preferred Survivor Variant:</b> <a href='?_src_=prefs;preference=preferred_survivor_variant;task=input'><b>[preferred_survivor_variant]</b></a>"
			dat += "</div>"

	dat += "</div></body>"

	winshow(user, "preferencewindow", TRUE)
	show_browser(user, dat, "Preferences", "preferencebrowser")
	onclose(user, "preferencewindow", src)

//limit - The amount of jobs allowed per column. Defaults to 13 to make it look nice.
//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
//width - Screen' width. Defaults to 550 to make it look nice.
//height - Screen's height. Defaults to 500 to make it look nice.
/datum/preferences/proc/SetChoices(mob/user, limit = 19, list/splitJobs = list(JOB_CHIEF_REQUISITION), width = 950, height = 700)
	if(!RoleAuthority)
		return

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br><br>"
	HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0' style='color: black;'><tr><td valign='top' width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.

	var/list/active_role_names = GLOB.gamemode_roles[GLOB.master_mode]
	if(!active_role_names)
		active_role_names = ROLES_REGULAR_ALL

	for(var/role_name as anything in active_role_names)
		var/datum/job/job = RoleAuthority.roles_by_name[role_name]
		if(!job)
			debug_log("Missing job for prefs: [role_name]")
			continue
		index++
		if((index >= limit) || (job.title in splitJobs))
			HTML += "</table></td><td valign='top' width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr class='[job.selection_class]'><td width='40%' align='right'>"

		if(jobban_isbanned(user, job.title))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='10%' align='right'></td><td><b>BANNED</b></td></tr>"
			continue
		else if(job.flags_startup_parameters & ROLE_WHITELISTED && !(RoleAuthority.roles_whitelist[user.ckey] & job.flags_whitelist))
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='10%' align='right'></td><td>WHITELISTED</td></tr>"
			continue
		else if(!job.can_play_role(user.client))
			var/list/missing_requirements = job.get_role_requirements(user.client)
			HTML += "<b><del>[job.disp_title]</del></b></td><td width='10%' align='right'></td><td>TIMELOCKED</td></tr>"
			for(var/r in missing_requirements)
				var/datum/timelock/T = r
				HTML += "<tr class='[job.selection_class]'><td width='40%' align='middle'>[T.name]</td><td width='10%' align='right'></td><td>[duration2text(missing_requirements[r])] Hours</td></tr>"
			continue

		HTML += "<b>[job.disp_title]</b></td><td width='10%' align='right'>"

		if(job.job_options)
			if(!pref_special_job_options || !pref_special_job_options[role_name])
				pref_special_job_options[role_name] = job.job_options[1]

			var/txt = pref_special_job_options[role_name]
			HTML += "<a href='?_src_=prefs;preference=special_job_select;task=input;text=[job.title]'><b>[txt]</b></a>"

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

			HTML += "<a class='[j == cur_priority ? b_color : "inactive"]' href='?_src_=prefs;preference=job;task=input;text=[job.title];target_priority=[j];'>[priority_text]</a>"
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

		HTML += "<center><br><a class='[b_color]' href='?_src_=prefs;preference=job;task=random'>[msg]</a></center><br>"

	HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset</a></center>"
	HTML += "</tt></body>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "Job Preferences", "mob_occupation", "size=[width]x[height]")
	onclose(user, "mob_occupation", user.client, list("_src_" = "prefs", "preference" = "job", "task" = "close"))
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
	HTML +="<a href='?src=\ref[user];preference=flavor_text;task=done'>Done</a>"
	HTML += "<tt>"
	close_browser(user, "preferences")
	show_browser(user, HTML, "Set Flavor Text", "flavor_text;size=430x300")
	return

/datum/preferences/proc/SetJob(mob/user, role, priority)
	var/datum/job/job = RoleAuthority.roles_by_name[role]
	if(!job)
		close_browser(user, "mob_occupation")
		ShowChoices(user)
		return

	SetJobDepartment(job, priority)

	SetChoices(user)
	return 1

/datum/preferences/proc/ResetJobs()
	if(length(job_preference_list))
		for(var/job in job_preference_list)
			job_preference_list[job] = NEVER_PRIORITY
		return

	if(!RoleAuthority)
		return

	job_preference_list = list()
	for(var/role in RoleAuthority.roles_by_path)
		var/datum/job/J = RoleAuthority.roles_by_path[role]
		job_preference_list[J.title] = NEVER_PRIORITY

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

/datum/preferences/proc/process_link(mob/user, list/href_list)
	var/whitelist_flags = RoleAuthority.roles_whitelist[user.ckey]

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
				else
					SetChoices(user)
			return 1
		if("loadout")
			switch(href_list["task"])
				if("input")

					var/list/valid_gear_choices = list()

					for(var/gear_name in gear_datums)
						var/datum/gear/G = gear_datums[gear_name]
						if(G.whitelisted && !is_alien_whitelisted(user, G.whitelisted))
							continue
						valid_gear_choices += gear_name

					var/choice = tgui_input_list(user, "Select gear to add: ", "Gear to add", valid_gear_choices)

					if(choice && gear_datums[choice])

						var/total_cost = 0

						if(isnull(gear) || !islist(gear)) gear = list()

						if(gear && gear.len)
							for(var/gear_name in gear)
								if(gear_datums[gear_name])
									var/datum/gear/G = gear_datums[gear_name]
									total_cost += G.cost

						var/datum/gear/C = gear_datums[choice]
						total_cost += C.cost
						if(C && total_cost <= MAX_GEAR_COST)
							gear += choice
							to_chat(user, SPAN_NOTICE("Added \the '[choice]' for [C.cost] points ([MAX_GEAR_COST - total_cost] points remaining)."))
						else
							to_chat(user, SPAN_WARNING("Adding \the '[choice]' will exceed the maximum loadout cost of [MAX_GEAR_COST] points."))

				if("remove")
					var/i_remove = text2num(href_list["gear"])
					if(i_remove < 1 || i_remove > gear.len) return
					gear.Cut(i_remove, i_remove + 1)

				if("clear")
					gear.Cut()

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
			switch(href_list["task"])
				if("open")
					open_character_traits(user)
					return TRUE
				if("change_slot")
					var/trait_group = text2path(href_list["trait_group"])
					if(!GLOB.character_trait_groups[trait_group])
						trait_group = null
					open_character_traits(user, trait_group)
					return TRUE
				if("give_trait")
					var/trait_group = text2path(href_list["trait_group"])
					if(!GLOB.character_trait_groups[trait_group])
						trait_group = null
					var/trait = text2path(href_list["trait"])
					var/datum/character_trait/character_trait = GLOB.character_traits[trait]
					character_trait?.try_give_trait(src)
					open_character_traits(user, trait_group)
					if(character_trait.refresh_choices)
						ShowChoices(user)
					if(character_trait.refresh_mannequin)
						update_preview_icon()
					return TRUE
				if("remove_trait")
					var/trait_group = text2path(href_list["trait_group"])
					if(!GLOB.character_trait_groups[trait_group])
						trait_group = null
					var/trait = text2path(href_list["trait"])
					var/datum/character_trait/character_trait = GLOB.character_traits[trait]
					character_trait?.try_remove_trait(src)
					open_character_traits(user, trait_group)
					if(character_trait.refresh_choices)
						ShowChoices(user)
					if(character_trait.refresh_mannequin)
						update_preview_icon()
					return TRUE

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
				if ("ethnicity")
					ethnicity = random_ethnicity()
				if ("body_type")
					body_type = random_body_type()
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
					var/static/list/vision_level_choices = list(XENO_VISION_LEVEL_NO_NVG, XENO_VISION_LEVEL_MID_NVG, XENO_VISION_LEVEL_FULL_NVG)
					var/choice = tgui_input_list(user, "Choose your default xeno vision level", "Vision level", vision_level_choices, theme="hive_status")
					if(!choice)
						return
					xeno_vision_level_pref = choice
				if("ghost_vision_pref")
					var/static/list/vision_level_choices = list(GHOST_VISION_LEVEL_NO_NVG, GHOST_VISION_LEVEL_MID_NVG, GHOST_VISION_LEVEL_FULL_NVG)
					var/choice = tgui_input_list(user, "Choose your default ghost vision level", "Vision level", vision_level_choices)
					if(!choice)
						return
					ghost_vision_pref = choice

				if("synth_name")
					var/raw_name = input(user, "Choose your Synthetic's name:", "Character Preference")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name) synthetic_name = new_name
						else to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
				if("synth_type")
					var/new_synth_type = tgui_input_list(user, "Choose your model of synthetic:", "Make and Model", PLAYER_SYNTHS)
					if(new_synth_type) synthetic_type = new_synth_type
				if("pred_name")
					var/raw_name = input(user, "Choose your Predator's name:", "Character Preference")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name) predator_name = new_name
						else to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
				if("pred_gender")
					predator_gender = predator_gender == MALE ? FEMALE : MALE
				if("pred_age")
					var/new_predator_age = tgui_input_number(user, "Choose your Predator's age(20 to 10000):", "Character Preference", 1234, 10000, 20)
					if(new_predator_age) predator_age = max(min( round(text2num(new_predator_age)), 10000),20)
				if("pred_trans_type")
					var/new_translator_type = tgui_input_list(user, "Choose your translator type.", "Translator Type", PRED_TRANSLATORS)
					if(!new_translator_type)
						return
					predator_translator_type = new_translator_type
				if("pred_mask_type")
					var/new_predator_mask_type = tgui_input_number(user, "Choose your mask type:\n(1-12)", "Mask Selection", 1, 12, 1)
					if(new_predator_mask_type) predator_mask_type = round(text2num(new_predator_mask_type))
				if("pred_armor_type")
					var/new_predator_armor_type = tgui_input_number(user, "Choose your armor type:\n(1-7)", "Armor Selection", 1, 7, 1)
					if(new_predator_armor_type) predator_armor_type = round(text2num(new_predator_armor_type))
				if("pred_boot_type")
					var/new_predator_boot_type = tgui_input_number(user, "Choose your greaves type:\n(1-4)", "Greave Selection", 1, 4, 1)
					if(new_predator_boot_type) predator_boot_type = round(text2num(new_predator_boot_type))
				if("pred_mask_mat")
					var/new_pred_mask_mat = tgui_input_list(user, "Choose your mask material:", "Mask Material", PRED_MATERIALS)
					if(!new_pred_mask_mat)
						return
					predator_mask_material = new_pred_mask_mat
				if("pred_armor_mat")
					var/new_pred_armor_mat = tgui_input_list(user, "Choose your armour material:", "Armor Material", PRED_MATERIALS)
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
				if("pred_cape_type")
					var/datum/job/J = RoleAuthority.roles_by_name[JOB_PREDATOR]
					var/whitelist_status = clan_ranks_ordered[J.get_whitelist_status(RoleAuthority.roles_whitelist, owner)]

					var/list/options = list("None" = "None")
					for(var/cape_name in GLOB.all_yautja_capes)
						var/obj/item/clothing/yautja_cape/cape = GLOB.all_yautja_capes[cape_name]
						if(whitelist_status >= initial(cape.clan_rank_required) || (initial(cape.councillor_override) && (whitelist_flags & (WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY))))
							options += list(capitalize_first_letters(cape_name) = cape_name)

					var/new_cape = tgui_input_list(user, "Choose your cape type:", "Cape Type", options)
					if(!new_cape)
						return
					predator_cape_type = options[new_cape]
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
					if(whitelist_flags & WHITELIST_COMMANDER_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_commander_status = tgui_input_list(user, "Choose your new Commander Whitelist Status.", "Commander Status", options)

					if(!new_commander_status)
						return

					commander_status = options[new_commander_status]

				if("co_sidearm")
					var/list/options = list("Mateba","Desert Eagle")

					if(whitelist_flags & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
						options += list("Colonel's Mateba","Golden Desert Eagle")
					else
						options -= list("Colonel's Mateba","Golden Desert Eagle") //This is weird and should not be necessary but it wouldn't remove these from the list otherwise

					var/new_co_sidearm = tgui_input_list(user, "Choose your preferred sidearm.", "Commanding Officer's Sidearm", options)
					if(!new_co_sidearm)
						return
					commander_sidearm = new_co_sidearm

				if("grade_path")
					var/list/options = list("Command", "Technical")
					var/new_path = tgui_input_list(user, "Choose your preferred promotion path.", "Promotion Paths", options)
					if(!new_path)
						return
					sea_path = new_path

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
					else
						var/all_ok = TRUE
						for(var/i=1, i<=length(new_xeno_prefix), i++)
							var/ascii_char = text2ascii(new_xeno_prefix,i)
							switch(ascii_char)
								// A  .. Z
								if(65 to 90) //Uppercase Letters will work
								else
									all_ok = FALSE //everything else - won't
						if(all_ok)
							xeno_prefix = new_xeno_prefix
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
						else
							to_chat(user, "<font color='red'>Invalid Xeno Postfix. Your Postfix can contain single letter and an optional digit after it.</font>")

				if("age")
					var/new_age = tgui_input_number(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference", 19, AGE_MAX, AGE_MIN)
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
					if(new_metadata)
						metadata = strip_html(new_metadata)

				if("hair")
					if(species == "Human")
						var/new_hair = input(user, "Choose your character's hair color:", "Character Preference", rgb(r_hair, g_hair, b_hair)) as color|null
						if(new_hair)
							r_hair = hex2num(copytext(new_hair, 2, 4))
							g_hair = hex2num(copytext(new_hair, 4, 6))
							b_hair = hex2num(copytext(new_hair, 6, 8))

				if("h_style")
					var/list/valid_hairstyles = list()
					for(var/hairstyle in GLOB.hair_styles_list)
						var/datum/sprite_accessory/sprite_accessory = GLOB.hair_styles_list[hairstyle]
						if( !(species in sprite_accessory.species_allowed))
							continue
						if(!sprite_accessory.selectable)
							continue

						valid_hairstyles[hairstyle] = GLOB.hair_styles_list[hairstyle]
					valid_hairstyles = sortList(valid_hairstyles)

					var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in valid_hairstyles
					if(new_h_style)
						h_style = new_h_style

				if("grad")
					if(species == "Human")
						var/new_hair_grad = input(user, "Choose your character's hair gradient color:", "Character Preference", rgb(r_gradient, g_gradient, b_gradient)) as color|null
						if(new_hair_grad)
							r_gradient = hex2num(copytext(new_hair_grad, 2, 4))
							g_gradient = hex2num(copytext(new_hair_grad, 4, 6))
							b_gradient = hex2num(copytext(new_hair_grad, 6, 8))

				if("grad_style")
					var/list/valid_hair_gradients = list()
					for(var/hair_gradient in GLOB.hair_gradient_list)
						var/datum/sprite_accessory/sprite_accessory = GLOB.hair_gradient_list[hair_gradient]
						if(!(species in sprite_accessory.species_allowed))
							continue
						if(!sprite_accessory.selectable)
							continue
						valid_hair_gradients[hair_gradient] = GLOB.hair_gradient_list[hair_gradient]
					valid_hair_gradients = sortList(valid_hair_gradients)

					var/new_h_gradient_style = input(user, "Choose your character's hair gradient style:", "Character Preference")  as null|anything in valid_hair_gradients
					if(new_h_gradient_style)
						grad_style = new_h_gradient_style

				if ("ethnicity")
					var/new_ethnicity = tgui_input_list(user, "Choose your character's ethnicity:", "Character Preferences", GLOB.ethnicities_list)

					if (new_ethnicity)
						ethnicity = new_ethnicity

				if ("body_type")
					var/new_body_type = tgui_input_list(user, "Choose your character's body type:", "Character Preferences", GLOB.body_types_list)

					if (new_body_type)
						body_type = new_body_type

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair color:", "Character Preference", rgb(r_facial, g_facial, b_facial)) as color|null
					if(new_facial)
						r_facial = hex2num(copytext(new_facial, 2, 4))
						g_facial = hex2num(copytext(new_facial, 4, 6))
						b_facial = hex2num(copytext(new_facial, 6, 8))

				if("f_style")
					var/list/valid_facialhairstyles = list()
					for(var/facialhairstyle in GLOB.facial_hair_styles_list)
						var/datum/sprite_accessory/sprite_accessory = GLOB.facial_hair_styles_list[facialhairstyle]
						if(gender == MALE && sprite_accessory.gender == FEMALE)
							continue
						if(gender == FEMALE && sprite_accessory.gender == MALE)
							continue
						if( !(species in sprite_accessory.species_allowed))
							continue
						if(!sprite_accessory.selectable)
							continue

						valid_facialhairstyles[facialhairstyle] = GLOB.facial_hair_styles_list[facialhairstyle]
					valid_facialhairstyles = sortList(valid_facialhairstyles)

					var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in valid_facialhairstyles
					if(new_f_style)
						f_style = new_f_style

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
					var/new_eyes = input(user, "Choose your character's eye color:", "Character Preference", rgb(r_eyes, g_eyes, b_eyes)) as color|null
					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))


				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC color:", "Game Preference", ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
					if(new_backbag)
						backbag = backbaglist.Find(new_backbag)

				if("nt_relation")
					var/new_relation = input(user, "Choose your relation to the Weyland-Yutani company. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
					if(new_relation)
						nanotrasen_relation = new_relation

				if("prefsquad")
					var/new_pref_squad = input(user, "Choose your preferred squad.", "Character Preference")  as null|anything in list("Alpha", "Bravo", "Charlie", "Delta", "None")
					if(new_pref_squad)
						preferred_squad = new_pref_squad

				if("limbs")
					var/limb_name = tgui_input_list(user, "Which limb do you want to change?", list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand"))
					if(!limb_name) return

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
					if(!new_state) return

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
					if(!organ_name) return

					var/organ = null
					switch(organ_name)
						if("Heart")
							organ = "heart"
						if("Eyes")
							organ = "eyes"

					var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "Organ state", list("Normal","Assisted","Mechanical"))
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organ_data[organ] = null
						if("Assisted")
							organ_data[organ] = "assisted"
						if("Mechanical")
							organ_data[organ] = "mechanical"

				if("skin_style")
					var/skin_style_name = tgui_input_list(user, "Select a new skin style", "Skin style", list("default1", "default2", "default3"))
					if(!skin_style_name) return

				if("origin")
					var/choice = tgui_input_list(user, "Please choose your character's origin.", "Origin Selection", GLOB.player_origins)
					if(choice)
						origin = choice

				if("religion")
					var/choice = tgui_input_list(user, "Please choose a religion.", "Religion choice", religion_choices + "Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter a religon.")  as text|null
						if(raw_choice)
							religion = strip_html(raw_choice) // This only updates itself in the UI when another change is made, eg. save slot or changing other char settings.
						return
					religion = choice

				if("preferred_survivor_variant")
					var/new_preferred_survivor_variant = tgui_input_list(user, "Choose your preferred survivor variant:", "Preferred Survivor Variant", SURVIVOR_VARIANT_LIST)
					if(!new_preferred_survivor_variant)
						return
					preferred_survivor_variant = new_preferred_survivor_variant

				if("special_job_select")
					var/datum/job/job = RoleAuthority.roles_by_name[href_list["text"]]
					if(!job)
						close_browser(user, "mob_occupation")
						ShowChoices(user)
						return

					var/new_special_job_variant = tgui_input_list(user, "Choose your preferred job variant:", "Preferred Job Variant", job.job_options)
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

				if("be_special")
					var/num = text2num(href_list["num"])
					be_special ^= (1<<num)

				if("rand_name")
					be_random_name = !be_random_name

				if("rand_body")
					be_random_body = !be_random_body

				if("hear_midis")
					toggles_sound ^= SOUND_MIDI

				if("hear_internet")
					toggles_sound ^= SOUND_INTERNET

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

				if("ambientocclusion")
					toggle_prefs ^= TOGGLE_AMBIENT_OCCLUSION
					var/atom/movable/screen/plane_master/game_world/plane_master = locate() in user?.client.screen
					if (!plane_master)
						return
					plane_master.backdrop(user?.client.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && owner)
						owner.fit_viewport()

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
						to_chat(user, SPAN_WARNING("You need to wait [round((save_cooldown-world.time)/10)] seconds before you can do that again."))
						return
					var/datum/origin/character_origin = GLOB.origins[origin]
					var/name_error = character_origin.validate_name(real_name)
					if(name_error)
						tgui_alert(user, name_error, "Invalid Name", list("OK"))
						return
					save_preferences()
					save_character()
					save_cooldown = world.time + 50
					var/mob/new_player/np = user
					if(istype(np))
						np.new_player_panel_proc()

				if("reload")
					if(reload_cooldown > world.time)
						to_chat(user, SPAN_WARNING("You need to wait [round((reload_cooldown-world.time)/10)] seconds before you can do that again."))
						return
					load_preferences()
					load_character()
					reload_cooldown = world.time + 50

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
					var/mob/new_player/np = user
					if(istype(np))
						np.new_player_panel_proc()
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock

				if("change_menu")
					current_menu = href_list["menu"]

	ShowChoices(user)
	return 1

// Transfers both physical characteristics and character information to character
/datum/preferences/proc/copy_all_to(mob/living/carbon/human/character, safety = 0)
	if(!istype(character))
		return

	if(be_random_name)
		real_name = random_name(gender)

	if(CONFIG_GET(flag/humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace) //we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.voice = real_name
	character.name = character.real_name

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.med_record = strip_html(med_record)
	character.sec_record = strip_html(sec_record)
	character.gen_record = strip_html(gen_record)
	character.exploit_record = strip_html(exploit_record)

	character.age = age
	character.gender = gender
	character.ethnicity = ethnicity
	character.body_type = body_type

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

// Transfers the character's physical characteristics (age, gender, ethnicity, etc) to the mob
/datum/preferences/proc/copy_appearance_to(mob/living/carbon/human/character, safety = 0)
	if(!istype(character))
		return

	character.age = age
	character.gender = gender
	character.ethnicity = ethnicity
	character.body_type = body_type

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


// Transfers the character's information (name, flavor text, records, roundstart clothes, etc.) to the mob
/datum/preferences/proc/copy_information_to(mob/living/carbon/human/character, safety = 0)
	if(!istype(character))
		return

	if(be_random_name)
		real_name = random_name(gender)

	if(CONFIG_GET(flag/humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace) //we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.voice = real_name
	character.name = character.real_name

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record

	character.origin = origin
	character.personal_faction = faction
	character.religion = religion


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
			if(!name) name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?_src_=prefs;preference=changeslot;num=[i];'>[name]</a><br>"

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

	if (key in key_mods)
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

/datum/preferences/proc/open_character_traits(mob/user, character_trait_group)
	if(!read_traits)
		read_traits = TRUE
		for(var/trait in traits)
			var/datum/character_trait/character_trait = GLOB.character_traits[trait]
			trait_points -= character_trait.cost
	var/dat = "<body onselectstart='return false;'>"
	dat += "<center>"
	var/datum/character_trait_group/current_trait_group
	var/i = 1
	for(var/trait_group in GLOB.character_trait_groups)
		var/datum/character_trait_group/CTG = GLOB.character_trait_groups[trait_group]
		if(!CTG.group_visible)
			continue
		var/button_class = ""
		if(!character_trait_group && i == 1 || character_trait_group == trait_group)
			button_class = "class='linkOn'"
			current_trait_group = CTG
		dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=traits;task=change_slot;trait_group=[trait_group]' [button_class]>"
		dat += CTG.trait_group_name
		dat += "</a>"
		i++
	dat += "</center>"
	dat += "<table>"
	for(var/trait in current_trait_group.traits)
		var/datum/character_trait/character_trait = trait
		if(!character_trait.applyable)
			continue
		var/has_trait = (character_trait.type in traits)
		var/task = has_trait ? "remove_trait" : "give_trait"
		var/button_class = has_trait ? "class='linkOn'" : ""
		dat += "<tr><td width='40%'>"
		if(has_trait || character_trait.can_give_trait(src))
			dat += "<a href='?_src_=prefs;preference=traits;task=[task];trait=[character_trait.type];trait_group=[current_trait_group.type]' [button_class]>"
			dat += "[character_trait.trait_name]"
			dat += "</a>"
		else
			dat += "<i>[character_trait.trait_name]</i>"
		var/cost_text = character_trait.cost ? " ([character_trait.cost] points)" : ""
		dat += "</td><td>[character_trait.trait_desc][cost_text]</td></tr>"
		dat += ""
	dat += "</table>"
	dat += "</body>"
	show_browser(user, dat, "Character Traits", "character_traits")
	update_preview_icon(TRUE)

#undef MENU_MARINE
#undef MENU_XENOMORPH
#undef MENU_CO
#undef MENU_SYNTHETIC
#undef MENU_YAUTJA
#undef MENU_MENTOR
#undef MENU_SETTINGS
#undef MENU_SPECIAL
