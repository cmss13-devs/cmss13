
/mob/living/simple_animal/hostile/retaliate/playable
	see_in_dark = 50
	lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE

	var/base_icon_state = "Giant Lizard"
	var/icon_sleeping
	var/icon_knocked_down
	///Reference to the wound icon.
	var/atom/movable/vis_obj/wound_icon_holder

	///How far the mob is willing to chase before losing its target.
	var/max_attack_distance = 16
	///If 0, moves the mob out of attacking into idle state. Used to prevent the mob from chasing down targets that did not mean to hurt it.
	var/aggression_value = 0
	///Every type of structure that can get attacked in the DestroySurroundings() proc.
	var/list/destruction_targets = list(/obj/structure/mineral_door/resin, /obj/structure/window, /obj/structure/closet, /obj/structure/surface/table, /obj/structure/grille, /obj/structure/barricade, /obj/structure/machinery/door, /obj/structure/largecrate)

	///Emotes to play when being pet by a friend.
	var/list/pet_emotes = list("closes its eyes.", "growls happily.", "wags its tail.", "rolls on the ground.")
	///Cooldown to stop generic emote spam.
	COOLDOWN_DECLARE(emote_cooldown)
	///Cooldown for the growl emote.
	COOLDOWN_DECLARE(growl_message)

	///How many times the mob is going bleed in the Life() proc.
	var/bleed_ticks = 0
	///Chance of the mob laying down/getting up.
	var/chance_to_rest = 0
	///Is the mob currently running away from a target?
	var/is_retreating = FALSE
	///How many times have we attempted to retreat?
	var/retreat_attempts = 0
	///Tied directly to retreat_attempts. If our retreat fail, then we will completely stop trying to retreat for the length of this cooldown.
	COOLDOWN_DECLARE(retreat_cooldown)

	///Can this mob be tamed?
	var/tameable = TRUE

	///Cooldown for when the mob calms down, so the mob doesn't start attacking immediately after calming down.
	COOLDOWN_DECLARE(calm_cooldown)
	///A list of foods the mob is interested in eating. The mob will eat anything that has meat protein in it even if it's not in this list.
	var/list/acceptable_foods = list(/obj/item/reagent_container/food/snacks/mre_food, /obj/item/reagent_container/food/snacks/resin_fruit)
	///Is the mob currently eating the food_target?
	var/is_eating = FALSE
	///Cooldown dictating how long the mob will wait between eating food.
	COOLDOWN_DECLARE(food_cooldown)
	/// A weakref to the food object that the mob is trying to eat.
	var/datum/weakref/food_target_ref

	///Collision callbacks for the pounce proc.
	var/list/pounce_callbacks = list()
	///Length of the cooldown for pouncing.
	var/pounce_cooldown_length = 9 SECONDS
	///Cooldown for the pounce ability.
	COOLDOWN_DECLARE(pounce_cooldown)

	affected_by_fire = TRUE
	break_stuff_probability = 100
	attack_same = FALSE

	var/sound_growl
	var/sound_hiss
	var/sound_death

/mob/living/simple_animal/hostile/retaliate/playable/Initialize()
	. = ..()
	change_real_name(src, "[name] ([rand(1, 999)])")

	icon_state = "[base_icon_state] Running"
	icon_living = "[base_icon_state] Running"
	icon_knocked_down = "[base_icon_state] Knocked Down"
	icon_sleeping = "[base_icon_state] Sleeping"
	icon_dead = "[base_icon_state] Dead"

	wound_icon_holder = new(null, src)
	vis_contents += wound_icon_holder

	pounce_callbacks[/mob] = DYNAMIC(/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_mob_wrapper)
	pounce_callbacks[/turf] = DYNAMIC(/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_turf_wrapper)
	pounce_callbacks[/obj] = DYNAMIC(/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_obj_wrapper)
	set_languages(list(LANGUAGE_SIMPLEMOB))

	GLOB.giant_fauna_alive += src

