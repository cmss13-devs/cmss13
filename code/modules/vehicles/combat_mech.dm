#define MECH_LAYER MOB_LAYER + 0.11
/obj/vehicle/combat_mech
	name = "\improper RX47 Combat Mechsuit"
	icon = 'icons/obj/vehicles/wymech.dmi'
	desc = "The Caterpillar P-5000 Work Loader is a commercial mechanized exoskeleton used for lifting heavy materials and objects, first designed in January 29, 2025 by Weyland Corporation. An old but trusted design used in warehouses, constructions and military ships everywhere."
	icon_state = "wymech"
	layer = MOB_LAYER
	anchored = TRUE
	density = TRUE
	light_range = 5
	move_delay = 8
	buckling_y = 17
	health = 200
	maxhealth = 200
	pixel_x = -17
	pixel_y = -2
	var/base_state = "wymech"
	var/open_state = "wymech"
	var/overlay_state = "wymech_body_overlay_open"
	var/wreckage = /obj/structure/powerloader_wreckage
	var/obj/item/powerloader_clamp/PC_left
	var/obj/item/powerloader_clamp/PC_right

	var/helmet_closed = FALSE

//--------------------GENERAL PROCS-----------------

/obj/vehicle/combat_mech/Initialize()
	cell = new /obj/item/cell/apc
	PC_left = new(src)
	PC_left.name = "\improper Power Loader Left Hydraulic Claw"
	PC_left.linked_powerloader = src
	PC_right = new(src)
	PC_right.name = "\improper Power Loader Right Hydraulic Claw"
	PC_right.linked_powerloader = src
	PC_right.is_right = TRUE
	PC_right.icon_state = "loader_clamp_right"


	rebuild_icon()
	. = ..()

/obj/vehicle/combat_mech/proc/rebuild_icon()
	overlays.Cut()
	if(helmet_closed)
		overlays += image(icon_state = "wymech_helmet_closed", layer = MECH_LAYER)
	else
		overlays += image(icon_state = "wymech_helmet_open", layer = MECH_LAYER)
	overlays += image(icon_state = "wymech_arms", layer = MECH_LAYER)
	if(PC_left)
		overlays += image(icon_state = "wymech_weapon_left", layer = MECH_LAYER)
	if(PC_right)
		overlays += image(icon_state = "wymech_weapon_right", layer = MECH_LAYER)

/obj/vehicle/combat_mech/Destroy()
	qdel(PC_left)
	PC_left = null
	qdel(PC_right)
	PC_right = null
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
	if(PC_left)
		. += PC_left.get_examine_text(user, TRUE)
	if(PC_right)
		. += PC_right.get_examine_text(user, TRUE)

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
	if(!skillcheck(user, SKILL_POWERLOADER, SKILL_POWERLOADER_TRAINED))
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
		icon_state = base_state
		overlays += image(icon_state = overlay_state, layer = MECH_LAYER)
		if(buckled_mob.mind && buckled_mob.skills)
			move_delay = max(4, move_delay - 2 * buckled_mob.skills.get_skill_level(SKILL_POWERLOADER))
		if(!buckled_mob.put_in_l_hand(PC_left))
			PC_left.forceMove(src)
			unbuckle()
			return
		else if(!buckled_mob.put_in_r_hand(PC_right))
			PC_right.forceMove(src)
			unbuckle()
			return
			//can't use the powerloader without both clamps equipped
	else
		move_delay = initial(move_delay)
		icon_state = open_state
		buckled_mob.drop_held_items() //drop the clamp when unbuckling

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
