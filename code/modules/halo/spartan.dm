#define SPARTAN_SKIN_COLOR list("pale1")

/datum/pain/spartan
	max_pain = 750

	threshold_mild = 500
	threshold_discomforting = 550
	threshold_moderate = 600
	threshold_distressing = 650
	threshold_severe = 700
	threshold_horrible = 725

/datum/skills/covenant/spartan
	name = "UNSC, Spartan"
	skills = list(
		SKILL_ENGINEER = SKILL_ENGINEER_TRAINED,
		SKILL_FIREMAN = SKILL_FIREMAN_DEFAULT,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_MEDICAL = SKILL_MEDICAL_MEDIC,
		SKILL_SURGERY = SKILL_SURGERY_DEFAULT,
		SKILL_CQC = SKILL_CQC_MAX,
		SKILL_LEADERSHIP = SKILL_LEAD_TRAINED,
		SKILL_OVERWATCH = SKILL_OVERWATCH_TRAINED,
		SKILL_JTAC = SKILL_JTAC_TRAINED,
		SKILL_FIREARMS = SKILL_FIREARMS_MASTER,
		SKILL_PILOT = SKILL_PILOT_TRAINED,
		SKILL_ENDURANCE = SKILL_ENDURANCE_EXPERT,
		SKILL_GUN_HO = SKILL_GUN_HO_EXPERT,
		SKILL_MELEE_WEAPONS = SKILL_MELEE_SUPER,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_ALL,
	)

/obj/item/clothing/gloves/marine/spartan
	name = "\improper spartan combat gloves"
	desc = "gloves"
	icon_state = "spartan"
	item_state = "spartan"

	item_icons = list(
		WEAR_HANDS = 'icons/halo/mob/humans/onmob/clothing/gloves_48.dmi'
	)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	flags_item = NODROP
	allowed_species_list = list(SPECIES_SPARTAN)

/obj/item/clothing/head/helmet/marine/unsc/mjolnir
	name = "\improper Mjolnir Mk IV helmet"
	desc = "Helmet for the Mjolnir Mk IV Powered Assault Armour. An advanced piece of equipment at least a generation ahead of anything else in UNSC use, the Mk IV's helmet is made of the same multilayer alloys as the armour, and features a polarizing orange-gold visor capable of protecting the wearers eyes from even nuclear flashes automatically. Employs the cutting edge of VISR technology, allowing for an unparalleled augmented-reality display."
	icon_state = "mk_iv_0"
	item_state = "mk_iv_0"
	light_system = DIRECTIONAL_LIGHT
	light_power = 3
	light_range = 5
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGH
	allowed_species_list = list(SPECIES_SPARTAN)
	actions_types = list(/datum/action/item_action/toggle)
	var/toggleable = TRUE

/obj/item/clothing/head/helmet/marine/unsc/mjolnir/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/head/helmet/marine/unsc/mjolnir/update_icon()
	. = ..()
	if(light_on)
		icon_state = "mk_iv_[light_on]"
		item_state = "mk_iv_[light_on]"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

/obj/item/clothing/head/helmet/marine/unsc/mjolnir/attack_self(mob/user)
	. = ..()

	if(!toggleable)
		to_chat(user, SPAN_WARNING("You cannot toggle [src] on or off."))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You cannot turn the light [light_on ? "off" : "on"] while in [user.loc].")) //To prevent some lighting anomalies.
		return FALSE

	turn_light(user, !light_on)

/obj/item/clothing/head/helmet/marine/unsc/mjolnir/turn_light(mob/user, toggle_on)

	. = ..()
	if(. != CHECKS_PASSED)
		return

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)

	set_light_on(toggle_on)

	update_icon()

	if(user == loc)
		user.update_inv_head()

	for(var/datum/action/current_action as anything in actions)
		current_action.update_button_icon()

/obj/item/clothing/shoes/marine/spartan
	name = "\improper spartan combat shoes"
	desc = "gloves"
	icon_state = "spartan"
	item_state = "spartan"
	item_icons = list(
		WEAR_FEET = 'icons/halo/mob/humans/onmob/clothing/shoes_48.dmi'
	)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	flags_item = NODROP
	allowed_species_list = list(SPECIES_SPARTAN)

/obj/item/clothing/suit/marine/unsc/mjolnir
	name = "\improper Mjolnir Mk IV armour"
	desc = "This is the main complex of the Mjolnir Mk IV Powered Assault Armour. A fully sealed and EVA capable green coloured set of armour which provides its wearer vastly improved physical capabilities through its active-powered-systems, though it requires the wearer be a Spartan. Its multilayer alloy is comparable to Titanium-A Battleplate used on starships, and features a refractive coating that can dispel a small amount of the energy from Covenant weapons. Its powered by a micro-fusion generator and costs about as much as a battlegroup of Frigates too."
	icon = 'icons/halo/obj/items/clothing/suits/suits_by_faction/suit_48.dmi'
	icon_state = "mk_iv"
	item_state = "mk_iv"
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)

	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/suits/suits_by_faction/suit_48.dmi'
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_HANDS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_HANDS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_HANDS|BODY_FLAG_FEET
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_laser = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGHPLUS
	var/armor_status = 100
	flags_item = NODROP
	allowed_species_list = list(SPECIES_SPARTAN)