//Immediately retaliate after being attacked.
/mob/living/simple_animal/hostile/retaliate/playable/Retaliate(pack_attack = FALSE)
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(stat == DEAD || get_dist(src, target_mob) < 6 || on_fire)
		return
	aggression_value = clamp(aggression_value + 5, 0, 15)

	. = ..()

	target_mob = FindTarget()
	target_mob_ref = WEAKREF(target_mob)
	if(!target_mob_ref)
		return

	growl(target_mob)
	MoveToTarget()

	if(pack_attack)
		return

	alert_others()

/mob/living/simple_animal/hostile/retaliate/playable/proc/alert_others()
	return

/mob/living/simple_animal/hostile/retaliate/playable/evaluate_target(mob/living/target)
	if(!..())
		return FALSE
	//we need to check for monkeys else these guys will tear up all the small hosts for xenos
	if(ismonkey(target))
		return FALSE
	return target

//Mobs in critical state are now fair game. Rip and tear.
/mob/living/simple_animal/hostile/retaliate/playable/SA_attackable(target_mob)
	if(isliving(target_mob))
		var/mob/living/target = target_mob
		//invisible mobs will still randomly be attacked regardless of this check if the lizard is in combat (intended)
		if(target.stat == DEAD || target.alpha <= 200 || !isturf(target.loc))
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/retaliate/playable/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user)) //simplemobs aren't coded to handle larva infection so we'll just let them know
		. += SPAN_DANGER("This is an unsuitable host for the hive.")
	return .

///Proc for growling.
/mob/living/simple_animal/hostile/retaliate/playable/proc/growl(target_mob, ignore_cooldown = FALSE)
	return

/mob/living/simple_animal/hostile/retaliate/playable/get_status_tab_items()
	. = ..()
	. += ""
	. += "Health: [floor(health)]/[floor(maxHealth)]"


//the AI gets funky when it gets stunned midcombat. this will help them get back into the fight more organically.
/mob/living/simple_animal/hostile/retaliate/playable/on_immobilized_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/retaliate/playable/on_knockedout_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/retaliate/playable/on_incapacitated_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/retaliate/playable/on_floored_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

///Proc for handling the AI post-status effect.
/mob/living/simple_animal/hostile/retaliate/playable/proc/find_target_on_trait_loss()
	update_transform()
	is_retreating = FALSE
	if(stance > HOSTILE_STANCE_ALERT)
		target_mob_ref = WEAKREF(FindTarget())
		MoveToTarget()

//regular pain datum will make the mob die when trying to pounce after taking enough damage.
/mob/living/simple_animal/hostile/retaliate/playable/initialize_pain()
	pain = new /datum/pain/simple_mob(src)

/mob/living/simple_animal/hostile/retaliate/playable/attack_hand(mob/living/carbon/human/attacking_mob)
	. = ..()
	process_attack_hand(attacking_mob)

/mob/living/simple_animal/hostile/retaliate/playable/attack_alien(mob/living/carbon/xenomorph/attacking_mob)
	. = ..()
	process_attack_hand(attacking_mob)

///Proc for handling attacking the lizard with a hand for BOTH XENOS AND HUMANS.
/mob/living/simple_animal/hostile/retaliate/playable/proc/process_attack_hand(mob/living/carbon/attacking_mob)
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
				manual_emote(pick(pick(pet_emotes), "stares at [attacking_mob].", "nuzzles [attacking_mob]."), "nibbles [attacking_mob]'s arm.")
	if(attacking_mob.a_intent == INTENT_DISARM && prob(25))
		playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
		KnockDown(0.4)

///Proc for moving to targets. walk_to() doesn't check for resting and status effects so we will do it ourselves.
/mob/living/simple_animal/hostile/retaliate/playable/proc/MoveTo(target, distance = 1, retreat = FALSE, time = 6 SECONDS, return_to_combat = FALSE)
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_FLOORED))
		return FALSE
	if(resting)
		set_resting(FALSE)
	if(!retreat)
		walk_to(src, target ? target : get_turf(src), distance, move_to_delay)
		return TRUE
	if(!is_retreating)
		is_retreating = TRUE
		stop_automated_movement = TRUE
		stance = HOSTILE_STANCE_ALERT
		walk_away(src, target ? target : get_turf(src), distance, PLAYBLE_SIMPLE_SPEED_RETREAT)
		addtimer(CALLBACK(src, PROC_REF(stop_retreat), return_to_combat), time)
		return TRUE

