/// Structure spawner, representing something that can be spawned by gameplay logic during round or at setup
/obj/effect/landmark/structure_spawner
	name = "structure spawner"
	icon_state = "x2"
	/// Typepath to effectively instanciate
	var/path_to_spawn
	/// Truthy if a turf to use turf placement operations
	var/is_turf = FALSE
	/// One of required gamemode flags for this to apply
	var/mode_flags = NO_FLAGS

/obj/effect/landmark/structure_spawner/Initialize(mapload, ...)
	. = ..()
	GLOB.structure_spawners += src

/obj/effect/landmark/structure_spawner/Destroy(force)
	GLOB.structure_spawners -= src
	return ..()

/// Check validity of spawning this
/obj/effect/landmark/structure_spawner/proc/validate()
	return (mode_flags & SSticker.mode?.flags_round_type)

/// Return effective location to spawn at
/obj/effect/landmark/structure_spawner/proc/get_spawn_location()
	RETURN_TYPE(/atom) // But probably usually /turf
	return get_turf(src)

/// Actually spawn this if applicable
/obj/effect/landmark/structure_spawner/proc/apply(atom/target_location)
	SHOULD_NOT_SLEEP(TRUE)
	if(!validate())
		return
	if(!target_location)
		target_location = get_spawn_location()
	if(is_turf)
		var/turf/T = target_location
		return T?.PlaceOnTop(path_to_spawn)
	return new path_to_spawn(target_location)

/// Post-Setup hook, mainly to delete unused landmarks. By default delete all non-applicable ones
/obj/effect/landmark/structure_spawner/proc/post_setup()
	if(validate())
		return TRUE
	qdel(src)
	return FALSE

/// Setup spawners will all be evaluated by game mode on start, and deleted after
/obj/effect/landmark/structure_spawner/setup
	name = "abstract gamemode structure spawner"
/obj/effect/landmark/structure_spawner/setup/post_setup()
	qdel(src)
	return FALSE