
/datum/equipment_preset/survivor/scientist/fiorina
	name = "Survivor - Fiorina Researcher"
	assignment = JOB_WY_RESEARCHER
	job_title = JOB_WY_RESEARCHER
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CRC"
	skills = /datum/skills/researcher
	minimap_icon = "goon_sci"
	idtype = /obj/item/card/id/silver/cl
	faction = FACTION_WY
	faction_group = FACTION_LIST_SURVIVOR_WY
	origin_override = ORIGIN_WY
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

/datum/equipment_preset/survivor/scientist/fiorina/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	..()


/datum/equipment_preset/survivor/doctor/fiorina
	name = "Survivor - Fiorina Doctor"
	assignment = JOB_WY_GOON_MEDIC
	job_title = JOB_WY_GOON_MEDIC
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	minimap_icon = "goon_med"
	role_comm_title = "CSM"
	idtype = /obj/item/card/id/silver/cl
	faction = FACTION_WY
	faction_group = FACTION_LIST_SURVIVOR_WY
	origin_override = ORIGIN_WY
	skills = /datum/skills/civilian/survivor/goon/medic
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)


/datum/equipment_preset/survivor/doctor/fiorina/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/lightblue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/sec(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/security/fiorina
	name = "Survivor - Fiorina Prison Guard"
	assignment = JOB_WY_SEC
	job_title = JOB_WY_SEC
	minimap_background = "background_goon"
	minimap_icon = "cmp"
	role_comm_title = "CSG"
	idtype = /obj/item/card/id/silver/cl
	faction = FACTION_WY
	faction_group = FACTION_LIST_SURVIVOR_WY
	origin_override = ORIGIN_WY
	skills = /datum/skills/civilian/survivor/goon
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

/datum/equipment_preset/survivor/security/fiorina/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/wy_cap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/colonial_marshal/fiorina
	name = "Survivor - United Americas Riot Control Officer"
	assignment = "United Americas Riot Control Officer"
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/silver
	job_title = JOB_CMB_RIOT
	role_comm_title = "UA RCO"
	faction = FACTION_MARSHAL
	faction_group = FACTION_LIST_SURVIVOR_UA
	minimap_icon = "rmp"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/colonial_marshal/fiorina/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/ua(new_human), WEAR_ACCESSORY)

	..()

/datum/equipment_preset/survivor/engineer/fiorina
	name = "Survivor - Fiorina Engineer"
	assignment = JOB_WY_GOON_TECH
	job_title = JOB_WY_GOON_TECH
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CST"
	skills = /datum/skills/wy_goon_tech
	minimap_icon = "goon_engi"
	faction = FACTION_WY
	faction_group = FACTION_LIST_SURVIVOR_WY
	origin_override = ORIGIN_WY
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
/datum/equipment_preset/survivor/engineer/fiorina/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/engi(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	..()

/datum/equipment_preset/survivor/corporate/fiorina
	name = "Survivor - Fiorina Corporate Liaison"
	assignment = "Fiorina Corporate Liaison"

/datum/equipment_preset/survivor/corporate/fiorina/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	..()
