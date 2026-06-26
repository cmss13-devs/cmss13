/mob/living/simple_animal/small/frog
	name = "frog"
	real_name = "frog"
	desc = "A small amphibian. It occasionally makes wet, croaking sounds."

	icon_state = "frog_green"
	icon_living = "frog_green"
	icon_dead = "frog_green_dead"

	speak = list("Ribbit!","Croak!","Rrrrk!","Bworp!")
	speak_emote = list("croaks", "ribbits", "warbles")
	emote_hear = list("croaks softly.", "lets out a wet ribbit.", "gurgles.")
	emote_see = list("blinks slowly.", "puffs its throat.", "sits very still.")

	speak_chance = 1
	turns_per_move = 5

	meat_type = /obj/item/reagent_container/food/snacks/meat

	response_help  = "pets"
	response_disarm = "nudges aside"
	response_harm   = "stomps"

	var/croak_counter = 0

/mob/living/simple_animal/small/frog/Life(delta_time)
	if(stat == DEAD)
		return ..()

	if(isturf(loc))
		if(++croak_counter >= rand(20, 30))
			croak_counter = 0
			switch(rand(1, 5))
				if(1)
					playsound(loc, "frog_1.ogg", 15, 1, 4)
				if(2)
					playsound(loc, "frog_2.ogg", 15, 1, 4)
				if(3)
					playsound(loc, "frog_3.ogg", 15, 1, 4)
				if(4)
					playsound(loc, "frog_4.ogg", 15, 1, 4)
				if(5)
					playsound(loc, "frog_5.ogg", 15, 1, 4)

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
			holder_type = /obj/item/holder/frog
		if(2)
			icon_state = "frog_blue"
			holder_type = /obj/item/holder/frog/blue
		if(3)
			icon_state = "frog_brown"
			holder_type = /obj/item/holder/frog/brown
