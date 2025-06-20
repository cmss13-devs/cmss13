/*
 * Job related
 */

//Botonist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	icon = 'icons/obj/items/clothing/suits/vests_aprons.dmi'
	blood_overlay_type = "armor"
	flags_armor_protection = 0
	allowed = list (
		/obj/item/reagent_container/spray/plantbgone,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/seeds,/obj/item/reagent_container/glass/fertilizer,
		/obj/item/tool/minihoe,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/vests_aprons.dmi',
	)

//Cultist
/obj/item/clothing/suit/cultist_hoodie
	name = "black robe"
	desc = "Looks eerie and weird, almost as if it belongs to a cult."
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN

	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT

	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

	armor_bio = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW

	slowdown = SLOWDOWN_ARMOR_LIGHT
	time_to_equip = 2 SECONDS

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDESHOES|HIDEJUMPSUIT
	allowed = list(
		/obj/item/weapon/gun,
	)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

//Chef
/obj/item/clothing/suit/chef
	name = "Chef's apron"
	desc = "An apron used by a high-class chef."
	icon_state = "chef"
	item_state = "chef"
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	gas_transfer_coefficient = 0.90

	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	allowed = list (
		/obj/item/tool/kitchen/knife,
		/obj/item/tool/kitchen/knife/butcher,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
	)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "A classic chef's apron"
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	icon = 'icons/obj/items/clothing/suits/vests_aprons.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/vests_aprons.dmi',
	)
	blood_overlay_type = "armor"
	flags_armor_protection = 0
	allowed = list (
		/obj/item/tool/kitchen/knife,
		/obj/item/tool/kitchen/knife/butcher,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)

/obj/item/clothing/suit/chef/classic/stain
	icon_state = "apronchef_stain"
	item_state = "apronchef_stain"

//Detective
/obj/item/clothing/suit/storage/CMB/trenchcoat
	name = "\improper tan trench-coat"
	desc = "A worn, tan, old style trench-coat. A classic of noir style apparel."
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
	)
	icon_state = "trench_tan"
	item_state = "trench_tan"
	uniform_restricted = null

/obj/item/clothing/suit/storage/CMB/trenchcoat/brown

	name = "\improper brown trench-coat"
	desc = "A worn, brown, old style trench-coat. When a bum sees a dick coming, he don't stick around."
	icon_state = "trench_brown"
	item_state = "trench_brown"

/obj/item/clothing/suit/storage/CMB/trenchcoat/grey
	name = "\improper grey trench-coat"
	desc = "A worn, brown, old style trench-coat. When a bum sees a dick coming, he don't stick around."
	icon_state = "trench_grey"
	item_state = "trench_grey"

/obj/item/clothing/suit/storage/CMB/trenchcoat/police
	name = "\improper tan police trench-coat"
	desc = "A light tan coat with a badge. Often worn by government officiated crime scene investigators rather than private sleuths, this suit strikes authority into those who see it."
	icon_state = "detective"
	item_state = "detective"

/obj/item/clothing/suit/storage/CMB/trenchcoat/police/black
	name = "\improper black police trench-coat"
	desc = "A light black coat with a badge. Often worn by government officiated crime scene investigators rather than private sleuths, this suit strikes authority into those who see it."
	icon_state = "detective2"
	item_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	item_state = "det_suit"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/device/analyzer,
		/obj/item/device/multitool,
		/obj/item/device/pipe_painter,
		/obj/item/device/radio,
		/obj/item/device/t_scanner,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/clothing/mask/gas,

		/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/taperecorder,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
	)

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
	)

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "orange hazard vest"
	desc = "An orange high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	icon = 'icons/obj/items/clothing/suits/vests_aprons.dmi'
	blood_overlay_type = "armor"
	allowed = list (
		/obj/item/device/analyzer,
		/obj/item/device/multitool,
		/obj/item/device/pipe_painter,
		/obj/item/device/radio,
		/obj/item/device/t_scanner,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/clothing/mask/gas,

		/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)
	flags_armor_protection = BODY_FLAG_CHEST
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/vests_aprons.dmi',
	)

