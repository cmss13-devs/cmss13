
//-------------------------------------------------------
//ENERGY GUNS/ETC



/obj/item/weapon/gun/energy//whoever delegated all behavior to the taser instead of a parent object needs to dig themselves a hole to die in. Fuck you old dev.
	name = "energy pistol"
	desc = "It shoots lasers by drawing power from an internal cell battery. Can be recharged at most convetion stations."

	icon_state = "stunrevolver"
	item_state = "m44"//temp
	muzzle_flash = null//replace at some point
	fire_sound = 'sound/weapons/emitter2.ogg'

	ammo = /datum/ammo/energy

	matter = list("metal" = 2000)

	var/obj/item/cell/high/cell //10000 power.
	var/charge_cost = 350

	var/works_in_recharger = TRUE
	var/has_charge_meter = FALSE//do we use the charging overlay system or just have an empty overlay
	var/charge_icon = "+stunrevolver_empty"//define on a per gun basis, used for the meter and empty icon on non meter guns

	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HANDGUN

/obj/item/weapon/gun/energy/Initialize(mapload, spawn_empty)
	. = ..()
	cell = new /obj/item/cell/high(src)
	update_icon()

/obj/item/weapon/gun/energy/update_icon()
	. = ..()

	icon_state = "[base_gun_icon]"

	if(!cell)
		return

	if(!has_charge_meter)
		switch(cell.percent())
			if(10 to 100)
				overlays.Cut()
			else
				overlays += charge_icon
		return
	else
		switch(cell.percent())
			if(75 to 100)
				overlays += charge_icon + "_100"
			if(50 to 75)
				overlays += charge_icon + "_75"
			if(25 to 50)
				overlays += charge_icon + "_50"
			if(1 to 25)
				overlays += charge_icon + "_25"
			else
				overlays += charge_icon + "_0"

/obj/item/weapon/gun/energy/emp_act(severity)
	cell.use(round(cell.maxcharge / severity))
	update_icon()
	..()

/obj/item/weapon/gun/energy/load_into_chamber()
	if(!cell || cell.charge < charge_cost)
		return

	cell.charge -= charge_cost
	in_chamber = create_bullet(ammo, initial(name))
	return in_chamber

/obj/item/weapon/gun/energy/has_ammunition()
	if(cell?.charge >= charge_cost)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/delete_bullet(var/obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) cell.charge += charge_cost
	return TRUE

/obj/item/weapon/gun/energy/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, SPAN_NOTICE("It has [cell.percent()]% charge left."))
	else
		to_chat(user, SPAN_NOTICE("It has no power cell inside."))

/obj/item/weapon/gun/energy/rxfm5_eva
	name = "RXF-M5 eva pistol"
	desc = "A high power focusing blue laser pistol for use in space. Though it works just about anywhere really. Derived from the same technology as laser welders. Issued by the Weyland-Yutani Corporation, but also available on the civilian market."
	icon_state = "rxfm5_eva"

	ammo = /datum/ammo/energy/rxfm_eva

	has_charge_meter = FALSE
	charge_icon = "+rxfm5_empty"

/obj/item/weapon/gun/energy/laser_top
	name = "'LAZ-TOP'"
	desc = "The 'LAZ-TOP', aka the Laser Anode something something"//finish this later

/obj/item/weapon/gun/energy/taser
	name = "disabler gun"
	desc = "An advanced stun device capable of firing balls of ionized electricity. Used for nonlethal takedowns. "
	icon_state = "taser"
	item_state = "taser"
	muzzle_flash = null //TO DO.
	fire_sound = 'sound/weapons/Taser.ogg'

	ammo = /datum/ammo/energy/taser/precise
	charge_cost = 625 // approx 16 shots shots.
	has_charge_meter = TRUE
	charge_icon = "+taser"
	var/precision = TRUE

/obj/item/weapon/gun/energy/taser/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	damage_mult = BASE_BULLET_DAMAGE_MULT
	movement_onehanded_acc_penalty_mult = 0
	scatter = 0
	scatter_unwielded = 0

/obj/item/weapon/gun/energy/taser/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE

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
