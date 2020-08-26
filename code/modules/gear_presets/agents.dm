/datum/equipment_preset/uscm_ship/stowaway
	name = "Stowaway"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/visa
	access = list(
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)
	assignment = JOB_STOWAWAY
	rank = JOB_STOWAWAY
	paygrade = "???"
	role_comm_title = "???"
	skills = /datum/skills/civilian/survivor

	utility_under = list(/obj/item/clothing/under/liaison_suit/outing)
	utility_hat = list()
	utility_gloves = list()
	utility_shoes = list(/obj/item/clothing/shoes)
	utility_extra = list(/obj/item/clothing/under/liaison_suit/suspenders)

	service_under = list(/obj/item/clothing/under/liaison_suit)
	service_over = list()
	service_hat = list()
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/liaison_suit/formal)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/stowaway/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/stowaway(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/briefcase/stowaway(H), WEAR_L_HAND)

/datum/equipment_preset/upp/representative
	name = "UPP Representative"
	faction_group = FACTION_LIST_MARINE_UPP
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)
	assignment = JOB_UPP_REPRESENTATIVE
	rank = JOB_UPP_REPRESENTATIVE
	paygrade = "Representative"
	role_comm_title = "UPP Rep."
	skills = /datum/skills/civilian/survivor

/datum/equipment_preset/upp/representative/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/rep(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/gimmick/jason(H), WEAR_JACKET)

/datum/equipment_preset/ress/representative
	name = "RESS Representative"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_RESS
	faction_group = FACTION_LIST_MARINE_RESS

	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)
	assignment = JOB_RESS_REPRESENTATIVE
	rank = JOB_RESS_REPRESENTATIVE
	paygrade = "Representative"
	role_comm_title = "RESS Rep."
	skills = /datum/skills/civilian/survivor

/datum/equipment_preset/ress/representative/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_dutch)] [pick(last_names_clf)]"
		H.f_style = "Shaved"

	H.change_real_name(H, random_name)
	H.age = rand(17,35)
	H.h_style = "Crewcut"
	H.r_hair = 0
	H.g_hair = 0
	H.b_hair = 0
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19

/datum/equipment_preset/ress/representative/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/rep(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/ress_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)