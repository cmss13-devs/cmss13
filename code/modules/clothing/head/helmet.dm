/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_atom = FPRINT|CONDUCT
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	flags_cold_protection = BODY_FLAG_HEAD
	flags_heat_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	siemens_coefficient = 0.7
	w_class = SIZE_MEDIUM
	pickup_sound = "armorequip"
	drop_sound = "armorequip"

/obj/item/clothing/head/helmet/verb/hidehair()
	set name = "Toggle Hair"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return

	if(flags_inv_hide & HIDETOPHAIR)
		flags_inv_hide &= ~HIDETOPHAIR
		to_chat(usr, "You let your hair out from [src].")
	else
		flags_inv_hide |= HIDETOPHAIR
		to_chat(usr, "You tuck your hair into \the [src].")

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			H.update_hair()

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks. It covers your ears."
	icon_state = "riot"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi'
	)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDETOPHAIR

/obj/item/clothing/head/helmet/riot/vintage_riot
	desc = "A scarred riot helmet covered in cobwebs. It still protects your ears."
	icon_state = "old_riot"
	icon = 'icons/obj/items/clothing/hats/hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats.dmi',
	)

/obj/item/clothing/head/helmet/augment
	name = "augment array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	item_state = "v62"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a security force. Protects the head from impacts."
	icon_state = "policehelm"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0

/obj/item/clothing/head/helmet/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	item_state = "swat"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT
	siemens_coefficient = 0.5
	anti_hug = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	item_state = "gladiator"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEALLHAIR
	siemens_coefficient = 1
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

//===========================//MARINES HELMETS\\=================================\\
//=======================================================================\\

GLOBAL_LIST_INIT(allowed_helmet_items, list(
	// TOBACCO-RELATED
	/obj/item/tool/lighter/random = NO_GARB_OVERRIDE,
	/obj/item/tool/lighter/zippo = NO_GARB_OVERRIDE,
	/obj/item/storage/box/matches = NO_GARB_OVERRIDE,
	/obj/item/storage/fancy/cigarettes/emeraldgreen = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/kpack = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/lucky_strikes = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/wypacket = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/lady_finger = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/blackpack = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/arcturian_ace = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/lucky_strikes_4 = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/spirit = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/storage/fancy/cigarettes/spirit/yellow = PREFIX_HELMET_GARB_OVERRIDE, // helmet_

	/obj/item/storage/fancy/cigar/matchbook = NO_GARB_OVERRIDE,
	/obj/item/clothing/mask/cigarette/cigar = NO_GARB_OVERRIDE,
	/obj/item/clothing/mask/electronic_cigarette = NO_GARB_OVERRIDE,

	// CARDS
	/obj/item/toy/deck = NO_GARB_OVERRIDE,
	/obj/item/toy/deck/uno = NO_GARB_OVERRIDE,
	/obj/item/toy/handcard = NO_GARB_OVERRIDE,
	/obj/item/toy/handcard/aceofspades = NO_GARB_OVERRIDE,
	/obj/item/toy/handcard/uno_reverse_red = NO_GARB_OVERRIDE,
	/obj/item/toy/handcard/uno_reverse_blue = NO_GARB_OVERRIDE,
	/obj/item/toy/handcard/uno_reverse_yellow = NO_GARB_OVERRIDE,
	/obj/item/toy/handcard/uno_reverse_purple = NO_GARB_OVERRIDE,

	// FOOD AND SNACKS
	/obj/item/reagent_container/food/drinks/flask = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/drinks/flask/marine = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/eat_bar = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/mushroompizzaslice = NO_GARB_OVERRIDE, // Fuck whoever put these under different paths for some REASON
	/obj/item/reagent_container/food/snacks/vegetablepizzaslice = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/meatpizzaslice = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/packaged_burrito = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/packaged_hdogs = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/wrapped/chunk = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/donkpocket = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/wrapped/booniebars = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/food/snacks/wrapped/barcardine = NO_GARB_OVERRIDE,

	// EYEWEAR
	/obj/item/clothing/glasses/mgoggles = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/v2 = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/prescription = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/blue = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/blue/prescription = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/polarized_blue = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/polarized_blue/prescription = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/polarized_orange = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/v2/polarized_orange/prescription = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/prescription = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/black = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/black/prescription = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/orange = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/orange/prescription = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/blue = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/blue/prescription = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/purple = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/glasses/mgoggles/purple/prescription = PREFIX_HELMET_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/yellow = PREFIX_HELMET_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/yellow/prescription = PREFIX_HELMET_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/red = PREFIX_HELMET_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/red/prescription = PREFIX_HELMET_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/prescription = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/aviator = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/aviator/silver = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/new_bimex/black = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/new_bimex = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/new_bimex/bronze = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/fake = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/fake/red = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/fake/orange = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/fake/yellow = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/fake/green = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/big/fake/blue = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/sechud = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/sechud/blue = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/eyepatch = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/eyepatch/left = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/eyepatch/white = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/eyepatch/white/left = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/eyepatch/green = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/eyepatch/green/left = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/regular/hipster = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/regular/hippie = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie/green = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie/sunrise = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie/sunset = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie/nightblue = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie/midnight = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/sunglasses/hippie/bloodred = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/regular = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mbcg = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/mgoggles/cmb_riot_shield = NO_GARB_OVERRIDE,

	// WALKMAN AND CASSETTES
	/obj/item/device/walkman = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/pop1 = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/pop2 = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/pop3 = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/pop4 = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/heavymetal = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/hairmetal = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/indie = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/hiphop = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/nam = NO_GARB_OVERRIDE,
	/obj/item/device/cassette_tape/ocean = NO_GARB_OVERRIDE,
	/obj/item/storage/pouch/cassette = NO_GARB_OVERRIDE,

	// PREFERENCES GEAR
	/obj/item/prop/helmetgarb/gunoil = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/netting = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/netting/desert = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/netting/jungle = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/netting/urban = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/spent_buckshot = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/spent_slug = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/spent_flech = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/cartridge = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/prescription_bottle = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/raincover = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/raincover/jungle = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/raincover/desert = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/raincover/urban = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/rabbitsfoot = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/rosary = NO_GARB_OVERRIDE, // This one was already in the game for some reason, but never had an object
	/obj/item/prop/helmetgarb/lucky_feather = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/lucky_feather/blue = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/lucky_feather/purple = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/lucky_feather/yellow = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/trimmed_wire = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/helmet_nvg = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/prop/helmetgarb/helmet_nvg/cosmetic = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/prop/helmetgarb/helmet_nvg/marsoc = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/prop/helmetgarb/helmet_gasmask = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/flair_initech = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/flair_io = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/flair_peace = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/flair_uscm = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/bullet_pipe = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/spacejam_tickets = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/family_photo = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/compass = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/bug_spray = NO_GARB_OVERRIDE,

	// MISC
	/obj/item/tool/pen = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/tool/pen/blue = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/tool/pen/red = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/tool/pen/multicolor/fountain = NO_GARB_OVERRIDE,
	/obj/item/clothing/glasses/welding = NO_GARB_OVERRIDE,
	/obj/item/clothing/head/headband = NO_GARB_OVERRIDE,
	/obj/item/clothing/head/headband/tan = NO_GARB_OVERRIDE,
	/obj/item/clothing/head/headband/red = NO_GARB_OVERRIDE,
	/obj/item/clothing/head/headband/brown = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/head/headband/gray = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/clothing/head/headband/squad = PREFIX_HELMET_GARB_OVERRIDE, // helmet_
	/obj/item/tool/candle = NO_GARB_OVERRIDE,
	/obj/item/clothing/mask/facehugger = NO_GARB_OVERRIDE,
	/obj/item/clothing/mask/facehugger/lamarr = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/red = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/orange = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/yellow = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/green = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/blue = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/purple = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/rainbow = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/trans = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/gay = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/lesbian = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/bi = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/pan = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/ace = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/trans = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/enby = NO_GARB_OVERRIDE,
	/obj/item/toy/crayon/pride/fluid = NO_GARB_OVERRIDE,
	/obj/item/paper = NO_GARB_OVERRIDE,
	/obj/item/device/flashlight/flare = NO_GARB_OVERRIDE,
	/obj/item/clothing/head/headset = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/falcon = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/falcon/squad_main = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/cec_patch = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/freelancer_patch = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/merc_patch = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/devils = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/forecon = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/royal_marines = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/upp = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/upp/airborne = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/upp/naval = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/ua = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/uasquare = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/falconalt = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/twe = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/uscmlarge = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/wy = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/wysquare = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/wy_faction = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/wy_white = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/wyfury = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/upp/alt = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/medic_patch = NO_GARB_OVERRIDE,
	/obj/item/clothing/accessory/patch/clf_patch = NO_GARB_OVERRIDE,
	/obj/item/ammo_magazine/handful = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/riot_shield = NO_GARB_OVERRIDE,
	/obj/item/attachable/flashlight = NO_GARB_OVERRIDE,
	/obj/item/prop/helmetgarb/chaplain_patch = NO_GARB_OVERRIDE,

	// MEDICAL
	/obj/item/stack/medical/bruise_pack = NO_GARB_OVERRIDE,
	/obj/item/stack/medical/ointment = NO_GARB_OVERRIDE,
	/obj/item/tool/surgery/scalpel = NO_GARB_OVERRIDE,
	/obj/item/reagent_container/hypospray/autoinjector = NO_GARB_OVERRIDE,
	/obj/item/storage/pill_bottle/packet = NO_GARB_OVERRIDE,
))

