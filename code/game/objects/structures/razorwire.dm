/obj/structure/razorwire
	name = "razorwire"
	desc = "A mesh of metal strips with sharp edges whose purpose is to prevent passage by humans."
	icon = 'icons/obj/structures/razorwire.dmi'
	icon_state = "razorwire-"
	layer = BELOW_OBJ_LAYER

	var/yautja_slowdown = 0.1 SECONDS
	var/human_slowdown = 0.5 SECONDS
	var/xeno_slowdown = 0.3 SECONDS

	var/brute_multiplier = 1
	var/burn_multiplier = 1
	var/explosive_multiplier = 1

	var/force_level_absorption = 5 //How much force an item needs to even damage it at all.

	health = 250

/obj/structure/razorwire/Initialize()
	. = ..()
	update_icons_in_range(include_self = TRUE)

/obj/structure/razorwire/Destroy()
	var/turf/old_turf = get_turf(src)
	. = ..()
	update_icons_in_range(include_self = FALSE, source = old_turf)

/obj/structure/razorwire/proc/update_icons_in_range(var/include_self = TRUE, var/atom/source = src)
	for(var/direction in cardinal)
		var/turf/razor_turf = get_step(source, direction)
		var/obj/structure/razorwire/razor = locate() in razor_turf
		if(razor)
			razor.update_icon()
	if(include_self)
		update_icon()

/obj/structure/razorwire/examine(mob/user)
	..()
	var/health_fraction = health / initial(health)
	switch(health_fraction)
		if(1)
			to_chat(user, SPAN_NOTICE("\The [src] is in perfect condition."))
		if(0.8 to 1)
			to_chat(user, SPAN_NOTICE("\The [src] is slightly damaged."))
		if(0.5 to 0.8)
			to_chat(user, SPAN_WARNING("\The [src] is torn up."))
		if(0.3 to 0.5)
			to_chat(user, SPAN_DANGER("\The [src] is fairly damaged!"))
		if(0 to 0.3)
			to_chat(user, SPAN_DANGER("\The [src] is falling apart!"))

/obj/structure/razorwire/update_icon()
	var/text_dirs = ""
	for(var/direction in cardinal)
		var/turf/razor_turf = get_step(src, direction)
		var/obj/structure/razorwire/razor = locate() in razor_turf
		if(razor)
			text_dirs += dir2text(direction)
	icon_state = "[initial(icon_state)][text_dirs]"

/obj/structure/razorwire/acid_spray_act()
	take_damage(25 * burn_multiplier)
	visible_message(SPAN_WARNING("\The [src] is hit by the acid spray!"))
	new /datum/effects/acid(src, null, null)

/obj/structure/razorwire/flamer_fire_act(var/dam = BURN_LEVEL_TIER_1)
	take_damage(dam * burn_multiplier)

/obj/structure/razorwire/proc/take_acid_damage(var/damage)
	take_damage(damage * burn_multiplier)

/obj/structure/razorwire/proc/hit_wire(obj/item/I)
	take_damage(I.force * 0.5 * brute_multiplier)

/obj/structure/razorwire/proc/take_damage(var/damage)
	update_health(damage)

/obj/structure/razorwire/update_health(damage, nomessage)
	health = Clamp(health - damage, 0, initial(health))
	if(!health)
		if(!nomessage)
			visible_message(SPAN_DANGER("[src] falls apart!"))
		destroy()

/obj/structure/razorwire/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/zombie_claws))
		user.visible_message(SPAN_DANGER("\The [user] smacks \the [src]!"), SPAN_DANGER("You smack \the [src]!"))
		playsound(src, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
		hit_wire(W)
		return

	for(var/obj/effect/xenomorph/acid/A in loc)
		if(A.acid_t == src)
			to_chat(user, SPAN_WARNING("You can't get near that, it's melting!"))
			return

	if(istype(W, /obj/item/stack/barbed_wire))
		if(health >= initial(health))
			to_chat(user, SPAN_WARNING("\The [src] is already fully repaired."))
			return
		var/obj/item/stack/barbed_wire/B = W
		user.visible_message(SPAN_NOTICE("[user] starts repairing \the [src] with \the [B]."), SPAN_NOTICE("You start repairing \the [src] with \the [B]."))
		if(do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			if(health >= initial(health))
				to_chat(user, SPAN_WARNING("\The [src] is already fully repaired."))
				return
			// Make sure there's still enough wire in the stack
			if(!B.use(1))
				return
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] repairs \the [src] with \the [B]."), SPAN_NOTICE("You repair \the [src] with \the [B]."))
			update_health(-50)
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		user.visible_message(SPAN_NOTICE("[user] begins taking \the [src] apart with \the [W]."), SPAN_NOTICE("You begin taking \the [src] apart with \the [W]."))
		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] takes \the [src] apart with \the [W]."), SPAN_NOTICE("You take \the [src] apart with \the [W]."))
			new /obj/item/stack/sheet/metal(loc, 3)
			qdel(src)
		return

	if(W.force > force_level_absorption)
		..()
		playsound(src, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
		hit_wire(W)

/obj/structure/razorwire/attack_robot(mob/user as mob)
	return attack_hand(user)

/obj/structure/razorwire/attack_animal(mob/user as mob)
	return attack_alien(user)

/obj/structure/razorwire/Crossed(var/atom/movable/moving_atom)
	. = ..()
	if(!moving_atom.throwing)
		if(isYautja(moving_atom))
			var/mob/living/carbon/human/yautja_mob = moving_atom
			yautja_mob.visible_message(SPAN_WARNING("\The [yautja_mob] deftly avoids \the [src]!"), SPAN_WARNING("You deftly avoid \the [src]!"), max_distance = 3)
			yautja_mob.next_move_slowdown = yautja_mob.next_move_slowdown + yautja_slowdown
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
		else if(ishuman(moving_atom))
			var/mob/living/carbon/human/human = moving_atom
			human.visible_message(SPAN_WARNING("\The [src] cuts into \the [human]'s legs, slowing them down!"), SPAN_WARNING("\The [src] cuts at your legs, slowing you down!"), max_distance = 3)
			human.next_move_slowdown = human.next_move_slowdown + human_slowdown
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)
		else if(isXeno(moving_atom))
			var/mob/living/carbon/Xenomorph/xeno = moving_atom
			xeno.visible_message(SPAN_WARNING("\The [src] wraps around \the [xeno]'s legs, slowing it down!"), SPAN_WARNING("\The [src] wraps around your legs, slowing you down!"), max_distance = 3)
			xeno.next_move_slowdown = xeno.next_move_slowdown + xeno_slowdown
			playsound(loc, 'sound/effects/barbed_wire_movement.ogg', 25, TRUE)

/obj/structure/razorwire/ex_act(severity, direction, cause_data)
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		if(prob(50)) // no message spam pls
			visible_message(SPAN_WARNING("[src] blows apart in the explosion, sending shards flying!"))
		qdel(src)
		create_shrapnel(location, rand(2,5), direction, , /datum/ammo/bullet/shrapnel/light, cause_data)
	else
		update_health(round(severity * explosive_multiplier))
