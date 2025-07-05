/mob
	density = TRUE
	layer = MOB_LAYER
	animate_movement = 2
	rebounds = TRUE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	var/mob_flags = NO_FLAGS
	var/datum/mind/mind

	var/icon_size = 32

	// An ID that uniquely identifies this mob through the full round
	var/gid = 0

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	var/chatWarn = 0 //Tracks how many times someone has spammed and gives them a no-no timer

	var/atom/movable/screen/hands = null //robot

	/// a ckey that persists client logout / ghosting, replaced when a client inhabits the mob
	var/persistent_ckey

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/obj/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticeable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	/// The list of people observing this mob.
	var/list/mob/dead/observer/observers
	var/zone_selected = "chest"

	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/damageoverlaytemp = 0
	var/computer_id = null //to track the players
	var/list/attack_log = list( )
	var/atom/movable/interactee //the thing that the mob is currently interacting with (e.g. a computer, another mob (stripping a mob), manning a hmg)
	var/sdisabilities = 0 //Carbon
	var/disabilities = 0 //Carbon
	var/atom/movable/pulling = null
	var/next_move = null
	var/next_move_slowdown = 0 // Amount added during the next movement_delay(), then is reset.
	var/speed = 0 //Speed that modifies the movement delay of a given mob
	var/recalculate_move_delay = TRUE // Whether move delay needs to be recalculated, on by default so that new mobs actually get movement delay calculated upon creation
	var/crawling = FALSE
	var/can_crawl = TRUE
	var/monkeyizing = null //Carbon
	var/hand = null

	// status effects that decrease over time \\

	/// timer for blinding
	var/eye_blind = 0 //Carbon
	/// Does the mob have blurry sight
	var/eye_blurry = 0 //Carbon
	var/ear_deaf = 0 //Carbon
	var/ear_damage = 0 //Carbon
	var/stuttering = 0 //Carbon
	var/slurring = 0 //Carbon
	var/paralyzed = 0 //Carbon
	var/druggy = 0 //Carbon
	var/confused = 0 //Carbon
	var/drowsyness = 0.0//Carbon
	var/dizziness = 0//Carbon
	var/jitteriness = 0//Carbon
	var/floatiness = 0
	var/losebreath = 0.0//Carbon
	var/shakecamera = 0

	// bool status effects \\

	/// bool that tracks if blind
	var/blinded = FALSE
	var/resting = 0
	var/is_floating = 0
	var/is_dizzy = 0
	var/is_jittery = 0

	// strings \\

	var/real_name = ""
	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	var/gibbing = FALSE
	var/lastpuke = 0
	unacidable = FALSE
	var/mob_size = MOB_SIZE_HUMAN
	var/list/embedded = list()   // Embedded items, since simple mobs don't have organs.
	var/list/datum/language/languages = list()  // For speaking/listening.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1 // Define emote default type, 1 for seen emotes, 2 for heard emotes

	var/name_archive //For admin things like possession

	///Override for sound_environments. If this is set the user will always hear a specific type of reverb (Instead of the area defined reverb)
	var/sound_environment_override = SOUND_ENVIRONMENT_NONE

	// Determines what the alpha of the lighting is to this mob.
	var/lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	/// List of active luminosity sources for handling of light stacking
	var/list/atom/luminosity_sources

	var/statistic_exempt = FALSE
	var/statistic_tracked = FALSE //So we don't repeat log the same data on death/ghost/cryo
	var/life_time_start = 0
	var/life_time_total = 0
	var/timeofdeath = 0.0//Living
	var/life_steps_total = 0
	var/life_kills_total = 0
	var/life_damage_taken_total = 0
	var/life_revives_total = 0
	var/life_ib_total = 0
	var/festivizer_hits_total = 0

	var/life_value = 1 // when killed, the killee gets this much added to its life_kills_total
	var/default_honor_value = 1 // when killed by a yautja, this determines the minimum amount of honor gained

	var/bodytemperature = 310.055 //98.7 F
	var/old_x = 0
	var/old_y = 0

	var/charges = 0
	var/nutrition = NUTRITION_NORMAL//Carbon

	var/overeatduration = 0 // How long this guy is overeating //Carbon
	var/recovery_constant = 1
	var/a_intent = INTENT_HELP//Living
	var/m_intent = MOVE_INTENT_RUN
	var/lastKnownIP = null
	var/obj/buckled = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/back = null//Human/Monkey
	var/obj/item/tank/internal = null//Human/Monkey
	var/obj/item/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon

	var/able_to_speak = TRUE

	var/datum/hud/hud_used = null

	var/grab_level = GRAB_PASSIVE //if we're pulling a mob, tells us how aggressive our grab is.

	var/list/mapobjs = list()

	var/throw_mode = THROW_MODE_OFF

	var/coughedtime = null

	var/inertia_dir = 0

	var/voice_name = "unidentifiable voice"

	var/job = null // Internal job title used when mob is spawned. Preds are "Predator", Xenos are "Xenomorph", Marines have their actual job title
	var/comm_title = ""
	var/faction = FACTION_NEUTRAL
	var/faction_group

	var/looc_overhead = FALSE

	var/datum/skills/skills = null //the knowledge you have about certain abilities and actions (e.g. do you how to do surgery?)
									//see skills.dm in #define folder and code/datums/skills.dm for more info
	var/obj/item/restraint/legcuffs/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.

	var/list/viruses = list() //List of active diseases

