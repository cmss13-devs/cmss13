#define MECH_LAYER MOB_LAYER + 0.12
#define MECH_CORE_LAYER MOB_LAYER + 0.11
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
	health = 3000
	maxhealth = 3000
	pixel_x = -17
	pixel_y = -2
	var/mouse_pointer = 'icons/effects/mouse_pointer/mecha_mouse.dmi'
	var/wreckage = /obj/structure/combat_mech_wreckage
	var/obj/item/weapon/gun/mech/rx47_chaingun/gun_left
	var/obj/item/weapon/gun/mech/rx47_support/gun_right

	var/helmet_closed = FALSE
	var/squad_color

//--------------------GENERAL PROCS-----------------

/obj/vehicle/combat_mech/Initialize()
	cell = new /obj/item/cell/apc

	gun_left = new(src)
	gun_left.linked_mech = src
	gun_right = new(src)
	gun_right.linked_mech = src

	rebuild_icon()
	. = ..()

/obj/vehicle/combat_mech/proc/rebuild_icon()
	overlays.Cut()
	if(buckled_mob)
		overlays += image(icon_state = "wymech_body_overlay", layer = MECH_CORE_LAYER)
		overlays += image(icon_state = "wymech_legs", layer = MECH_CORE_LAYER)
	if(helmet_closed)
		overlays += image(icon_state = "wymech_helmet_closed", layer = MECH_LAYER)
	else
		overlays += image(icon_state = "wymech_helmet_open", layer = MECH_LAYER)
	overlays += image(icon_state = "wymech_arms", layer = MECH_LAYER)
	overlays += image(icon_state = "wymech_weapon_left", layer = MECH_LAYER)
	overlays += image(icon_state = "wymech_weapon_right", layer = MECH_LAYER)
	if(squad_color)
		overlays += image(icon_state = "wymech_markings_[squad_color]", layer = MECH_LAYER)


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


/obj/vehicle/combat_mech/Collide(atom/A)
	if(ishumansynth_strict(A))
		var/mob/living/carbon/human/human_hit = A
		human_hit.KnockDown(3)
		return

	if(A && !QDELETED(A))
		A.last_bumped = world.time
		A.Collided(src)
		return

/obj/vehicle/combat_mech/Collided(atom/A)
	if(isxeno(A))
		var/mob/living/carbon/xenomorph/xeno = A
		health -= (xeno.melee_vehicle_damage * 5)
		healthcheck()
		return

/obj/vehicle/combat_mech/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
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

/obj/vehicle/combat_mech/get_examine_text(mob/user)
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

/obj/vehicle/combat_mech/proc/flamer_fire_crossed_callback(mob/living/L, datum/reagent/R)
	SIGNAL_HANDLER

	return COMPONENT_NO_IGNITE|COMPONENT_NO_BURN

/obj/vehicle/combat_mech/attackby(obj/item/W, mob/user)
	. = ..()
	var/obj/item/weapon/gun/mech/mech_gun = W
	if((mech_gun == gun_right) || mech_gun == gun_left)
		user.drop_held_item(mech_gun, TRUE)

/obj/vehicle/combat_mech/afterbuckle(mob/new_buckled_mob)
	. = ..()
	new_buckled_mob.layer = MOB_LAYER + 0.1
	ADD_TRAIT(new_buckled_mob, TRAIT_INSIDE_VEHICLE, TRAIT_SOURCE_BUCKLE)
	RegisterSignal(new_buckled_mob, COMSIG_LIVING_FLAMER_CROSSED, PROC_REF(flamer_fire_crossed_callback))
	rebuild_icon()
	playsound(loc, 'sound/mecha/powerloader_buckle.ogg', 25)
	if(.)
		if(new_buckled_mob.mind && new_buckled_mob.skills)
			move_delay = max(3, move_delay - 2 * new_buckled_mob.skills.get_skill_level(SKILL_POWERLOADER))
		if(gun_left && !new_buckled_mob.put_in_l_hand(gun_left))
			gun_left.forceMove(src)
			gun_left.flags_gun_features |= GUN_TRIGGER_SAFETY
			unbuckle()
			return
		else if(gun_right && !new_buckled_mob.put_in_r_hand(gun_right))
			gun_right.forceMove(src)
			gun_left.flags_gun_features |= GUN_TRIGGER_SAFETY
			unbuckle()
			return
			//can't use the mech without both weapons equipped
	else
		move_delay = initial(move_delay)
		new_buckled_mob.drop_held_items(TRUE) //drop the weapons when unbuckling

/obj/vehicle/combat_mech/unbuckle()
	buckled_mob.layer = MOB_LAYER
	REMOVE_TRAIT(buckled_mob, TRAIT_INSIDE_VEHICLE, TRAIT_SOURCE_BUCKLE)
	UnregisterSignal(buckled_mob, COMSIG_LIVING_FLAMER_CROSSED)
	..()

