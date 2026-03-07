/*
Anything a security force would need
corporate or pencil pusher shit included, i guess
*/



/obj/item/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "flashbang"
	item_state = "flashbang"
	w_class = SIZE_LARGE

/obj/item/storage/box/flashbangs/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/explosive/grenade/flashbang(src)

	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		handle_delete_clash_contents()
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(handle_delete_clash_contents))

/obj/item/storage/box/flashbangs/proc/handle_delete_clash_contents()
	SIGNAL_HANDLER
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		var/grenade_count = 0
		var/grenades_desired = 4
		for(var/grenade in contents)
			if(grenade_count > grenades_desired)
				qdel(grenade)
			grenade_count++
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box with 5 emp grenades."
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "emp"
	item_state = "emp"
	w_class = SIZE_LARGE
	storage_slots = 5

/obj/item/storage/box/emps/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/explosive/grenade/empgrenade(src)

/obj/item/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/trackimp/fill_preset_inventory()
	for(var/i in 1 to 4)
		new /obj/item/implantcase/tracking(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)
	new /obj/item/device/locator(src)

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"
	item_state = "id"

/obj/item/storage/box/ids/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/card/id(src)

/obj/item/storage/box/handcuffs
	name = "box of handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"
	item_state = "handcuff"
	w_class = SIZE_MEDIUM
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/handcuffs/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/restraint/handcuffs(src)

/obj/item/storage/box/legcuffs
	name = "box of legcuffs"
	desc = "A box full of legcuffs."
	icon_state = "handcuff"
	item_state = "handcuff"
	w_class = SIZE_MEDIUM
	storage_slots = 4

/obj/item/storage/box/legcuffs/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/restraint/legcuffs(src)


/obj/item/storage/box/zipcuffs
	name = "box of zip cuffs"
	desc = "A box full of zip cuffs."
	w_class = SIZE_SMALL
	icon_state = "handcuff"
	item_state = "handcuff"
	storage_slots = 4

/obj/item/storage/box/zipcuffs/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/restraint/handcuffs/zip(src)

/obj/item/storage/box/tapes
	name = "box of regulation tapes"
	desc = "A box full of magnetic tapes for tape recorders. Contains 10 hours and 40 minutes of recording space!"
	w_class = SIZE_SMALL

/obj/item/storage/box/tapes/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SPACE_MAX)
		new /obj/item/tape/regulation(src)

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/holobadge/New()
	for(var/i in 1 to 4)
		new /obj/item/clothing/accessory/holobadge(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/holobadge/cord(src)