//Proc that's called after the retreat has run its course.
/mob/living/simple_animal/hostile/retaliate/playable/proc/stop_retreat(return_to_combat = FALSE)
	is_retreating = FALSE
	//extinguishing is top priority
	if(on_fire)
		resist_fire()
		return
	if(!return_to_combat)
		//can't retreat? go back to fighting
		if(retreat_attempts >= 2)
			target_mob_ref = WEAKREF(FindTarget())
			MoveToTarget()
			retreat_attempts = 0
			//seems like it's a life or death situation. we will stop trying to run away.
			COOLDOWN_START(src, retreat_cooldown, 20 SECONDS)
			return
		//don't stop retreating if there are non-friendly carbons in view
		for(var/mob/living/carbon/hostile_mob in view(7, src))
			if(hostile_mob.faction in faction_group)
				continue
			MoveTo(hostile_mob, 10, TRUE, 2 SECONDS, FALSE)
			retreat_attempts++
			return
		retreat_attempts = 0
		LoseTarget()
	else
		target_mob_ref = WEAKREF(FindTarget())
		MoveToTarget()

//Replaced walk_to() with MoveTo().
/mob/living/simple_animal/hostile/retaliate/playable/MoveToTarget()
	stop_automated_movement = TRUE
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(!target_mob || !SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(get_dist(src, target_mob) <= max_attack_distance)
		if(MoveTo(target_mob))
			stance = HOSTILE_STANCE_ATTACKING


//##############################################################################################
//######################################## DAMAGE/FIRE #########################################
//##############################################################################################
/mob/living/simple_animal/hostile/retaliate/playable/proc/special_attack(mob/living/target)
	return

/mob/living/simple_animal/hostile/retaliate/playable/resist_fire()
	visible_message(SPAN_NOTICE("[src] rolls frantically on the ground to extinguish itself!"))
	adjust_fire_stacks(-10)
	KnockDown(2)
	Stun(2)

//apply blood splatter when attacked by a sufficently damaging sharp weapon
/mob/living/simple_animal/hostile/retaliate/playable/attackby(obj/item/weapon, mob/living/carbon/human/attacker)
	if(weapon.force > 10 && weapon.sharp && attacker.a_intent != INTENT_HELP)
		handle_blood_splatter(get_dir(attacker.loc, loc))
	return ..()

/mob/living/simple_animal/hostile/retaliate/playable/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force, enviro)
	Retaliate()
	aggression_value = clamp(aggression_value + 5, 0, 30)
	. = ..()
	var/retreat_chance = abs((health / maxHealth * 100) - 100)
	if(prob(retreat_chance) && health <= maxHealth * 0.66 && COOLDOWN_FINISHED(src, retreat_cooldown))
		if(client && !is_retreating)
			is_retreating = TRUE
			to_chat(src, SPAN_USERDANGER("Your fight or flight response kicks in, run!"))
			speed = PLAYBLE_SIMPLE_SPEED_RETREAT_CLIENT
			addtimer(VARSET_CALLBACK(src, speed, PLAYBLE_SIMPLE_SPEED_NORMAL_CLIENT), 8 SECONDS)
			addtimer(VARSET_CALLBACK(src, is_retreating, FALSE), 8 SECONDS)
		else
			MoveTo(target_mob_ref?.resolve(), 12, TRUE, 4.5 SECONDS)
	if(damage >= 10 && damagetype == BRUTE)
		add_splatter_floor(loc, TRUE)
		bleed_ticks = clamp(bleed_ticks + ceil(damage / 10), 0, 30)
	update_wounds()

