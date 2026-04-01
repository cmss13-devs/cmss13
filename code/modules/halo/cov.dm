#define ACCESSORY_SLOT_SANG_SHOULDER "Sang Shoulder"
#define ACCESSORY_SLOT_SANG_WEBBING "Sang Webbing"

/mob/living/carbon/human/proc/handle_luminosity()
	var/new_luminosity = 0
	if(species)
		new_luminosity += species.luminosity
	if(on_fire)
		new_luminosity += min(fire_stacks, 5)
	set_light_range(new_luminosity) // light up cov
	if(new_luminosity)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)


/obj/item/device/radio/headset/almayer/marine/covenant
	name = "\improper covenant communicator"
	desc = "A simple device designed to allow the wearer access to the Covenant Battle-Net, a secure communications and organizational network. The communicator can be fitted directly to the users ear via a self-adjusting and anchoring system, requiring no input from the user."
	icon = 'icons/halo/obj/items/clothing/covenant/radio.dmi'
	icon_state = "headset"
	frequency = COV_FREQ
	initial_keys = list()
	ignore_z = TRUE
	minimap_flag = MINIMAP_FLAG_YAUTJA

//======================
// COVIE BELTS
//======================

/obj/item/storage/belt/marine/covenant
	name = "\improper Covenant ammunition belt"
	desc = "A modular attachment for a warrior's combat harness that accepts several hard case blister units for personal storage, and to holster weaponry. Thanks to advancements in smart-materials, the belt is theoretically a true 'one size fits all' design."
	icon = 'icons/halo/obj/items/clothing/covenant/belts.dmi'
	icon_state = "sangbelt_minor"
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks,
		/obj/item/ammo_magazine/needler_crystal,
		/obj/item/ammo_magazine/carbine,
	)
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/needler_crystal,
		/obj/item/ammo_magazine/carbine,
	)

/obj/item/storage/belt/marine/covenant/sangheili
	name = "\improper Sangheili ammunition belt"
	desc = "A modular attachment for a warrior's combat harness that accepts several hard case blister units for personal storage, and to holster weaponry. Thanks to advancements in smart-materials, the belt is theoretically a true 'one size fits all' design."
	icon_state = "sangbelt_minor"
	item_state = "sangbelt_minor"
	item_icons = list(
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/sangheili/belts.dmi'
		)

/obj/item/storage/belt/marine/covenant/sangheili/minor
	name = "\improper Sangheili Minor ammunition belt"

/obj/item/storage/belt/marine/covenant/sangheili/minor/stored_needles

/obj/item/storage/belt/marine/covenant/sangheili/major
	name = "\improper Sangheili Major ammunition belt"
	icon_state = "sangbelt_major"
	item_state = "sangbelt_major"

/obj/item/storage/belt/marine/covenant/sangheili/major/stored_needles

/obj/item/storage/belt/marine/covenant/sangheili/ultra
	name = "\improper Sangheili Ultra ammunition belt"
	icon_state = "sangbelt_ultra"
	item_state = "sangbelt_ultra"

/obj/item/storage/belt/marine/covenant/sangheili/zealot
	name = "\improper Sangheili Zealot ammunition belt"
	icon_state = "sangbelt_zealot"
	item_state = "sangbelt_zealot"

/obj/item/storage/belt/marine/covenant/unggoy
	name = "\improper Unggoy ammunition belt"
	icon_state = "gruntbelt_minor"
	item_state = "gruntbelt_minor"
	item_icons = list(
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/unggoy/belts.dmi'
		)

/obj/item/storage/belt/marine/covenant/unggoy/minor
	name = "\improper Unggoy Minor ammunition belt"
	icon_state = "gruntbelt_minor"
	item_state = "gruntbelt_minor"

/obj/item/storage/belt/marine/covenant/unggoy/major
	name = "\improper Unggoy Major ammunition belt"
	icon_state = "gruntbelt_major"
	item_state = "gruntbelt_major"

/obj/item/storage/belt/marine/covenant/unggoy/heavy
	name = "\improper Unggoy ammunition belt"
	icon_state = "gruntbelt_heavy"
	item_state = "gruntbelt_heavy"

/obj/item/storage/belt/marine/covenant/unggoy/ultra
	name = "\improper Unggoy Ultra ammunition belt"
	icon_state = "gruntbelt_ultra"
	item_state = "gruntbelt_ultra"

