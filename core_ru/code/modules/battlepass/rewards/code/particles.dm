/mob
	var/obj/effect/abstract/particle_holder/particle_holder

///objects can only have one particle on them at a time, so we use these abstract effects to hold and display the effects. You know, so multiple particle effects can exist at once.
///also because some objects do not display particles due to how their visuals are built
/obj/effect/abstract/particle_holder
	name = "particle holder"
	desc = "How are you reading this? Please make a bug report :)"
	appearance_flags = KEEP_APART|KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE //movable appearance_flags plus KEEP_APART and KEEP_TOGETHER
	vis_flags = VIS_INHERIT_PLANE
	layer = ABOVE_XENO_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	/// Holds info about how this particle emitter works
	/// See \code\__DEFINES\particles.dm
	var/particle_flags = NONE

	var/atom/parent

/obj/effect/abstract/particle_holder/Initialize(mapload, particle_path_or_instance, particle_flags = NONE)
	. = ..()
	if(!loc)
		stack_trace("particle holder was created with no loc!")
		return INITIALIZE_HINT_QDEL
	// We nullspace ourselves because some objects use their contents (e.g. storage) and some items may drop everything in their contents on deconstruct.
	parent = loc
	loc = null

	// Mouse opacity can get set to opaque by some objects when placed into the object's contents (storage containers).
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	src.particle_flags = particle_flags
	if(ispath(particle_path_or_instance))
		particles = new particle_path_or_instance()
	else
		particles = particle_path_or_instance
	// /atom doesn't have vis_contents, /turf and /atom/movable do
	var/atom/movable/lie_about_areas = parent
	lie_about_areas.vis_contents += src
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(parent_deleted))

	if(particle_flags & PARTICLE_ATTACH_MOB)
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	on_move(parent, null, NORTH)

/obj/effect/abstract/particle_holder/Destroy(force)
	QDEL_NULL(particles)
	parent = null
	return ..()

/// Non movables don't delete contents on destroy, so we gotta do this
/obj/effect/abstract/particle_holder/proc/parent_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// signal called when a parent that's been hooked into this moves
/// does a variety of checks to ensure overrides work out properly
/obj/effect/abstract/particle_holder/proc/on_move(atom/movable/attached, atom/oldloc, direction)
	SIGNAL_HANDLER

	if(!(particle_flags & PARTICLE_ATTACH_MOB))
		return

	//remove old
	if(ismob(oldloc))
		var/mob/particle_mob = oldloc
		particle_mob.vis_contents -= src

	// If we're sitting in a mob, we want to emit from it too, for vibes and shit
	if(ismob(attached.loc))
		var/mob/particle_mob = attached.loc
		particle_mob.vis_contents += src

/// Sets the particles position to the passed coordinate list (X, Y, Z)
/// See [https://www.byond.com/docs/ref/#/{notes}/particles] for position documentation
/obj/effect/abstract/particle_holder/proc/set_particle_position(list/pos)
	particles.position = pos

/particles/proc/resize_pos(mob/assigned_mob)
	return

