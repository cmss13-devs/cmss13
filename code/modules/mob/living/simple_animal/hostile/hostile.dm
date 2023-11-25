/mob/living/simple_animal/hostile
	faction = "hostile"
	var/stance = HOSTILE_STANCE_IDLE //Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/move_to_delay = 4 //delay for the automated movement.
	var/list/friends = list()
	var/break_stuff_probability = 10
	stop_automated_movement_when_pulled = 0
	black_market_value = KILL_MENDOZA
	dead_black_market_value = 25
	var/destroy_surroundings = 1

/mob/living/simple_animal/hostile/Destroy()
	friends = null
	target_mob = null
	return ..()

/mob/living/simple_animal/hostile/proc/FindTarget()

	var/atom/T = null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(10))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = evaluate_target(A)
			if(L)
				stance = HOSTILE_STANCE_ATTACK
				T = L
				break

		if(istype(A, /obj/structure/machinery/bot))
			var/obj/structure/machinery/bot/B = A
			if (B.health > 0)
				stance = HOSTILE_STANCE_ATTACK
				T = B
				break
	return T

/mob/living/simple_animal/hostile/proc/evaluate_target(mob/living/target)
	if(target.faction == src.faction && !attack_same)
		return FALSE
	else if(target in friends)
		return FALSE
	else
		if(!target.stat)
			return target

/mob/living/simple_animal/hostile/proc/Found(atom/A)
	return

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target_mob, 1, move_to_delay)

/mob/living/simple_animal/hostile/proc/AttackTarget()

	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1) //Attacking
		AttackingTarget()
		return 1

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_animal(src)
		src.animation_attack_on(L)
		src.flick_attack_overlay(L, "slash")
		playsound(src.loc, "alien_claw_flesh", 25, 1)
		return L
	if(istype(target_mob,/obj/structure/machinery/bot))
		var/obj/structure/machinery/bot/B = target_mob
		B.attack_animal(src)

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)


/mob/living/simple_animal/hostile/proc/ListTargets(dist = 7)
	var/list/L = hearers(src, dist)
	return L

/mob/living/simple_animal/hostile/death()
	. = ..()
	if(!.) return //was already dead
	walk(src, 0)

/mob/living/simple_animal/hostile/Life(delta_time)

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(!stat && mobility_flags & MOBILITY_MOVE)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				if(destroy_surroundings)
					DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				if(!AttackTarget() && destroy_surroundings)
					DestroySurroundings()

/mob/living/simple_animal/hostile/stop_moving()
	..()
	stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/proc/DestroySurroundings()
	if(prob(break_stuff_probability))
		for(var/dir in GLOB.cardinals) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == GLOB.reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_animal(src)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/surface/table) || istype(obstacle, /obj/structure/grille) || istype(obstacle, /obj/structure/barricade))
				obstacle.attack_animal(src)