/obj/item/storage/belt/marine/covenant/unggoy/specops
	name = "\improper Unggoy SpecOps ammunition belt"
	icon_state = "gruntbelt_specops"
	item_state = "gruntbelt_specops"

/obj/item/storage/belt/marine/covenant/unggoy/specops_ultra
	name = "\improper Unggoy SpecOps ammunition belt"
	icon_state = "gruntbelt_specops_ultra"
	item_state = "gruntbelt_specops_ultra"

/obj/item/clothing/gloves/marine/sangheili
	name = "\improper Sangheili gauntlets"
	desc = "Simple gauntlets worn over the wrists of a Sangheili, made of common nanolaminate composites. Fitted precisely, these gauntlets do not interfere whatsoever with the warriors work, and in the case where pure brute strength is needed, prove sufficient as improvised weapons."
	icon = 'icons/halo/obj/items/clothing/covenant/gloves.dmi'
	icon_state = "sanggauntlets_minor"
	item_state = "sangauntlets_minor"

	item_icons = list(
		WEAR_HANDS = 'icons/halo/mob/humans/onmob/clothing/sangheili/gloves.dmi'
	)

	allowed_species_list = list(SPECIES_SANGHEILI)

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/gloves/marine/sangheili/minor
	name = "\improper Sangheili Minor gauntlets"

/obj/item/clothing/gloves/marine/sangheili/major
	name = "\improper Sangheili Major gauntlets"
	icon_state = "sanggauntlets_major"

	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/gloves/marine/sangheili/ultra
	name = "\improper Sangheili Ultra gauntlets"
	icon_state = "sanggauntlets_ultra"

	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/gloves/marine/sangheili/zealot
	name = "\improper Sangheili Zealot gauntlets"
	icon_state = "sanggauntlets_zealot"

	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/head/helmet/marine/sangheili
	name = "\improper Sangheili helmet"
	desc = "A nanolaminate helmet inspired by ancient Sangheili armours of the Pre-Covenant, having not changed its design in fifty generations. Fitted with comprehensive communications and smart-link systems allowing the wearer to maintain both control of their levies and fine operation of their weapons."
	icon = 'icons/halo/obj/items/clothing/covenant/helmets.dmi'
	icon_state = "sanghelmet_minor"
	item_state = "sanghelmet_minor"

	item_icons = list(
		WEAR_HEAD = 'icons/halo/mob/humans/onmob/clothing/sangheili/hat.dmi'
	)

	allowed_species_list = list(SPECIES_SANGHEILI)

	flags_marine_helmet = NO_FLAGS
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	built_in_visors = list()

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	anti_hug = 6

/obj/item/clothing/head/helmet/marine/sangheili/minor
	name = "\improper Sangheili Minor helmet"

/obj/item/clothing/head/helmet/marine/sangheili/major
	name = "\improper Sangheili Major helmet"
	icon_state = "sanghelmet_major"

	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/head/helmet/marine/sangheili/ultra
	name = "\improper Sangheili Ultra helmet"
	icon_state = "sanghelmet_ultra"

	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/head/helmet/marine/sangheili/zealot
	name = "\improper Sangheili Zealot helmet"
	icon_state = "sanghelmet_zealot"

	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/shoes/sangheili
	name = "Sangheili combat boots"
	desc = "A pair of fitted greaves and accompanying boots. While the external nanolaminate construction may suggest rigidity and discomfort, the internal lining is surprisingly plush, wicking sweat and passively regulating tempature. These benefits allow the warrior to focus on the art of killing, and not how much they may hate marching."
	icon = 'icons/halo/obj/items/clothing/covenant/shoes.dmi'
	icon_state = "sangboots_minor"
	item_state = "sangboots_minor"

	drop_sound = "armorequip"

	item_icons = list(
		WEAR_FEET = 'icons/halo/mob/humans/onmob/clothing/sangheili/shoes.dmi'
	)

	allowed_species_list = list(SPECIES_SANGHEILI)

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/shoes/sangheili/minor
	name = "Sangheili Minor combat boots"

/obj/item/clothing/shoes/sangheili/major
	name = "Sangheili Major combat boots"
	icon_state = "sangboots_major"

	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/shoes/sangheili/ultra
	name = "Sangheili Ultra combat boots"
	icon_state = "sangboots_ultra"

	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/shoes/sangheili/zealot
	name = "Sangheili Zealot combat boots"
	icon_state = "sangboots_zealot"

	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/under/marine/covenant
	name = "undersuit"
	desc = "Covenant undersuit. You shouldn't see this."
	icon = 'icons/halo/obj/items/clothing/covenant/under.dmi'
	icon_state = "sangheili_undersuit"
	item_state = "sangheili_undersuit"
	worn_state = "sangheili_undersuit"
	flags_jumpsuit = null
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	drop_sound = "armorequip"
	allowed_species_list = list()