/obj/item/clothing/suit/marine/unsc/mjolnir/proc/armor_check()
	var/new_stat
	switch(armor_status)
		if(80 to 100)
			new_stat = CLOTHING_ARMOR_ULTRAHIGHPLUS
		if(50 to 80)
			new_stat = CLOTHING_ARMOR_VERYHIGH
		if(20 to 50)
			new_stat = CLOTHING_ARMOR_HIGHPLUS
		if(0 to 20)
			new_stat = CLOTHING_ARMOR_MEDIUM
	armor_melee = new_stat
	armor_bullet = new_stat
	armor_laser = new_stat
	armor_bomb = new_stat
	armor_internaldamage = new_stat

/obj/item/clothing/accessory/storage/webbing/m52b/mag/m7
	hold = /obj/item/storage/internal/accessory/webbing/m52bmag/m7

/obj/item/storage/internal/accessory/webbing/m52bmag/m7/fill_preset_inventory()
	new /obj/item/ammo_magazine/smg/halo/m7(src)
	new /obj/item/ammo_magazine/smg/halo/m7(src)
	new /obj/item/ammo_magazine/smg/halo/m7(src)
	new /obj/item/ammo_magazine/smg/halo/m7(src)
	new /obj/item/ammo_magazine/smg/halo/m7(src)

/obj/item/clothing/accessory/storage/webbing/m52b/mag/ma5b
	hold = /obj/item/storage/internal/accessory/webbing/m52bmag/ma5b

