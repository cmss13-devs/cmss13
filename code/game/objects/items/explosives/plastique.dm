/obj/item/explosive/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags_item = NOBLUDGEON
	w_class = SIZE_SMALL
	
	var/timer = 10
	var/atom/plant_target = null //which atom the plstique explosive is planted on

/obj/item/explosive/plastique/Dispose()
	plant_target = null
	. = ..()

/obj/item/explosive/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return FALSE

/obj/item/explosive/plastique/attack_self(mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	var/new_time = input(usr, "Please set the timer.", "Timer", 10) as num
	if(new_time < 10)
		new_time = 10
	else if(new_time > 60)
		new_time = 60

	timer = new_time
	to_chat(user, SPAN_NOTICE("Timer set for [timer] seconds."))

/obj/item/explosive/plastique/afterattack(atom/target, mob/user, flag)
	if(user.action_busy || !flag)
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	if(!can_place(user, target))
		return

	user.visible_message(SPAN_WARNING("[user] is trying to plant [name] on [target]!"),
	SPAN_WARNING("You are trying to plant [name] on [target]!"))
	if(ismob(target))
		var/mob/M = target
		to_chat(M, FONT_SIZE_HUGE(SPAN_DANGER("[user] is trying to plant [name] on you!")))

	var/turf/current_turf = get_turf(src)
	var/image/I = image('icons/obj/items/assemblies.dmi', "plastic-explosive2")
	I.layer = BELOW_MOB_LAYER
	if(!ismob(target)) //Father forgive me for I have sinned
		calculate_pixel_offset(user, target, current_turf, I)

	if(!do_after(user, 50, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		if(!ismob(target))
			current_turf.overlays -= I
		return

	user.drop_held_item()
	loc = null

	if(ismob(target))
		target.overlays += I
		var/mob/M = target
		to_chat(M, FONT_SIZE_HUGE(SPAN_DANGER("[user] plants [name] on you!")))
		user.attack_log += "\[[time_stamp()]\] <font color='red'> [user.real_name] successfully planted [name] on [target:real_name] ([target:ckey])</font>"
		message_admins("[key_name(user, user.client)](<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[user]'>?</A>) planted [src.name] on [key_name(target)](<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[target]'>?</A>) with [timer] second fuse")
		log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")
	else
		message_admins("[key_name(user, user.client)](<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[user]'>?</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse")
		log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

	user.visible_message(SPAN_WARNING("[user] plants [name] on [target]!"),
	SPAN_WARNING("You plant [name] on [target]! Timer counting down from [timer]."))

	add_timer(CALLBACK(src, .proc/explode, user, target, current_turf, I), timer * 10)

/obj/item/explosive/plastique/proc/can_place(var/mob/user, var/atom/target)
	if(istype(target, /obj/structure/ladder) || istype(target, /obj/item) || istype(target, /turf/open))
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
			
	return TRUE

/obj/item/explosive/plastique/proc/calculate_pixel_offset(var/mob/user, var/atom/target, var/turf/current_turf, var/image/I)
	switch(get_dir(user, target))
		if(NORTH)
			I.pixel_y = 24
		if(NORTHEAST)
			I.pixel_y = 24
			I.pixel_x = 24
		if(EAST)
			I.pixel_x = 24
		if(SOUTHEAST)
			I.pixel_x = 24
			I.pixel_y = -24
		if(SOUTH)
			I.pixel_y = -24
		if(SOUTHWEST)
			I.pixel_y = -24
			I.pixel_x = -24
		if(WEST)
			I.pixel_x = -24
		if(NORTHWEST)
			I.pixel_x = -24
			I.pixel_y = 24
	current_turf.overlays += I

/obj/item/explosive/plastique/proc/explode(var/mob/user, var/atom/target, var/turf/current_turf, var/image/I)
	if(!target || target.disposed)
		return

	if(ismob(target))
		var/mob/M = target
		M.last_damage_source = initial(name)
		M.last_damage_mob = user
		target.overlays -= I
	else
		current_turf.overlays -= I
	qdel(I)

	var/turf/target_turf = get_turf(target)
	target.ex_act(1000, , initial(name), user)

	for(var/turf/closed/wall/W in orange(1, target_turf))
		if(W.hull)
			continue
		W.ex_act(1000, , initial(name), user)

	for(var/obj/structure/window/W in orange(1, target_turf))
		if(W.not_damageable)
			continue

		W.ex_act(1000, , initial(name), user)

	for(var/obj/structure/machinery/door/D in orange(1, target_turf))
		D.ex_act(1000, , initial(name), user)
	
	cell_explosion(target_turf, 120, 30, null, initial(name), user)

	qdel(src)