/obj/item/clothing/head/helmet/marine
	name = "\improper M10 pattern marine helmet"
	desc = "A standard M10 Pattern Helmet. The inside label, along with washing information, reads, 'The difference between an open-casket and closed-casket funeral. Wear on head for best results.'. There is a built-in camera on the right side."
	icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_map/jungle.dmi'
	)
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	health = 5
	force = 15
	throwforce = 15
	attack_verb = list("whacked", "hit", "smacked", "beaten", "battered")
	var/obj/structure/machinery/camera/camera
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NONE
	var/flags_marine_helmet = HELMET_SQUAD_OVERLAY|HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY
	var/helmet_bash_cooldown = 0

	//speciality does NOTHING if you have NO_NAME_OVERRIDE
	var/specialty = "M10 pattern marine" //Give them a specialty var so that they show up correctly in vendors. speciality does NOTHING if you have NO_NAME_OVERRIDE.
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)

	var/obj/item/storage/internal/headgear/pockets
	var/storage_slots = 2 // Small items like injectors, bandages, etc
	var/storage_slots_reserved_for_garb = 2 // Cosmetic items & now cigarettes and lighters for RP
	var/storage_max_w_class = SIZE_TINY // can hold tiny items only, EXCEPT for glasses & metal flask.
	var/storage_max_storage_space = 4

	/// The dmi where the grayscale squad overlays are contained for "std-helmet" and "sql-helmet"
	var/helmet_overlay_icon = 'icons/mob/humans/onmob/clothing/head/overlays.dmi'
	/// The dmi where the "helmet_band" is contained for garb
	var/helmet_band_icon = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi'

	///Any visors built into the helmet
	var/list/built_in_visors = list(new /obj/item/device/helmet_visor)
	///Any visors that have been added into the helmet
	var/list/inserted_visors = list()
	///Max amount of inserted visors
	var/max_inserted_visors = 1
	///The current active visor that is shown
	var/obj/item/device/helmet_visor/active_visor = null
	///Designates a visor type that should start down when initialized
	var/start_down_visor_type

/obj/item/clothing/head/helmet/marine/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT))
	. = ..()
	AddComponent(/datum/component/overwatch_console_control)
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += " snow helmet"
		else
			name += " helmet"

	if(!(flags_atom & NO_GAMEMODE_SKIN))
		select_gamemode_skin(type, null, new_protection)

	helmet_overlays = list() //To make things simple.

	pockets = new(src)
	pockets.storage_slots = HAS_FLAG(flags_marine_helmet, HELMET_GARB_OVERLAY) ? storage_slots + storage_slots_reserved_for_garb : storage_slots
	pockets.slots_reserved_for_garb = HAS_FLAG(flags_marine_helmet, HELMET_GARB_OVERLAY) ? storage_slots_reserved_for_garb : 0
	pockets.max_w_class = storage_max_w_class
	pockets.bypass_w_limit = GLOB.allowed_helmet_items
	pockets.max_storage_space = storage_max_storage_space

	camera = new /obj/structure/machinery/camera/overwatch(src)

	for(var/obj/visor as anything in built_in_visors)
		visor.forceMove(src)

	if(length(inserted_visors) || length(built_in_visors))
		var/datum/action/item_action/cycle_helmet_huds/new_action = new(src)
		if(ishuman(loc))
			var/mob/living/carbon/human/holding_human = loc
			if(holding_human.head == src)
				new_action.give_to(holding_human)

	if(start_down_visor_type)
		for(var/obj/item/device/helmet_visor/cycled_visor in (built_in_visors + inserted_visors))
			if(cycled_visor.type == start_down_visor_type)
				active_visor = cycled_visor
				break

		if(active_visor)
			var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in actions
			if(cycle_action)
				cycle_action.set_action_overlay(active_visor)

