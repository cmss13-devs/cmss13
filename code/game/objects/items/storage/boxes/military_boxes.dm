/*
look this file could be named grenade boxes or explosives boxes
and it really wouldnt make that much of a difference
*/

////////// MARINES BOXES //////////////////////////


/obj/item/storage/box/explosive_mines
	name = "\improper M20 mine box"
	desc = "A secure box holding five M20 anti-personnel proximity mines."
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "minebox"
	item_state = "minebox"
	storage_slots = 5
	can_hold = list(/obj/item/explosive/mine)
	preset_hold_only = FALSE

/obj/item/storage/box/explosive_mines/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/explosive/mine(src)

/obj/item/storage/box/explosive_mines/pmc
	name = "\improper M20P mine box"

/obj/item/storage/box/explosive_mines/pmc/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/explosive/mine/pmc(src)

/obj/item/storage/box/m94
	name = "\improper M94 marking flare pack"
	desc = "A packet of eight M94 Marking Flares. Carried by USCM soldiers to light dark areas that cannot be reached with the usual TNR Shoulder Lamp."
	icon_state = "m94"
	icon = 'icons/obj/items/storage/packets.dmi'
	storage_slots = 8
	can_hold = list(/obj/item/device/flashlight/flare,/obj/item/device/flashlight/flare/signal)
	preset_hold_only = FALSE

/obj/item/storage/box/m94/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/box/m94/update_icon()
	if(!length(contents))
		icon_state = "m94_e"
	else
		icon_state = "m94"


/obj/item/storage/box/m94/signal
	name = "\improper M89-S signal flare pack"
	desc = "A packet of eight M89-S Signal Marking Flares."
	icon_state = "m89"

/obj/item/storage/box/m94/signal/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/device/flashlight/flare/signal(src)

/obj/item/storage/box/m94/signal/update_icon()
	if(!length(contents))
		icon_state = "m89_e"
	else
		icon_state = "m89"


/obj/item/storage/box/nade_box
	name = "\improper M40 HEDP grenade box"
	desc = "A secure box holding 25 M40 High-Explosive Dual-Purpose grenades. High explosive, don't store near the flamer fuel."
	icon_state = "nade_placeholder"
	item_state = "nade_placeholder"
	icon = 'icons/obj/items/storage/packets.dmi'
	w_class = SIZE_LARGE
	storage_slots = 25
	can_hold = list(/obj/item/explosive/grenade/high_explosive)
	preset_hold_only = FALSE
	var/base_icon
	var/model_icon = "model_m40"
	var/type_icon = "hedp"
	var/grenade_type = /obj/item/explosive/grenade/high_explosive
	flags_atom = FPRINT|CONDUCT|MAP_COLOR_INDEX
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)
	weighted_storage = TRUE

/obj/item/storage/box/nade_box/Initialize()
	. = ..()
	if(!(flags_atom & NO_GAMEMODE_SKIN))
		select_gamemode_skin()
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(try_forced_folding))

/obj/item/storage/box/nade_box/proc/try_forced_folding(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!isturf(loc))
		return

	if(length(contents))
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	storage_close(user)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	qdel(src)

/obj/item/storage/box/nade_box/post_skin_selection()
	base_icon = icon_state

/obj/item/storage/box/nade_box/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new grenade_type(src)

/obj/item/storage/box/nade_box/update_icon()
	overlays.Cut()
	if(!length(contents))
		icon_state = "[base_icon]_e"
	else
		icon_state = base_icon
		if(type_icon)
			overlays += image(icon, type_icon)
		if(model_icon)
			overlays += image(icon, model_icon)


/obj/item/storage/box/nade_box/frag
	name = "\improper M40 HEFA grenade box"
	desc = "A secure box holding 25 M40 High-Explosive Fragmenting-Antipersonnel grenades. High explosive, don't store near the flamer fuel."
	type_icon = "hefa"
	can_hold = list(/obj/item/explosive/grenade/high_explosive/frag)
	grenade_type = /obj/item/explosive/grenade/high_explosive/frag

/obj/item/storage/box/nade_box/phophorus
	name = "\improper M40 CCDP grenade box"
	desc = "A secure box holding 25 M40 CCDP chemical compound grenade. High explosive, don't store near the flamer fuel."
	type_icon = "ccdp"
	can_hold = list(/obj/item/explosive/grenade/phosphorus)
	grenade_type = /obj/item/explosive/grenade/phosphorus

/obj/item/storage/box/nade_box/incen
	name = "\improper M40 HIDP grenade box"
	desc = "A secure box holding 25 M40 HIDP white incendiary grenades. Highly flammable, don't store near the flamer fuel."
	type_icon = "hidp"
	can_hold = list(/obj/item/explosive/grenade/incendiary)
	grenade_type = /obj/item/explosive/grenade/incendiary

/obj/item/storage/box/nade_box/airburst
	name = "\improper M74 AGM-F grenade box"
	desc = "A secure box holding 25 M74 AGM Fragmentation grenades. Explosive, don't store near the flamer fuel."
	model_icon = "model_m74"
	type_icon = "agmf"
	can_hold = list(/obj/item/explosive/grenade/high_explosive/airburst)
	grenade_type = /obj/item/explosive/grenade/high_explosive/airburst

/obj/item/storage/box/nade_box/airburstincen
	name = "\improper M74 AGM-I grenade box"
	desc = "A secure box holding 25 M74 AGM Incendiary grenades. Highly flammable, don't store near the flamer fuel."
	model_icon = "model_m74"
	type_icon = "agmi"
	can_hold = list(/obj/item/explosive/grenade/incendiary/airburst)
	grenade_type = /obj/item/explosive/grenade/incendiary/airburst


/obj/item/storage/box/nade_box/training
	name = "\improper M07 training grenade box"
	desc = "A secure box holding 25 M07 training grenades. Harmless and reusable."
	icon_state = "train_nade_placeholder"
	item_state = "train_nade_placeholder"
	model_icon = "model_mo7"
	type_icon = null
	grenade_type = /obj/item/explosive/grenade/high_explosive/training
	can_hold = list(/obj/item/explosive/grenade/high_explosive/training)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes

/obj/item/storage/box/nade_box/tear_gas
	name = "\improper M66 tear gas grenade box"
	desc = "A secure box holding 25 M66 tear gas grenades. Used for riot control."
	icon_state = "teargas_nade_placeholder"
	item_state = "teargas_nade_placeholder"
	model_icon = "model_m66"
	type_icon = null
	grenade_type = /obj/item/explosive/grenade/custom/teargas
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes

/obj/item/storage/box/nade_box/tear_gas/fill_preset_inventory()
	..()
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		handle_delete_clash_contents()
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(handle_delete_clash_contents))

/obj/item/storage/box/nade_box/tear_gas/proc/handle_delete_clash_contents()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		var/grenade_count = 0
		var/grenades_desired = 6
		for(var/grenade in contents)
			if(grenade_count > grenades_desired)
				qdel(grenade)
			grenade_count++
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

// van bandoliers humble box
/obj/item/storage/box/twobore
	name = "box of 2 bore shells"
	icon_state = "twobore"
	icon = 'icons/obj/items/storage/kits.dmi'
	desc = "A box filled with enormous slug shells, for hunting only the most dangerous game. 2 Bore."
	storage_slots = 5

/obj/item/storage/box/twobore/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/twobore(src)
