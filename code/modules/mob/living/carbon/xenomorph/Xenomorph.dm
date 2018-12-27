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
		src << "<span class='warning'>The round is either not ready, or has already finished.</span>"
		return
	if(mind in ticker.mode.xenomorphs)
		src << "<span class='debuginfo'>[src] mind is in the xenomorph list. Mind key is [mind.key].</span>"
		src << "<span class='debuginfo'>Current mob is: [mind.current]. Original mob is: [mind.original].</span>"
	else src << "<span class='debuginfo'>This xenomorph is not in the xenomorph list.</span>"
#endif

#undef DEBUG_XENO

/mob/living/carbon/Xenomorph
	name = "Drone"
	desc = "What the hell is THAT?"
	icon = 'icons/Xeno/1x1_Xenos.dmi'
	icon_state = "Drone Walking"
	voice_name = "xenomorph"
	speak_emote = list("hisses")
	var/armor_deflection_buff = 0
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
	see_invisible = SEE_INVISIBLE_MINIMUM
	hud_possible = list(HEALTH_HUD_XENO, PLASMA_HUD, PHEROMONE_HUD,QUEEN_OVERWATCH_HUD)
	unacidable = TRUE
	var/hivenumber = XENO_HIVE_NORMAL
	var/datum/mutator_set/individual_mutators/mutators = new

	//Variables that can be mutated
	health = 5
	maxHealth = 5
	var/speed = -0.5 //Speed bonus/penalties. Positive makes you go slower. (1.5 is equivalent to FAT mutation)
	melee_damage_lower = 5
	melee_damage_upper = 10
	var/burn_damage_lower = 0
	var/burn_damage_upper = 0
	var/armor_deflection = 10

	var/plasma_stored = 10
	var/plasma_max = 10
	var/plasma_gain = 5

	var/aura_strength = 0
	var/weed_level = 1
	var/acid_level = 0
	var/gas_level = 0

	var/upgrade_threshold = 200
	var/evolution_threshold = 200
	var/pull_multiplier = 1.0
	
	var/tacklemin = 2
	var/tacklemax = 3
	var/tackle_chance = 35


/mob/living/carbon/Xenomorph/New(var/new_loc, var/mob/living/carbon/Xenomorph/oldXeno)
	if(oldXeno)
		hivenumber = oldXeno.hivenumber
		nicknumber = oldXeno.nicknumber
	mutators.xeno = src
	set_hivenumber(hivenumber)
	update_caste()
	generate_name()
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

	if(caste.spit_types && caste.spit_types.len)
		ammo = ammo_list[caste.spit_types[1]]

	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

	living_xeno_list += src
	xeno_mob_list += src
	round_statistics.total_xenos_created++

	if(caste.adjust_size_x != 1)
		var/matrix/M = matrix()
		M.Scale(caste.adjust_size_x, caste.adjust_size_y)
		transform = M

	regenerate_icons()
	toggle_xeno_mobhud() //This is a verb, but fuck it, it just werks

	if(oldXeno)
		if(xeno_mobhud)
			var/datum/mob_hud/H = huds[MOB_HUD_XENO_STATUS]
			H.add_hud_to(src) //keep our mobhud choice
			xeno_mobhud = TRUE

		middle_mouse_toggle = oldXeno.middle_mouse_toggle //Keep our toggle state
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

		if(oldXeno.queen_chosen_lead && caste_name != "Queen") // xeno leader is removed by Dispose()
			queen_chosen_lead = TRUE
			hive.xeno_leader_list += src
			hud_set_queen_overwatch()
			if(hive.living_xeno_queen)
				handle_xeno_leader_pheromones()


/mob/living/carbon/Xenomorph/proc/update_caste()
	if(caste_name && xeno_datum_list[caste_name] && xeno_datum_list[caste_name][max(1,upgrade+1)])
		caste = xeno_datum_list[caste_name][max(1,upgrade+1)]
	else
		world << "something went very wrong"
		return
	upgrade = caste.upgrade
	mutators.user_levelled_up(upgrade)
	if(isXenoQueenLeadingHive(src))
		//The Queen matures, so does the Hive!
		hive.mutators.user_levelled_up(upgrade)
	recalculate_everything()