/obj/item/clothing/head/helmet/marine/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	if(flags_atom & MAP_COLOR_INDEX)
		return
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/classic.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/desert.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/snow.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/urban.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/urban.dmi'

/obj/item/clothing/head/helmet/marine/Destroy(force)
	QDEL_NULL(camera)
	QDEL_NULL(pockets)
	if(active_visor && istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/potential_user = loc
		if(potential_user.head == src)
			var/obj/item/device/helmet_visor/temp_visor_holder = active_visor
			active_visor = null
			toggle_visor(potential_user, temp_visor_holder, TRUE)
	QDEL_NULL_LIST(built_in_visors)
	return ..()

/obj/item/clothing/head/helmet/marine/attack_hand(mob/user)
	if(loc != user)
		..(user) // If it's in a satchel or something don't open the pockets
		return

	if(pockets.handle_attack_hand(user))
		..(user)


/obj/item/clothing/head/helmet/marine/MouseDrop(over_object, src_location, over_location)
	SEND_SIGNAL(usr, COMSIG_ITEM_DROPPED, usr)
	if(pockets.handle_mousedrop(usr, over_object))
		..()

/obj/item/clothing/head/helmet/marine/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ammo_magazine) && world.time > helmet_bash_cooldown && user)
		var/obj/item/ammo_magazine/M = attacking_item
		var/ammo_level = "more than half full."
		playsound(user, 'sound/items/trayhit1.ogg', 15, FALSE)
		if(M.current_rounds == (M.max_rounds/2))
			ammo_level = "half full."
		if(M.current_rounds < (M.max_rounds/2))
			ammo_level = "less than half full."
		if(M.current_rounds < (M.max_rounds/6))
			ammo_level = "almost empty."
		if(M.current_rounds == 0)
			ammo_level = "empty. Uh oh."
		user.visible_message("[user] bashes [M] against their helmet", "You bash [M] against your helmet. It is [ammo_level]")
		helmet_bash_cooldown = world.time + 20 SECONDS
		return

	if(istype(attacking_item, /obj/item/device/helmet_visor))
		if(length(inserted_visors) >= max_inserted_visors)
			to_chat(user, SPAN_NOTICE("[src] has used all of its visor attachment sockets."))
			return

		var/obj/item/device/helmet_visor/new_visor = attacking_item
		for(var/obj/item/device/helmet_visor/cycled_visor as anything in (built_in_visors + inserted_visors))
			if(cycled_visor.type == new_visor.type)
				to_chat(user, SPAN_NOTICE("[src] already has this type of HUD connected."))
				return
		if(!user.drop_held_item())
			return

		inserted_visors += new_visor
		to_chat(user, SPAN_NOTICE("You connect [new_visor] to [src]."))
		new_visor.forceMove(src)
		if(!(locate(/datum/action/item_action/cycle_helmet_huds) in actions))
			var/datum/action/item_action/cycle_helmet_huds/new_action = new(src)
			new_action.give_to(user)
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
		// If there isn't anything to remove, return.
		if(!length(inserted_visors))
			// If the user is trying to remove a built-in visor, give them a more helpful failure message.
			switch(length(built_in_visors))
				if(1) // Messy plural handling
					to_chat(user, SPAN_WARNING("The visor on [src] is built-in!"))
				if(2 to INFINITY)
					to_chat(user, SPAN_WARNING("The visors on [src] are built-in!"))
			return

		if(active_visor)
			var/obj/item/device/helmet_visor/temp_visor_holder = active_visor
			active_visor = null
			toggle_visor(user, temp_visor_holder, TRUE)

		for(var/obj/item/device/helmet_visor/visor as anything in inserted_visors)
			visor.forceMove(get_turf(src))

		inserted_visors = list()
		to_chat(user, SPAN_NOTICE("You remove the inserted visors."))

		var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in actions
		cycle_action.set_default_overlay()
		if(!length(built_in_visors))
			cycle_action.remove_from(user)

		return

	..()
	return pockets.attackby(attacking_item, user)

/obj/item/clothing/head/helmet/marine/on_pocket_insertion()
	update_icon()

/obj/item/clothing/head/helmet/marine/on_pocket_removal()
	update_icon()

/obj/item/clothing/head/helmet/marine/update_icon()
	// Currently done by delegating to the human onmob head inventory updater
	// not the best *possible* solution, but this is complicated by the fact that
	// adding an image to src or trying to render it in overlays does nothing because
	// the "primary" icon of src is the holdable object, not the onmob.
	// the human sprite is the only thing that reliably renders things, so
	// we have to add overlays to that.
	helmet_overlays = list() // Rebuild our list every time
	if(length(pockets?.contents) && (flags_marine_helmet & HELMET_GARB_OVERLAY))
		var/list/above_band_layer = list()
		var/list/below_band_layer = list()
		var/has_helmet_band = FALSE
		for(var/obj/item/garb_object in pockets.contents)
			if(garb_object.type in GLOB.allowed_helmet_items)
				var/has_band = !HAS_FLAG(garb_object.flags_obj, OBJ_NO_HELMET_BAND)
				if(has_band)
					has_helmet_band = TRUE
				var/image/new_overlay = garb_object.get_garb_overlay(GLOB.allowed_helmet_items[garb_object.type])
				if(has_band)
					above_band_layer += new_overlay
				else
					below_band_layer += new_overlay

		if(has_helmet_band)
			var/image/band_overlay = overlay_image(helmet_band_icon, "helmet_band", color, RESET_COLOR)
			helmet_overlays = above_band_layer + band_overlay + below_band_layer
		else
			helmet_overlays = above_band_layer + below_band_layer

	if(active_visor)
		helmet_overlays += overlay_image(active_visor.helmet_overlay_icon, active_visor.helmet_overlay, color, RESET_COLOR)

	if(ismob(loc))
		var/mob/moob = loc
		moob.update_inv_head()

