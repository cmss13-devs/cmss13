//Xenomorph "generic" parent, does not actually appear in game
//Many of these defines aren't referenced in the castes and so are assumed to be defaulted
//Castes are all merely subchildren of this parent
//Just about ALL the procs are tied to the parent, not to the children
//This is so they can be easily transferred between them without copypasta

//All this stuff was written by Absynth.... and god help us
//Edited by Apop - 11JUN16

#define DEBUG_XENO 0

#if DEBUG_XENO
/mob/verb/debug_xeno_mind()
	set name =  "Debug Xeno Mind"
	set category = "Debug"
	set desc = "Shows whether or not a mine is contained within the xenomorph list."

	if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished."))
		return
	if(mind in SSticker.mode.xenomorphs)
		to_chat(src, SPAN_DEBUG("[src] mind is in the xenomorph list. Mind key is [mind.key]."))
		to_chat(src, SPAN_DEBUG("Current mob is: [mind.current]. Original mob is: [mind.original]."))
	else to_chat(src, SPAN_DEBUG("This xenomorph is not in the xenomorph list."))
#endif

#undef DEBUG_XENO

/mob/living/carbon/Xenomorph
	//// ALL OLD SS13 VARS
	name = "Drone"
	desc = "What the hell is THAT?"
	layer = BIG_XENO_LAYER
	voice_name = "xenomorph"
	speak_emote = list("hisses")
	attacktext = "claws"
	attack_sound = null
	friendly = "nuzzles"
	wall_smash = 0
	universal_understand = 0
	universal_speak = 0
	mob_size = MOB_SIZE_XENO
	hand = 1 //Make right hand active by default. 0 is left hand, mob defines it as null normally
	see_in_dark = 12
	recovery_constant = 1.5
	see_invisible = SEE_INVISIBLE_LIVING
	hud_possible = list(HEALTH_HUD_XENO, PLASMA_HUD, PHEROMONE_HUD, QUEEN_OVERWATCH_HUD, ARMOR_HUD_XENO, XENO_STATUS_HUD, XENO_BANISHED_HUD, XENO_HOSTILE_ACID, XENO_HOSTILE_SLOW, XENO_HOSTILE_TAG, XENO_HOSTILE_FREEZE, HUNTER_HUD)
	unacidable = TRUE
	rebounds = TRUE
	faction = FACTION_XENOMORPH
	gender = NEUTER
	icon_size = 48
	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/head/head = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null

	var/obj/item/iff_tag/iff_tag = null

	//////////////////////////////////////////////////////////////////
	//
	//		Core Stats
	//
	// 		Self-Explanatory.
	//
	//////////////////////////////////////////////////////////////////
	var/datum/caste_datum/caste // Used to extract determine ALL Xeno stats.
	var/speaking_key = "x"
	var/speaking_noise = "alien_talk"
	var/slash_verb = "slash"
	var/slashes_verb = "slashes"
	var/slash_sound = "alien_claw_flesh"
	health = 5
	maxHealth = 5
	var/crit_health = -100 // What negative healthy they die in.
	var/gib_chance  = 5 // % chance of them exploding when taking damage. Goes up with damage inflicted.
	speed = -0.5 // Speed. Positive makes you go slower. (1.5 is equivalent to FAT mutation)
	can_crawl = FALSE
	melee_damage_lower = 5
	melee_damage_upper = 10
	var/melee_vehicle_damage = 10
	var/claw_type = CLAW_TYPE_NORMAL
	var/burn_damage_lower = 0
	var/burn_damage_upper = 0
	var/plasma_stored = 10
	var/plasma_max = 10
	var/plasma_gain = 5
	var/cooldown_reduction_percentage = 0 // By what % cooldown are reduced by. 1 => No cooldown. Should normally be clamped at 50%

	var/death_fontsize = 3

	var/small_explosives_stun = TRUE // Have to put this here, otherwise it can't be strain specific
	var/counts_for_slots = TRUE
	var/counts_for_roundend = TRUE
	var/refunds_larva_if_banished = TRUE
	var/shaman_interactive = TRUE // whether shaman abilities affect this xeno
	var/can_hivemind_speak = TRUE

	// Tackles
	var/tackle_min = 2
	var/tackle_max = 6
	var/tackle_chance = 35
	var/tacklestrength_min = 2
	var/tacklestrength_max = 3

	var/last_hit_time = 0

	var/crit_grace_time = 1 SECONDS
	var/next_grace_time = 0

	//Amount of construction resources stored internally
	var/crystal_stored = 0
	var/crystal_max = 0

	var/evasion = 0   // RNG "Armor"

	// Armor
	var/armor_deflection = 10 // Most important: "max armor"
	var/armor_deflection_buff = 0 // temp buffs to armor
	var/armor_deflection_debuff = 0 //temp debuffs to armor
	var/armor_explosive_buff = 0  // temp buffs to explosive armor
	var/armor_integrity = 100     // Current health % of our armor
	var/armor_integrity_max = 100
	var/armor_integrity_last_damage_time = 0
	var/armor_integrity_immunity_time = 0
	var/pull_multiplier = 1.0
	var/aura_strength = 0 // Pheromone strength
	var/weed_level = WEED_LEVEL_STANDARD
	var/acid_level = 0

	// Mutator-related and other important vars
	var/mutation_type = null
	var/datum/mutator_set/individual_mutators/mutators = new

	// Hive-related vars
	var/datum/hive_status/hive
	hivenumber = XENO_HIVE_NORMAL
	var/hive_pos = NORMAL_XENO // The position of the xeno in the hive (0 = normal xeno; 1 = queen; 2+ = hive leader)

	// Variables that can be mutated
	var/ability_speed_modifier = 0.0 //Things that add on top of our base speed, based on what powers we are using

	// Progression-related
	var/age_prefix = ""
	var/age = 0  //This will track their age level. -1 means cannot age
	var/show_age_prefix = TRUE
	var/show_name_numbers = TRUE
	var/show_only_numbers = FALSE
	var/evolution_stored = 0 //How much evolution they have stored
	var/evolution_threshold = 200
	var/tier = 1 //This will track their "tier" to restrict/limit evolutions
	var/time_of_birth

	var/pslash_delay = 0

	var/hardcore = 0 //Set to 1 in New() when Whiskey Outpost is active. Prevents healing and queen evolution, deactivates dchat death messages

	//Naming variables
	var/caste_type = "Drone"
	var/nicknumber = 0 //The number after the name. Saved right here so it transfers between castes.
	var/full_designation = ""

	//This list of inherent verbs lets us take any proc basically anywhere and add them.
	//If they're not a xeno subtype it might crash or do weird things, like using human verb procs
	//It should add them properly on New() and should reset/readd them on evolves
	var/list/inherent_verbs = list()

	//Leader vars
	var/leader_aura_strength = 0 //Pheromone strength inherited from Queen
	var/leader_current_aura = "" //Pheromone type inherited from Queen

	/// List of actions (typepaths) that a
	/// xenomorph type is given upon spawn
	var/base_actions

	// Mark tracking --
	var/obj/effect/alien/resin/marker/tracked_marker = null //this is the resin mark that is currently being tracked by the xeno

	//////////////////////////////////////////////////////////////////
	//
	//		Modifiers
	//
	// 		These are used by strains/mutators to buff/debuff a xeno's
	//      stats. They can be mutated and are persistent between
	// 		upgrades, but not evolutions (which are just a new Xeno)
	// 		Strains that wish to change these should use the defines
	// 		in xeno_defines.dm, NOT snowflake values
	//
	//////////////////////////////////////////////////////////////////
	var/damage_modifier = 0
	var/health_modifier = 0
	var/armor_modifier = 0
	var/explosivearmor_modifier = 0
	var/plasmapool_modifier = 1
	var/plasmagain_modifier = 0
	var/tackle_chance_modifier = 0
	var/regeneration_multiplier = 1
	var/speed_modifier = 0
	var/phero_modifier = 0
	var/acid_modifier = 0
	var/weed_modifier = 0
	var/evasion_modifier = 0
	var/attack_speed_modifier = 0
	var/armor_integrity_modifier = 0

	var/list/modifier_sources

	//////////////////////////////////////////////////////////////////
	//
	//		Intrinsic State - well-ish modularized
	//
	// 		State used by all Xeno mobs.
	//
	//////////////////////////////////////////////////////////////////
	var/xeno_mobhud = FALSE //whether the xeno mobhud is activated or not.
	var/xeno_hostile_hud = FALSE // 'Hostile' HUD - the verb Xenos use to see tags, etc on humans
	var/list/plasma_types = list() //The types of plasma the caste contains
	var/list/xeno_shields = list() // List of /datum/xeno_shield that holds all active shields on the Xeno.
	var/acid_splash_cooldown = 5 SECONDS //Time it takes between acid splash retaliate procs
	var/acid_splash_last //Last recorded time that an acid splash procced
	var/interference = 0 // Stagger for predator weapons. Prevents hivemind usage, queen overwatching, etc.
	var/mob/living/carbon/Xenomorph/observed_xeno // Overwatched xeno for xeno hivemind vision
	var/need_weeds = TRUE // Do we need weeds to regen HP?
	var/datum/behavior_delegate/behavior_delegate = null // Holds behavior delegate. Governs all 'unique' hooked behavior of the Xeno. Set by caste datums and strains.
	var/datum/action/xeno_action/activable/selected_ability // Our currently selected ability
	var/datum/action/xeno_action/activable/queued_action // Action to perform on the next click.
	var/is_zoomed = FALSE
	var/tileoffset = 0 // Zooming-out related vars
	var/viewsize = 0
	var/banished = FALSE // Banished xenos can be attacked by all other xenos
	var/lock_evolve = FALSE //Prevents evolve/devolve (used when banished)
	var/list/tackle_counter
	var/evolving = FALSE // Whether the xeno is in the process of evolving
	/// The damage dealt by a xeno whenever they take damage near someone
	var/acid_blood_damage = 25
	var/nocrit = FALSE
	var/deselect_timer = 0 // Much like Carbon.last_special is a short tick record to prevent accidental deselects of abilities

	var/pounce_distance = 0


	//////////////////////////////////////////////////////////////////
	//
	//		Misc. State - poorly modularized
	//
	// 		This is a messy section comprising state that really shouldn't
	//      exist on the base Xeno type, but is anyway due to the messy
	//  	way the game's interaction system was architected.
	//		Suffice it to say, the alternative to storing all this here
	// 		is a bunch of messy typecasts and/or snowflake checks in many, many procs
	// 		affected integrally by this state, instead of being defined in
	// 		an easily modularizable way. So, here you go.
	//
	//////////////////////////////////////////////////////////////////
	var/weedwalking_activated = 0 //Hivelord's weedwalking
	var/tunnel = 0
	var/burrow = 0
	var/fortify = 0
	var/crest_defense = 0
	var/agility = 0		// 0 - upright, 1 - all fours
	var/ripping_limb = 0
	// Related to zooming out (primarily queen and boiler)
	var/devour_timer = 0 // The world.time at which we will regurgitate our currently-vored victim
	var/extra_build_dist = 0 // For drones/hivelords. Extends the maximum build range they have
	var/can_stack_builds = FALSE
	var/list/resin_build_order
	var/selected_resin // Which resin structure to build when we secrete resin, defaults to null.
	var/selected_construction = XENO_STRUCTURE_CORE //which special structure to build when we place constructions
	var/selected_mark // If leader what mark you will place when you make one
	var/datum/ammo/xeno/ammo = null //The ammo datum for our spit projectiles. We're born with this, it changes sometimes.
	var/tunnel_delay = 0
	var/steelcrest = FALSE
	var/list/available_fruits = list() // List of placeable the xenomorph has access to.
	var/list/current_fruits = list() // If we have current_fruits that are limited, e.g. fruits
	var/max_placeable = 0 // Limit to that amount
	var/obj/effect/alien/resin/fruit/selected_fruit = null // the typepath of the placeable we wanna put down
	var/list/built_structures = list()

	var/icon_xeno
	var/icon_xenonid

	/////////////////////////////////////////////////////////////////////
	//
	//		Phero related vars
	//
	//////////////////////////////////////////////////////////////////
	var/ignores_pheromones = FALSE // title, ignores ALL pheros
	var/current_aura = null //"claw", "armor", "regen", "speed"
	var/frenzy_new = 0 // Tally vars used in Xeno Life() for Pheromones
	var/warding_new = 0
	var/recovery_new = 0
	var/frenzy_aura = 0 //Strength of aura we are affected by. NOT THE ONE WE ARE EMITTING
	var/warding_aura = 0
	var/recovery_aura = 0
	var/ignore_aura = FALSE // ignore a specific pherom, input type


	//////////////////////////////////////////////////////////////////
	//
	//		Vars that should be deleted
	//
	//////////////////////////////////////////////////////////////////
	var/burrow_timer = 200
	var/tunnel_timer = 20

	//Burrower Vars
	var/used_tremor = 0
	// Defender vars
	var/used_headbutt = 0
	var/used_fortify = 0
	// Burrowers
	var/used_burrow = 0
	var/used_tunnel = 0

	//Carrier vars
	var/threw_a_hugger = 0
	var/huggers_cur = 0
	var/eggs_cur = 0
	var/huggers_max = 0
	var/eggs_max = 0
	var/laid_egg = 0

	//Taken from update_icon for all xeno's
	var/list/overlays_standing[X_TOTAL_LAYERS]

	var/atom/movable/vis_obj/xeno_wounds/wound_icon_carrier

