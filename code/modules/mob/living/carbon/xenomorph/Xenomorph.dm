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

	if(!ticker || ticker.current_state != GAME_STATE_PLAYING || !ticker.mode)
		to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished."))
		return
	if(mind in ticker.mode.xenomorphs)
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
	see_in_dark = 8
	recovery_constant = 1.5
	see_invisible = SEE_INVISIBLE_MINIMUM
	hud_possible = list(HEALTH_HUD_XENO, PLASMA_HUD, PHEROMONE_HUD, QUEEN_OVERWATCH_HUD, ARMOR_HUD_XENO, XENO_STATUS_HUD, XENO_BANISHED_HUD, XENO_HOSTILE_ACID, XENO_HOSTILE_SLOW, XENO_HOSTILE_TAG, XENO_HOSTILE_FREEZE)
	unacidable = TRUE
	rebounds = TRUE
	faction = FACTION_XENOMORPH
	gender = NEUTER
	var/icon_size = 48
	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/head/head = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null

	//////////////////////////////////////////////////////////////////
	//
	//		Core Stats
	//
	// 		Self-Explanatory.
	//
	//////////////////////////////////////////////////////////////////
	var/datum/caste_datum/caste // Used to extract determine ALL Xeno stats.
	health = 5
	maxHealth = 5
	var/crit_health = -100 // What negative healthy they die in.
	var/gib_chance  = 5 // % chance of them exploding when taking damage. Goes up with damage inflicted.
	speed = -0.5 // Speed. Positive makes you go slower. (1.5 is equivalent to FAT mutation)
	melee_damage_lower = 5
	melee_damage_upper = 10
	var/claw_type = CLAW_TYPE_NORMAL
	var/burn_damage_lower = 0
	var/burn_damage_upper = 0
	var/plasma_stored = 10
	var/plasma_max = 10
	var/plasma_gain = 5

	var/small_explosives_stun = TRUE // Have to put this here, otherwise it can't be strain specific

	// Tackles
	var/tackle_min = 2
	var/tackle_max = 6
	var/tackle_chance = 35
	var/tacklestrength_min = 2
	var/tacklestrength_max = 3

	var/last_hit_time = 0

	//Amount of construction resources stored internally
	var/crystal_stored = 0
	var/crystal_max = 0

	var/evasion = 0   // RNG "Armor"

	// Armor
	var/armor_deflection = 10 // Most important: "max armor"
	var/armor_deflection_buff = 0 // temp buffs to armor
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
	var/age_threshold = 1000
	var/age_stored = 0 //How much age points they have stored.
	var/age = 0  //This will track their age level. -1 means cannot age
	var/max_grown = 200
	var/evolution_stored = 0 //How much evolution they have stored
	var/evolution_threshold = 200
	var/tier = 1 //This will track their "tier" to restrict/limit evolutions
	var/amount_grown = 0 // for some fucking reason larva use their own variable here, who knows why
	var/time_of_birth

	var/pslash_delay = 0

	var/hardcore = 0 //Set to 1 in New() when Whiskey Outpost is active. Prevents healing and queen evolution

	//Naming variables
	var/caste_name = "Drone"
	var/nicknumber = 0 //The number after the name. Saved right here so it transfers between castes.

	//This list of inherent verbs lets us take any proc basically anywhere and add them.
	//If they're not a xeno subtype it might crash or do weird things, like using human verb procs
	//It should add them properly on New() and should reset/readd them on evolves
	var/list/inherent_verbs = list()

	//Leader vars
	var/leader_aura_strength = 0 //Pheromone strength inherited from Queen
	var/leader_current_aura = "" //Pheromone type inherited from Queen

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
	var/speed_modifier = 0
	var/phero_modifier = 0
	var/acid_modifier = 0
	var/weed_modifier = 0
	var/evasion_modifier = 0
	var/attack_speed_modifier = 0
	var/armor_integrity_modifier = 0

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
	var/acid_splash_cooldown = SECONDS_5 //Time it takes between acid splash retaliate procs
	var/acid_splash_last //Last recorded time that an acid splash procced
	var/interference = 0 // Stagger for predator weapons. Prevents hivemind usage, queen overwatching, etc.
	var/mob/living/carbon/Xenomorph/observed_xeno // Overwatched xeno for xeno hivemind vision
	var/need_weeds = TRUE // Do we need weeds to regen HP?
	var/datum/behavior_delegate/behavior_delegate = null // Holds behavior delegate. Governs all 'unique' hooked behavior of the Xeno. Set by caste datums and strains.
	var/current_aura = null //"claw", "armor", "regen", "speed"
	var/frenzy_new = 0 // Tally vars used in Xeno Life() for Pheromones
	var/warding_new = 0
	var/recovery_new = 0
	var/frenzy_aura = 0 //Strength of aura we are affected by. NOT THE ONE WE ARE EMITTING
	var/warding_aura = 0
	var/recovery_aura = 0
	var/datum/action/xeno_action/activable/selected_ability // Our currently selected ability
	var/datum/action/xeno_action/activable/queued_action // Action to perform on the next click.
	var/ignores_pheromones = FALSE // title
	var/is_zoomed = FALSE
	var/tileoffset = 0 // Zooming-out related vars
	var/viewsize = 0
	var/banished = FALSE // Banished xenos can be attacked by all other xenos
	var/list/tackle_counter = list()


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
	var/list/resin_build_order
	var/selected_resin = 1 // Which resin structure to build when we secrete resin, defaults to 1 (first element)
	var/selected_construction = XENO_STRUCTURE_CORE //which special structure to build when we place constructions
	var/datum/ammo/xeno/ammo = null //The ammo datum for our spit projectiles. We're born with this, it changes sometimes.
	var/obj/structure/tunnel/start_dig = null
	var/tunnel_delay = 0
	var/spiked = FALSE


	//////////////////////////////////////////////////////////////////
	//
	//		Vars that should be deleted
	//
	//////////////////////////////////////////////////////////////////
	var/burrow_timer = 200
	var/tunnel_timer = 20

	///// BELOW HERE LIE COOLDOWN VARS
	var/has_spat = 0
	var/has_screeched = 0
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

