
/obj/item/stack/yautja_rope
	name = "strange rope"
	singular_name = "rope meter"
	desc = "This unassuming rope seems to be covered in markings depicting strange humanoid forms."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "coil"
	item_state = "coil"
	force = 2
	w_class = SIZE_SMALL
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	color = "#D2B48C"
	attack_speed = 1.4 SECONDS //stop spam
	amount = 8
	max_amount = 8

/obj/item/stack/yautja_rope/attack(mob/living/mob_victim, mob/living/carbon/human/user)
	if(mob_victim.stat != DEAD)
		return ..()

	if(mob_victim.mob_size != MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("[mob_victim] has the wrong body plan to hang up."))
		return TRUE

	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		to_chat(user, SPAN_WARNING("You're not strong enough to lift [mob_victim] up with a rope. Also, that's kind of fucked up."))
		return TRUE

	var/mob/living/carbon/human/victim = mob_victim

	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		return TRUE

	user.visible_message(SPAN_NOTICE("[user] starts to secure \his rope to the ceiling..."),
		SPAN_NOTICE("You start securing the rope to the ceiling..."))

	if(do_after(user, 4 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		var/turf/rturf = get_turf(victim)
		var/area/rarea = get_area(victim)
		if(rturf.density)
			to_chat(user, SPAN_WARNING("They're in a wall!"))
			return TRUE
		if(rarea.ceiling == CEILING_NONE && !(rarea.flags_area & AREA_YAUTJA_HANGABLE))
			to_chat(user, SPAN_WARNING("There's nothing to hang them from!"))
			return TRUE
		user.visible_message(SPAN_NOTICE("[user] secures the rope."),
			SPAN_NOTICE("You secure the rope."))
		if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
			return
		user.visible_message(SPAN_WARNING("[user] begins hanging [victim] up by the rope..."),
			SPAN_NOTICE("You start hanging [victim] up by the rope..."))
		if(!do_after(user, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
			return
		if(victim.anchored)
			return // Just in case weed_food took them during this time
		user.visible_message(SPAN_WARNING("[user] hangs [victim] from the ceiling!"), SPAN_NOTICE("You finish hanging [victim]."))
		user.stop_pulling()
		victim.get_hung()
		use(1)
	return TRUE

/mob/living/carbon/human/proc/get_hung()
	animate(src, pixel_y = 9, time = 0.5 SECONDS, easing = SINE_EASING|EASE_OUT)
	setDir(SOUTH)
	var/matrix/A = matrix()
	A.Turn(180)
	apply_transform(A)
	var/rand_swing = rand(6, 3)
	//-6, -3
	animate(src, pixel_x = (rand_swing * -1), time = 3 SECONDS, loop = -1, easing = SINE_EASING|EASE_OUT)
	animate(pixel_x = rand_swing, time = 3 SECONDS,  easing = SINE_EASING|EASE_OUT)

	anchored = TRUE
	RegisterSignal(src, COMSIG_ATTEMPT_MOB_PULL, PROC_REF(deny_pull))
	RegisterSignal(src, list(
		COMSIG_ITEM_ATTEMPT_ATTACK,
		COMSIG_LIVING_REJUVENATED,
		COMSIG_HUMAN_REVIVED
		), PROC_REF(cut_down))

/mob/living/carbon/human/proc/deny_pull()
	return COMPONENT_CANCEL_MOB_PULL

/mob/living/carbon/human/proc/cut_down(mob/living/carbon/human/target, mob/living/user, obj/item/source)
	//source = item, target = src
	SIGNAL_HANDLER
	if(source && !source.sharp)
		return

	if(user)
		if(user.a_intent != INTENT_HELP)
			return
		user.visible_message(SPAN_WARNING("[user] cuts down [src] with \the [source]."), SPAN_WARNING("You cut down [src] with \the [source]."))
		user.animation_attack_on(src)
		playsound(src, 'sound/effects/vegetation_hit.ogg', 25, TRUE)
	else
		visible_message(SPAN_DANGER("[src]'s body falls down from the hanging rope!"))
	UnregisterSignal(src, list(
			COMSIG_ATTEMPT_MOB_PULL,
			COMSIG_ITEM_ATTEMPT_ATTACK,
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED
		))
	animate(src) //remove the anims
	anchored = FALSE
	var/matrix/A = matrix()
	A.Turn(90)
	apply_transform(A)
	pixel_x = 0
	pixel_y = 0
	Moved(loc, NONE, TRUE) // Trigger any movement signals
	return COMPONENT_CANCEL_ATTACK
