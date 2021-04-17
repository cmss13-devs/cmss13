#define HELMET_GARB_RELAY_ICON_STATE "icon_state"
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
	min_cold_protection_temperature = HELMET_min_cold_protection_temperature
	max_heat_protection_temperature = HELMET_max_heat_protection_temperature
	siemens_coefficient = 0.7
	w_class = SIZE_MEDIUM



/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks. It covers your ears."
	icon_state = "riot"
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

/obj/item/clothing/head/helmet/HoS
	name = "Head of Security Hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS
	flags_armor_protection = 0
	siemens_coefficient = 0.8

/obj/item/clothing/head/helmet/HoS/dermal
	name = "Dermal Armour Patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	item_state = "dermal"
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a securiy force. Protects the head from impacts."
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

/obj/item/clothing/head/helmet/formalcaptain
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"
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
	min_cold_protection_temperature = SPACE_HELMET_min_cold_protection_temperature
	siemens_coefficient = 0.5
	anti_hug = 1

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	item_state = "thunderdome"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_min_cold_protection_temperature
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	item_state = "gladiator"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEALLHAIR
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	item_state = "helmet"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	anti_hug = 1
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0.7


//===========================//MARINES HELMETS\\=================================\\
//=======================================================================\\

GLOBAL_LIST_INIT(allowed_helmet_items, list(
	///// TOBACCO-RELATED
	/obj/item/tool/lighter/random = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/tool/lighter/zippo = "helmet_lighter_zippo",
	/obj/item/storage/box/matches = "helmet_matches",
	/obj/item/storage/fancy/cigarettes/emeraldgreen = "helmet_cig_cig",
	/obj/item/storage/fancy/cigarettes/kpack = "helmet_cig_kpack",
	/obj/item/storage/fancy/cigarettes/lucky_strikes = "helmet_cig_ls",
	/obj/item/storage/fancy/cigarettes/wypacket = "helmet_cig_wypack",
	/obj/item/storage/fancy/cigarettes/lady_finger = "helmet_cig_lf",
	/obj/item/storage/fancy/cigarettes/blackpack = "helmet_cig_blackpack",
	/obj/item/storage/fancy/cigarettes/arcturian_ace = "helmet_cig_aapack",

	///// CARDS
	/obj/item/toy/deck = "helmet_card_card",
	/obj/item/toy/handcard = "helmet_card_card",
	/obj/item/toy/handcard/aceofspades = "ace_of_spades",
	/obj/item/toy/handcard/uno_reverse_red = "red_reverse",
	/obj/item/toy/handcard/uno_reverse_blue = "blue_reverse",
	/obj/item/toy/handcard/uno_reverse_yellow = "yellow_reverse",
	/obj/item/toy/handcard/uno_reverse_purple = "purple_reverse",

	///// FOOD AND SNACKS
	/obj/item/reagent_container/food/drinks/flask = "helmet_flask",
	/obj/item/reagent_container/food/drinks/flask/marine = "helmet_flask",
	/obj/item/reagent_container/food/snacks/eat_bar = "helmet_snack_eat",
	/obj/item/reagent_container/food/snacks/packaged_burrito = "helmet_snack_burrito",
	/obj/item/reagent_container/food/snacks/mushroompizzaslice = "pizza", // Fuck whoever put these under different paths for some REASON
	/obj/item/reagent_container/food/snacks/vegetablepizzaslice = "pizza",
	/obj/item/reagent_container/food/snacks/meatpizzaslice = "pizza",
	/obj/item/reagent_container/food/snacks/packaged_burrito = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/reagent_container/food/snacks/packaged_hdogs = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/reagent_container/food/snacks/wrapped/chunk = "chunkbox",
	/obj/item/reagent_container/food/snacks/donkpocket = "donkpocket",
	/obj/item/reagent_container/food/snacks/wrapped/booniebars = "boonie-bars",
	/obj/item/reagent_container/food/snacks/wrapped/barcardine = "barcardine-bars",


	///// EYEWEAR
	/obj/item/clothing/glasses/mgoggles = "goggles-h",
	/obj/item/clothing/glasses/mgoggles/prescription = "goggles-h",
	/obj/item/clothing/glasses/sunglasses = "sunglasses",
	/obj/item/clothing/glasses/sunglasses/prescription = "sunglasses",
	/obj/item/clothing/glasses/sunglasses/aviator = "aviator",
	/obj/item/clothing/glasses/sunglasses/big = "bigsunglasses",
	/obj/item/clothing/glasses/sunglasses/sechud = "sechud",
	/obj/item/clothing/glasses/eyepatch = "eyepatch",
	/obj/item/clothing/glasses/regular/hipster = "persc-glasses",

	///// WALKMAN AND CASSETTES
	/obj/item/device/walkman = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/device/cassette_tape/pop1 = "cassette_blue",
	/obj/item/device/cassette_tape/pop2 = "cassette_rainbow",
	/obj/item/device/cassette_tape/pop3 = "cassette_orange",
	/obj/item/device/cassette_tape/pop4 = "cassette_pink_stripe",
	/obj/item/device/cassette_tape/heavymetal = "cassette_red_black",
	/obj/item/device/cassette_tape/hairmetal = "cassette_red_stripe",
	/obj/item/device/cassette_tape/indie = "cassette_rising_sun",
	/obj/item/device/cassette_tape/hiphop = "cassette_orange_blue",
	/obj/item/device/cassette_tape/nam = "cassette_green",
	/obj/item/device/cassette_tape/ocean = "cassette_ocean",

	///// PREFERENCES GEAR
	/obj/item/prop/helmetgarb/gunoil = "gunoil",
	/obj/item/prop/helmetgarb/netting = "netting",
	/obj/item/prop/helmetgarb/spent_buckshot = "spent_buckshot",
	/obj/item/prop/helmetgarb/spent_slug = "spent_slug",
	/obj/item/prop/helmetgarb/spent_flech = "spent_flech",
	/obj/item/prop/helmetgarb/prescription_bottle = "prescription_bottle",
	/obj/item/prop/helmetgarb/raincover = "raincover",
	/obj/item/prop/helmetgarb/rabbitsfoot = "rabbitsfoot",
	/obj/item/prop/helmetgarb/rosary = "helmet_rosary", // This one was already in the game for some reason, but never had an object
	/obj/item/prop/helmetgarb/lucky_feather = "lucky_feather",
	/obj/item/prop/helmetgarb/lucky_feather/blue = "lucky_feather_blue",
	/obj/item/prop/helmetgarb/lucky_feather/purple = "lucky_feather_purple",
	/obj/item/prop/helmetgarb/lucky_feather/yellow = "lucky_feather_yellow",
	/obj/item/prop/helmetgarb/trimmed_wire = "trimmed_wire",
	/obj/item/prop/helmetgarb/helmet_nvg = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/helmet_nvg/functional = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/helmet_gasmask = "helmet_gasmask",
	/obj/item/prop/helmetgarb/flair_initech = "flair_initech",
	/obj/item/prop/helmetgarb/helmet_gasmask = "helmet_gasmask",
	/obj/item/prop/helmetgarb/flair_io = "flair_io",
	/obj/item/prop/helmetgarb/flair_peace ="flair_peace_smiley",
	/obj/item/prop/helmetgarb/flair_uscm = "flair_uscm",
	/obj/item/prop/helmetgarb/bullet_pipe = "bullet_pipe",
	/obj/item/prop/helmetgarb/spacejam_tickets = "tickets_to_space_jam",

	///// MISC
	/obj/item/tool/pen = "helmet_pen_black",
	/obj/item/tool/pen/blue = "helmet_pen_blue",
	/obj/item/tool/pen/red = "helmet_pen_red",
	/obj/item/clothing/glasses/welding ="welding-h",
	/obj/item/clothing/head/headband = "headbandgreen",
	/obj/item/clothing/head/headband/tan = "headbandtan",
	/obj/item/clothing/head/headband/red = "headbandred",
	/obj/item/tool/candle = "candle",
	/obj/item/clothing/mask/facehugger/lamarr = "lamarr",
	/obj/item/toy/crayon/red = "crayonred",
	/obj/item/toy/crayon/orange = "crayonorange",
	/obj/item/toy/crayon/yellow = "crayonyellow",
	/obj/item/toy/crayon/green = "crayongreen",
	/obj/item/toy/crayon/blue = "crayonblue",
	/obj/item/toy/crayon/purple = "crayonpurple",
	/obj/item/toy/crayon/rainbow = "crayonrainbow",
	/obj/item/paper = "paper",
	/obj/item/device/flashlight/flare = "flare",
	/obj/item/clothing/head/headset = "headset",
	/obj/item/clothing/accessory/patch = "uscmpatch",
	/obj/item/clothing/accessory/patch/falcon = "falconspatch",
	/obj/item/ammo_magazine/handful = "bullet",
	/obj/item/prop/helmetgarb/riot_shield = "helmet_riot_shield",

	///// MEDICAL
	/obj/item/stack/medical/bruise_pack ="brutepack",
	/obj/item/stack/medical/ointment = "ointment",
	/obj/item/tool/surgery/scalpel = "scalpel",
	/obj/item/reagent_container/hypospray/autoinjector = "helmet_injector"
))

