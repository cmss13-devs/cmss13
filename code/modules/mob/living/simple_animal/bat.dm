/mob/living/simple_animal/bat
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

/mob/living/simple_animal/bat/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_FLAGS_CRAWLER

/mob/living/simple_animal/bat/Life()
	. = ..()
	if(!ckey && stat == CONSCIOUS && prob(5))
		if(locate(/turf/closed,get_step(src, NORTH)))
			stat = UNCONSCIOUS
			icon_state = "bat_hanging"
			wander = 0
			speak_chance = 0
	else if(ckey || (stat == UNCONSCIOUS && prob(5)))
		stat = CONSCIOUS
		icon_state = "bat"
		wander = 1
		canmove = 1
