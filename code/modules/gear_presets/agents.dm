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
		ACCESS_MARINE_MAINT,
	)
	assignment = JOB_STOWAWAY
	rank = JOB_STOWAWAY
	paygrades = list("???" = JOB_PLAYTIME_TIER_0)
	role_comm_title = "???"
	skills = /datum/skills/civilian/survivor

	utility_under = list(/obj/item/clothing/under/liaison_suit/outing)
	utility_hat = list()
	utility_gloves = list()
	utility_shoes = list(/obj/item/clothing/shoes/laceup)
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

/datum/equipment_preset/uscm_ship/stowaway/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/stowaway(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/briefcase/stowaway(new_human), WEAR_L_HAND)

/datum/equipment_preset/upp/representative
	name = "UPP Representative"
	faction_group = FACTION_LIST_MARINE_UPP
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_FLIGHT,
		ACCESS_UPP_LEADERSHIP,
	)
	assignment = JOB_UPP_REPRESENTATIVE
	rank = JOB_UPP_REPRESENTATIVE
	paygrades = list(PAY_SHORT_CREP = JOB_PLAYTIME_TIER_0)
	role_comm_title = "UPP Rep."
	skills = /datum/skills/civilian/survivor

/datum/equipment_preset/upp/representative/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/rep(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/gimmick/jason(new_human), WEAR_JACKET)

/datum/equipment_preset/twe/representative
	name = "TWE Representative"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_TWE
	faction_group = FACTION_LIST_MARINE_TWE

	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_TWE_GENERAL,
		ACCESS_TWE_FLIGHT,
		ACCESS_TWE_LEADERSHIP,
	)
	assignment = JOB_TWE_REPRESENTATIVE
	rank = JOB_TWE_REPRESENTATIVE
	paygrades = list(PAY_SHORT_CREP = JOB_PLAYTIME_TIER_0)
	role_comm_title = "TWE Rep."
	skills = /datum/skills/civilian/survivor

/datum/equipment_preset/twe/representative/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male_dutch)] [pick(GLOB.last_names_clf)]"
		new_human.f_style = "Shaved"

	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(17,35)
	new_human.h_style = "Crewcut"
	new_human.r_hair = 0
	new_human.g_hair = 0
	new_human.b_hair = 0
	new_human.r_eyes = 139
	new_human.g_eyes = 62
	new_human.b_eyes = 19

/datum/equipment_preset/twe/representative/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/rep(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/twe_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
