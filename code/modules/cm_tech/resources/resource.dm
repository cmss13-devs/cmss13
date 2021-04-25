/area
	var/obj/structure/resource_node/r_node

/obj/structure/resource_node
	name = "\improper power node"
	desc = "Generates vast amounts of energy."
	icon = 'icons/obj/structures/resources_64x64.dmi'
	icon_state = "node_off"

	var/last_looped = 0

	var/sound/ambient_noise = 'sound/machines/resource_node/node_idle.ogg'

	var/treeid = TREE_NONE
	var/datum/techtree/tree

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

	indestructible = TRUE
	anchored = TRUE

	density = TRUE

	var/play_ambient_noise = TRUE
	var/is_area_controller = FALSE
	var/area/controlled_area

/obj/structure/resource_node/area_controller
	is_area_controller = TRUE

/obj/structure/resource_node/Initialize(mapload, var/play_ambient_noise = TRUE)
	. = ..()
	bound_width = width * world.icon_size
	bound_height = height * world.icon_size

	SStechtree.resources.Add(src)

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
	if(tree)
		tree.on_node_lost(src)

	SStechtree.resources.Remove(src)

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

	if(!tree)
		return

	overlays += image(icon, icon_state = tree.resource_icon_state)

/obj/structure/resource_node/proc/healthcheck()
	if(health > 0 || treeid == TREE_NONE)
		return

	STOP_PROCESSING(SSobj, src)

	if(!tree)
		return

	playsound(loc, tree.resource_destroy_sound, 50, TRUE)

	set_tree(TREE_NONE)
	update_icon()

/obj/structure/resource_node/proc/take_damage(var/damage)
	if(!tree)
		return
	playsound(loc, tree.resource_break_sound, 50, TRUE)

	health = Clamp(health - damage, 0, max_health)
	healthcheck()

/obj/structure/resource_node/bullet_act(obj/item/projectile/P)
	take_damage(P.damage)

/obj/structure/resource_node/ex_act(severity, direction)
	take_damage(severity*0.1) // Reduced damage from explosives

/obj/structure/resource_node/flamer_fire_act(dam)
	take_damage(dam)

/obj/structure/resource_node/process(delta_time)
	if(!active)
		STOP_PROCESSING(SSobj, src)
		return

	if(tree)
		tree.on_process(src, delta_time)
		tree.add_points(resources_per_second * delta_time)


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
	return !isnull(tree)

/obj/structure/resource_node/proc/set_tree(var/treeid)
	if(treeid == TREE_NONE || !treeid)
		if(tree)
			tree.on_node_lost(src)

		src.treeid = TREE_NONE
		tree = null

	var/datum/techtree/T = SStechtree.trees[treeid]
	if(!T)
		return

	START_PROCESSING(SSobj, src)

	if(tree)
		tree.on_node_lost(src)

	health = max_health

	src.treeid = treeid
	tree = T

	playsound(loc, tree.resource_make_sound, 50, TRUE)
	tree.on_node_gained(src)

	update_icon()

/obj/structure/resource_node/examine(mob/user)
	. = ..()
	if(!tree)
		return

	to_chat(user, SPAN_BLUE("[src] belongs to the [tree.name]"))
	to_chat(user, SPAN_BLUE("Health: [health]/[max_health]"))