//Off-load this proc so it can be called freely
//Since Xenos change names like they change shoes, we need somewhere to hammer in all those legos
//We set their name first, then update their real_name AND their mind name
/mob/living/carbon/Xenomorph/proc/generate_name()
	if(!hive)
		set_hivenumber(hivenumber)


	//We don't have a nicknumber yet, assign one to stick with us
	if(!nicknumber)
		var/tempnumber = rand(1, 999)
		var/list/numberlist = list()
		for(var/mob/living/carbon/Xenomorph/X in mob_list)
			numberlist += X.nicknumber

		while(tempnumber in numberlist)
			tempnumber = rand(1, 999)

		nicknumber = tempnumber


	//Larvas have their own, very weird naming conventions, let's not kick a beehive, not yet
	if(isXenoLarva(src))
		return

	var/name_prefix = hive.prefix
	color = hive.color

	//Queens have weird, hardcoded naming conventions based on upgrade levels. They also never get nicknumbers
	if(isXenoQueen(src))
		switch(upgrade)
			if(0) name = "\improper [name_prefix]Queen"			 //Young
			if(1) name = "\improper [name_prefix]Elder Queen"	 //Mature
			if(2) name = "\improper [name_prefix]Elder Empress"	 //Elite
			if(3) name = "\improper [name_prefix]Ancient Empress" //Ancient
	else if(isXenoPredalien(src)) name = "\improper [name_prefix][caste.display_name] ([nicknumber])"
	else name = "\improper [name_prefix][caste.upgrade_name] [caste.caste_name] ([nicknumber])"

	//Update linked data so they show up properly
	real_name = name
	if(mind) mind.name = name //This gives them the proper name in deadchat if they explode on death. It's always the small things

/mob/living/carbon/Xenomorph/examine(mob/user)
	..()
	if(isXeno(user) && caste.caste_desc)
		user << caste.caste_desc

	if(stat == DEAD)
		user << "It is DEAD. Kicked the bucket. Off to that great hive in the sky."
	else if(stat == UNCONSCIOUS)
		user << "It quivers a bit, but barely moves."
	else
		var/percent = (health / maxHealth * 100)
		switch(percent)
			if(95 to 101)
				user << "It looks quite healthy."
			if(75 to 94)
				user << "It looks slightly injured."
			if(50 to 74)
				user << "It looks injured."
			if(25 to 49)
				user << "It bleeds with sizzling wounds."
			if(1 to 24)
				user << "It is heavily injured and limping badly."

	if(hivenumber != XENO_HIVE_NORMAL)
		user << "It appears to belong to the [hive.prefix]hive"
	return

/mob/living/carbon/Xenomorph/Dispose()
	if(mind) mind.name = name //Grabs the name when the xeno is getting deleted, to reference through hive status later.
	if(is_zoomed) zoom_out()

	living_xeno_list -= src
	xeno_mob_list -= src

	if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
		hive.living_xeno_queen.set_queen_overwatch(src, TRUE)
	if(src in hive.xeno_leader_list)
		hive.xeno_leader_list -= src
	. = ..()



/mob/living/carbon/Xenomorph/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	return FALSE



/mob/living/carbon/Xenomorph/start_pulling(atom/movable/AM, lunge, no_msg)
	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	if(isSynth(L) && L.stat == DEAD) //no meta hiding synthetic bodies
		return FALSE
	if(L.buckled)
		return FALSE //to stop xeno from pulling marines on roller beds.
	if(ishuman(L) && L.stat == DEAD && !L.chestburst)
		var/mob/living/carbon/human/H = L
		if(H.status_flags & XENO_HOST)
			if(world.time > H.timeofdeath + H.revive_grace_period)
				return FALSE // they ain't gonna burst now
		else
			return FALSE // leave the dead alone
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
		puller.visible_message("<span class='warning'>[puller] tried to pull [src] but instead gets a tail swipe to the head!</span>")
		puller.stop_pulling()
		return FALSE
	return TRUE

/mob/living/carbon/Xenomorph/resist_grab(moving_resist)
	if(pulledby.grab_level)
		visible_message("<span class='danger'>[src] has broken free of [pulledby]'s grip!</span>", null, null, 5)
	pulledby.stop_pulling()
	. = 1



/mob/living/carbon/Xenomorph/prepare_huds()
	..()
	//updating all the mob's hud images
	med_hud_set_health()
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
	if(queen_chosen_lead || isXenoQueen(src))
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


//Call this function to set the hivenumber
//It also assigns the hive datum, since a lot of things reference that
/mob/living/carbon/Xenomorph/proc/set_hivenumber(var/new_hivenumber = XENO_HIVE_NORMAL)
	hivenumber = new_hivenumber
	if(!hivenumber || hivenumber > hive_datum.len)
		hivenumber = XENO_HIVE_NORMAL //Someone passed a bad number
		log_debug("Invalid hivenumber forwarded - [hivenumber]. Let the devs know!")
	hive = hive_datum[hivenumber]

//Call this function to set the hivenumber and do other cleanup
/mob/living/carbon/Xenomorph/proc/set_hivenumber_and_update(var/new_hivenumber = XENO_HIVE_NORMAL)
	set_hivenumber(new_hivenumber)

	if(istype(src, /mob/living/carbon/Xenomorph/Larva))
		var/mob/living/carbon/Xenomorph/Larva/L = src
		L.update_icons() // larva renaming done differently
	else
		generate_name()
	if(istype(src, /mob/living/carbon/Xenomorph/Queen))
		update_living_queens()
	recalculate_everything()

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