/mob/living/carbon/Xenomorph/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	var/area/A = get_area(src)
	if(A && A.statistic_exempt)
		statistic_exempt = TRUE

	wound_icon_carrier = new(null, src)
	vis_contents += wound_icon_carrier

	if(oldXeno)
		hivenumber = oldXeno.hivenumber
		nicknumber = oldXeno.nicknumber
		life_kills_total = oldXeno.life_kills_total
		life_damage_taken_total = oldXeno.life_damage_taken_total
		if(oldXeno.iff_tag)
			iff_tag = oldXeno.iff_tag
			iff_tag.forceMove(src)
			oldXeno.iff_tag = null
	else if (h_number)
		hivenumber = h_number

	set_languages(list(LANGUAGE_XENOMORPH, LANGUAGE_HIVEMIND))
	if(oldXeno)
		for(var/datum/language/L in oldXeno.languages)
			add_language(L.name)//Make sure to keep languages (mostly for event Queens that know English)

	// Well, not yet, technically
	var/datum/hive_status/in_hive = GLOB.hive_datum[hivenumber]
	if(in_hive)
		in_hive.add_xeno(src)
		// But now we are!

	for(var/T in in_hive.hive_inherant_traits)
		ADD_TRAIT(src, T, TRAIT_SOURCE_HIVE)

	mutators.xeno = src

	update_icon_source()

	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]
	else
		to_world("something went very wrong")
		return

	acid_splash_cooldown = caste.acid_splash_cooldown

	if (caste.fire_immunity != FIRE_IMMUNITY_NONE)
		if(caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE)
			RegisterSignal(src, COMSIG_LIVING_PREIGNITION, .proc/fire_immune)
		RegisterSignal(src, list(
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		), .proc/flamer_crossed_immune)
	else
		UnregisterSignal(src, list(
			COMSIG_LIVING_PREIGNITION,
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		))

	recalculate_everything()

	if(mob_size < MOB_SIZE_BIG)
		mob_flags |= SQUEEZE_UNDER_VEHICLES

	generate_name()

	if(isXenoQueen(src))
		SStracking.set_leader("hive_[hivenumber]", src)
	SStracking.start_tracking("hive_[hivenumber]", src)

	. = ..()
	//WO GAMEMODE
	if(SSticker?.mode?.hardcore)
		hardcore = 1 //Prevents healing and queen evolution
	time_of_birth = world.time

	add_inherent_verbs()
	add_abilities()
	recalculate_actions()

	sight |= SEE_MOBS
	see_invisible = SEE_INVISIBLE_LIVING
	see_in_dark = 12
	if(client)
		set_lighting_alpha_from_prefs(client)
	else
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

	if(caste && caste.spit_types && caste.spit_types.len)
		ammo = GLOB.ammo_list[caste.spit_types[1]]

	create_reagents(100)

	GLOB.living_xeno_list += src
	GLOB.xeno_mob_list += src

	if(caste && caste.adjust_size_x != 1)
		var/matrix/M = matrix()
		M.Scale(caste.adjust_size_x, caste.adjust_size_y)
		apply_transform(M)

	if(caste)
		behavior_delegate = new caste.behavior_delegate_type()
		behavior_delegate.bound_xeno = src
		behavior_delegate.add_to_xeno()
		resin_build_order = caste.resin_build_order
	else
		CRASH("Xenomorph [src] has no caste datum! Tell the devs!")

	regenerate_icons()
	toggle_xeno_mobhud() //This is a verb, but fuck it, it just werks
	toggle_xeno_hostilehud()

	if(oldXeno)
		a_intent_change(oldXeno.a_intent)//Keep intent

		if(oldXeno.layer == XENO_HIDING_LAYER)
			//We are hiding, let's keep hiding if we can!
			for(var/datum/action/xeno_action/onclick/xenohide/hide in actions)
				if(istype(hide))
					layer = XENO_HIDING_LAYER
					hide.button.icon_state = "template_active"

		for(var/obj/item/W in oldXeno.contents) //Drop stuff
			oldXeno.drop_inv_item_on_ground(W)

		oldXeno.empty_gut()

		if(IS_XENO_LEADER(oldXeno))
			hive.replace_hive_leader(oldXeno, src)

	// Only handle free slots if the xeno is not in tdome
	if(!is_admin_level(z))
		var/selected_caste = GLOB.xeno_datum_list[caste_type]?.type
		var/free_slots = LAZYACCESS(hive.free_slots, selected_caste)
		if(free_slots)
			hive.free_slots[selected_caste]--
			var/new_val = LAZYACCESS(hive.used_free_slots, selected_caste) + 1
			LAZYSET(hive.used_free_slots, selected_caste, new_val)

	if(round_statistics && !statistic_exempt)
		round_statistics.track_new_participant(faction, 1)
	generate_name()

	// This can happen if a xeno gets made before the game starts
	if (hive && hive.hive_ui)
		hive.hive_ui.update_all_xeno_data()

	job = caste.caste_type // Used for tracking the caste playtime

	RegisterSignal(src, COMSIG_MOB_SCREECH_ACT, .proc/handle_screech_act)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_XENO_SPAWN, src)

