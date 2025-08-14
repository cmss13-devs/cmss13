/datum/equipment_preset/cia
	name = "CIA"
	flags = EQUIPMENT_PRESET_EXTRA
	minimum_age = 25
	assignment = JOB_CIA
	skills = /datum/skills/cia
	languages = ALL_HUMAN_LANGUAGES
	faction = FACTION_MARINE

/datum/equipment_preset/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA)

/datum/equipment_preset/cia/analyst
	name = "CIA Agent (Civilian Clothing)"
	job_title = JOB_CIA
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CIV"
	minimap_background = "background_civillian"
	minimap_icon = "cia_ia"
	idtype = /obj/item/card/id/adaptive

/datum/equipment_preset/cia/analyst/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()

	//Give them a random piece of civvie clothing.
	var/random_outfit = pick(
		/obj/item/clothing/under/liaison_suit/black,
		/obj/item/clothing/under/liaison_suit/brown,
		/obj/item/clothing/under/liaison_suit/field,
		/obj/item/clothing/under/liaison_suit/outing,
	)

	var/random_suit = pick(
		/obj/item/clothing/suit/storage/jacket/marine/corporate/black,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/brown,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/blue,
		/obj/item/clothing/suit/storage/jacket/marine/bomber,
		/obj/item/clothing/suit/storage/jacket/marine/bomber/red,
		/obj/item/clothing/suit/storage/jacket/marine/bomber/grey,
		/obj/item/clothing/suit/storage/jacket/marine/vest,
		/obj/item/clothing/suit/storage/jacket/marine/vest/tan,
		/obj/item/clothing/suit/storage/jacket/marine/vest/grey,
	)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new random_outfit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new random_suit(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911/socom/equipped, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_IN_BACK)

/datum/equipment_preset/cia/officer
	name = "CIA Agent (USCM Liaison - 1st Lieutenant)"
	job_title = JOB_CIA_LIAISON
	assignment = JOB_CIA_LIAISON
	paygrades = list(PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "ILO"
	minimum_age = 25
	minimap_icon = "cia_lo"
	minimap_background = "background_ua"
	idtype = /obj/item/card/id/adaptive

/datum/equipment_preset/cia/officer/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/bridge(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/m1911(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert(new_human), WEAR_IN_BACK)

/datum/equipment_preset/cia/officer/o3
	name = "CIA Agent (USCM Liaison - Captain)"
	paygrades = list(PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_0)
	minimum_age = 30

/datum/equipment_preset/uscm/marsoc/low_threat/cia
	name = "CIA Agent (Marine Raider Advisor)"
	minimum_age = 30
	skills = /datum/skills/cia

/datum/equipment_preset/uscm/marsoc/low_threat/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA)

/datum/equipment_preset/uscm/marsoc/low_threat/cia/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	//Custom reduced loadout versus normal MARSOC
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/marsoc, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK) //CIA equipment
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_HELMET)
	//uniform
	var/obj/item/clothing/under/marine/veteran/marsoc/uniform = new()
	var/obj/item/clothing/accessory/storage/black_vest/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/sof/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/xm40, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/xm40/ap, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/marsoc, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_R_STORE)

/// Spies ///

/datum/equipment_preset/clf/engineer/cia
	name = "CIA Spy (CLF Engineer)"
	skills = /datum/skills/cia

/datum/equipment_preset/clf/engineer/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CIA)

/datum/equipment_preset/clf/engineer/cia/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/colonist/clf/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/webbing = new()
	uniform.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)

	spawn_rebel_suit(new_human)
	spawn_rebel_shoes(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/clf_patch, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/low_grade_full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_R_STORE)

	spawn_rebel_weapon(new_human)
	spawn_rebel_weapon(new_human,1)



/datum/equipment_preset/upp/soldier/dressed/cia
	name = "CIA Spy (UPP Soldier)"
	skills = /datum/skills/cia

/datum/equipment_preset/upp/soldier/dressed/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CIA)

/datum/equipment_preset/upp/soldier/dressed/cia/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert, WEAR_IN_BACK)


/datum/equipment_preset/upp/officer/senior/dressed/cia
	name = "CIA Spy (UPP Senior Officer)"
	skills = /datum/skills/cia

/datum/equipment_preset/upp/officer/senior/dressed/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CIA)

/datum/equipment_preset/upp/officer/senior/dressed/cia/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)


