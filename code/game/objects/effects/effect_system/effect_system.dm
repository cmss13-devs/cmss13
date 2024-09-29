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

/datum/effect_system/proc/start()


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

/datum/effect_system/steam_spread/start()
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

/obj/effect/particle_effect/sparks/New()
	..()
	playsound(loc, "sparks", 25, 1)
// var/turf/turf = src.loc
// if (istype(turf, /turf))
// turf.hotspot_expose(1000,100)
	spawn (100)
		qdel(src)


/datum/effect_system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect_system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect_system/spark_spread/start()
	var/i = 0
	for(i=0, i<number, i++)
		if(total_sparks > 20)
			return
		spawn(0)
			if(holder)
				location = get_turf(holder)
			var/obj/effect/particle_effect/sparks/sparks = new /obj/effect/particle_effect/sparks(location)
			total_sparks++
			var/direction
			if(cardinals)
				direction = pick(GLOB.cardinals)
			else
				direction = pick(GLOB.alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(sparks,direction)
			spawn(20)
				if(sparks)
					qdel(sparks)
				total_sparks--



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

/datum/effect_system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/ion_trail_follow/start()
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
						start()
			else
				spawn(2)
					if(on)
						processing = TRUE
						start()

/datum/effect_system/ion_trail_follow/proc/stop()
	processing = FALSE
	on = FALSE




/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect_system/steam_trail_follow
	var/turf/oldposition
	var/processing = TRUE
	var/on = TRUE

/datum/effect_system/steam_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/steam_trail_follow/start()
	if(!on)
		on = TRUE
		processing = TRUE
	if(processing)
		processing = FALSE
		spawn(0)
			if(number < 3)
				var/obj/effect/particle_effect/steam/trails = new /obj/effect/particle_effect/steam(oldposition)
				number++
				oldposition = get_turf(holder)
				if(isnull(oldposition))
					qdel(src)
					return
				trails.setDir(holder.dir)
				spawn(10)
					qdel(trails)
					number--
				spawn(2)
					if(on)
						processing = TRUE
						start()
			else
				spawn(2)
					if(on)
						processing = TRUE
						start()

/datum/effect_system/steam_trail_follow/proc/stop()
	processing = FALSE
	on = FALSE

