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
	var/setup = 0

/datum/effect_system/proc/set_up(amount = 3, args_cardinals = 0, turf/loca)
	if(amount > 10)
		amount = 10
	number = amount
	cardinals = args_cardinals
	location = loca
	setup = 1

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

/datum/effect_system/steam_spread/set_up(amount = 3, args_cardinals = 0, turf/loc)
	if(amount > 10)
		amount = 10
	number = amount
	cardinals = args_cardinals
	location = loc

/datum/effect_system/steam_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/particle_effect/steam/steam = new /obj/effect/particle_effect/steam(src.location)
			var/direction
			if(src.cardinals)
				direction = pick(cardinal)
			else
				direction = pick(alldirs)
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
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/amount = 6
	var/sound_to_play = "sparks"

/obj/effect/particle_effect/sparks/New()
	..()
	if(sound_to_play)
		playsound(src.loc, sound_to_play, 25, 1)
// var/turf/T = src.loc
// if (istype(T, /turf))
// T.hotspot_expose(1000,100)
	spawn (100)
		qdel(src)

/obj/effect/particle_effect/sparks/armor_shards
	name = "armor shards"
	icon_state = "white_sparks"
	sound_to_play = null
	amount = 4

/datum/effect_system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!
	var/obj/effect/particle_effect/sparks/sparks_type = /obj/effect/particle_effect/sparks

/datum/effect_system/spark_spread/set_up(amount = 3, args_cardinals = 0, loca)
	if(amount > 10)
		amount = 10
	number = amount
	cardinals = args_cardinals
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect_system/spark_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_sparks > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/particle_effect/sparks/sparks = new sparks_type(src.location)
			src.total_sparks++
			var/direction
			if(src.cardinals)
				direction = pick(cardinal)
			else
				direction = pick(alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(sparks,direction)
			spawn(20)
				if(sparks)
					qdel(sparks)
				total_sparks--

/datum/effect_system/spark_spread/armor_shards
	sparks_type = /obj/effect/particle_effect/sparks/armor_shards

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
	var/processing = 1
	var/on = 1

/datum/effect_system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/ion_trail_follow/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			var/turf/T = get_turf(src.holder)
			if(T != src.oldposition)
				if(istype(T, /turf/open/space))
					var/obj/effect/particle_effect/ion_trails/I = new /obj/effect/particle_effect/ion_trails(src.oldposition)
					src.oldposition = T
					I.setDir(src.holder.dir)
					flick("ion_fade", I)
					I.icon_state = "blank"
					QDEL_IN(I, 20)
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect_system/ion_trail_follow/proc/stop()
	src.processing = 0
	src.on = 0




/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect_system/steam_trail_follow
	var/turf/oldposition
	var/processing = 1
	var/on = 1

/datum/effect_system/steam_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/steam_trail_follow/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			if(src.number < 3)
				var/obj/effect/particle_effect/steam/I = new /obj/effect/particle_effect/steam(src.oldposition)
				src.number++
				src.oldposition = get_turf(holder)
				I.setDir(src.holder.dir)
				spawn(10)
					qdel(I)
					number--
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect_system/steam_trail_follow/proc/stop()
	src.processing = 0
	src.on = 0