/obj/item/clothing/head/helmet/marine
	name = "\improper M10 pattern marine helmet"
	desc = "A standard M10 Pattern Helmet. The inside label, along with washing information, reads, 'The difference between an open-casket and closed-casket funeral. Wear on head for best results.'. There is a built-in camera on the right side."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	health = 5
	force = 15
	throwforce = 15 // https://i.imgur.com/VW09I4B.gif
	attack_verb = list("whacked", "hit", "smacked", "beaten", "battered")
	var/obj/structure/machinery/camera/camera
	var/helmet_overlays[]
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS
	var/flags_marine_helmet = HELMET_SQUAD_OVERLAY|HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY|HELMET_STORE_GARB
	var/obj/item/storage/internal/pockets
	var/helmet_bash_cooldown = 0

	var/specialty = "M10 pattern marine" //Give them a specialty var so that they show up correctly in vendors.
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

	//speciality does NOTHING if you have NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/New(loc,
	new_protection[]	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += " snow helmet"
		else
			name += " helmet"

	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type,null,new_protection)

	helmet_overlays = list() //To make things simple.
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 2
	pockets.max_w_class = SIZE_TINY //can hold tiny items only, EXCEPT for glasses & metal flask.
	pockets.bypass_w_limit = GLOB.allowed_helmet_items
	pockets.max_storage_space = 3

	camera = new /obj/structure/machinery/camera(src)
	camera.network = list("Overwatch")

	..()

