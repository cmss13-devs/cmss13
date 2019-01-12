

/datum/equipment_preset/yautja
	name = "Yautja"
	idtype = null //No IDs for Yautja!
	languages = list("Sainja")

/datum/equipment_preset/yautja/load_id(mob/living/carbon/human/H)
	//No ID for preds!
	if(H.mind)
		H.mind.assigned_role = "PRED"
		H.mind.special_role = "Yautja"

/datum/equipment_preset/yautja/load_vanity(mob/living/carbon/human/H)
	return //No vanity items for Yautja!

/*****************************************************************************************************/

/datum/equipment_preset/yautja/warrior
	name = "Yautja Warrior"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/yautja/warrior/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
	var/obj/item/clothing/gloves/yautja/bracer = new(H)
	bracer.charge = 2500
	bracer.charge_max = 2500
	H.verbs += /obj/item/clothing/gloves/yautja/proc/translate
	bracer.upgrades = 1
	H.equip_to_slot_or_del((bracer), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/yautja_sword(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/spawnergrenade/smartdisc(H), WEAR_R_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder
	name = "Yautja Elder"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/yautja/elder/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
	var/obj/item/clothing/gloves/yautja/bracer = new(H)
	bracer.charge = 3000
	bracer.charge_max = 3000
	H.verbs += /obj/item/clothing/gloves/yautja/proc/translate
	bracer.upgrades = 2
	H.equip_to_slot_or_del((bracer), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja/full(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/twohanded/glaive(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasmarifle(H), WEAR_R_HAND)
