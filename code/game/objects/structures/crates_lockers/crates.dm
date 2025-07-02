//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "closed_basic"
	icon_opened = "open_basic"
	icon_closed = "closed_basic"
	climbable = 1
	anchored = FALSE
	throwpass = 1 //prevents moving crates by hurling things at them
	store_mobs = FALSE
	var/rigged = 0
	/// Types this crate can be made into
	var/list/crate_customizing_types = list(
		"Plain" = /obj/structure/closet/crate,
		"Plain (Green)" = /obj/structure/closet/crate/green,
		"Weapons" = /obj/structure/closet/crate/weapon,
		"Supply" = /obj/structure/closet/crate/supply,
		"Ammo" = /obj/structure/closet/crate/ammo,
		"Ammo (Black)" = /obj/structure/closet/crate/ammo/alt,
		"Ammo (Flame)" = /obj/structure/closet/crate/ammo/alt/flame,
		"Construction" = /obj/structure/closet/crate/construction,
		"Science" = /obj/structure/closet/crate/science,
		"Hydroponics" = /obj/structure/closet/crate/hydroponics,
		"Medical" = /obj/structure/closet/crate/medical,
		"Internals" = /obj/structure/closet/crate/internals,
		"Explosives" = /obj/structure/closet/crate/explosives,
		"Alpha" = /obj/structure/closet/crate/alpha,
		"Bravo" = /obj/structure/closet/crate/bravo,
		"Charlie" = /obj/structure/closet/crate/charlie,
		"Delta" = /obj/structure/closet/crate/delta,
	)

/obj/structure/closet/crate/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND

/obj/structure/closet/crate/can_open()
	return 1

/obj/structure/closet/crate/can_close()
	for(var/mob/living/L in get_turf(src)) //Can't close if someone is standing inside it. This is to prevent "crate traps" (let someone step in, close, open for 30 damage)
		return 0
	return 1

/obj/structure/closet/crate/BlockedPassDirs(atom/movable/mover, target_dir)
	for(var/obj/structure/S in get_turf(mover))
		if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
			return NO_BLOCKED_MOVEMENT
	if(opened) //Open crate, you can cross over it
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/closet/crate/open()
	if(opened)
		return 0
	if(!can_open())
		return 0

	if(rigged && locate(/obj/item/device/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			if(L.electrocute_act(17, src))
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return 2

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	opened = 1
	update_icon()
	if(climbable)
		structure_shaken()
		climbable = 0 //Open crate is not a surface that works when climbing around
	return 1

/obj/structure/closet/crate/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O, /obj/structure/closet) || istype(O, /obj/effect))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.buckled_mob)
				continue
		if(istype(O, /obj/item/phone))
			continue
		O.forceMove(src)
		itemcount++

	opened = 0
	climbable = 1
	update_icon()
	return 1

/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(W.flags_item & ITEM_ABSTRACT)
		return
	if(opened)
		user.drop_inv_item_to_loc(W, loc)
	else if(istype(W, /obj/item/packageWrap) || istype(W, /obj/item/stack/fulton) || istype(W, /obj/item/tool/hand_labeler)) //If it does something to the crate, don't open it.
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, SPAN_NOTICE("[src] is already rigged!"))
			return
		if (C.use(1))
			to_chat(user, SPAN_NOTICE("You rig [src]."))
			rigged = 1
			return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			to_chat(user, SPAN_NOTICE("You attach [W] to [src]."))
			user.drop_held_item()
			W.forceMove(src)
			return
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(rigged)
			to_chat(user, SPAN_NOTICE("You cut away the wiring."))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			rigged = 0
			return
	else
		return attack_hand(user)

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(50))
				deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			contents_explosion(severity)
			deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			contents_explosion(severity)
			deconstruct(FALSE)
			return

/obj/structure/closet/crate/alpha
	name = "alpha squad crate"
	desc = "A crate with alpha squad's symbol on it. "
	icon_state = "closed_alpha"
	icon_opened = "open_alpha"
	icon_closed = "closed_alpha"

/obj/structure/closet/crate/ammo
	name = "ammunitions crate"
	desc = "An ammunitions crate"
	icon_state = "closed_ammo"
	icon_opened = "open_ammo"
	icon_closed = "closed_ammo"

/obj/structure/closet/crate/ammo/alt
	name = "ammunitions crate"
	desc = "A crate that contains ammunition, this one is black."
	icon_state = "closed_ammo_alt"
	icon_opened = "open_ammo_alt"
	icon_closed = "closed_ammo_alt"