/mob/living/carbon/Xenomorph/proc/handle_screech_act(var/mob/self, var/mob/living/carbon/Xenomorph/Queen/queen)
	SIGNAL_HANDLER
	if(queen.can_not_harm(src))
		return COMPONENT_SCREECH_ACT_CANCEL



/mob/living/carbon/Xenomorph/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_IS_XENO
		PF.flags_can_pass_all = PASS_MOB_THRU_XENO|PASS_AROUND|PASS_HIGH_OVER_ONLY

/mob/living/carbon/Xenomorph/initialize_pain()
	pain = new /datum/pain/xeno(src)

/mob/living/carbon/Xenomorph/initialize_stamina()
	stamina = new /datum/stamina/none(src)

/mob/living/carbon/Xenomorph/proc/fire_immune(mob/living/L)
	SIGNAL_HANDLER

	if(L.fire_reagent?.fire_penetrating && !burrow)
		return

	return COMPONENT_CANCEL_IGNITION

/mob/living/carbon/Xenomorph/proc/flamer_crossed_immune(mob/living/L, datum/reagent/R)
	SIGNAL_HANDLER

	if(R.fire_penetrating)
		return

	. = COMPONENT_NO_BURN
	// Burrowed xenos also cannot be ignited
	if((caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE) || burrow)
		. |= COMPONENT_NO_IGNITE
	if(caste.fire_immunity & FIRE_IMMUNITY_XENO_FRENZY)
		. |= COMPONENT_XENO_FRENZY

