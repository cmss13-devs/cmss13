GLOBAL_LIST_EMPTY(gear_datums_by_category)

GLOBAL_LIST_EMPTY_TYPED(gear_datums_by_name, /datum/gear)
GLOBAL_LIST_EMPTY_TYPED(gear_datums_by_type, /datum/gear)

GLOBAL_LIST_EMPTY(roles_with_gear)

/proc/populate_gear_list()
	var/datum/gear/G
	for(var/gear_type in subtypesof(/datum/gear))
		G = new gear_type()
		if(!G.path)
			continue //Skipping parent types that are not actual items.
		if(!G.display_name)
			G.display_name = capitalize(strip_improper(G.path::name))
		if(!G.category)
			log_debug("Improper gear datum: [gear_type].")
			continue
		LAZYADD(GLOB.gear_datums_by_category[G.category], G)
		GLOB.gear_datums_by_type[G.type] = G

		// it's okay if this gets clobbered by duplicate names, it's just used for a best guess to convert old names to types
		GLOB.gear_datums_by_name[G.display_name] = G

		if(G.allowed_roles)
			for(var/allowed_role in G.allowed_roles)
				GLOB.roles_with_gear |= allowed_role

/datum/gear

	/// Overrides the display name
	var/display_name

	/// Used for sorting in the loadout selection.
	var/category

	/// Path to item.
	var/obj/item/path

	/// Number of job specific loadout points used.
	var/loadout_cost = 0

	/// Number of fluff points used.
	var/fluff_cost = 2

	/// Slot to equip to, if any.
	var/slot

	/// Roles that can spawn with this item.
	var/list/allowed_roles

	/// Origins that can sapwn with this item.
	var/list/allowed_origins

/// Returns a list with the various variables used to display this gear in a UI
/datum/gear/proc/get_list_representation()
	return list(
		"name" = display_name,
		"type" = type,
		"fluff_cost" = fluff_cost,
		"loadout_cost" = loadout_cost,

		"icon" = path::icon,
		"icon_state" = path::icon_state
	)

/// Attempt to wear this equipment, in the given slot if possible. If not, any slot is used.
/datum/gear/proc/equip_to_user(mob/living/carbon/human/user, override_checks = FALSE, drop_instead_of_del = TRUE)
	if(!override_checks && allowed_roles && !(user.job in allowed_roles))
		to_chat(user, SPAN_WARNING("Gear [display_name] cannot be equipped: Invalid Role"))
		return

	if(!override_checks && allowed_origins && !(user.origin in allowed_origins))
		to_chat(user, SPAN_WARNING("Gear [display_name] cannot be equipped: Invalid Origin"))
		return

	if(!(slot && user.equip_to_slot_or_del(new path, slot)))
		var/obj/equipping_gear = new path
		if(user.equip_to_appropriate_slot(equipping_gear))
			return

		if(user.equip_to_slot_if_possible(equipping_gear, WEAR_IN_BACK, disable_warning = TRUE))
			return

		if(drop_instead_of_del)
			equipping_gear.forceMove(get_turf(user))
			return

		qdel(equipping_gear)

/datum/gear/eyewear
	category = "Eyewear"
	slot = WEAR_EYES

/datum/gear/eyewear/goggles
	display_name = "Ballistic goggles"
	path = /obj/item/clothing/glasses/mgoggles

/datum/gear/eyewear/prescription_goggles
	display_name = "Prescription ballistic goggles"
	path = /obj/item/clothing/glasses/mgoggles/prescription

/datum/gear/eyewear/goggles_black
	display_name = "Ballistic goggles, black"
	path = /obj/item/clothing/glasses/mgoggles/black

/datum/gear/eyewear/goggles_orange
	display_name = "Ballistic goggles, orange"
	path = /obj/item/clothing/glasses/mgoggles/orange

/datum/gear/eyewear/goggles_red
	display_name = "Ballistic goggles, red"
	path = /obj/item/clothing/glasses/mgoggles/red

/datum/gear/eyewear/goggles_blue
	display_name = "Ballistic goggles, blue"
	path = /obj/item/clothing/glasses/mgoggles/blue

/datum/gear/eyewear/goggles_purple
	display_name = "Ballistic goggles, purple"
	path = /obj/item/clothing/glasses/mgoggles/purple

/datum/gear/eyewear/goggles_yellow
	display_name = "Ballistic goggles, yellow"
	path = /obj/item/clothing/glasses/mgoggles/yellow

/datum/gear/eyewear/goggles2
	display_name = "Ballistic goggles, M1A1"
	path = /obj/item/clothing/glasses/mgoggles/v2

/datum/gear/eyewear/goggles2/blue
	display_name = "Ballistic goggles, M1A1 blue"
	path = /obj/item/clothing/glasses/mgoggles/v2/blue

/datum/gear/eyewear/goggles2/polarized_blue
	display_name = "Polarized Ballistic goggles, M1A1 blue"
	path = /obj/item/clothing/glasses/mgoggles/v2/polarized_blue

/datum/gear/eyewear/goggles2/polarized_orange
	display_name = "Polarized Ballistic goggles, M1A1 orange"
	path = /obj/item/clothing/glasses/mgoggles/v2/polarized_orange

/datum/gear/eyewear/eyepatch
	display_name = "Eyepatch, black"
	path = /obj/item/clothing/glasses/eyepatch

/datum/gear/eyewear/eyepatch/white
	display_name = "Eyepatch, white"
	path = /obj/item/clothing/glasses/eyepatch/white

/datum/gear/eyewear/eyepatch/green
	display_name = "Eyepatch, green"
	path = /obj/item/clothing/glasses/eyepatch/green

/datum/gear/eyewear/rpg_glasses
	display_name = "Marine RPG Glasses"
	path = /obj/item/clothing/glasses/regular
	allowed_origins = USCM_ORIGINS

/datum/gear/eyewear/prescription_glasses
	display_name = "Prescription Glasses"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyewear/hippie_glasses
	display_name = "Rounded Prescription Glasses"
	path = /obj/item/clothing/glasses/regular/hippie

/datum/gear/eyewear/aviators
	display_name = "Aviator shades"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyewear/new_bimex/black
	display_name = "BiMex tactical shades, black"
	path = /obj/item/clothing/glasses/sunglasses/big/new_bimex/black
	fluff_cost = 4

