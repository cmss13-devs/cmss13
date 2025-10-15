#define ATTACK_SLASH 0
#define ATTACK_BITE 1

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard
	name = "giant lizard"
	desc = "A large, wolf-like reptile. Its eyes are keenly focused on yours."
	icon = 'icons/mob/mob_64.dmi'

	base_icon_state = "Giant Lizard"

	mob_size = MOB_SIZE_XENO_SMALL
	maxHealth = 350
	health = 350
	icon_size = 64
	pixel_x = -16
	old_x = -16
	base_pixel_x = 0
	base_pixel_y = -20
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	move_to_delay = PLAYBLE_SIMPLE_SPEED_NORMAL
	speed = PLAYBLE_SIMPLE_SPEED_NORMAL_CLIENT //speed and move_to_delay are not the same in simplemob code (wow!)

	response_help = "pets"
	response_disarm = "tries to push away"
	response_harm  = "punches"
	friendly = "nuzzles"

	speak_chance = 2
	speak_emote = "hisses"
	emote_hear = list("hisses.", "growls.", "roars.", "bellows.")
	emote_see = list("shakes its head.", "wags its tail.", "yawns.")

	melee_damage_lower = 20
	melee_damage_upper = 25
	langchat_color = LIGHT_COLOR_GREEN

	sound_growl = "giant_lizard_growl"
	sound_hiss = "giant_lizard_hiss"
	sound_death = 'sound/effects/giant_lizard_death.ogg'

	///Reference to the ZZzzz sleep overlay when resting.
	var/sleep_overlay
	///Reference to the tongue flick overlay.
	var/atom/movable/vis_obj/giant_lizard_icon_holder/tongue_icon_holder

	///Are we currently mauling a mob after pouncing them? Used to stop normal attacks on pounced targets.
	var/is_ravaging = FALSE

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/desert
	base_icon_state = "Desert Lizard"

//For displaying wound states, and the tongue flicker.
/atom/movable/vis_obj/giant_lizard_icon_holder
	icon = 'icons/mob/mob_64.dmi'

//Due to being constrained to 64x64, we need to change the icon's offsets manually whenever the mob's dir is changed.
//apparantly movement sets both olddir and newdir to the same value, in comparison to manually switching facing which returns the right values.
//i don't know if there's any worthwhile performance gain in having a second signal exclusively for movement so we can check if the olddir and newdir are same.
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/proc/change_tongue_offset(datum/source, olddir, newdir)
	SIGNAL_HANDLER

	if(!newdir)
		newdir = dir

	switch(newdir)
		if(WEST)
			if(resting)
				tongue_icon_holder.pixel_x = 7
				tongue_icon_holder.pixel_y = -4
				return

			tongue_icon_holder.pixel_x = -2
			tongue_icon_holder.pixel_y = 0

		if(EAST)
			if(resting)
				tongue_icon_holder.pixel_x = -7
				tongue_icon_holder.pixel_y = -4
				return

			tongue_icon_holder.pixel_x = 2
			tongue_icon_holder.pixel_y = 0
		if(SOUTH)
			tongue_icon_holder.pixel_x = 0
			tongue_icon_holder.pixel_y = 0
	//there is no north facing tongue animation

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/face_dir(ndir, specific_dir)
	//there is no north or south facing rest sprite, so updating the direction would mess up tongue flicking.
	if(resting && (ndir == NORTH || ndir == SOUTH))
		return
	return ..()

//we also have to check for the keybind apparantly...
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/keybind_face_direction(direction)
	if(resting && (direction == NORTH || direction == SOUTH))
		return
	return ..()

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/Initialize()
	. = ..()
	tongue_icon_holder = new(null, src)
	tongue_icon_holder.pixel_x = 2
	vis_contents += tongue_icon_holder

	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(change_tongue_offset))

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/initialize_pass_flags(datum/pass_flags_container/pass_flags_container)
	..()
	if(pass_flags_container)
		pass_flags_container.flags_pass |= PASS_FLAGS_CRAWLER

