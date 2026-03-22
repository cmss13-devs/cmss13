// Grenades

/obj/item/explosive/grenade/high_explosive/unsc
	name = "M9 fragmentation grenade"
	desc = "A high explosive fragmentation grenade utilized by the UNSC."
	desc_lore = "Rumors spread about how every new posting someone gets, the design of the M9 fragmentation grenade looks different from the last ones they held."
	icon = 'icons/halo/obj/items/weapons/grenades.dmi'
	icon_state = "m9"
	item_state = "m9"
	shrapnel_count = 12
	underslug_launchable = FALSE

/obj/item/explosive/grenade/high_explosive/unsc/launchable
	name = "40mm explosive grenade"
	desc = "A 40mm explosive grenade. It's unable to be primed by hand and must be loaded into the bottom of a rifle's grenade launcher."
	icon = 'icons/halo/obj/items/weapons/grenades.dmi'
	icon_state = "he_40mm"
	item_state = "he_40mm"
	hand_throwable = FALSE
	has_arm_sound = FALSE
	dangerous = FALSE
	underslug_launchable = TRUE



//========== PISTOL BELTS ==========
/obj/item/storage/belt/gun/m6
	name = "\improper M6 general pistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the UNSC. It consists of a modular belt with various clips. This version has a holster assembly that allows one to carry the most common pistols. It also contains side pouches that can store most pistol magazines."
	icon = 'icons/halo/obj/items/clothing/belts/belts_by_faction/belt_unsc.dmi'
	icon_state = "m6_holster"
	item_state = "s_marinebelt"
	item_icons = list(
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/belts/belts_by_faction/belt_unsc.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi')
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/pistol/halo,
		/obj/item/ammo_magazine/pistol/halo,
	)
	gun_has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = -5,
			"icon_y" = 0))

/obj/item/storage/belt/gun/m6/full_m6c/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6c())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6c(src)

/obj/item/storage/belt/gun/m6/full_m6g/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6g())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6g(src)

/obj/item/storage/belt/gun/m6/full_m6c/m4a/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6c/m4a())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6c(src)

/obj/item/storage/belt/gun/m6/full_m6a/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6a())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6a(src)

/obj/item/storage/belt/gun/m6/full_m6d/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6d())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6d(src)

//========== SPECIAL BELTS ==========

/obj/item/storage/belt/gun/m7
	name = "\improper M7 holster rig"
	desc = "Special issue M7 holster rig, uncommonly issued to UNSC support and specialist personnel as a PDW."
	icon = 'icons/halo/obj/items/clothing/belts/belts_by_faction/belt_unsc.dmi'
	icon_state = "m7_holster"
	item_state = "s_marinebelt"
	storage_slots = 3
	max_w_class = 6
	can_hold = list(
		/obj/item/weapon/gun/smg/halo/m7,
		/obj/item/ammo_magazine/smg/halo/m7,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = 0,
			"icon_y" = 0))
	item_icons = list(
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/belts/belts_by_faction/belt_unsc.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi')

	bypass_w_limit = list(
		/obj/item/weapon/gun/smg/halo/m7,
	)

/obj/item/storage/belt/gun/m7/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/halo/m7/folded_up())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/smg/halo/m7(src)

/obj/item/storage/belt/gun/m7/full/socom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/halo/m7/socom/folded_up())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/smg/halo/m7(src)
//========== POUCHES ==========

/obj/item/storage/pouch/pistol/unsc
	name = "\improper M6 pistol holster"
	icon = 'icons/halo/obj/items/clothing/pouches.dmi'
	icon_state = "m6"
	icon_x = 5
	icon_y = 0
	can_hold = list(
		/obj/item/weapon/gun/pistol/halo,
		/obj/item/ammo_magazine/pistol/halo,
	)

/obj/item/storage/pouch/magazine/pistol/unsc
	name = "pistol magazine pouch"
	icon = 'icons/halo/obj/items/clothing/pouches.dmi'
	icon_state = "pistolmag"
	can_hold = list(/obj/item/ammo_magazine/pistol/halo)

/obj/item/storage/pouch/magazine/pistol/unsc/large
	name = "large pistol magazine pouch"
	icon_state = "pistolmag_large"
	storage_slots = 6

//========== BACKPACKS ==========