//Off-load this proc so it can be called freely
//Since Xenos change names like they change shoes, we need somewhere to hammer in all those legos
//We set their name first, then update their real_name AND their mind name
/mob/living/carbon/Xenomorph/proc/generate_name()
	//We don't have a nicknumber yet, assign one to stick with us
	if(!nicknumber)
		var/tempnumber = rand(1, 999)
		var/list/numberlist = list()
		for(var/mob/living/carbon/Xenomorph/X in GLOB.xeno_mob_list)
			numberlist += X.nicknumber

		while(tempnumber in numberlist)
			tempnumber = rand(1, 999)

		nicknumber = tempnumber

	// Even if we don't have the hive datum we usually still have the hive number
	var/datum/hive_status/in_hive = hive
	if(!in_hive)
		in_hive = GLOB.hive_datum[hivenumber]

	//Im putting this in here, because this proc gets called when a player inhabits a SSD xeno and it needs to go somewhere (sorry)
	hud_set_marks()

	handle_name(in_hive)

/mob/living/carbon/Xenomorph/proc/handle_name(var/datum/hive_status/in_hive)
	var/name_prefix = in_hive.prefix
	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
		age_xeno()
	full_designation = "[name_client_prefix][nicknumber][name_client_postfix]"
	color = in_hive.color

	var/age_display = show_age_prefix ? age_prefix : ""
	var/name_display = ""
	if(show_name_numbers)
		name_display = show_only_numbers ? " ([nicknumber])" : " ([name_client_prefix][nicknumber][name_client_postfix])"
	name = "[name_prefix][age_display][caste.display_name || caste.caste_type][name_display]"

	//Update linked data so they show up properly
	change_real_name(src, name)

	// Since we updated our name we should update the info in the UI
	in_hive.hive_ui.update_xeno_info()

