/// Spies ///


/// CLF ///
/datum/equipment_preset/clf/soldier/cia_spy
	name = "CLF Soldier (CIA Spy)"
	skills = /datum/skills/cia/field_agent
	faction_group = FACTION_LIST_CIA_CLF
	selection_categories = list("CIA")

/datum/equipment_preset/clf/soldier/cia_spy/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CIA)

/datum/equipment_preset/clf/soldier/cia_spy/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)


/datum/equipment_preset/clf/engineer/cia_spy
	name = "CLF Engineer (CIA Spy)"
	skills = /datum/skills/cia/field_agent
	faction_group = FACTION_LIST_CIA_CLF
	selection_categories = list("CIA")

/datum/equipment_preset/clf/engineer/cia_spy/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CIA)

/datum/equipment_preset/clf/engineer/cia_spy/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)


/// UPP ///
/datum/equipment_preset/upp/soldier/dressed/cia_spy
	name = "UPP Soldier (CIA Spy)"
	skills = /datum/skills/cia/field_agent
	faction_group = FACTION_LIST_CIA_UPP
	selection_categories = list("CIA")

/datum/equipment_preset/upp/soldier/dressed/cia_spy/New()
	. = ..()
	access = get_access(ACCESS_LIST_UPP_ALL) + list(ACCESS_CIA)

/datum/equipment_preset/upp/soldier/dressed/cia_spy/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert, WEAR_IN_BACK)


/datum/equipment_preset/upp/officer/senior/dressed/cia_spy
	name = "UPP Starshiy Leytenant (CIA Spy)"
	skills = /datum/skills/cia/field_agent/senior
	faction_group = FACTION_LIST_CIA_UPP
	selection_categories = list("CIA")

/datum/equipment_preset/upp/officer/senior/dressed/cia_spy/New()
	. = ..()
	access = get_access(ACCESS_LIST_UPP_ALL) + list(ACCESS_CIA, ACCESS_CIA_SENIOR)

/datum/equipment_preset/upp/officer/senior/dressed/cia_spy/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)


/// Wey-Yu ///
/datum/equipment_preset/goon/standard/cia_spy
	name = "Weyland-Yutani Corporate Security Goon (CIA Spy)"
	skills = /datum/skills/cia/field_agent
	faction_group = FACTION_LIST_CIA_WY
	selection_categories = list("CIA")

/datum/equipment_preset/goon/standard/cia_spy/kutjevo
	name = "Weyland-Yutani Corporate Security Goon (CIA Spy) (Kutjevo Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo

/datum/equipment_preset/goon/standard/cia_spy/hybrisa
	name = "Weyland-Yutani Corporate Security Goon (CIA Spy) (Hybrisa Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa

/datum/equipment_preset/goon/standard/cia_spy/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_GOON) + list(ACCESS_CIA)

/datum/equipment_preset/goon/standard/cia_spy/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)


/datum/equipment_preset/pmc/pmc_standard/cia_spy
	name = "Weyland-Yutani PMC (Standard) (CIA Spy)"
	skills = /datum/skills/cia/field_agent/adv
	faction_group = FACTION_LIST_CIA_WY
	selection_categories = list("CIA")

/datum/equipment_preset/pmc/pmc_standard/cia_spy/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_PMC) + list(ACCESS_CIA)

/datum/equipment_preset/pmc/pmc_standard/cia_spy/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)


/datum/equipment_preset/wy/senior_exec
	name = "Corporate - D - Senior Executive (CIA Spy)"
	skills = /datum/skills/cia/field_agent
	faction_group = FACTION_LIST_CIA_WY
	selection_categories = list("CIA")

/datum/equipment_preset/wy/senior_exec/New()
	. = ..()
	access += get_access(ACCESS_LIST_WY_BASE) + list(ACCESS_CIA)

/datum/equipment_preset/wy/senior_exec/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK)
