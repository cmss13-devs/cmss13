/datum/equipment_preset/yautja
	name = "Yautja"
	idtype = null //No IDs for Yautja!
	languages = list("Sainja")
	rank = "Predator"
	faction = FACTION_YAUTJA
	uses_special_name = TRUE
	skills = /datum/skills/yautja/warrior
/datum/equipment_preset/yautja/load_race(mob/living/carbon/human/H)
	H.set_species("Yautja")

/datum/equipment_preset/yautja/load_id(mob/living/carbon/human/H)
	H.job = rank
	H.faction = faction

/datum/equipment_preset/yautja/load_vanity(mob/living/carbon/human/H)
	return //No vanity items for Yautja!

/datum/equipment_preset/yautja/load_name(mob/living/carbon/human/H, var/randomise)
	var/final_name = "Le'pro"
	H.gender = MALE
	H.age = 100

	if(H.client && H.client.prefs)
		H.gender = H.client.prefs.predator_gender
		H.age = H.client.prefs.predator_age
		final_name = H.client.prefs.predator_name
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Le'pro"
	H.change_real_name(H, final_name)

/*****************************************************************************************************/

/datum/equipment_preset/yautja/blooded
	name = "Yautja Blooded"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/blooded/load_gear(mob/living/carbon/human/H)
	var/armor_number = 1
	var/boot_number = 1
	var/mask_number = 1
	if(H.client && H.client.prefs)
		armor_number = H.client.prefs.predator_armor_type
		boot_number = H.client.prefs.predator_boot_type
		mask_number = H.client.prefs.predator_mask_type

	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H, boot_number), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(H, armor_number), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H, mask_number), WEAR_FACE)

/*****************************************************************************************************/

/datum/equipment_preset/yautja/blooded/councillor
	name = "Yautja Councillor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/blooded/councillor/load_name(mob/living/carbon/human/H, var/randomise)
	. = ..()
	var/new_name = "Councillor [H.real_name]"
	H.change_real_name(H, new_name)

/datum/equipment_preset/yautja/blooded/councillor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(H), WEAR_BACK)
	. = ..()

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder
	name = "Yautja Elder"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	var/elder_number = 0 //overwriting elder gear

/datum/equipment_preset/yautja/elder/load_name(mob/living/carbon/human/H, var/randomise)
	. = ..()
	var/new_name = "Elder [H.real_name]"
	H.change_real_name(H, new_name)

/datum/equipment_preset/yautja/elder/load_gear(mob/living/carbon/human/H)
	var/armor_number = 1
	var/boot_number = 1
	var/mask_number = 1
	if(H.client && H.client.prefs)
		armor_number = H.client.prefs.predator_armor_type
		boot_number = H.client.prefs.predator_boot_type
		mask_number = H.client.prefs.predator_mask_type
	if(elder_number)
		armor_number = elder_number
		mask_number = elder_number

	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H, boot_number), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(H, armor_number, 1), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H, mask_number, 1), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(H, armor_number), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder/dragon
	name = "Yautja Elder, Dragon"
	flags = EQUIPMENT_PRESET_EXTRA
	elder_number = 1341 //overwriting elder gear

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder/horror
	name = "Yautja Elder, Swamp Horror"
	flags = EQUIPMENT_PRESET_EXTRA
	elder_number = 7128 //overwriting elder gear

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder/enforcer
	name = "Yautja Elder, Enforcer"
	flags = EQUIPMENT_PRESET_EXTRA
	elder_number = 9867 //overwriting elder gear

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder/collector
	name = "Yautja Elder, Ambivalent Collector"
	flags = EQUIPMENT_PRESET_EXTRA
	elder_number = 4879 //overwriting elder gear

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
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/yautja_sword(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/spawnergrenade/smartdisc(H), WEAR_R_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/yautja/elder_geared
	name = "Yautja Elder, geared up"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/yautja/elder_geared/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
	var/obj/item/clothing/gloves/yautja/bracer = new(H)
	bracer.charge = 3000
	bracer.charge_max = 3000
	H.verbs += /obj/item/clothing/gloves/yautja/proc/translate
	bracer.upgrades = 2
	H.equip_to_slot_or_del((bracer), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja/full(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/glaive(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasmarifle(H), WEAR_R_HAND)
