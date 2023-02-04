/datum/equipment_preset/wy
	name = "WY"
	paygrade = "WYC1"

	faction = FACTION_WY
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver
	faction_group = FACTION_LIST_WY
	access = list(
		ACCESS_WY_CORPORATE,
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH,
		ACCESS_WY_CORPORATE_DS,
		ACCESS_MARINE_MEDBAY,
	)
	skills = /datum/skills/civilian
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/headset_type = /obj/item/device/radio/headset/distress/WY

/datum/equipment_preset/wy/New()
	. = ..()
	access += get_all_civilian_accesses() + get_all_centcom_access()

/datum/equipment_preset/wy/load_id(mob/living/carbon/human/H)
	. = ..()

/datum/equipment_preset/wy/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new headset_type(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	. = ..()

/datum/equipment_preset/wy/trainee
	name = "Corporate - A - Trainee"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_TRAINEE
	rank = JOB_TRAINEE
	paygrade = "WYC1"

/datum/equipment_preset/wy/trainee/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/trainee(H), WEAR_BODY)
	. = ..()

/datum/equipment_preset/wy/junior_exec
	name = "Corporate - B - Junior Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_JUNIOR_EXECUTIVE
	rank = JOB_JUNIOR_EXECUTIVE
	paygrade = "WYC2"

/datum/equipment_preset/wy/exec
	name = "Corporate - C - Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_EXECUTIVE
	rank = JOB_EXECUTIVE
	paygrade = "WYC3"

/datum/equipment_preset/wy/senior_exec
	name = "Corporate - D - Senior Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_SENIOR_EXECUTIVE
	rank = JOB_SENIOR_EXECUTIVE
	paygrade = "WYC4"

/datum/equipment_preset/wy/exec_spec
	name = "Corporate - E - Executive Specialist"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_EXECUTIVE_SPECIALIST
	rank = JOB_EXECUTIVE_SPECIALIST
	paygrade = "WYC5"

/datum/equipment_preset/wy/exec_supervisor
	name = "Corporate - F - Executive Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_EXECUTIVE_SUPERVISOR
	rank = JOB_EXECUTIVE_SUPERVISOR
	paygrade = "WYC6"

/datum/equipment_preset/wy/manager
	skills = /datum/skills/civilian/manager
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	headset_type = /obj/item/device/radio/headset/distress/pmc/command

/datum/equipment_preset/wy/manager/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/wy/manager/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/manager(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	..()

/datum/equipment_preset/wy/manager/assistant_manager
	name = "Corporate - G - Assistant Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_ASSISTANT_MANAGER
	rank = JOB_ASSISTANT_MANAGER
	paygrade = "WYC7"

/datum/equipment_preset/wy/manager/division_manager
	name = "Corporate - H - Division Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_DIVISION_MANAGER
	rank = JOB_DIVISION_MANAGER
	paygrade = "WYC8"

/datum/equipment_preset/wy/manager/chief_executive
	name = "Corporate - I - Chief Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CHIEF_EXECUTIVE
	rank = JOB_CHIEF_EXECUTIVE
	paygrade = "WYC9"

/datum/equipment_preset/wy/manager/director
	name = "Corporate - J - Director"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_DIRECTOR
	rank = JOB_DIRECTOR
	paygrade = "WYC10"
	skills = /datum/skills/civilian/manager/director
	headset_type = /obj/item/device/radio/headset/distress/pmc/command/director

/datum/equipment_preset/wy/manager/director/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/director(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/director(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/director(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general(H), WEAR_WAIST)
	..()