/obj/structure/closet/crate/ammo/alt/flame
	name = "ammunitions crate"
	desc = "A black crate. Warning, contents are flammable!"
	icon_state = "closed_ammo_alt2"
	icon_opened = "open_ammo_alt"//does not have its own unique icon
	icon_closed = "closed_ammo_alt2"

/obj/structure/closet/crate/green
	name = "green crate"
	desc = "A standard green storage crate employed by the USCM. These things are so common, just about anything could be inside."
	icon_state = "closed_green"
	icon_opened = "open_green"
	icon_closed = "closed_green"

/obj/structure/closet/crate/bravo
	name = "bravo squad crate"
	desc = "A crate with bravo squad's symbol on it. "
	icon_state = "closed_bravo"
	icon_opened = "open_bravo"
	icon_closed = "closed_bravo"

/obj/structure/closet/crate/charlie
	name = "charlie squad crate"
	desc = "A crate with charlie squad's symbol on it. "
	icon_state = "closed_charlie"
	icon_opened = "open_charlie"
	icon_closed = "closed_charlie"

/obj/structure/closet/crate/construction
	name = "construction crate"
	desc = "A construction crate"
	icon_state = "closed_construction"
	icon_opened = "open_construction"
	icon_closed = "closed_construction"

/obj/structure/closet/crate/delta
	name = "delta squad crate"
	desc = "A crate with delta squad's symbol on it. "
	icon_state = "closed_delta"
	icon_opened = "open_delta"
	icon_closed = "closed_delta"

/obj/structure/closet/crate/explosives
	name = "explosives crate"
	desc = "An explosives crate"
	icon_state = "closed_explosives"
	icon_opened = "open_explosives"
	icon_closed = "closed_explosives"

/obj/structure/closet/crate/freezer
	name = "freezer crate"
	desc = "A freezer crate."
	icon_state = "closed_freezer"
	icon_opened = "open_freezer"
	icon_closed = "closed_freezer"
	crate_customizing_types = null
	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/cooler
	icon = 'icons/obj/structures/souto_land.dmi'
	desc = "A cozy cooler for your beer and other beverages."
	icon_state = "cooler_closed"
	icon_opened = "cooler_open"
	icon_closed = "cooler_closed"
	cooling_power = 10//not nearly as good as the actual freezer crate

/obj/structure/closet/crate/freezer/cooler/oj
	icon_state = "cooler-oj_closed"
	icon_opened = "cooler-oj_open"
	icon_closed = "cooler-oj_closed"


/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "closed_hydro"
	icon_opened = "open_hydro"
	icon_closed = "closed_hydro"

/obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.

/obj/structure/closet/crate/hydroponics/prespawned/Initialize()
	. = ..()
	new /obj/item/reagent_container/spray/plantbgone(src)
	new /obj/item/reagent_container/spray/plantbgone(src)
	new /obj/item/tool/minihoe(src)

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "An internals crate."
	icon_state = "closed_oxygen"
	icon_opened = "open_oxygen"
	icon_closed = "closed_oxygen"

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "closed_medical"
	icon_opened = "open_medical"
	icon_closed = "closed_medical"

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "closed_plastic"
	icon_opened = "open_plastic"
	icon_closed = "closed_plastic"

/obj/structure/closet/crate/rcd
	name = "RCD crate"
	desc = "A crate for the storage of the RCD."

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	desc = "A crate of emergency rations."
	name = "Emergency Rations"

/obj/structure/closet/crate/freezer/rations/Initialize()
	. = ..()
	new /obj/item/storage/box/donkpockets(src)
	new /obj/item/storage/box/donkpockets(src)

/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "closed_radioactive"
	icon_opened = "open_radioactive"
	icon_closed = "closed_radioactive"

/obj/structure/closet/crate/radiation/Initialize()
	. = ..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/science
	name = "science crate"
	desc = "A science crate."
	icon_state = "closed_science"
	icon_opened = "open_science"
	icon_closed = "closed_science"

/obj/structure/closet/crate/supply
	name = "supply crate"
	desc = "A supply crate."
	icon_state = "closed_supply"
	icon_opened = "open_supply"
	icon_closed = "closed_supply"

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "closed_trashcart"
	icon_opened = "open_trashcart"
	icon_closed = "closed_trashcart"