/mob/living/carbon/Xenomorph/proc/set_lighting_alpha_from_prefs(var/client/xeno_client)
	var/vision_level = xeno_client?.prefs?.xeno_vision_level_pref
	switch(vision_level)
		if(XENO_VISION_LEVEL_NO_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		if(XENO_VISION_LEVEL_MID_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if(XENO_VISION_LEVEL_FULL_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	update_sight()
	if(hud_used)
		var/atom/movable/screen/xenonightvision/screenobj = (locate() in hud_used.infodisplay)
		screenobj.update_icon(src)

/mob/living/carbon/Xenomorph/proc/set_lighting_alpha(var/level)
	switch(level)
		if(XENO_VISION_LEVEL_NO_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		if(XENO_VISION_LEVEL_MID_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if(XENO_VISION_LEVEL_FULL_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	update_sight()
	var/atom/movable/screen/xenonightvision/screenobj = (locate() in hud_used.infodisplay)
	screenobj.update_icon(src)

/mob/living/carbon/Xenomorph/proc/get_vision_level()
	switch(lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_INVISIBLE)
			return XENO_VISION_LEVEL_FULL_NVG
		if(LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			return XENO_VISION_LEVEL_MID_NVG
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			return XENO_VISION_LEVEL_NO_NVG

/mob/living/carbon/Xenomorph/get_examine_text(mob/user)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_SIMPLE_DESC))
		return list(desc)

	if(isXeno(user) && caste && caste.caste_desc)
		. += caste.caste_desc

	if(l_hand)
		. += "It's holding[l_hand.get_examine_line(user)] in its left hand."

	if(r_hand)
		. += "It's holding[r_hand.get_examine_line(user)] in its right hand."

	if(stat == DEAD)
		. += "It is DEAD. Kicked the bucket. Off to that great hive in the sky."
	else if(stat == UNCONSCIOUS)
		. += "It quivers a bit, but barely moves."
	else
		var/percent = (health / maxHealth * 100)
		switch(percent)
			if(95 to 101)
				. += "It looks quite healthy."
			if(75 to 94)
				. += "It looks slightly injured."
			if(50 to 74)
				. += "It looks injured."
			if(25 to 49)
				. += "It bleeds with sizzling wounds."
			if(1 to 24)
				. += "It is heavily injured and limping badly."

	if(isXeno(user))
		var/mob/living/carbon/Xenomorph/xeno = user
		if(hivenumber != xeno.hivenumber)
			. += "It appears to belong to [hive?.prefix ? "the [hive.prefix]" : "a different "]hive."

	if(isXeno(user) || isobserver(user))
		if(mutation_type != "Normal")
			. += "It has specialized into a [mutation_type]."

	if(iff_tag)
		. += SPAN_NOTICE("It has an IFF tag sticking out of its carapace.")

/mob/living/carbon/Xenomorph/Destroy()
	GLOB.living_xeno_list -= src
	GLOB.xeno_mob_list -= src

	if(mind)
		mind.name = name //Grabs the name when the xeno is getting deleted, to reference through hive status later.
	if(IS_XENO_LEADER(src)) //Strip them from the Xeno leader list, if they are indexed in here
		hive.remove_hive_leader(src, light_mode = TRUE)
	SStracking.stop_tracking("hive_[hivenumber]", src)

	// Only handle free slots if the xeno is not in tdome
	if(!is_admin_level(z))
		var/selected_caste = GLOB.xeno_datum_list[caste_type]?.type
		var/used_slots = LAZYACCESS(hive.used_free_slots, selected_caste)
		if(used_slots)
			hive.used_free_slots[selected_caste]--
			var/new_val = LAZYACCESS(hive.free_slots, selected_caste) + 1
			LAZYSET(hive.free_slots, selected_caste, new_val)

	hive.remove_xeno(src)
	remove_from_all_mob_huds()

	observed_xeno = null
	wear_suit = null
	head = null
	r_store = null
	l_store = null
	ammo = null
	selected_ability = null
	queued_action = null

	QDEL_NULL(mutators)
	QDEL_NULL(behavior_delegate)

	built_structures = null

	vis_contents -= wound_icon_carrier
	QDEL_NULL(wound_icon_carrier)

	QDEL_NULL(iff_tag)

	if(hardcore)
		attack_log?.Cut() // Completely clear out attack_log to limit mem usage if we fail to delete

	. = ..()

	// Everything below fits the "we have to clear by principle it but i dont wanna break stuff" bill
	mutators = null



/mob/living/carbon/Xenomorph/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	return FALSE



/mob/living/carbon/Xenomorph/start_pulling(atom/movable/AM, lunge, no_msg)
	if(SEND_SIGNAL(AM, COMSIG_MOVABLE_XENO_START_PULLING, src) & COMPONENT_ALLOW_PULL)
		return do_pull(AM, lunge, no_msg)

	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	if(isSynth(L) && L.health < 0) // no pulling critted or dead synths
		return FALSE
	if(L.buckled)
		return FALSE //to stop xeno from pulling marines on roller beds.
	if(!L.is_xeno_grabbable())
		return FALSE
	var/atom/A = AM.handle_barriers(src)
	if(A != AM)
		A.attack_alien(src)
		xeno_attack_delay(src)
		return FALSE
	return ..()

/mob/living/carbon/Xenomorph/pull_response(mob/puller)
	if(stat != DEAD && has_species(puller,"Human")) // If the Xeno is alive, fight back against a grab/pull
		var/mob/living/carbon/human/H = puller
		if(H.ally_of_hivenumber(hivenumber))
			return TRUE
		puller.KnockDown(rand(caste.tacklestrength_min,caste.tacklestrength_max))
		playsound(puller.loc, 'sound/weapons/pierce.ogg', 25, 1)
		puller.visible_message(SPAN_WARNING("[puller] tried to pull [src] but instead gets a tail swipe to the head!"))
		return FALSE
	return TRUE

/mob/living/carbon/Xenomorph/resist_grab(moving_resist)
	if(!pulledby)
		return
	if(pulledby.grab_level)
		visible_message(SPAN_DANGER("[src] has broken free of [pulledby]'s grip!"), null, null, 5)
	pulledby.stop_pulling()
	. = 1



/mob/living/carbon/Xenomorph/prepare_huds()
	..()
	//updating all the mob's hud images
	med_hud_set_health()
	med_hud_set_armor()
	hud_set_plasma()
	hud_set_pheromone()
	hud_set_marks()


	//and display them
	add_to_all_mob_huds()
	var/datum/mob_hud/MH = huds[MOB_HUD_XENO_INFECTION]
	MH.add_hud_to(src)


/mob/living/carbon/Xenomorph/check_improved_pointing()
	//xeno leaders get a big arrow and less cooldown
	if(hive_pos != NORMAL_XENO)
		return TRUE

///get_eye_protection()
///Returns a number between -1 to 2
/mob/living/carbon/Xenomorph/get_eye_protection()
	return 2

/mob/living/carbon/Xenomorph/get_pull_miltiplier()
	return pull_multiplier

/mob/living/carbon/Xenomorph/proc/set_faction(var/new_faction = FACTION_XENOMORPH)
	faction = new_faction

//Call this function to set the hive and do other cleanup
/mob/living/carbon/Xenomorph/proc/set_hive_and_update(var/new_hivenumber = XENO_HIVE_NORMAL)
	var/datum/hive_status/new_hive = GLOB.hive_datum[new_hivenumber]
	if(!new_hive)
		return

	for(var/T in status_traits)
		REMOVE_TRAIT(src, T, TRAIT_SOURCE_HIVE)

	new_hive.add_xeno(src)

	for(var/T in new_hive.hive_inherant_traits)
		ADD_TRAIT(src, T, TRAIT_SOURCE_HIVE)

	if(istype(src, /mob/living/carbon/Xenomorph/Larva))
		var/mob/living/carbon/Xenomorph/Larva/L = src
		L.update_icons() // larva renaming done differently
	else
		generate_name()
	if(istype(src, /mob/living/carbon/Xenomorph/Queen))
		update_living_queens()

	lock_evolve = FALSE
	banished = FALSE
	hud_update_banished()

	recalculate_everything()

	// Update the hive status UI
	new_hive.hive_ui.update_all_xeno_data()

//*********************************************************//
//********************Mutator functions********************//
//*********************************************************//

//Call this function when major changes happen - evolutions, upgrades, mutators getting removed
/mob/living/carbon/Xenomorph/proc/recalculate_everything()
	recalculate_stats()
	recalculate_actions()
	recalculate_pheromones()
	recalculate_maturation()
	update_icon_source()
	if(hive && hive.living_xeno_queen && hive.living_xeno_queen == src)
		hive.recalculate_hive() //Recalculating stuff around Queen maturing


/mob/living/carbon/Xenomorph/proc/recalculate_stats()
	recalculate_health()
	recalculate_plasma()
	recalculate_stockpile()
	recalculate_speed()
	recalculate_armor()
	recalculate_damage()
	recalculate_evasion()
	recalculate_tackle()

/mob/living/carbon/Xenomorph/proc/recalculate_tackle()
	tackle_min = caste.tackle_min
	tackle_max = caste.tackle_max
	tackle_chance = caste.tackle_chance + tackle_chance_modifier
	tacklestrength_min = caste.tacklestrength_min + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus
	tacklestrength_max = caste.tacklestrength_max + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus

/mob/living/carbon/Xenomorph/proc/recalculate_health()
	var/new_max_health = nocrit ? health_modifier + maxHealth : health_modifier + caste.max_health
	if (new_max_health == maxHealth)
		return
	var/currentHealthRatio = 1
	if(health < maxHealth)
		currentHealthRatio = health / maxHealth
	maxHealth = new_max_health
	health = round(maxHealth * currentHealthRatio + 0.5)//Restore our health ratio, so if we're full, we continue to be full, etc. Rounding up (hence the +0.5)
	if(health > maxHealth)
		health = maxHealth

/mob/living/carbon/Xenomorph/proc/recalculate_plasma()
	if(!plasma_max)
		return

	var/new_plasma_max = plasmapool_modifier * caste.plasma_max
	plasma_gain = plasmagain_modifier + caste.plasma_gain
	if (new_plasma_max == plasma_max)
		return
	var/plasma_ratio = plasma_stored / plasma_max
	plasma_max = new_plasma_max
	plasma_stored = round(plasma_max * plasma_ratio + 0.5) //Restore our plasma ratio, so if we're full, we continue to be full, etc. Rounding up (hence the +0.5)
	if(plasma_stored > plasma_max)
		plasma_stored = plasma_max

/mob/living/carbon/Xenomorph/proc/recalculate_stockpile()
	crystal_max = caste.crystal_max
	if(crystal_stored > crystal_max)
		crystal_stored = crystal_max

/mob/living/carbon/Xenomorph/proc/recalculate_speed()
	recalculate_move_delay = TRUE
	speed = speed_modifier
	if(caste)
		speed += caste.speed
	SEND_SIGNAL(src, COMSIG_XENO_RECALCULATE_SPEED)

/mob/living/carbon/Xenomorph/proc/recalculate_armor()
	//We are calculating it in a roundabout way not to give anyone 100% armor deflection, so we're dividing the differences
	armor_deflection = armor_modifier + round(100 - (100 - caste.armor_deflection))
	armor_explosive_buff = explosivearmor_modifier

/mob/living/carbon/Xenomorph/proc/recalculate_damage()
	melee_damage_lower = damage_modifier
	melee_damage_upper = damage_modifier
	melee_vehicle_damage = damage_modifier
	if(caste)
		melee_damage_lower += caste.melee_damage_lower
		melee_damage_upper += caste.melee_damage_upper
		melee_vehicle_damage += caste.melee_vehicle_damage

/mob/living/carbon/Xenomorph/proc/recalculate_evasion()
	if(caste)
		evasion = evasion_modifier + caste.evasion

/mob/living/carbon/Xenomorph/proc/recalculate_actions()
	recalculate_acid()
	recalculate_weeds()
	pull_multiplier = mutators.pull_multiplier
	if(isXenoRunner(src))
		//Xeno runners need a small nerf to dragging speed mutator
		pull_multiplier = 1.0 - (1.0 - mutators.pull_multiplier) * 0.85
		if(is_zoomed)
			zoom_out()
	if(isXenoCarrier(src))
		huggers_max = caste.huggers_max
		eggs_max = caste.eggs_max
	need_weeds = mutators.need_weeds


/mob/living/carbon/Xenomorph/proc/recalculate_acid()
	if(caste)
		acid_level = caste.acid_level
	if(acid_level == 0)
		return //Caste does not use acid
	for(var/datum/action/xeno_action/activable/corrosive_acid/acid in actions)
		if(istype(acid))
			acid_level = caste.acid_level + acid_modifier
			if(acid_level > 3)
				acid_level = 3
			if(acid.level == acid_level)
				return //nothing to update, we're at the same level
			else
				//We are setting the new acid level and updating our action
				acid.level = acid_level
				acid.update_level()

/mob/living/carbon/Xenomorph/proc/recalculate_weeds()
	if(!caste || caste.weed_level == 0)
		return //Caste does not use weeds
	weed_level = caste.weed_level + weed_modifier
	if(weed_level < WEED_LEVEL_STANDARD)
		weed_level = WEED_LEVEL_STANDARD//need to maintain the minimum in case something goes really wrong

/mob/living/carbon/Xenomorph/proc/recalculate_pheromones()
	if(caste.aura_strength > 0)
		aura_strength = caste.aura_strength + phero_modifier
	else
		caste.aura_strength = 0
	if(aura_strength == 0 && current_aura)
		current_aura = null
		to_chat(src, SPAN_XENOWARNING("You lose your pheromones."))


/mob/living/carbon/Xenomorph/proc/recalculate_maturation()
	evolution_threshold =  caste.evolution_threshold

/mob/living/carbon/Xenomorph/rejuvenate()
	if(stat == DEAD && !QDELETED(src))
		GLOB.living_xeno_list += src

		if(hive)
			hive.add_xeno(src)
			hive.hive_ui.update_all_xeno_data()

	armor_integrity = 100
	UnregisterSignal(src, COMSIG_XENO_PRE_HEAL)
	..()
	hud_update()
	plasma_stored = plasma_max
	for(var/datum/action/xeno_action/XA in actions)
		XA.end_cooldown()

/mob/living/carbon/Xenomorph/resist_fire()
	adjust_fire_stacks(XENO_FIRE_RESIST_AMOUNT, min_stacks = 0)
	KnockDown(4, TRUE)
	visible_message(SPAN_DANGER("[src] rolls on the floor, trying to put themselves out!"), \
		SPAN_NOTICE("You stop, drop, and roll!"), null, 5)

	if(istype(get_turf(src), /turf/open/gm/river))
		ExtinguishMob()

	if(fire_stacks > 0)
		return

	visible_message(SPAN_DANGER("[src] has successfully extinguished themselves!"), \
		SPAN_NOTICE("You extinguish yourself."), null, 5)

/mob/living/carbon/Xenomorph/resist_restraints()
	var/breakouttime = legcuffed.breakouttime

	next_move = world.time + 100
	last_special = world.time + 10

	var/displaytime = max(1, round(breakouttime / 600)) //Minutes
	to_chat(src, SPAN_WARNING("You attempt to remove [legcuffed]. (This will take around [displaytime] minute(s) and you need to stand still)"))
	for(var/mob/O in viewers(src))
		O.show_message(SPAN_DANGER("<B>[usr] attempts to remove [legcuffed]!</B>"), 1)
	if(!do_after(src, breakouttime, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
		return
	if(!legcuffed || buckled)
		return // time leniency for lag which also might make this whole thing pointless but the server
	for(var/mob/O in viewers(src))//                                         lags so hard that 40s isn't lenient enough - Quarxink
		O.show_message(SPAN_DANGER("<B>[src] manages to remove [legcuffed]!</B>"), 1)
	to_chat(src, SPAN_NOTICE(" You successfully remove [legcuffed]."))
	drop_inv_item_on_ground(legcuffed)

/mob/living/carbon/Xenomorph/IgniteMob()
	. = ..()
	if (. & IGNITE_IGNITED)
		RegisterSignal(src, COMSIG_XENO_PRE_HEAL, .proc/cancel_heal)
		if(!caste || !(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE) || fire_reagent.fire_penetrating)
			INVOKE_ASYNC(src, /mob.proc/emote, "roar")

/mob/living/carbon/Xenomorph/ExtinguishMob()
	. = ..()
	if (.)
		UnregisterSignal(src, COMSIG_XENO_PRE_HEAL)

/mob/living/carbon/Xenomorph/proc/cancel_heal()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_XENO_HEAL

/mob/living/carbon/Xenomorph/proc/set_resin_build_order(var/list/build_order)
	resin_build_order = build_order
	if(length(resin_build_order))
		selected_resin = resin_build_order[1]

/mob/living/carbon/Xenomorph/ghostize(can_reenter_corpse = TRUE)
	. = ..()
	if(. && !can_reenter_corpse && stat != DEAD && !QDELETED(src) && !is_admin_level(z))
		handle_ghost_message()

/mob/living/carbon/Xenomorph/proc/handle_ghost_message()
	announce_dchat("[src] ([mutation_type] [caste_type])</b> has ghosted and their body is up for grabs!", src)

/mob/living/carbon/Xenomorph/Larva/handle_ghost_message()
	if(locate(/obj/effect/alien/resin/special/pool) in range(2, get_turf(src)))
		return
	return ..()

/mob/living/carbon/Xenomorph/handle_blood_splatter(var/splatter_dir)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(loc, splatter_dir)
