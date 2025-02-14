/datum/component/moba_simplemob
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/simple_animal/hostile/parent_simplemob
	var/turf/home_turf
	var/returning_to_home = FALSE
	var/home_dist = 4
	var/starting_max_health = 100
	var/ending_max_health = 400
	var/map_id

/datum/component/moba_simplemob/Initialize(starting_health, ending_health, new_map_id)
	. = ..()
	if(!istype(parent, /mob/living/simple_animal/hostile))
		return COMPONENT_INCOMPATIBLE

	parent_simplemob = parent
	home_turf = get_turf(parent)
	starting_max_health = starting_health
	ending_max_health = ending_health
	map_id = new_map_id

	parent_simplemob.target_search_range = 5
	parent_simplemob.wander = FALSE

	var/datum/moba_controller/controller = SSmoba.controller_id_dict["[map_id]"]
	parent_simplemob.setMaxHealth(starting_max_health + (((ending_max_health - starting_max_health) * 0.1) * floor(controller.game_duration / (2.5 MINUTES))))
	parent_simplemob.health = parent_simplemob.getMaxHealth()

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
