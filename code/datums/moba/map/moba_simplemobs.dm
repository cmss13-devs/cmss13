// Could this be componentized?

/mob/living/simple_animal/hostile/carp/moba //zonenote add health/damage scaling
	maxHealth = 120
	health = 120
	wander = FALSE
	move_to_delay = 0.3 SECONDS
	bite_knockdown_chance = 4
	var/turf/home_turf

	var/returning_to_home = FALSE

/mob/living/simple_animal/hostile/carp/moba/Initialize()
	. = ..()
	home_turf = get_turf(src)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(return_to_home))
	RegisterSignal(src, COMSIG_MOB_DEATH, PROC_REF(on_death))

/mob/living/simple_animal/hostile/carp/moba/Destroy()
	home_turf = null
	return ..()

/mob/living/simple_animal/hostile/carp/moba/FindTarget()
	if(returning_to_home)
		return

	stop_automated_movement = FALSE
	for(var/mob/living/carbon/xenomorph/xeno in ListTargets(5))
		if(!HAS_TRAIT(xeno, TRAIT_MOBA_CAMP_TARGET) || (xeno.stat == DEAD))
			continue

		manual_emote("gnashes at [xeno].")
		stance = HOSTILE_STANCE_ATTACK
		return xeno

/mob/living/simple_animal/hostile/carp/moba/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force)
	. = ..()
	if(. && (health <= 0))
		death() // Waiting for the lifeloop sucks

/mob/living/simple_animal/hostile/carp/moba/evaluate_target(mob/living/target)
	return target

/mob/living/simple_animal/hostile/carp/moba/proc/return_to_home(datum/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(returning_to_home || (get_dist(src, home_turf) <= 4))
		return

	returning_to_home = TRUE
	RegisterSignal(home_turf, COMSIG_TURF_ENTERED, PROC_REF(on_enter_turf))
	addtimer(CALLBACK(src, PROC_REF(returned_home)), 5 SECONDS) // in case they get stuck
	LoseTarget()
	heal_all_damage()
	walk_to(src, home_turf, 0, move_to_delay * 0.5)
	manual_emote("wanders off.")

/mob/living/simple_animal/hostile/carp/moba/proc/on_enter_turf(datum/source, atom/entering_atom)
	SIGNAL_HANDLER

	if(entering_atom != src)
		return

	returned_home()

/mob/living/simple_animal/hostile/carp/moba/proc/returned_home()
	if(returning_to_home)
		UnregisterSignal(home_turf, COMSIG_TURF_ENTERED)
		returning_to_home = FALSE
		manual_emote("settles down.")

/mob/living/simple_animal/hostile/carp/moba/proc/on_death(datum/source)
	SIGNAL_HANDLER

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 90 SECONDS) // maybe add a fadeout
	// Also give XP/gold here eventually