/obj/item/clothing/head/helmet/marine/Destroy(force)
	helmet_overlays = null
	QDEL_NULL(camera)
	QDEL_NULL(pockets)
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

/obj/item/clothing/head/helmet/marine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine) && world.time > helmet_bash_cooldown)
		var/obj/item/ammo_magazine/M = W
		var/ammo_level = "somewhat"
		playsound(user, 'sound/items/trayhit1.ogg', 15, FALSE)
		if(M.current_rounds > (M.max_rounds/2))
			ammo_level = "more than half full."
		if(M.current_rounds < (M.max_rounds/2))
			ammo_level = "less than half full."
		if(M.current_rounds < (M.max_rounds/6))
			ammo_level = "almost empty."
		if(M.current_rounds == 0)
			ammo_level = "empty. Uh oh."
		user.visible_message("[user] bashes [M] against their helmet", "You bash [M] against your helmet. It is [ammo_level]")
		helmet_bash_cooldown = world.time + 20 SECONDS
	else
		..()
		return pockets.attackby(W, user)

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
	if(pockets && pockets.contents.len && (flags_marine_helmet & HELMET_GARB_OVERLAY))
		helmet_overlays += "helmet_band"
		for(var/obj/O in pockets.contents)
			if(GLOB.allowed_helmet_items[O.type])
				if(GLOB.allowed_helmet_items[O.type] == HELMET_GARB_RELAY_ICON_STATE)
					helmet_overlays += O.icon_state
				else
					helmet_overlays += GLOB.allowed_helmet_items[O.type]

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

