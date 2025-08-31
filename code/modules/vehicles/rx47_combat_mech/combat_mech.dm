#define MECH_LAYER MOB_LAYER + 0.12
#define MECH_CORE_LAYER MOB_LAYER + 0.11
/obj/vehicle/rx47_mech
	name = "\improper RX47 Combat Mechsuit"
	icon = 'icons/obj/vehicles/wymech.dmi'
	desc = "A RX47 Combat Mechsuit, equipped with a 20mm Chaingun and support Cupola Smartgun. It has a flamethrower attached to the cupola unit."
	icon_state = "wymech"
	layer = MOB_LAYER
	anchored = TRUE
	density = TRUE
	light_range = 5
	move_delay = 7
	buckling_y = 17
	health = 3000
	maxhealth = 3000
	pixel_x = -17
	pixel_y = -2

	heal_increment = 100

	var/mouse_pointer = 'icons/effects/mouse_pointer/mecha_mouse.dmi'
	var/wreckage = /obj/structure/combat_mech_wreckage
	var/obj/item/weapon/gun/mech/gun_primary
	var/gun_primary_path = /obj/item/weapon/gun/mech/chaingun
	var/obj/item/weapon/gun/mech/gun_secondary
	var/gun_secondary_path = /obj/item/weapon/gun/mech/cupola

	var/helmet_closed = FALSE
	var/has_cannon = FALSE
	var/has_tow_launcher = FALSE
	var/markings_color
	var/markings_specialty

	var/played_crit_alert = FALSE
	var/played_damage_alert = FALSE

/obj/vehicle/rx47_mech/siegebreaker
	name = "\improper RX47-SB Combat Mechsuit"
	desc = "A RX47-SB 'Siegebreaker' Combat Mechsuit, equipped with a 50mm IFF-locked explosive cannon and support Cupola Smartgun. It has a flamethrower attached to the cupola unit."
	has_cannon = TRUE
	gun_primary_path = /obj/item/weapon/gun/mech/cannon

/obj/vehicle/rx47_mech/exterminator
	name = "\improper RX47-EX Combat Mechsuit"
	desc = "A RX47-EX 'Exterminator' Combat Mechsuit, equipped with a 20mm Chaingun and 50mm IFF-locked explosive cannon"
	has_cannon = TRUE
	gun_secondary_path = /obj/item/weapon/gun/mech/cannon

//--------------------GENERAL PROCS-----------------

/obj/vehicle/rx47_mech/Initialize()
	cell = new /obj/item/cell/apc

	gun_primary = new gun_primary_path(src)
	gun_primary.linked_mech = src
	gun_secondary = new gun_secondary_path(src)
	gun_secondary.linked_mech = src

	rebuild_icon()
	. = ..()

/obj/vehicle/rx47_mech/proc/rebuild_icon()
	overlays.Cut()
	if(buckled_mob)
		overlays += image(icon_state = "wymech_body_overlay", layer = MECH_CORE_LAYER)
		overlays += image(icon_state = "wymech_legs", layer = MECH_CORE_LAYER)
		if(helmet_closed)
			overlays += image(icon_state = "wymech_helmet_closed", layer = MECH_LAYER)
		else
			overlays += image(icon_state = "wymech_helmet_open", layer = MECH_LAYER)
	else
		overlays += image(icon_state = "wymech_helmet_open", layer = MECH_LAYER)
	overlays += image(icon_state = "wymech_arms", layer = MECH_LAYER)

	overlays += image(icon_state = "weapon_left", layer = MECH_LAYER)
	if(has_cannon)
		overlays += image(icon_state = "weapon_cannon", layer = MECH_LAYER)
	else
		overlays += image(icon_state = "weapon_right", layer = MECH_LAYER)
	if(has_tow_launcher)
		overlays += image(icon_state = "weapon_tow", layer = MECH_LAYER)

	if(markings_color)
		overlays += image(icon_state = "markings_c_[markings_color]", layer = MECH_LAYER)
	if(markings_specialty)
		overlays += image(icon_state = "markings_s_[markings_specialty]", layer = MECH_LAYER)

/obj/vehicle/rx47_mech/Destroy()
	if(buckled_mob)
		clean_driver(buckled_mob)
		unbuckle()
	if(gun_primary)
		qdel(gun_primary)
		gun_primary = null
	if(gun_secondary)
		qdel(gun_secondary)
		gun_secondary = null
	return ..()

/obj/vehicle/rx47_mech/unbuckle()
	gun_primary.flags_gun_features |= GUN_TRIGGER_SAFETY
	gun_secondary.flags_gun_features |= GUN_TRIGGER_SAFETY
	clean_driver(buckled_mob)
	. = ..()