/obj/item/storage/internal/accessory/webbing/m52bmag/ma5b/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/halo/ma5b(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5b(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5b(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5b(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5b(src)

/obj/item/clothing/under/marine/spartan
	name = "\improper Mjolnir Mk IV Undersuit"
	desc = "The undersuit of the Mjolnir Mk IV Powered Assault Armour. Despite appearances, this thick black undersuit employs extremely advanced technology; its material composition is primarily a titanium nanoncomposite overlayer. Beneath this is an advanced gel-layer which wicks sweat and waste such as dead skin, alongside regulating body-temperature. The gel-layer also responds to kinetic strikes against it, stiffening into a barrier capable of stopping bullets and breaking blades, sections of it can be manually adjusted as needed."
	icon = 'icons/halo/obj/items/clothing/undersuit.dmi'
	icon_state = "spartan"
	item_state = "spartan"
	worn_state = "spartan"
	drop_sound = "armorequip"
	item_state_slots = list()
	flags_atom = FPRINT|NO_GAMEMODE_SKIN
	flags_item = NODROP
	allowed_species_list = list(SPECIES_SPARTAN)

	item_icons = list(
		WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/uniforms_48.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)
	flags_jumpsuit = null
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_VERYLOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS

/datum/equipment_preset/unsc/spartan
	name = "Spartan"
	assignment = JOB_SPARTAN
	assignment = JOB_SPARTAN
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	paygrades = list(PAY_SHORT_NE6 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/covenant/spartan
	role_comm_title = "Spartan"
	languages = list(LANGUAGE_ENGLISH)
	var/access_list = ACCESS_LIST_MARINE_MAIN

/datum/equipment_preset/unsc/spartan/New()
	. = ..()
	access = get_access(access_list)

/datum/equipment_preset/unsc/spartan/load_race(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_species(SPECIES_SPARTAN)
	var/static/list/colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "BROWN" = list(48, 38, 18),"BLUE" = list(29, 51, 65), "GREEN" = list(40, 61, 39), "STEEL" = list(46, 59, 54))
	new_human.gender = pick(50;MALE,50;FEMALE)
	var/random_name = "[capitalize(pick(new_human.gender == MALE ? GLOB.first_names_spartan_male : GLOB.first_names_spartan_female))]-[rand(0,200)]"
	var/final_name = random_name
	new_human.change_real_name(new_human, final_name)
	new_human.body_type = "spartan"
	new_human.skin_color = "pale1"
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	new_human.age = rand(17,35)

/datum/equipment_preset/unsc/spartan/load_name(mob/living/carbon/human/new_human, randomise, client/mob_client)
	new_human.set_species(SPECIES_SPARTAN)
	var/static/list/colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "BROWN" = list(48, 38, 18),"BLUE" = list(29, 51, 65), "GREEN" = list(40, 61, 39), "STEEL" = list(46, 59, 54))
	new_human.gender = pick(50;MALE,50;FEMALE)
	var/random_name = "[capitalize(pick(new_human.gender == MALE ? GLOB.first_names_spartan_male : GLOB.first_names_spartan_female))]-[rand(0,200)]"
	var/final_name = random_name
	new_human.change_real_name(new_human, final_name)
	new_human.body_type = "spartan"
	new_human.skin_color = "pale1"
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	new_human.age = rand(17,35)

// =================================
// Standard Loadout
// =================================

/datum/equipment_preset/unsc/spartan/equipped
	name = "Spartan Equipped"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/unsc/spartan/equipped/load_gear(mob/living/carbon/human/new_human)
	//clothing
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/spartan(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unsc/mjolnir(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unsc/mjolnir(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/spartan(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/spartan(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	//suit store
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/halo/ma5c(new_human), WEAR_J_STORE)
	//belt
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/ma5c(new_human), WEAR_IN_BELT)
	//accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/unsc(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/unsc(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/canteen, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/unsc/corpsman(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(new_human), WEAR_IN_BACK)

/datum/equipment_preset/unsc/spartan/sniper
	name = "Spartan Sniper"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/unsc/spartan/sniper/load_gear(mob/living/carbon/human/new_human)
	//clothing
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/spartan(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unsc/mjolnir(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unsc/mjolnir(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/spartan(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/spartan(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	//suit store
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m7/full/socom(new_human), WEAR_J_STORE)
	//belt
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/halo/sniper(new_human), WEAR_IN_BELT)
	//accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/m52b/mag/m7(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/halo(new_human), WEAR_BACK)

/datum/equipment_preset/unsc/spartan/cqc
	name = "Spartan CQC"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/unsc/spartan/cqc/load_gear(mob/living/carbon/human/new_human)
	//clothing
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/spartan(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unsc/mjolnir(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unsc/mjolnir(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/spartan(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/spartan(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	//suit store
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/halo/ma5b(new_human), WEAR_J_STORE)
	//belt
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/shotgun/buckshot/unsc(new_human), WEAR_WAIST)
	//accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/m52b/mag/ma5b(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/halo/m6d(new_human), WEAR_IN_ACCESSORY)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/halo/m90(new_human), WEAR_BACK)


/datum/species/spartan
	group = SPECIES_SPARTAN
	name = "Spartan"
	name_plural = "Spartans"
	mob_flags = KNOWS_TECHNOLOGY
	flags = HAS_HARDCRIT|HAS_SKIN_COLOR|SPECIAL_BONEBREAK|NO_SHRAPNEL
	mob_inherent_traits = list(
		TRAIT_SUPER_STRONG,
		TRAIT_DEXTROUS,
		TRAIT_IRON_TEETH,
	)
	unarmed_type = /datum/unarmed_attack/punch/spartan
	pain_type = /datum/pain/spartan

	total_health = 250
	burn_mod = 0.8
	brute_mod = 0.8

	darksight = 2
	default_lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

	dodge_pool = 10
	dodge_pool_max = 10
	dodge_pool_regen = 1
	dodge_pool_regen_max = 1
	dodge_pool_regen_restoration = 0.1
	dp_regen_base_reactivation_time = 20

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	knock_down_reduction = 2
	stun_reduction = 2
	knock_out_reduction = 2

	icobase = 'icons/halo/mob/humans/species/spartan/r_spartan.dmi'
	deform = 'icons/halo/mob/humans/species/spartan/r_spartan.dmi'
	eye_icon = 'icons/halo/mob/humans/species/spartan/eyes.dmi'
	dam_icon = 'icons/halo/mob/humans/species/spartan/dam_spartan.dmi'
	blood_mask = 'icons/halo/mob/humans/species/spartan/blood_mask.dmi'
	icon_template = 'icons/mob/humans/template_64.dmi'

/datum/species/spartan/New()
	..()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 1, "y" = 4), "[EAST]" = list("x" = 1, "y" = 4), "[SOUTH]" = list("x" = -1, "y" = 4), "[WEST]" = list("x" = 1, "y" = 4)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -1, "y" = 4), "[EAST]" = list("x" = 1, "y" = 4), "[SOUTH]" = list("x" = 1, "y" = 4), "[WEST]" = list("x" = 1, "y" = 4)),
		WEAR_WAIST = list("[NORTH]" = list("x" = 0, "y" = 6), "[EAST]" = list("x" = 0, "y" = 6), "[SOUTH]" = list("x" = 0, "y" = 6), "[WEST]" = list("x" = 1, "y" = 6)),
		WEAR_HEAD = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 0, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 0, "y" = 7)),
		WEAR_FACE = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_EYES = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_ID = list("[NORTH]" = list("x" = 0, "y" = 6), "[EAST]" = list("x" = 1, "y" = 6), "[SOUTH]" = list("x" = 0, "y" = 6), "[WEST]" = list("x" = 1, "y" = 6)),
		WEAR_BACK = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -2, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 3, "y" = 7)),
		WEAR_J_STORE = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -2, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 3, "y" = 7)),
		WEAR_IN_JACKET = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_L_EAR = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_R_EAR = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		WEAR_ACCESSORY = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 0, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 0, "y" = 7)),
		WEAR_IN_ACCESSORY = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 0, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 0, "y" = 7)),
		WEAR_IN_HELMET = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = 0, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 0, "y" = 7)),
	)

