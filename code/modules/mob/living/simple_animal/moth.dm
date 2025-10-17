/mob/living/simple_animal/moth
	name = "cave moth"
	desc = "A large cave-dwelling arthropod native to LV-624. Its thick, leathery wings and reflective eyes suggest nocturnal habits. Despite its size, it moves with eerie grace, clinging silently to rock walls until disturbed."
	icon = 'icons/mob/animal.dmi'
	icon_state = "moth"
	icon_living = "moth"
	icon_dead = "moth_dead"
	mob_size = MOB_SIZE_SMALL
	speak = list("chitters", "flutters", "clicks", "trills softly", "buzzes")
	speak_emote = list("chitters", "clicks its mandibles", "flutters its wings", "buzzes faintly")
	emote_hear = list("soft wingbeats", "a faint clicking", "rapid fluttering", "an eerie trill")

/mob/living/simple_animal/moth/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_FLAGS_CRAWLER

/mob/living/simple_animal/moth/Life(delta_time)
	. = ..()
	if(!ckey && stat == CONSCIOUS && prob(5))
		if(locate(/turf/closed,get_step(src, NORTH)))
			set_stat(UNCONSCIOUS)
			icon_state = "moth_hanging"
			wander = 0
			speak_chance = 0
	else if(ckey || (stat == UNCONSCIOUS && prob(5)))
		set_stat(CONSCIOUS)
		icon_state = "moth"
		wander = 1