///Proc that forces the mob to disengage and try to extinguish itself. Will not be called if the mob is already retreating.
/mob/living/simple_animal/hostile/retaliate/playable/proc/try_to_extinguish()
	if(is_retreating || !on_fire || client || stat == DEAD || body_position == LYING_DOWN)
		return

	//forget EVERYTHING. we need to stop the flames!!!
	stance = HOSTILE_STANCE_ALERT
	target_mob_ref = null
	food_target_ref = null
	is_eating = FALSE
	manual_emote("hisses in agony!")
	playsound(src, "giant_lizard_hiss", 40)
	MoveTo(null, 9, TRUE, 4 SECONDS, FALSE)
	COOLDOWN_START(src, calm_cooldown, 8 SECONDS)

/mob/living/simple_animal/hostile/retaliate/playable/IgniteMob()
	. = ..()
	if(on_fire)
		try_to_extinguish()

/mob/living/simple_animal/hostile/retaliate/playable/handle_fire()
	. = ..()
	if(on_fire)
		try_to_extinguish()

/mob/living/simple_animal/hostile/retaliate/playable/bullet_act(obj/projectile/projectile)
	. = ..()
	if(projectile.damage)
		handle_blood_splatter(get_dir(projectile.starting, src))
		add_splatter_floor(loc, FALSE)

/mob/living/simple_animal/hostile/retaliate/playable/handle_blood_splatter(splatter_dir)
	var/obj/effect/bloodsplatter/human/bloodsplatter = new(loc, splatter_dir)
	bloodsplatter.pixel_y = -2


#define NO_WOUNDS 4
#define SMALL_WOUNDS 3
#define BIG_WOUNDS 2

/mob/living/simple_animal/hostile/retaliate/playable/proc/update_wounds()
	if(!wound_icon_holder)
		return

	wound_icon_holder.icon = icon

	var/health_threshold = max(ceil((health * 4) / (maxHealth)), 0) //From 0 to 4, in 25% chunks
	switch(health_threshold)
		if(NO_WOUNDS)
			health_threshold = "none"
		if(SMALL_WOUNDS)
			health_threshold = "Wounds Small"
		if(0 to BIG_WOUNDS)
			health_threshold = "Wounds Big"

	if(health > 0)
		if(health_threshold == "none")
			wound_icon_holder.icon_state = "none"
		else if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				wound_icon_holder.icon_state = "[base_icon_state] [health_threshold] Rest"
			else
				wound_icon_holder.icon_state = "[base_icon_state] [health_threshold] Stun"
		else
			wound_icon_holder.icon_state = "[base_icon_state] [health_threshold]"

#undef NO_WOUNDS
#undef SMALL_WOUNDS
#undef BIG_WOUNDS

//POUNCE PROCS AND WRAPPERS
///////////////////////////
/mob/living/simple_animal/hostile/retaliate/playable/proc/pounce(target)
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_FLOORED))
		return
	if(!COOLDOWN_FINISHED(src, pounce_cooldown))
		to_chat(src, SPAN_WARNING("You can't pounce again that fast! You need to wait [COOLDOWN_SECONDSLEFT(src, pounce_cooldown)] seconds."))
		return

	COOLDOWN_START(src, pounce_cooldown, pounce_cooldown_length)
	var/pounce_distance = clamp((get_dist(src, target)), 1, 5)
	manual_emote("pounces at [target]!")
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_atom), target, pounce_distance, SPEED_FAST, src, null, LOW_LAUNCH, PASS_OVER_THROW_MOB, null, pounce_callbacks)

/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_mob_wrapper(mob/living/pounced_mob)
	pounced_mob(pounced_mob)