/mob/living/carbon/Xenomorph/Initialize(var/new_loc, var/mob/living/carbon/Xenomorph/oldXeno, var/h_number)
	var/area/A = get_area(src)
	if(A && A.statistic_exempt)
		statistic_exempt = TRUE
	if(oldXeno)
		hivenumber = oldXeno.hivenumber
		nicknumber = oldXeno.nicknumber
	else if (h_number)
		hivenumber = h_number

	// Well, not yet, technically
	var/datum/hive_status/in_hive = hive_datum[hivenumber]
	if(in_hive)
		in_hive.add_xeno(src)
		// But now we are!

	mutators.xeno = src

	update_caste()
	generate_name()

	if(isXenoQueen(src))
		SStracking.set_leader("hive_[hivenumber]", src)
	SStracking.start_tracking("hive_[hivenumber]", src)

	..(new_loc)
	//WO GAMEMODE
	if(map_tag == MAP_WHISKEY_OUTPOST)
		hardcore = 1 //Prevents healing and queen evolution
	time_of_birth = world.time

	set_languages(list("Xenomorph", "Hivemind"))
	if(oldXeno)
		for(var/datum/language/L in oldXeno.languages)
			add_language(L.name)//Make sure to keep languages (mostly for event Queens that know English)

	add_inherent_verbs()
	add_abilities()
	recalculate_actions()

	sight |= SEE_MOBS
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 8

	if(caste && caste.spit_types && caste.spit_types.len)
		ammo = ammo_list[caste.spit_types[1]]

	create_reagents(100)

	living_xeno_list += src
	xeno_mob_list += src

	if(caste && caste.adjust_size_x != 1)
		var/matrix/M = matrix()
		M.Scale(caste.adjust_size_x, caste.adjust_size_y)
		apply_transform(M)

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

		for(var/obj/item/W in oldXeno.contents) //Drop stuff
			oldXeno.drop_inv_item_on_ground(W)

		oldXeno.empty_gut()

		if(IS_XENO_LEADER(oldXeno))
			hive.replace_hive_leader(oldXeno, src)

	if (caste)
		behavior_delegate = new caste.behavior_delegate_type()
		behavior_delegate.bound_xeno = src
		resin_build_order = caste.resin_build_order
	else
		CRASH("Xenomorph [src] has no caste datum! Tell the devs!")


	if(round_statistics && !statistic_exempt)
		round_statistics.track_new_participant(faction, 1)
	generate_name()

	// This can happen if a xeno gets made before the game starts
	if (hive && hive.hive_ui)
		hive.hive_ui.update_all_xeno_data()

	job = JOB_XENOMORPH

/mob/living/carbon/Xenomorph/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = SETUP_LIST_FLAGS(PASS_MOB_IS_XENO)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_MOB_THRU_XENO, PASS_AROUND, PASS_HIGH_OVER_ONLY)

/mob/living/carbon/Xenomorph/initialize_pain()
	pain = new /datum/pain/xeno(src)

