//Xenomorph "generic" parent, does not actually appear in game
//Many of these defines aren't referenced in the castes and so are assumed to be defaulted
//Castes are all merely subchildren of this parent
//Just about ALL the procs are tied to the parent, not to the children
//This is so they can be easily transferred between them without copypasta

//All this stuff was written by Absynth.
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
	name = "Drone"
	desc = "What the hell is THAT?"
	icon = 'icons/mob/xenos/1x1_Xenos.dmi'
	icon_state = "Drone Walking"
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
	see_infrared = 1
	recovery_constant = 1.5
	see_invisible = SEE_INVISIBLE_MINIMUM
	hud_possible = list(HEALTH_HUD_XENO, PLASMA_HUD, PHEROMONE_HUD, QUEEN_OVERWATCH_HUD, ARMOR_HUD_XENO, XENO_STATUS_HUD)
	unacidable = TRUE
	rebounds = TRUE
	faction = FACTION_XENOMORPH
	var/hivenumber = XENO_HIVE_NORMAL
	var/icon_size = 48
	var/datum/mutator_set/individual_mutators/mutators = new

	// Mutatotion types/Strain names
	var/mutation_type = null

	// Armor
	var/armor_deflection_buff = 0
	var/armor_explosive_buff = 0
	var/armor_integrity = 100
	var/armor_integrity_max = 100
	var/armor_integrity_last_damage_time = 0
	var/armor_integrity_immunity_time = 0

	//Stagger for predator weapons. Prevents hivemind usage, queen overwatching, etc.
	var/interference = 0

	// Overwatched xeno for xeno hivemind vision
	var/mob/living/carbon/Xenomorph/observed_xeno

	//Variables that can be mutated
	health = 5
	maxHealth = 5
	speed = -0.5 //Speed bonus/penalties. Positive makes you go slower. (1.5 is equivalent to FAT mutation)
	var/speed_multiplier = 1.0 //For speed mutator
	var/ability_speed_modifier = 0.0 //Things that add on top of our base speed, based on what powers we are using
	melee_damage_lower = 5
	melee_damage_upper = 10
	var/burn_damage_lower = 0
	var/burn_damage_upper = 0
	var/armor_deflection = 10
	var/evasion = 0
	var/list/plasma_types = list() //The types of plasma the caste contains
	var/extra_build_dist = 0 // For drones/hivelords. Extends the maximum build range they have

	// Action to perform on the next click.
	var/datum/action/xeno_action/activable/queued_action

	// Temporary HP.
	var/temp_health = 0 // As dumb as it sounds, literally just an HP buffer. Should be reset to 0 by whatever adds it to begin with.

	// Overheal - Gives you temporary extra health
	var/overheal = 0
	var/max_overheal = 0

	var/plasma_stored = 10
	var/plasma_max = 10
	var/plasma_gain = 5

	var/aura_strength = 0
	var/weed_level = 1
	var/acid_level = 0
	var/gas_level = 0
	var/gas_life_multiplier = 1.0

	var/upgrade_threshold = 200
	var/evolution_threshold = 200
	var/pull_multiplier = 1.0

	var/datum/caste_datum/caste
	var/datum/hive_status/hive

	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/head/head = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/amount_grown = 0
	var/time_of_birth
	var/max_grown = 200
	var/evolution_stored = 0 //How much evolution they have stored

	var/upgrade_stored = 0 //How much upgrade points they have stored.
	var/upgrade = -1  //This will track their upgrade level. -1 means cannot upgrade

	var/has_spat = 0
	var/armor_bonus = 0 //Extra chance of deflecting projectiles due to temporary effects
	var/has_screeched = 0

	var/devour_timer = 0

	var/last_rng_attack = 0

	var/obj/structure/tunnel/start_dig = null
	var/tunnel_delay = 0
	var/datum/ammo/xeno/ammo = null //The ammo datum for our spit projectiles. We're born with this, it changes sometimes.
	var/pslash_delay = 0

	var/current_aura = null //"claw", "armor", "regen", "speed"
	var/frenzy_aura = 0 //Strength of aura we are affected by. NOT THE ONE WE ARE EMITTING
	var/warding_aura = 0
	var/recovery_aura = 0

	var/is_zoomed = 0
	var/zoom_turf = null
	var/autopsied = 0

	var/tier = 1 //This will track their "tier" to restrict/limit evolutions
	var/hardcore = 0 //Set to 1 in New() when Whiskey Outpost is active. Prevents healing and queen evolution
	var/crit_health = -100 // What negative healthy they die in.
	var/gib_chance  = 5 // % chance of them exploding when taking damage. Goes up with damage inflicted.

	var/fortify_timer = 60
	var/burrow_timer = 200
	var/tunnel_timer = 20

	var/emotedown = 0

	var/datum/action/xeno_action/activable/selected_ability
	var/selected_resin = RESIN_WALL //which resin structure to build when we secrete resin

	//Naming variables
	var/caste_name = "Drone"
	var/nicknumber = 0 //The number after the name. Saved right here so it transfers between castes.

	//This list of inherent verbs lets us take any proc basically anywhere and add them.
	//If they're not a xeno subtype it might crash or do weird things, like using human verb procs
	//It should add them properly on New() and should reset/readd them on evolves
	var/list/inherent_verbs = list()

	//Lord forgive me for this horror, but Life code is awful
	//These are tally vars, yep. Because resetting the aura value directly leads to fuckups
	var/frenzy_new = 0
	var/warding_new = 0
	var/recovery_new = 0

	var/xeno_mobhud = FALSE //whether the xeno mobhud is activated or not.

	//Old crusher specific vars, moved here so the Queen can use charge, and potential future Xenos
	var/charge_dir = 0 //Stores initial charge dir to immediately cut out any direction change shenanigans
	var/charge_timer = 0 //Has a small charge window. has to keep moving to build speed.
	var/turf/lastturf = null
	var/noise_timer = 0 // Makes a mech footstep, but only every 3 turfs.
	var/has_moved = 0
	var/is_charging = 0 //Will the mob charge when moving ? You need the charge verb to change this
	var/weedwalking_activated = 0 //Hivelord's weedwalking
	var/last_charge_move = 0 //Time of the last time the Crusher moved while charging. If it's too far apart, the charge is broken

	//Burrower Vars
	var/used_tremor = 0

	//Pounce vars
	var/used_pounce = 0

	// Warrior vars
	var/agility = 0		// 0 - upright, 1 - all fours
	var/ripping_limb = 0

	var/used_lunge = 0
	var/used_fling = 0
	var/used_punch = 0
	var/used_toggle_agility = 0

	var/used_jab = 0

	// Defender vars
	var/fortify = 0
	var/crest_defense = 0

	var/used_headbutt = 0
	var/used_tail_sweep = 0
	var/used_crest_defense = 0
	var/used_fortify = 0

	// Burrowers
	var/used_burrow = 0
	var/used_tunnel = 0
	var/used_widen = 0

	var/tunnel = 0
	var/burrow = 0

	//Praetorian vars
	var/used_acid_spray = 0
	var/prae_status_flags = 0 // Used to store praetorian status flags so we don't stack screech buffs

	//Carrier vars
	var/threw_a_hugger = 0
	var/huggers_cur = 0
	var/eggs_cur = 0
	var/huggers_max = 0
	var/eggs_max = 0
	var/laid_egg = 0

	//Leader vars
	var/leader_aura_strength = 0 //Pheromone strength inherited from Queen
	var/leader_current_aura = "" //Pheromone type inherited from Queen

	// Related to zooming out (primarily queen and boiler)
	var/tileoffset = 0
	var/viewsize = 0

	gender = NEUTER

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

	// TODO: move this to caste-specific
	var/tacklemin = 2
	var/tacklemax = 3
	var/tackle_chance = 35
	var/need_weeds = TRUE

	//Defender
	var/spiked = FALSE

	//Warrior
	var/boxer = FALSE

	//Pouncing Castes
	var/pounce_slash = FALSE

	//Strain Variables
	//Boiler
	// TODO: move this to caste-specific
	var/bombard_cooldown = 30
	var/min_bombard_dist = 5

	var/acid_spray_activation_time = 12

	var/acid_splash_cooldown = SECONDS_5 //Time it takes between acid splash retaliate procs
	var/acid_splash_last //Last recorded time that an acid splash procced

	//New variables for how charges work, max speed, speed buildup, all that jazz
	// TODO: move this to caste-specific if possible (this one's tricky)
	var/charge_speed_max = 1.5 //Can only gain this much speed before capping
	var/charge_speed_buildup = 0.15 //POSITIVE amount of speed built up during a charge each step
	var/charge_turfs_to_charge = 5 //Amount of turfs to build up before a charge begins
	var/charge_speed = 0 //Modifier on base move delay as charge builds up
	var/charge_roar = 0 //Did we roar in our charge yet?

	var/hive_pos = NORMAL_XENO // The position of the xeno in the hive (0 = normal xeno; 1 = queen; 2+ = hive leader)



