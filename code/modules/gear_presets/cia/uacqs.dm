/// UACQS ///

/datum/equipment_preset/cia/uacqs
	name = "CIA Agent (UACQS Administrator)"
	job_title = JOB_CIA_UACQS_ADMN
	assignment = JOB_CIA_UACQS_ADMN
	paygrades = list(PAY_SHORT_CIA_ADM = JOB_PLAYTIME_TIER_0)
	role_comm_title = "UACQS"
	minimap_icon = "uacqs"
	minimap_background = "background_ua"

/datum/equipment_preset/cia/uacqs/load_gear(mob/living/carbon/human/new_human, client/mob_client)
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
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/antag(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_IN_BACK)

/datum/equipment_preset/cia/uacqs/commissioner
	name = "CIA Senior Agent (UACQS Commissioner)"
	job_title = JOB_CIA_UACQS_COMR
	assignment = JOB_CIA_UACQS_COMR
	paygrades = list(PAY_SHORT_CIA_COM = JOB_PLAYTIME_TIER_0)
	minimap_icon = "uacqs_c"
	idtype = /obj/item/card/id/adaptive/silver
	skills = /datum/skills/cia/field_agent/senior

/datum/equipment_preset/cia/uacqs/commissioner/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA, ACCESS_CIA_SENIOR)

/datum/equipment_preset/cia/uacqs/commissioner/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/paper/prefab/uacqs_notice(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/syringe/uacqs_fountain(new_human), WEAR_R_EAR)

/datum/equipment_preset/cia/uacqs/security
	name = "CIA Agent (UACQS Security)"
	job_title = JOB_CIA_UACQS_SEC
	assignment = JOB_CIA_UACQS_SEC
	paygrades = list(PAY_SHORT_CIA_O = JOB_PLAYTIME_TIER_0)
	minimap_icon = "uacqs_s"
	skills = /datum/skills/cia/security_officer

/datum/equipment_preset/cia/uacqs/security/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/low_points, WEAR_IN_BACK) //CIA equipment
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/antag(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black, WEAR_FACE)

	//uniform
	var/obj/item/clothing/under/suit_jacket/uniform = new()
	var/obj/item/clothing/accessory/storage/webbing/black/accessory = new()
	var/obj/item/clothing/accessory/health/ceramic_plate/plate = new()
	uniform.attach_accessory(new_human, accessory)
	uniform.attach_accessory(new_human, plate)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m4a4_tactical, WEAR_WAIST)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/mp5a6, WEAR_J_STORE)

	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5/ap/black, WEAR_R_STORE)