/mob/living/carbon/Xenomorph/initialize_stamina()
	stamina = new /datum/stamina/xeno(src)

/mob/living/carbon/Xenomorph/proc/update_caste()
	if(caste_name && xeno_datum_list[caste_name])
		caste = xeno_datum_list[caste_name]
	else
		to_world("something went very wrong")
		return

	acid_splash_cooldown = caste.acid_splash_cooldown

	if (caste.fire_immune)
		registerListener(src, EVENT_PREIGNITION_CHECK, "xeno_fire_immune", TRUE_CALLBACK)
		registerListener(src, EVENT_PRE_FIRE_BURNED_CHECK, "xeno_fire_immune", TRUE_CALLBACK)

	recalculate_everything()


//Off-load this proc so it can be called freely
//Since Xenos change names like they change shoes, we need somewhere to hammer in all those legos
//We set their name first, then update their real_name AND their mind name
/mob/living/carbon/Xenomorph/proc/generate_name()
	//We don't have a nicknumber yet, assign one to stick with us
	if(!nicknumber)
		var/tempnumber = rand(1, 999)
		var/list/numberlist = list()
		for(var/mob/living/carbon/Xenomorph/X in mob_list)
			numberlist += X.nicknumber

		while(tempnumber in numberlist)
			tempnumber = rand(1, 999)

		nicknumber = tempnumber

	// Even if we don't have the hive datum we usually still have the hive number
	var/datum/hive_status/in_hive = hive
	if(!in_hive)
		in_hive = hive_datum[hivenumber]

	//Larvas have their own, very weird naming conventions, let's not kick a beehive, not yet
	if(isXenoLarva(src))
		return

	var/name_prefix = in_hive.prefix
	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
	color = in_hive.color

	//Queens have weird, hardcoded naming conventions based on age levels. They also never get nicknumbers
	if(isXenoQueen(src))
		switch(age)
			if(0) name = "\improper [name_prefix]Queen"			 //Young
			if(1) name = "\improper [name_prefix]Elder Queen"	 //Mature
			if(2) name = "\improper [name_prefix]Elder Empress"	 //Elite
			if(3) name = "\improper [name_prefix]Ancient Empress" //Ancient
			if(4) name = "\improper [name_prefix]Primordial Empress" //Primordial
	else if(isXenoPredalien(src)) name = "\improper [name_prefix][caste.display_name] ([name_client_prefix][nicknumber][name_client_postfix])"
	else if(caste) name = "\improper [name_prefix][age_prefix][caste.caste_name] ([name_client_prefix][nicknumber][name_client_postfix])"

	//Update linked data so they show up properly
	change_real_name(src, name)

	// Since we updated our name we should update the info in the UI
	in_hive.hive_ui.update_xeno_info()

/mob/living/carbon/Xenomorph/examine(mob/user)
	..()
	if(isXeno(user) && caste && caste.caste_desc)
		to_chat(user, caste.caste_desc)

	if(stat == DEAD)
		to_chat(user, "It is DEAD. Kicked the bucket. Off to that great hive in the sky.")
	else if(stat == UNCONSCIOUS)
		to_chat(user, "It quivers a bit, but barely moves.")
	else
		var/percent = (health / maxHealth * 100)
		switch(percent)
			if(95 to 101)
				to_chat(user, "It looks quite healthy.")
			if(75 to 94)
				to_chat(user, "It looks slightly injured.")
			if(50 to 74)
				to_chat(user, "It looks injured.")
			if(25 to 49)
				to_chat(user, "It bleeds with sizzling wounds.")
			if(1 to 24)
				to_chat(user, "It is heavily injured and limping badly.")

	if(hivenumber != XENO_HIVE_NORMAL)
		to_chat(user, "It appears to belong to [hive ? "the [hive.prefix]" : "a different "]hive.")

	if(isXeno(user) || isobserver(user))
		if(mutation_type != "Normal")
			to_chat(user, "It has specialized into a [mutation_type].")

	return

/mob/living/carbon/Xenomorph/Destroy()
	if(mind)
		mind.name = name //Grabs the name when the xeno is getting deleted, to reference through hive status later.
	if(is_zoomed)
		zoom_out()

	living_xeno_list -= src
	xeno_mob_list -= src

	if(IS_XENO_LEADER(src)) //Strip them from the Xeno leader list, if they are indexed in here
		hive.remove_hive_leader(src)

	SStracking.stop_tracking("hive_[hivenumber]", src)

	if(hive)
		hive.remove_xeno(src)

	remove_from_all_mob_huds()

	for(var/datum/action/xeno_action/XA in actions)
		qdel(XA)
		XA = null

	reagents = null

	observed_xeno = null
	wear_suit = null
	head = null
	r_store = null
	l_store = null

	start_dig = null
	ammo = null

	selected_ability = null
	queued_action = null

	if(mutators)
		qdel(mutators)
		mutators = null

	. = ..()