/obj/item/clothing/head/helmet/marine/equipped(mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
		camera.status = TRUE
	if(active_visor)
		recalculate_visors(mob)
	..()

/obj/item/clothing/head/helmet/marine/unequipped(mob/user, slot)
	. = ..()
	if(camera)
		camera.status = FALSE
	if(pockets)
		for(var/obj/item/attachable/flashlight/F in pockets)
			if(F.light_on)
				F.activate_attachment(src, user, TRUE)
	if(active_visor)
		recalculate_visors(user)

/obj/item/clothing/head/helmet/marine/dropped(mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "Unknown"
	if(pockets)
		for(var/obj/item/attachable/flashlight/F in pockets)
			if(F.light_on)
				F.activate_attachment(src, mob, TRUE)
	if(active_visor)
		recalculate_visors(mob)
	..()

/obj/item/clothing/head/helmet/marine/has_garb_overlay()
	return flags_marine_helmet & HELMET_GARB_OVERLAY

/obj/item/clothing/head/helmet/marine/get_examine_text(mob/user)
	. = ..()
	if(active_visor)
		. += active_visor.get_helmet_examine_text()

/obj/item/clothing/head/helmet/marine/proc/add_hugger_damage() //This is called in XenoFacehuggers.dm to first add the desc and set the var.
	if(flags_marine_helmet & HELMET_DAMAGE_OVERLAY && !(flags_marine_helmet & HELMET_IS_DAMAGED))
		flags_marine_helmet |= HELMET_IS_DAMAGED
		desc += "\n<b>This helmet seems to be scratched up and damaged, particularly around the face area...</b>"

/obj/item/clothing/head/helmet/marine/get_pockets()
	if(pockets)
		return pockets
	return ..()

/// Recalculates and sets the proper visor effects
/obj/item/clothing/head/helmet/marine/proc/recalculate_visors(mob/user)
	turn_off_visors(user)

	if(!active_visor)
		return

	if(user != loc)
		return

	var/mob/living/carbon/human/human_user = user
	if(!human_user || human_user.head != src)
		return

	toggle_visor(user, silent = TRUE)

/// Toggles the specified visor, if nothing specified then the active visor, if the visor is the active visor and the helmet is on the user's head it will turn on, if it is not the active visor it will turn off
/obj/item/clothing/head/helmet/marine/proc/toggle_visor(mob/user, obj/item/device/helmet_visor/current_visor, silent = FALSE)
	current_visor = current_visor || active_visor

	if(!current_visor)
		return

	current_visor.toggle_visor(src, user, silent)

	update_icon()

/// Attempts to turn off all visors
/obj/item/clothing/head/helmet/marine/proc/turn_off_visors(mob/user)
	var/list/total_visors = built_in_visors + inserted_visors

	for(var/obj/item/device/helmet_visor/cycled_helmet_visor in total_visors)
		cycled_helmet_visor.deactivate_visor(src, user)

	update_icon()

///Cycles the active HUD to the next between built_in_visors and inserted_visors, nullifies if at end and removes all HUDs
/obj/item/clothing/head/helmet/marine/proc/cycle_huds(mob/user)
	var/list/total_visors = built_in_visors + inserted_visors

	if(!length(total_visors))
		to_chat(user, SPAN_WARNING("There are no visors to swap to."))
		return FALSE

	if(active_visor)
		var/visor_to_deactivate = active_visor
		var/skipped_hud = FALSE
		var/iterator = 1
		for(var/obj/item/device/helmet_visor/current_visor as anything in total_visors)
			if(current_visor == active_visor || skipped_hud)
				if(length(total_visors) > iterator)
					var/obj/item/device/helmet_visor/next_visor = total_visors[iterator + 1]

					if(!isnull(GLOB.huds[next_visor.hud_type]?.hudusers[user]))
						iterator++
						skipped_hud = TRUE
						continue

					if(!next_visor.can_toggle(user))
						iterator++
						skipped_hud = TRUE
						continue

					active_visor = next_visor
					toggle_visor(user, visor_to_deactivate, silent = TRUE) // disables the old visor
					toggle_visor(user)
					return active_visor
				else
					active_visor = null
					toggle_visor(user, visor_to_deactivate, FALSE)
					return FALSE
			iterator++

	for(var/obj/item/device/helmet_visor/new_visor in total_visors)
		if(!isnull(GLOB.huds[new_visor.hud_type]?.hudusers[user]))
			continue

		if(!new_visor.can_toggle(user))
			continue

		active_visor = new_visor
		toggle_visor(user)
		return active_visor

	to_chat(user, SPAN_WARNING("There are no visors to swap to currently."))
	return FALSE


/obj/item/clothing/head/helmet/marine/hear_talk(mob/living/sourcemob, message, verb, datum/language/language, italics)
	SEND_SIGNAL(src, COMSIG_BROADCAST_HEAR_TALK, sourcemob, message, verb, language, italics, loc == sourcemob)

/obj/item/clothing/head/helmet/marine/see_emote(mob/living/sourcemob, emote, audible)
	SEND_SIGNAL(src, COMSIG_BROADCAST_SEE_EMOTE, sourcemob, emote, audible, loc == sourcemob && audible)

/datum/action/item_action/cycle_helmet_huds/New(Target, obj/item/holder)
	. = ..()
	name = "Cycle helmet HUD"
	button.name = name
	set_default_overlay()

/datum/action/item_action/cycle_helmet_huds/action_activate()
	. = ..()
	var/obj/item/clothing/head/helmet/marine/holder_helmet = holder_item
	var/cycled_hud = holder_helmet.cycle_huds(usr)

	set_action_overlay(cycled_hud)

/// Sets the action overlay based on the visor type
/datum/action/item_action/cycle_helmet_huds/proc/set_action_overlay(obj/item/device/helmet_visor/new_visor)
	if(!new_visor)
		set_default_overlay()
		return

	action_icon_state = new_visor.action_icon_string
	button.overlays.Cut()
	button.overlays += image('icons/obj/items/clothing/helmet_visors.dmi', button, action_icon_state)

/// Sets the action overlay to default hud sight up
/datum/action/item_action/cycle_helmet_huds/proc/set_default_overlay()
	action_icon_state = "hud_sight_up"
	button.overlays.Cut()
	button.overlays += image('icons/obj/items/clothing/helmet_visors.dmi', button, action_icon_state)

/obj/item/clothing/head/helmet/marine/tech
	name = "\improper M10 technician helmet"
	desc = "A modified M10 marine helmet for ComTechs. Features a toggleable welding screen for eye protection."
	icon_state = "tech_helmet"
	specialty = "M10 technician"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/welding_visor)

/obj/item/clothing/head/helmet/marine/welding
	name = "\improper M10 welding helmet"
	desc = "A modified M10 marine helmet, Features a toggleable welding screen for eye protection. Completely invisible while toggled off as opposed to the technician helmet."
	specialty = "M10 welding"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/welding_visor)


