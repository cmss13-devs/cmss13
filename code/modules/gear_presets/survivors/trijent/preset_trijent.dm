/datum/equipment_preset/survivor/chaplain/trijent
	name = "Survivor - Trijent Chaplain"
	assignment = "Trijent Dam Chaplain"

/datum/equipment_preset/survivor/chaplain/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/nun(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/nun_hood(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(new_human), WEAR_JACKET)
	add_survivor_rare_item(new_human)
	..()

/datum/equipment_preset/survivor/security/trijent
	name = "Survivor - Trijent Security Guard"
	assignment = JOB_WY_SEC
	job_title = JOB_WY_SEC
	minimap_background = "background_goon"
	minimap_icon = "cmp"
	faction = FACTION_WY
	idtype = /obj/item/card/id/silver/cl
	faction_group = list(FACTION_WY, FACTION_SURVIVOR)
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_WY_GENERAL, ACCESS_WY_COLONIAL, ACCESS_WY_MEDICAL, ACCESS_WY_ENGINEERING)

/datum/equipment_preset/survivor/security/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/sec(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/colonial_marshal/trijent
	name = "Survivor - Trijent Colonial Marshal Deputy"
	assignment = "CMB Deputy"

/datum/equipment_preset/survivor/colonial_marshal/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/doctor/trijent
	name = "Survivor - Trijent Doctor"
	assignment = "Trijent Dam Doctor"

/datum/equipment_preset/survivor/doctor/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/scientist/trijent
	name = "Survivor - Trijent Researcher"
	assignment = "Trijent Dam Researcher"

/datum/equipment_preset/survivor/scientist/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/rd(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/jan(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/trucker/trijent
	name = "Survivor - Trijent Heavy Vehicle Operator"
	assignment = "Trijent Dam Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker

/datum/equipment_preset/survivor/trucker/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(new_human), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/engineer/trijent/hydro
	name = "Survivor - Hydro Electric Engineer"
	assignment = "Hydro Electric Engineer"

/datum/equipment_preset/survivor/engineer/trijent/hydro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/survivor/engineer/trijent
	name = "Survivor - Dam Maintenance Technician"
	assignment = "Dam Maintenance Technician"

/datum/equipment_preset/survivor/engineer/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/corporate/trijent
	name = "Survivor - Trijent Corporate Liaison"
	assignment = "Trijent Dam Corporate Liaison"

/datum/equipment_preset/survivor/corporate/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	..()
