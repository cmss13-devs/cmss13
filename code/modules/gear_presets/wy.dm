/datum/equipment_preset/wy
	name = "WY"
	paygrades = list(PAY_SHORT_WYC1 = JOB_PLAYTIME_TIER_0)

	faction = FACTION_WY
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver
	faction_group = FACTION_LIST_WY
	skills = /datum/skills/civilian
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/headset_type = /obj/item/device/radio/headset/distress/WY

	dress_under = list(
		/obj/item/clothing/under/liaison_suit/black,
		/obj/item/clothing/under/liaison_suit/blue,
		/obj/item/clothing/under/liaison_suit/brown,
		/obj/item/clothing/under/liaison_suit/corporate_formal,
		/obj/item/clothing/under/liaison_suit,
		/obj/item/clothing/under/liaison_suit/charcoal,
		/obj/item/clothing/under/liaison_suit/formal,
		/obj/item/clothing/under/liaison_suit/blazer,
		/obj/item/clothing/under/liaison_suit/suspenders,
		/obj/item/clothing/under/blackskirt,
		/obj/item/clothing/under/suit_jacket/trainee,
		/obj/item/clothing/under/liaison_suit/ivy,
		/obj/item/clothing/under/liaison_suit/orange,
		/obj/item/clothing/under/liaison_suit/field,
		/obj/item/clothing/under/colonist/workwear,
		/obj/item/clothing/under/colonist/workwear/khaki,
		/obj/item/clothing/under/colonist/workwear/pink,
		/obj/item/clothing/under/colonist/workwear/green,
	)
	dress_over = list(
		/obj/item/clothing/suit/storage/jacket/marine/corporate/black,
		/obj/item/clothing/suit/storage/jacket/marine/corporate,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/brown,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/blue,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/black,
		/obj/item/clothing/suit/storage/jacket/marine/bomber/grey,
		/obj/item/clothing/suit/storage/jacket/marine/bomber/red,
		/obj/item/clothing/suit/storage/jacket/marine/bomber,
		/obj/item/clothing/suit/storage/bomber,
		/obj/item/clothing/suit/storage/bomber/alt,
		/obj/item/clothing/suit/storage/snow_suit/liaison,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/jacket/marine/vest/grey,
		/obj/item/clothing/suit/storage/jacket/marine/vest,
		/obj/item/clothing/suit/storage/jacket/marine/vest/tan,
		/obj/item/clothing/suit/storage/webbing,
	)
	dress_extra = list(
		/obj/item/clothing/accessory/black,
		/obj/item/clothing/accessory/red,
		/obj/item/clothing/accessory/purple,
		/obj/item/clothing/accessory/blue,
		/obj/item/clothing/accessory/green,
		/obj/item/clothing/accessory/gold,
		/obj/item/clothing/accessory/horrible,
		/obj/item/clothing/glasses/sunglasses/big,
		/obj/item/clothing/glasses/sunglasses/aviator,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/glasses/sunglasses/prescription,
		/obj/item/clothing/glasses/regular/hipster,
	)
	dress_gloves = list(
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/marine/dress,
	)
	dress_shoes = list(
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/marine/corporate,
	)
	dress_hat = list(
		/obj/item/clothing/head/fedora,
		/obj/item/clothing/head/beret/cm/black/civilian,
		/obj/item/clothing/head/beret/cm/white/civilian,
	)

/datum/equipment_preset/wy/New()
	. = ..()
	access += get_access(ACCESS_LIST_WY_BASE)

/datum/equipment_preset/wy/load_id(mob/living/carbon/human/new_human)
	. = ..()

/datum/equipment_preset/wy/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	. = ..()

/datum/equipment_preset/wy/trainee
	name = "Corporate - A - Trainee"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_TRAINEE
	rank = JOB_TRAINEE
	paygrades = list(PAY_SHORT_WYC1 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/trainee/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/trainee(new_human), WEAR_BODY)
	. = ..()

/datum/equipment_preset/wy/junior_exec
	name = "Corporate - B - Junior Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_JUNIOR_EXECUTIVE
	rank = JOB_JUNIOR_EXECUTIVE
	paygrades = list(PAY_SHORT_WYC2 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/exec
	name = "Corporate - C - Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_EXECUTIVE
	rank = JOB_EXECUTIVE
	paygrades = list(PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/senior_exec
	name = "Corporate - D - Senior Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_SENIOR_EXECUTIVE
	rank = JOB_SENIOR_EXECUTIVE
	paygrades = list(PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/exec_spec
	name = "Corporate - E - Executive Specialist"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_EXECUTIVE_SPECIALIST
	rank = JOB_EXECUTIVE_SPECIALIST
	paygrades = list(PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/exec_spec/lawyer
	name = "Corporate - E - Lawyer"

/datum/equipment_preset/wy/exec_spec/lawyer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/notepad/blue(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human), WEAR_L_STORE)

	..()

/datum/equipment_preset/wy/exec_supervisor
	name = "Corporate - F - Executive Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_EXECUTIVE_SUPERVISOR
	rank = JOB_EXECUTIVE_SUPERVISOR
	paygrades = list(PAY_SHORT_WYC6 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/exec_supervisor/lawyer
	name = "Corporate - F - Lawyer"

/datum/equipment_preset/wy/exec_supervisor/lawyer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/secure/briefcase(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000/counterfeit(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/notepad/black(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human), WEAR_L_STORE)
	..()

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
	paygrades = list(PAY_SHORT_WYC7 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/manager/division_manager
	name = "Corporate - H - Division Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_DIVISION_MANAGER
	rank = JOB_DIVISION_MANAGER
	paygrades = list(PAY_SHORT_WYC8 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/manager/chief_executive
	name = "Corporate - I - Chief Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CHIEF_EXECUTIVE
	rank = JOB_CHIEF_EXECUTIVE
	paygrades = list(PAY_SHORT_WYC9 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/wy/manager/chief_executive/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_ALL)

/datum/equipment_preset/wy/manager/director
	name = "Corporate - J - Director"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_DIRECTOR
	rank = JOB_DIRECTOR
	paygrades = list(PAY_SHORT_WYC10 = JOB_PLAYTIME_TIER_0)
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