/obj/item/clothing/head/helmet/marine/equipped(var/mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
	..()

/obj/item/clothing/head/helmet/marine/dropped(var/mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "Unknown"
	..()


/obj/item/clothing/head/helmet/marine/proc/add_hugger_damage() //This is called in XenoFacehuggers.dm to first add the overlay and set the var.
	if(flags_marine_helmet & HELMET_DAMAGE_OVERLAY && !(flags_marine_helmet & HELMET_IS_DAMAGED))
		helmet_overlays["damage"] = image('icons/obj/items/clothing/cm_hats.dmi',icon_state = "hugger_damage")
		flags_marine_helmet |= HELMET_IS_DAMAGED
		update_icon()
		desc += "\n<b>This helmet seems to be scratched up and damaged, particularly around the face area...</b>"



/obj/item/clothing/head/helmet/marine/tech
	name = "\improper M10 technician helmet"
	desc = "A modified M10 marine helmet for squad engineers. Features a toggleable welding screen for eye protection."
	icon_state = "tech_helmet"
	specialty = "M10 technician"
	var/protection_on = FALSE
	///To remember the helmet's map variant-adjusted icon state
	var/base_icon_state

	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/head/helmet/marine/tech/Initialize()
	. = ..()
	base_icon_state = icon_state

/obj/item/clothing/head/helmet/marine/tech/attack_self()
	toggle()

/obj/item/clothing/head/helmet/marine/tech/verb/toggle()
	set category = "Object"
	set name = "Toggle Tech Helmet"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.is_mob_restrained())
		if(protection_on)
			flags_inventory &= ~(COVEREYES|COVERMOUTH)
			flags_inv_hide &= ~(HIDEEYES|HIDEFACE)
			icon_state = base_icon_state
			eye_protection = 0
			to_chat(usr, "You <b>deactivate</b> the [src]'s welding screen.")
		else
			flags_inventory |= COVEREYES|COVERMOUTH
			flags_inv_hide |= HIDEEYES|HIDEFACE
			icon_state = "[base_icon_state]_on"
			eye_protection = 2
			to_chat(usr, "You <b>activate</b> the [src]'s welding screen.")

		protection_on = !protection_on

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.head == src)
				H.update_tint()

		update_clothing_icon()	//so our mob-overlays update

		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()

/obj/item/clothing/head/helmet/marine/medic
	name = "\improper M10 medic helmet"
	desc = "An M10 marine helmet version worn by squad medics. Has red cross painted on its front."
	icon_state = "med_helmet"
	specialty = "M10 medic"

/obj/item/clothing/head/helmet/marine/leader
	name = "\improper M11 pattern leader helmet"
	desc = "A slightly fancier helmet for marine leaders. This one contains a small built-in camera and has cushioning to project your fragile brain."
	icon_state = "sl_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "M11 pattern leader"

/obj/item/clothing/head/helmet/marine/rto
	name = "\improper XM12 pattern radio operator helmet"
	desc = "An experimental brain-bucket. A dust ruffle hangs from back. Moderately better at deflecting blunt objects at the cost of humiliation. But who will be laughing at the memorial? Not you, you'll be busy getting medals for your IMPORTANT phone calls."
	icon_state = "io"
	item_state = "io"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "XM12 pattern radio operator"

/obj/item/clothing/head/helmet/marine/specialist
	name = "\improper B18 helmet"
	desc = "The B18 Helmet that goes along with the B18 Defensive Armor. It's heavy, reinforced, and protects more of the face."
	icon_state = "grenadier_helmet"
	item_state = "grenadier_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
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
	desc = "Pairs with the M3-G4 heavy grenadier plating. A distant cousin of the experimental B18 defensive helmet."
	icon_state = "grenadier_helmet"
	item_state = "grenadier_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	unacidable = TRUE
	anti_hug = 6
	specialty = "M3-G4 grenadier"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/head/helmet/marine/scout
	name = "\improper M3-S light helmet"
	icon_state = "scout_helmet"
	desc = "A custom helmet designed for USCM Scouts."
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	specialty = "M3-S light"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/head/helmet/marine/pyro
	name = "\improper M35 pyrotechnician helmet"
	icon_state = "pyro_helmet"
	desc = "A helmet designed for USCM Pyrotechnicians."
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	max_heat_protection_temperature = FIRESUIT_max_heat_protection_temperature
	specialty = "M35 pyrotechnician"
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/head/helmet/marine/pilot
	name = "\improper M30 tactical helmet"
	desc = "The M30 tactical helmet has an left eyepiece filter used to filter tactical data. It is required to fly the dropships manually and in safety."
	icon_state = "helmetp"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	specialty = "M30 tactical"

/obj/item/clothing/head/helmet/marine/tanker
	name = "\improper M50 tanker helmet"
	desc = "The lightweight M50 tanker helmet is designed for use by armored crewmen in the USCM. It offers low weight protection, and allows agile movement inside the confines of an armored vehicle."
	icon_state = "tanker_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	specialty = "M50 tanker"