/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_mob(mob/living/pounced_mob)
	if(stat == DEAD || pounced_mob.stat == DEAD || pounced_mob.mob_size >= MOB_SIZE_BIG || pounced_mob == src)
		throwing = FALSE
		return

	if(ishuman(pounced_mob) && (pounced_mob.dir in reverse_nearby_direction(dir)))
		var/mob/living/carbon/human/human = pounced_mob
		if(human.check_shields(15, "the pounce")) //Human shield block.
			visible_message(SPAN_DANGER("[src] slams into [human]!"))
			KnockDown(1)
			Stun(1)
			throwing = FALSE //Reset throwing manually.
			playsound(human, "bonk", 75, FALSE) //bonk
			return

		if(isyautja(human))
			if(human.check_shields(0, "the pounce", 1))
				visible_message(SPAN_DANGER("[human] blocks the pounce of [src] with the combistick!"))
				apply_effect(3, WEAKEN)
				throwing = FALSE
				playsound(human, "bonk", 75, FALSE)
				return
			else if(prob(75)) //Body slam.
				visible_message(SPAN_DANGER("[human] body slams [src]!"))
				KnockDown(3)
				Stun(3)
				throwing = FALSE
				playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
				return
		if(iscolonysynthetic(human) && prob(60))
			visible_message(SPAN_DANGER("[human] withstands being pounced and slams down [src]!"))
			KnockDown(1.5)
			Stun(1.5)
			throwing = FALSE
			playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
			return

	playsound(loc, "giant_lizard_hiss", 25)
	pounced_mob.KnockDown(0.5)
	step_to(src, pounced_mob)
	if(!client && !(pounced_mob.faction in faction_group))
		special_attack(pounced_mob)

/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_turf(turf/turf_target)
	if(!turf_target.density)
		for(var/mob/living/mob in turf_target)
			pounced_mob(mob)
			break
	else
		turf_launch_collision(turf_target)

/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_turf_wrapper(turf/turf_target)
	pounced_turf(turf_target)

/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_obj_wrapper(obj/O)
	pounced_obj(O)

/mob/living/simple_animal/hostile/retaliate/playable/proc/pounced_obj(obj/O)
	// Unconscious or dead, or not throwing but used pounce
	if(stat != CONSCIOUS)
		obj_launch_collision(O)
		return

	if(!istype(O, /obj/structure/surface/table) && !istype(O, /obj/structure/surface/rack))
		O.hitby(src) //This resets throwing.

//Middle mouse button/shift click to pounce.
/mob/living/simple_animal/hostile/retaliate/playable/click(atom/clicked_atom, list/mods)
	var/should_pounce = FALSE
	switch(get_ability_mouse_key())
		if(XENO_ABILITY_CLICK_SHIFT)
			if(mods[SHIFT_CLICK] && mods[LEFT_CLICK])
				should_pounce = TRUE
		if(XENO_ABILITY_CLICK_RIGHT)
			if(mods[RIGHT_CLICK])
				should_pounce = TRUE
		if(XENO_ABILITY_CLICK_MIDDLE)
			if(mods[MIDDLE_CLICK])
				should_pounce = TRUE

	if(should_pounce)
		pounce(clicked_atom)
		return TRUE

	return ..()

//################################################################################################
//########################################## FOOD STUFF ##########################################
//################################################################################################

///Proc for when the mob finds food and starts DEVOURING it.
/mob/living/simple_animal/hostile/retaliate/playable/proc/handle_food(obj/item/reagent_container/food/snacks/food)
	manual_emote("starts gnawing [food].")
	is_eating = TRUE
	for(var/times_to_eat = rand(4, 6), times_to_eat--)
		sleep(rand(1.7, 2.5) SECONDS)
		if(check_food_loc(food) || stance > HOSTILE_STANCE_ALERT || stat == DEAD)
			return
		face_atom(food)
		playsound(loc,'sound/items/eatfood.ogg', 25, 1)

	for(var/mob/living/carbon/nearest_mob in view(7, src))
		if(nearest_mob != food.last_dropped_by || (nearest_mob.faction in faction_group))
			continue
		face_atom(nearest_mob)
		manual_emote("stares curiously at [nearest_mob].")
		faction_group += nearest_mob.faction_group
		break

	health += maxHealth * 0.15
	update_wounds()
	qdel(food)
	food_target_ref = null
	is_eating = FALSE
	stance = HOSTILE_STANCE_IDLE
	COOLDOWN_START(src, food_cooldown, 30 SECONDS)