/obj/vehicle/rx47_mech/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated())
		return
	if(world.time > l_move_time + move_delay)
		if(dir != direction)
			l_move_time = world.time
			setDir(direction)
			handle_rotation()
			playsound(src.loc, 'sound/mecha/mechturn.ogg', 25, 1)
			. = TRUE
		else
			. = step(src, direction)
			if(.)
				playsound(loc, 'sound/mecha/mechstep.ogg', 25)

/obj/vehicle/rx47_mech/handle_rotation()
	if(buckled_mob)
		buckled_mob.setDir(dir)
		switch(dir)
			if(EAST)
				buckled_mob.pixel_x = 4
			if(WEST)
				buckled_mob.pixel_x = -4
			else
				buckled_mob.pixel_x = 0

/obj/vehicle/rx47_mech/Collide(atom/A)
	if(ishumansynth_strict(A))
		var/mob/living/carbon/human/human_hit = A
		human_hit.KnockDown(1)
		return

	if(istype(A, /obj/structure/barricade/plasteel))
		var/obj/structure/barricade/plasteel/cade = A
		cade.attack_hand(buckled_mob)
		return

	if(A && !QDELETED(A))
		A.last_bumped = world.time
		A.Collided(src)
		return

/obj/vehicle/rx47_mech/Collided(atom/A)
	if(isxeno(A))
		var/mob/living/carbon/xenomorph/xeno = A
		health -= (xeno.melee_vehicle_damage * 5)
		healthcheck()
		return

/obj/vehicle/rx47_mech/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
	if(attacking_xeno.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	if(attacking_xeno.mob_size < MOB_SIZE_XENO)
		to_chat(attacking_xeno, SPAN_XENOWARNING("You're too small to do any significant damage to this vehicle!"))
		return XENO_NO_DELAY_ACTION

	attacking_xeno.animation_attack_on(src)

	attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] slashes [src]!"), SPAN_DANGER("You slash [src]!"))
	playsound(attacking_xeno, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	var/damage = (attacking_xeno.melee_vehicle_damage + rand(-5,5)) * brute_dam_coeff

	health -= damage

	healthcheck()

	return XENO_ATTACK_ACTION
//--------------------INTERACTION PROCS-----------------

/obj/vehicle/rx47_mech/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	if(!ishuman(user) && !isobserver(user))
		return
	var/one_percent = maxhealth / 100
	var/percentage = health / one_percent
	var/message = SPAN_GREEN("It has [percentage]% health.")
	if(percentage <= 25)
		message = SPAN_RED("It has [percentage]% health.")
	else if(percentage <= 75)
		message = SPAN_ORANGE("It has [percentage]% health.")

	. += message
	if(gun_primary)
		. += gun_primary.get_examine_text(user, TRUE)
	if(gun_secondary)
		. += gun_secondary.get_examine_text(user, TRUE)

/obj/vehicle/rx47_mech/healthcheck()
	var/one_percent = maxhealth / 100
	var/percentage = health / one_percent
	if(buckled_mob && buckled_mob.client)
		if(percentage <= 10)
			if(!played_crit_alert)
				playsound_client(buckled_mob.client, 'sound/mecha/critnano.ogg', src, 75)
				played_crit_alert = TRUE
		else if(percentage <= 25)
			if(!played_damage_alert)
				playsound_client(buckled_mob.client, 'sound/mecha/internaldmgalarm.ogg', src, 75)
				played_damage_alert = TRUE
				played_crit_alert = FALSE
		else
			played_crit_alert = FALSE
			played_damage_alert = FALSE

	if(health <= 0)
		explode()

/obj/vehicle/rx47_mech/explode()
	new wreckage(loc)
	playsound(loc, 'sound/effects/metal_crash.ogg', 75)
	..()

/obj/vehicle/rx47_mech/attack_hand(mob/user)
	if(buckled_mob && user != buckled_mob)
		buckled_mob.visible_message(SPAN_WARNING("[user] tries to move [buckled_mob] out of [src]."),
		SPAN_DANGER("[user] tries to move you out of [src]!"))
		var/oldloc = loc
		var/olddir = dir
		var/old_buckled_mob = buckled_mob
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && dir == olddir && loc == oldloc && buckled_mob == old_buckled_mob)
			manual_unbuckle(user)
			playsound(loc, 'sound/mecha/mechmove03.ogg', 25)

/obj/vehicle/rx47_mech/buckle_mob(mob/M, mob/user)
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

/obj/vehicle/rx47_mech/proc/flamer_fire_crossed_callback(mob/living/L, datum/reagent/R)
	SIGNAL_HANDLER

	return COMPONENT_NO_IGNITE|COMPONENT_NO_BURN

/obj/vehicle/rx47_mech/attackby(obj/item/W, mob/user)
	. = ..()
	var/obj/item/weapon/gun/mech/mech_gun = W
	if((mech_gun == gun_secondary) || mech_gun == gun_primary)
		user.drop_held_item(mech_gun, TRUE)

