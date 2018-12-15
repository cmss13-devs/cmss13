/datum/equipment_preset/uscm_ship
	name = "USCM (ship roles)"

/datum/equipment_preset/uscm_ship/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/so
	name = "USCM Staff Officer (SO)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/so/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Second Lieutenant"
	W.rank = "Staff Officer"
	W.registered_name = H.real_name
	W.paygrade = "O2"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "SO"
		H.mind.assigned_role = "Staff Officer"

/datum/equipment_preset/uscm_ship/so/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SO)

/datum/equipment_preset/uscm_ship/so/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/ro(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/xo
	name = "USCM Executive Officer (XO)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/xo/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "USCM Executive Officer"
	W.rank = "Executive Officer"
	W.registered_name = H.real_name
	W.paygrade = "O3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "XO"
		H.mind.assigned_role = "Executive Officer"

/datum/equipment_preset/uscm_ship/xo/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/XO)

/datum/equipment_preset/uscm_ship/xo/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/exec(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/co
	name = "USCM Commander (CO)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/co/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "USCM Commanding Officer"
	W.rank = "Commander"
	W.registered_name = H.real_name
	W.paygrade = "O4"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "CO"
		H.mind.assigned_role = "Commander"

/datum/equipment_preset/uscm_ship/co/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commander)

/datum/equipment_preset/uscm_ship/co/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/command(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/tan(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/officer
	name = "USCM Officer (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/officer/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/centcom/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "USCM Officer"
	W.registered_name = H.real_name
	W.paygrade = "O5"
	H.equip_if_possible(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Cpt"

/datum/equipment_preset/uscm_ship/officer/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commander)

/datum/equipment_preset/uscm_ship/officer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/rank/centcom/officer(H), WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_if_possible(new /obj/item/clothing/head/beret/centcom/officer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)

	var/obj/item/device/pda/heads/pda = new(H)
	pda.owner = H.real_name
	pda.ownjob = "USCM Officer"
	pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	H.equip_if_possible(pda, WEAR_R_STORE)
	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_if_possible(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/admiral
	name = "USCM Admiral (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/admiral/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/centcom/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "USCM Admiral"
	W.registered_name = H.real_name
	W.paygrade = "O7"
	H.equip_if_possible(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "ADM"

/datum/equipment_preset/uscm_ship/admiral/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/admiral)

/datum/equipment_preset/uscm_ship/admiral/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/admiral(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/admiral(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/admiral(H), WEAR_JACKET)

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/admiral(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)

	var/obj/item/device/pda/heads/pda = new(H)
	pda.owner = H.real_name
	pda.ownjob = "USCM Admiral"
	pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	H.equip_if_possible(pda, WEAR_R_STORE)
	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/upp_spy
	name = "UPP Spy"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/upp_spy/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_MARINE_ENGINEERING)
	W.assignment = "Maintenance Tech"
	W.registered_name = H.real_name
	W.paygrade = "E6E"
	H.equip_if_possible(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "MT"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/uscm_ship/upp_spy/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/spy)

/datum/equipment_preset/uscm_ship/upp_spy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_EAR)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/c99/upp/tranq(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99t(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99t(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/datum/equipment_preset/uscm_ship/upp_spy/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian"))//can speak russian, but it's not default

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/fleet_admiral
	name = "Fleet Admiral" //Renamed from Soviet Admiral
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_ship/fleet_admiral/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "Fleet Admiral"
	W.registered_name = H.real_name
	W.paygrade = "O8"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "FADM"

/datum/equipment_preset/uscm_ship/fleet_admiral/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/admiral)

/datum/equipment_preset/uscm_ship/fleet_admiral/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hgpiratecap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/hgpirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), WEAR_BODY)