/mob/living/carbon/Xenomorph/New(var/new_loc, var/mob/living/carbon/Xenomorph/oldXeno)
	var/area/A = get_area(src)
	if(A.statistic_exempt)
		statistic_exempt = TRUE
	if(oldXeno)
		hivenumber = oldXeno.hivenumber
		nicknumber = oldXeno.nicknumber

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
	if(hivenumber == XENO_HIVE_CORRUPTED)
		add_language("English")
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

	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

	living_xeno_list += src
	xeno_mob_list += src

	if(caste && caste.adjust_size_x != 1)
		var/matrix/M = matrix()
		M.Scale(caste.adjust_size_x, caste.adjust_size_y)
		apply_transform(M)

	regenerate_icons()
	toggle_xeno_mobhud() //This is a verb, but fuck it, it just werks

	if(oldXeno)
		if(xeno_mobhud)
			var/datum/mob_hud/H = huds[MOB_HUD_XENO_STATUS]
			H.add_hud_to(src) //keep our mobhud choice
			xeno_mobhud = TRUE

		a_intent_change(oldXeno.a_intent)//Keep intent
		if(oldXeno.m_intent != MOVE_INTENT_RUN)
			toggle_mov_intent()//Keep move intent

		if(oldXeno.layer == XENO_HIDING_LAYER)
			//We are hiding, let's keep hiding if we can!
			for(var/datum/action/xeno_action/xenohide/hide in actions)
				if(istype(hide))
					layer = XENO_HIDING_LAYER

		for(var/obj/item/W in oldXeno.contents) //Drop stuff
			oldXeno.drop_inv_item_on_ground(W)

		oldXeno.empty_gut()

		if(IS_XENO_LEADER(oldXeno))
			hive.replace_hive_leader(oldXeno, src)

	// Set the maximum overheal to % of the xeno's max health
	max_overheal = round(maxHealth*XENO_MAXOVERHEAL_OF_MAXHEALTH)

	if(round_statistics && !statistic_exempt)
		round_statistics.track_new_participant(faction, 1)
	generate_name()

	hive.hive_ui.update_all_xeno_data()