/mob/living/simple_animal/hostile/retaliate/playable/proc/handle_food_client(obj/item/reagent_container/food/snacks/food)
	manual_emote("starts gnawing [food].")
	playsound(loc,'sound/items/eatfood.ogg', 25, 1)
	is_eating = TRUE
	if(!do_after(src, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY))
		is_eating = FALSE
		return

	is_eating = FALSE
	if(!Adjacent(food))
		return

	playsound(loc,'sound/items/eatfood.ogg', 25, 1)
	health += maxHealth * 0.10
	update_wounds()
	qdel(food)

///Proc for checking if someone picked our food target.
/mob/living/simple_animal/hostile/retaliate/playable/proc/check_food_loc(obj/food)
	if(!ismob(food.loc))
		return

	var/mob/living/food_holder = food.loc
	stop_moving()
	COOLDOWN_START(src, food_cooldown, 15 SECONDS)
	food_target_ref = null
	is_eating = FALSE
	//snagging the food while you're right next to the mob makes it very angry
	if(get_dist(src, food_holder) <= 2 && !(food_holder.faction in faction_group))
		Retaliate()
		return TRUE

	growl(food.loc)
	stance = HOSTILE_STANCE_IDLE
	return TRUE

//Proc for when we lose our food target.
/mob/living/simple_animal/hostile/retaliate/playable/proc/lose_food()
	stance = HOSTILE_STANCE_IDLE
	food_target_ref = null
	is_eating = FALSE
	COOLDOWN_START(src, food_cooldown, 15 SECONDS)

//Do not stop hunting targets even if they're not visible anymore.
/mob/living/simple_animal/hostile/retaliate/playable/ListTargets(dist = 9)
	if(!length(enemies))
		return list()
	var/list/see = orange(src, dist)
	var/list/seen_enemies = list()
	// Remove all entries that aren't in enemies
	for(var/thing in see)
		if(WEAKREF(thing) in enemies)
			seen_enemies += thing
	return seen_enemies

//################################################################################################
//########################################## LIFE TICK ###########################################
//################################################################################################

