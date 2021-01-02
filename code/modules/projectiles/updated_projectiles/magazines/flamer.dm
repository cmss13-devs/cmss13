

//Flame thrower.

/obj/item/ammo_magazine/flamer_tank
	name = "incinerator tank"
	desc = "A fuel tank used to store fuel for use in the M240 incinerator unit. Handle with care."
	icon_state = "flametank_custom"
	item_state = "flametank"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower //doesn't actually need bullets. But we'll get null ammo error messages if we don't
	w_class = SIZE_MEDIUM //making sure you can't sneak this onto your belt.
	gun_type = /obj/item/weapon/gun/flamer
	caliber = "UT-Napthal Fuel" //Ultra Thick Napthal Fuel, from the lore book.

	var/flamer_chem = "utnapthal"
	flags_magazine = AMMUNITION_HIDE_AMMO

	var/max_intensity = 40
	var/max_range = 6
	var/max_duration = 30

/obj/item/ammo_magazine/flamer_tank/empty
	flamer_chem = null

/obj/item/ammo_magazine/flamer_tank/Initialize(mapload, ...)
	. = ..()
	create_reagents(max_rounds)

	if(flamer_chem)
		reagents.add_reagent(flamer_chem, max_rounds)

	reagents.min_fire_dur = 1
	reagents.min_fire_int = 1
	reagents.min_fire_rad = 1

	reagents.max_fire_dur = max_duration
	reagents.max_fire_rad = max_range
	reagents.max_fire_int = max_intensity

	update_icon()

/obj/item/ammo_magazine/flamer_tank/verb/remove_reagents()
	set name = "Empty cannister"
	set category = "Object"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	if(alert(usr, "Do you really want to empty out [src]?", "Empty cannister", "Yes", "No") == "No")
		return

	reagents.clear_reagents()

	to_chat(usr, SPAN_NOTICE("You empty out [src]"))
	update_icon()

/obj/item/ammo_magazine/flamer_tank/on_reagent_change()
	. = ..()
	update_icon()

	if(istype(loc, /obj/item/weapon/gun/))
		var/obj/item/weapon/gun/G = loc
		if(G.current_mag == src)
			G.update_icon()

/obj/item/ammo_magazine/flamer_tank/afterattack(obj/target, mob/user , flag) //refuel at fueltanks when we run out of ammo.
	if(!istype(target, /obj/structure/reagent_dispensers/fueltank) && !istype(target, /obj/item/tool/weldpack) && !istype(target, /obj/item/storage/backpack/marine/engineerpack))
		return ..()
	if(get_dist(user,target) > 1)
		return ..()

	var/obj/O = target
	if(!O.reagents || O.reagents.reagent_list.len < 1)
		to_chat(user, SPAN_WARNING("[O] is empty!"))
		return

	if(!reagents)
		create_reagents(max_rounds)

	var/datum/reagent/to_add = O.reagents.reagent_list[1]

	if(!istype(to_add) || (length(reagents.reagent_list) && flamer_chem != to_add.id) || length(O.reagents.reagent_list) > 1)
		to_chat(user, SPAN_WARNING("You can't mix fuel mixtures!"))
		return

	if(!to_add.intensityfire)
		to_chat(user, SPAN_WARNING("This chemical is not potent enough to be used in a flamethrower!"))
		return

	var/fuel_amt_to_remove = Clamp(to_add.volume, 0, max_rounds - reagents.get_reagent_amount(to_add.id))
	if(!fuel_amt_to_remove)
		to_chat(user, SPAN_WARNING("[O] is empty!"))
		return

	O.reagents.remove_reagent(to_add.id, fuel_amt_to_remove)
	reagents.add_reagent(to_add.id, fuel_amt_to_remove)
	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	caliber = to_add.name
	flamer_chem = to_add.id

	to_chat(user, SPAN_NOTICE("You refill [src] with [caliber]."))
	update_icon()

/obj/item/ammo_magazine/flamer_tank/update_icon()
	overlays.Cut()

	var/image/I = image(icon, icon_state="[icon_state]_strip")

	if(reagents)
		I.color = mix_color_from_reagents(reagents.reagent_list)

	overlays += I

/obj/item/ammo_magazine/flamer_tank/get_ammo_percent()
	if(!reagents)
		return 0

	return 100 * (reagents.total_volume / max_rounds)

/obj/item/ammo_magazine/flamer_tank/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("It contains:"))
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			to_chat(user, SPAN_NOTICE(" [R.volume] units of [R.name]."))
	else
		to_chat(user, SPAN_NOTICE("Nothing."))

/obj/item/ammo_magazine/flamer_tank/large	// Extra thicc tank
	name = "large incinerator tank"
	desc = "A large fuel tank used to store fuel for use in the M240-T incinerator unit. Handle with care."
	icon_state = "flametank_large_custom"
	item_state = "flametank_large"
	max_rounds = 250
	gun_type = /obj/item/weapon/gun/flamer/M240T

	max_intensity = 80
	max_range = 10
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/large/empty
	flamer_chem = null

/obj/item/ammo_magazine/flamer_tank/gellied
	name = "large incinerator tank (Gel)"
	desc = "A large fuel tank full of heavier gel fuel. Unlike its liquid contemporaries, this stuff shoots far, and burns up fast, but it doesn't burn anywhere near as hot. Handle with exceptional care."
	caliber = "Napalm Gel"
	flamer_chem = "napalmgel"
	max_rounds = 200

/obj/item/ammo_magazine/flamer_tank/large/B
	name = "large incinerator tank (B)"
	desc = "A large fuel tank of Ultra Thick Napthal Fuel type B, a wide-spreading sticky combustable liquid chemical that burns up fast with a low temperature, for use in the M240-T incinerator unit. Handle with care."
	caliber = "Napalm B"
	flamer_chem = "napalmb"

/obj/item/ammo_magazine/flamer_tank/large/X
	name = "large incinerator tank (X)"
	desc = "A large fuel tank of Ultra Thick Napthal Fuel type X, a sticky combustable liquid chemical that burns extremely hot, for use in the M240-T incinerator unit. Handle with care."
	caliber = "Napalm X"
	flamer_chem = "napalmx"