///Proc for growling.
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/growl(target_mob, ignore_cooldown = FALSE)
	if(!COOLDOWN_FINISHED(src, growl_message) && !ignore_cooldown)
		return
	if(target_mob)
		manual_emote("growls at [target_mob].")
	else
		manual_emote("growls.")
	playsound(loc, sound_growl, 60)
	COOLDOWN_START(src, growl_message, rand(10, 14) SECONDS)

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/get_status_tab_items()
	. = ..()
	if(!COOLDOWN_FINISHED(src, pounce_cooldown))
		. += "Pounce Cooldown: [COOLDOWN_SECONDSLEFT(src, pounce_cooldown)] seconds"

//procs for handling sleeping icons when resting
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/AddSleepingIcon()
	var/image/sleeping_icon = new('icons/mob/hud/hud.dmi', "slept_icon_centered")
	if(sleep_overlay)
		return
	sleep_overlay = sleeping_icon
	overlays += sleep_overlay
	addtimer(CALLBACK(src, PROC_REF(RemoveSleepingIcon)), 6 SECONDS)

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/RemoveSleepingIcon()
	if(sleep_overlay)
		overlays -= sleep_overlay
		sleep_overlay = null

//The parent proc sets the stance to IDLE which will break the AI if it's in combat
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/stop_moving()
	walk_to(src, 0)

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/update_transform(instant_update = FALSE)
	tongue_icon_holder.alpha = alpha
	if(stat == DEAD)
		icon_state = icon_dead
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = icon_sleeping
		else
			icon_state = icon_knocked_down
			tongue_icon_holder.alpha = 0
			//we can't stop an animation that's called via flick(). best we can do is hide it.
	else
		icon_state = icon_living
	update_wounds()
	change_tongue_offset()
	return ..()


/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/get_examine_text(mob/user)
	. = ..()
	if(stat == DEAD || user == src)
		desc = "A large, wolf-like reptile."
		if(user == src)
			. += SPAN_NOTICE("\nRest on the ground to restore 5% of your health every second.")
			. += SPAN_NOTICE("You're able to pounce targets by using [get_ability_mouse_name()].")
			. += SPAN_NOTICE("You will aggressively maul targets that are prone. Any click on yourself will be passed down to mobs below you, so feel free to click on your sprite in order to attack pounced targets.")
	else if((user.faction in faction_group))
		desc = "[initial(desc)] There's a hint of warmth in them."
	else
		desc = initial(desc)
	if(isxeno(user)) //simplemobs aren't coded to handle larva infection so we'll just let them know
		. += SPAN_DANGER("This is an unsuitable host for the hive.")
	return .

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/set_resting(new_resting, silent, instant)
	. = ..()
	//north and south rest sprites don't exist, we need to set it to WEST for tongue flicks to work properly
	if(resting && dir == NORTH || dir == SOUTH)
		setDir(WEST)
	if(!resting)
		RemoveSleepingIcon()
	update_transform()



///Proc for handling attacking the lizard with a hand for BOTH XENOS AND HUMANS.
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/process_attack_hand(mob/living/carbon/attacking_mob)
	if(stat == DEAD)
		return

	if(!(attacking_mob.faction in faction_group) && !is_eating)
		Retaliate()

	if(attacking_mob.a_intent == INTENT_HELP && (attacking_mob.faction in faction_group))
		if(on_fire)
			adjust_fire_stacks(-5, min_stacks = 0)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
			visible_message(SPAN_DANGER("[attacking_mob] tries to put out the fire on [src]!"),
			SPAN_WARNING("You try to put out the fire on [src]!"), null, 5)
			if(fire_stacks <= 0)
				visible_message(SPAN_DANGER("[attacking_mob] has successfully extinguished the fire on [src]!"),
				SPAN_NOTICE("You extinguished the fire on [src]."), null, 5)
			return
		if(!resting)
			chance_to_rest += 15
		if(resting)
			chance_to_rest = 0
			if(COOLDOWN_FINISHED(src, emote_cooldown))
				COOLDOWN_START(src, emote_cooldown, rand(5, 8) SECONDS)
				manual_emote(pick(pick(pet_emotes), "stares at [attacking_mob].", "nuzzles [attacking_mob].", "licks [attacking_mob]'s hand."), "nibbles [attacking_mob]'s arm.")
				if(prob(50))
					playsound(loc, sound_hiss, 25)
					flick("Giant Lizard Tongue", tongue_icon_holder)
	if(attacking_mob.a_intent == INTENT_DISARM && prob(25))
		playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
		KnockDown(0.4)