/mob/living/simple_animal/hostile/retaliate/playable/Life(delta_time)
	//simplemobs don't have innate knockdown reduction so we'll just remove the status effects manually. works alright due to the 2 second delay on life()
	SetKnockOut(0)
	SetStun(0)
	SetKnockDown(0)
	if(aggression_value > 0)
		aggression_value--

	//it is possible for the mob to keep a target_mob saved, yet be stuck in alert stance and never lose said target.
	//this will cause it to be paralyzed and do nothing for the rest of its life, so this specific check is here to remedy that (hopefully)
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(!client && stance == HOSTILE_STANCE_ALERT && target_mob && !is_retreating && !on_fire)
		target_mob_ref = WEAKREF(FindTarget())
		MoveToTarget()

	if(resting && stat != DEAD)
		health += maxHealth * 0.05
		update_wounds()
		if(prob(33) && !HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			AddSleepingIcon()

	if(bleed_ticks)
		var/is_small_pool = FALSE
		if(bleed_ticks < 10)
			is_small_pool = TRUE
		bleed_ticks--
		add_splatter_floor(loc, is_small_pool)

	//done before the parent proccall because it would result in it moving before resting
	if(stance == HOSTILE_STANCE_IDLE && !client)
		stop_automated_movement = FALSE
		//if there's a friend on the same tile as us, don't bother getting up (cute!)
		var/mob/living/carbon/friend = locate(/mob/living/carbon) in get_turf(src)
		if((friend?.faction in faction_group) && resting)
			chance_to_rest = 0

		if(prob(chance_to_rest))
			set_resting(!resting)
			chance_to_rest = 0

		chance_to_rest += rand(1, 2)

	. = ..()

	if(client)
		return

	//if we haven't gotten hurt in a while, calm down and go back to idling
	if(aggression_value == 0 && stance == HOSTILE_STANCE_ATTACKING)
		enemies = list()
		LoseTarget()
		if(COOLDOWN_FINISHED(src, emote_cooldown))
			manual_emote("calms down.")
			COOLDOWN_START(src, calm_cooldown, 4 SECONDS)
			COOLDOWN_START(src, emote_cooldown, 3 SECONDS)

	//no longer interested in food when we're in combat
	if(stance > HOSTILE_STANCE_ALERT)
		is_eating = FALSE

	//if we're resting and something catches our interest, get up
	if(stance != HOSTILE_STANCE_IDLE && resting)
		set_resting(FALSE)

	if(target_mob && !is_retreating && target_mob.stat == CONSCIOUS && stance == HOSTILE_STANCE_ATTACKING && COOLDOWN_FINISHED(src, pounce_cooldown) && (prob(75) || get_dist(src, target_mob) <= 5) && (target_mob in view(5, src)))
		pounce(target_mob)

	//if we're trying to get away and there's obstacles around us, try to break them
	if(target_mob && is_retreating && stance >= HOSTILE_STANCE_ALERT && destroy_surroundings)
		INVOKE_ASYNC(src, PROC_REF(DestroySurroundings))

	if(target_mob || on_fire)
		return

	//if we are retreating, but we don't have any targets or we're not on fire, stop retreating
	if(is_retreating)
		stop_moving()
		stance = HOSTILE_STANCE_IDLE

	//if we're hungry and we don't have already have our eyes on a snack, try eating food if possible
	var/obj/item/reagent_container/food/snacks/food_target = food_target_ref?.resolve()
	if(tameable && !food_target && COOLDOWN_FINISHED(src, food_cooldown))
		for(var/obj/item/reagent_container/food/snacks/food in view(6, src))
			var/is_meat = locate(/datum/reagent/nutriment/meat) in food.reagents.reagent_list

			if(is_meat || is_type_in_list(food, acceptable_foods))
				food_target_ref = WEAKREF(food)
				if(!food_target) // qdeleted check
					continue
				stance = HOSTILE_STANCE_ALERT
				stop_automated_movement = TRUE
				MoveTo(food_target)
				break

	//handling mobs that are invading our personal space
	if(stance <= HOSTILE_STANCE_ALERT && !food_target && COOLDOWN_FINISHED(src, calm_cooldown))
		var/intruder_in_sight = FALSE
		for(var/mob/living/carbon/intruder in view(5, src))
			if((intruder.faction in faction_group) || intruder.stat != CONSCIOUS || ismonkey(intruder) || intruder.alpha <= 200)
				continue

			intruder_in_sight = TRUE
			face_atom(intruder)
			stance = HOSTILE_STANCE_ALERT
			stop_automated_movement = TRUE
			if(get_dist(src, intruder) == 3)
				growl(intruder)
			else if(get_dist(src, intruder) <= 2)
				Retaliate()
				COOLDOWN_START(src, pounce_cooldown, 1 SECONDS)
				break

		if(!intruder_in_sight && stance == HOSTILE_STANCE_ALERT)
			stance = HOSTILE_STANCE_IDLE

	//if we have a snack that we want to eat, but we're not munching on it currently, check if it's close to us.
	if(food_target && !is_eating)
		if(!(food_target in view(5, src)))
			stop_moving()
			lose_food()
		//if the food is next to us AND not in the hands of a mob, start eating
		else if(!check_food_loc(food_target) && Adjacent(food_target))
			INVOKE_ASYNC(src, PROC_REF(handle_food), food_target)


/mob/living/simple_animal/hostile/retaliate/playable/rejuvenate()
	//if the mob was dead beforehand, it's now alive and therefore it's an extra lizard to the count
	if(stat == DEAD)
		GLOB.giant_fauna_alive += src
	return ..()

/mob/living/simple_animal/hostile/retaliate/playable/death(datum/cause_data/cause_data, gibbed = FALSE, deathmessage = "lets out a waning growl....")
	playsound(loc, sound_death, 70)
	GLOB.giant_fauna_alive -= src
	return ..()

/mob/living/simple_animal/hostile/retaliate/playable/Destroy()
	GLOB.giant_fauna_alive -= src
	return ..()
