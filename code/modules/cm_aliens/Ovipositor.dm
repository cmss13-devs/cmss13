#define QUEEN_OVIPOSITOR_DECAY_TIME 500

/obj/ovipositor
	name = "Egg Sac"
	icon = 'icons/mob/xenos/castes/tier_4/ovipositor.dmi'
	icon_state = "ovipositor"
	unacidable = TRUE
	var/begin_decay_time = 0
	health = 50
	var/decayed = FALSE // This is here so later on we can use the ovpositor molt for research. ~BMC777
	var/destroyed = FALSE

/obj/ovipositor/Initialize(mapload, ...)
	. = ..()

	begin_decay_time = world.timeofday + QUEEN_OVIPOSITOR_DECAY_TIME
	START_PROCESSING(SSoldeffects, src) // Process every second

/obj/ovipositor/Destroy()
	if(!decayed && !destroyed)
		STOP_PROCESSING(SSoldeffects, src)

	return ..()

/obj/ovipositor/process()
	if (health < 0)
		explode()
		return

	if (world.timeofday > begin_decay_time)
		do_decay()

/obj/ovipositor/proc/do_decay()
	decayed = TRUE
	STOP_PROCESSING(SSoldeffects, src)

	icon_state = "ovipositor_molted"
	flick("ovipositor_decay", src)
	sleep(15)

	var/turf/T = get_turf(src)
	if (T)
		T.overlays += image('icons/mob/xenos/castes/tier_4/ovipositor.dmi', "ovipositor_molted", ATMOS_DEVICE_LAYER) //ATMOS_DEVICE_LAYER so that the ovi is above weeds, blood, and resin weed nodes.

	qdel(src)

/obj/ovipositor/proc/explode()
	destroyed = TRUE
	STOP_PROCESSING(SSoldeffects, src)

	icon_state = "ovipositor_gibbed"
	flick("ovipositor_explosion", src)
	sleep(15)

	var/turf/T = get_turf(src)
	if (T)
		T.overlays += image('icons/mob/xenos/castes/tier_4/ovipositor.dmi', "ovipositor_gibbed", ATMOS_DEVICE_LAYER)

	qdel(src)

/obj/ovipositor/ex_act(severity)
	health -= severity/4

//Every other type of nonhuman mob
/obj/ovipositor/attack_alien(mob/living/carbon/xenomorph/M)
	switch(M.a_intent)
		if(INTENT_HELP)
			M.visible_message(SPAN_NOTICE("\The [M] caresses [src] with its claws."),
			SPAN_NOTICE("You caress [src] with your claws."))

		if(INTENT_GRAB)
			if(M == src || anchored)
				return XENO_NO_DELAY_ACTION

			if(Adjacent(M)) //Logic!
				M.start_pulling(src)

		else
			M.animation_attack_on(src)
			var/damage = (rand(M.melee_damage_lower, M.melee_damage_upper) + 3)
			M.visible_message(SPAN_DANGER("\The [M] bites [src]!"),
			SPAN_DANGER("You bite [src]!"))
			health -= damage

	return XENO_ATTACK_ACTION

/obj/ovipositor/attack_larva(mob/living/carbon/xenomorph/larva/M)
	M.visible_message(SPAN_DANGER("[M] nudges its head against [src]."),
	SPAN_DANGER("You nudge your head against [src]."))

// Density override
/obj/ovipositor/get_projectile_hit_boolean(obj/projectile/P)
	return TRUE

/obj/ovipositor/bullet_act(obj/projectile/Proj)
	health -= Proj.damage
	return 1
