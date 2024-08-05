#define ATTACK_SLASH 0
#define ATTACK_BITE 1
#define LIZARD_SPEED_NORMAL 3
#define LIZARD_SPEED_RETREAT 2.5

/mob/living/simple_animal/hostile/retaliate/giant_lizard
	name = "giant lizard"
	desc = "A large, wolf-like reptile. Its eyes are keenly focused on yours."
	icon = 'icons/mob/mob_64.dmi'
	icon_state = "Giant Lizard Running"
	icon_living = "Giant Lizard Running"
	icon_dead = "Giant Lizard Dead"
	mob_size = MOB_SIZE_XENO_SMALL
	maxHealth = 350
	health = 350
	icon_size = 64
	pixel_x = -16
	old_x = -16
	base_pixel_x = 0
	base_pixel_y = -20
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	affected_by_fire = TRUE
	move_to_delay = LIZARD_SPEED_NORMAL
	speed = LIZARD_SPEED_NORMAL //speed and move_to_delay are not the same in simplemob code (wow!)

	response_help = "pets"
	response_disarm = "tries to push away"
	response_harm  = "punches"
	see_in_dark = 50

	speak_chance = 2
	speak_emote = "hisses"
	emote_hear = list("hisses.", "growls.", "roars.", "bellows.")
	emote_see = list("shakes its head.", "wags its tail.", "flicks its tongue.", "yawns.")

	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_same = FALSE

	///If 0, moves the mob out of attacking into idle state. Used to prevent the mob from chasing down targets that did not mean to hurt it.
	var/aggression_value = 0

	///What sounds to play when the mob growls.
	var/list/growl_sounds = list('sound/effects/giant_lizard_growl1.ogg', 'sound/effects/giant_lizard_growl2.ogg')
	///What sounds to play when hissing. Mostly used for when being pet.
	var/list/hiss_sounds = list('sound/effects/giant_lizard_hiss1.ogg', 'sound/effects/giant_lizard_hiss2.ogg')

	///Emotes to play when being pet by a friend.
	var/list/pet_emotes = list("closes its eyes.", "growls happily.", "wags its tail.", "stares.", "rolls on the ground.")
	///Cooldown to stop generic emote spam.
	COOLDOWN_DECLARE(emote_cooldown)

	///Collision callbacks for the pounce proc.
	var/list/pounce_callbacks = list()
	///Are we currently mauling a mob after pouncing them? Used to stop normal attacks on pounced targets.
	var/is_ravaging = FALSE
	///Cooldown for the pounce ability.
	COOLDOWN_DECLARE(pounce_cooldown)

	///How many times the mob is going bleed in the Life() proc.
	var/bleed_ticks = 0
	///Chance of the mob laying down/getting up.
	var/chance_to_rest = 0
	///Is the mob currently running away from a target?
	var/is_retreating = FALSE

	///The food object that the mob is trying to eat.
	var/food_target
	///A list of foods the mob is interested in eating.
	var/list/acceptable_foods = list(/obj/item/reagent_container/food/snacks/meat, /obj/item/reagent_container/food/snacks/packaged_meal, /obj/item/reagent_container/food/snacks/resin_fruit)
	///Is the mob currently eating the food_target?
	var/is_eating = FALSE
	///Cooldown dictating how long the mob will wait between eating food.
	COOLDOWN_DECLARE(food_cooldown)

	///Cooldown for the growl emote.
	COOLDOWN_DECLARE(growl_message)
	///Cooldown for when the mob calms down, so the mob doesn't start attacking immediately after calming down.
	COOLDOWN_DECLARE(calm_cooldown)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/Initialize()
	. = ..()
	pounce_callbacks[/mob] = DYNAMIC(/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_mob_wrapper)
	pounce_callbacks[/turf] = DYNAMIC(/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_turf_wrapper)
	pounce_callbacks[/obj] = DYNAMIC(/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_obj_wrapper)


//regular pain datum will make the mob die when trying to pounce after taking enough damage.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/initialize_pain()
	pain = new /datum/pain/xeno(src)

///Proc for growling.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/growl(target_mob, ignore_cooldown = FALSE)
	if(!COOLDOWN_FINISHED(src, growl_message) && !ignore_cooldown)
		return
	if(target_mob)
		manual_emote("growls at [target_mob].")
	else
		manual_emote("growls.")
	playsound(loc, growl_sounds, 60)
	COOLDOWN_START(src, growl_message, rand(10, 14) SECONDS)

//the AI gets funky when it gets stunned midcombat. this will help them get back into the fight more organically.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/on_immobilized_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/on_knockedout_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/on_incapacitated_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/find_target_on_trait_loss()
	if(stance > HOSTILE_STANCE_ALERT)
		FindTarget()
		MoveToTarget()

