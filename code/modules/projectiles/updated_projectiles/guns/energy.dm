
//-------------------------------------------------------
//ENERGY GUNS/ETC





/obj/item/weapon/gun/energy/taser
	name = "disabler gun"
	desc = "An advanced stun device capable of firing balls of ionized electricity. Used for nonlethal takedowns. "
	icon_state = "taser"
	item_state = "taser"
	muzzle_flash = null //TO DO.
	fire_sound = 'sound/weapons/Taser.ogg'

	matter = list("metal" = 2000)
	ammo = /datum/ammo/energy/taser
	var/obj/item/cell/high/cell //10000 power.
	var/charge_cost = 625 // approx 16 shots shots.
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_CAN_POINTBLANK

/obj/item/weapon/gun/energy/taser/Initialize(mapload, spawn_empty)
	. = ..()
	cell = new /obj/item/cell/high(src)
	update_icon()

/obj/item/weapon/gun/energy/taser/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	damage_mult = BASE_BULLET_DAMAGE_MULT
	movement_acc_penalty_mult = 0
	scatter = 0
	scatter_unwielded = 0


/obj/item/weapon/gun/energy/taser/update_icon()
	. = ..()

	icon_state = "[base_gun_icon]_e"

	if(!cell)
		return

	switch(cell.percent())
		if(75 to 100)
			overlays += "+charge_100"
		if(50 to 75)
			overlays += "+charge_75"
		if(25 to 50)
			overlays += "+charge_50"
		if(1 to 25)
			overlays += "+charge_25"
		else
			overlays += "+charge_0"


/obj/item/weapon/gun/energy/taser/emp_act(severity)
	cell.use(round(cell.maxcharge / severity))
	update_icon()
	..()

/obj/item/weapon/gun/energy/taser/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0

/obj/item/weapon/gun/energy/taser/load_into_chamber()
	if(!cell || cell.charge - charge_cost < 0) return

	cell.charge -= charge_cost
	in_chamber = create_bullet(ammo, initial(name))
	return in_chamber

/obj/item/weapon/gun/energy/taser/reload_into_chamber()
	update_icon()
	return 1

/obj/item/weapon/gun/energy/taser/delete_bullet(var/obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) cell.charge += charge_cost
	return 1

/obj/item/weapon/gun/energy/taser/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, SPAN_NOTICE("It has [cell.percent()]% charge left."))
	else
		to_chat(user, SPAN_NOTICE("It has no power cell inside."))

/obj/item/weapon/gun/energy/plasmarifle
	name = "plasma rifle"
	desc = "A long-barreled heavy plasma weapon capable of taking down large game. It has a mounted scope for distant shots and an integrated battery."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "plasmarifle"
	item_state = "plasmarifle"

	unacidable = TRUE
	fire_sound = 'sound/weapons/pred_plasma_shot.ogg'
	ammo = /datum/ammo/energy/yautja/rifle/bolt
	muzzle_flash = null // TO DO, add a decent one.
	zoomdevicename = "scope"
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_HUGE
	var/charge_time = 0
	var/last_regen = 0
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR

/obj/item/weapon/gun/energy/plasmarifle/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time
	update_icon()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/energy/plasmarifle/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/energy/plasmarifle/Destroy()
	remove_from_missing_pred_gear(src)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/energy/plasmarifle/process()
	if(charge_time < 100)
		charge_time++
		if(charge_time == 99)
			if(ismob(loc)) to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))
		update_icon()


/obj/item/weapon/gun/energy/plasmarifle/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*2
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/energy/plasmarifle/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [charge_time] / 100 charge.")
	else to_chat(user, "This thing looks like an alien rifle of some kind. Strange.")

/obj/item/weapon/gun/energy/plasmarifle/update_icon()
	if(last_regen < charge_time + 20 || last_regen > charge_time || charge_time > 95)
		var/new_icon_state = charge_time <=15 ? null : icon_state + "[round(charge_time/33, 1)]"
		update_special_overlay(new_icon_state)
		last_regen = charge_time

/obj/item/weapon/gun/energy/plasmarifle/unique_action(mob/user)
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	..()
	zoom(user)

/obj/item/weapon/gun/energy/plasmarifle/able_to_fire(mob/user)
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return

	return ..()

/obj/item/weapon/gun/energy/plasmarifle/load_into_chamber()
	ammo = ammo_list[charge_time < 15? /datum/ammo/energy/yautja/rifle/bolt : /datum/ammo/energy/yautja/rifle/blast]
	var/obj/item/projectile/P = create_bullet(ammo, initial(name))
	P.SetLuminosity(1)
	in_chamber = P
	charge_time = round(charge_time / 2)
	return in_chamber

/obj/item/weapon/gun/energy/plasmarifle/reload_into_chamber()
	update_icon()
	return 1

/obj/item/weapon/gun/energy/plasmarifle/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) charge_time *= 2
	return 1