/datum/species/spartan/post_species_loss(mob/living/carbon/human/H)
	..()
	GLOB.spartan_mob_list -= H
	for(var/obj/limb/limb in H.limbs)
		switch(limb.name)
			if("groin","chest")
				limb.min_broken_damage = 40
				limb.max_damage = 200
			if("head")
				limb.min_broken_damage = 40
				limb.max_damage = 60
			if("l_hand","r_hand","r_foot","l_foot")
				limb.min_broken_damage = 25
				limb.max_damage = 30
			if("r_leg","r_arm","l_leg","l_arm")
				limb.min_broken_damage = 30
				limb.max_damage = 35
		limb.time_to_knit = -1

/datum/species/spartan/handle_post_spawn(mob/living/carbon/human/spartan)
	GLOB.alive_human_list -= spartan

	#ifndef UNIT_TESTS // Since this is a hard ref, we shouldn't confuse create_and_destroy
	GLOB.spartan_mob_list += spartan
	#endif
	for(var/obj/limb/limb in spartan.limbs)
		switch(limb.name)
			if("groin","chest")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 2 MINUTES // 2 minutes to self heal bone break, time is in tenths of a second to auto heal this
			if("head")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 1 MINUTES // 1 minute to self heal bone break, time is in tenths of a second
			if("l_hand","r_hand","r_foot","l_foot")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 1 MINUTES // 1 minute to self heal bone break, time is in tenths of a second
			if("r_leg","r_arm","l_leg","l_arm")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 1 MINUTES // 1 minute to self heal bone break, time is in tenths of a second

	spartan.set_languages(LANGUAGE_ENGLISH)
	give_action(spartan, /datum/action/human_action/activable/lunge)
	spartan.AddComponent(/datum/component/leaping, _leap_range = 4, _leap_cooldown = 4 SECONDS, _leaper_allow_pass_flags = PASS_OVER|PASS_MOB_THRU)
//	spartan.AddComponent(/datum/component/jump, _jump_duration = 0.75 SECONDS, _jump_cooldown = 1 SECONDS, _jump_height = 32, _jump_sound = 'sound/weapons/thudswoosh.ogg', _jump_flags = JUMP_SPIN, _jumper_allow_pass_flags = PASS_OVER|PASS_MOB_THRU)
	return ..()


// Warrior Lunge
/datum/action/human_action/activable/lunge
	name = "Lunge"
	icon_file = 'icons/mob/hud/actions_xeno.dmi'
	action_icon_state = "lunge"
	cooldown = 15 SECONDS

	// Configurables
	var/grab_range = 4
	var/twitch_message_cooldown = 0 //apparently this is necessary for a tiny code that makes the lunge message on cooldown not be spammable, doesn't need to be big so 5 will do.

/datum/action/human_action/activable/lunge/use_ability(atom/affected_atom, mob/living/carbon/owner)
	owner = usr

	if(!action_cooldown_check())
		to_chat(owner, SPAN_WARNING("You can't do that yet..."))
		return

	if (!affected_atom)
		return

	if (!isturf(owner.loc))
		to_chat(owner, SPAN_WARNING("We can't lunge from here!"))
		return

	var/mob/living/carbon/carbon = affected_atom
	if(carbon.stat == DEAD)
		return

	enter_cooldown(cooldown)
	..()

	owner.visible_message(SPAN_WARNING("[owner] lunges towards [carbon]!"), SPAN_WARNING("We lunge at [carbon]!"))

	owner.throw_atom(get_step_towards(affected_atom, owner), grab_range, SPEED_FAST, owner)

	if (owner.Adjacent(carbon))
		owner.start_pulling(carbon)
		carbon.KnockDown(1)
		carbon.Stun(1)
		if(ishuman(carbon))
			INVOKE_ASYNC(carbon, TYPE_PROC_REF(/mob, emote), "scream")
	return TRUE

/datum/unarmed_attack/punch/spartan
	attack_verb = list("pummel","slamm","punch")
	damage = 50