//procs for handling sleeping icons when resting
/mob/living/simple_animal/hostile/retaliate/giant_lizard/AddSleepingIcon()
	var/image/SL
	SL = new /image('icons/mob/hud/hud.dmi', "slept_icon")
	if(SL in overlays)
		return
	overlays += SL
	addtimer(CALLBACK(src, PROC_REF(RemoveSleepingIcon)), 3 SECONDS)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/RemoveSleepingIcon()
	var/image/SL
	SL = new /image('icons/mob/hud/hud.dmi', "slept_icon")
	overlays -= SL

//The parent proc sets the stance to IDLE which will break the AI if it's in combat
/mob/living/simple_animal/hostile/retaliate/giant_lizard/stop_moving()
	walk_to(src, 0)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/update_transform(instant_update = FALSE)
	if(stat == DEAD)
		icon_state = icon_dead
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = "Giant Lizard Sleeping"
		else
			icon_state = "Giant Lizard Knocked Down"
	else
		icon_state = icon_living
	return ..()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/get_examine_text(mob/user)
	if(stat == DEAD)
		desc = "A large, wolf-like reptile."
	else if(user.faction in faction_group)
		desc = "[initial(desc)] There's a hint of warmth in them."
	else
		desc = initial(desc)
	return ..()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/set_resting(new_resting, silent, instant)
	. = ..()
	if(!resting)
		RemoveSleepingIcon()
	update_transform()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/death()
	playsound(loc, 'sound/effects/giant_lizard_death.ogg', 70)
	manual_emote("lets out a waning growl.")
	return ..()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/attack_hand(mob/living/carbon/human/attacking_mob)
	. = ..()
	if(attacking_mob.a_intent == INTENT_HELP && (attacking_mob.faction in faction_group))
		if(!resting)
			chance_to_rest += 15
		if(resting)
			chance_to_rest = 0
			if(COOLDOWN_FINISHED(src, emote_cooldown))
				COOLDOWN_START(src, emote_cooldown, rand(5, 8) SECONDS)
				manual_emote(pick(pet_emotes))
				if(prob(50))
					playsound(loc, hiss_sounds, 25)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force)
	Retaliate()
	aggression_value = clamp(aggression_value + 5, 0, 30)
	. = ..()
	var/retreat_chance = abs((health / maxHealth * 100) - 100)
	if(prob(retreat_chance))
		MoveTo(target_mob, 12, TRUE, 8 SECONDS)
	if(damage >= 10 && damagetype == BRUTE)
		add_splatter_floor(loc, TRUE)
		bleed_ticks = clamp(bleed_ticks + ceil(damage / 10), 0, 30)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/Life(delta_time)
	//simplemobs don't have knockdown reduction so we'll manually remove it if applicable. works well due to Life() delay.
	SetKnockDown(0)
	if(aggression_value > 0) aggression_value--

	//if we haven't gotten hurt in a while, calm down and go back to idling
	if(aggression_value == 0 && stance == HOSTILE_STANCE_ATTACKING)
		enemies = new()
		LoseTarget()
		if(COOLDOWN_FINISHED(src, emote_cooldown))
			manual_emote("calms down.")
			COOLDOWN_START(src, calm_cooldown, 4 SECONDS)
			COOLDOWN_START(src, emote_cooldown, 3 SECONDS)

	if(resting)
		health += maxHealth * 0.05
		if(prob(33))
			AddSleepingIcon()

	if(stance > HOSTILE_STANCE_ALERT)
		is_eating = FALSE

	if(stance == HOSTILE_STANCE_IDLE)
		stop_automated_movement = FALSE
		//if there's a friend on the same tile as us, don't bother getting up (cute!)
		var/mob/living/carbon/friend = locate(/mob/living/carbon) in get_turf(src)
		if((friend?.faction in faction_group) && resting)
			chance_to_rest = 0

		if(prob(chance_to_rest))
			set_resting(!resting)
			chance_to_rest = 0

		chance_to_rest += rand(1, 2)

	if(stance != HOSTILE_STANCE_IDLE && resting)
		set_resting(FALSE)

	if(bleed_ticks)
		var/is_small_pool = FALSE
		if(bleed_ticks < 10) is_small_pool = TRUE
		bleed_ticks -= is_small_pool ? 1 : 2
		add_splatter_floor(loc, is_small_pool)

	if(!target_mob)
		if(is_retreating)
			stop_moving()
			stance = HOSTILE_STANCE_IDLE

		if(!food_target && COOLDOWN_FINISHED(src, food_cooldown))
			for(var/obj/item/reagent_container/food/snacks/food in view(6, src))
				if(!is_type_in_list(food, acceptable_foods))
					continue
				food_target = food
				stance = HOSTILE_STANCE_ALERT
				stop_automated_movement = TRUE
				MoveTo(food_target)
				break

		if(stance <= HOSTILE_STANCE_ALERT && !food_target && COOLDOWN_FINISHED(src, calm_cooldown))
			var/intruder_in_sight = FALSE
			for(var/mob/living/carbon/intruder in view(5, src))
				if((intruder.faction in faction_group) || intruder.stat != CONSCIOUS || ismonkey(intruder))
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

		if(food_target && !is_eating)
			if(!(food_target in view(5, src)))
				stop_moving()
				lose_food()
			else if(!check_food_loc(food_target) && Adjacent(food_target))
				INVOKE_ASYNC(src, PROC_REF(handle_food), food_target)

	. = ..()

	if(target_mob && !is_retreating && target_mob.stat == CONSCIOUS && stance == HOSTILE_STANCE_ATTACKING && COOLDOWN_FINISHED(src, pounce_cooldown) && (prob(75) || get_dist(src, target_mob) <= 5) && (target_mob in view(5, src)))
		pounce()
		COOLDOWN_START(src, pounce_cooldown, rand(8, 12) SECONDS)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bullet_act(obj/projectile/projectile)
	. = ..()
	if(projectile.damage)
		handle_blood_splatter(get_dir(projectile.starting, src))
		add_splatter_floor(loc, FALSE)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/handle_blood_splatter(splatter_dir)
	var/obj/effect/temp_visual/dir_setting/bloodsplatter/human/bloodsplatter = new(loc, splatter_dir)
	bloodsplatter.pixel_y = -2