/datum/gear/eyewear/new_bimex
	display_name = "BiMex polarized shades, yellow"
	path = /obj/item/clothing/glasses/sunglasses/big/new_bimex
	fluff_cost = 4

/datum/gear/eyewear/new_bimex/bronze
	display_name = "BiMex polarized shades, bronze"
	path = /obj/item/clothing/glasses/sunglasses/big/new_bimex/bronze
	fluff_cost = 4

/datum/gear/eyewear/prescription_sunglasses
	display_name = "Prescription sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/prescription

/datum/gear/eyewear/sunglasses
	display_name = "Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/mask
	category = "Masks and scarves"
	slot = WEAR_FACE

/datum/gear/mask/balaclava_black
	display_name = "Balaclava, black"
	path = /obj/item/clothing/mask/balaclava

/datum/gear/mask/balaclava_green
	display_name = "Balaclava, green"
	path = /obj/item/clothing/mask/balaclava/tactical

/datum/gear/mask/coif
	display_name = "Coif"
	path = /obj/item/clothing/mask/rebreather/scarf

/datum/gear/mask/face_wrap_black
	display_name = "Face wrap, black"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black

/datum/gear/mask/face_wrap_green
	display_name = "Face wrap, green"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green

/datum/gear/mask/face_wrap_grey
	display_name = "Face wrap, grey"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask

/datum/gear/mask/face_wrap_red
	display_name = "Face wrap, red"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/red

/datum/gear/mask/face_wrap_tan
	display_name = "Face wrap, tan"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan

/datum/gear/mask/face_wrap_squad
	display_name = "Face wrap, squad specific"
	path =/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad

/datum/gear/mask/gas
	display_name = "Gas mask"
	path = /obj/item/clothing/mask/gas

/datum/gear/mask/scarf_black
	display_name = "Scarf, black"
	path = /obj/item/clothing/mask/tornscarf/black

/datum/gear/mask/scarf_desert
	display_name = "Scarf, desert"
	path = /obj/item/clothing/mask/tornscarf/desert

/datum/gear/mask/scarf_green
	display_name = "Scarf, green"
	path = /obj/item/clothing/mask/tornscarf/green

/datum/gear/mask/scarf_grey
	display_name = "Scarf, grey"
	path = /obj/item/clothing/mask/tornscarf

/datum/gear/mask/scarf_urban
	display_name = "Scarf, urban"
	path = /obj/item/clothing/mask/tornscarf/urban

/datum/gear/mask/scarf_white
	display_name = "Scarf, white"
	path = /obj/item/clothing/mask/tornscarf/snow

/datum/gear/mask/neckerchief
	display_name = "Neckerchief, tan"
	path = /obj/item/clothing/mask/neckerchief

/datum/gear/mask/neckerchief/gray
	display_name = "Neckerchief, gray"
	path = /obj/item/clothing/mask/neckerchief/gray

/datum/gear/mask/neckerchief/green
	display_name = "Neckerchief, green"
	path = /obj/item/clothing/mask/neckerchief/green

/datum/gear/mask/neckerchief/black
	display_name = "Neckerchief, black"
	path = /obj/item/clothing/mask/neckerchief/black

/datum/gear/mask/neckerchief/squad
	display_name = "Neckerchief, squad specific"
	path = /obj/item/clothing/mask/neckerchief/squad

/datum/gear/mask/keffiyeh
	display_name = "Keffiyeh" // Traditional middle-eastern headdress, works like a balaclava/scarf.
	path = /obj/item/clothing/mask/rebreather/scarf/keffiyeh

/datum/gear/mask/keffiyeh_white
	display_name = "Keffiyeh, white"
	path = /obj/item/clothing/mask/rebreather/scarf/keffiyeh/white

/datum/gear/mask/keffiyeh_red
	display_name = "Keffiyeh, red"
	path = /obj/item/clothing/mask/rebreather/scarf/keffiyeh/red

/datum/gear/mask/keffiyeh_green
	display_name = "Keffiyeh, green"
	path = /obj/item/clothing/mask/rebreather/scarf/keffiyeh/green

/datum/gear/mask/keffiyeh_black
	display_name = "Keffiyeh, black"
	path = /obj/item/clothing/mask/rebreather/scarf/keffiyeh/black

/datum/gear/mask/keffiyeh_blue
	display_name = "Keffiyeh, blue"
	path = /obj/item/clothing/mask/rebreather/scarf/keffiyeh/blue

/datum/gear/mask/uscm
	allowed_origins = USCM_ORIGINS

/datum/gear/mask/uscm/balaclava_green
	display_name = "USCM balaclava, green"
	path = /obj/item/clothing/mask/rebreather/scarf/green

/datum/gear/mask/uscm/balaclava_grey
	display_name = "USCM balaclava, grey"
	path = /obj/item/clothing/mask/rebreather/scarf/gray

/datum/gear/mask/uscm/balaclava_tan
	display_name = "USCM balaclava, tan"
	path = /obj/item/clothing/mask/rebreather/scarf/tan

/datum/gear/mask/uscm/skull_balaclava_blue
	display_name = "USCM balaclava, blue skull"
	path = /obj/item/clothing/mask/rebreather/skull
	fluff_cost = 4 //same as skull facepaint
	slot = WEAR_FACE

/datum/gear/mask/uscm/skull_balaclava_black
	display_name = "USCM balaclava, black skull"
	path = /obj/item/clothing/mask/rebreather/skull/black
	fluff_cost = 4
	slot = WEAR_FACE

/datum/gear/headwear
	category = "Headwear"
	fluff_cost = 2
	slot = WEAR_HEAD

/datum/gear/headwear/durag_black
	display_name = "Durag, black"
	path = /obj/item/clothing/head/durag/black

/datum/gear/headwear/durag
	display_name = "Durag, mission specific"
	path = /obj/item/clothing/head/durag

/datum/gear/headwear/uscm
	allowed_origins = USCM_ORIGINS

/datum/gear/headwear/uscm/bandana_green
	display_name = "USCM bandana, green"
	path = /obj/item/clothing/head/cmbandana

/datum/gear/headwear/uscm/bandana_tan
	display_name = "USCM bandana, tan"
	path = /obj/item/clothing/head/cmbandana/tan

