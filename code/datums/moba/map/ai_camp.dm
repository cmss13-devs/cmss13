GLOBAL_LIST_EMPTY(mapless_moba_camps)

/obj/effect/moba_camp_spawner
	invisibility = INVISIBILITY_MAXIMUM
	var/simplemob_type = /mob/living/simple_animal/hostile/carp/no_knockdown
	var/hostile_range = 3
	var/amount_to_spawn = 2
	var/respawn_timer = 4 MINUTES
	var/starting_max_health = 120
	/// Reaches this at 25 minutes, increases every 2.5 minutes
	var/ending_max_health = 480

	var/timer_started = FALSE
	var/map_id = 0

	var/list/mob/living/simple_animal/hostile/spawned_mobs = list()
	var/list/turf/open/floor/watched_tiles = list()

/obj/effect/moba_camp_spawner/Initialize(mapload, ...)
	. = ..()
	GLOB.mapless_moba_camps += src

/obj/effect/moba_camp_spawner/proc/spawn_mobs()
	if(!length(watched_tiles))
		for(var/turf/open/floor/floor in view(hostile_range, src))
			RegisterSignal(floor, COMSIG_TURF_ENTERED, PROC_REF(on_enter))
			watched_tiles += floor

	var/list/viable_turfs = list()
	for(var/turf/open/floor/floor in range(1, src))
		viable_turfs += floor

	for(var/i in 1 to amount_to_spawn)
		var/mob/living/spawned_mob = new simplemob_type(pick_n_take(viable_turfs))
		spawned_mob.AddComponent(/datum/component/moba_simplemob, starting_max_health, ending_max_health, map_id)
		spawned_mobs += spawned_mob
		RegisterSignal(spawned_mob, COMSIG_MOB_DEATH, PROC_REF(on_mob_death))

/obj/effect/moba_camp_spawner/proc/set_map_id(new_map_id)
	map_id = new_map_id
	GLOB.mapless_moba_camps -= src
	spawn_mobs()

/obj/effect/moba_camp_spawner/proc/on_mob_death(mob/living/source)
	SIGNAL_HANDLER

	spawned_mobs -= source

	if(!length(spawned_mobs) && !timer_started)
		start_respawn_timer()

/obj/effect/moba_camp_spawner/proc/start_respawn_timer()
	timer_started = TRUE
	addtimer(CALLBACK(src, PROC_REF(spawn_mobs)), respawn_timer)

/obj/effect/moba_camp_spawner/proc/on_enter(datum/source, atom/entering_atom)
	SIGNAL_HANDLER

	if(!isxeno(entering_atom) || HAS_TRAIT(entering_atom, TRAIT_MOBA_CAMP_TARGET))
		return

	var/mob/living/carbon/xenomorph/xeno = entering_atom
	ADD_TRAIT(xeno, TRAIT_MOBA_CAMP_TARGET, TRAIT_SOURCE_INHERENT)
	RegisterSignal(xeno, COMSIG_MOVABLE_MOVED, PROC_REF(on_xeno_move))
	for(var/mob/living/simple_animal/hostile/mob as anything in spawned_mobs)
		mob.Life() // I hate simplemobs

/obj/effect/moba_camp_spawner/proc/on_xeno_move(mob/living/carbon/xenomorph/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	var/turf/xeno_turf = get_turf(source)
	if(xeno_turf in watched_tiles)
		return

	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	REMOVE_TRAIT(source, TRAIT_MOBA_CAMP_TARGET, TRAIT_SOURCE_INHERENT)