/mob/living/carbon/Xenomorph/proc/update_caste()
	if(caste_name && xeno_datum_list[caste_name] && xeno_datum_list[caste_name][max(1,upgrade+1)])
		caste = xeno_datum_list[caste_name][max(1,upgrade+1)]
	else
		to_world("something went very wrong")
		return
	upgrade = caste.upgrade
	acid_splash_cooldown = caste.acid_splash_cooldown
	mutators.user_levelled_up(upgrade)
	if(isXenoQueenLeadingHive(src))
		//The Queen matures, so does the Hive!
		hive.mutators.user_levelled_up(upgrade)
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

	//Queens have weird, hardcoded naming conventions based on upgrade levels. They also never get nicknumbers
	if(isXenoQueen(src))
		switch(upgrade)
			if(0) name = "\improper [name_prefix]Queen"			 //Young
			if(1) name = "\improper [name_prefix]Elder Queen"	 //Mature
			if(2) name = "\improper [name_prefix]Elder Empress"	 //Elite
			if(3) name = "\improper [name_prefix]Ancient Empress" //Ancient
			if(4) name = "\improper [name_prefix]Primordial Empress" //Primordial
	else if(isXenoPredalien(src)) name = "\improper [name_prefix][caste.display_name] ([name_client_prefix][nicknumber][name_client_postfix])"
	else if(caste) name = "\improper [name_prefix][caste.upgrade_name] [caste.caste_name] ([name_client_prefix][nicknumber][name_client_postfix])"

	//Update linked data so they show up properly
	real_name = name
	if(mind) mind.name = name //This gives them the proper name in deadchat if they explode on death. It's always the small things

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
		to_chat(user, "It appears to belong to the [hive.prefix]hive")

	if(isXeno(user) || isobserver(user))
		if(mutation_type != "Normal")
			to_chat(user, "It has specialized into a [mutation_type].")

	return

/mob/living/carbon/Xenomorph/Dispose()
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
		hive.remove_xeno(src, TRUE)
		hive = null

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

	caste = null



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
		next_move = world.time + (10 + caste.attack_delay)
		return FALSE
	return ..()

/mob/living/carbon/Xenomorph/pull_response(mob/puller)
	if(stat != DEAD && has_species(puller,"Human")) // If the Xeno is alive, fight back against a grab/pull
		puller.KnockDown(rand(caste.tacklemin,caste.tacklemax))
		playsound(puller.loc, 'sound/weapons/pierce.ogg', 25, 1)
		puller.visible_message(SPAN_WARNING("[puller] tried to pull [src] but instead gets a tail swipe to the head!"))
		puller.stop_pulling()
		return FALSE
	return TRUE

