/obj/structure/punching_bag
	name = "punching bag"
	desc = "A punching bag. Can you get to speed level 4???"
	icon = 'icons/obj/structures/fitness.dmi'
	icon_state = "punchingbag"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	var/list/hit_sounds = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg',
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg'
	)

/obj/structure/punching_bag/attack_hand(mob/user)
	if(!ishuman(user))
		return
	flick("[icon_state]2", src)
	playsound(loc, pick(hit_sounds), 25, TRUE, 3)

/obj/structure/punching_bag/attack_alien(mob/living/carbon/xenomorph/Mob)
	Mob.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	Mob.visible_message(SPAN_DANGER("[Mob] slices \the [src] apart!"),
	SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	qdel(src)
	return XENO_ATTACK_ACTION

/obj/structure/weightmachine
	name = "weight machine"
	desc = "Just looking at this thing makes you feel tired."
	density = TRUE
	anchored = TRUE
	var/inuse_stun_time = 7 SECONDS
	var/icon_state_inuse

/obj/structure/weightmachine/proc/animate_machine(mob/living/user)
	return

/obj/structure/weightmachine/attack_hand(mob/living/user)
	if(!ishuman(user))
		return
	if(in_use)
		to_chat(user, SPAN_WARNING("It's already in use - wait a bit."))
		return
	else
		in_use = TRUE
		icon_state = icon_state_inuse
		user.setDir(SOUTH)
		user.Stun(inuse_stun_time / GLOBAL_STATUS_MULTIPLIER)
		user.forceMove(src.loc)
		var/bragmessage = pick("pushing it to the limit", "going into overdrive", "burning with determination", "rising up to the challenge", "getting strong now", "getting ripped")
		user.visible_message(SPAN_BOLD("[user] is [bragmessage]!"))
		animate_machine(user)

		playsound(user, 'sound/machines/click.ogg', 40, TRUE, 2)
		in_use = FALSE
		user.pixel_z = 0
		var/finishmessage = pick("You feel stronger!", "You feel like you can take on the world!", "You feel robust!", "You feel indestructible!")
		icon_state = initial(icon_state)
		to_chat(user, SPAN_NOTICE(finishmessage))

/obj/structure/weightmachine/attack_alien(mob/living/carbon/xenomorph/Mob)
	Mob.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	Mob.visible_message(SPAN_DANGER("[Mob] slices \the [src] apart!"),
	SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	qdel(src)
	return XENO_ATTACK_ACTION

/obj/structure/weightmachine/stacklifter
	icon = 'icons/obj/structures/fitness.dmi'
	icon_state = "fitnesslifter"
	icon_state_inuse = "fitnesslifter2"
	inuse_stun_time = 5.5 SECONDS

/obj/structure/weightmachine/stacklifter/animate_machine(mob/living/user)
	for(var/lift in 1 to 6)
		if(user.loc != loc)
			break
		animate(user, pixel_z = -2, time = 3, delay = 3)
		animate(pixel_z = -4, time = 3)
		stoplag(9 DECISECONDS)
		playsound(user, 'sound/effects/spring.ogg', 40, TRUE, 2)

/obj/structure/weightmachine/weightlifter
	icon = 'icons/obj/structures/fitness.dmi'
	icon_state = "fitnessweight"
	icon_state_inuse = "fitnessweight-c"
	inuse_stun_time = 7 SECONDS

/obj/structure/weightmachine/weightlifter/animate_machine(mob/living/user)
	var/mutable_appearance/swole_overlay = mutable_appearance(icon, "fitnessweight-w", ABOVE_MOB_LAYER)
	overlays += swole_overlay
	user.pixel_z = 5
	for(var/reps in 1 to 6)
		if(user.loc != src.loc)
			break
		for(var/innerReps = max(reps, 1), innerReps > 0, innerReps--)
			stoplag(3 DECISECONDS)
			animate(user, pixel_z = (user.pixel_z == 3) ? 5 : 3, time = 3)
		playsound(user, 'sound/effects/spring.ogg', 40, TRUE, 2)
	animate(user, pixel_z = 2, time = 3, delay = 3)
	stoplag(6 DECISECONDS)
	overlays -= swole_overlay

// Treadmill

/obj/structure/machinery/treadmill
	icon = 'icons/obj/structures/treadmill.dmi'
	icon_state = "back_off"
	name = "treadmill"
	desc = "A treadmill used for cardio related exercise."
	layer = CONVEYOR_LAYER // so they appear under stuff
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 50
	var/datum/weakref/second_half_ref

/obj/structure/machinery/treadmill/console
	icon_state = "console_nopower"

/obj/structure/machinery/treadmill/Destroy()
	stop_processing()
	if(second_half_ref)
		var/obj/structure/machinery/treadmill/second_half = second_half_ref?.resolve()
		second_half.second_half_ref = null
		qdel(second_half)
		second_half_ref = null
	return ..()

/obj/structure/machinery/treadmill/update_icon()
	. = ..()
	if(machine_processing && !(stat & NOPOWER))
		icon_state = "back_on"
	else
		icon_state = "back_off"

/obj/structure/machinery/treadmill/Crossed(atom/movable/thing)
	. = ..()
	var/mob/entering_mob = thing
	if(!istype(entering_mob))
		return
	entering_mob.pixel_z += pixel_y + 2

/obj/structure/machinery/treadmill/Uncrossed(atom/movable/thing)
	. = ..()
	var/mob/exiting_mob = thing
	if(!istype(exiting_mob))
		return
	exiting_mob.pixel_z -= pixel_y + 2

/obj/structure/machinery/treadmill/proc/toggle_running(force_state = null)
	var/to_process = FALSE
	if(!isnull(force_state))
		to_process = force_state
	else
		to_process = !machine_processing

	if(to_process)
		start_processing()
	else
		stop_processing()

	update_icon()
	update_use_power(machine_processing ? USE_POWER_ACTIVE : USE_POWER_IDLE)

/obj/structure/machinery/treadmill/process()
	if(inoperable())
		return PROCESS_KILL
	var/items_moved = 0
	for(var/atom/movable/object in loc.contents - src)
		if(!object.anchored)
			if(object.loc == src.loc)
				INVOKE_NEXT_TICK(src, PROC_REF(move_thing), object) // to prevent instant movement
				items_moved++
		if(items_moved >= 10)
			break
	return 1

/obj/structure/machinery/treadmill/proc/move_thing(atom/thing)
	step(thing, turn(dir, 180))

/obj/structure/machinery/treadmill/console/Initialize(mapload, ...)
	. = ..()
	var/turf/back_turf = get_step(src, turn(dir, 180))
	for(var/obj/object in back_turf)
		if(object.type == /obj/structure/machinery/treadmill)
			var/obj/structure/machinery/treadmill/sec_half = object
			second_half_ref = WEAKREF(sec_half)
			sec_half.second_half_ref = WEAKREF(src)
			return

/obj/structure/machinery/treadmill/console/update_icon()
	overlays.Cut()
	. = ..()
	if(machine_processing)
		icon_state = "console_on"
	else
		icon_state = "console_off"
	if((stat & NOPOWER))
		icon_state = "console_nopower"
	var/mutable_appearance/handles_overlay = mutable_appearance(icon = icon, icon_state = "treadmill_overlay", layer = BIG_XENO_LAYER)
	overlays += handles_overlay

/obj/structure/machinery/treadmill/console/toggle_running()
	..()
	var/obj/structure/machinery/treadmill/back = second_half_ref?.resolve()
	if(istype(back))
		back.toggle_running(machine_processing)

/obj/structure/machinery/treadmill/console/attack_hand(mob/user)
	toggle_running()