/obj/item/clothing/under/marine/covenant/sangheili
	name = "sangheili undersuit"
	desc = "A high-tech jumpsuit that for the most part conforms to the users body. Interlaced with nanolaminate armoring, it provides ample protection for how flexible it is - enabling the wearer to be aggressive while still protecting themselves. Advanced magnetic projectors on the undersuit are capable of locking armor to it with considerable force."
	icon = 'icons/halo/obj/items/clothing/covenant/under.dmi'
	icon_state = "sangheili_undersuit"
	item_state = "sangheili_undersuit"
	worn_state = "sangheili_undersuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	drop_sound = "armorequip"
	allowed_species_list = list(SPECIES_SANGHEILI)
	item_state_slots = list()

	item_icons = list(
		WEAR_BODY = 'icons/halo/mob/humans/onmob/sangheili/uniforms.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)

/obj/item/clothing/under/marine/covenant/unggoy
	name = "Unggoy magnetic webbing"
	desc = "Issued to Unggoy as a part of their combat kit, the webbing is a series of straps fitted with magnetic locks intended to be worn with their issued armor. Although uncomfortable and doesn't prevent any armor chafing, Unggoy skin is pretty tough."

	icon_state = "unggoy_harness"
	item_state = "unggoy_harness"
	worn_state = "unggoy_harness"
	flags_jumpsuit = null
	drop_sound = "armorequip"
	allowed_species_list = list(SPECIES_UNGGOY)
	item_state_slots = list()

	item_icons = list(
		WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/unggoy/uniforms.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)


/obj/structure/machinery/recharger/covenant
	name = "\improper plasma-charging crate"
	desc = "A crate made of a purple alien material. It can only fit covenant plasma weapons to recharge them."
	icon = 'icons/halo/obj/structures/machinery/cov_recharger.dmi'
	icon_state = "cov_recharger"
	density = TRUE
	allowed_devices = list(/obj/item/weapon/gun/energy/plasma)

/obj/structure/machinery/recharger/covenant/update_icon()
	. = ..()
	if(istype(charging, /obj/item/weapon/gun/energy/plasma))
		overlays += "cover"

/obj/structure/machinery/recharger/covenant/process()

	if(inoperable() || !anchored)
		update_use_power(USE_POWER_NONE)
		update_icon()
		return
	if(!charging)
		update_use_power(USE_POWER_IDLE)
		percent_charge_complete = 0
		update_icon()
	//This is an awful check. Holy cow.
	// ADDENDUM: FUCK CM DEV 8 YEARS AGO I HATE YOU.
	else
		if(istype(charging, /obj/item/weapon/gun/energy/plasma))
			var/obj/item/weapon/gun/energy/plasma/E = charging
			if(!E.works_in_cov_recharger)
				return;
			if(!E.cell.fully_charged())
				E.cell.give(charge_amount)
				percent_charge_complete = E.cell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return


/obj/item/clothing/mask/gas/unggoy
	name = "methane rebreather"
	desc = "Worn by the Unggoy, this rebreather hooks up to their tank and allows them to operate in planets lacking methane-rich atmosphere."
	icon = 'icons/halo/obj/items/clothing/covenant/masks.dmi'
	icon_state = "methane_mask"
	item_state = "methane_mask"

	allowed_species_list = list(SPECIES_UNGGOY)

	item_icons = list(
		WEAR_FACE = 'icons/halo/mob/humans/onmob/clothing/unggoy/mask.dmi'
	)
	anti_hug = 6

/obj/item/clothing/suit/marine/unggoy
	name = "placeholder Unggoy combat harness"
	desc = "A combat harness made to fit an Unggoy. Placeholder."
	slowdown = SLOWDOWN_ARMOR_LIGHT

	icon = 'icons/halo/obj/items/clothing/covenant/armor.dmi'
	icon_state = "unggoy_minor"
	item_state = "unggoy_minor"

	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/unggoy/armor.dmi'
	)
	allowed_species_list = list(SPECIES_UNGGOY)

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW

	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/suit/marine/unggoy/minor
	name = "Unggoy Minor combat harness"
	desc = "A combat harness designed for use by Unggoy warriors, made of a sturdy nanolaminate composite and coloured to denote the warriors rank. Thanks to the weight of the methane tank usually mounted to the harness, the actual coverage of the plating is relatively limited, only covering the chest, waist and shoulders. <b>This one indicates the wearer is an Unggoy Minor.</b>"