/particles/droplets
	icon = 'core_ru/icons/effects/particles/generic.dmi'
	icon_state = list("dot"=2,"drop"=1)
	width = 32
	height = 36
	count = 5
	spawning = 0.2
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	color = "#549EFF"
	position = generator(GEN_BOX, list(-9,-9,0), list(9,18,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	gravity = list(0, -0.9)

/particles/droplets/resize_pos(mob/assigned_mob)
	var/is = assigned_mob.icon_size / 32
	position = generator(GEN_BOX, list(-9*is, -9*is, 0), list(9*is,18*is,0), NORMAL_RAND)

/particles/slime
	icon = 'core_ru/icons/effects/particles/goop.dmi'
	icon_state = list("goop_1" = 6, "goop_2" = 2, "goop_3" = 1)
	width = 100
	height = 100
	count = 100
	spawning = 0.5
	color = "#4b4a4aa0"
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	grow = -0.025
	gravity = list(0, -0.05)
	position = generator(GEN_BOX, list(-8,-16,0), list(8,16,0), NORMAL_RAND)
	spin = generator(GEN_NUM, -15, 15, NORMAL_RAND)
	scale = list(0.75, 0.75)

/particles/slime/resize_pos(mob/assigned_mob)
	var/is = assigned_mob.icon_size / 32
	position = generator(GEN_BOX, list(-8*is, -16*is, 0), list(8*is,16*is,0), NORMAL_RAND)

/// Rainbow slime particles.
/particles/slime/rainbow
	gradient = list(0, "#f00a", 3, "#0ffa", 6, "#f00a", "loop", "space"=COLORSPACE_HSL)
	color_change = 0.2
	color = generator(GEN_NUM, 0, 6, UNIFORM_RAND)

/particles/pollen
	icon = 'core_ru/icons/effects/particles/pollen.dmi'
	icon_state = "pollen"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 0.7 SECONDS
	fade = 1 SECONDS
	grow = -0.01
	velocity = list(0, 0)
	position = generator(GEN_CIRCLE, 0, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.95)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation = 30
	spin = generator(GEN_NUM, -20, 20)

/particles/pollen/resize_pos(mob/assigned_mob)
	var/is = assigned_mob.icon_size / 32
	position = generator(GEN_CIRCLE, 0, 16*is, NORMAL_RAND)


/particles/stink
	icon = 'core_ru/icons/effects/particles/stink.dmi'
	icon_state = list("stink_1" = 1, "stink_2" = 2, "stink_3" = 2)
	color = "#0BDA51"
	width = 100
	height = 100
	count = 25
	spawning = 0.25
	lifespan = 1 SECONDS
	fade = 1 SECONDS
	position = generator(GEN_CIRCLE, 0, 16, UNIFORM_RAND)
	gravity = list(0, 0.25)

/particles/stink/resize_pos(mob/assigned_mob)
	var/is = assigned_mob.icon_size / 32
	position = generator(GEN_CIRCLE, 0, 16*is, NORMAL_RAND)

/particles/musical_notes
	icon = 'core_ru/icons/effects/particles/notes/note.dmi'
	icon_state = list(
		"note_1" = 1,
		"note_2" = 1,
		"note_3" = 1,
		"note_4" = 1,
		"note_5" = 1,
		"note_6" = 1,
		"note_7" = 1,
		"note_8" = 1,
	)
	width = 100
	height = 100
	count = 250
	spawning = 0.3
	lifespan = 0.7 SECONDS
	fade = 1 SECONDS
	grow = -0.01
	velocity = list(0, 0)
	position = generator(GEN_CIRCLE, 0, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.95)

/particles/musical_notes/resize_pos(mob/assigned_mob)
	var/is = assigned_mob.icon_size / 32
	position = generator(GEN_CIRCLE, 0, 16*is, NORMAL_RAND)

/particles/musical_notes/holy
	icon = 'core_ru/icons/effects/particles/notes/note_holy.dmi'
	icon_state = list(
		"holy_1" = 1,
		"holy_2" = 1,
		"holy_3" = 1,
		"holy_4" = 1,
		"holy_5" = 1,
		"holy_6" = 1,
		"holy_7" = 1,
		"holy_8" = 1,
		"holy_9" = 4, //holy theme specific
	)

/particles/musical_notes/nullwave
	icon = 'core_ru/icons/effects/particles/notes/note_null.dmi'
	icon_state = list(
		"null_1" = 1,
		"null_2" = 1,
		"null_3" = 1,
		"null_4" = 1,
		"null_5" = 1,
		"null_6" = 1,
		"null_7" = 1,
		"null_8" = 1,
		"null_9" = 2, //heal theme specific
		"null_10" = 2, //heal theme specific
	)

/particles/musical_notes/harm
	icon = 'core_ru/icons/effects/particles/notes/note_harm.dmi'
	icon_state = list(
		"harm_1" = 1,
		"harm_2" = 1,
		"harm_3" = 1,
		"harm_4" = 1,
		"harm_5" = 1,
		"harm_6" = 1,
		"harm_7" = 1,
		"harm_8" = 1,
		"harm_9" = 2, //harm theme specific
		"harm_10" = 2, //harm theme specific
	)

/particles/musical_notes/sleepy
	icon = 'core_ru/icons/effects/particles/notes/note_sleepy.dmi'
	icon_state = list(
		"sleepy_1" = 1,
		"sleepy_2" = 1,
		"sleepy_3" = 1,
		"sleepy_4" = 1,
		"sleepy_5" = 1,
		"sleepy_6" = 1,
		"sleepy_7" = 1,
		"sleepy_8" = 1,
		"sleepy_9" = 2, //sleepy theme specific
		"sleepy_10" = 2, //sleepy theme specific
	)

/particles/musical_notes/light
	icon = 'core_ru/icons/effects/particles/notes/note_light.dmi'
	icon_state = list(
		"power_1" = 1,
		"power_2" = 1,
		"power_3" = 1,
		"power_4" = 1,
		"power_5" = 1,
		"power_6" = 1,
		"power_7" = 1,
		"power_8" = 1,
		"power_9" = 2, //light theme specific
		"power_10" = 2, //light theme specific
	)

/particles/acid
	icon = 'core_ru/icons/effects/particles/goop.dmi'
	icon_state = list("goop_1" = 6, "goop_2" = 2, "goop_3" = 1)
	width = 100
	height = 100
	count = 100
	spawning = 0.5
	color = "#00ea2b80" //to get 96 alpha
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	grow = -0.025
	gravity = list(0, 0.15)
	position = generator(GEN_SPHERE, 0, 16, NORMAL_RAND)
	spin = generator(GEN_NUM, -15, 15, NORMAL_RAND)
