/mob/living/simple_animal/small/bat
	name = "bat"
	desc = "It's a spooky bat!"
	icon = 'icons/mob/animal.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	mob_size = MOB_SIZE_SMALL
	speak = list("screech")
	speak_emote = list("screeches")
	emote_hear = list("screeches")

/mob/living/simple_animal/small/bat/Life(delta_time)
	. = ..()
	if(!ckey && stat == CONSCIOUS && prob(5))
		if(locate(/turf/closed,get_step(src, NORTH)))
			set_stat(UNCONSCIOUS)
			icon_state = "bat_hanging"
			wander = 0
			speak_chance = 0
	else if(ckey || (stat == UNCONSCIOUS && prob(5)))
		set_stat(CONSCIOUS)
		icon_state = "bat"
		wander = 1
