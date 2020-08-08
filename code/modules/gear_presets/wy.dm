/datum/equipment_preset/wy
	name = "WY"
	paygrade = "WY-XA"

	faction = FACTION_WY
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver
	faction_group = FACTION_LIST_WY
	access = list(
		ACCESS_IFF_MARINE,
		ACCESS_WY_CORPORATE,
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY
	)
	skills = /datum/skills/civilian

/datum/equipment_preset/wy/New()
	. = ..()
	access += get_all_civilian_accesses() + get_all_centcom_access()

/datum/equipment_preset/wy/load_id(mob/living/carbon/human/H)
	. = ..()
	H.apply_wy_rank_code(load_rank(), assignment, role_comm_title)

/datum/equipment_preset/wy/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	. = ..()

/datum/equipment_preset/wy/trainee
	name = "Corporate - A - Trainee"
	flags = EQUIPMENT_PRESET_EXTRA

	paygrade = "WY-XA"

/datum/equipment_preset/wy/trainee/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/trainee(H), WEAR_BODY)
	. = ..()

/datum/equipment_preset/wy/junior_exec
	name = "Corporate - B - Junior Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XB"

/datum/equipment_preset/wy/exec
	name = "Corporate - C - Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XC"

/datum/equipment_preset/wy/senior_exec
	name = "Corporate - D - Senior Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XD"

/datum/equipment_preset/wy/exec_spec
	name = "Corporate - E - Executive Specialist"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XE"

/datum/equipment_preset/wy/exec_supervisor
	name = "Corporate - F - Executive Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XF"

/datum/equipment_preset/wy/manager
	name = "Corporate Manager"
	paygrade = "WY-XG"
	access = list()
	skills = /datum/skills/civilian/manager
	idtype = /obj/item/card/id/silver/clearance_badge/manager

/datum/equipment_preset/wy/manager/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/wy/manager/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/manager(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	..()

/datum/equipment_preset/wy/manager/survivor
	name = "Survivor - Corporate Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-5G"
	assignment = "Colony Supervisor"
	role_comm_title = "Supervisor"


/datum/equipment_preset/wy/manager/survivor/load_skills(mob/living/carbon/human/H)
	. = ..()
	H.skills.set_skill(SKILL_ENDURANCE, SKILL_ENDURANCE_SURVIVOR)
	

/datum/equipment_preset/wy/manager/survivor/load_gear(mob/living/carbon/human/H)
	. = ..()
	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	add_survivor_weapon(H)

/datum/equipment_preset/wy/manager/assistant_manager
	name = "Corporate - G - Assistant Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XG"

/datum/equipment_preset/wy/manager/division_manager
	name = "Corporate - H - Division Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XH"

/datum/equipment_preset/wy/manager/chief_executive
	name = "Corporate - I - Chief Executive"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XI"

/datum/equipment_preset/wy/manager/director
	name = "Corporate - J - Director"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-XJ"

/datum/equipment_preset/wy/manager/director/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/director(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/director(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/director(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral(H), WEAR_WAIST)
	..()