/obj/item/clothing/suit/storage/hazardvest/blue
	name = "blue hazard vest"
	desc = "A blue high-visibility vest used in work zones."
	icon_state = "hazard_blue"
	item_state = "hazard_blue"

/obj/item/clothing/suit/storage/hazardvest/yellow
	name = "yellow hazard vest"
	desc = "A yellow high-visibility vest used in work zones."
	icon_state = "hazard_yellow"
	item_state = "hazard_yellow"

/obj/item/clothing/suit/storage/hazardvest/black
	name = "black hazard vest"
	desc = "A niche-market, black, allegedly high-visibility vest supposedly used in work zones. Features extra-reflective tapes. The etiquette on the vest insists that it's fully compliant with all the United American workplace safety standards."
	icon_state = "hazard_black"
	item_state = "hazard_black"

//Lawyer
/obj/item/clothing/suit/storage/jacket/marine/lawyer
	desc = "A snappy dress jacket."
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi',
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS

	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	has_buttons = TRUE
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/bluejacket
	name = "blue suit-jacket"
	icon_state = "suitjacket_blue"
	initial_icon_state = "suitjacket_blue"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/purpjacket
	name = "purple suit-jacket"
	icon_state = "suitjacket_purp"
	initial_icon_state = "suitjacket_purp"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/redjacket
	name = "red suit-jacket"
	icon_state = "suitjacket_red"
	initial_icon_state = "suitjacket_red"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/blackjacket
	name = "black suit-jacket"
	icon_state = "suitjacket_black"
	initial_icon_state = "suitjacket_black"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/comedian
	name = "bright red suit-jacket"
	icon_state = "suitjacket_comedian"
	initial_icon_state = "suitjacket_comedian"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/brown
	name = "brown suit-jacket"
	icon_state = "suitjacket_brown"
	initial_icon_state = "suitjacket_brown"

/obj/item/clothing/suit/storage/jacket/marine/lawyer/light_brown
	name = "light-brown suit-jacket"
	icon_state = "suitjacket_lightbrown"
	initial_icon_state = "suitjacket_lightbrown"

//Windbreakers
/obj/item/clothing/suit/storage/windbreaker
	name = "windbreaker parent object"
	desc = "This shouldn't be here..."
	icon = 'icons/obj/items/clothing/suits/windbreakers.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,

		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/weapon/gun,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	var/zip_unzip = FALSE
	actions_types = list(/datum/action/item_action/toggle)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/windbreakers.dmi',
	)

/obj/item/clothing/suit/storage/windbreaker/attack_self(mob/user) //Adds UI button
	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		return

	playsound(user, "sound/items/zip.ogg", 10, TRUE)
	zip_unzip(user)

/obj/item/clothing/suit/storage/windbreaker/proc/zip_unzip(mob/user)

	if(zip_unzip)
		icon_state = initial(icon_state)
		to_chat(user, SPAN_NOTICE("You zip \the [src]."))

	else
		icon_state = "[initial(icon_state)]_o"
		to_chat(user, SPAN_NOTICE("You unzip \the [src]."))
	zip_unzip = !zip_unzip

	update_clothing_icon()

/obj/item/clothing/suit/storage/windbreaker/windbreaker_brown
	name = "brown windbreaker"
	desc = "A brown windbreaker."
	icon_state = "windbreaker_brown"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_gray
	name = "gray windbreaker"
	desc = "A gray windbreaker."
	icon_state = "windbreaker_gray"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_green
	name = "green windbreaker"
	desc = "A green windbreaker."
	icon_state = "windbreaker_green"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_fr
	name = "first responder windbreaker"
	desc = "A brown windbreaker with reflective strips commonly worn by first responders."
	icon_state = "windbreaker_fr"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant
	name = "explorer's windbreaker"
	desc = "A brown windbreaker covered in various patches tying it to one of the first explorations into this sector."
	icon_state = "windbreaker_covenant"

//Suspenders
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	gender = PLURAL
	desc = "They suspend pants."
	icon = 'icons/obj/items/clothing/belts/misc.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor"
	flags_armor_protection = 0
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/belts/misc.dmi',
	)
