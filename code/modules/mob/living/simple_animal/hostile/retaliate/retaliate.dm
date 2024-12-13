/mob/living/simple_animal/hostile/retaliate
	black_market_value = 50
	dead_black_market_value = 0
	/// List of weakrefs of our enemy mobs
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Found(atom/A)
	if(isliving(A))
		var/mob/living/living = A
		if(!living.stat)
			stance = HOSTILE_STANCE_ATTACK
			return living
		else
			enemies -= WEAKREF(living)

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!length(enemies))
		return list()
	var/list/see = ..()
	var/list/seen_enemies = list()
	// Remove all entries that aren't in enemies
	for(var/thing in see)
		if(WEAKREF(thing) in enemies)
			seen_enemies += thing
	return seen_enemies

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	var/list/around = view(src, 7)

	for(var/atom/movable/thing in around)
		if(thing == src)
			continue
		if(isliving(thing))
			var/mob/living/living = thing
			if(evaluate_target(living))
				enemies |= WEAKREF(living)

	for(var/mob/living/simple_animal/hostile/retaliate/buddy in around)
		if(!attack_same && !buddy.attack_same && buddy.faction == faction)
			buddy.enemies |= enemies
	return 0

/mob/living/simple_animal/hostile/retaliate/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force)
	Retaliate()
	return ..()

