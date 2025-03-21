/datum/component/moba_simplemob
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/simple_animal/hostile/parent_simplemob
	var/turf/home_turf
	var/returning_to_home = FALSE
	var/home_dist = 4
	var/starting_max_health = 100
	var/ending_max_health = 400
	var/map_id
	var/boss_simplemob = FALSE

/datum/component/moba_simplemob/Initialize(starting_health, ending_health, new_map_id, gold_to_grant, starting_xp_to_grant, ending_xp_to_grant, boss_simplemob = FALSE)
	. = ..()
	if(!istype(parent, /mob/living/simple_animal/hostile))
		return COMPONENT_INCOMPATIBLE

	parent_simplemob = parent
	home_turf = get_turf(parent)
	starting_max_health = starting_health
	ending_max_health = ending_health
	map_id = new_map_id
	src.boss_simplemob = boss_simplemob

	parent_simplemob.target_search_range = 5
	parent_simplemob.wander = FALSE

	if(!boss_simplemob)
		var/scale = (SSmoba.get_moba_controller(map_id).game_level - 1) / (MOBA_MAX_LEVEL - 1) // camps don't scale until they respawn
		parent_simplemob.setMaxHealth(starting_max_health + ((ending_max_health - starting_max_health) * scale))
		parent_simplemob.health = parent_simplemob.getMaxHealth()

		parent_simplemob.AddComponent(/datum/component/moba_death_reward, gold_to_grant, starting_xp_to_grant + ((ending_xp_to_grant - starting_xp_to_grant) * scale))
	else
		parent_simplemob.maptext_width = 64
		parent_simplemob.maptext = MAPTEXT("<center><h2>[floor(parent_simplemob.health / parent_simplemob.getMaxHealth() * 100)]%</h2></center>")

/datum/component/moba_simplemob/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/moba_simplemob/RegisterWithParent()
	..()
	RegisterSignal(parent_simplemob, COMSIG_MOVABLE_MOVED, PROC_REF(return_to_home))
	RegisterSignal(parent_simplemob, COMSIG_MOB_DEATH, PROC_REF(on_death))
	RegisterSignal(parent_simplemob, COMSIG_LIVING_SIMPLEMOB_EVALUATE_TARGET, PROC_REF(on_target))
	RegisterSignal(parent_simplemob, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_damage))

/datum/component/moba_simplemob/proc/handle_qdel()
	SIGNAL_HANDLER

	parent_simplemob = null
	home_turf = null

/datum/component/moba_simplemob/proc/return_to_home(datum/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(returning_to_home || (get_dist(parent_simplemob, home_turf) <= home_dist))
		return

	returning_to_home = TRUE
	RegisterSignal(home_turf, COMSIG_TURF_ENTERED, PROC_REF(on_enter_turf))
	addtimer(CALLBACK(src, PROC_REF(returned_home)), 5 SECONDS) // in case they get stuck
	parent_simplemob.LoseTarget()
	parent_simplemob.heal_all_damage()
	walk_to(parent_simplemob, home_turf, 0, parent_simplemob.move_to_delay * 0.5)
	parent_simplemob.manual_emote("wanders off.")
	if(boss_simplemob)
		parent_simplemob.maptext = MAPTEXT("<center><h2>[floor(parent_simplemob.health / parent_simplemob.getMaxHealth() * 100)]%</h2></center>")

/datum/component/moba_simplemob/proc/on_enter_turf(datum/source, atom/entering_atom)
	SIGNAL_HANDLER

	if(entering_atom != parent_simplemob)
		return

	returned_home()

/datum/component/moba_simplemob/proc/returned_home()
	if(returning_to_home)
		UnregisterSignal(home_turf, COMSIG_TURF_ENTERED)
		returning_to_home = FALSE
		parent_simplemob.manual_emote("settles down.")

/datum/component/moba_simplemob/proc/on_death(datum/source)
	SIGNAL_HANDLER

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), parent_simplemob), 90 SECONDS) // maybe add a fadeout

/datum/component/moba_simplemob/proc/on_target(datum/source, mob/living/target)
	SIGNAL_HANDLER

	if(HAS_TRAIT(target, TRAIT_MOBA_CAMP_TARGET))
		return

	return COMSIG_LIVING_SIMPLEMOB_EVALUATE_TARGET_BLOCK

/datum/component/moba_simplemob/proc/on_damage(datum/source, list/damagedata, damagetype)
	SIGNAL_HANDLER

	if(((parent_simplemob.health - damagedata["damage"]) <= 0) && (parent_simplemob.stat != DEAD))
		parent_simplemob.death()

	parent_simplemob.maptext = MAPTEXT("<center><h2>[floor(parent_simplemob.health / parent_simplemob.getMaxHealth() * 100)]%</h2></center>")