/obj/item/storage/backpack/marine/satchel/rto/unsc
	name = "UNSC radio backpack"
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "radiopack"
	item_state = "radiopack"
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	networks_receive = list(FACTION_MARINE)
	networks_transmit = list(FACTION_MARINE)
	phone_category = PHONE_MARINE
	flags_atom = FPRINT|NO_GAMEMODE_SKIN

/obj/item/storage/backpack/marine/satchel/unsc
	name = "UNSC buttpack"
	desc = "A standard-issue buttpack for the infantry of the UNSC."
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "buttpack"
	item_state = "buttpack"
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	flags_atom = FPRINT|NO_GAMEMODE_SKIN

/obj/item/storage/backpack/marine/unsc
	name = "UNSC rucksack"
	desc = "A large tan rucksack that attaches directly to the M52B armor's attachment points. Standard issue, used by just about every UNSC branch since the 25th century."
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "rucksack"
	item_state = "rucksack"
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	flags_atom = FPRINT|NO_GAMEMODE_SKIN

/obj/item/storage/backpack/marine/ammo_rack/spnkr
	name = "SPNKr tube storage backpack"
	desc = "Two individual cloth bags, each capable of storing one M19 twin-tube unit for the M41 SPNKr."
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "spnkrpack_0"
	base_icon_state = "spnkrpack"
	item_state = "spnkrpack"
	storage_slots = 2
	can_hold = list(/obj/item/ammo_magazine/spnkr)
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	flags_atom = FPRINT|NO_GAMEMODE_SKIN
	bypass_w_limit = list(/obj/item/ammo_magazine/spnkr)

/obj/item/storage/backpack/marine/ammo_rack/spnkr/filled/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/spnkr(src)
	update_icon()

//========== BOXES ==========

/obj/item/storage/unsc_speckit
	name = "UNSC specialist kit box"
	desc = "An unlabeled, unmarked specialist equipment box. You can only wonder as to what the contents are."
	icon = 'icons/halo/obj/items/storage/spec_kits.dmi'
	icon_state = "template"
	var/open_state = "template_o"
	var/icon_full = "template" //icon state to use when kit is full
	var/possible_icons_full
	can_hold = list()
	max_w_class = SIZE_MASSIVE
	storage_flags = STORAGE_FLAGS_BOX

/obj/item/storage/unsc_speckit/Initialize()
	. = ..()

	if(possible_icons_full)
		icon_full = pick(possible_icons_full)
	else
		icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/unsc_speckit/update_icon()
	if(content_watchers || !length(contents))
		icon_state = open_state
	else
		icon_state = icon_full

/obj/item/storage/unsc_speckit/attack_self(mob/living/user)
	..()

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.swap_hand()
		open(user)

/obj/item/storage/unsc_speckit/spnkr
	name = "SPNKr equipment case"
	desc = "A case containing the essentials for a UNSC weapons specialist. This one has the emblem of a SPNKr on its lid."
	icon_state = "spnkr"
	open_state = "spnkr_o"
	icon_full = "spnkr"
	can_hold = list(/obj/item/ammo_magazine/spnkr, /obj/item/storage/backpack/marine/ammo_rack/spnkr, /obj/item/weapon/gun/halo_launcher/spnkr)
	storage_slots = 5

/obj/item/storage/unsc_speckit/spnkr/fill_preset_inventory()
	new /obj/item/ammo_magazine/spnkr(src)
	new /obj/item/ammo_magazine/spnkr(src)
	new /obj/item/ammo_magazine/spnkr(src)
	new /obj/item/storage/backpack/marine/ammo_rack/spnkr(src)
	new /obj/item/weapon/gun/halo_launcher/spnkr/unloaded(src)

/obj/item/storage/unsc_speckit/srs99
	name = "SRS99-AM equipment case"
	desc = "A case containing the essentials for a UNSC weapons specialist. This one has the emblem of an SRS99-AM on its lid."
	icon_state = "srs99"
	open_state = "srs99_o"
	icon_full = "srs99"
	can_hold = list(/obj/item/weapon/gun/rifle/sniper/halo/unloaded, /obj/item/ammo_magazine/rifle/halo/sniper)
	storage_slots = 7

