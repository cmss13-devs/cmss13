/obj/effect/random_explosion
	name = "random explosion (short)"
	icon_state = "random_explosion_1"
	anchored = TRUE
	unacidable = TRUE
	/// The shortest possible time it takes to explode
	var/min_time = 45 SECONDS
	/// The longest possible time it takes to explode
	var/max_time = 70 SECONDS

	var/invisibility_value = INVISIBILITY_MAXIMUM

	var/datum/cause_data/cause_data

/obj/effect/random_explosion/New()
	invisibility = invisibility_value
	return ..()

/obj/effect/random_explosion/Initialize(mapload, ...)
	. = ..()
	invisibility = invisibility_value
	START_PROCESSING(SSobj, src)

/obj/effect/random_explosion/process()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		return
	invisibility = invisibility_value
	var/explosion_time = rand(min_time, max_time)
	addtimer(CALLBACK(src, PROC_REF(explode)), explosion_time)
	STOP_PROCESSING(SSobj, src)

/obj/effect/random_explosion/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)
	cause_data = null

/obj/effect/random_explosion/proc/explode()
	src.audible_message(SPAN_HIGHDANGER("Something hisses violently! It's gonna blow!"), SPAN_HIGHDANGER("Something hisses violently! It's gonna blow!"), 10)
	var/datum/effect_system/spark_spread/sparks = new()
	sparks.set_up(n = rand(3,10), loca = loc)
	sparks.start()
	sleep(3 SECONDS)
	new /obj/effect/warning/explosive(loc, 5 SECONDS)
	sleep(5 SECONDS)
	cause_data = create_cause_data("Random explosion effect. Usually mapped in.", null, src)
	cell_explosion(src, 50, 15, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	qdel(src)

/obj/effect/random_explosion/medium
	name = "random explosion (medium)"
	icon_state = "random_explosion_2"
	min_time = 5 MINUTES
	max_time = 20 MINUTES

/obj/effect/random_explosion/long
	name = "random explosion (long)"
	icon_state = "random_explosion_3"
	min_time = 15 MINUTES
	max_time = 30 MINUTES

/obj/effect/random_explosion/uber
	name = "random explosion (uber)"
	icon_state = "random_explosion_4"
	min_time = 20 MINUTES
	max_time = 90 MINUTES