/obj/item/clothing/head/helmet/marine/grey
	desc = "A standard M10 Pattern Helmet. This one has not had a camouflage pattern applied to it yet. There is a built-in camera on the right side."
	icon = 'icons/obj/items/clothing/hats/hats_by_map/classic.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_map/classic.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/classic_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/classic_righthand.dmi'
	)


/obj/item/clothing/head/helmet/marine/jungle
	icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_map/jungle.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)


/obj/item/clothing/head/helmet/marine/snow
	name = "\improper M10 marine snow helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_map/snow.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_map/snow.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/snow_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/snow_righthand.dmi'
	)

/obj/item/clothing/head/helmet/marine/desert
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	icon = 'icons/obj/items/clothing/hats/hats_by_map/desert.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_map/desert.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_righthand.dmi'
	)

/obj/item/clothing/head/helmet/marine/tech/tanker
	name = "\improper M50 tanker helmet"
	desc = "The lightweight M50 tanker helmet is designed for use by armored crewmen in the USCM. It offers low weight protection, and allows agile movement inside the confines of an armored vehicle. Features a toggleable welding screen for eye protection."
	icon_state = "tanker_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	specialty = "M50 tanker"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/welding_visor/tanker)

/obj/item/clothing/head/helmet/marine/medic
	name = "\improper M10 corpsman helmet"
	desc = "An M10 marine helmet version worn by marine hospital corpsmen. Has red cross painted on its front."
	icon_state = "med_helmet"
	specialty = "M10 pattern medic"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/medical/advanced)
	start_down_visor_type = /obj/item/device/helmet_visor/medical/advanced

/obj/item/clothing/head/helmet/marine/medic/white
	name = "\improper M10 white corpsman helmet"
	desc = "An M10 marine helmet version worn by marine hospital corpsmen. Painted in medical white and has white cross in a red square painted on its front."
	icon_state = "med_helmet_white"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/snow_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/snow_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/covert
	name = "\improper M10 covert helmet"
	desc = "An M10 marine helmet version designed for use in darkened environments. It is coated with a special anti-reflective paint."
	icon_state = "marsoc_helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/urban_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/urban_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "M10 pattern covert"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/leader
	name = "\improper M11 pattern helmet"
	desc = "A variant of the standard M10 pattern. The front plate is reinforced. This one contains a small built-in camera and has cushioning to project your fragile brain."
	icon_state = "sl_helmet"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "M11 pattern marine"

/obj/item/clothing/head/helmet/marine/rto
	name = "\improper M12 pattern dust helmet"
	desc = "An experimental brain-bucket. A dust ruffle hangs from back instead of the standard lobster shell design. Moderately better at deflecting blunt objects at the cost of humiliation, can also hold a second visor optic. But who will be laughing at the memorial? Not you, you'll be busy getting medals for your fantastic leadership."
	icon_state = "io"
	item_state = "io"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "M12 pattern"
	max_inserted_visors = 2

/obj/item/clothing/head/helmet/marine/rto/intel
	name = "\improper XM12 pattern intelligence helmet"
	desc = "An experimental brain-bucket. A dust ruffle hangs from back. Moderately better at deflecting blunt objects at the cost of humiliation, can also hold a second visor optic. But who will be laughing at the memorial? Not you, you'll be busy getting medals for your intel work."
	specialty = "XM12 pattern intel"

/obj/item/clothing/head/helmet/marine/specialist
	name = "\improper B18 helmet"
	desc = "The B18 Helmet that goes along with the B18 Defensive Armor. It's heavy, reinforced, and protects more of the face."
	icon_state = "grenadier_helmet"
	item_state = "grenadier_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	unacidable = TRUE
	anti_hug = 6
	force = 20
	specialty = "B18"

/obj/item/clothing/head/helmet/marine/grenadier
	name = "\improper M3-G4 grenadier helmet"
	desc = "Pairs with the M3-G4 heavy grenadier plating. A distant cousin of the experimental B18 defensive helmet. Comes with inbuilt ear blast protection."
	icon_state = "grenadier_helmet"
	item_state = "grenadier_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	unacidable = TRUE
	anti_hug = 6
	specialty = "M3-G4 grenadier"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/head/helmet/marine/scout
	name = "\improper M3-S light helmet"
	icon_state = "scout_helmet"
	desc = "A custom helmet designed for USCM Scouts."
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	specialty = "M3-S light"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/head/helmet/marine/pyro
	name = "\improper M35 pyrotechnician helmet"
	icon_state = "pyro_helmet"
	desc = "A helmet designed for USCM Pyrotechnicians."
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	specialty = "M35 pyrotechnician"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/head/helmet/marine/M3T
	name = "\improper M3-T bombardier helmet"
	icon_state = "sadar_helmet"
	desc = "A custom-built helmet for explosive weaponry users. Comes with inbuilt ear blast protection, firing a rocket launcher without this is not recommended."
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	armor_bomb = CLOTHING_ARMOR_HIGH
	specialty = "M3-T bombardier"
	flags_inventory = BLOCKSHARPOBJ
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	unacidable = TRUE

/obj/item/clothing/head/helmet/marine/pilot
	name = "\improper M30 tactical helmet"
	desc = "The M30 tactical helmet has a left eyepiece filter used to filter tactical data. It is required to fly the dropships manually and in safety."
	icon_state = "helmetp"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	specialty = "M30 tactical"

/obj/item/clothing/head/helmet/marine/pilottex
	name = "\improper Tex's M30 tactical helmet"
	desc = "The M30 tactical helmet has a left eyepiece filter used to filter tactical data. It is required to fly the dropships manually and in safety. This one belonged to Tex: the craziest sum'bitch pilot the Almayer ever had. He's not dead or anything, but he did get a medical discharge after he was hit by a car on shore leave last year."
	icon_state = "helmetp_tex"
	item_state = "helmetp_tex"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
	)
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/ghillie
	name = "\improper M45 ghillie helmet"
	desc = "A lightweight M45 helmet with ghillie coif used by USCM snipers on recon missions."
	icon_state = "ghillie_coif"
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	flags_marine_helmet = HELMET_GARB_OVERLAY
	flags_item = MOB_LOCK_ON_EQUIP
	specialty = "M45 ghillie"