/mob/living/carbon/Xenomorph/proc/recalculate_tackle()
	tacklemin = caste.tacklemin + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus
	tacklemax = caste.tacklemax + mutators.tackle_strength_bonus + hive.mutators.tackle_strength_bonus
	tackle_chance = round(caste.tackle_chance * mutators.tackle_chance_multiplier * hive.mutators.tackle_chance_multiplier + 0.5)


/mob/living/carbon/Xenomorph/proc/recalculate_health()
	var/new_max_health = round(caste.max_health * mutators.health_multiplier * hive.mutators.health_multiplier + 0.5)
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
	var/new_plasma_max = round(caste.plasma_max * mutators.plasma_multiplier * hive.mutators.plasma_multiplier + 0.5)
	plasma_gain = round(new_plasma_max * caste.plasma_gain * mutators.plasma_gain_multiplier * hive.mutators.plasma_gain_multiplier + 0.5)
	if (new_plasma_max == plasma_max)
		return
	var/plasma_ratio = plasma_stored / plasma_max
	plasma_max = new_plasma_max
	plasma_stored = round(plasma_max * plasma_ratio + 0.5)//Restore our plasma ratio, so if we're full, we continue to be full, etc. Rounding up (hence the +0.5)
	if(plasma_stored > plasma_max)
		plasma_stored = plasma_max

/mob/living/carbon/Xenomorph/proc/recalculate_speed()
	speed = caste.speed + mutators.speed_boost + hive.mutators.speed_boost
	if(isXenoWarrior(src)) // because of the warrior speed bug.
		if(agility)
			speed = speed + caste.agility_speed_increase


/mob/living/carbon/Xenomorph/proc/recalculate_armor()
	//We are calculating it in a roundabout way not to give anyone 100% armor deflection, so we're dividing the differences
	armor_deflection = round(100 - ((100 - caste.armor_deflection) * mutators.armor_multiplier * hive.mutators.armor_multiplier) + 0.5)

/mob/living/carbon/Xenomorph/proc/recalculate_damage()
	melee_damage_lower = round(caste.melee_damage_lower * mutators.damage_multiplier * hive.mutators.damage_multiplier + 0.5)
	melee_damage_upper = round(caste.melee_damage_upper * mutators.damage_multiplier * hive.mutators.damage_multiplier + 0.5)

	if(mutators.acid_claws)
		//Burn damage is equal to 12.5% of brute damage, multiplied by acid level (1-3)
		burn_damage_lower = round(melee_damage_lower * acid_level * 0.125 + 0.5)
		burn_damage_upper = round(melee_damage_upper * acid_level * 0.125 + 0.5)

		//Brute damage is lowered by 12.5%. Overall damage will be greater than before if acid level is above 1
		melee_damage_lower = round(melee_damage_lower * 0.875 + 0.5)
		melee_damage_upper = round(melee_damage_upper * 0.875 + 0.5)


/mob/living/carbon/Xenomorph/proc/recalculate_actions()
	recalculate_acid()
	recalculate_weeds()
	recalculate_gas()
	pull_multiplier = mutators.pull_multiplier
	if(isXenoRunner(src))
		//Xeno runners need a small nerf to dragging speed mutator
		pull_multiplier = 1.0 - (1.0 - mutators.pull_multiplier) * 0.85
	if(isXenoCarrier(src))
		huggers_max = mutators.carry_boost_level + caste.huggers_max
		eggs_max = mutators.carry_boost_level + caste.eggs_max


/mob/living/carbon/Xenomorph/proc/recalculate_acid()
	acid_level = caste.acid_level
	if(acid_level == 0)
		return //Caste does not use acid
	for(var/datum/action/xeno_action/activable/corrosive_acid/acid in actions)
		if(istype(acid))
			acid_level = caste.acid_level + mutators.acid_boost_level + hive.mutators.acid_boost_level
			if(acid_level > 3)
				acid_level = 3
			if(acid.level == acid_level)
				return //nothing to update, we're at the same level
			else
				//We are setting the new acid level and updating our action
				acid.level = acid_level
				acid.update_level()

/mob/living/carbon/Xenomorph/proc/recalculate_weeds()
	if(caste.weed_level == 0)
		return //Caste does not use weeds
	weed_level = caste.weed_level + mutators.weed_boost_level + hive.mutators.weed_boost_level
	if(weed_level < 1)
		weed_level = 1//need to maintain the minimum in case something goes really wrong

/mob/living/carbon/Xenomorph/proc/recalculate_pheromones()
	if(caste.aura_strength > 0)
		aura_strength = caste.aura_strength + mutators.pheromones_boost_level + hive.mutators.pheromones_boost_level
	else
		caste.aura_strength = 0

/mob/living/carbon/Xenomorph/proc/recalculate_gas()
	gas_level = upgrade + mutators.gas_boost_level

/mob/living/carbon/Xenomorph/proc/recalculate_maturation()
	upgrade_threshold =  round(caste.upgrade_threshold * hive.mutators.maturation_multiplier)
	evolution_threshold =  round(caste.evolution_threshold * hive.mutators.maturation_multiplier)