/obj/item/storage/unsc_speckit/srs99/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/sniper/halo/unloaded(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/device/helmet_visor/night_vision/sniper(src)


/obj/structure/magazine_box/unsc
	icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base"
	text_markings_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/text.dmi'
	magazines_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/magazines.dmi'



//-----------------------Halo Boxes-----------------------

/obj/item/ammo_box/magazine/misc/unsc
	name = "\improper UNSC storage crate"
	desc = "A generic storage crate for the UNSC. Looks like it holds...nothing? You shouldn't be seeing this..."
	icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	magazines_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	icon_state = "base"
	magazine_type = null
	limit_per_tile = 1
	num_of_magazines = 0
	overlay_content = null
	deployed_object = /obj/structure/magazine_box/unsc

/obj/item/ammo_box/magazine/misc/unsc/mre
	name = "\improper UNSC storage crate - (MRE x 14)"
	desc = "A generic storage crate for the UNSC holding MREs."
	icon_state = "base_mre"
	magazine_type = /obj/item/storage/box/mre
	num_of_magazines = 14
	overlay_content = "_mre"

/obj/item/ammo_box/magazine/misc/unsc/mre/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/flare
	name = "\improper UNSC storage crate  (Flares x 14)"
	desc = "A generic storage crate for the UNSC holding flares."
	icon_state = "base_flare"
	magazine_type = /obj/item/storage/box/m94
	num_of_magazines = 14
	overlay_content = "_flare"

/obj/item/ammo_box/magazine/misc/unsc/flare/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/flare/signal
	name = "\improper UNSC storage crate - (Signal Flares x 14)"
	desc = "A generic storage crate for the UNSC holding signal flares."
	icon_state = "base_flare"
	magazine_type = /obj/item/storage/box/m94/signal
	num_of_magazines = 14
	overlay_content = "_signal"

/obj/item/ammo_box/magazine/misc/unsc/flare/signal/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/grenade
	name = "\improper UNSC storage crate - (Grenades x 9)"
	desc = "A generic storage crate for the UNSC holding fragmentation grenades."
	icon_state = "base_frag"
	magazine_type = /obj/item/explosive/grenade/high_explosive/unsc
	num_of_magazines = 9
	overlay_content = "_frag"

/obj/item/ammo_box/magazine/misc/unsc/grenade/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/grenade/launchable
	name = "\improper UNSC storage crate - (40mm Grenades x 30)"
	desc = "A generic storage crate for the UNSC holding 40MM grenades."
	icon_state = "base_40mm"
	magazine_type = /obj/item/explosive/grenade/high_explosive/unsc/launchable
	num_of_magazines = 30
	overlay_content = "_40mm"

/obj/item/ammo_box/magazine/misc/unsc/grenade/launchable/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/medical_packets
	name = "\improper UNSC storage crate - (First Aid Packets x 10)"
	desc = "A generic storage crate for the UNSC holding MREs."
	icon_state = "base_medpack"
	magazine_type = /obj/item/storage/box/tear_packet/medical_packet
	num_of_magazines = 10
	overlay_content = "_medpack"

/obj/item/ammo_box/magazine/misc/unsc/medical_packets/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/m7_ammo
	name = "UNSC storage crate - (M7 Magazine Packets x 16)"
	desc = "A generic UNSC storage crate for holding M7 magazine packets."
	magazine_type = /obj/item/storage/box/tear_packet/m7
	num_of_magazines = 16
	overlay_content = "_riflepack"

/obj/item/ammo_box/magazine/misc/unsc/m7_ammo/empty
	empty = TRUE

//-----------------------Halo Mag Box-----------------------

/obj/item/ammo_box/magazine/unsc
	name = "UNSC magazine box"
	desc = "A generic ammo box for UNSC weapons."
	icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base_ammo"
	magazines_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	text_markings_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/text.dmi'
	limit_per_tile = 1
	deployed_object = /obj/structure/magazine_box/unsc

/obj/item/ammo_box/magazine/unsc/ma5c
	name = "UNSC magazine box (MA5C x 48)"
	desc = "An ammo box storing 48 magazines of MA5C ammunition"
	icon_state = "base_ammo"
	overlay_gun_type = "_ma5c"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/ma5c
	num_of_magazines = 48

/obj/item/ammo_box/magazine/unsc/ma5c/shredder
	name = "UNSC magazine box (MA5C x 24, AP shredder)"
	desc = "An ammo box storing 24 magazines of MA5C ammunition"
	overlay_ammo_type = "_shred"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/ma5c/shredder
	num_of_magazines = 24

/obj/item/ammo_box/magazine/unsc/ma5b
	name = "UNSC magazine box (MA5B x 48)"
	desc = "An ammo box storing 48 magazines of MA5B ammunition"
	icon_state = "base_ammo3"
	overlay_gun_type = "_ma5b"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/ma5b
	num_of_magazines = 48

/obj/item/ammo_box/magazine/unsc/ma5b/shredder
	name = "UNSC magazine box (MA5B x 48)"
	desc = "An ammo box storing 48 magazines of MA5B ammunition"
	overlay_ammo_type = "_shred"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/ma5b/shredder
	num_of_magazines = 24

/obj/item/ammo_box/magazine/unsc/br55
	name = "UNSC magazine box (BR55 x 32)"
	desc = "An ammo box storing 32 magazines of BR55 ammunition"
	icon_state = "base_ammo2"
	overlay_gun_type = "_br55"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/br55
	num_of_magazines = 32

/obj/item/ammo_box/magazine/unsc/br55/extended
	name = "UNSC magazine box (BR55 x 32, extended)"
	desc = "An ammo box storing 32 magazines of BR55 ammunition"
	overlay_ammo_type = "_ext"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/br55/extended

/obj/item/ammo_box/magazine/unsc/small
	name = "UNSC magazine box"
	icon_state = "base_ammosmall"
	limit_per_tile = 2
	overlay_gun_type = null
	overlay_content = "_small"

/obj/item/ammo_box/magazine/unsc/small/m6c
	name = "UNSC magazine box (M6C x 22)"
	desc = "An ammo box storing 22 magazines of M6C ammunition."
	icon_state = "base_ammosmall"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6c
	num_of_magazines = 22

/obj/item/ammo_box/magazine/unsc/small/m6c/socom
	name = "UNSC magazine box (M6C/SOCOM x 22)"
	desc = "An ammo box storing 22 magazines of M6C/SOCOM ammunition."
	icon_state = "base_ammosmall4"
	overlay_ammo_type = "_extsmall"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6c/socom

/obj/item/ammo_box/magazine/unsc/small/m6g
	name = "UNSC magazine box (M6G x 22)"
	desc = "An ammo box storing 22 magazines of M6G ammunition."
	icon_state = "base_ammosmall2"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6g
	num_of_magazines = 22

/obj/item/ammo_box/magazine/unsc/small/m6d
	name = "UNSC magazine box (M6D x 22)"
	desc = "An ammo box storing 22 magazines of M6D ammunition."
	icon_state = "base_ammosmall3"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6d
	num_of_magazines = 22

//===========================//CUSTOM ARMOR WEBBING\\================================\\

/obj/item/clothing/accessory/storage/webbing/m52b
	name = "\improper M52B Pattern Webbing"
	desc = "A sturdy mess of synthcotton belts and buckles designed to attach to the M52B body armor armor standard for the UNSC. This one is the slimmed down model designed for general purpose storage."
	icon = 'icons/halo/obj/items/clothing/accessories/accessories.dmi'
	icon_state = "m52b_webbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3generic
	worn_accessory_slot = ACCESSORY_SLOT_M3UTILITY
	flags_atom = NO_GAMEMODE_SKIN
	accessory_icons = list(WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi', WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi')

/obj/item/clothing/accessory/storage/webbing/m52b/Initialize(mapload)
	. = ..()


/obj/item/storage/internal/accessory/webbing/m3generic
	cant_hold = list(
		/obj/item/ammo_magazine/handful/shotgun,
		/obj/item/ammo_magazine/rifle,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/mag
	name = "\improper M52B Pattern Magazine Webbing"
	desc = "A variant of the M52B pattern webbing that features pouches for pulse rifle magazines."
	icon_state = "m52b_magwebbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag

/obj/item/storage/internal/accessory/webbing/m3mag
	storage_slots = 3
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
	)

//Partial Pre-load For Props

/obj/item/clothing/accessory/storage/webbing/m52b/mag/ma5c
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/ma5c

/obj/item/storage/internal/accessory/webbing/m3mag/ma5c/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)

