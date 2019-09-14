/obj/item/marine/fuelpack
	name = "\improper Broiler-T flexible refueling system"
	desc = "A specialized back harness that carries the Broiler-T flexible refueling system. Designed by and for USCM Pyrotechnicians."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "flamethrower_broiler"
	item_state = "flamethrower_broiler"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	var/obj/item/ammo_magazine/flamer_tank/large/fuel
	var/obj/item/ammo_magazine/flamer_tank/large/B/fuelB
	var/obj/item/ammo_magazine/flamer_tank/large/X/fuelX
	var/obj/item/ammo_magazine/flamer_tank/large/active_fuel
	var/flamer
	var/toggling = FALSE
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/marine/fuelpack/New()
	..()
	fuel = new /obj/item/ammo_magazine/flamer_tank/large(src)
	fuelB =	new /obj/item/ammo_magazine/flamer_tank/large/B(src)
	fuelX =	new /obj/item/ammo_magazine/flamer_tank/large/X(src)
	active_fuel = fuel

/obj/item/marine/fuelpack/update_icon()
	var/mob/user = loc
	if(overlays)
		overlays.Cut()

	if(flamer)
		overlays += overlay_image('icons/obj/items/storage.dmi', "+m240t")

	// Handles toggling of fuel. Snowflake way of changing action icon. Change icon, update action icon, change icon back
	if(toggling)
		icon = 'icons/obj/items/weapons/guns/ammo.dmi'
		if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/X/))
			active_fuel = fuel
			icon_state = "flametank_large"
		else if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/B/))
			active_fuel = fuelX
			icon_state = "flametank_large_blue"
		else if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/))
			active_fuel = fuelB
			icon_state = "flametank_large_green"
	
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()

		icon = 'icons/obj/items/storage.dmi'
		icon_state = "flamethrower_broiler"

	// Update onmob
	if(istype(user)) 
		user.update_inv_back()

// Get the right onmob icon when we have flamer holstered.
/obj/item/marine/fuelpack/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()

	if(flamer)
		var/image/weapon_holstered = overlay_image('icons/mob/humans/onmob/back.dmi', "+m240t", color, RESET_COLOR)
		ret.overlays += weapon_holstered

	return ret

/obj/item/marine/fuelpack/attack_self(mob/user)
	toggle_fuel()

/obj/item/marine/fuelpack/verb/toggle_fuel()
	set name = "Specialist Activation"
	set desc = "Toggle between the fuel types."
	set category = "Weapons"
	
	if(!ishuman(usr) || usr.stat) return 0

	var/obj/item/weapon/gun/flamer/M240T/flamer = usr.get_active_hand()
	if(isnull(flamer) || !flamer || !istype(flamer))
		to_chat(usr, "You must be holding the M240-T incinerator unit to use the [name]") //Hardcoding flamer name or we get null reads.
		return

	if(!active_fuel)
		return

	// Toggle to the next one
	toggling = TRUE
	update_icon()
	flamer.update_icon()
	if(flamer.current_mag)
		flamer.current_mag.update_icon()
	to_chat(usr, "You switched the fuel tank to <b>[active_fuel.caliber]</b>")
	playsound(src,'sound/machines/click.ogg', 25, 1)
	flamer.current_mag = active_fuel
	toggling = FALSE

	return TRUE

/obj/item/marine/fuelpack/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/ammo_magazine/flamer_tank/large/))
		switch_fuel(A, user)
	else if(istype(A, /obj/item/weapon/gun/flamer/M240T) && !flamer)
		flamer = A
		user.drop_inv_item_to_loc(A, src)
		playsound(user,'sound/weapons/gun_rifle_draw.ogg', 15, 1)
		desc = initial(desc) + " It is storing \a [flamer]."
		update_icon()
	else
		if(istype(A, /obj/item/weapon/gun/flamer/M240T)) //Auto equip likes to attackby twice
			return
		to_chat(user, "This thing doesn't fit in the [src.name]!")
		..()

/obj/item/marine/fuelpack/attack_hand(mob/user)
	if(flamer && loc == user && !user.is_mob_incapacitated())
		if(user.put_in_active_hand(flamer))
			playsound(user,'sound/weapons/gun_rifle_draw.ogg', 15, 1)
			flamer = 0
			desc = initial(desc)
			update_icon()
		return
	..()


/obj/item/marine/fuelpack/proc/switch_fuel(var/obj/item/ammo_magazine/flamer_tank/large/new_fuel, var/mob/user)
	// Switch out the currently stored fuel and drop it
	if(istype(new_fuel, /obj/item/ammo_magazine/flamer_tank/large/X/))
		fuelX.forceMove(get_turf(user))
		fuelX = new_fuel
	else if(istype(new_fuel, /obj/item/ammo_magazine/flamer_tank/large/B/))
		fuelB.forceMove(get_turf(user))
		fuelB = new_fuel
	else
		fuel.forceMove(get_turf(user))
		fuel = new_fuel
	visible_message("[user.name] swaps out the fuel tank in the [src.name].","You swap out the fuel tank in the [src] and drop the old one.")
	to_chat(user, "The newly inserted [new_fuel.caliber] contains: [round(new_fuel.get_ammo_percent())]% fuel.")
	user.drop_inv_item_to_loc(new_fuel, src)
	playsound(src,'sound/machines/click.ogg', 25, 1)
	// If the fuel being switched is the active one, set it as new_fuel until it gets toggled
	if(istype(new_fuel, active_fuel))
		active_fuel = new_fuel


/obj/item/marine/fuelpack/examine(mob/user)
	..()
	if (get_dist(user, src) <= 1)
		if(fuel)
			to_chat(user, "The [fuel.caliber] currently contains: [round(fuel.get_ammo_percent())]% fuel.")
		if(fuelB)
			to_chat(user, "The [fuelB.caliber] currently contains: [round(fuelB.get_ammo_percent())]% fuel.")
		if(fuelX)
			to_chat(user, "The [fuelX.caliber] currently contains: [round(fuelX.get_ammo_percent())]% fuel.")

/obj/item/marine/fuelpack/Dispose()
	fuel = null
	fuelB =	null
	fuelX =	null
	active_fuel = null
	flamer = null
	..()