/obj/item/clothing/head/helmet/marine/ghillie/select_gamemode_skin()
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("urban")
			name = "\improper M10-LS pattern sniper helmet"
			desc = "A lightweight version of M10 helmet with thermal signature dampering used by USCM snipers on urban recon missions."

/obj/item/clothing/head/helmet/marine/leader/CO
	name = "\improper M11C pattern commanding officer helmet"
	desc = "A special M11 Pattern Helmet worn by Commanding Officers of the USCM. It reads on the label, 'The difference between an open-casket and closed-casket funeral. Wear on head for best results.'."
	icon_state = "co"
	item_state = "co"
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "M11 pattern commanding officer"
	flags_atom = NO_NAME_OVERRIDE
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/medical/advanced, new /obj/item/device/helmet_visor/security)

/obj/item/clothing/head/helmet/marine/leader/CO/general
	name = "\improper M11 pattern ceremonial helmet"
	desc = "A special M11 pattern ceremonial helmet worn occasionally by general officers of the USCM."
	icon_state = "golden"
	item_state = "golden"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/desert_righthand.dmi'
	)
	specialty = "M11 pattern ceremonial"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/MP
	name = "\improper M10 pattern MP helmet"
	desc = "A special variant of the M10 Pattern Helmet worn by the Military Police of the USCM. Whether you're facing a crime syndicate or a mutiny, this bucket will keep your brains intact."
	icon_state = "mp_helmet"
	item_state = "mp_helmet"
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	specialty = "M10 pattern military police"
	built_in_visors = list(new /obj/item/device/helmet_visor/security)

/obj/item/clothing/head/helmet/marine/MP/WO
	name = "\improper M3 pattern chief MP helmet"
	desc = "A well-crafted variant of the M10 Helmet typically distributed to Chief MPs. Useful for letting your men know who is in charge."
	icon_state = "cmp_helmet"
	item_state = "cmp_helmet"
	specialty = "M10 pattern chief MP"

/obj/item/clothing/head/helmet/marine/MP/SO
	name = "\improper M10 pattern Officer Helmet"
	desc = "A special variant of the M10 Pattern Helmet worn by Officers of the USCM, attracting the attention of the grunts and sniper fire alike."
	icon_state = "officer"
	item_state = "officer"
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	specialty = "M10 pattern officer"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/medical/advanced)

/obj/item/clothing/head/helmet/marine/MP/provost/marshal
	name = "\improper Provost Marshal Cap"
	desc = "The expensive headwear of a Provost Marshal. Contains shards of kevlar to keep its valuable contents safe."
	icon_state = "pvmarshalhat"
	item_state = "pvmarshalhat"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
	)
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ|FULL_DECAP_PROTECTION

/obj/item/clothing/head/helmet/marine/sof
	name = "\improper SOF Operator Helmet"
	desc = "A special variant of the M10 Pattern Helmet worn by USCM SOF."
	icon_state = "marsoc_helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/urban_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/urban_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "M10 pattern SOF"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	built_in_visors = list(new /obj/item/device/helmet_visor/night_vision/marine_raider, new /obj/item/device/helmet_visor/security)
	start_down_visor_type = /obj/item/device/helmet_visor/night_vision/marine_raider

//=============================//PMCS\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE //Let's make these keep their name and icon.
	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/veteran/pmc
	name = "\improper PMC tactical cap"
	desc = "A protective cap made from flexible kevlar. Standard issue for most security forms in the place of a helmet."
	icon_state = "pmc_hat"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/WY.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/WY.dmi',
	)
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/pmc/leader
	name = "\improper PMC beret"
	desc = "The pinnacle of fashion for any aspiring mercenary leader. Designed to protect the head from light impacts."
	icon_state = "officer_hat"

/obj/item/clothing/head/helmet/marine/veteran/pmc/sniper
	name = "\improper PMC sniper helmet"
	desc = "A helmet worn by PMC Marksmen."
	icon_state = "pmc_sniper_hat"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/pmc/gunner
	name = "\improper PMC gunner helmet"
	desc = "A modification of the standard Armat Systems M3 armor."
	icon_state = "heavy_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/pmc/commando
	name = "\improper M5X helmet"
	desc = "A fully enclosed, armored helmet made to complete the M5X exoskeleton armor."
	icon_state = "commando_helmet"
	item_state = "commando_helmet"
	unacidable = 1
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT|FULL_DECAP_PROTECTION
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	unacidable = TRUE

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate
	name = "\improper WY corporate security helmet"
	desc = "A basic skull-helm worn by corporate security assets, graded to protect your head from an unruly scientist armed with a crowbar."
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/WY.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/WY.dmi'
	)
	icon_state = "sec_helmet"
	item_state = "sec_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/medic
	desc = "A basic skull-helm worn by corporate security assets. This variant lacks a visor, granting the wearer a better view of any potential patients."
	icon_state = "med_helmet"
	item_state = "med_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/engi
	name = "\improper WY corporate security technician helmet"
	desc = "A basic skull-helm worn by corporate security assets. This variant comes equipped with a standard-issue integrated welding visor. Prone to fogging up over prolonged use"
	icon_state = "eng_helmet"
	item_state = "eng_helmet"
	built_in_visors = list(new /obj/item/device/helmet_visor/welding_visor/goon)

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead
	desc = "A basic skull-helm worn by corporate security assets. This variant is worn by low-level guards that have too much brainmatter to fit into the old one. Or so they say."
	icon_state = "sec_lead_helmet"
	item_state = "sec_lead_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo
	desc = "A basic skull-helm worn by corporate security assets. This variant comes with a wider brim to protect the user from the harsh climate of the desert."
	icon_state = "sec_helmet_kutjevo"
	item_state = "sec_helmet_kutjevo"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo/medic
	desc = "A basic skull-helm worn by corporate security assets. This variant comes with a wider brim to protect the user from the harsh climate of the desert and has a medical cross across the front."
	icon_state = "sec_medic_helmet_kutjevo"
	item_state = "sec_medic_helmet_kutjevo"

//FIORINA / UA RIOT CONTROL HELMET//

/obj/item/clothing/head/helmet/marine/veteran/ua_riot
	name = "\improper RC6 helmet"
	desc = "The standard UA Riot Control 6 helmet is of odd design, lacking a face shield by default (mounting points are available). The distinct white pattern and red emblem are synonymous with oppression throughout the rim."
	icon_state = "ua_riot"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/snow_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/snow_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	specialty = "RC6"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