/obj/vehicle/combat_mech/proc/update_mouse_pointer(mob/user, new_cursor)
	if(!user.client?.prefs.custom_cursors)
		return
	user.client.mouse_pointer_icon = new_cursor ? mouse_pointer : initial(user.client.mouse_pointer_icon)

//verb
/obj/vehicle/combat_mech/verb/enter_mech()
	set category = "Object.Mechsuit"
	set name = "Enter Combat Mechsuit"
	set src in oview(1)

	buckle_mob(usr, usr)

/obj/vehicle/combat_mech/verb/toggle_helmet()
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

//Guns
/obj/item/weapon/gun/mech
	var/obj/vehicle/combat_mech/linked_mech
	unacidable = TRUE
	explo_proof = TRUE
	flags_gun_features = GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK|GUN_TRIGGER_SAFETY
	flags_item = NODROP
	start_semiauto = FALSE
	start_automatic = TRUE
	akimbo_forbidden = TRUE
	can_jam = FALSE
	has_empty_icon = FALSE

/obj/item/weapon/gun/mech/dropped(mob/user)
	if(!linked_mech)
		qdel(src)
	..()
	forceMove(linked_mech)
	if(linked_mech.buckled_mob && linked_mech.buckled_mob == user)
		linked_mech.unbuckle()

//Chaingun
/obj/item/ammo_magazine/rx47_chaingun
	name = "rotating ammo drum (20x102mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = "20x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rx47_chaingun
	max_rounds = 5000
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/rx47_chaingun
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/rx47_chaingun
	name = "chaingun bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 12
	damage = 25
	penetration = ARMOR_PENETRATION_TIER_6

/obj/item/weapon/gun/mech/rx47_chaingun
	name = "\improper RX47 Chaingun"
	desc = "An enormous multi-barreled rotating gatling gun. This thing will no doubt pack a punch."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	icon_state = "chaingun"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/rx47_chaingun
	w_class = SIZE_HUGE
	force = 20
	gun_category = GUN_CATEGORY_HEAVY

/obj/item/weapon/gun/mech/rx47_chaingun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/mech/rx47_chaingun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9 // Most of the scatter should come from the recoil
	scatter_unwielded = SCATTER_AMOUNT_TIER_9
	fa_max_scatter = SCATTER_AMOUNT_TIER_8
	fa_scatter_peak = 6
	burst_scatter_mult = 1

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF
	recoil_buildup_limit = RECOIL_OFF
	durability_loss = GUN_DURABILITY_LOSS_NONE


// Support Gun
/obj/item/ammo_magazine/rx47_cupola
	name = "rotating ammo drum (15x102mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = "15x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rx47_cupola
	max_rounds = 3000
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/rx47_support
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/rx47_cupola
	name = "cupola bullet"
	icon_state = "bullet_iff"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage_falloff = DAMAGE_FALLOFF_TIER_9
	max_range = 12
	accuracy = HIT_ACCURACY_TIER_4
	damage = 15
	penetration = 0
	effective_range_max = 5
	penetration = ARMOR_PENETRATION_TIER_2

/obj/item/weapon/gun/mech/rx47_support/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_10
	recoil = RECOIL_OFF

/obj/item/weapon/gun/mech/rx47_support/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/mech/rx47_support/attack_self(mob/user)
	activate_attachment_verb()
	if(!active_attachable)
		base_gun_icon = "aux_cupola"
		icon_state = "aux_cupola"
	else
		base_gun_icon = "aux_fire"
		icon_state = "aux_fire"
	return

/obj/item/weapon/gun/mech/cock()
	return

/obj/item/weapon/gun/mech/unload()
	return

/obj/item/weapon/gun/mech/unique_action(mob/user)
	. = ..()
	toggle_gun_safety()

/obj/item/weapon/gun/mech/rx47_support
	name = "\improper RX47 Auxilliary Cupola"
	desc = "A large Cupola smartgun with undermounted flamethrower."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	base_gun_icon = "aux_cupola"
	icon_state = "aux_cupola"
	mouse_pointer = 'icons/effects/mouse_pointer/smartgun_mouse.dmi'

	fire_sound = "gun_smartgun"
	fire_rattle = "gun_smartgun_rattle"
	current_mag = /obj/item/ammo_magazine/rx47_cupola
	w_class = SIZE_HUGE
	force = 20
	gun_category = GUN_CATEGORY_SMG
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MUZZLE_BLUE
	attachable_allowed = list(
		/obj/item/attachable/attached_gun/flamer/advanced/rx47,
	)

/obj/item/weapon/gun/mech/rx47_support/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/flamer/advanced/rx47/flamer = new(src)
	flamer.Attach(src)

/obj/item/attachable/attached_gun/flamer/advanced/rx47
	name = "RX47 Auxilliary Flamer"
	max_rounds = 750
	current_rounds = 750
	max_range = 5
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON|ATTACH_WIELD_OVERRIDE
	hidden = TRUE

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
