/obj/item/ammo_magazine/hardpoint/primary_flamer
	name = "DRG-N Offensive Flamer Unit Fuel Tank"
	desc = "Fuel tanks for the DRG-N Offensive Flamer. It contains a high-combustion napalm, capabale of burning through nearly anything."
	caliber = "High-Combustion Napalm" //correlates to flamer mags
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "drgn_flametank"
	w_class = SIZE_LARGE
	max_rounds = 300
	gun_type = /obj/item/hardpoint/primary/flamer
	default_ammo = /datum/ammo/flamethrower/tank_flamer
	// Reagent id this tank starts filled with
	var/flamer_chem = "highdamagenapalm"

/obj/item/ammo_magazine/hardpoint/primary_flamer/Initialize(mapload, ...)
	. = ..()
	create_reagents(max_rounds)
	if(flamer_chem)
		reagents.add_reagent(flamer_chem, max_rounds)
	current_rounds = round(reagents.total_volume)
	update_icon()

/**
 * Refuels this tank from a fuel source, exactly mirroring /obj/item/ammo_magazine/flamer_tank/afterattack()
 *
 * also follows the same rules regarding what fuel types are or aren't allowed.
 */
/obj/item/ammo_magazine/hardpoint/primary_flamer/afterattack(obj/target, mob/user, flag)
	if(get_dist(user, target) > 1)
		return ..()
	if(!istype(target, /obj/structure/reagent_dispensers/tank/fuel) && !istype(target, /obj/item/tool/weldpack) && !istype(target, /obj/item/storage/backpack/marine/engineerpack) && !istype(target, /obj/item/ammo_magazine/hardpoint/primary_flamer))
		return ..()

	if(!target.reagents || length(target.reagents.reagent_list) < 1)
		to_chat(user, SPAN_WARNING("[target] is empty!"))
		return

	if(!reagents)
		create_reagents(max_rounds)

	var/datum/reagent/to_add = target.reagents.reagent_list[1]

	if(!istype(to_add) || (length(reagents.reagent_list) && flamer_chem != to_add.id) || length(target.reagents.reagent_list) > 1)
		to_chat(user, SPAN_WARNING("You can't mix fuel mixtures!"))
		return

	if(!to_add.intensityfire && to_add.id != "stablefoam")
		to_chat(user, SPAN_WARNING("This chemical is not potent enough to be used in a flamethrower!"))
		return

	var/fuel_amt_to_remove = clamp(to_add.volume, 0, max_rounds - reagents.get_reagent_amount(to_add.id))
	if(!fuel_amt_to_remove)
		if(!max_rounds)
			to_chat(user, SPAN_WARNING("[target] is empty!"))
		return

	target.reagents.remove_reagent(to_add.id, fuel_amt_to_remove)
	reagents.add_reagent(to_add.id, fuel_amt_to_remove)
	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	caliber = to_add.name
	flamer_chem = to_add.id
	current_rounds = round(reagents.total_volume)

	to_chat(user, SPAN_NOTICE("You refill [src] with [caliber]."))
	update_icon()


// Colored fuel strip overlay
/obj/item/ammo_magazine/hardpoint/primary_flamer/update_icon()
	overlays.Cut()
	if(current_rounds > 0)
		icon_state = "drgn_flametank"
		var/image/strip = image(icon, icon_state = "drgn_flametank_strip")
		if(reagents)
			strip.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += strip
	else
		icon_state = "drgn_flametank_empty"

// Lists loaded fuel by name/volume on examine
/obj/item/ammo_magazine/hardpoint/primary_flamer/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It contains:")
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/reagent in reagents.reagent_list)
			. += SPAN_NOTICE(" [reagent.volume] units of [reagent.name].")
	else
		. += SPAN_NOTICE(" Nothing.")

// "Empty canister" verb, also found in the m240 flamer.
/obj/item/ammo_magazine/hardpoint/primary_flamer/verb/remove_reagents()
	set name = "Empty canister"
	set category = "Object"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	if(alert(usr, "Do you really want to empty out [src]?", "Empty canister", "Yes", "No") != "Yes")
		return

	reagents.clear_reagents()
	current_rounds = round(reagents.total_volume)

	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	to_chat(usr, SPAN_NOTICE("You empty out [src]"))
	update_icon()
