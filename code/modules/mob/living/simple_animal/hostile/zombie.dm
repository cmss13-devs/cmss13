//night of the unliving deceased
/mob/living/simple_animal/hostile/zombie
	name = "zombie"
	desc = "Don't let it touch you."
	icon_state = "zombie"
	icon_living = "zombie"
	icon_dead = "zombie_dead"
	speak_emote = list("groans")
	emote_hear = list("groans")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pokes the"
	response_disarm = "shoves aside the"
	response_harm   = "kicks the"
	stop_automated_movement_when_pulled = 0
	maxHealth = 250
	health = 250
	melee_damage_lower = 10
	melee_damage_upper = 40
	var/poison_per_bite = 5
	var/poison_type = "blackgoo"
	faction = FACTION_ZOMBIE
	move_to_delay = 6
	speed = 3
	break_stuff_probability = 75

/mob/living/simple_animal/hostile/zombie/FindTarget()
	. = ..()
	if(.)
		roar_emote()

/mob/living/simple_animal/hostile/zombie/AttackingTarget()
	..()
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(isliving(target_mob))
		if(target_mob.reagents)
			if(prob(25))
				target_mob.reagents.add_reagent("blackgoo", poison_per_bite)
				if(prob(poison_per_bite))
					to_chat(target_mob, SPAN_DANGER("You feel a tiny prick."))
					target_mob.reagents.add_reagent(poison_type, 5)
					roar_emote()

	if(prob(5))
		roar_emote()

/mob/living/simple_animal/hostile/zombie/bullet_act(obj/projectile/P)
	. = ..()
	if(P.damage)
		var/splatter_dir = get_dir(P.starting, loc)
		new /obj/effect/bloodsplatter(loc, splatter_dir)
		if(prob(15))
			roar_emote()

/mob/living/simple_animal/hostile/zombie/proc/roar_emote()
	visible_message("<B>The [name]</B> roars!")
	playsound(loc, "zombie_sound", 25)

/mob/living/simple_animal/hostile/zombie/death(cause, gibbed, deathmessage = "lets out a high pitched groan, its body begins to melt away...")
	. = ..()
	if(!.)
		return //If they were already dead, it will return.
	playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 25, 1)
	QDEL_IN(src, 5 SECONDS)
	animate(src, 5 SECONDS, alpha = 0, easing = CUBIC_EASING)

/mob/living/simple_animal/hostile/zombie/fast
	move_to_delay = 4
