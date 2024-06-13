

//Flame thrower.

/obj/item/ammo_magazine/flamer_tank
	name = "incinerator tank"
	desc = "A fuel tank used to store fuel for use in the M240 incinerator unit. Handle with care."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "flametank_custom"
	item_state = "flametank"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower //doesn't actually need bullets. But we'll get null ammo error messages if we don't
	w_class = SIZE_MEDIUM //making sure you can't sneak this onto your belt.
	gun_type = /obj/item/weapon/gun/flamer
	caliber = "UT-Napthal Fuel" //Ultra Thick Napthal Fuel, from the lore book.
	var/custom = FALSE //accepts custom fuels if true

	var/flamer_chem = "utnapthal"
	flags_magazine = AMMUNITION_HIDE_AMMO

	var/max_intensity = 40
	var/max_range = 5
	var/max_duration = 30

	var/fuel_pressure = 1 //How much fuel is used per tile fired
	var/max_pressure = 10

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
	set name = "Empty canister"
	set category = "Object"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	if(alert(usr, "Do you really want to empty out [src]?", "Empty canister", "Yes", "No") != "Yes")
		return

	reagents.clear_reagents()

	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	to_chat(usr, SPAN_NOTICE("You empty out [src]"))
	update_icon()

/obj/item/ammo_magazine/flamer_tank/on_reagent_change()
	. = ..()
	update_icon()

	if(isgun(loc))
		var/obj/item/weapon/gun/G = loc
		if(G.current_mag == src)
			G.update_icon()

/obj/item/ammo_magazine/flamer_tank/afterattack(obj/target, mob/user , flag) //refuel at fueltanks when we run out of ammo.
	if(get_dist(user,target) > 1)
		return ..()
	if(!istype(target, /obj/structure/reagent_dispensers/fueltank) && !istype(target, /obj/item/tool/weldpack) && !istype(target, /obj/item/storage/backpack/marine/engineerpack))
		return ..()

	if(!target.reagents || target.reagents.reagent_list.len < 1)
		to_chat(user, SPAN_WARNING("[target] is empty!"))
		return

	if(!reagents)
		create_reagents(max_rounds)

	var/datum/reagent/to_add = target.reagents.reagent_list[1]

	if(!istype(to_add) || (length(reagents.reagent_list) && flamer_chem != to_add.id) || length(target.reagents.reagent_list) > 1)
		to_chat(user, SPAN_WARNING("You can't mix fuel mixtures!"))
		return

	if(istype(to_add, /datum/reagent/generated) && !custom)
		to_chat(user, SPAN_WARNING("[src] cannot accept custom fuels!"))
		return

	if(!to_add.intensityfire && to_add.id != "stablefoam" && !istype(src, /obj/item/ammo_magazine/flamer_tank/smoke))
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

/obj/item/ammo_magazine/flamer_tank/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It contains:")
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			. += SPAN_NOTICE(" [R.volume] units of [R.name].")
	else
		. += SPAN_NOTICE("Nothing.")

// This is gellie fuel. Green Flames.
/obj/item/ammo_magazine/flamer_tank/gellied
	name = "incinerator tank (B-Gel)"
	desc = "A fuel tank full of specialized Ultra Thick Napthal Fuel type B-Gel. Unlike its liquid contemporaries, this gelled variant of napalm is easily extinguished, but shoots far and lingers on the ground in a viscous mess, while reacting with inorganic materials to break them down. Handle with exceptional care."
	caliber = "Napalm Gel"
	flamer_chem = "napalmgel"
	max_rounds = 200

	max_range = 7
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/EX
	name = "incinerator tank (EX)"
	desc = "A fuel tank of Ultra Thick Napthal Fuel type EX, a sticky combustible liquid chemical that burns so hot it melts straight through flame-resistant material, for use in the M240-T incinerator unit. Handle with care."
	caliber = "Napalm EX"
	flamer_chem = "napalmex"

	max_range = 7

/obj/item/ammo_magazine/flamer_tank/custom
	name = "custom incinerator tank"
	desc = "A fuel tank used to store fuel for use in the M240 incinerator unit. This one has been modified with a pressure regulator and an internal propellant tank."
	matter = list("metal" = 3750)
	flamer_chem = null
	max_rounds = 100
	max_range = 5
	fuel_pressure = 1
	custom = TRUE

/obj/item/ammo_magazine/flamer_tank/custom/verb/set_fuel_pressure()
	set name = "Change Fuel Pressure"
	set category = "Object"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	var/set_pressure = clamp(tgui_input_number(usr, "Change fuel pressure to: (max: [max_pressure])", "Fuel pressure", fuel_pressure, 10, 1), 1 ,max_pressure)
	if(!set_pressure)
		to_chat(usr, SPAN_WARNING("You can't find that setting on the regulator!"))
	else
		to_chat(usr, SPAN_NOTICE("You set the pressure regulator to [set_pressure] U/t"))
		fuel_pressure = set_pressure

/obj/item/ammo_magazine/flamer_tank/custom/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("The pressure regulator is set to: [src.fuel_pressure] U/t")

// Pyro regular flamer tank just bigger than the base flamer tank.
/obj/item/ammo_magazine/flamer_tank/large
	name = "large incinerator tank"
	desc = "A large fuel tank used to store fuel for use in the M240-T incinerator unit. Handle with care."
	icon_state = "flametank_large_custom"
	item_state = "flametank_large"
	max_rounds = 250
	gun_type = /obj/item/weapon/gun/flamer/M240T

	max_intensity = 80
	max_range = 5
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/large/empty
	flamer_chem = null



// This is the green flamer fuel for the pyro.
/obj/item/ammo_magazine/flamer_tank/large/B
	name = "large incinerator tank (B)"
	desc = "A large fuel tank of Ultra Thick Napthal Fuel type B, a special variant of napalm that is easily extinguished, but disperses over a wide area while burning slowly. The composition reacts with inorganic materials to break them down, causing severe damage. For use in the M240-T incinerator unit. Handle with care."
	caliber = "Napalm B"
	flamer_chem = "napalmb"

	max_range = 6

// This is the blue flamer fuel for the pyro.
/obj/item/ammo_magazine/flamer_tank/large/X
	name = "large incinerator tank (X)"
	desc = "A large fuel tank of Ultra Thick Napthal Fuel type X, a sticky combustible liquid chemical that burns extremely hot, for use in the M240-T incinerator unit. Handle with care."
	caliber = "Napalm X"
	flamer_chem = "napalmx"

	max_range = 6

/obj/item/ammo_magazine/flamer_tank/large/EX
	name = "large incinerator tank (EX)"
	desc = "A large fuel tank of Ultra Thick Napthal Fuel type EX, a sticky combustible liquid chemical that burns so hot it melts straight through flame-resistant material, for use in the M240-T incinerator unit. Handle with care."
	caliber = "Napalm EX"
	flamer_chem = "napalmex"

	max_range = 7

//Custom pyro tanks
/obj/item/ammo_magazine/flamer_tank/custom/large
	name = "large custom incinerator tank"
	desc = "A large fuel tank for use in the M240-T incinerator unit. This one has been modified with a pressure regulator and a large internal propellant tank. Must be manually attached."
	gun_type = /obj/item/weapon/gun/flamer/M240T
	max_rounds = 250

	max_intensity = 60
	max_range = 8
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/smoke
	name = "Custom incinerator smoke tank"
	desc = "A tank holding powdered smoke that expands when exposed to an open flame and carries any chemicals along with it."
	matter = list("metal" = 3750)
	flamer_chem = null
	custom = TRUE