/obj/structure/closet/crate/foodcart
	name = "food cart"
	desc = "A heavy, metal foodcart with wheels."
	icon_state = "foodcart2"
	icon_opened = "foodcart2_open"
	icon_closed = "foodcart2"

/obj/structure/closet/crate/foodcart/alt
	icon_state = "foodcart1"
	icon_opened = "foodcart1_open"
	icon_closed = "foodcart1"

/obj/structure/closet/crate/weapon
	name = "weapons crate"
	desc = "A weapons crate."
	icon_state = "closed_weapons"
	icon_opened = "open_weapons"
	icon_closed = "closed_weapons"
	var/obj/item/weapon_type
	var/obj/item/ammo_type
	var/ammo_count = 5

/obj/structure/closet/crate/weapon/Initialize()
	. = ..()
	if(ammo_type)
		for(var/t=0,t<ammo_count,t++)
			new ammo_type(src)
	if(weapon_type)
		new weapon_type(src)

/obj/structure/closet/crate/empexplosives
	name = "electromagnetic explosives crate"
	desc = "An explosives crate, containing EMP grenades"
	icon_state = "closed_explosives"
	icon_opened = "open_explosives"
	icon_closed = "closed_explosives"

/obj/structure/closet/crate/empexplosives/Initialize()
	. = ..()
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)

	/* * * * * * * * * * * * * *
	 * Training weapon crates. *
	 * * * * * * * * * * * * * */

/obj/structure/closet/crate/weapon/training/m41a
	name = "training M41A MK2 crate"
	desc = "A crate with an M41A MK2 rifle and nonlethal ammunition for it. Intended for use in combat exercises."
	weapon_type = /obj/item/weapon/gun/rifle/m41a/training
	ammo_type = /obj/item/ammo_magazine/rifle/rubber

/obj/structure/closet/crate/weapon/training/m4ra
	name = "training M4RA crate"
	desc = "A crate with an M4RA battle rifle and nonlethal ammunition for it. Intended for use in combat exercises."
	weapon_type = /obj/item/weapon/gun/rifle/m4ra/training
	ammo_type = /obj/item/ammo_magazine/rifle/m4ra/rubber

/obj/structure/closet/crate/weapon/training/l42a
	name = "training L42A crate"
	desc = "A crate with an L42A battle rifle and nonlethal ammunition for it. Intended for use in combat exercises."
	weapon_type = /obj/item/weapon/gun/rifle/l42a/training
	ammo_type = /obj/item/ammo_magazine/rifle/l42a/rubber

/obj/structure/closet/crate/weapon/training/m39
	name = "training M39 crate"
	desc = "A crate with an M39 submachine gun and nonlethal ammunition for it. Intended for use in combat exercises."
	weapon_type = /obj/item/weapon/gun/smg/m39/training
	ammo_type = /obj/item/ammo_magazine/smg/m39/rubber

/obj/structure/closet/crate/weapon/training/m4a3
	name = "training M4A3 crate"
	desc = "A crate with an M4A3 pistol and nonlethal ammunition for it. Intended for use in combat exercises."
	weapon_type = /obj/item/weapon/gun/pistol/m4a3/training
	ammo_type = /obj/item/ammo_magazine/pistol/rubber

/obj/structure/closet/crate/weapon/training/mod88
	name = "training 88 mod 4 crate"
	desc = "A crate with an 88 mod 4 pistol and nonlethal ammunition for it. Intended for use in combat exercises."
	weapon_type = /obj/item/weapon/gun/pistol/mod88/training
	ammo_type = /obj/item/ammo_magazine/pistol/mod88/rubber

/obj/structure/closet/crate/weapon/training/grenade
	name = "rubber pellet M15 grenades crate"
	desc = "A crate with multiple nonlethal M15 grenades. Intended for use in combat exercises and riot control."
	ammo_type = /obj/item/explosive/grenade/high_explosive/m15/rubber
	ammo_count = 6


/obj/structure/closet/crate/miningcar
	name = "\improper minecart"
	desc = "Essentially a big metal bucket on wheels. This one has a modern plastic shroud."
	icon_state = "closed_mcart"
	density = TRUE
	icon_opened = "open_mcart"
	icon_closed = "closed_mcart"

/obj/structure/closet/crate/miningcar/yellow
	name = "\improper minecart"
	desc = "Essentially a big metal bucket on wheels. This one has a modern plastic shroud."
	icon_state = "closed_mcart_y"
	density = TRUE
	icon_opened = "open_mcart_y"
	icon_closed = "closed_mcart_y"