/obj/item/clothing/suit/marine/unggoy/major
	name = "Unggoy Major combat harness"
	desc = "A red coloured harness is the sign of an Unggoy Major, a more veteran warrior usually given charge of files of Minors. While featuring no superior protective qualities to the standard orange harness of its lessers, the Major's harness is noted to fit just a bit more comfortably and provide higher-quality methane to its user."
	desc_lore = "Minor adjustments include a more robust communications system, allowing for more efficient comms with their superiors, a noted negative by anyone who isn't an Unggoy."
	icon_state = "unggoy_major"
	item_state = "unggoy_major"

/obj/item/clothing/suit/marine/unggoy/heavy
	name = "Unggoy Heavy combat harness"
	desc = "This green combat harness denotes the wearer as a special weapons operator, from plasma cannons and shade turrets to fuel rod cannons and explosive ordinance. Features additional padding and a specific nanolaminate composition to more easily resist explosive damage in the case of enemy counter fire, or semi-common accidents."
	icon_state = "unggoy_heavy"
	item_state = "unggoy_heavy"

	armor_bomb = CLOTHING_ARMOR_HIGH

/obj/item/clothing/suit/marine/unggoy/ultra
	name = "Unggoy Ultra combat harness"
	desc = "A white coloured combat harness marking its user as a Ultra, a combat veteran of many campaigns. The armour not only features vastly superior material composition in its protective qualities, but is fitted to its owner exactly, providing a comfortable fit that allows for more natural movement."
	icon_state = "unggoy_ultra"
	item_state = "unggoy_ultra"

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/suit/marine/unggoy/deacon
	name = "Unggoy Deacon harness"
	desc = "This harness is of the highest quality, reserved for ministry personnel who serve as Deacons to their San'shyuum betters. Its many features include custom fitting and more robust mounting brackets, alongside a superior nanolaminate composite that is not only both light without sacrificing protective quality, but also may include small holographic projectors to provide reinforcement to ones sermons and duties."
	icon_state = "unggoy_deacon"
	item_state = "unggoy_deacon"

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/suit/marine/stealth/unggoy_specops
	name = "Unggoy SpecOps combat harness"
	desc = "A dark purple harness reserved for those few Unggoy who meet the requirements to join the Special-Warfare-Group's ranks. While benefiting from numerous fitting and material developments over the more common combat harnesses of their brothers, the Spec-Ops variant also features obvious advancements in the areas of stealth."
	desc_lore = "From passive thermal and sensor stealth built into its matrices, to the capability to become totally invisible on all spectrum given an active camouflage module, this harness is well worth the countless nights of training."
	icon_state = "unggoy_specops"
	item_state = "unggoy_specops"

	icon = 'icons/halo/obj/items/clothing/covenant/armor.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/unggoy/armor.dmi'
	)
	allowed_species_list = list(SPECIES_UNGGOY)

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE

/obj/item/clothing/suit/marine/stealth/unggoy_specops/ultra
	name = "Unggoy SpecOps Ultra combat harness"
	desc = "A modification of the Spec-Ops harness used by Unggoy of the Special-Warfare-Group, worn by veterans and specialists. A notable improvement over the common Spec-Ops harness, featuring reinforced composites designed for direct combat. While many may regard Unggoy as cowardly and weak, few who've seen this black harness live to tell about it, and those who do have far different opinions."
	icon_state = "unggoy_specops_ultra"
	item_state = "unggoy_specops_ultra"

	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/accessory/pads/sangheili
	name = "\improper Sangheili shoulder pads"
	desc = "Pauldrons of venerable design, fitted to a warrior's combat harness to protect the upper arms. While simple in function, the strong nanolaminate composites of these pauldrons provide ample protection."
	icon = 'icons/halo/obj/items/clothing/covenant/accessories.dmi'
	icon_state = "sangpads_minor"
	item_state = "sangpads_minor"
	worn_accessory_slot = ACCESSORY_SLOT_SANG_SHOULDER
	flags_atom = NO_GAMEMODE_SKIN
	accessory_icons = list(WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/sangheili/accessories.dmi', WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/sangheili/accessories.dmi')

