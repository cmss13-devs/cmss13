#define SHARED_PARTICLE_HOLDER_INDEX 1
#define SHARED_PARTICLE_USER_NUM_INDEX 2
// Assoc list of particle type/key -> list(list of particle holders, number of particle users)
GLOBAL_LIST_EMPTY(shared_particles)

//A more abstract version of particle holder not bound to a specific object
/obj/effect/abstract/shared_particle_holder
	name = "shared particle holder"
	desc = "How are you reading this? Please make a bug report :)"
	appearance_flags = KEEP_APART|KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE|RESET_COLOR
	vis_flags = VIS_INHERIT_PLANE
	layer = ABOVE_FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	/// Holds info about how this particle emitter works
	/// See \code\__DEFINES\particles.dm
	var/particle_flags = NONE

/obj/effect/abstract/shared_particle_holder/Initialize(mapload, particle_path, particle_flags = NONE)
	. = ..()
	// Shouldn't exist outside of nullspace
	loc = null
	src.particle_flags = particle_flags
	particles = new particle_path()

/obj/effect/abstract/shared_particle_holder/Destroy(force)
	QDEL_NULL(particles)
	return ..()

/* Adds (or creates and adds) a shared particle holder
 * Shared particle holders are held in nullspace and added to vis_contents of all atoms using it
 * in order to save clientside performance by making clients only render 3-5 particle holders
 * for 400 objects using them. This should be prioritized over normal particles when possible if it is known
 * that there will be a lot of objects using certain particles.
 * custom_key can be used to create a new pool of already existing particle type in case you're planning to edit holder's color or properties
 * pool_size controls how many particle holders per type are created. Any objects over this cap will pick an existing holder from the pool.
 *
 * Now, this code seems fucked up, that's because this is meant to support both objects (and mobs) and turfs, *however* areas are special
 * and don't have vis_contents, so to avoid copypaste code we do this weirdness
 */
/atom/proc/add_shared_particles(particle_type, custom_key = null, particle_flags = NONE, pool_size = 3)
	var/atom/movable/play_pretend = src
	var/particle_key = custom_key || "[particle_type]"
	if (!GLOB.shared_particles[particle_key])
		GLOB.shared_particles[particle_key] = list(list(new /obj/effect/abstract/shared_particle_holder(null, particle_type, particle_flags)), 1)
		play_pretend.vis_contents += GLOB.shared_particles[particle_key][SHARED_PARTICLE_HOLDER_INDEX][1]
		return GLOB.shared_particles[particle_key][SHARED_PARTICLE_HOLDER_INDEX][1]

	var/list/type_holders = GLOB.shared_particles[particle_key][SHARED_PARTICLE_HOLDER_INDEX]
	for (var/obj/effect/abstract/shared_particle_holder/particle_holder as anything in type_holders)
		if (particle_holder in play_pretend.vis_contents)
			return particle_holder

	if (length(type_holders) < pool_size)
		var/obj/effect/abstract/shared_particle_holder/new_holder = new(null, particle_type, particle_flags)
		type_holders += new_holder
		play_pretend.vis_contents += new_holder
		GLOB.shared_particles[particle_key][SHARED_PARTICLE_USER_NUM_INDEX] += 1
		return new_holder

	var/obj/effect/abstract/shared_particle_holder/particle_holder = pick(type_holders)
	play_pretend.vis_contents += particle_holder
	GLOB.shared_particles[particle_key][SHARED_PARTICLE_USER_NUM_INDEX] += 1
	return particle_holder

/area/add_shared_particles(particle_type, custom_key = null, particle_flags = NONE, pool_size = 3)
	CRASH("add_shared_particles was called on an area [src] ([type]) trying to add [particle_type]! Only turfs and movables support shared particles.")

/* Removes shared particles from object's vis_contents and disposes of it if nothing uses that type/key of particle
 * particle_key can be either a type (if no custom_key was passed) or said custom_key
 */
/atom/proc/remove_shared_particles(particle_key, delete_on_empty = TRUE)
	if (!particle_key)
		return

	if (ispath(particle_key))
		particle_key = "[particle_key]"

	if (!GLOB.shared_particles[particle_key])
		return

	var/atom/movable/play_pretend = src
	var/list/type_holders = GLOB.shared_particles[particle_key][SHARED_PARTICLE_HOLDER_INDEX]
	for (var/obj/effect/abstract/shared_particle_holder/particle_holder as anything in type_holders)
		if (!(particle_holder in play_pretend.vis_contents))
			continue

		play_pretend.vis_contents -= particle_holder
		GLOB.shared_particles[particle_key][SHARED_PARTICLE_USER_NUM_INDEX] -= 1

		if (delete_on_empty && GLOB.shared_particles[particle_key][SHARED_PARTICLE_USER_NUM_INDEX] <= 0)
			QDEL_LIST(type_holders)
			GLOB.shared_particles -= particle_key
		return

/area/remove_shared_particles(particle_key, delete_on_empty = TRUE)
	CRASH("remove_shared_particles was called on an area [src] ([type]) trying to add [particle_key]! Only turfs and movables support shared particles.")

#undef SHARED_PARTICLE_HOLDER_INDEX
#undef SHARED_PARTICLE_USER_NUM_INDEX