/datum/gear/headwear/uscm/beanie_grey
	display_name = "USCM beanie, grey"
	path = /obj/item/clothing/head/beanie/gray

/datum/gear/headwear/uscm/beanie_green
	display_name = "USCM beanie, green"
	path = /obj/item/clothing/head/beanie/green

/datum/gear/headwear/uscm/beanie_tan
	display_name = "USCM beanie, tan"
	path = /obj/item/clothing/head/beanie/tan

/datum/gear/headwear/uscm/beret_squad
	display_name = "USCM beret, squad specific"
	path = /obj/item/clothing/head/beret/cm/squadberet

/datum/gear/headwear/uscm/beret_green
	display_name = "USCM beret, green"
	path = /obj/item/clothing/head/beret/cm/green

/datum/gear/headwear/uscm/beret_tan
	display_name = "USCM beret, tan"
	path = /obj/item/clothing/head/beret/cm/tan

/datum/gear/headwear/uscm/beret_black
	display_name = "USCM beret, black"
	path = /obj/item/clothing/head/beret/cm/black

/datum/gear/headwear/uscm/beret_white
	display_name = "USCM beret, white"
	path = /obj/item/clothing/head/beret/cm/white

/datum/gear/headwear/uscm/boonie_olive
	display_name = "USCM boonie hat, olive"
	path = /obj/item/clothing/head/cmcap/boonie

/datum/gear/headwear/uscm/boonie_tan
	display_name = "USCM boonie hat, tan"
	path = /obj/item/clothing/head/cmcap/boonie/tan

/datum/gear/headwear/uscm/cap
	display_name = "USCM cap"
	path = /obj/item/clothing/head/cmcap

/datum/gear/headwear/uscm/headband_brown
	display_name = "USCM headband, brown"
	path = /obj/item/clothing/head/headband/brown

/datum/gear/headwear/uscm/headband_green
	display_name = "USCM headband, green"
	path = /obj/item/clothing/head/headband

/datum/gear/headwear/uscm/headband_grey
	display_name = "USCM headband, grey"
	path = /obj/item/clothing/head/headband/gray

/datum/gear/headwear/uscm/headband_red
	display_name = "USCM headband, red"
	path = /obj/item/clothing/head/headband/red

/datum/gear/headwear/uscm/headband_tan
	display_name = "USCM headband, tan"
	path = /obj/item/clothing/head/headband/tan

/datum/gear/headwear/uscm/headband_squad
	display_name = "USCM headband, squad specific"
	path = /obj/item/clothing/head/headband/squad

/datum/gear/headwear/uscm/headset
	display_name = "USCM headset"
	path = /obj/item/clothing/head/headset

/datum/gear/helmet_garb
	category = "Helmet accessories"
	fluff_cost = 1

/datum/gear/helmet_garb/flair_initech
	display_name = "Flair, Initech"
	path = /obj/item/prop/helmetgarb/flair_initech

/datum/gear/helmet_garb/flair_io
	display_name = "Flair, Io"
	path = /obj/item/prop/helmetgarb/flair_io

/datum/gear/helmet_garb/flair_peace
	display_name = "Flair, Peace and Love"
	path = /obj/item/prop/helmetgarb/flair_peace

/datum/gear/helmet_garb/flair_uscm
	display_name = "Flair, USCM"
	path = /obj/item/prop/helmetgarb/flair_uscm

/datum/gear/helmet_garb/helmet_gasmask
	display_name = "M5 integrated gasmask"
	path = /obj/item/prop/helmetgarb/helmet_gasmask

/datum/gear/helmet_garb/gunoil
	display_name = "Gun oil"
	path = /obj/item/prop/helmetgarb/gunoil

/datum/gear/helmet_garb/netting
	display_name = "Helmet netting"
	path = /obj/item/prop/helmetgarb/netting

/datum/gear/helmet_garb/netting/desert
	display_name = "Desert Helmet netting"
	path = /obj/item/prop/helmetgarb/netting/desert

/datum/gear/helmet_garb/netting/jungle
	display_name = "Jungle Helmet netting"
	path = /obj/item/prop/helmetgarb/netting/jungle

/datum/gear/helmet_garb/netting/urban
	display_name = "Urban Helmet netting"
	path = /obj/item/prop/helmetgarb/netting/urban

/datum/gear/helmet_garb/lucky_feather
	display_name = "Lucky feather, red"
	path = /obj/item/prop/helmetgarb/lucky_feather

/datum/gear/helmet_garb/lucky_feather/yellow
	display_name = "Lucky feather, yellow"
	path = /obj/item/prop/helmetgarb/lucky_feather/yellow

/datum/gear/helmet_garb/lucky_feather/purple
	display_name = "Lucky feather, purple"
	path = /obj/item/prop/helmetgarb/lucky_feather/purple

/datum/gear/helmet_garb/lucky_feather/blue
	display_name = "Lucky feather, blue"
	path = /obj/item/prop/helmetgarb/lucky_feather/blue

/datum/gear/helmet_garb/broken_nvgs
	display_name = "Night vision goggles, broken"
	path = /obj/item/prop/helmetgarb/helmet_nvg/cosmetic

/datum/gear/helmet_garb/prescription_bottle
	display_name = "Prescription bottle"
	path = /obj/item/prop/helmetgarb/prescription_bottle

/datum/gear/helmet_garb/raincover
	display_name = "Rain cover"
	path = /obj/item/prop/helmetgarb/raincover

/datum/gear/helmet_garb/raincover/jungle
	display_name = "Jungle Rain cover"
	path = /obj/item/prop/helmetgarb/raincover/jungle

/datum/gear/helmet_garb/raincover/desert
	display_name = "Desert Rain cover"
	path = /obj/item/prop/helmetgarb/raincover/desert

/datum/gear/helmet_garb/raincover/urban
	display_name = "Urban Rain cover"
	path = /obj/item/prop/helmetgarb/raincover/urban

/datum/gear/helmet_garb/rabbits_foot
	display_name = "Rabbit's foot"
	path = /obj/item/prop/helmetgarb/rabbitsfoot

/datum/gear/helmet_garb/rosary
	display_name = "Rosary"
	path = /obj/item/prop/helmetgarb/rosary

/datum/gear/helmet_garb/spent_buck
	display_name = "Spent buckshot"
	path = /obj/item/prop/helmetgarb/spent_buckshot