/obj/item/weapon/gun/energy/plasmarifle/attack_self(mob/living/user)
	if(!isYautja(user))
		return ..()

	if(charge_time > 10)
		user.visible_message(SPAN_NOTICE("You feel a strange surge of energy in the area."),SPAN_NOTICE("You release the rifle battery's energy."))
		var/obj/item/clothing/gloves/yautja/Y = user:gloves
		if(Y && Y.charge < Y.charge_max)
			Y.charge += charge_time * 2
			if(Y.charge > Y.charge_max) Y.charge = Y.charge_max
			charge_time = 0
			to_chat(user, SPAN_NOTICE("Your bracers absorb some of the released energy."))
			update_icon()
	else to_chat(user, SPAN_WARNING("The weapon's not charged enough with ambient energy!"))





/obj/item/weapon/gun/energy/plasmapistol
	name = "plasma pistol"
	desc = "A plasma pistol capable of rapid fire. It has an integrated battery."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "plasmapistol"
	item_state = "plasmapistol"

	unacidable = TRUE
	fire_sound = 'sound/weapons/pulse3.ogg'
	flags_equip_slot = SLOT_WAIST
	ammo = /datum/ammo/energy/yautja/pistol
	muzzle_flash = null // TO DO, add a decent one.
	w_class = SIZE_MEDIUM
	var/charge_time = 40
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR

/obj/item/weapon/gun/energy/plasmapistol/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/weapon/gun/energy/plasmapistol/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/energy/plasmapistol/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/energy/plasmapistol/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag



/obj/item/weapon/gun/energy/plasmapistol/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)


/obj/item/weapon/gun/energy/plasmapistol/process()
	if(charge_time < 40)
		charge_time++
		if(charge_time == 39)
			if(ismob(loc)) to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))



/obj/item/weapon/gun/energy/plasmapistol/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT



/obj/item/weapon/gun/energy/plasmapistol/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [charge_time] / 40 charge.")
	else
		to_chat(user, "This thing looks like an alien rifle of some kind. Strange.")


/obj/item/weapon/gun/energy/plasmapistol/able_to_fire(mob/user)
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	else
		return ..()

/obj/item/weapon/gun/energy/plasmapistol/load_into_chamber()
	if(charge_time < 1) return
	var/obj/item/projectile/P = create_bullet(ammo, initial(name))
	P.SetLuminosity(1)
	in_chamber = P
	charge_time -= 1
	return in_chamber

/obj/item/weapon/gun/energy/plasmapistol/reload_into_chamber()
	return 1

/obj/item/weapon/gun/energy/plasmapistol/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) charge_time *= 2
	return 1











/obj/item/weapon/gun/energy/plasma_caster
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "plasma"
	item_state = "plasma_wear"
	name = "plasma caster"
	desc = "A powerful, shoulder-mounted energy weapon."
	fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
	ammo = /datum/ammo/energy/yautja/caster/bolt
	muzzle_flash = null // TO DO, add a decent one.
	w_class = SIZE_HUGE
	force = 0
	fire_delay = 3
	var/obj/item/clothing/gloves/yautja/source = null
	var/charge_cost = 100 //How much energy is needed to fire.
	var/mode = 0
	actions_types = list(/datum/action/item_action/toggle)
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON|DELONDROP //Can't bludgeon with this.
	flags_gun_features = GUN_UNUSUAL_DESIGN
	has_empty_icon = FALSE

/obj/item/weapon/gun/energy/plasma_caster/Initialize(mapload, spawn_empty)
	. = ..()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/weapon/gun/verb/use_unique_action

/obj/item/weapon/gun/energy/plasma_caster/Destroy()
	. = ..()
	source = null


/obj/item/weapon/gun/energy/plasma_caster/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + FIRE_DELAY_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/plasma_caster/attack_self(mob/living/user)
	switch(mode)
		if(0)
			mode = 1
			charge_cost = 300
			fire_delay = FIRE_DELAY_TIER_6 * 20
			fire_sound = 'sound/weapons/pulse.ogg'
			to_chat(user, SPAN_NOTICE("[src] is now set to fire heavy plasma spheres."))
			ammo = ammo_list[/datum/ammo/energy/yautja/caster/sphere]
		if(1)
			mode = 0
			charge_cost = 30
			fire_delay = FIRE_DELAY_TIER_6
			fire_sound = 'sound/weapons/pred_lasercannon.ogg'
			to_chat(user, SPAN_NOTICE("[src] is now set to fire light plasma bolts."))
			ammo = ammo_list[/datum/ammo/energy/yautja/caster/bolt]

/obj/item/weapon/gun/energy/plasma_caster/dropped(mob/living/carbon/human/M)
	playsound(M,'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
	if(source)
		forceMove(source)
		return
	..()

/obj/item/weapon/gun/energy/plasma_caster/able_to_fire(mob/user)
	if(!source)	return
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return

	return ..()

/obj/item/weapon/gun/energy/plasma_caster/load_into_chamber()
	if(source.drain_power(usr,charge_cost))
		in_chamber = create_bullet(ammo, initial(name))
		return in_chamber

/obj/item/weapon/gun/energy/plasma_caster/reload_into_chamber()
	return 1

/obj/item/weapon/gun/energy/plasma_caster/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		source.charge += charge_cost
		var/perc = source.charge / source.charge_max * 100
		var/mob/living/carbon/human/user = usr //Hacky...
		user.update_power_display(perc)
	return 1
