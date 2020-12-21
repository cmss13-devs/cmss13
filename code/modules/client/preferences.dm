//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

var/global/list/stylesheets = list(
	"Modern" = 'html/browser/common.css',
	"Legacy" = 'html/browser/legacy.css'
)

var/const/MAX_SAVE_SLOTS = 10

/datum/preferences
	var/client/owner
	var/obj/screen/preview_front
	var/mob/living/carbon/human/dummy/preview_dummy

	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/fps = 20
	var/last_id

	//game-preferences
	var/lastchangelog = ""				// Saved changlog filesize to detect if there was a change
	var/ooccolor = "#b82e00"
	var/be_special = 0				// Special role selection
	var/toggle_prefs = TOGGLE_MIDDLE_MOUSE_CLICK|TOGGLE_DIRECTIONAL_ATTACK // flags in #define/mode.dm
	var/UI_style = "midnight"
	var/toggles_chat = TOGGLES_CHAT_DEFAULT
	var/toggles_sound = TOGGLES_SOUND_DEFAULT
	var/chat_display_preferences = CHAT_TYPE_ALL
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

	//Synthetic specific preferences
	var/synthetic_name = "Undefined"
	var/synthetic_type = "Synthetic"
	//Predator specific preferences.
	var/predator_name = "Undefined"
	var/predator_gender = MALE
	var/predator_age = 100
	var/predator_mask_type = 1
	var/predator_armor_type = 1
	var/predator_boot_type = 1


	//WL Council preferences.
	var/yautja_status = WHITELIST_NORMAL
	var/commander_status = WHITELIST_NORMAL
	var/synth_status = WHITELIST_NORMAL

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/be_random_body = 0				//whether we have a random appearance every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 18						//age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/underwear = 1					//underwear type
	var/undershirt = 1					//undershirt type
	var/backbag = 2						//backpack type
	var/h_style = "Crewcut"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color

	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = "Human"               //Species datum to use.
	var/ethnicity = "Western"			// Ethnicity
	var/body_type = "Mesomorphic (Average)" // Body Type
	var/language = "None"				//Secondary language
	var/list/gear						//Custom/fluff item loadout.
	var/preferred_squad = "None"

		//Some faction information.
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "United Americas (United States)" //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.

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
	var/disabilities = 0

	var/nanotrasen_relation = "Neutral"

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

	// XENO NAMES
	var/xeno_prefix = "XX"
	var/xeno_postfix = ""
	var/xeno_name_ban = FALSE

	var/playtime_perks = TRUE

	var/stylesheet = "Modern"

	var/lang_chat_disabled = FALSE

	var/swap_hand_default = "Ctrl+X"
	var/swap_hand_hotkeymode = "X"
	var/key_buf // A buffer for setting macro keybinds
	var/list/key_mod_buf // A buffer for macro modifiers

	var/tgui_fancy = TRUE
	var/tgui_lock = FALSE