/datum/gear/helmet_garb/spent_flechette
	display_name = "Spent flechette"
	path = /obj/item/prop/helmetgarb/spent_flech

/datum/gear/helmet_garb/spent_slugs
	display_name = "Spent slugs"
	path = /obj/item/prop/helmetgarb/spent_slug

/datum/gear/helmet_garb/cartridge
	display_name = "Cartridge"
	path = /obj/item/prop/helmetgarb/cartridge

/datum/gear/helmet_garb/spacejam_tickets
	display_name = "Tickets to Space Jam"
	path = /obj/item/prop/helmetgarb/spacejam_tickets

/datum/gear/helmet_garb/trimmed_wire
	display_name = "Trimmed barbed wire"
	path = /obj/item/prop/helmetgarb/trimmed_wire

/datum/gear/helmet_garb/bullet_pipe
	display_name = "10x99mm XM43E1 casing pipe"
	path = /obj/item/prop/helmetgarb/bullet_pipe
	allowed_origins = USCM_ORIGINS

/datum/gear/helmet_garb/chaplain_patch
	display_name = "USCM chaplain helmet patch"
	path = /obj/item/prop/helmetgarb/chaplain_patch
	allowed_origins = USCM_ORIGINS

/datum/gear/paperwork
	category = "Paperwork"
	fluff_cost = 1

/datum/gear/paperwork/pen
	display_name = "Pen, black"
	path = /obj/item/tool/pen

/datum/gear/paperwork/pen_blue
	display_name = "Pen, blue"
	path = /obj/item/tool/pen/blue

/datum/gear/paperwork/pen_green
	display_name = "Pen, green"
	path = /obj/item/tool/pen/green

/datum/gear/paperwork/pen_red
	display_name = "Pen, red"
	path = /obj/item/tool/pen/red

/datum/gear/paperwork/pen_fountain
	display_name = "Pen, fountain"
	path = /obj/item/tool/pen/multicolor/fountain
	fluff_cost = 2

/datum/gear/paperwork/paper
	display_name = "Sheet of paper"
	path = /obj/item/paper
	fluff_cost = 1

/datum/gear/paperwork/clipboard
	display_name = "Clipboard"
	path = /obj/item/clipboard

/datum/gear/paperwork/folder_black
	display_name = "Folder, black"
	path = /obj/item/folder/black

/datum/gear/paperwork/folder_blue
	display_name = "Folder, blue"
	path = /obj/item/folder/blue

/datum/gear/paperwork/folder_red
	display_name = "Folder, red"
	path = /obj/item/folder/red

/datum/gear/paperwork/folder_white
	display_name = "Folder, white"
	path = /obj/item/folder/white

/datum/gear/paperwork/folder_yellow
	display_name = "Folder, yellow"
	path = /obj/item/folder/yellow

/datum/gear/paperwork/notepad_black
	display_name = "Notepad, black"
	path = /obj/item/notepad/black

/datum/gear/paperwork/notepad_blue
	display_name = "Notepad, blue"
	path = /obj/item/notepad/blue

/datum/gear/paperwork/notepad_green
	display_name = "Notepad, green"
	path = /obj/item/notepad/green

/datum/gear/paperwork/notepad_red
	display_name = "Notepad, red"
	path = /obj/item/notepad/red

/datum/gear/toy
	category = "Recreational"
	fluff_cost = 1

/datum/gear/toy/camera
	display_name = "Camera"
	path = /obj/item/device/camera
	fluff_cost = 2

/datum/gear/toy/mags
	fluff_cost = 1

/datum/gear/toy/mags/magazine_dirty
	display_name = "Magazine"
	path = /obj/item/prop/magazine/dirty

/datum/gear/toy/mags/boots_magazine_one
	display_name = "Boots Issue No.117"
	path = /obj/item/prop/magazine/boots/n117

/datum/gear/toy/mags/boots_magazine_two
	display_name = "Boots Issue No.150"
	path = /obj/item/prop/magazine/boots/n150

/datum/gear/toy/mags/boot_magazine_three
	display_name = "Boots Issue No.160"
	path = /obj/item/prop/magazine/boots/n160

/datum/gear/toy/mags/boots_magazine_four
	display_name = "Boots Issue No.54"
	path = /obj/item/prop/magazine/boots/n054

/datum/gear/toy/mags/boots_magazine_five
	display_name = "Boots Issue No.55"
	path = /obj/item/prop/magazine/boots/n055

/datum/gear/toy/film
	display_name = "Camera film"
	path = /obj/item/device/camera_film
	fluff_cost = 1

/datum/gear/toy/card
	fluff_cost = 1

/datum/gear/toy/card/ace_of_spades
	display_name = "Card, ace of spades"
	path = /obj/item/toy/handcard/aceofspades

/datum/gear/toy/card/uno_reverse_red
	display_name = "Card, Uno Reverse - red"
	path = /obj/item/toy/handcard/uno_reverse_red

/datum/gear/toy/card/uno_reverse_blue
	display_name = "Card, Uno Reverse - blue"
	path = /obj/item/toy/handcard/uno_reverse_blue

/datum/gear/toy/card/uno_reverse_purple
	display_name = "Card, Uno Reverse - purple"
	path = /obj/item/toy/handcard/uno_reverse_purple

/datum/gear/toy/card/uno_reverse_yellow
	display_name = "Card, Uno Reverse - yellow"
	path = /obj/item/toy/handcard/uno_reverse_yellow

/datum/gear/toy/card/trading_card
	display_name = "Card, random WeyYu Trading"
	path = /obj/item/toy/trading_card

/datum/gear/toy/deck
	display_name = "Deck of cards, regular"
	path = /obj/item/toy/deck

/datum/gear/toy/deck/uno
	display_name = "Deck of cards, Uno"
	path = /obj/item/toy/deck/uno

/datum/gear/toy/trading_card
	display_name = "Trading Card Packet"
	path = /obj/item/storage/fancy/trading_card

/datum/gear/toy/d6
	display_name = "Die, 6 sides"
	path = /obj/item/toy/dice

/datum/gear/toy/d20
	display_name = "Die, 20 sides"
	path = /obj/item/toy/dice/d20

/datum/gear/toy/walkman
	display_name = "Walkman"
	path = /obj/item/device/walkman
	fluff_cost = 2