/mob/living/carbon/Xenomorph/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	return FALSE



/mob/living/carbon/Xenomorph/start_pulling(atom/movable/AM, lunge, no_msg)
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
		next_move = world.time + (10 + caste.attack_delay + attack_speed_modifier)
		return FALSE
	return ..()

/mob/living/carbon/Xenomorph/pull_response(mob/puller)
	if(stat != DEAD && has_species(puller,"Human")) // If the Xeno is alive, fight back against a grab/pull
		puller.KnockDown(rand(caste.tacklestrength_min,caste.tacklestrength_max))
		playsound(puller.loc, 'sound/weapons/pierce.ogg', 25, 1)
		puller.visible_message(SPAN_WARNING("[puller] tried to pull [src] but instead gets a tail swipe to the head!"))
		puller.stop_pulling()
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
	
	//and display them
	add_to_all_mob_huds()
	var/datum/mob_hud/MH = huds[MOB_HUD_XENO_INFECTION]
	MH.add_hud_to(src)


/mob/living/carbon/Xenomorph/point_to_atom(atom/A, turf/T)
	//xeno leader get a bit arrow and less cooldown
	if(hive_pos != NORMAL_XENO)
		recently_pointed_to = world.time + 10
		new /obj/effect/overlay/temp/point/big(T, src)
	else
		recently_pointed_to = world.time + 50
		new /obj/effect/overlay/temp/point(T, src)
	visible_message("<b>[src]</b> points to [A]")
	return 1



///get_eye_protection()
///Returns a number between -1 to 2
/mob/living/carbon/Xenomorph/get_eye_protection()
	return 2

/mob/living/carbon/Xenomorph/get_pull_miltiplier()
	return pull_multiplier

/mob/living/carbon/Xenomorph/proc/set_faction(var/new_faction = FACTION_XENOMORPH)
	if(round_statistics && !statistic_exempt)
		round_statistics.track_new_participant(faction, -1)
		round_statistics.track_new_participant(new_faction, 1)
	faction = new_faction

//Call this function to set the hive and do other cleanup
/mob/living/carbon/Xenomorph/proc/set_hive_and_update(var/new_hivenumber = XENO_HIVE_NORMAL)
	var/datum/hive_status/new_hive = hive_datum[new_hivenumber]
	if(!new_hive)
		return
	
	
	new_hive.add_xeno(src)

	set_faction(hive.name)

	if(istype(src, /mob/living/carbon/Xenomorph/Larva))
		var/mob/living/carbon/Xenomorph/Larva/L = src
		L.update_icons() // larva renaming done differently
	else
		generate_name()
	if(istype(src, /mob/living/carbon/Xenomorph/Queen))
		update_living_queens()
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
	tackle_chance = caste.tackle_chance
	tacklestrength_min = caste.tacklestrength_min + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus
	tacklestrength_max = caste.tacklestrength_max + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus

/mob/living/carbon/Xenomorph/proc/recalculate_health()
	var/new_max_health = health_modifier + caste.max_health
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

/mob/living/carbon/Xenomorph/proc/recalculate_armor()
	//We are calculating it in a roundabout way not to give anyone 100% armor deflection, so we're dividing the differences
	armor_deflection = armor_modifier + round(100 - (100 - caste.armor_deflection))
	armor_explosive_buff = explosivearmor_modifier

/mob/living/carbon/Xenomorph/proc/recalculate_damage()
	melee_damage_lower = damage_modifier
	melee_damage_upper = damage_modifier
	if(caste)
		melee_damage_lower += caste.melee_damage_lower
		melee_damage_upper += caste.melee_damage_upper

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


/mob/living/carbon/Xenomorph/proc/recalculate_maturation()
	evolution_threshold =  caste.evolution_threshold

/mob/living/carbon/Xenomorph/rejuvenate()
	if(stat == DEAD && !disposed)
		living_xeno_list += src

		if(hive)
			hive.add_xeno(src)
			hive.hive_ui.update_all_xeno_data()

		if(caste_name == "Queen")
			New()
	armor_integrity = 100
	..()
	hud_update()
	plasma_stored = plasma_max

/mob/living/carbon/Xenomorph/proc/remove_action(var/action as text)
	for(var/X in actions)
		var/datum/action/A = X
		if(A.name == action)
			A.remove_action(src)

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