/datum/preferences/New(client/C)
	if(istype(C))
		owner = C
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender)
	gear = list()

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

	var/dat = "<html><head><style>"
	dat += "#wrapper 		{position: relative; margin: 0 auto;}"
	dat += "#column1			{width: 30%; float: left;}"
	dat += "#column2			{width: 30%; float: left;}"
	dat += "#column3			{width: 40%; float: left;}"
	dat += ".square			{width: 15px; height: 15px; display: inline-block;}"
	dat += "</style></head>"
	dat += "<body onselectstart='return false;'>"

	if(path)
		dat += "<center>"
		dat += "Slot <b>[slot_name]</b> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=open_load_dialog\">Load slot</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=save\">Save slot</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=reload\">Reload slot</a>"
		dat += "</center>"
	else
		dat += "Please create an account to save your preferences."


	dat += "<div id='wrapper'>"
	dat += "<div id='column1'>"
	dat += "<h1><u><b>Name:</b></u> "
	dat += "<a href='?_src_=prefs;preference=name;task=input'><b>[real_name]</b></a>"
	dat += "<a href='?_src_=prefs;preference=name;task=random'>&reg</A></h1>"
	dat += "Always Pick Random Name: <a href='?_src_=prefs;preference=rand_name'>[be_random_name ? "Yes" : "No"]</a>"
	dat += "<br>"
	dat += "Always Pick Random Appearance: <a href='?_src_=prefs;preference=rand_body'>[be_random_body ? "Yes" : "No"]</a>"
	dat += "<br><br>"


	dat += "<h2><b><u>Physical Information:</u></b>"
	dat += "<a href='?_src_=prefs;preference=all;task=random'>&reg;</A></h2>"
	dat += "<b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'><b>[age]</b></a><br>"
	dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'><b>[gender == MALE ? "Male" : "Female"]</b></a><br>"
	dat += "<b>Ethnicity:</b> <a href='?_src_=prefs;preference=ethnicity;task=input'><b>[ethnicity]</b></a><br>"
	dat += "<b>Body Type:</b> <a href='?_src_=prefs;preference=body_type;task=input'><b>[body_type]</b></a><br>"
	dat += "<b>Poor Eyesight:</b> <a href='?_src_=prefs;preference=disabilities'><b>[disabilities == 0 ? "No" : "Yes"]</b></a><br>"
	dat += "<br>"

	dat += "<h2><b><u>Occupation Choices:</u></b></h2>"

	var/display_prefix = xeno_prefix ? xeno_prefix : "------"
	var/display_postfix = xeno_postfix ? xeno_postfix : "------"
	dat += "<b>Xeno prefix:</b> <a href='?_src_=prefs;preference=xeno_prefix;task=input'>[display_prefix]</a><br>"
	dat += "<b>Xeno postfix:</b> <a href='?_src_=prefs;preference=xeno_postfix;task=input'>[display_postfix]</a><br>"

	dat += "<b>Enable Playtime Perks:</b> <a href='?_src_=prefs;preference=playtime_perks'><b>[playtime_perks? "Yes" : "No"]</b></a><br>"

	var/tempnumber = rand(1, 999)
	var/postfix_text = xeno_postfix ? ("-"+xeno_postfix) : ""
	var/prefix_text = xeno_prefix ? xeno_prefix : "XX"
	var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"

	dat += "<b>Xeno sample name:</b> [xeno_text]<br>"
	dat += "<br>"

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
				ban_check_name = "Alien"

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

	dat += "<div id='column2'>"
	dat += "<br>"
	dat += "<b>Hair:</b> "
	dat += "<a href='?_src_=prefs;preference=h_style;task=input'>[h_style]</a>"
	dat += " | "
	dat += "<a href='?_src_=prefs;preference=hair;task=input'>"
	dat += "Color <span class='square' style='background-color: #[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)];'></span>"
	dat += "</a>"
	dat += "<br>"

	dat += "<b>Facial Hair:</b> "
	dat += "<a href='?_src_=prefs;preference=f_style;task=input'>[f_style]</a>"
	dat += " | "
	dat += "<a href='?_src_=prefs;preference=facial;task=input'>"
	dat += "Color <span class='square' style='background-color: #[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)];'></span>"
	dat += "</a>"
	dat += "<br>"

	dat += "<b>Eye:</b> "
	dat += "<a href='?_src_=prefs;preference=eyes;task=input'>"
	dat += "Color <span class='square' style='background-color: #[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)];'></span>"
	dat += "</a>"
	dat += "<br><br>"
	dat += "<h2><b><u>Background Information:</u></b></h2>"
	dat += "<b>Citizenship</b>: <a href='byond://?src=\ref[user];preference=citizenship;task=input'>[citizenship]</a><br/>"
	dat += "<b>Religion</b>: <a href='byond://?src=\ref[user];preference=religion;task=input'>[religion]</a><br/>"

	dat += "<b>Corporate Relation:</b> <a href ='?_src_=prefs;preference=nt_relation;task=input'><b>[nanotrasen_relation]</b></a><br>"
	dat += "<b>Preferred Squad:</b> <a href ='?_src_=prefs;preference=prefsquad;task=input'><b>[preferred_squad]</b></a><br>"

	if(jobban_isbanned(user, "Records"))
		dat += "<b>You are banned from using character records.</b><br>"
	else
		dat += "<b><a href=\"byond://?src=\ref[user];preference=records;record=1\">Character Records</a></b><br>"

	dat += "<a href='byond://?src=\ref[user];preference=flavor_text;task=open'><b>Character Description</b></a>"

	dat += "<br><br>"

	dat += "<h2><b><u>Marine Gear:</u></b></h2>"
	if(gender == MALE)
		dat += "<b>Underwear:</b> <a href ='?_src_=prefs;preference=underwear;task=input'><b>[underwear_m[underwear]]</b></a><br>"
	else
		dat += "<b>Underwear:</b> <a href ='?_src_=prefs;preference=underwear;task=input'><b>[underwear_f[underwear]]</b></a><br>"

	dat += "<b>Undershirt:</b> <a href='?_src_=prefs;preference=undershirt;task=input'><b>[undershirt_t[undershirt]]</b></a><br>"

	dat += "<b>Backpack Type:</b> <a href ='?_src_=prefs;preference=bag;task=input'><b>[backbaglist[backbag]]</b></a><br>"

	dat += "<b>Custom Loadout:</b> "
	var/total_cost = 0

	if(!islist(gear))
		gear = list()

	if(gear && gear.len)
		dat += "<br>"
		for(var/i = 1; i <= gear.len; i++)
			var/datum/gear/G = gear_datums[gear[i]]
			if(G)
				total_cost += G.cost
				dat += "[gear[i]] ([G.cost] points) <a href='byond://?src=\ref[user];preference=loadout;task=remove;gear=[i]'>Remove</a><br>"

		dat += "<b>Used:</b> [total_cost] points."
	else
		dat += "None"

	if(total_cost < MAX_GEAR_COST)
		dat += " <a href='byond://?src=\ref[user];preference=loadout;task=input'>Add</a>"
		if(gear && gear.len)
			dat += " <a href='byond://?src=\ref[user];preference=loadout;task=clear'>Clear</a>"
	dat += "</div>"

	dat += "<div id='column3'>"
	dat += "<h2><b><u>Game Settings:</u></b></h2>"
	dat += "<b>tgui Window Mode:</b> <a href='?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy (default)" : "Compatible (slower)"]</a><br>"
	dat += "<b>tgui Window Placement:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary monitor" : "Free (default)"]</a><br>"
	dat += "<b>Play Admin Midis:</b> <a href='?_src_=prefs;preference=hear_midis'><b>[(toggles_sound & SOUND_MIDI) ? "Yes" : "No"]</b></a><br>"
	dat += "<b>Play Lobby Music:</b> <a href='?_src_=prefs;preference=lobby_music'><b>[(toggles_sound & SOUND_LOBBY) ? "Yes" : "No"]</b></a><br>"
	dat += "<b>Ghost Ears:</b> <a href='?_src_=prefs;preference=ghost_ears'><b>[(toggles_chat & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a><br>"
	dat += "<b>Ghost Sight:</b> <a href='?_src_=prefs;preference=ghost_sight'><b>[(toggles_chat & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a><br>"
	dat += "<b>Ghost Radio:</b> <a href='?_src_=prefs;preference=ghost_radio'><b>[(toggles_chat & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a><br>"
	dat += "<b>Ghost Hivemind:</b> <a href='?_src_=prefs;preference=ghost_hivemind'><b>[(toggles_chat & CHAT_GHOSTHIVEMIND) ? "Show Hivemind" : "Hide Hivemind"]</b></a><br>"
	dat += "<b>Swap Hand Macro (default mode):</b> <a href='?_src_=prefs;preference=swap_hand_default'><b>[swap_hand_default]</b></a><br>"
	dat += "<b>Swap Hand Macro (hotkey mode):</b> <a href='?_src_=prefs;preference=swap_hand_hotkeymode'><b>[swap_hand_hotkeymode]</b></a><br>"
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

	if(CONFIG_GET(flag/allow_Metadata))
		dat += "<b>OOC Notes:</b> <a href='?_src_=prefs;preference=metadata;task=input'> Edit </a><br>"
	dat += "<br>"

	dat += "<h2><b><u>UI Customization:</u></b></h2>"
	dat += "<b>Style:</b> <a href='?_src_=prefs;preference=ui'><b>[UI_style]</b></a><br>"
	dat += "<b>Color</b>: <a href='?_src_=prefs;preference=UIcolor'><b>[UI_style_color]</b> <table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></table></a><br>"
	dat += "<b>Alpha</b>: <a href='?_src_=prefs;preference=UIalpha'><b>[UI_style_alpha]</b></a><br><br>"
	dat += "<b>Stylesheet</b>: <a href='?_src_=prefs;preference=stylesheet'><b>[stylesheet]</b></a><br>"
	if(user.client.admin_holder && user.client.admin_holder.rights & R_DEBUG)
		dat += "<b>View Master Controller Tab: <a href='?_src_=prefs;preference=ViewMC'><b>[View_MC ? "TRUE" : "FALSE"]</b></a>"
	dat += "</div>"

	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_COMMANDER)
		dat += "<div id='column1'>"
		dat += "<h2><b><u>Commander Settings:</u></b></h2>"
		dat += "<b>Commander whitelist status:</b><a href='?_src_=prefs;preference=commander_status;task=input'>[commander_status]</a><br>"
		dat += "</div>"

	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_PREDATOR)
		dat += "<div id='column2'>"
		dat += "<h2><b><u>Yautja Settings:</u></b></h2>"
		dat += "<b>Yautja name:</b> <a href='?_src_=prefs;preference=pred_name;task=input'>[predator_name]</a><br>"
		dat += "<b>Yautja gender:</b> <a href='?_src_=prefs;preference=pred_gender;task=input'>[predator_gender == MALE ? "Male" : "Female"]</a><br>"
		dat += "<b>Yautja age:</b> <a href='?_src_=prefs;preference=pred_age;task=input'>[predator_age]</a><br>"
		dat += "<b>Mask style:</b> <a href='?_src_=prefs;preference=pred_mask_type;task=input'>([predator_mask_type])</a><br>"
		dat += "<b>Armor style:</b> <a href='?_src_=prefs;preference=pred_armor_type;task=input'>([predator_armor_type])</a><br>"
		dat += "<b>Greave style:</b> <a href='?_src_=prefs;preference=pred_boot_type;task=input'>([predator_boot_type])</a><br><br>"
		dat += "<b>Yautja whitelist status:</b> <a href='?_src_=prefs;preference=yautja_status;task=input'>[yautja_status]</a><br>"
		dat += "</div>"

	if(RoleAuthority.roles_whitelist[user.ckey] & WHITELIST_SYNTHETIC)
		dat += "<div id='column3'>"
		dat += "<h2><b><u>Synthetic Settings:</u></b></h2>"
		dat += "<b>Synthetic name:</b> <a href='?_src_=prefs;preference=synth_name;task=input'>[synthetic_name]</a><br>"
		dat += "<b>Synthetic Type:</b> <a href='?_src_=prefs;preference=synth_type;task=input'>[synthetic_type]</a><br>"
		dat += "<b>Synthetic whitelist status:</b> <a href='?_src_=prefs;preference=synth_status;task=input'>[synth_status]</a><br>"
		dat += "</div>"

	dat += "</div></body></html>"

	winshow(user, "preferencewindow", TRUE)
	show_browser(user, dat, "Preferences", "preferencebrowser", "size=640x770")
	onclose(user, "preferencewindow", src)