/datum/gear/toy/crayon
	display_name = "Crayon"
	path = /obj/item/toy/crayon/rainbow

/datum/gear/toy/pride
	display_name = "Box of Prideful Crayons"
	path = /obj/item/storage/box/pride

/datum/gear/weapon
	category = "Weapons"
	fluff_cost = 4

/datum/gear/weapon/type_80_bayonet
	display_name = "Type 80 Bayonet"
	path = /obj/item/attachable/bayonet/upp_replica

/datum/gear/weapon/antique_Bayonet
	display_name = "antique bayonet" // ancient bayonet - family heirloom perhaps
	path = /obj/item/attachable/bayonet/antique

/datum/gear/weapon/L5_Bayonet
	display_name = "L5 Bayonet"
	path = /obj/item/attachable/bayonet/rmc_replica

/datum/gear/weapon/custom_Bayonet
	display_name = "M5 'Raven's Claw' tactical bayonet" // custom style bayonet with variants, exclusive to loadout and unique. Name might need changing.
	path = /obj/item/attachable/bayonet/custom

/datum/gear/weapon/custom_Bayonet/red
	display_name = "M5 'Raven's Claw' tactical bayonet, red"
	path = /obj/item/attachable/bayonet/custom/red

/datum/gear/weapon/custom_Bayonet/blue
	display_name = "M5 'Raven's Claw' tactical bayonet, blue"
	path = /obj/item/attachable/bayonet/custom/blue

/datum/gear/weapon/custom_Bayonet/black
	display_name = "M5 'Raven's Claw' tactical bayonet, black"
	path = /obj/item/attachable/bayonet/custom/black

/datum/gear/weapon/tanto_Bayonet
	display_name = "T9 tactical bayonet" // TWE/CLF bayonet
	path = /obj/item/attachable/bayonet/tanto

/datum/gear/weapon/tanto_Bayonet/blue
	display_name = "T9 tactical bayonet, blue"
	path = /obj/item/attachable/bayonet/tanto/blue

/datum/gear/weapon/m8_cartridge_bayonet
	display_name = "M8 Cartridge Bayonet"
	path = /obj/item/storage/box/co2_knife

/datum/gear/weapon/clfpistol
	display_name = "D18 Holdout Pistol"
	path = /obj/item/storage/box/clf

/datum/gear/weapon/upppistol //ww2 war trophy luger
	display_name = "Type 73 Pistol"
	path = /obj/item/storage/box/upp
	slot = WEAR_IN_BACK
	fluff_cost = 4

/datum/gear/weapon/m4a3_custom
	display_name = "M4A3 Custom Pistol"
	path = /obj/item/weapon/gun/pistol/m4a3/custom
	allowed_origins = USCM_ORIGINS

/datum/gear/weapon/m44_custom_revolver
	display_name = "M44 Custom Revolver"
	path = /obj/item/weapon/gun/revolver/m44/custom
	allowed_origins = USCM_ORIGINS

/datum/gear/drink
	category = "Canned drinks"
	fluff_cost = 1

/datum/gear/drink/water
	display_name = "Bottled water"
	path = /obj/item/reagent_container/food/drinks/cans/waterbottle
	fluff_cost = 1

/datum/gear/drink/grape_juice
	display_name = "Grape juice"
	path = /obj/item/reagent_container/food/drinks/cans/grape_juice

/datum/gear/drink/lemon_lime
	display_name = "Lemon lime"
	path = /obj/item/reagent_container/food/drinks/cans/lemon_lime

/datum/gear/drink/iced_tea
	display_name = "Iced tea"
	path = /obj/item/reagent_container/food/drinks/cans/iced_tea

/datum/gear/drink/cola
	display_name = "Classic Cola"
	path = /obj/item/reagent_container/food/drinks/cans/classcola

/datum/gear/drink/mountain_wind
	display_name = "Mountain Wind"
	path = /obj/item/reagent_container/food/drinks/cans/space_mountain_wind

/datum/gear/drink/space_up
	display_name = "Space Up"
	path = /obj/item/reagent_container/food/drinks/cans/space_up

/datum/gear/drink/souto_classic
	display_name = "Classic Souto"
	path = /obj/item/reagent_container/food/drinks/cans/souto/classic

/datum/gear/drink/souto_diet
	display_name = "Diet Souto"
	path = /obj/item/reagent_container/food/drinks/cans/souto/diet/classic

/datum/gear/drink/boda
	display_name = "Boda Soda"
	path = /obj/item/reagent_container/food/drinks/cans/boda
	fluff_cost = 2 //Legally imported from UPP.

/datum/gear/drink/boda/plus
	display_name = "Boda Cola"
	path = /obj/item/reagent_container/food/drinks/cans/bodaplus

/datum/gear/drink/alcohol
	fluff_cost = 2 //Illegal in military.

/datum/gear/drink/alcohol/ale
	display_name = "Weyland-Yutani IPA Ale"
	path = /obj/item/reagent_container/food/drinks/cans/ale

/datum/gear/drink/alcohol/aspen
	display_name = "Weyland-Yutani Aspen Beer"
	path = /obj/item/reagent_container/food/drinks/cans/aspen

/datum/gear/drink/alcohol/beer
	display_name = "Weyland-Yutani Lite Beer"
	path = /obj/item/reagent_container/food/drinks/cans/beer

/datum/gear/drink/alcohol/loko
	display_name = "Thirteen Loko"
	path = /obj/item/reagent_container/food/drinks/cans/thirteenloko

/datum/gear/flask
	category = "Flasks"
	fluff_cost = 1

/datum/gear/flask/canteen
	display_name = "Canteen"
	path = /obj/item/reagent_container/food/drinks/flask/canteen

/datum/gear/flask/leather
	display_name = "Leather flask"
	path = /obj/item/reagent_container/food/drinks/flask/detflask

/datum/gear/flask/leather_black
	display_name = "Black leather flask"
	path = /obj/item/reagent_container/food/drinks/flask/barflask

/datum/gear/flask/metal
	display_name = "Metal flask"
	path = /obj/item/reagent_container/food/drinks/flask

/datum/gear/flask/uscm
	display_name = "USCM flask"
	path = /obj/item/reagent_container/food/drinks/flask/marine