/obj/vehicle/rx47_mech/afterbuckle(mob/new_buckled_mob)
	. = ..()
	new_buckled_mob.layer = MOB_LAYER + 0.1
	ADD_TRAIT(new_buckled_mob, TRAIT_INSIDE_VEHICLE, TRAIT_SOURCE_BUCKLE)
	ADD_TRAIT(new_buckled_mob, TRAIT_FORCED_STANDING, TRAIT_SOURCE_BUCKLE)
	RegisterSignal(new_buckled_mob, COMSIG_LIVING_FLAMER_CROSSED, PROC_REF(flamer_fire_crossed_callback))
	update_mouse_pointer(new_buckled_mob, TRUE)
	rebuild_icon()
	if(.)
		playsound(loc, 'sound/mecha/mechmove01.ogg', 25)
		if(new_buckled_mob.mind && new_buckled_mob.skills)
			move_delay = max(3, move_delay - 2 * new_buckled_mob.skills.get_skill_level(SKILL_POWERLOADER))
		if(gun_primary && !new_buckled_mob.put_in_l_hand(gun_primary))
			gun_primary.forceMove(src)
			gun_primary.flags_gun_features |= GUN_TRIGGER_SAFETY
			clean_driver(new_buckled_mob)
			unbuckle()
			return
		else if(gun_secondary && !new_buckled_mob.put_in_r_hand(gun_secondary))
			gun_secondary.forceMove(src)
			gun_secondary.flags_gun_features |= GUN_TRIGGER_SAFETY
			clean_driver(new_buckled_mob)
			unbuckle()
			return
			//can't use the mech without both weapons equipped
	else
		playsound(loc, 'sound/mecha/mechmove03.ogg', 25)
		move_delay = initial(move_delay)
		clean_driver(new_buckled_mob)
		new_buckled_mob.drop_held_items(TRUE) //drop the weapons when unbuckling

/obj/vehicle/rx47_mech/proc/clean_driver(mob/driver)
	if(!istype(driver))
		return FALSE
	driver.layer = MOB_LAYER
	REMOVE_TRAIT(driver, TRAIT_INSIDE_VEHICLE, TRAIT_SOURCE_BUCKLE)
	REMOVE_TRAIT(driver, TRAIT_FORCED_STANDING, TRAIT_SOURCE_BUCKLE)
	UnregisterSignal(driver, COMSIG_LIVING_FLAMER_CROSSED)
	update_mouse_pointer(driver, FALSE)
	return TRUE

/obj/vehicle/rx47_mech/proc/update_mouse_pointer(mob/user, new_cursor)
	if(!user.client?.prefs.custom_cursors)
		return
	user.client.mouse_pointer_icon = new_cursor ? mouse_pointer : initial(user.client.mouse_pointer_icon)

//verb
/obj/vehicle/rx47_mech/verb/enter_mech()
	set category = "Object.Mechsuit"
	set name = "Enter Combat Mechsuit"
	set src in oview(1)

	buckle_mob(usr, usr)

/obj/vehicle/rx47_mech/verb/toggle_helmet()
	set category = "Object.Mechsuit"
	set name = "Toggle Faceplate"
	set src in oview(1)
	var/mob/user = usr

	if(user != buckled_mob)
		return

	helmet_closed = !helmet_closed
	if(helmet_closed)
		to_chat(user, SPAN_NOTICE("You close the mechsuit faceplate."))
	else
		to_chat(user, SPAN_NOTICE("You open the mechsuit faceplate."))
	rebuild_icon()


// Wreckage

/obj/structure/combat_mech_wreckage
	name = "\improper RX47 Combat Mechsuit wreckage"
	desc = "Remains of some unfortunate Combat Mechsuit. Completely unrepairable."
	icon = 'icons/obj/vehicles/wymech.dmi'
	icon_state = "wymech_wreck"
	density = TRUE
	anchored = FALSE
	opacity = FALSE
	pixel_x = -18
	pixel_y = -5
	health = 100

/obj/structure/combat_mech_wreckage/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
	if(attacking_xeno.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	if(attacking_xeno.mob_size < MOB_SIZE_XENO)
		to_chat(attacking_xeno, SPAN_XENOWARNING("You're too small to do any significant damage to this vehicle!"))
		return XENO_NO_DELAY_ACTION

	attacking_xeno.animation_attack_on(src)

	attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] slashes [src]!"), SPAN_DANGER("You slash [src]!"))
	playsound(attacking_xeno, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	var/damage = (attacking_xeno.melee_vehicle_damage + rand(-5,5))

	health -= damage

	if(health <= 0)
		deconstruct(FALSE)

	return XENO_NONCOMBAT_ACTION




#undef MECH_LAYER
