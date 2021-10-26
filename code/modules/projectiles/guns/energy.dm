
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
	ammo = /datum/ammo/energy/taser/precise
	var/obj/item/cell/high/cell //10000 power.
	var/charge_cost = 625 // approx 16 shots shots.
	var/precision = TRUE
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HANDGUN

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
	movement_onehanded_acc_penalty_mult = 0
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
		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE

/obj/item/weapon/gun/energy/taser/load_into_chamber()
	if(!cell || cell.charge < charge_cost)
		return

	cell.charge -= charge_cost
	in_chamber = create_bullet(ammo, initial(name))
	return in_chamber

/obj/item/weapon/gun/energy/taser/has_ammunition()
	if(cell?.charge >= charge_cost)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/taser/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/taser/delete_bullet(var/obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) cell.charge += charge_cost
	return TRUE

/obj/item/weapon/gun/energy/taser/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, SPAN_NOTICE("It has [cell.percent()]% charge left."))
	else
		to_chat(user, SPAN_NOTICE("It has no power cell inside."))

/obj/item/weapon/gun/energy/taser/use_unique_action()
	switch(precision)
		if(TRUE)
			precision = FALSE
			to_chat(usr, SPAN_NOTICE("\The [src] is now set to Free mode."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/taser]
		if(FALSE)
			precision = TRUE
			to_chat(usr, SPAN_NOTICE("\The [src] is now set to Precision mode."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/taser/precise]