/datum/gear/flask/vacuum
	display_name = "Vacuum flask"
	path = /obj/item/reagent_container/food/drinks/flask/vacuumflask

/datum/gear/flask/wy
	display_name = "WY flask"
	path = /obj/item/reagent_container/food/drinks/flask/weylandyutani

/datum/gear/snack_sweet
	category = "Food (sweets)"
	fluff_cost = 1

/datum/gear/snack_sweet/candy
	display_name = "Bar of candy"
	path = /obj/item/reagent_container/food/snacks/candy

/datum/gear/snack_sweet/chocolate
	display_name = "Bar of chocolate"
	path = /obj/item/reagent_container/food/snacks/chocolatebar

/datum/gear/snack_sweet/candy_apple
	display_name = "Candied apple"
	path = /obj/item/reagent_container/food/snacks/candiedapple

/datum/gear/snack_sweet/cookie
	display_name = "Cookie"
	path = /obj/item/reagent_container/food/snacks/cookie

/datum/gear/snack_sweet/fortune_cookie
	display_name = "Fortune cookie"
	path = /obj/item/reagent_container/food/snacks/fortunecookie/prefilled

/datum/gear/snack_sweet/donut_normal
	display_name = "Donut"
	path = /obj/item/reagent_container/food/snacks/donut/normal

/datum/gear/snack_sweet/donut_jelly
	display_name = "Jelly donut"
	path = /obj/item/reagent_container/food/snacks/donut/jelly

/datum/gear/snack_sweet/donut_cherry
	display_name = "Cherry donut"
	path = /obj/item/reagent_container/food/snacks/donut/cherryjelly

/datum/gear/snack_packaged
	category = "Food (packaged)"
	fluff_cost = 1

/datum/gear/snack_packaged/beef_jerky
	display_name = "Beef jerky"
	path = /obj/item/reagent_container/food/snacks/sosjerky

/datum/gear/snack_packaged/meat_bar
	display_name = "MEAT bar"
	path = /obj/item/reagent_container/food/snacks/eat_bar

/datum/gear/snack_packaged/kepler_crisps
	display_name = "Kepler Crisps"
	path = /obj/item/reagent_container/food/snacks/kepler_crisps

/datum/gear/snack_packaged/burrito
	display_name = "Packaged burrito"
	path = /obj/item/reagent_container/food/snacks/packaged_burrito

/datum/gear/snack_packaged/cheeseburger
	display_name = "Packaged cheeseburger"
	path = /obj/item/reagent_container/food/snacks/packaged_burger

/datum/gear/snack_packaged/hotdog
	display_name = "Packaged hotdog"
	path = /obj/item/reagent_container/food/snacks/packaged_hdogs

/datum/gear/snack_packaged/chips_pepper
	display_name = "W-Y Pepper Chips"
	path = /obj/item/reagent_container/food/snacks/wy_chips/pepper

/datum/gear/snack_grown
	category = "Food (healthy)"
	fluff_cost = 1

/datum/gear/snack_grown/apple
	display_name = "Apple"
	path = /obj/item/reagent_container/food/snacks/grown/apple

/datum/gear/snack_grown/carrot
	display_name = "Carrot"
	path = /obj/item/reagent_container/food/snacks/grown/carrot

/datum/gear/snack_grown/corn
	display_name = "Corn"
	path = /obj/item/reagent_container/food/snacks/grown/corn

/datum/gear/snack_grown/lemon
	display_name = "Lemon"
	path = /obj/item/reagent_container/food/snacks/grown/lemon

/datum/gear/snack_grown/lime
	display_name = "Lime"
	path = /obj/item/reagent_container/food/snacks/grown/lime

/datum/gear/snack_grown/orange
	display_name = "Orange"
	path = /obj/item/reagent_container/food/snacks/grown/orange

/datum/gear/snack_grown/potato
	display_name = "Potato"
	path = /obj/item/reagent_container/food/snacks/grown/potato

/datum/gear/smoking
	category = "Smoking"
	fluff_cost = 1

/datum/gear/smoking/cigarette
	display_name = "Cigarette"
	path = /obj/item/clothing/mask/cigarette
	fluff_cost = 1
	slot = WEAR_FACE

/datum/gear/smoking/cigarette/cigar_classic
	display_name = "Classic cigar"
	path = /obj/item/clothing/mask/cigarette/cigar/classic
	fluff_cost = 3

/datum/gear/smoking/cigarette/cigar_premium
	display_name = "Premium cigar"
	path = /obj/item/clothing/mask/cigarette/cigar
	fluff_cost = 2

/datum/gear/smoking/cigarette/tarbacks
	display_name = "Tarbacks case"
	path = /obj/item/storage/fancy/cigar/tarbacks
	fluff_cost = 6

/datum/gear/smoking/cigarette/tarbacktube
	display_name = "Tarback tube"
	path = /obj/item/storage/fancy/cigar/tarbacktube
	fluff_cost = 2

/datum/gear/smoking/pack_emerald_green
	display_name = "Pack Of Emerald Greens"
	path = /obj/item/storage/fancy/cigarettes/emeraldgreen

/datum/gear/smoking/pack_lucky_strikes
	display_name = "Pack Of Lucky Strikes"
	path = /obj/item/storage/fancy/cigarettes/lucky_strikes

/datum/gear/smoking/arcturian_ace
	display_name = "Pack Of Arcturian Ace"
	path = /obj/item/storage/fancy/cigarettes/arcturian_ace

/datum/gear/smoking/lady_finger
	display_name = "Pack Of Lady Fingers"
	path = /obj/item/storage/fancy/cigarettes/lady_finger

/datum/gear/smoking/lucky_strikes_4
	display_name = "Pack Of Lucky Strikes Mini"
	path = /obj/item/storage/fancy/cigarettes/lucky_strikes_4

/datum/gear/smoking/wypacket
	display_name = "Pack Of Weyland-Yutani Gold"
	path = /obj/item/storage/fancy/cigarettes/wypacket
	fluff_cost = 2

/datum/gear/smoking/spirit
	display_name = "Pack Of Turquoise American Spirit"
	path = /obj/item/storage/fancy/cigarettes/spirit

/datum/gear/smoking/yellow
	display_name = "Pack Of Yellow American Spirit"
	path = /obj/item/storage/fancy/cigarettes/spirit/yellow