// KUTJEVO HELMET

/obj/item/clothing/head/helmet/marine/veteran/kutjevo
	name = "Kutjevo Helmet"
	desc = "Standard issued helmet for the workers of Kutjevo. Contains a small webbing to hold small items like pens, oil or even a photo of a loved one."
	icon_state = "kutjevo_helmet"
	item_state = "kutjevo_helmet"
	icon = 'icons/obj/items/clothing/hats/misc_ert_colony.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/misc_ert_colony.dmi',
	)

//=============================//CMB\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/cmb
	name = "M11R pattern CMB Riot helmet"
	desc = "A CMB variant of the standard M10 pattern. The front plate is reinforced. This one is a lot more tight fitting, also protects from flashbangs."
	icon_state = "cmb_helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/CMB.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/CMB.dmi',
	)
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_LOW
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	built_in_visors = list(new /obj/item/device/helmet_visor/security)

/obj/item/clothing/head/helmet/marine/veteran/cmb/engi
	built_in_visors = list(new /obj/item/device/helmet_visor/security, new /obj/item/device/helmet_visor/welding_visor)

/obj/item/clothing/head/helmet/marine/veteran/cmb/spec
	name = "M11R-S pattern CMB SWAT helmet"
	icon_state = "cmb_elite_helmet"
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	built_in_visors = list(new /obj/item/device/helmet_visor/security, new /obj/item/device/helmet_visor/night_vision)


//==========================//DISTRESS\\=================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/dutch
	name = "\improper Dutch's Dozen helmet"
	desc = "A protective helmet worn by some seriously experienced mercs."
	icon_state = "dutch_helmet"
	icon = 'icons/obj/items/clothing/hats/misc_ert_colony.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/misc_ert_colony.dmi',
	)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/dutch/cap
	name = "\improper Dutch's Dozen cap"
	desc = "A protective cap worn by some seriously experienced mercs."
	icon_state = "dutch_cap"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/dutch/band
	name = "\improper Dutch's Dozen band"
	desc = "A protective band worn by some seriously experienced mercs."
	icon_state = "dutch_band"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

// UPP Are very powerful against bullets (marines) but middling against melee (xenos)
/obj/item/clothing/head/helmet/marine/veteran/UPP
	name = "\improper UM4 helmet"
	desc = "Using highly skilled manufacturing techniques this UM4 helmet manages to be very resistant to ballistics damage, at the cost of its huge weight causing an extreme stress on the occupant's head that will most likely cause neck problems."
	icon_state = "upp_helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UPP.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UPP.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	clothing_traits = list(TRAIT_EAR_PROTECTION) //the sprites clearly fully cover the ears and most of the head

/obj/item/clothing/head/helmet/marine/veteran/UPP/engi
	name = "\improper UM4-V helmet"
	desc = "This version of the UM4 helmet has a ballistic-glass visor, allowing for the UPP Engineers to safely weld, but by some reports hindering sight in the process."
	icon_state = "upp_helmet_engi"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	var/protection_on = TRUE

/obj/item/clothing/head/helmet/marine/veteran/UPP/heavy
	name = "\improper UH7 helmet"
	desc = "Like the UM4, this helmet is very resistant to ballistic damage, but both its flaws and benefits have been doubled. The few UPP Zhergeants that have lived past age 30 have all needed to retire from terminal neck problems caused from the stress of wearing this helmet."
	icon_state = "upp_helmet_heavy"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

/obj/item/clothing/head/uppcap
	name = "\improper UL2 UPP cap"
	desc = "UPP headgear issued to soldiers when they're not expected to face combat, and may be requested by officers and above."
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UPP.dmi'
	icon_state = "upp_cap"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UPP.dmi'
	)
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/uppcap/civi
	name = "\improper UL2 UPP cap"
	desc = "UPP civilian headgear. It's of poor quality, and isn't expected to last all that long, however for as long as it's whole, it appears quite stylish."
	icon_state = "upp_cap_civi"

/obj/item/clothing/head/uppcap/beret
	name = "\improper UL3 UPP beret"
	icon_state = "upp_beret"

/obj/item/clothing/head/uppcap/peaked
	name = "\improper UL3 UPP peaked cap"
	desc = "UPP headgear issued to Kapitans and above. It is made of high-quality materials, and has the officers rank in gold placed upon the front of the cap."
	icon_state = "upp_peaked"

/obj/item/clothing/head/uppcap/ushanka
	name = "\improper UL8 UPP ushanka"
	icon_state = "upp_ushanka"
	item_state = "upp_ushanka"
	var/tied = FALSE
	var/original_state = "upp_ushanka"

/obj/item/clothing/head/uppcap/ushanka/verb/flaps_up()
	set name = "Tie Up/Down"
	set category = "Object"
	set src in usr
	if(usr.is_mob_incapacitated())
		return

	tied = !tied
	if(tied)
		to_chat(usr, SPAN_NOTICE("You tie \the [src] up."))
		icon_state += "_up"
	else
		to_chat(usr, SPAN_NOTICE("You untie \the [src]."))
		icon_state = original_state



	update_clothing_icon(src) //Update the on-mob icon.



/obj/item/clothing/head/uppcap/ushanka/civi
	name = "\improper UL8c UPP ushanka"
	icon_state = "upp_ushanka_civi"
	item_state = "upp_ushanka_civi"
	original_state = "upp_ushanka_civi"

/obj/item/clothing/head/helmet/marine/veteran/van_bandolier
	name = "pith helmet"
	desc = "A stylish pith helmet, made from space-age materials. Lightweight, breathable, cool, and protective."
	icon_state = "van_bandolier"
	item_state = "s_helmet"
	icon = 'icons/obj/items/clothing/hats/misc_ert_colony.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/misc_ert_colony.dmi',
	)
	flags_marine_helmet = NO_FLAGS


//head rag

/obj/item/clothing/head/helmet/specrag
	name = "weapons specialist head-rag"
	desc = "A hat worn by heavy-weapons operators to block sweat."
	icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
	icon_state = "spec"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)

/obj/item/clothing/head/helmet/specrag/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/classic.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/desert.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/snow.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/urban.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/urban.dmi'


/obj/item/clothing/head/helmet/specrag/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)

