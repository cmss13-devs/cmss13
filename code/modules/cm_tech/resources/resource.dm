/area
	var/obj/structure/resource_node/r_node

/obj/structure/resource_node
	name = "\improper power node"
	desc = "Generates vast amounts of energy. As a Marine, use a wrench to capture and welder to repair. As a Xeno, click as a builder caste to capture and repair."
	icon = 'icons/obj/structures/resources_64x64.dmi'
	icon_state = "node_off"

	var/last_looped = 0

	var/sound/ambient_noise = 'sound/machines/resource_node/node_idle.ogg'
	var/resources_per_second = RESOURCE_PER_SECOND
	var/active = FALSE

	var/width = 2
	var/height = 2

	var/time_to_repair = 10 SECONDS
	var/time_to_build = 15 SECONDS

	var/max_health = RESOURCE_HEALTH
	health = RESOURCE_HEALTH // Xenos/marines will have to slash the opposing faction's things off of the resource_node

	unslashable = TRUE
	unacidable = TRUE

	explo_proof = TRUE
	anchored = TRUE

	density = TRUE

	var/play_ambient_noise = TRUE
	var/is_area_controller = FALSE
	var/area/controlled_area

/obj/structure/resource_node/area_controller
	is_area_controller = TRUE

/obj/structure/resource_node/Initialize(mapload, play_ambient_noise = TRUE)
	. = ..()
	bound_width = width * world.icon_size
	bound_height = height * world.icon_size

	src.play_ambient_noise = play_ambient_noise

	if(is_area_controller)
		var/area/A = get_area(src)
		if(!A)
			return

		if(A.r_node)
			qdel(A.r_node)

		controlled_area = A
		A.r_node = src

/obj/structure/resource_node/Destroy()
	if(controlled_area && controlled_area.r_node == src)
		controlled_area.r_node = null
	controlled_area = null
	return ..()

/obj/structure/resource_node/initialize_pass_flags(datum/pass_flags_container/PF)
	. = ..()
	if(PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/resource_node/update_icon()
	overlays.Cut()

	if(active)
		icon_state = "node_on"
	else
		icon_state = "node_off"

/obj/structure/resource_node/proc/healthcheck()
	if(health > 0)
		return

	STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/resource_node/proc/take_damage(damage)
	health = clamp(health - damage, 0, max_health)
	healthcheck()

/obj/structure/resource_node/bullet_act(obj/projectile/P)
	take_damage(P.damage)

/obj/structure/resource_node/ex_act(severity, direction)
	take_damage(severity*0.1) // Reduced damage from explosives

/obj/structure/resource_node/flamer_fire_act(dam)
	take_damage(dam)

/obj/structure/resource_node/process(delta_time)
	if(!active)
		STOP_PROCESSING(SSobj, src)
		return
	if(last_looped < world.time && play_ambient_noise)
		playsound(loc, ambient_noise, 50)
		last_looped = world.time + 3 SECONDS

/obj/structure/resource_node/proc/make_active()
	START_PROCESSING(SSobj, src)
	playsound(loc, 'sound/machines/resource_node/node_turn_on_2.ogg', 75)

	active = TRUE
	update_icon()

/obj/structure/resource_node/proc/make_inactive()
	STOP_PROCESSING(SSobj, src)
	playsound(loc, 'sound/machines/resource_node/node_turn_off.ogg', 75)

	active = FALSE
	update_icon()

/obj/structure/resource_node/get_projectile_hit_boolean()
	return TRUE

/obj/structure/resource_node/get_examine_text(mob/user)
	. = ..()
	. += SPAN_BLUE("Health: [health]/[max_health]")


/obj/structure/resource_node/attackby(obj/item/W, mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		return

	if(!active)
		to_chat(H, SPAN_WARNING("[src] isn't active right now!"))
		return
	if(H.action_busy)
		to_chat(H, SPAN_WARNING("You're already performing an action!"))
		return

	H.visible_message(SPAN_DANGER("[H] starts to set up [src]."),
	SPAN_NOTICE("You begin to set up [src]."), max_distance = 3)
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)

	if(!do_after(H, time_to_build * H.get_skill_duration_multiplier(SKILL_ENGINEER), BEHAVIOR_IMMOBILE|INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL))
		to_chat(H, SPAN_NOTICE("You decide not to apply [W] onto [src]."))
		return

	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	H.visible_message(SPAN_DANGER("[H] sets up [src]."),
	SPAN_NOTICE("You set up [src]."), max_distance = 3)

/obj/structure/resource_node/attack_alien(mob/living/carbon/xenomorph/M)
	if(!isxeno_builder(M))
		to_chat(M, SPAN_XENOWARNING("You can't build onto [src]."))
		return XENO_NO_DELAY_ACTION

	if(!active)
		to_chat(M, SPAN_XENOWARNING("[src] isn't active right now!"))
		return XENO_NO_DELAY_ACTION

	if(M.action_busy)
		to_chat(M, SPAN_WARNING("You're already performing an action!"))
		return XENO_NO_DELAY_ACTION

	M.visible_message(SPAN_DANGER("[M] starts secreting resin over [src]."),
	SPAN_XENONOTICE("You begin to connect [src] to the hive."), max_distance = 3)
	xeno_attack_delay(M)

	if(!do_after(M, time_to_build, BEHAVIOR_IMMOBILE|INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL))
		to_chat(M, SPAN_XENOWARNING("You decide not to connect [src] to the hive."))
		return XENO_NO_DELAY_ACTION

	M.visible_message(SPAN_DANGER("[M] secretes resin over [src]."),
	SPAN_XENONOTICE("You connect [src] to the hive."), max_distance = 3)

	return XENO_NO_DELAY_ACTION