/datum/gear/smoking/kpack
	display_name = "Pack Of Koorlander Gold"
	path = /obj/item/storage/fancy/cigarettes/kpack
	fluff_cost = 2

/datum/gear/smoking/weed_joint
	display_name = "Joint of space weed"
	path = /obj/item/clothing/mask/cigarette/weed
	fluff_cost = 2

/datum/gear/smoking/lighter
	display_name = "Lighter, cheap"
	path = /obj/item/tool/lighter/random
	fluff_cost = 1

/datum/gear/smoking/zippo
	display_name = "Lighter, zippo"
	path = /obj/item/tool/lighter/zippo

/datum/gear/smoking/zippo/black
	display_name = "Black lighter, zippo"
	path = /obj/item/tool/lighter/zippo/black

/datum/gear/smoking/zippo/gold
	display_name = "Golden lighter, zippo"
	path = /obj/item/tool/lighter/zippo/gold
	fluff_cost = 3

/datum/gear/smoking/zippo/executive
	display_name = "Weyland-Yutani executive Zippo lighter"
	path = /obj/item/tool/lighter/zippo/executive
	fluff_cost = 3

/datum/gear/smoking/zippo/blue
	display_name = "Blue lighter, zippo"
	path = /obj/item/tool/lighter/zippo/blue

/datum/gear/smoking/electronic_cigarette
	display_name = "Electronic cigarette"
	path = /obj/item/clothing/mask/electronic_cigarette

/datum/gear/smoking/electronic_cigarette/cigar
	display_name = "Electronic cigar"
	path = /obj/item/clothing/mask/electronic_cigarette/cigar

/datum/gear/misc
	category = "Miscellaneous"

/datum/gear/misc/facepaint_green
	display_name = "Facepaint, green"
	path = /obj/item/facepaint/green

/datum/gear/misc/facepaint_brown
	display_name = "Facepaint, brown"
	path = /obj/item/facepaint/brown

/datum/gear/misc/facepaint_black
	display_name = "Facepaint, black"
	path = /obj/item/facepaint/black

/datum/gear/misc/facepaint_skull
	display_name = "Facepaint, skull"
	path = /obj/item/facepaint/skull
	fluff_cost = 3

/datum/gear/misc/facepaint_body
	display_name = "Fullbody paint"
	path = /obj/item/facepaint/sniper
	fluff_cost = 4 //To match with the skull paint amount of point, gave this amount of point for the same reason of the skull facepaint (too cool for everyone to be able to constantly use)

/datum/gear/misc/jungle_boots
	display_name = "Jungle pattern combat boots"
	path = /obj/item/clothing/shoes/marine/jungle
	fluff_cost = 2

/datum/gear/misc/brown_boots
	display_name = "brown combat boots"
	path = /obj/item/clothing/shoes/marine/brown
	fluff_cost = 2

/datum/gear/misc/brown_gloves
	display_name = "brown combat gloves"
	path = /obj/item/clothing/gloves/marine/brown
	fluff_cost = 2

/datum/gear/misc/grey_boots
	display_name = "grey combat boots"
	path = /obj/item/clothing/shoes/marine/grey
	fluff_cost = 2

/datum/gear/misc/urban_boots
	display_name = "Urban pattern combat boots"
	path = /obj/item/clothing/shoes/marine/urban
	fluff_cost = 2

/datum/gear/misc/grey_gloves
	display_name = "grey combat gloves"
	path = /obj/item/clothing/gloves/marine/grey
	fluff_cost = 2

/datum/gear/misc/pdt_kit
	display_name = "PDT/L kit"
	path = /obj/item/storage/box/pdt_kit
	fluff_cost = 3

/datum/gear/misc/sunscreen_stick
	display_name = "USCM issue sunscreen"
	path = /obj/item/facepaint/sunscreen_stick
	fluff_cost = 1 //The cadmium poisoning pays for the discounted cost longterm
	allowed_origins = USCM_ORIGINS

/datum/gear/misc/dogtags
	display_name = "Attachable Dogtags"
	path = /obj/item/clothing/accessory/dogtags
	fluff_cost = 1
	slot = WEAR_IN_ACCESSORY
	allowed_origins = USCM_ORIGINS

/datum/gear/misc/patch_uscm
	display_name = "Falling Falcons shoulder patch, squad specific"
	path = /obj/item/clothing/accessory/patch/falcon/squad_main
	fluff_cost = 1
	slot = WEAR_IN_ACCESSORY
	allowed_origins = USCM_ORIGINS

/datum/gear/misc/patch_uscm/medic_patch
	display_name = "Field Medic shoulder patch"
	path = /obj/item/clothing/accessory/patch/medic_patch

/datum/gear/misc/family_photo
	display_name = "Family photo"
	path = /obj/item/prop/helmetgarb/family_photo
	fluff_cost = 1

/datum/gear/misc/compass
	display_name = "Compass"
	path = /obj/item/prop/helmetgarb/compass
	fluff_cost = 1

/datum/gear/misc/bug_spray
	display_name = "Bug spray"
	path = /obj/item/prop/helmetgarb/bug_spray
	fluff_cost = 1

/datum/gear/misc/straight_razor
	display_name = "Cut-throat razor"
	path = /obj/item/weapon/straight_razor
	fluff_cost = 2

/datum/gear/misc/watch
	display_name = "Cheap wrist watch"
	path = /obj/item/clothing/accessory/wrist/watch
	fluff_cost = 1 // Cheap and crappy

// Civilian only

/datum/gear/civilian
	category = "Civilian only (restricted)"
	allowed_origins = list(ORIGIN_CIVILIAN)

/datum/gear/civilian/patch
	display_name = "Weyland-Yutani shoulder patch, black"
	path = /obj/item/clothing/accessory/patch/wy
	fluff_cost = 1
	slot = WEAR_IN_ACCESSORY

/datum/gear/civilian/patch/wysquare
	display_name = "Weyland-Yutani shoulder patch"
	path = /obj/item/clothing/accessory/patch/wysquare

/datum/gear/civilian/patch/wy_white
	display_name = "Weyland-Yutani shoulder patch, white"
	path = /obj/item/clothing/accessory/patch/wy_white

/datum/gear/civilian/patch/wy_fury
	display_name = "Weyland-Yutani Fury '161' patch"
	path = /obj/item/clothing/accessory/patch/wyfury