//===

/obj/item/clothing/accessory/storage/webbing/m52b/shotgun
	name = "\improper M52B Pattern Shell Webbing"
	desc = "A slightly modified variant of the M52B pattern webbing, fitted for 12 gauge shotgun shells."
	icon_state = "m52b_shotgunwebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3shotgun

/obj/item/storage/internal/accessory/black_vest/m3shotgun
	can_hold = list(
		/obj/item/ammo_magazine/handful,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/small
	name = "\improper M52B Pattern Small Pouch Webbing"
	desc = "A set of M52B pattern webbing fully outfitted with pouches and pockets to carry a while array of small items."
	icon_state = "m52b_smallwebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic
	worn_accessory_slot = ACCESSORY_SLOT_M3UTILITY

/obj/item/storage/internal/accessory/black_vest/m3generic
	cant_hold = list(
		/obj/item/ammo_magazine/handful/shotgun,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/grenade
	name = "\improper M52B Pattern Grenade Webbing"
	desc = "A variation of the M52B pattern webbing fitted with loops for storing M40 grenades."
	icon_state = "m52b_grenadewebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3grenade

/obj/item/storage/internal/accessory/black_vest/m3grenade
	storage_slots = 5
	can_hold = list(
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/slug/baton,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/grenade/m9_frag
	hold = /obj/item/storage/internal/accessory/black_vest/m3grenade/unsc

/obj/item/storage/internal/accessory/black_vest/m3grenade/unsc/fill_preset_inventory()
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)

/obj/item/clothing/accessory/storage/webbing/m52b/recon
	name = "\improper M52B-R Pattern Magazine Webbing"
	desc = "A set of magazine webbing made in an alternative configuration for standard M3 Pattern armor. This one is exclusively issued to Force Reconnoissance units."
	icon_state = "m52b_r_webbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/recon

/obj/item/storage/internal/accessory/webbing/m3mag/recon
	storage_slots = 4

//===========================//CUSTOM ARMOR COSMETIC PLATES\\================================\\

/obj/item/clothing/accessory/pads
	name = "\improper M52B Shoulder Pads"
	desc = "A set shoulder pads attachable to the M52B armor set worn by the UNSC."
	icon = 'icons/halo/obj/items/clothing/accessories/accessories.dmi'
	icon_state = "pads"
	item_state = "pads"
	worn_accessory_slot = ACCESSORY_SLOT_DECORARMOR
	flags_atom = NO_GAMEMODE_SKIN
	accessory_icons = list(WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi', WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi')

/obj/item/clothing/accessory/pads/Initialize(mapload)
	. = ..()

/obj/item/clothing/accessory/pads/bracers
	name = "\improper M52B Arm Bracers"
	desc = "A set arm bracers worn in conjunction to the M52B body armor of the UNSC."
	icon_state = "bracers"
	item_state = "bracers"
	worn_accessory_slot = ACCESSORY_SLOT_DECORBRACER
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/bracers/police
	name = "\improper Police Shoulder Bracers"
	desc = "A set arm bracers worn in conjunction to an armoured vest, commonly issued to Police forces."
	icon_state = "bracers_police"
	item_state = "bracers_police"

/obj/item/clothing/accessory/pads/neckguard
	name = "\improper M52B Neck Guard"
	desc = "An attachable neck guard option for the M52B body armor worn by the UNSC."
	icon_state = "neckguard"
	item_state = "neckguard"
	worn_accessory_slot = ACCESSORY_SLOT_DECORNECK
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/neckguard/police
	name = "\improper Police Neck Guard"
	desc = "An attachable neck guard option for basic ballistic vests, commonly issued to the Police."
	icon_state = "neckguard_police"
	item_state = "neckguard_police"

/obj/item/clothing/accessory/pads/greaves
	name = "\improper M52B Shin Guards"
	desc = "A set shinguards designed to be worn in conjuction with M52B body armor."
	icon_state = "shinguards"
	item_state = "shinguards"
	worn_accessory_slot = ACCESSORY_SLOT_DECORSHIN
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/groin
	name = "\improper M52B Groin Plate"
	desc = "A plate designed to attach to M52B body armor to protect the babymakers of the Corps. Standardized protection of the UNSC often seen worn more often than not."
	icon_state = "groinplate"
	item_state = "groinplate"
	worn_accessory_slot = ACCESSORY_SLOT_DECORGROIN
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/groin/police
	name = "\improper Police Groin Plate"
	desc = "A plate designed to attach to an armoured Vest to protect the babymakers. Most commonly attached to Police Vests."
	icon_state = "groinplate_police"
	item_state = "groinplate_police"

/obj/item/clothing/accessory/pads/odst
	name = "\improper M70DT Shoulder Pads"
	desc = "A set shoulder pads attachable to the M70DT armor set worn by the ODSTs."
	icon_state = "odst_pads"
	item_state = "odst_pads"

/obj/item/clothing/accessory/pads/bracers/odst
	name = "\improper M70DT Bracers"
	desc = "A set arm bracers worn in conjunction to the M70DT body armor of the ODSTs."
	icon_state = "odst_bracers"
	item_state = "odst_bracers"

/obj/item/clothing/accessory/pads/greaves/odst
	name = "\improper M70DT Greaves"
	desc = "A set greaves designed to be worn in conjuction with M70DT body armor."
	icon_state = "odst_shinguards"
	item_state = "odst_shinguards"

/obj/item/clothing/accessory/pads/groin/odst
	name = "\improper M70DT Groin Plate"
	desc = "A plate designed to attach to M70DT body armor to protect the babymakers of the Corps. Standardized protection of the ODSTs often seen worn more often than not."
	icon_state = "odst_groinplate"
	item_state = "odst_groinplate"


/obj/item/clothing/under/marine/odst
	name = "ODST bodyglove"
	icon = 'icons/halo/obj/items/clothing/undersuit.dmi'
	icon_state = "odst"
	worn_state = "odst"
	flags_jumpsuit = null
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/uniforms.dmi')

/obj/item/clothing/suit/marine/unsc
	name = "\improper M52B body armor"
	desc = "Standard-issue to the UNSC Marine Corps, the M52B armor entered service by 2531 for use in the Human Covenant war, coming with improved protection against plasma-based projectiles compared to older models."
	icon = 'icons/halo/obj/items/clothing/suits/suits_by_faction/suit_unsc.dmi'
	icon_state = "m52b"
	item_state = "m52b"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_bodypart_hidden = BODY_FLAG_CHEST
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	siemens_coefficient = 0.7
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/suits/suits_by_faction/suit_unsc.dmi')
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/prop/prop_gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/type47,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/gun/m39,
		/obj/item/storage/belt/gun/xm51,
		/obj/item/storage/belt/gun/m6,
		/obj/item/storage/belt/gun/m7,
		/obj/item/weapon/gun/halo_launcher/spnkr
	)

/obj/item/clothing/suit/marine/unsc/police
	name = "\improper police RD90 ballistic armor"
	desc = "An older model of the M52B body armor, designated as the RD90 by local police and security forces. Whilst not as comfortable, it still does the job for most of it's users, and has added protection against melee attacks."
	icon = 'icons/halo/obj/items/clothing/suits/suits_by_faction/suit_unsc.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)
	icon_state = "police"
	item_state = "police"
	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/suits/suits_by_faction/suit_unsc.dmi')
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/suit/marine/unsc/odst
	name = "\improper M70DT ODST BDU"
	desc = "The sum total of the ODST's armour complex, simply called 'Battle-Dress-Uniform'. Designed for several environments, be it in vacuum with its 30 minutes of air, in the racket of a SOEIV or the clamour of a battlefield; this BDU is ready for it all. Consists of heat-dispersing and vacuum rated body glove, and the armour worn over it, which reflects heat and bullets quite well. Do not test shock absorption for recreation."
	icon_state = "odst"
	item_state = "odst"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/head/helmet/marine/unsc
	name = "\improper CH252 helmet"
	desc = "Standard-issue helmet to the UNSC Marine Corps. Various attachment points on the helmet allow for various equipment to be fitted to the helmet."
	icon = 'icons/halo/obj/items/clothing/hats/hats_by_faction/hat_unsc.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	built_in_visors = null
	start_down_visor_type = null
	item_icons = list(
		WEAR_HEAD = 'icons/halo/mob/humans/onmob/clothing/hats/hats_by_faction/hat_unsc.dmi'
	)

/obj/item/clothing/head/helmet/marine/unsc/Initialize()
	..()
	var/obj/item/attachable/flashlight/light = new /obj/item/attachable/flashlight
	light.forceMove(pockets)
	light.attached_item = src
	light.turn_light(toggle_on = TRUE, forced = TRUE)

/obj/item/clothing/head/helmet/marine/unsc/pilot
	name = "\improper FH252 helmet"
	desc = "The typical helmet found used by most UNSC pilots due to it's fully enclosed nature, particularly preferred by pilots in combat situations where their cockpit may end up breached."
	icon_state = "pilot"
	item_state = "pilot"
	flags_atom = ALLOWINTERNALS|NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE|BLOCKGASEFFECT|ALLOWREBREATH|ALLOWCPR

/obj/item/clothing/head/helmet/marine/unsc/police
	name = "\improper police CH252 helmet"
	desc = "Standard-issue helmet to the UNSC Marine Corps, this one given to the local police and security forces across the colonies for riot suppression during the days of the insurrection."
	icon_state = "police"
	item_state = "police"


/obj/item/clothing/head/helmet/marine/unsc/odst
	name = "\improper CH381 ODST helmet"
	desc = "An iconic helmet, designed for use by Orbital-Drop-Shock-Troopers of the UNSC's Marine Corps' Special Forces. An advanced piece of equipment featuring various benefits: a polarizing visor, VISR optical software, reinforced COM unit, fully sealed environment and a nice black finish. Commonly defaced with crude graffiti by bored helljumpers."
	icon_state = "odst"
	item_state = "odst"
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/glasses/sunglasses/big/unsc
	name = "\improper UNSC shooting shades"
	desc = "A pair of standard-issue shades. Some models come with an in-built HUD system, this one evidently does not."
	icon = 'icons/halo/obj/items/clothing/glasses/glasses.dmi'
	icon_state = "hudglasses"
	item_state = "hudglasses"
	item_icons = list(
		WEAR_EYES = 'icons/halo/mob/humans/onmob/clothing/eyes.dmi',
		WEAR_FACE = 'icons/halo/mob/humans/onmob/clothing/eyes.dmi'
		)

//---------UNSC---------

/obj/item/storage/firstaid/unsc
	name = "UNSC health pack"
	desc = "First-class military medical aid is typically found in these octogon-shaped health packs."
	icon = 'icons/halo/obj/items/storage/medical.dmi'
	icon_state = "healthpack"
	empty_icon = "healthpack_empty"
	has_overlays = FALSE
	storage_slots = 8

/obj/item/storage/firstaid/unsc/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)