/mob/living/simple_animal/hostile/retaliate/giant_lizard/AttackingTarget()
	if(!Adjacent(target_mob) || is_ravaging)
		return

	if(isliving(target_mob))
		var/mob/living/target = target_mob
		//decimate mobs that are in crit
		if(target.stat == UNCONSCIOUS)
			ravagingattack()
			return target

		face_atom(target)
		var/attack_type = pick(ATTACK_SLASH, ATTACK_BITE)
		attacktext = attack_type ? "claws" : "bites"
		flick_attack_overlay(target, attack_type ? "slash" : "animalbite")
		playsound(loc, attack_type ? "alien_claw_flesh" : "alien_bite", 25, 1)
		target.attack_animal(src)
		animation_attack_on(target)

		if(prob(33))
			MoveTo(target_mob, 8, TRUE, 2 SECONDS, TRUE) //skirmish around our target
		return target

///Proc for when the mob finds food and starts DEVOURING it.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/handle_food(obj/item/reagent_container/food/snacks/food)
	manual_emote("starts gnawing [food].")
	is_eating = TRUE
	for(var/times_to_eat = rand(4, 6), times_to_eat--)
		sleep(rand(1.7, 2.5) SECONDS)
		if(check_food_loc(food) || stance > HOSTILE_STANCE_ALERT)
			return
		face_atom(food)
		playsound(loc,'sound/items/eatfood.ogg', 25, 1)

	for(var/mob/living/carbon/nearest_mob in view(7, src))
		if(nearest_mob != food.last_dropped_by || (nearest_mob in faction_group))
			continue
		face_atom(nearest_mob)
		manual_emote("stares curiously at [nearest_mob].")
		faction_group += nearest_mob.faction_group
		break

	qdel(food)
	food_target = null
	is_eating = FALSE
	stance = HOSTILE_STANCE_IDLE
	COOLDOWN_START(src, food_cooldown, 30 SECONDS)

///Proc for checking if someone picked our food target.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/check_food_loc(obj/food)
	if(ismob(food.loc))
		var/mob/living/food_holder = food.loc
		stop_moving()
		COOLDOWN_START(src, food_cooldown, 15 SECONDS)
		food_target = null
		is_eating = FALSE
		//snagging the food while you're right next to the mob makes it very angry
		if(get_dist(src, food_holder) <= 2 && !(food_holder.faction in faction_group))
			Retaliate()
			return TRUE

		growl(food.loc)
		stance = HOSTILE_STANCE_IDLE
		return TRUE

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/lose_food()
	stance = HOSTILE_STANCE_IDLE
	food_target = null
	is_eating = FALSE
	COOLDOWN_START(src, food_cooldown, 15 SECONDS)

//Do not stop hunting targets even if they're not visible anymore.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/ListTargets(dist = 9)
	if(!enemies.len)
		return list()
	var/list/see = orange(src, dist)
	see &= enemies
	return see

/mob/living/simple_animal/hostile/retaliate/giant_lizard/evaluate_target(mob/living/target)
	//we need to check for monkeys else these guys will tear up all the small hosts for xenos
	if((target.faction == faction || (target.faction in faction_group)) && !attack_same || ismonkey(target))
		return FALSE
	else if(target in friends)
		return FALSE
	else if(target.stat != DEAD)
		return target

