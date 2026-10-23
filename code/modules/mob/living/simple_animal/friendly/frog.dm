/mob/living/simple_animal/small/frog
	name = "frog"
	real_name = "frog"
	desc = "A small amphibian."

	holder_type = /obj/item/holder/frog

	icon_state = "frog_green"
	icon_living = "frog_green"
	icon_dead = "frog_green_dead"

	speak = list("Ribbit!","Croak!","Rrrrk!","Bworp!")
	speak_emote = list("croaks", "ribbits", "warbles")
	emote_hear = list("croaks softly.", "lets out a wet ribbit.", "gurgles.")
	emote_see = list("blinks slowly.", "puffs its throat.", "sits very still.")

	speak_chance = 1
	min_turns_per_move = 2
	max_turns_per_move = 6

	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "stomps"

	var/croak_counter = 0

/mob/living/simple_animal/small/frog/Life(delta_time)
	if(stat == DEAD)
		return ..()

	if(isturf(loc))
		if(++croak_counter >= rand(10, 20))
			croak_counter = 0
			switch(rand(1, 5))
				if(1)
					playsound(loc, 'sound/effects/frog_1.ogg', 35, 1)
				if(2)
					playsound(loc, 'sound/effects/frog_2.ogg', 35, 1)
				if(3)
					playsound(loc, 'sound/effects/frog_3.ogg', 35, 1)
				if(4)
					playsound(loc, 'sound/effects/frog_4.ogg', 35, 1)
				if(5)
					playsound(loc, 'sound/effects/frog_5.ogg', 35, 1)

	return ..()

/mob/living/simple_animal/small/frog/MouseDrop(atom/over_object)
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

/*
 * frog types
 */

/mob/living/simple_animal/small/frog/blue
	icon_state = "frog_blue"
	holder_type = /obj/item/holder/frog/blue

/mob/living/simple_animal/small/frog/brown
	icon_state = "frog_brown"
	holder_type = /obj/item/holder/frog/brown

/mob/living/simple_animal/small/frog/random/Initialize()
	. = ..()

	switch(pick(1,2,3))
		if(1)
			icon_state = "frog_green"
			icon_living = "frog_green"
			icon_dead = "frog_green_dead"
			holder_type = /obj/item/holder/frog/green
		if(2)
			icon_state = "frog_blue"
			icon_living = "frog_blue"
			icon_dead = "frog_blue_dead"
			holder_type = /obj/item/holder/frog/blue
		if(3)
			icon_state = "frog_brown"
			icon_living = "frog_brown"
			icon_dead = "frog_brown_dead"
			holder_type = /obj/item/holder/frog/brown