//limit 	 	- The amount of jobs allowed per column. Defaults to 13 to make it look nice.
//splitJobs 	- Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
//width	 		- Screen' width. Defaults to 550 to make it look nice.
//height 	 	- Screen's height. Defaults to 500 to make it look nice.
/datum/preferences/proc/SetChoices(mob/user, limit = 18, list/splitJobs = list(), width = 800, height = 850)
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
	var/datum/job/lastJob
	for(var/i in RoleAuthority.roles_for_mode)
		var/datum/job/job = RoleAuthority.roles_for_mode[i]
		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/j = 0, j < (limit - index), j += 1)
					HTML += "<tr class='[lastJob.selection_class]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			HTML += "</table></td><td valign='top' width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr class='[job.selection_class]'><td width='40%' align='right'>"
		lastJob = job

		if(jobban_isbanned(user, job.title))
			HTML += "<b><del>[job.disp_title]</del></b></td><td><b>BANNED</b></td></tr>"
			continue
		else if(job.flags_startup_parameters & ROLE_WHITELISTED && !(RoleAuthority.roles_whitelist[user.ckey] & job.flags_whitelist))
			HTML += "<b><del>[job.disp_title]</del></b></td><td>WHITELISTED</td></tr>"
			continue
		else if(!job.can_play_role(user.client))
			var/list/missing_requirements = job.get_role_requirements(user.client)
			HTML += "<b><del>[job.disp_title]</del></b></td><td>TIMELOCKED</td></tr>"
			for(var/r in missing_requirements)
				var/datum/timelock/T = r
				HTML += "<tr class='[job.selection_class]'><td width='40%' align='right'>[T.name]</td><td>[duration2text(missing_requirements[r])] Hours</td></tr>"
			continue

		HTML += "<b>[job.disp_title]</b>"

		HTML += "</td><td width='60%'>"

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

	if(user.client.prefs) //Just makin sure
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
	var/datum/job/job = RoleAuthority.roles_for_mode[role]
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