/obj/item/storage/firstaid/unsc/corpsman/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)

/obj/item/storage/box/tear_packet
	name = "packet"
	desc = "A plastic packet."
	icon = 'icons/halo/obj/items/storage/packets.dmi'
	icon_state = "ammo_packet"
	w_class = SIZE_SMALL
	can_hold = list()
	storage_slots = 3
	use_sound = "rip"
	var/isopened = FALSE

/obj/item/storage/box/tear_packet/m7
	name = "magazine packet (M7, x2)"
	storage_slots = 2

/obj/item/storage/box/tear_packet/m7/fill_preset_inventory()
	new /obj/item/ammo_magazine/smg/halo/m7(src)
	new /obj/item/ammo_magazine/smg/halo/m7(src)

/obj/item/storage/box/tear_packet/Initialize()
	. = ..()
	isopened = FALSE
	icon_state = "[initial(icon_state)]"
	use_sound = "rip"

/obj/item/storage/box/tear_packet/update_icon()
	if(!isopened)
		isopened = TRUE
		icon_state = "[initial(icon_state)]_o"
		use_sound = "rustle"

/obj/item/storage/box/tear_packet/medical_packet
	name = "UNSC medical packet"
	desc = "A combat-rated first aid medical packet filled with the bare bones basic essentials to ensuring you or your buddies don't die on the battlefield."
	icon_state = "medical_packet"
	storage_slots = 5
	max_w_class = 3
	can_hold = list(
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/splint,
		/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless,
	)

/obj/item/storage/box/tear_packet/medical_packet/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)
