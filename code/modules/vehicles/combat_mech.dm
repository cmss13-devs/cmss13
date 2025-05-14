#define MECH_LAYER MOB_LAYER + 0.11
/obj/vehicle/combat_mech
	name = "\improper RX47 Combat Mechsuit"
	icon = 'icons/obj/vehicles/wymech.dmi'
	desc = "Yeehaw!"
	icon_state = "wymech"
	layer = MOB_LAYER
	anchored = TRUE
	density = TRUE
	light_range = 5
	move_delay = 7
	buckling_y = 17
	health = 200
	maxhealth = 200
	pixel_x = -17
	pixel_y = -2
	var/overlay_state = "wymech_body_overlay_open"
	var/wreckage = /obj/structure/powerloader_wreckage
	var/obj/item/weapon/gun/gun_left
	var/obj/item/weapon/gun/gun_right

	var/helmet_closed = FALSE

//--------------------GENERAL PROCS-----------------

/obj/vehicle/combat_mech/Initialize()
	cell = new /obj/item/cell/apc

	rebuild_icon()
	. = ..()

/obj/vehicle/combat_mech/proc/rebuild_icon()
	overlays.Cut()
	if(helmet_closed)
		overlays += image(icon_state = "wymech_helmet_closed", layer = MECH_LAYER)
	else
		overlays += image(icon_state = "wymech_helmet_open", layer = MECH_LAYER)
	overlays += image(icon_state = "wymech_arms", layer = MECH_LAYER)
	if(gun_left)
		overlays += image(icon_state = "wymech_weapon_left", layer = MECH_LAYER)
	if(gun_right)
		overlays += image(icon_state = "wymech_weapon_right", layer = MECH_LAYER)

/obj/vehicle/combat_mech/Destroy()
	if(gun_left)
		qdel(gun_left)
		gun_left = null
	if(gun_right)
		qdel(gun_right)
		gun_right = null
	return ..()

/obj/vehicle/combat_mech/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated())
		return
	if(world.time > l_move_time + move_delay)
		if(dir != direction)
			l_move_time = world.time
			setDir(direction)
			handle_rotation()
			pick(playsound(src.loc, 'sound/mecha/powerloader_turn.ogg', 25, 1), playsound(src.loc, 'sound/mecha/powerloader_turn2.ogg', 25, 1))
			. = TRUE
		else
			. = step(src, direction)
			if(.)
				pick(playsound(loc, 'sound/mecha/powerloader_step.ogg', 25), playsound(loc, 'sound/mecha/powerloader_step2.ogg', 25))

/obj/vehicle/combat_mech/handle_rotation()
	if(buckled_mob)
		buckled_mob.setDir(dir)
		switch(dir)
			if(EAST)
				buckled_mob.pixel_x = 4
			if(WEST)
				buckled_mob.pixel_x = -4
			else
				buckled_mob.pixel_x = 0

/obj/vehicle/combat_mech/explode()
	new wreckage(loc)
	playsound(loc, 'sound/effects/metal_crash.ogg', 75)
	..()

//--------------------INTERACTION PROCS-----------------

/obj/vehicle/combat_mech/get_examine_text(mob/user)
	. = ..()
	if(gun_left)
		. += gun_left.get_examine_text(user, TRUE)
	if(gun_right)
		. += gun_right.get_examine_text(user, TRUE)

/obj/vehicle/combat_mech/attack_hand(mob/user)
	if(buckled_mob && user != buckled_mob)
		buckled_mob.visible_message(SPAN_WARNING("[user] tries to move [buckled_mob] out of [src]."),
		SPAN_DANGER("[user] tries to move you out of [src]!"))
		var/oldloc = loc
		var/olddir = dir
		var/old_buckled_mob = buckled_mob
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && dir == olddir && loc == oldloc && buckled_mob == old_buckled_mob)
			manual_unbuckle(user)
			playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 25)

/obj/vehicle/combat_mech/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = W
		if(PC.linked_powerloader == src)
			unbuckle() //clicking the powerloader with its own clamp unbuckles the pilot.
			playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 25)
			return 1
	. = ..()

/obj/vehicle/combat_mech/buckle_mob(mob/M, mob/user)
	if(M != user)
		return
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(!skillcheck(user, SKILL_POWERLOADER, SKILL_POWERLOADER_COMBAT))
		to_chat(H, SPAN_WARNING("You don't seem to know how to operate \the [src]."))
		return
	if(H.r_hand || H.l_hand)
		to_chat(H, SPAN_WARNING("You need both hands free to operate \the [src]."))
		return
	. = ..()

/obj/vehicle/combat_mech/afterbuckle(mob/buckled_mob)
	. = ..()
	buckled_mob.layer = MOB_LAYER + 0.1
	rebuild_icon()
	playsound(loc, 'sound/mecha/powerloader_buckle.ogg', 25)
	if(.)
		overlays += image(icon_state = overlay_state, layer = MECH_LAYER)
		if(buckled_mob.mind && buckled_mob.skills)
			move_delay = max(3, move_delay - 2 * buckled_mob.skills.get_skill_level(SKILL_POWERLOADER))
		if(gun_left && !buckled_mob.put_in_l_hand(gun_left))
			gun_left.forceMove(src)
			unbuckle()
			return
		else if(gun_right && !buckled_mob.put_in_r_hand(gun_right))
			gun_right.forceMove(src)
			unbuckle()
			return
			//can't use the mech without both weapons equipped
	else
		move_delay = initial(move_delay)
		buckled_mob.drop_held_items() //drop the weapons when unbuckling

/obj/vehicle/combat_mech/unbuckle()
	buckled_mob.layer = MOB_LAYER
	..()

//verb
/obj/vehicle/combat_mech/verb/enter_mech(mob/M)
	set category = "Object"
	set name = "Enter Combat Mech"
	set src in oview(1)

	buckle_mob(M, usr)

#undef MECH_LAYER