/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/Life(delta_time)
	if(stat != DEAD && !HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED) && prob(25))
		flick("Giant Lizard Tongue", tongue_icon_holder)
	..()

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/AttackingTarget(inherited_target = target_mob_ref?.resolve())
	if(!Adjacent(inherited_target) || is_ravaging || body_position == LYING_DOWN)
		return

	if(isliving(inherited_target))
		var/mob/living/target = inherited_target
		if(target.stat == DEAD)
			to_chat(src, SPAN_WARNING("[target] is dead. There's nothing interesting about a corpse."))
			return
		//decimate mobs that are on the ground
		if(target.body_position == LYING_DOWN)
			special_attack(target)
			return target

		face_atom(target)
		var/attack_type = pick(ATTACK_SLASH, ATTACK_BITE)
		attacktext = attack_type ? "claws" : "bites"
		flick_attack_overlay(target, attack_type ? "slash" : "animalbite")
		playsound(loc, attack_type ? "alien_claw_flesh" : "alien_bite", 25, 1)
		target.attack_animal(src)
		animation_attack_on(target)

		//xenos take extra damage
		if(isxeno(target))
			var/extra_damage = rand(melee_damage_lower, melee_damage_upper) * 0.33
			target.apply_damage(extra_damage, BRUTE, enviro=TRUE)

		if(prob(33))
			if(client && !is_retreating)
				is_retreating = TRUE
				to_chat(src, SPAN_USERDANGER("You gain a rush of speed!"))
				speed = PLAYBLE_SIMPLE_SPEED_RETREAT_CLIENT
				addtimer(VARSET_CALLBACK(src, speed, PLAYBLE_SIMPLE_SPEED_NORMAL_CLIENT), 2 SECONDS)
				addtimer(VARSET_CALLBACK(src, is_retreating, FALSE), 2 SECONDS)
			else
				MoveTo(target_mob_ref?.resolve(), 8, TRUE, 2 SECONDS, TRUE) //skirmish around our target
		return target

	if(isStructure(inherited_target))
		var/obj/structure/structure = inherited_target
		if(structure.unslashable)
			return

		var/is_xeno_structure = FALSE
		if(structure.flags_obj & OBJ_ORGANIC)
			is_xeno_structure = TRUE

		animation_attack_on(structure)
		playsound(loc, is_xeno_structure ? "alien_resin_break" : 'sound/effects/metalhit.ogg', 25)
		visible_message(SPAN_DANGER("[src] slashes [structure]!"), SPAN_DANGER("You slash [structure]!"), null, 5, CHAT_TYPE_COMBAT_ACTION)
		var/damage_multiplier = 2
		if(is_xeno_structure)
			damage_multiplier = !client ? 15 : 5 //ai mobs need that extra oomph else they won't be able to break anything before they die
		structure.update_health(rand(melee_damage_lower, melee_damage_upper) * damage_multiplier)
		return

	if(client && !is_eating && istype(inherited_target, /obj/item/reagent_container/food/snacks))
		handle_food_client(inherited_target)
		return

	//if it's not an object or a structure, just swipe at it
	animation_attack_on(inherited_target)
	visible_message(SPAN_DANGER("[src] swipes at [inherited_target]!"), SPAN_DANGER("You swipe at [inherited_target]!"), null, 5, CHAT_TYPE_COMBAT_ACTION)
	playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 10, 1)

