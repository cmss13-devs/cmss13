/obj/structure/lessers_burrow
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "hole"

	density = FALSE
	opacity = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = RESIN_STRUCTURE_LAYER
	plane = FLOOR_PLANE

	var/hivenumber = XENO_HIVE_NORMAL
	var/datum/hive_status/hive
	var/last_spawning = 0
	var/spawn_cooldown = XENO_LESSER_BURROW_SPAWN_TIME

	health = 140
	var/id = null //For mapping

/obj/structure/lessers_burrow/Initialize(mapload, h_number)
	. = ..()
	var/turf/L = get_turf(src)

	if(h_number && GLOB.hive_datum[h_number])
		hivenumber = h_number
		hive = GLOB.hive_datum[h_number]

		set_hive_data(src, h_number)

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

	var/obj/effect/alien/resin/trap/resin_trap = locate() in L
	if(resin_trap)
		qdel(resin_trap)

	handle_spawning()

/obj/structure/lessers_burrow/proc/handle_spawning()
	last_spawning = world.time
	visible_message(SPAN_WARNING("[src] starts rumbling!"))
	for(var/i = 1; i <= XENO_LESSER_BURROW_AMOUNT; i++)
		addtimer(CALLBACK(src, PROC_REF(spawn_alien)), XENO_LESSER_BURROW_SPAWN_QUEUE_TIME * i)

/obj/structure/lessers_burrow/proc/spawn_alien()
	if(prob(10))
		new /mob/living/simple_animal/hostile/alien/spawnable/tearer(get_turf(src))
		return
	new /mob/living/simple_animal/hostile/alien/spawnable/trooper(get_turf(src))

/obj/structure/lessers_burrow/attackby(obj/item/W as obj, mob/user as mob)
	if(!isxeno(user))
		if(istype(W, /obj/item/tool/shovel))
			var/obj/item/tool/shovel/destroying_shovel = W

			if(destroying_shovel.folded)
				return

			playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)

			user.visible_message(SPAN_NOTICE("[user] starts to collapse [src]!"), SPAN_NOTICE("You start collapsing [src]!"))

			if(user.action_busy || !do_after(user, TUNNEL_COLLAPSING_TIME * ((100 - destroying_shovel.shovelspeed) * 0.01), INTERRUPT_ALL, BUSY_ICON_BUILD))
				return

			playsound(loc, 'sound/effects/tunnel_collapse.ogg', 50)

			visible_message(SPAN_NOTICE("[src] collapses in on itself."))

			qdel(src)
		else if (user.a_intent != INTENT_HARM)
			user.visible_message(SPAN_NOTICE("[user] knocks in the [src]"), SPAN_NOTICE("You knock in the [src]."))

			if (last_spawning + spawn_cooldown <= world.time)
				handle_spawning()

			return

		return ..()
	return attack_alien(user)

/obj/structure/lessers_burrow/attack_larva(mob/living/carbon/xenomorph/M)
	. = attack_alien(M)

/obj/structure/lessers_burrow/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M) || M.stat || M.lying)
		return XENO_NO_DELAY_ACTION

	if(!isfriendly(M))
		if(M.mob_size < MOB_SIZE_BIG)
			to_chat(M, SPAN_XENOWARNING("You aren't large enough to collapse this tunnel!"))
			return XENO_NO_DELAY_ACTION

		M.visible_message(SPAN_XENODANGER("[M] begins to fill [src] with dirt."),\
		SPAN_XENONOTICE("You begin to fill [src] with dirt using your massive claws."), max_distance = 3)
		xeno_attack_delay(M)

		if(!do_after(M, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL_OUT_OF_RANGE, max_dist = 1))
			to_chat(M, SPAN_XENOWARNING("You decide not to cave the tunnel in."))
			return XENO_NO_DELAY_ACTION

		src.visible_message(SPAN_XENODANGER("[src] caves in!"), max_distance = 3)
		qdel(src)

		return XENO_NO_DELAY_ACTION

	if (last_spawning + spawn_cooldown <= world.time)
		M.visible_message(SPAN_WARNING("[M] made few knocks on [src]"), SPAN_XENONOTICE("You call your lesser sisters"))
		handle_spawning()
	else
		to_chat(M, SPAN_XENOWARNING("It's not time yet! New lesser sisters will arrive in [world.time - (last_spawning + spawn_cooldown)]!"))
	return XENO_NO_DELAY_ACTION

/obj/structure/lessers_burrow/proc/isfriendly(mob/target)
	var/mob/living/carbon/C = target
	if(istype(C) && C.ally_of_hivenumber(hivenumber))
		return TRUE

	return FALSE

/obj/structure/lessers_burrow/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] suddenly collapses!"))
		qdel(src)

/obj/structure/lessers_burrow/bullet_act(obj/item/projectile/Proj)
	return FALSE

/obj/structure/lessers_burrow/ex_act(severity)
	health -= severity/2
	healthcheck()
