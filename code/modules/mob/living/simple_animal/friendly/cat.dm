//Cat
/mob/living/simple_animal/cat
	name = "cat"
	real_name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	/// The target src is moving towards during its hunt.
	var/mob/living/movement_target
	/// The mobs that src will track to hunt and kill.
	var/static/list/hunting_targets = list(
		/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/alien_slug,
		/mob/living/simple_animal/bat,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/lizard,
		/mob/living/carbon/xenomorph/facehugger,
		/mob/living/carbon/xenomorph/larva,
	)
	/// The cat will 'play' with dead hunted targets near it until this counter reaches a certain value.
	var/play_counter = 0
	min_oxy = 16 //Require at least 16kPA oxygen
	minbodytemp = 223 //Below -50 Degrees Celcius
	maxbodytemp = 323 //Above 50 Degrees Celcius
	holder_type = /obj/item/holder/cat
	mob_size = MOB_SIZE_SMALL
	sight = SEE_MOBS
	see_in_dark = 8
	see_invisible = 15
	black_market_value = 50
	dead_black_market_value = 0
	var/miaow_counter = 0
	var/attack_damage = 25

/mob/living/simple_animal/cat/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/simple_animal/cat/Destroy()
	movement_target = null
	. = ..()

/mob/living/simple_animal/cat/Life(delta_time)
	//MICE!
	if(stat == DEAD)
		return ..()

	if(isturf(loc))
		if(++miaow_counter >= rand(20, 30)) //Increase the meow variable each tick. Play it at random intervals.
			playsound(loc, "cat_meow", 15, 1, 4)
			miaow_counter = 0 //Reset the counter
		if(stat == CONSCIOUS && !resting && !buckled)
			for(var/mob/prey in view(1,src))
				if(is_type_in_list(prey, hunting_targets) && play_counter < 5 && prey.stat != DEAD)
					var/mob/living/livingprey = prey

					if(livingprey.stat == DEAD) //quick deadcheck
						return ..()

					play_counter++
					visible_message(pick("[src] bites [livingprey]!","[src] toys with [livingprey].","[src] chomps on [livingprey]!"))
					movement_target = null
					stop_automated_movement = 0

					animation_attack_on(livingprey)
					flick_attack_overlay(livingprey, "slash")
					if(!livingprey.client) // instakilling players bad
						livingprey.splat(src)
					else
						livingprey.attack_animal(src)
						livingprey.apply_damage(attack_damage,BRUTE)
						livingprey.apply_effect(1,SLOW)
						livingprey.KnockDown(1,1)
					playsound(src.loc, "alien_claw_flesh", 25, 1)
					break

	..()

	for(var/mob/snack in oview(src, 3))
		if(is_type_in_list(snack, hunting_targets) && prob(15) && snack.stat != DEAD)
			visible_message(pick("[src] hisses at [snack]!", "[src] mrowls fiercely!", "[src] eyes [snack] hungrily."))
		break

	if(stat == CONSCIOUS && !resting && !buckled)
		handle_movement_target()

/mob/living/simple_animal/cat/death()
	. = ..()
	if(!.)
		return //was already dead
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_CAT)

/mob/living/simple_animal/cat/proc/handle_movement_target()
	turns_since_scan++
	if(turns_since_scan > 5)
		walk_to(src,0)
		turns_since_scan = 0

		if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
			movement_target = null
			stop_automated_movement = 0
		if( !movement_target || !(movement_target.loc in oview(src, 4)) )
			movement_target = null
			stop_automated_movement = 0
			for(var/mob/living/snack in oview(src))
				if(isturf(snack.loc) && snack.stat != DEAD && is_type_in_list(snack, hunting_targets))
					setDir(get_dir(src, snack))
					balloon_alert_to_viewers("[src] pounces at [snack]")
					movement_target = snack
					play_counter = 0
					break
		if(movement_target)
			stop_automated_movement = 1
			walk_to(src,movement_target,0,3)

/mob/living/simple_animal/cat/MouseDrop(atom/over_object)
	if(!CAN_PICKUP(usr, src))
		return ..()
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H) || H != usr)
		return ..()

	if(H.a_intent == INTENT_HELP)
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/cat/get_scooped(mob/living/carbon/grabber)
	if (stat >= DEAD)
		return
	..()

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	holder_type = /obj/item/holder/cat/blackcat/Runtime

/mob/living/simple_animal/cat/blackcat
	name = "black cat"
	desc = "It's a cat, now in black!"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	holder_type = /obj/item/holder/cat/blackcat

/mob/living/simple_animal/cat/Jones
	name = "Jones"
	real_name = "Jones"
	desc = "A tough, old stray whose origin no one seems to know."
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	health = 50
	maxHealth = 50
	holder_type = /obj/item/holder/cat/Jones

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	holder_type = /obj/item/holder/cat/kitten
	gender = NEUTER