//Used to handle attacks when a client is in the mob. Otherwise we'd default to a generic animal attack.
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/UnarmedAttack(atom/target)
	var/tile_attack = FALSE
	if(target == src) //Clicking self.
		target = get_turf(src)
		tile_attack = TRUE

	if(isturf(target) && tile_attack)
		var/turf/our_turf = target
		for(var/mob/living/targets in our_turf)
			if(targets == src)
				continue
			target = targets
			break

	AttackingTarget(target)
	//turf attacks are missed attacks so it should just be a minor penalty to attack delay
	next_move = isturf(target) ? world.time + 4 : world.time + 8

/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/DestroySurroundings()
	if(!prob(break_stuff_probability))
		return

	for(var/obj/structure/obstacle in view(1, src))
		if(is_type_in_list(obstacle, destruction_targets))
			AttackingTarget(obstacle)
			return

//no longer checks for distance with ListTargets(). threshold for losing targets is increased, due to needing range for skirmishing
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/AttackTarget()
	stop_automated_movement = TRUE
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(!target_mob || !SA_attackable(target_mob))
		LoseTarget()
		return
	if(get_dist(src, target_mob) > max_attack_distance)
		LoseTarget()
		return
	if(in_range(src, target_mob)) //Attacking
		AttackingTarget()
		return TRUE




/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/alert_others()
	for(var/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/pack_member in GLOB.giant_fauna_alive)
		if(pack_member == src || pack_member.target_mob_ref?.resolve() || get_dist(src, pack_member) > 7)
			continue
		pack_member.Retaliate(pack_attack = TRUE)


///Ravaging attack, used for when a mob gets pounced or is on the ground.
/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/special_attack(mob/living/target)
	if(is_ravaging || !isliving(target))
		return
	is_ravaging = TRUE
	visible_message(SPAN_DANGER("<B>[src]</B> tears into [target] repeatedly!"))

	var/successful_attacks = 0
	for(var/times_to_attack = 3, times_to_attack > 0, times_to_attack--)
		//we got stunned, so we can ravage no longer
		if(body_position == LYING_DOWN)
			is_ravaging = FALSE
			return

		if(Adjacent(target))
			var/damage = rand(melee_damage_lower, melee_damage_upper) * 0.4
			//xenos take extra damage
			if(isxeno(target))
				damage *= 1.33
			var/attack_type = pick(ATTACK_SLASH, ATTACK_BITE)
			attacktext = attack_type ? "claws" : "bites"
			flick_attack_overlay(target, attack_type ? "slash" : "animalbite")
			playsound(loc, attack_type ? "alien_claw_flesh" : "alien_bite", 25, 1)
			target.handle_blood_splatter(get_dir(src.loc, target.loc))

			if(target.body_position == LYING_DOWN)
				target.apply_damage(damage, BRUTE, enviro=TRUE)
				target.apply_effect(1, DAZE)
				shake_camera(target, 1, 2)

			animation_attack_on(target)
			face_atom(target)
			sleep(0.5 SECONDS)
			successful_attacks++

	if(successful_attacks == 3 && !COOLDOWN_FINISHED(src, pounce_cooldown))
		to_chat(src, SPAN_BOLDWARNING("The bloodlust invigorates you! You will be ready to pounce much sooner."))
		COOLDOWN_START(src, pounce_cooldown, COOLDOWN_TIMELEFT(src, pounce_cooldown) * 0.5)
	is_ravaging = FALSE


///CLIENT EMOTES
////////////////

/datum/emote/living/giant_lizard
	mob_type_allowed_typecache = list(/mob/living/simple_animal/hostile/retaliate/playable/giant_lizard)

/datum/emote/living/giant_lizard/growl
	key = "growl"
	message = "growls."
	sound = "giant_lizard_growl"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/giant_lizard/hiss
	key = "hiss"
	message = "hisses."
	sound = "giant_lizard_hiss"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/giant_lizard/flicktongue
	key = "flicktongue"
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/giant_lizard/flicktongue/run_emote(mob/living/simple_animal/hostile/retaliate/playable/giant_lizard/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return

	flick("Giant Lizard Tongue", user.tongue_icon_holder)

#undef ATTACK_SLASH
#undef ATTACK_BITE