/mob/living/carbon/Xenomorph/resist_grab(moving_resist)
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

/mob/living/carbon/Xenomorph/lay_down()
	if(burrow)
		return
	..()


/mob/living/carbon/Xenomorph/point_to_atom(atom/A, turf/T)
	//xeno leader get a bit arrow and less cooldown
	if(hive_pos != NORMAL_XENO)
		recently_pointed_to = world.time + 10
		new /obj/effect/overlay/temp/point/big(T)
	else
		recently_pointed_to = world.time + 50
		new /obj/effect/overlay/temp/point(T)
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
/mob/living/carbon/Xenomorph/proc/set_hive_and_update(var/new_hivenumber = XENO_HIVE_NORMAL, var/new_faction = FACTION_XENOMORPH)
	var/datum/hive_status/new_hive = hive_datum[new_hivenumber]
	if(new_hive)
		new_hive.add_xeno(src)

	set_faction(new_faction)

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
	recalculate_speed()
	recalculate_armor()
	recalculate_damage()
	recalculate_charge()
	recalculate_evasion()

/mob/living/carbon/Xenomorph/proc/recalculate_tackle()
	tacklemin = caste.tacklemin + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus
	tacklemax = caste.tacklemax + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus
	tackle_chance = round(caste.tackle_chance * mutators.tackle_chance_multiplier * hive.mutators.tackle_chance_multiplier + 0.5)


/mob/living/carbon/Xenomorph/proc/recalculate_charge()
	charge_speed_max = caste.charge_speed_max
	charge_speed_buildup = caste.charge_speed_buildup * mutators.charge_speed_buildup_multiplier
	charge_turfs_to_charge = caste.charge_turfs_to_charge + mutators.charge_turfs_to_charge_delta

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

/mob/living/carbon/Xenomorph/proc/recalculate_speed()
	recalculate_move_delay = TRUE
	speed = speed_modifier
	if(caste)
		speed += caste.speed

/mob/living/carbon/Xenomorph/proc/recalculate_armor()
	//We are calculating it in a roundabout way not to give anyone 100% armor deflection, so we're dividing the differences
	armor_deflection = armor_modifier + round(100 - (100 - caste.armor_deflection))

/mob/living/carbon/Xenomorph/proc/recalculate_damage()
	melee_damage_lower = damage_modifier
	melee_damage_upper = damage_modifier
	if(caste)
		melee_damage_lower += caste.melee_damage_lower
		melee_damage_upper += caste.melee_damage_upper

/mob/living/carbon/Xenomorph/proc/recalculate_evasion()
	evasion = evasion_modifier + caste.evasion

/mob/living/carbon/Xenomorph/proc/recalculate_actions()
	recalculate_acid()
	recalculate_weeds()
	recalculate_gas()
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
	if(weed_level < 1)
		weed_level = 1//need to maintain the minimum in case something goes really wrong

/mob/living/carbon/Xenomorph/proc/recalculate_pheromones()
	if(caste.aura_strength > 0)
		aura_strength = caste.aura_strength + phero_modifier
	else
		caste.aura_strength = 0

/mob/living/carbon/Xenomorph/proc/recalculate_gas()
	gas_level = mutators.gas_boost_level
	gas_life_multiplier = mutators.gas_life_multiplier
	bombard_cooldown = mutators.bombard_cooldown
	min_bombard_dist = mutators.min_bombard_dist

/mob/living/carbon/Xenomorph/proc/recalculate_maturation()
	upgrade_threshold =  caste.upgrade_threshold
	evolution_threshold =  caste.evolution_threshold

/mob/living/carbon/Xenomorph/rejuvenate()
	if(stat == DEAD)
		living_xeno_list += src

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
	fire_stacks = max(fire_stacks - rand(3, 6), 0)
	KnockDown(4, TRUE)
	visible_message(SPAN_DANGER("[src] rolls on the floor, trying to put themselves out!"), \
		SPAN_NOTICE("You stop, drop, and roll!"), null, 5)
	if(fire_stacks > 0 && !istype(get_turf(src), /turf/open/gm/river))
		return

	visible_message(SPAN_DANGER("[src] has successfully extinguished themselves!"), \
		SPAN_NOTICE("You extinguish yourself."), null, 5)
	ExtinguishMob()
	return

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
