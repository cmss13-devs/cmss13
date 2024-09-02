/*
 * Job related
 */

//Botonist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
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
//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	item_state = "bio_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	flags_inv_hide = HIDEJUMPSUIT

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	item_state = "bio_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEJUMPSUIT

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
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDESHOES|HIDEJUMPSUIT
	allowed = list(
		/obj/item/weapon/gun,
	)

//Chef
/obj/item/clothing/suit/chef
	name = "Chef's apron"
	desc = "An apron used by a high-class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
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

//Chef
/obj/item/clothing/suit/chef/classic
	name = "A classic chef's apron."
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
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

//Security
/obj/item/clothing/suit/security/navyofficer
	name = "security officer's jacket"
	desc = "This jacket is for those special occasions when a security officer actually feels safe."
	icon_state = "officerbluejacket"
	item_state = "officerbluejacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/suit/security/navywarden
	name = "warden's jacket"
	desc = "Perfectly suited for the warden that wants to leave an impression of style on those who visit the brig."
	icon_state = "wardenbluejacket"
	item_state = "wardenbluejacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/suit/security/navyhos
	name = "head of security's jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon_state = "hosbluejacket"
	item_state = "hosbluejacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

//Detective
/obj/item/clothing/suit/storage/det_suit
	name = "coat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
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
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
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
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/det_suit/black
	icon_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	item_state = "det_suit"
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
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "orange hazard vest"
	desc = "An orange high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
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
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

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
/obj/item/clothing/suit/storage/lawyer/bluejacket
	name = "Blue Suit Jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_blue_open"
	item_state = "suitjacket_blue_open"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "Purple Suit Jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS

//Internal Affairs
/obj/item/clothing/suit/storage/internalaffairs
	name = "Internal Affairs Jacket"
	desc = "A smooth black jacket."
	icon_state = "ia_jacket_open"
	item_state = "ia_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/internalaffairs/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	switch(icon_state)
		if("ia_jacket_open")
			src.icon_state = "ia_jacket"
			to_chat(usr, "You button up the jacket.")
		if("ia_jacket")
			src.icon_state = "ia_jacket_open"
			to_chat(usr, "You unbutton the jacket.")
		else
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are.")
			return
	update_clothing_icon() //so our overlays update

//Windbreakers
/obj/item/clothing/suit/storage/windbreaker
	name = "windbreaker parent object"
	desc = "This shouldn't be here..."
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
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	var/zip_unzip = FALSE
	actions_types = list(/datum/action/item_action/toggle)

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
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor"
	flags_armor_protection = 0