/obj/item/clothing/head/helmet/skullcap
	name = "skullcap"
	desc = "Good for keeping sweat out of your eyes"
	icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
	icon_state = "skullcap"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)

/obj/item/clothing/head/helmet/skullcap/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)

/obj/item/clothing/head/helmet/skullcap/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/jungle.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/classic.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/desert.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/snow.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/hats/hats_by_map/urban.dmi'
			item_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/head/hats_by_map/urban.dmi'


/obj/item/clothing/head/helmet/skullcap/jungle
	name = "\improper M8 marksman cowl"
	desc = "A cowl worn to conceal the face of a marksman in the jungle."
	icon_state = "skullcapm"

/obj/item/clothing/head/helmet/skullcap/jungle/New(loc, type,
	new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT))
	select_gamemode_skin(type, override_protection = new_protection)
	..()
	switch(icon_state)
		if("s_skullcapm")
			desc = "A hood meant to protect the wearer from both the cold and the guise of the enemy in the tundra."
			flags_inv_hide = HIDEEARS|HIDEALLHAIR

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/mercenary
	name = "\improper K12 ceramic helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_heavy_helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/CLF.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/CLF.dmi'
	)
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/mercenary
	name = "\improper Modified K12 ceramic helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group. Reinforced with extra plating."
	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGHPLUS

/obj/item/clothing/head/helmet/marine/veteran/mercenary/miner
	name = "\improper Y8 miner helmet"
	desc = "A sturdy helmet, specialised for mining, worn by an unknown mercenary group."
	icon_state = "mercenary_miner_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS


/obj/item/clothing/head/helmet/marine/veteran/mercenary/support
	name = "\improper Z7 helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_engineer_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

/obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer
	desc = "A sturdy helmet worn by an unknown mercenary group. Features a toggleable welding screen for eye protection."
	built_in_visors = list(new /obj/item/device/helmet_visor/welding_visor/mercenary)

//=============================//MEME\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/specialist/hefa
	name = "\improper HEFA helmet"
	specialty = "HEFA"
	desc = "For some reason, seeing this helmet causes you to feel extremely distressed."
	icon_state = "hefa_helmet"
	item_state = "hefa_helmet"
	icon = 'icons/obj/items/clothing/hats/misc_ert_colony.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/misc_ert_colony.dmi',
	)
	armor_bomb = CLOTHING_ARMOR_HARDCORE // the hefa knight stands
	flags_inv_hide = HIDEEARS|HIDEALLHAIR|HIDEEYES
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_GIGAHIGH

	built_in_visors = list()

	var/mob/activator = null
	var/active = FALSE
	var/det_time = 40

/obj/item/clothing/head/helmet/marine/specialist/hefa/Initialize(mapload, list/new_protection)
	. = ..()
	pockets.bypass_w_limit = list(/obj/item/explosive/grenade/high_explosive/frag)

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)

/obj/item/clothing/head/helmet/marine/specialist/hefa/attack_self(mob/user)
	..()
	activator = user
	activate()

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/activate()
	if(active)
		return
	active = TRUE

	icon_state = initial(icon_state) + "_active"
	item_state = initial(item_state) + "_active"
	overlays += /obj/effect/overlay/danger
	playsound(loc, 'sound/weapons/armbomb.ogg', 25, 1, 6)

	addtimer(CALLBACK(src, PROC_REF(prime)), det_time)

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/prime()
	INVOKE_ASYNC(src, PROC_REF(boom))

// Values nabbed from the HEFA nade
/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/boom()
	// TODO: knock down user so the shrapnel isn't all taken by the user
	var/datum/cause_data/cause_data = create_cause_data(initial(name), activator)
	create_shrapnel(loc, 48, , ,/datum/ammo/bullet/shrapnel, cause_data)
	sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(loc, 40, 18, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	qdel(src)

/obj/item/clothing/head/helmet/marine/reporter
	name = "press helmet"
	desc = "A helmet designed to make it clear that the wearer is safety aware and not looking for a fight."
	icon_state = "cc_helmet"
	item_state = "cc_helmet"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/urban_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/urban_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_L_HAND = "helmet",
		WEAR_R_HAND = "helmet"
	)
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/cbrn_hood
	name = "\improper M3 MOPP mask"
	desc = "The M3 MOPP mask includes a full covering cowl that securely attaches to the MOPP suit. The mask filters out harmful particles in the air to allow the wearer to breathe safely in the field. Depending on the hostility of the contaminated area the mask’s filter will last an average of 12 hours or less."
	icon_state = "cbrn_hood"
	item_state = "cbrn_hood"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/UA.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/UA.dmi',
	)
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROT
	flags_cold_protection = BODY_FLAG_HEAD
	flags_heat_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_ULTRAHIGHPLUS
	force = 0 //"The M3 MOPP mask would be a normal weapon if you were to hit someone with it."
	throwforce = 0
	flags_inventory = BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/cbrn_hood/advanced
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS

//=ROYAL MARINES=\\

/obj/item/clothing/head/helmet/marine/veteran/royal_marine
	name = "\improper L5A2 ballistic helmet"
	desc = "A High-cut ballistic helmet. Designed by Lindenthal-Ehrenfeld Militärindustrie it is intended to be used by Royal Marines Commando as part of the kestrel armour system."
	icon_state = "rmc_helm1"
	item_state = "rmc_helm1"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/TWE.dmi'
	)
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	built_in_visors = list(new /obj/item/device/helmet_visor/medical)
	start_down_visor_type = /obj/item/device/helmet_visor/medical


/obj/item/clothing/head/helmet/marine/veteran/royal_marine/breacher
	name = "\improper L5A3 ballistic helmet"
	desc = "A High-cut ballistic helmet featuring an attached mandible. Designed by Lindenthal-Ehrenfeld Militärindustrie it is intended to be used by Royal Marines Commando as part of the kestrel armour system"
	icon_state = "rmc_helm_br"
	item_state = "rmc_helm_br"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/head/helmet/marine/veteran/royal_marine/medic
	name = "\improper L5A2 ballistic medic helmet"
	desc = "A High-cut ballistic helmet. Designed by Lindenthal-Ehrenfeld Militärindustrie it is intended to be used by Royal Marines Commando as part of the kestrel armour system. This one comes with an advanced medical HUD and a dark-green patch on the back, denoting that the wearer is a corpsman."
	icon_state = "rmc_helm_medic"
	item_state = "rmc_helm_medic"
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/advanced)
	start_down_visor_type = /obj/item/device/helmet_visor/medical/advanced