/obj/structure/resource_node/attackby(obj/item/W, mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(!tree)
		if(!iswrench(W))
			return

		if(!active)
			to_chat(H, SPAN_WARNING("[src] isn't active right now!"))
			return

		if(H.action_busy)
			to_chat(H, SPAN_WARNING("You're already performing an action!"))
			return

		H.visible_message(SPAN_DANGER("[H] starts to set up [src]."),\
		SPAN_NOTICE("You begin to set up [src]."), max_distance = 3)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)

		if(!do_after(H, time_to_build * H.get_skill_duration_multiplier(SKILL_ENGINEER), BEHAVIOR_IMMOBILE|INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL))
			to_chat(H, SPAN_NOTICE("You decide not to apply [W] onto [src]."))
			return

		if(tree)
			return

		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		H.visible_message(SPAN_DANGER("[H] sets up [src]."),\
		SPAN_NOTICE("You set up [src]."), max_distance = 3)

		set_tree(TREE_MARINE)

	else if(tree.can_attack(H))
		H.visible_message(SPAN_DANGER("[H] attacks [src] with [W]!"))

		H.animation_attack_on(src)
		playsound(loc, tree.resource_break_sound, 40, 1)

		take_damage(W.force)
	else
		var/to_heal = (max_health - health)

		if(H.action_busy)
			to_chat(H, SPAN_WARNING("You're already performing an action!"))
			return

		if(!iswelder(W))
			return

		if(!to_heal)
			to_chat(H, SPAN_WARNING("[src] is already at full health!"))
			return

		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0, H))
			H.visible_message(SPAN_NOTICE("[H] starts repairing the damage to [src]."),\
			SPAN_NOTICE("You start repairing the damage to [src]."), max_distance = 3)
			playsound(src, 'sound/items/Welder.ogg', 25, 1)
			if(do_after(H, time_to_repair * H.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src, INTERRUPT_ALL) && H.get_active_hand() == WT && WT.isOn())
				H.visible_message(SPAN_NOTICE("[H] finishes repairing the damage to [src]."),\
				SPAN_NOTICE("You finish repairing the damage to [src]."), max_distance = 3)
				take_damage(-to_heal)

				WT.remove_fuel(Floor(RESOURCE_FUEL_TO_REPAIR*(to_heal / max_health)), H)
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
		else
			to_chat(H, SPAN_WARNING("You need more welding fuel to complete this task."))

/obj/structure/resource_node/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!tree)
		if(!isXenoBuilder(M))
			to_chat(M, SPAN_XENOWARNING("You can't build onto [src]."))
			return XENO_NO_DELAY_ACTION

		if(!active)
			to_chat(M, SPAN_XENOWARNING("[src] isn't active right now!"))
			return XENO_NO_DELAY_ACTION

		if(M.action_busy)
			to_chat(M, SPAN_WARNING("You're already performing an action!"))
			return XENO_NO_DELAY_ACTION

		M.visible_message(SPAN_DANGER("[M] starts secreting resin over [src]."),\
		SPAN_XENONOTICE("You begin to connect [src] to the hive."), max_distance = 3)
		xeno_attack_delay(M)

		if(!do_after(M, time_to_build, BEHAVIOR_IMMOBILE|INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL))
			to_chat(M, SPAN_XENOWARNING("You decide not to connect [src] to the hive."))
			return XENO_NO_DELAY_ACTION

		if(tree)
			return XENO_NO_DELAY_ACTION

		M.visible_message(SPAN_DANGER("[M] secretes resin over [src]."),\
		SPAN_XENONOTICE("You connect [src] to the hive."), max_distance = 3)

		set_tree(TREE_XENO)

	else if(tree.can_attack(M))
		M.visible_message(SPAN_DANGER("[M] slashes [src]."))

		M.animation_attack_on(src)
		take_damage(rand(M.melee_damage_lower, M.melee_damage_upper))
		return XENO_ATTACK_ACTION
	else
		if(M.action_busy)
			to_chat(M, SPAN_WARNING("You're already performing an action!"))
			return XENO_NO_DELAY_ACTION

		var/to_heal = (max_health - health)

		if(!to_heal)
			to_chat(M, SPAN_WARNING("[src] is already at full health!"))
			return XENO_NO_DELAY_ACTION

		var/plasma_to_use = RESOURCE_PLASMA_PER_REPAIR * to_heal

		if(!isXenoBuilder(M)) // Uses 2x the amount of plasma
			plasma_to_use *= 2
			to_chat(M, SPAN_XENOWARNING("Your repairs on [src] will require significantly more work."))

		if(!M.plasma_stored)
			return XENO_NO_DELAY_ACTION

		M.visible_message(SPAN_XENONOTICE("[M] begins secreting resin over [src]."),\
		SPAN_XENONOTICE("You start repairing the damage to [src]."), max_distance = 3)
		xeno_attack_delay(M)

		if(do_after(M, time_to_repair, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src, INTERRUPT_ALL) && M.plasma_stored)
			M.visible_message(SPAN_XENONOTICE("[M] finishes secreting resin over [src]."),\
			SPAN_XENONOTICE("You finish repairing the damage to [src]."), max_distance = 3)

			var/heal_frac = min(M.plasma_stored / plasma_to_use, 1)
			take_damage(-(to_heal*heal_frac))

			playsound(loc, "alien_resin_build", 25, 1)
			M.use_plasma(plasma_to_use)
		else
			to_chat(M, SPAN_NOTICE("You fail to repair [src]."))
	return XENO_NO_DELAY_ACTION