/datum/preferences/proc/get_job_priority(var/J)
	if(!J)
		return FALSE

	if(!length(job_preference_list))
		ResetJobs()

	return job_preference_list[J]

/datum/preferences/proc/SetJobDepartment(var/datum/job/J, var/priority)
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
	if(!istype(user, /mob/new_player) && !istype(user, /mob/dead/observer)) return

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
						alternate_option += 1
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

					var/choice = input(user, "Select gear to add: ") as null|anything in valid_gear_choices

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
						msg = copytext(msg, 1, 256)
						msg = html_encode(msg)
					flavor_texts[href_list["task"]] = msg
				else
					var/msg = input(usr,"Set the flavor text for your [href_list["task"]].","Flavor Text",html_decode(flavor_texts[href_list["task"]])) as message
					if(msg != null)
						msg = copytext(msg, 1, 256)
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

	switch (href_list["task"])
		if ("random")
			switch (href_list["preference"])
				if ("name")
					real_name = random_name(gender)
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
					underwear = rand(1,underwear_m.len)
					ShowChoices(user)
				if ("undershirt")
					undershirt = rand(1,undershirt_t.len)
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
					var/raw_name = input(user, "Choose your character's name:", "Character Preference")  as text|null
					if (!isnull(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("synth_name")
					var/raw_name = input(user, "Choose your Synthetic's name:", "Character Preference")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name) synthetic_name = new_name
						else to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
				if("synth_type")
					var/new_synth_type = input(user, "Choose your model of synthetic:", "Make and Model") as null|anything in synth_types
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
					var/new_predator_age = input(user, "Choose your Predator's age(20 to 10000):", "Character Preference") as num|null
					if(new_predator_age) predator_age = max(min( round(text2num(new_predator_age)), 10000),20)
				if("pred_mask_type")
					var/new_predator_mask_type = input(user, "Choose your mask type:\n(1-11)", "Mask Selection") as num|null
					if(new_predator_mask_type) predator_mask_type = round(text2num(new_predator_mask_type))
				if("pred_armor_type")
					var/new_predator_armor_type = input(user, "Choose your armor type:\n(1-6)", "Armor Selection") as num|null
					if(new_predator_armor_type) predator_armor_type = round(text2num(new_predator_armor_type))
				if("pred_boot_type")
					var/new_predator_boot_type = input(user, "Choose your greaves type:\n(1-3)", "Greave Selection") as num|null
					if(new_predator_boot_type) predator_boot_type = round(text2num(new_predator_boot_type))

				if("commander_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & WHITELIST_COMMANDER_COUNCIL)
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_COMMANDER_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_commander_status = input(user, "Choose your new Commander Whitelist Status.", "Commander Status") in options

					if(!new_commander_status)
						return

					commander_status = options[new_commander_status]

				if("yautja_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & WHITELIST_YAUTJA_COUNCIL)
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_YAUTJA_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_yautja_status = input(user, "Choose your new Yautja Whitelist Status.", "Yautja Status") in options

					if(!new_yautja_status)
						return

					yautja_status = options[new_yautja_status]

				if("synth_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & WHITELIST_SYNTHETIC_COUNCIL)
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_SYNTHETIC_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_synth_status = input(user, "Choose your new Synthetic Whitelist Status.", "Synthetic Status") in options

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
							to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You need to play [Ceiling((124 HOURS - playtime)/HOURS_1)] more hours to unlock xeno three letter prefix.")))
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
								if(65 to 90)			//Uppercase Letters will work
								else
									all_ok = FALSE		//everything else - won't
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
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("You need to play [Ceiling((24 HOURS - playtime)/HOURS_1)] more hours to unlock xeno postfix.")))
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
								if(65 to 90)			//Uppercase Letters will work on first char
									if(!first_char)
										all_ok = FALSE
								// 0  .. 9
								if(48 to 57)			//Numbers will work if not the first char
									if(first_char)
										all_ok = FALSE
								else
									all_ok = FALSE		//everything else - won't
							first_char = FALSE
						if(all_ok)
							xeno_postfix = new_xeno_postfix
						else
							to_chat(user, "<font color='red'>Invalid Xeno Postfix. Your Postfix can contain single letter and an optional digit after it.</font>")

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
					if(new_metadata)
						metadata = strip_html(new_metadata)

				if("hair")
					if(species == "Human")
						var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as color|null
						if(new_hair)
							r_hair = hex2num(copytext(new_hair, 2, 4))
							g_hair = hex2num(copytext(new_hair, 4, 6))
							b_hair = hex2num(copytext(new_hair, 6, 8))

				if("h_style")
					var/list/valid_hairstyles = list()
					for(var/hairstyle in hair_styles_list)
						var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
						if( !(species in S.species_allowed))
							continue
						if(!S.selectable)
							continue

						valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]
					valid_hairstyles = sortList(valid_hairstyles)

					var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in valid_hairstyles
					if(new_h_style)
						h_style = new_h_style

				if ("ethnicity")
					var/new_ethnicity = input(user, "Choose your character's ethnicity:", "Character Preferences") as null|anything in GLOB.ethnicities_list

					if (new_ethnicity)
						ethnicity = new_ethnicity

				if ("body_type")
					var/new_body_type = input(user, "Choose your character's body type:", "Character Preferences") as null|anything in GLOB.body_types_list

					if (new_body_type)
						body_type = new_body_type

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as color|null
					if(new_facial)
						r_facial = hex2num(copytext(new_facial, 2, 4))
						g_facial = hex2num(copytext(new_facial, 4, 6))
						b_facial = hex2num(copytext(new_facial, 6, 8))

				if("f_style")
					var/list/valid_facialhairstyles = list()
					for(var/facialhairstyle in facial_hair_styles_list)
						var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
						if(gender == MALE && S.gender == FEMALE)
							continue
						if(gender == FEMALE && S.gender == MALE)
							continue
						if( !(species in S.species_allowed))
							continue
						if(!S.selectable)
							continue

						valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]
					valid_facialhairstyles = sortList(valid_facialhairstyles)

					var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in valid_facialhairstyles
					if(new_f_style)
						f_style = new_f_style

				if("underwear")
					var/list/underwear_options
					if(gender == MALE)
						underwear_options = underwear_m
					else
						underwear_options = underwear_f

					var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in underwear_options
					if(new_underwear)
						underwear = underwear_options.Find(new_underwear)
					ShowChoices(user)

				if("undershirt")
					var/list/undershirt_options
					undershirt_options = undershirt_t

					var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in undershirt_options
					if (new_undershirt)
						undershirt = undershirt_options.Find(new_undershirt)
					ShowChoices(user)

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color|null
					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))


				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
					if(new_backbag)
						backbag = backbaglist.Find(new_backbag)

				if("nt_relation")
					var/new_relation = input(user, "Choose your relation to the Weston-Yamada company. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
					if(new_relation)
						nanotrasen_relation = new_relation

				if("prefsquad")
					var/new_pref_squad = input(user, "Choose your preferred squad.", "Character Preference")  as null|anything in list("Alpha", "Bravo", "Charlie", "Delta", "None")
					if(new_pref_squad)
						preferred_squad = new_pref_squad

				if("limbs")
					var/limb_name = input(user, "Which limb do you want to change?") as null|anything in list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand")
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

					var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in list("Normal","Prothesis") //"Amputated"
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
					var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in list("Heart", "Eyes")
					if(!organ_name) return

					var/organ = null
					switch(organ_name)
						if("Heart")
							organ = "heart"
						if("Eyes")
							organ = "eyes"

					var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in list("Normal","Assisted","Mechanical")
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organ_data[organ] = null
						if("Assisted")
							organ_data[organ] = "assisted"
						if("Mechanical")
							organ_data[organ] = "mechanical"

				if("skin_style")
					var/skin_style_name = input(user, "Select a new skin style") as null|anything in list("default1", "default2", "default3")
					if(!skin_style_name) return

				if("citizenship")
					var/choice = input(user, "Please choose your current citizenship.") as null|anything in citizenship_choices
					if(choice)
						citizenship = choice

				if("religion")
					var/choice = input(user, "Please choose a religion.") as null|anything in religion_choices + list("None","Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter a religon.")  as text|null
						if(raw_choice)
							religion = strip_html(raw_choice)
						return
					religion = choice
		else
			switch(href_list["preference"])
				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE
						underwear = 1

				if("disabilities")				//please note: current code only allows nearsightedness as a disability
					disabilities = !disabilities//if you want to add actual disabilities, code that selects them should be here

				if("hear_adminhelps")
					toggles_sound ^= SOUND_ADMINHELP

				if("ui")
					switch(UI_style)
						if("dark")
							UI_style = "midnight"
						if("midnight")
							UI_style = "orange"
						if("orange")
							UI_style = "old"
						if("old")
							UI_style = "white"
						else
							UI_style = "dark"

				if("UIcolor")
					var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!") as color|null
					if(!UI_style_color_new) return
					UI_style_color = UI_style_color_new

				if("UIalpha")
					var/UI_style_alpha_new = input(user, "Select a new alpha(transparence) parametr for UI, between 50 and 255") as num
					if(!UI_style_alpha_new|!(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50)) return
					UI_style_alpha = UI_style_alpha_new

				if("stylesheet")
					var/stylesheet_new = input(user, "Select a stylesheet to use (affects non-NanoUI interfaces)") in stylesheets
					stylesheet = stylesheet_new

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

				if("lobby_music")
					toggles_sound ^= SOUND_LOBBY
					if(toggles_sound & SOUND_LOBBY)
						user << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
					else
						user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

				if("ghost_ears")
					toggles_chat ^= CHAT_GHOSTEARS

				if("ghost_sight")
					toggles_chat ^= CHAT_GHOSTSIGHT

				if("ghost_radio")
					toggles_chat ^= CHAT_GHOSTRADIO

				if("ghost_hivemind")
					toggles_chat ^= CHAT_GHOSTHIVEMIND

				if("swap_hand_default")
					owner.runtime_macro_remove(swap_hand_default, "default")

					swap_hand_default = read_key()
					if (!swap_hand_default)
						swap_hand_default = "CTRL+X"

					owner.runtime_macro_insert(swap_hand_default, "default", ".SwapMobHand")

				if("swap_hand_hotkeymode")
					owner.runtime_macro_remove(swap_hand_hotkeymode, "hotkeymode")

					swap_hand_hotkeymode = read_key()
					if (!swap_hand_hotkeymode)
						swap_hand_hotkeymode = "X"

					owner.runtime_macro_insert(swap_hand_hotkeymode, "hotkeymode", ".SwapMobHand")

				if("toggle_prefs")
					var/flag = text2num(href_list["flag"])
					var/flag_undo = text2num(href_list["flag_undo"])
					toggle_prefs ^= flag
					if (toggle_prefs & flag && toggle_prefs & flag_undo)
						toggle_prefs ^= flag_undo

				if("save")
					save_preferences()
					save_character()
					var/mob/new_player/np = user
					if(istype(np))
						np.new_player_panel_proc()

				if("reload")
					load_preferences()
					load_character()

				if("open_load_dialog")
					if(!IsGuestKey(user.key))
						open_load_dialog(user)

				if("close_load_dialog")
					close_load_dialog(user)

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
		if(!firstspace)	//we need a surname
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

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.h_style = h_style
	character.f_style = f_style

	character.home_system = home_system
	character.citizenship = citizenship
	character.personal_faction = faction
	character.religion = religion

	// Destroy/cyborgize organs

	for(var/name in organ_data)

		var/status = organ_data[name]
		var/obj/limb/O = character.get_limb(name)
		if(O)
//			if(status == "amputated")
//				O.amputated = 1
//				O.status |= LIMB_DESTROYED
//				O.destspawn = 1
			if(status == "cyborg")
				O.status |= LIMB_ROBOT
		else
			var/datum/internal_organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.mechanize()

	if(underwear > underwear_f.len || underwear < 1)
		underwear = 0 //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	character.underwear = underwear

	if(undershirt > undershirt_t.len || undershirt < 1)
		undershirt = 0
	character.undershirt = undershirt

	if(backbag > 2 || backbag < 1)
		backbag = 2 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_staff("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
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

	if(underwear > underwear_f.len || underwear < 1)
		underwear = 0 //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	character.underwear = underwear

	if(undershirt > undershirt_t.len || undershirt < 1)
		undershirt = 0
	character.undershirt = undershirt

	if(backbag > 2 || backbag < 1)
		backbag = 2 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_staff("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
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
		if(!firstspace)	//we need a surname
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

	character.home_system = home_system
	character.citizenship = citizenship
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
			if(!name)	name = "Character[i]"
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

	RegisterSignal(owner, COMSIG_CLIENT_KEY_DOWN, .proc/parse_key_down)
	RegisterSignal(owner, COMSIG_CLIENT_KEY_UP, .proc/set_key_buf)
	winset(owner, null, "mainwindow.macro=keyreader")
	while (!key_buf)
		stoplag()
	winset(owner, null, "mainwindow.macro=[old]")
	UnregisterSignal(owner, list(
		COMSIG_CLIENT_KEY_DOWN,
		COMSIG_CLIENT_KEY_UP,
	))

	alert("The key sequence is [key_buf].")
	return key_buf