//Monkey/infected mode
	var/list/resistances = list()

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/status_flags = DEFAULT_MOB_STATUS_FLAGS //bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null
	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_understand = 0 // Set to 1 to enable the mob to understand everyone, not necessarily speak

	var/immune_to_ssd = 0
	var/aghosted = FALSE //If the mob owner is currently aghosted.

	var/list/tile_contents = list()  //the contents of the turf being examined in the stat panel
	var/tile_contents_change = 0

	var/STUI_log = 1

	var/away_timer = 0 //How long the player has not done an action.

	var/recently_pointed_to = 0 //used as cooldown for the pointing verb.

	var/recently_grabbed = 0 //used as a cooldown for item grabs

	///Color matrices to be applied to the client window. Assoc. list.
	var/list/client_color_matrices

	///This mob's HUD (med/sec, etc) images. Associative list.
	var/list/image/hud_list
	///HUD images that this mob can provide.
	var/list/hud_possible

	var/action_busy //whether the mob is currently doing an action that takes time (do_after proc)
	var/resisting // whether the mob is currently resisting (primarily for do_after proc)
	var/clicked_something // a list of booleans for if a mob did a specific click
							// only left click, shift click, right click, and middle click

	var/datum/cause_data/last_damage_data // for tracking whatever damaged us last

	var/noclip = FALSE

	var/next_delay_update = 0 // when next update of move delay should happen
	var/next_delay_delay = 10 // how much time we wait for next calc of move delay
	var/move_delay

	///Holds the time when a mob can throw an item next, only applies after two throws, reference /mob/proc/do_click()
	COOLDOWN_DECLARE(throw_delay)

	///holds the buffer to allow for throwing two things before the cooldown effects throwing, reference /mob/proc/do_click()
	var/throw_buffer = 0

	var/list/datum/action/actions = list()

	can_block_movement = TRUE

	appearance_flags = TILE_BOUND

	///the mob's tgui player panel
	var/datum/player_panel/mob_panel

	///the mob's tgui player panel
	var/datum/language_menu/mob_language_menu

	var/datum/focus

	///the current turf being examined in the stat panel
	var/turf/listed_turf = null

	var/list/list/item_verbs = list()

	var/max_implants = 2
	var/list/implants

	var/move_on_shuttle = TRUE // Can move on the shuttle.

	var/list/important_radio_channels = list()

	var/datum/click_intercept

	/// Used for tracking last uses of emotes for cooldown purposes
	var/list/emotes_used

	///the icon currently used for the typing indicator's bubble
	var/mutable_appearance/active_typing_indicator
	///the icon currently used for the thinking indicator's bubble
	var/mutable_appearance/active_thinking_indicator
	/// User is thinking in character. Used to revert to thinking state after stop_typing
	var/thinking_IC = FALSE

	// contains /atom/movable/screen/alert only
	var/list/alerts = list()

/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EXPLODE, "Trigger Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EMPULSE, "Trigger EM Pulse")
	VV_DROPDOWN_OPTION(VV_HK_SETMATRIX, "Set Base Matrix")
	VV_DROPDOWN_OPTION("", "-----MOB-----")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_DISEASE, "Give Disease")
	VV_DROPDOWN_OPTION(VV_HK_BUILDMODE, "Give Build Mode")
	VV_DROPDOWN_OPTION(VV_HK_GIB, "Gib")
	VV_DROPDOWN_OPTION(VV_HK_DROP_ALL, "Drop All")
	VV_DROPDOWN_OPTION(VV_HK_DIRECT_CONTROL, "Assume Direct Control")
	VV_DROPDOWN_OPTION(VV_HK_ADD_VERB, "Add Verb")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_VERB, "Remove Verb")
	VV_DROPDOWN_OPTION(VV_HK_SELECT_EQUIPMENT, "Select Equipment")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_SKILL, "Edit Skills")
	VV_DROPDOWN_OPTION(VV_HK_ADD_LANGUAGE, "Add Language")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_LANGUAGE, "Remove Language")
	VV_DROPDOWN_OPTION(VV_HK_REGEN_ICONS, "Regenerate Icons")