/datum/gear/civilian/patch/twepatch
	display_name = "Three World Empire shoulder patch"
	path = /obj/item/clothing/accessory/patch/twe

/datum/gear/civilian/patch/cec
	display_name = "Cosmos Exploration Corps shoulder patch"
	path = /obj/item/clothing/accessory/patch/cec_patch

/datum/gear/civilian/patch/clf
	display_name = "Colonial Liberation Front shoulder patch"
	path = /obj/item/clothing/accessory/patch/clf_patch

// Cheap Civilian shades - colorful!

/datum/gear/civilian/eyewear/bimax_shades
	display_name = "BiMax personal shades"
	path = /obj/item/clothing/glasses/sunglasses/big/fake

/datum/gear/civilian/eyewear/bimax_shades/red
	display_name = "BiMax personal shades, red"
	path = /obj/item/clothing/glasses/sunglasses/big/fake/red

/datum/gear/civilian/eyewear/bimax_shades/orange
	display_name = "BiMax personal shades, orange"
	path = /obj/item/clothing/glasses/sunglasses/big/fake/orange

/datum/gear/civilian/eyewear/bimax_shades/yellow
	display_name = "BiMax personal shades, yellow"
	path = /obj/item/clothing/glasses/sunglasses/big/fake/yellow

/datum/gear/civilian/eyewear/bimax_shades/green
	display_name = "BiMax personal shades, green"
	path = /obj/item/clothing/glasses/sunglasses/big/fake/green

/datum/gear/civilian/eyewear/bimax_shades/blue
	display_name = "BiMax personal shades, blue"
	path = /obj/item/clothing/glasses/sunglasses/big/fake/blue

// Hippie Shades

/datum/gear/eyewear/sunglasses/hippie_shades/pink
	display_name = "Suntex-Sightware rounded shades, pink"
	path = /obj/item/clothing/glasses/sunglasses/hippie

/datum/gear/eyewear/sunglasses/hippie_shades/green
	display_name = "Suntex-Sightware rounded shades, green"
	path = /obj/item/clothing/glasses/sunglasses/hippie/green

/datum/gear/eyewear/sunglasses/hippie_shades/sunrise
	display_name = "Suntex-Sightware rounded shades, sunrise"
	path = /obj/item/clothing/glasses/sunglasses/hippie/sunrise

/datum/gear/eyewear/sunglasses/hippie_shades/sunset
	display_name = "Suntex-Sightware rounded shades, sunset"
	path = /obj/item/clothing/glasses/sunglasses/hippie/sunset

/datum/gear/eyewear/sunglasses/hippie_shades/nightblue
	display_name = "Suntex-Sightware rounded shades, nightblue"
	path = /obj/item/clothing/glasses/sunglasses/hippie/nightblue

/datum/gear/eyewear/sunglasses/hippie_shades/midnight
	display_name = "Suntex-Sightware rounded shades, midnight"
	path = /obj/item/clothing/glasses/sunglasses/hippie/midnight

/datum/gear/eyewear/sunglasses/hippie_shades/bloodred
	display_name = "Suntex-Sightware rounded shades, bloodred"
	path = /obj/item/clothing/glasses/sunglasses/hippie/bloodred

// Civilian shoes

/datum/gear/civilian/shoes
	display_name = "black shoes"
	path = /obj/item/clothing/shoes/black
	fluff_cost = 1

/datum/gear/civilian/shoes/brown
	display_name = "brown shoes"
	path = /obj/item/clothing/shoes/brown

/datum/gear/civilian/shoes/blue
	display_name = "blue shoes"
	path = /obj/item/clothing/shoes/blue

/datum/gear/civilian/shoes/green
	display_name = "green shoes"
	path = /obj/item/clothing/shoes/green

/datum/gear/civilian/shoes/yellow
	display_name = "yellow shoes"
	path = /obj/item/clothing/shoes/yellow

/datum/gear/civilian/shoes/purple
	display_name = "purple shoes"
	path = /obj/item/clothing/shoes/purple

/datum/gear/civilian/shoes/red
	display_name = "red shoes"
	path = /obj/item/clothing/shoes/red

/datum/gear/civilian/shoes/rainbow
	display_name = "rainbow shoes"
	path = /obj/item/clothing/shoes/rainbow

// Plushies - either civilian only or removed completely perhaps...

/datum/gear/civilian/plush/farwa
	display_name = "Farwa plush"
	path = /obj/item/toy/plush/farwa

/datum/gear/civilian/plush/barricade
	display_name = "Barricade plush"
	path = /obj/item/toy/plush/barricade

/datum/gear/civilian/plush/bee
	display_name = "Bee plush"
	path = /obj/item/toy/plush/bee

/datum/gear/civilian/plush/shark
	display_name = "Shark plush"
	path = /obj/item/toy/plush/shark

/datum/gear/civilian/plush/gnarp
	display_name = "Gnarp plush"
	path = /obj/item/toy/plush/gnarp

/datum/gear/civilian/plush/gnarp/alt
	display_name = "Gnarp plush, alt"
	path = /obj/item/toy/plush/gnarp/alt

/datum/gear/civilian/plush/rock
	display_name = "Rock plush"
	path = /obj/item/toy/plush/rock

/datum/gear/civilian/plush/therapy
	display_name = "Therapy plush"
	path = /obj/item/toy/plush/therapy

/datum/gear/civilian/plush/therapy/red
	display_name = "Therapy plush (Red)"
	path = /obj/item/toy/plush/therapy/red

/datum/gear/civilian/plush/therapy/blue
	display_name = "Therapy plush (Blue)"
	path = /obj/item/toy/plush/therapy/blue

/datum/gear/civilian/plush/therapy/green
	display_name = "Therapy plush (Green)"
	path = /obj/item/toy/plush/therapy/green

/datum/gear/civilian/plush/therapy/orange
	display_name = "Therapy plush (Orange)"
	path = /obj/item/toy/plush/therapy/orange

/datum/gear/civilian/plush/therapy/purple
	display_name = "Therapy plush (Purple)"
	path = /obj/item/toy/plush/therapy/purple

/datum/gear/civilian/plush/therapy/yellow
	display_name = "Therapy plush (Yellow)"
	path = /obj/item/toy/plush/therapy/yellow
