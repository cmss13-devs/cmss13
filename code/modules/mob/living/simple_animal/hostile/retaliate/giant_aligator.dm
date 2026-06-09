#define ALIGATOR_SPEED_DRAGING 1.2
#define LIZARD_SPEED_NORMAL 2.8


/mob/living/simple_animal/hostile/retaliate/giant_lizard/aligator
	name = "Aligator"
	stun_duration = 2

/mob/living/simple_animal/hostile/retaliate/giant_lizard/aligator/pounced_mob(mob/living/pounced_mob)
	. = ..()
	throwing = 0
	start_pulling(pounced_mob, TRUE, simple_mob = TRUE)
	MoveTo(target_mob_ref?.resolve(), 5, TRUE, 2 SECONDS, TRUE) //drag our target away

/mob/living/simple_animal/hostile/retaliate/giant_lizard/aligator/start_pulling(atom/movable/clone/AM, lunge, no_msg, simple_mob)
	. = ..()
	if(.)
		speed = ALIGATOR_SPEED_DRAGING
/mob/living/simple_animal/hostile/retaliate/giant_lizard/aligator/stop_pulling()
	. = ..()
	speed = LIZARD_SPEED_NORMAL

#undef ALIGATOR_SPEED_DRAGING
#undef LIZARD_SPEED_NORMAL
