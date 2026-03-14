/*
Engineering parts and scraps and lights and tubes and stuff
*/


/obj/item/storage/box/engineer // this is literally just a copy of the survival box, but sure whatever

/obj/item/storage/box/engineer/fill_preset_inventory()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/tank/emergency_oxygen/engi( src )

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/items/storage/boxes.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "light"
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap
	can_hold = list(
		/obj/item/light_bulb/tube,
		/obj/item/light_bulb/bulb,
	)
	max_storage_space = 42 //holds 21 items of w_class 2
	storage_flags = STORAGE_FLAGS_BOX|STORAGE_CLICK_GATHER
	preset_hold_only = FALSE

/obj/item/storage/box/lights/bulbs/fill_preset_inventory()
	for(var/i in 1 to 21)
		new /obj/item/light_bulb/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
	item_state = "lighttube"

/obj/item/storage/box/lights/tubes/fill_preset_inventory()
	for(var/i in 1 to 21)
		new /obj/item/light_bulb/tube/large(src)

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"
	item_state = "lightmixed"

/obj/item/storage/box/lights/mixed/fill_preset_inventory()
	for(var/i in 1 to 11)
		new /obj/item/light_bulb/tube/large(src)
	for(var/i in 1 to 10)
		new /obj/item/light_bulb/bulb(src)

/obj/item/storage/box/lightstick
	name = "box of lightsticks"
	desc = "Contains blue lightsticks."
	icon_state = "lightstick"
	item_state = "lightstick"
	w_class = SIZE_SMALL
	can_hold = list(
		/obj/item/lightstick,
	)
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/lightstick/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/lightstick(src)

/obj/item/storage/box/lightstick/red
	desc = "Contains red lightsticks."
	icon_state = "lightstick2"
	item_state = "lightstick2"

/obj/item/storage/box/lightstick/red/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/lightstick/red(src)

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"
	item_state = "mousetraps"

/obj/item/storage/box/mousetraps/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/device/assembly/mousetrap( src )