//Mobs in critical state are now fair game. Rip and tear.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/SA_attackable(target_mob)
	if(isliving(target_mob))
		var/mob/living/target = target_mob
		if(target.stat == DEAD)
			return TRUE
	return FALSE

//Immediately retaliate after being attacked.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/Retaliate()
	if(stat == DEAD || target_mob)
		return
	aggression_value = clamp(aggression_value + 5, 0, 30)
	. = ..()
	target_mob = FindTarget()
	if(target_mob)
		growl(target_mob)
		MoveToTarget()

///Proc for moving to targets. walk_to() doesn't check for resting and status effects so we will do it ourselves.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/MoveTo(target, distance = 1, retreat = FALSE, time = 6 SECONDS, return_to_combat = FALSE)
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_FLOORED))
		return
	if(resting)
		set_resting(FALSE)
	if(!retreat)
		walk_to(src, target, distance, move_to_delay)
		return

	is_retreating = TRUE
	stop_automated_movement = TRUE
	stance = HOSTILE_STANCE_ALERT
	walk_away(src, target ? target : get_turf(src), distance, LIZARD_SPEED_RETREAT)
	addtimer(CALLBACK(src, PROC_REF(stop_retreat), return_to_combat), time)

//Proc that's called after the retreat has run its course.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/stop_retreat(return_to_combat = FALSE)
	is_retreating = FALSE
	if(!return_to_combat)
		//don't stop retreating if there are non-friendly carbons in view
		for(var/mob/living/carbon/hostile_mob in view(7, src))
			if(hostile_mob.faction in faction_group)
				continue
			MoveTo(hostile_mob, 10, TRUE, 4 SECONDS, FALSE)
			return

		LoseTarget()
	else
		stance = HOSTILE_STANCE_ATTACKING
		FindTarget()
		MoveToTarget()

//Replaced walk_to() with MoveTo().
/mob/living/simple_animal/hostile/retaliate/giant_lizard/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		stance = HOSTILE_STANCE_ATTACKING
		MoveTo(target_mob)

///Ravaging attack, used for when a mob gets pounced.
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/ravagingattack()
	if(is_ravaging)
		return
	is_ravaging = TRUE
	visible_message(SPAN_DANGER("<B>[src]</B> tears into [target_mob] repeatedly!"))

	for(var/attack_num = 3, attack_num >= 0, attack_num--)
		if(Adjacent(target_mob) && stat == CONSCIOUS)
			var/damage = rand(melee_damage_lower, melee_damage_upper) * 0.33
			var/attack_type = pick(ATTACK_SLASH, ATTACK_BITE)
			attacktext = attack_type ? "claws" : "bites"
			flick_attack_overlay(target_mob, attack_type ? "slash" : "animalbite")
			playsound(loc, attack_type ? "alien_claw_flesh" : "alien_bite", 25, 1)
			target_mob.handle_blood_splatter(get_dir(src.loc, target_mob.loc))
			target_mob.apply_damage(damage, BRUTE)
			animation_attack_on(target_mob)
			face_atom(target_mob)
			sleep(0.5 SECONDS)
	is_ravaging = FALSE

//POUNCE PROCS AND WRAPPERS
///////////////////////////
/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounce()
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_FLOORED))
		return
	var/pounce_distance = clamp((get_dist(src, target_mob)), 1, 5)
	manual_emote("pounces at [target_mob]!")
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_atom), target_mob, pounce_distance, SPEED_FAST, src, null, LOW_LAUNCH, PASS_OVER_THROW_MOB, null, pounce_callbacks)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_mob_wrapper(mob/living/pounced_mob)
	pounced_mob(pounced_mob)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_mob(mob/living/pounced_mob)
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

	playsound(loc, hiss_sounds, 15)
	pounced_mob.KnockDown(0.5)
	step_to(src, pounced_mob)
	ravagingattack()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_turf(turf/turf_target)
	if(!turf_target.density)
		for(var/mob/living/mob in turf_target)
			pounced_mob(mob)
			break
	else
		turf_launch_collision(turf_target)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_turf_wrapper(turf/turf_target)
	pounced_turf(turf_target)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_obj_wrapper(obj/O)
	pounced_obj(O)

/mob/living/simple_animal/hostile/retaliate/giant_lizard/proc/pounced_obj(obj/O)
	// Unconscious or dead, or not throwing but used pounce
	if(stat != CONSCIOUS)
		obj_launch_collision(O)
		return

	if(!istype(O, /obj/structure/surface/table) && !istype(O, /obj/structure/surface/rack))
		O.hitby(src) //This resets throwing.

#undef ATTACK_SLASH
#undef ATTACK_BITE
#undef LIZARD_SPEED_NORMAL
#undef LIZARD_SPEED_RETREAT