/mob/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += "<font size='1'><br><a href='byond://?_src_=vars;[HrefToken()];view_combat_logs=[refid]'>View Combat Logs</a><br></font>"

/mob/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_HK_SETMATRIX])
		if(!check_rights(R_DEBUG|R_ADMIN|R_VAREDIT))
			return

		if(!LAZYLEN(usr.client.stored_matrices))
			to_chat(usr, "You don't have any matrices stored!")
			return

		var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (usr.client.stored_matrices + "Revert to Default" + "Cancel"))
		if(!matrix_name || matrix_name == "Cancel")
			return
		else if (matrix_name == "Revert to Default")
			base_transform = null
			transform = matrix()
			disable_pixel_scaling()
			return

		var/matrix/MX = LAZYACCESS(usr.client.stored_matrices, matrix_name)
		if(!MX)
			return

		base_transform = MX
		transform = MX

		if (alert(usr, "Would you like to enable pixel scaling?", "Confirm", "Yes", "No") == "Yes")
			enable_pixel_scaling()

	if(href_list[VV_HK_GIVE_DISEASE])
		if(!check_rights(R_ADMIN))
			return

		usr.client.give_disease(src)

	if(href_list[VV_HK_BUILDMODE])
		if(!check_rights(R_ADMIN))
			return

		if(!client || !client.admin_holder || !(client.admin_holder.rights & R_MOD))
			to_chat(usr, "This can only be used on people with +MOD permissions")
			return

		log_admin("[key_name(usr)] has toggled buildmode on [key_name(src)]")
		message_admins("[key_name_admin(usr)] has toggled buildmode on [key_name_admin(src)]")

		togglebuildmode(src)

	if(href_list[VV_HK_GIB])
		if(!check_rights(R_MOD))
			return

		usr.client.cmd_admin_gib(src)

	if(href_list[VV_HK_DROP_ALL])
		if(!check_rights(R_DEBUG|R_ADMIN))
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(src)

	if(href_list[VV_HK_DIRECT_CONTROL])
		if(!check_rights(R_ADMIN))
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(src)

	if(href_list[VV_HK_ADD_VERB])
		if(!check_rights(R_DEBUG))
			return

		var/list/possibleverbs = list()
		possibleverbs += "Cancel" // One for the top...
		possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		switch(type)
			if(/mob/living/carbon/human)
				possibleverbs += typesof(/mob/living/carbon/proc,/mob/living/carbon/verb,/mob/living/carbon/human/verb,/mob/living/carbon/human/proc)
		possibleverbs -= verbs
		possibleverbs += "Cancel" // ...And one for the bottom

		var/verb = tgui_input_list(usr, "Select a verb!", "Verbs", possibleverbs)
		if(!verb || verb == "Cancel")
			return
		else
			add_verb(src, verb)

	if(href_list[VV_HK_SELECT_EQUIPMENT])
		if(!check_rights(R_SPAWN))
			return

		usr.client.cmd_admin_dress(src)

	if(href_list[VV_HK_ADD_LANGUAGE])
		if(!check_rights(R_SPAWN))
			return

		var/new_language = tgui_input_list(usr, "Please choose a language to add.","Language", GLOB.all_languages)

		if(!new_language)
			return

		if(add_language(new_language))
			to_chat(usr, "Added [new_language] to [src].")
		else
			to_chat(usr, "Mob already knows that language.")

	if(href_list[VV_HK_REMOVE_LANGUAGE])
		if(!check_rights(R_SPAWN))
			return

		if(!length(languages))
			to_chat(usr, "This mob knows no languages.")
			return

		var/datum/language/rem_language = tgui_input_list(usr, "Please choose a language to remove.","Language", languages)

		if(!rem_language)
			return

		if(remove_language(rem_language.name))
			to_chat(usr, "Removed [rem_language] from [src].")
		else
			to_chat(usr, "Mob doesn't know that language.")

	if(href_list[VV_HK_REMOVE_VERB])
		if(!check_rights(R_DEBUG))
			return

		var/verb = tgui_input_list(usr, "Please choose a verb to remove.","Verbs", verbs)

		if(!verb)
			return
		else
			remove_verb(src, verb)

	if(href_list[VV_HK_REGEN_ICONS])
		if(!check_rights(R_MOD))
			return

		src.regenerate_icons()
