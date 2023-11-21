/datum/equipment_preset/wy
	name = "WY"
	paygrade = "WYC1"

	faction = FACTION_WY
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver
	faction_group = FACTION_LIST_WY
	skills = /datum/skills/civilian
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/headset_type = /obj/item/device/radio/headset/distress/WY

/datum/equipment_preset/wy/New()
	. = ..()
	access += get_access(ACCESS_LIST_WY_BASE)

/datum/equipment_preset/wy/load_id(mob/living/carbon/human/new_human)
	. = ..()

/datum/equipment_preset/wy/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	. = ..()

/datum/equipment_preset/wy/trainee
	name = "Corporate - A - Trainee"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_TRAINEE
	rank = JOB_TRAINEE
	paygrade = "WYC1"

/datum/equipment_preset/wy/trainee/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/trainee(new_human), WEAR_BODY)
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
	access = get_access(ACCESS_LIST_WY_SENIOR)

/datum/equipment_preset/wy/manager/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/manager(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(new_human), WEAR_WAIST)
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

/datum/equipment_preset/wy/manager/chief_executive/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_ALL)

/datum/equipment_preset/wy/manager/director
	name = "Corporate - J - Director"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_DIRECTOR
	rank = JOB_DIRECTOR
	paygrade = "WYC10"
	skills = /datum/skills/civilian/manager/director
	headset_type = /obj/item/device/radio/headset/distress/pmc/command/director

/datum/equipment_preset/wy/manager/director/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_ALL)

/datum/equipment_preset/wy/manager/director/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/director(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/director(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/director(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general(new_human), WEAR_WAIST)
	..()