/obj/item/clothing/accessory/pads/sangheili/minor
	name = "\improper Sangheili Minor shoulder pads"

/obj/item/clothing/accessory/pads/sangheili/major
	name = "\improper Sangheili Major shoulder pads"
	icon_state = "sangpads_major"
	item_state = "sangpads_major"

/obj/item/clothing/accessory/pads/sangheili/ultra
	name = "\improper Sangheili Ultra shoulder pads"
	icon_state = "sangpads_ultra"
	item_state = "sangpads_ultra"

/obj/item/clothing/accessory/pads/sangheili/zealot
	name = "\improper Sangheili Zealot shoulder pads"
	icon_state = "sangpads_zealot"
	item_state = "sangpads_zealot"

/obj/item/storage/pouch/firstaid/full/alternate/cov
	name = "Covenant First Aid Pouch"
	desc = "full of alien healing supplies"
	color = "#CC99FF"
	storage_slots = 6

	can_hold = list(
	/obj/item/storage/pill_bottle/packet/tricordrazine/cov,
	/obj/item/stack/medical/splint/cov,
	/obj/item/stack/medical/ointment/cov,
	/obj/item/stack/medical/bruise_pack/cov,
	/obj/item/reagent_container/food/snacks/protein_pack/cov,
	/obj/item/reagent_container/hypospray/autoinjector/cov,
	)

/obj/item/storage/pouch/firstaid/full/alternate/cov/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/packet/tricordrazine/cov(src)
	new /obj/item/stack/medical/splint/cov(src)
	new /obj/item/stack/medical/ointment/cov(src)
	new /obj/item/stack/medical/bruise_pack/cov(src)
	new /obj/item/reagent_container/food/snacks/protein_pack/cov(src)
	new /obj/item/reagent_container/hypospray/autoinjector/cov(src)


/obj/item/stack/medical/bruise_pack/cov
	name = "Covenant Bandages"
	desc = "Bandages, for covenant."
	color = "#CC99FF"
	alien = TRUE

/obj/item/storage/pill_bottle/packet/tricordrazine/cov
	name = "Covenant Healing Pills"
	desc = "Pills that heal covenant"
	color = "#CC99FF"

/obj/item/stack/medical/splint/cov
	name = "Covenant Splints"
	desc = "Splints for covenant fractures"
	color = "#CC99FF"
	alien = TRUE

/obj/item/stack/medical/ointment/cov
	name = "Covenant Ointment"
	desc = "Ointment for Covenant Burns"
	color = "#CC99FF"
	alien = TRUE

/obj/item/reagent_container/food/snacks/protein_pack/cov
	name = "Covenant Nutrient Brick"
	desc = "Is this even food?"
	filling_color = "#CC99FF"
	color = "#CC99FF"

/obj/item/reagent_container/hypospray/autoinjector/cov
	name = "covenant recovery stimulant"
	desc = "A stimulant said to stabilize sangheili and unggoy warriors and help recover from internal wounds."
	chemname = "cathwei"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "crystal"
	injectSFX = 'sound/items/pred_crystal_inject.ogg'
	autoinjector_type = "thwei"
	injectVOL = 15
	amount_per_transfer_from_this = REAGENTS_OVERDOSE
	volume = REAGENTS_OVERDOSE
	uses_left = 1
	black_market_value = 25
	color = "#CC99FF"

/obj/item/reagent_container/hypospray/autoinjector/cov/attack(mob/M as mob, mob/user as mob)
	if(ishuman_strict(M))
		to_chat(user, SPAN_DANGER("You would not desecrate your equipment using it on a lowly human."))
		return
	if(HAS_TRAIT(user, TRAIT_COV_TECH))
		..()
	else
		to_chat(user, SPAN_DANGER("You have no idea where to inject [src]."))

	if(uses_left == 0)
		addtimer(CALLBACK(src, PROC_REF(remove_crystal)), 120 SECONDS)

/obj/item/reagent_container/hypospray/autoinjector/cov/proc/remove_crystal()
	visible_message(SPAN_DANGER("[src] collapses into nothing."))
	qdel(src)

/obj/item/reagent_container/hypospray/autoinjector/cov/update_icon()
	overlays.Cut()
	if(uses_left && autoinjector_type) //does not apply a colored fill overlay like the rest of the autoinjectors
		var/image/filling = image('icons/obj/items/hunter/pred_gear.dmi', src, "[autoinjector_type]_[uses_left]")
		overlays += filling
		return
