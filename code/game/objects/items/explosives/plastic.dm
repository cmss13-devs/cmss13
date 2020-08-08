/obj/item/explosive/plastic
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags_item = NOBLUDGEON
	w_class = SIZE_SMALL
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor, /obj/item/device/assembly/signaler, /obj/item/device/assembly/timer)
	max_container_volume = 180
	reaction_limits = list(	"max_ex_power" = 260,	"base_ex_falloff" = 90,	"max_ex_shards" = 64,
							"max_fire_rad" = 6,		"max_fire_int" = 26,	"max_fire_dur" = 30,
							"min_fire_rad" = 2,		"min_fire_int" = 4,		"min_fire_dur" = 5
	)

	var/timer = 10
	var/atom/plant_target = null //which atom the plstique explosive is planted on
	var/overlay_image = "plastic-explosive2"
	var/image/overlay

/obj/item/explosive/plastic/Dispose()
	disarm()
	. = ..()

/obj/item/explosive/plastic/attack(mob/M as mob, mob/user as mob, def_zone)
	return FALSE

/obj/item/explosive/plastic/attack_hand(mob/user)
	if(active)
		to_chat(user, SPAN_WARNING("You can't just pickup [src] while it is active! Use a multitool!"))
		return
	. = ..()

/obj/item/explosive/plastic/attack_self(mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	. = ..()
	if(customizable && detonator)
		if(istimer(detonator.a_right) || istimer(detonator.a_left))
			detonator.attack_self(user)
		return
	var/new_time = input(usr, "Please set the timer.", "Timer", 10) as num
	if(new_time < 10)
		new_time = 10
	else if(new_time > 60)
		new_time = 60

	timer = new_time
	to_chat(user, SPAN_NOTICE("Timer set for [timer] seconds."))

/obj/item/explosive/plastic/afterattack(atom/target, mob/user, flag)
	if(user.action_busy || !flag)
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	if(!can_place(user, target))
		return

	user.visible_message(SPAN_WARNING("[user] is trying to plant [name] on [target]!"),
	SPAN_WARNING("You are trying to plant [name] on [target]!"))
	if(ismob(target))
		var/mob/M = target
		to_chat(M, FONT_SIZE_HUGE(SPAN_DANGER("[user] is trying to plant [name] on you!")))

	if(!do_after(user, 50, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		if(!ismob(target))
			disarm()
		return

	user.drop_held_item()
	source_mob = user
	plant_target = target
	icon_state = overlay_image

	if(!istype(target, /obj/structure/window) && !istype(target, /turf/closed))
		user.drop_held_item()
		target.contents += src
		overlay = image('icons/obj/items/assemblies.dmi', overlay_image)
		overlay.layer = ABOVE_XENO_LAYER
		target.overlays += overlay
	else
		calculate_pixel_offset(user, target)

	if(ismob(target))
		var/mob/M = target
		to_chat(M, FONT_SIZE_HUGE(SPAN_DANGER("[user] plants [name] on you!")))
		user.attack_log += "\[[time_stamp()]\] <font color='red'> [key_name(user)] successfully planted [name] on [key_name(target)]</font>"
		msg_admin_niche("[key_name(user, user.client)](<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[user]'>?</A>) planted [src.name] on [key_name(target)](<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[target]'>?</A>) with [timer] second fuse")
		log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")
	else
		msg_admin_niche("[key_name(user, user.client)](<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[user]'>?</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse")
		log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

	if(customizable)
		user.visible_message(SPAN_WARNING("[user] plants [name] on [target]!"),
		SPAN_WARNING("You plant [name] on [target]!."))
		activate_sensors()
		if(!istimer(detonator.a_right) && !istimer(detonator.a_left))
			icon_state = overlay_image
	else
		user.visible_message(SPAN_WARNING("[user] plants [name] on [target]!"),
		SPAN_WARNING("You plant [name] on [target]! Timer counting down from [timer]."))
		active = TRUE
		add_timer(CALLBACK(src, .proc/prime), timer * 10)

/obj/item/explosive/plastic/attackby(obj/item/W, mob/user)
	if(ismultitool(W))
		if(active)
			if(user.action_busy)
				return
			user.visible_message(SPAN_NOTICE("[user] starts disarming [src]."), \
			SPAN_NOTICE("You start disarming [src]."))
			if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
				user.visible_message(SPAN_WARNING("[user] stops disarming [src]."), \
					SPAN_WARNING("You stop disarming [src]."))
				return
			if(!active)//someone beat us to it
				return
			user.visible_message(SPAN_NOTICE("[user] finishes disarming [src]."), \
			SPAN_NOTICE("You finish disarming [src]."))
			disarm()
	else
		return ..()

/obj/item/explosive/plastic/proc/disarm()
	pixel_x = 0
	pixel_y = 0
	if(plant_target && !istype(plant_target, /obj/structure/window) & !istype(plant_target, /turf/closed))
		plant_target.overlays -= overlay
		qdel(overlay)
		plant_target.contents -= src
		forceMove(get_turf(plant_target.loc))
	plant_target = null
	if(customizable)
		if(active) //deactivate
			if(!isigniter(detonator.a_right) && !issignaler(detonator.a_right))
				detonator.a_right.activate()
			if(!isigniter(detonator.a_left) && !issignaler(detonator.a_left))
				detonator.a_left.activate()
	active = FALSE
	update_icon()

/obj/item/explosive/plastic/proc/can_place(var/mob/user, var/atom/target)
	if(istype(target, /obj/structure/ladder) || istype(target, /obj/item) || istype(target, /turf/open) || istype(target, /obj/structure/barricade) || istype(target, /obj/structure/closet/crate))
		return FALSE

	if(istype(target, /obj/effect) || istype(target, /obj/structure/machinery))
		var/obj/O = target
		if(O.unacidable)
			return FALSE

	if(istype(target, /turf/closed/wall))
		var/turf/closed/wall/W = target
		if(W.hull)
			return FALSE

	if(istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		if(W.not_damageable)
			to_chat(user, SPAN_WARNING("[W] is much too tough for you to do anything to it with [src].")) //On purpose to mimic wall message
			return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(user.faction == H.faction)
			to_chat(user, SPAN_WARNING("ARE YOU OUT OF YOUR MIND?!"))
			return FALSE

	if(customizable && assembly_stage < ASSEMBLY_LOCKED)
		return FALSE

	return TRUE

/obj/item/explosive/plastic/proc/calculate_pixel_offset(var/mob/user, var/atom/target)
	switch(get_dir(user, target))
		if(NORTH)
			pixel_y = 24
		if(NORTHEAST)
			pixel_y = 24
			pixel_x = 24
		if(EAST)
			pixel_x = 24
		if(SOUTHEAST)
			pixel_x = 24
			pixel_y = -24
		if(SOUTH)
			pixel_y = -24
		if(SOUTHWEST)
			pixel_y = -24
			pixel_x = -24
		if(WEST)
			pixel_x = -24
		if(NORTHWEST)
			pixel_x = -24
			pixel_y = 24

/obj/item/explosive/plastic/prime(var/force = FALSE)
	if(!force && (!plant_target || plant_target.disposed || !active))
		return
	var/turf/target_turf
	if(!force)
		if(!istype(plant_target, /obj/structure/window) & !istype(plant_target, /turf/closed))
			plant_target.overlays -= overlay
			qdel(overlay)
			plant_target.contents -= src
			forceMove(plant_target.loc)
		if(ismob(plant_target))
			var/mob/M = plant_target
			M.last_damage_source = initial(name)
			M.last_damage_mob = source_mob

		target_turf = get_turf(plant_target)
	else
		plant_target = loc
		target_turf = get_turf(loc)
	if(customizable)
		if(force)
			. = ..()
		else if(!detonator)
			return
		else if(issignaler(detonator.a_right) || issignaler(detonator.a_left))
			overlays += new /obj/effect/overlay/danger
			layer = INTERIOR_DOOR_LAYER
			add_timer(CALLBACK(src, .proc/delayed_prime, target_turf), SECONDS_3)
		else
			. = ..()
		if(!disposed)
			overlays.Cut()
			cell_explosion(target_turf, 60, 30, null, initial(name), source_mob)
			qdel(src)
		return
	plant_target.ex_act(1000, , initial(name), source_mob)

	for(var/turf/closed/wall/W in orange(1, target_turf))
		if(W.hull)
			continue
		W.ex_act(1000, , initial(name), source_mob)

	for(var/obj/structure/window/W in orange(1, target_turf))
		if(W.not_damageable)
			continue

		W.ex_act(1000, , initial(name), source_mob)

	for(var/obj/structure/machinery/door/D in orange(1, target_turf))
		D.ex_act(1000, , initial(name), source_mob)

	cell_explosion(target_turf, 120, 30, null, initial(name), source_mob)

	qdel(src)

/obj/item/explosive/plastic/proc/delayed_prime(var/turf/target_turf)
	prime(TRUE)

/obj/item/explosive/plastic/custom
	name = "Custom plastic explosive"
	desc = "A custom plastic explosive."
	icon_state = "custom_plastic_explosive"
	overlay_image = "custom_plastic_explosive_sensing"
	customizable = TRUE
	matter = list("metal" = 7500, "plastic" = 2000) // 2 metal and 1 plastic sheet