/obj/item/clothing/head/helmet/marine/ghillie
	name = "\improper M45 ghillie helmet"
	desc = "A lightweight M45 helmet with ghillie coif used by USCM snipers on recon missions."
	icon_state = "ghillie_coif"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	flags_marine_helmet = NO_FLAGS
	flags_item = MOB_LOCK_ON_EQUIP
	specialty = "M45 ghillie"

/obj/item/clothing/head/helmet/marine/CO
	name = "\improper M10 pattern captain helmet"
	desc = "A special M10 Pattern Helmet worn by Captains of the USCM. It reads on the label, 'The difference between an open-casket and closed-casket funeral. Wear on head for best results.'."
	icon_state = "co_officer"
	item_state = "co_officer"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "M10 pattern captain"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/MP
	name = "\improper M10 pattern Military Police Helmet"
	desc = "A special variant of the M10 Pattern Helmet worn by the Military Police of the USCM. Whether you're facing a crime syndicate or a mutiny, this bucket will keep your brains intact."
	icon_state = "mp_helmet"
	item_state = "mp_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "M10 pattern military police"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/mp/provost/marshall
	name = "\improper Provost Marshall Cap"
	desc = "The expensive headwear of a Provost Marshall. Contains shards of kevlar to keep it's valuable contents safe."
	icon_state = "pvmarshalhat"
	item_state = "pvmarshalhat"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/marsoc
	name = "\improper MARSOC Operator Helmet"
	desc = "A special variant of the M10 Pattern Helmet worn by MARSOC operators. Fitted for quad NODs."
	icon_state = "marsoc_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "M10 pattern MARSOC"
	flags_atom = NO_SNOW_TYPE


//=============================//PMCS\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make these keep their name and icon.

/obj/item/clothing/head/helmet/marine/veteran/PMC
	name = "\improper PMC tactical cap"
	desc = "A protective cap made from flexible kevlar. Standard issue for most security forms in the place of a helmet."
	icon_state = "pmc_hat"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/PMC/leader
	name = "\improper PMC beret"
	desc = "The pinacle of fashion for any aspiring mercenary leader. Designed to protect the head from light impacts."
	icon_state = "officer_hat"

/obj/item/clothing/head/helmet/marine/veteran/PMC/sniper
	name = "\improper PMC sniper helmet"
	desc = "A helmet worn by PMC Marksmen"
	icon_state = "pmc_sniper_hat"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/PMC/gunner
	name = "\improper PMC gunner helmet"
	desc = "A modification of the standard Armat Systems M3 armor."
	icon_state = "heavy_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/PMC/commando
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
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	unacidable = TRUE

//FIORINA / UA RIOT CONTROL HELMET//

/obj/item/clothing/head/helmet/marine/veteran/ua_riot
	name = "\improper RC6 helmet"
	desc = "The standard UA Riot Control 6 helmet is of odd design, lacking a face shield by default (mounting points are available). The distinct white pattern and red emblem are synonymous with oppression throughout the rim."
	icon_state = "ua_riot"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	specialty = "RC6 helmet"
	flags_atom = NO_SNOW_TYPE

//==========================//DISTRESS\\=================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/dutch
	name = "\improper Dutch's Dozen helmet"
	desc = "A protective helmet worn by some seriously experienced mercs."
	icon_state = "dutch_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY|HELMET_STORE_GARB

/obj/item/clothing/head/helmet/marine/veteran/dutch/cap
	name = "\improper Dutch's Dozen cap"
	desc = "A protective cap worn by some seriously experienced mercs."
	icon_state = "dutch_cap"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/dutch/band
	name = "\improper Dutch's Dozen band"
	desc = "A protective band worn by some seriously experienced mercs."
	icon_state = "dutch_band"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/bear
	name = "\improper Iron Bear helmet"
	desc = "Is good for winter, because it has hole to put vodka through."
	icon_state = "dutch_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY|HELMET_STORE_GARB

// UPP Are very powerful against bullets (marines) but middling against melee (xenos)
/obj/item/clothing/head/helmet/marine/veteran/UPP
	name = "\improper UM4 helmet"
	desc = "Using highly skilled manufacturing techniques this UM4 helmet manages to be very resistant to ballistics damage, at the cost of its huge weight causing an extreme stress on the occupant's head that will most likely cause neck problems."
	icon_state = "upp_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature

