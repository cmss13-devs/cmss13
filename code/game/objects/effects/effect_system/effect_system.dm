/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/


/datum/effect_system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = FALSE

/datum/effect_system/Destroy(force, ...)
	holder = null
	location = null
	return ..()

/datum/effect_system/proc/set_up(n = 3, c = 0, turf/loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loca
	setup = TRUE

/datum/effect_system/proc/attach(atom/atom)
	holder = atom

/**
 * Starts the effect system, which will invariably lead to objects being
 * created in the most irresponsible way possible.
 * Since this is decade old legacy code and nobody cares about using this properly,
 * it provides the following arg:
 *
 * [do_NOT_delete] : if TRUE, then effect_system will NOT seld delete after a single
 *                   start, and YOU have to do it by YOURSELF (defaults to FALSE)
 *
 * When you override this proc, you sign a blood contract to uphold this behavior.
 * Failure to do so leads to a penalty of rewriting the entire effect_system.
 * I dare you.
 *
 * Note: This is purposedly used as named argument because it will cause linter to
 * complain about someone skipping it in implementations. And hopefully to read this.
 */
/datum/effect_system/proc/start(do_NOT_delete = FALSE)
	if(!do_NOT_delete)
		qdel(src)


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
	var/datum/effect_system/steam_spread/steam = new /datum/effect_system/steam_spread() -- creates new system
	steam.set_up(5, 0, mob.loc) -- sets up variables
	OPTIONAL: steam.attach(mob)
	steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/particle_effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	density = FALSE

/datum/effect_system/steam_spread

/datum/effect_system/steam_spread/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect_system/steam_spread/start(do_NOT_delete = FALSE)
	var/i = 0
	for(i=0, i<number, i++)
		spawn(0)
			if(holder)
				location = get_turf(holder)
			var/obj/effect/particle_effect/steam/steam = new /obj/effect/particle_effect/steam(location)
			var/direction
			if(cardinals)
				direction = pick(GLOB.cardinals)
			else
				direction = pick(GLOB.alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(steam,direction)
			QDEL_IN(steam, 20)
	if(!do_NOT_delete)
		QDEL_IN(src, 2 SECONDS)


/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/particle_effect/sparks
	name = "sparks"
	icon_state = "sparks"
	var/amount = 6
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/move_count = 0
	var/time_waiting = 0

/obj/effect/particle_effect/sparks/Initialize(mapload, ...)
	. = ..()
	playsound(loc, "sparks", 25, 1)
	START_PROCESSING(SSfasteffects, src)
	QDEL_IN(src, 10 SECONDS)

/obj/effect/particle_effect/sparks/process(delta_time)
	if (move_count == 0)
		STOP_PROCESSING(SSfasteffects, src)

	time_waiting += delta_time
	for (var/iter = 0, iter < floor(time_waiting/0.5), iter++)
		step(src, dir)
		move_count--
		if (move_count == 0)
			STOP_PROCESSING(SSfasteffects, src)
		time_waiting -= 0.5

/datum/effect_system/spark_spread/set_up(particle_count = 3, cardinal_dirs_only = FALSE, target)
	if(particle_count > 10)
		particle_count = 10
	number = particle_count
	cardinals = cardinal_dirs_only
	if(istype(target, /turf/))
		location = target
	else
		location = get_turf(target)

/datum/effect_system/spark_spread/proc/create_sparks(current_particle)
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/sparks/sparks = new /obj/effect/particle_effect/sparks(location)
	var/direction
	if(cardinals)
		direction = pick(GLOB.cardinals)
	else
		direction = pick(GLOB.alldirs)
	sparks.setDir(direction)
	sparks.move_count = pick(1, 2, 3)
	QDEL_IN(sparks, 2 SECONDS)

/datum/effect_system/spark_spread/start(do_NOT_delete = FALSE)
	var/current_particle = 0
	for(current_particle=0, current_particle<min(number, 20), current_particle++)
		INVOKE_ASYNC(src, PROC_REF(create_sparks), current_particle)
	if(!do_NOT_delete)
		QDEL_IN(src, 2 SECONDS)

/datum/effect_system/spark_spread/proc/setup_and_start(particle_count = 3, cardinal_dirs_only = FALSE, target)
	set_up(particle_count, cardinal_dirs_only, target)
	start()

/datum/effect_system/spark_spread/proc/setup_and_start_with_delay(particle_count = 3, cardinal_dirs_only = FALSE, target, delay = null)
	var/datum/callback/callback = CALLBACK(src, PROC_REF(setup_and_start), particle_count, cardinal_dirs_only, target)
	if (delay)
		addtimer(callback, delay)
	else
		callback.Invoke()


/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/obj/effect/particle_effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = TRUE

/datum/effect_system/ion_trail_follow
	var/turf/oldposition
	var/processing = TRUE
	var/on = TRUE

/datum/effect_system/ion_trail_follow/Destroy()
	. = ..()
	oldposition = null

/datum/effect_system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/ion_trail_follow/start(do_NOT_delete = FALSE)
	if(!do_NOT_delete)
		qdel(src) // The recursive spawn loop below is so screwed we only support explicit deletion as in the single instance of code using it
		return

	if(!on)
		on = TRUE
		processing = TRUE
	if(processing)
		processing = FALSE
		spawn(0)
			var/turf/turf = get_turf(holder)
			if(isnull(turf))
				qdel(src)
				return
			if(turf != oldposition)
				if(istype(turf, /turf/open/space))
					var/obj/effect/particle_effect/ion_trails/trails = new /obj/effect/particle_effect/ion_trails(oldposition)
					oldposition = turf
					trails.setDir(holder.dir)
					flick("ion_fade", trails)
					trails.icon_state = "blank"
					QDEL_IN(trails, 20)
				spawn(2)
					if(on)
						processing = TRUE
						start(do_NOT_delete)
			else
				spawn(2)
					if(on)
						processing = TRUE
						start(do_NOT_delete)

/datum/effect_system/ion_trail_follow/proc/stop()
	processing = FALSE
	on = FALSE