/obj/item/clothing/head/helmet/marine/veteran/UPP/V
	name = "\improper UM4-V helmet"
	desc = "This version of the UM4 helmet has a ballistic-glass visor, increasing resistance against attacks significantly but by some reports hindering sight in the process."
	icon_state = "upp_helmet_visor"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/head/helmet/marine/veteran/UPP/heavy
	name = "\improper UH7 helmet"
	desc = "Like the UM4, this helmet is very resistant to ballistic damage, but both its flaws and benefits have been doubled. The few UPP Zhergeants that have lived past age 30 have all needed to retire from terminal neck problems caused from the stress of wearing this helmet."
	icon_state = "upp_helmet_heavy"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

/obj/item/clothing/head/uppcap
	name = "\improper UL2 UPP cap"
	desc = "UPP headgear issued to soldiers when they're not expected to face combat, and may be requested by officers and above."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_cap"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	siemens_coefficient = 2.0
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
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/uppcap/beret
	name = "\improper UL3 UPP beret"
	icon_state = "upp_beret"

/obj/item/clothing/head/uppcap/ushanka
	name = "\improper UL8 UPP ushanka"
	icon_state = "upp_ushanka"
	actions_types = list(/datum/action/item_action/toggle)
	var/flaps_up = FALSE

/obj/item/clothing/head/uppcap/ushanka/attack_self(mob/user)
	if(flaps_up)
		to_chat(user, SPAN_INFO("You move the ear flaps back."))
		icon_state = "upp_ushanka"
		flaps_up = FALSE
	else
		to_chat(user, SPAN_INFO("You move the ear flaps out of the way."))
		icon_state = "upp_ushanka_u"
		flaps_up = TRUE
	update_icon()

//head rag

/obj/item/clothing/head/helmet/specrag
	name = "specialist head-rag"
	desc = "A hat worn by heavy-weapons operators to block sweat."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "spec"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/helmet/specrag/New()
	select_gamemode_skin(type)
	..()

/obj/item/clothing/head/helmet/durag
	name = "durag"
	desc = "Good for keeping sweat out of your eyes"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "durag"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/helmet/durag/jungle
	name = "\improper M8 marksman cowl"
	desc = "A cowl worn to conceal the face of a marksman in the jungle."
	icon_state = "duragm"

/obj/item/clothing/head/helmet/durag/jungle/New(loc, type,
	new_protection[] 	= list(MAP_ICE_COLONY = ICE_PLANET_min_cold_protection_temperature))
	select_gamemode_skin(type,, new_protection)
	..()
	switch(icon_state)
		if("s_duragm")
			desc = "A hood meant to protect the wearer from both the cold and the guise of the enemy in the tundra."
			flags_inventory = BLOCKSHARPOBJ
			flags_inv_hide = HIDEEARS|HIDEALLHAIR

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/mercenary
	name = "\improper K12 ceramic helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_heavy_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/mercenary/miner
	name = "\improper Y8 miner helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_miner_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM


/obj/item/clothing/head/helmet/marine/veteran/mercenary/engineer
	name = "\improper Z7 engineer helmet"
	desc = "A sturdy helmet worn by an unknown mercenary group."
	icon_state = "mercenary_engineer_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

//=============================//MEME\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/specialist/hefa
	name = "\improper HEFA helmet"
	specialty = "HEFA"
	desc = "For some reason, seeing this helmet causes you to feel extremely distressed."
	icon_state = "hefa_helmet"
	item_state = "hefa_helmet"
	armor_bomb = CLOTHING_ARMOR_HARDCORE // the hefa knight stands
	flags_inv_hide = HIDEEARS|HIDEALLHAIR|HIDEEYES
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE

	var/mob/activator = null
	var/active = FALSE
	var/det_time = 40

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)
	return

/obj/item/clothing/head/helmet/marine/specialist/hefa/attack_self(var/mob/user)
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

	addtimer(CALLBACK(src, .proc/prime), det_time)

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/prime()
	INVOKE_ASYNC(src, .proc/boom)

// Values nabbed from the HEFA nade
/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/boom()
	// TODO: knock down user so the shrapnel isn't all taken by the user
	create_shrapnel(loc, 48, , ,/datum/ammo/bullet/shrapnel, initial(name), activator)
	sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(loc, 40, 18, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), activator)
	qdel(src)


#undef HELMET_GARB_RELAY_ICON_STATE
