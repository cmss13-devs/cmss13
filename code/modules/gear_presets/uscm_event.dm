/datum/equipment_preset/uscm_event
	name = "USCM (Event Roles)"
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	minimum_age = 30
	languages = list(LANGUAGE_ENGLISH)


/*****************************************************************************************************/

/datum/equipment_preset/uscm_event/colonel
	name = "USCM O-6 - Colonel (High Command)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/general
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_COLONEL
	rank = JOB_COLONEL
	paygrade = "MO6"
	role_comm_title = "COL"
	minimum_age = 40
	skills = /datum/skills/general
	languages = ALL_HUMAN_LANGUAGES //Know your enemy.

	utility_under = list(/obj/item/clothing/under/marine,/obj/item/clothing/under/marine/officer/command)
	utility_hat = list(/obj/item/clothing/head/cmcap,/obj/item/clothing/head/beret/cm/tan)
	utility_extra = list(/obj/item/clothing/glasses/sunglasses,/obj/item/clothing/glasses/sunglasses/big,/obj/item/clothing/glasses/sunglasses/aviator,/obj/item/clothing/glasses/mbcg)

	service_under = list(/obj/item/clothing/under/marine/officer/formal/white, /obj/item/clothing/under/marine/officer/formal/black)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)
	service_hat = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/marine/commander/dress, /obj/item/clothing/head/beret/marine/commander/black)

	dress_under = list(/obj/item/clothing/under/marine/dress, /obj/item/clothing/under/marine/officer/formal/servicedress)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain/white, /obj/item/clothing/head/marine/peaked/captain/black)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/black, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit)

/datum/equipment_preset/uscm_event/colonel/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_event/colonel/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/flash, WEAR_IN_JACKET)

/datum/equipment_preset/uscm_event/general
	name = "USCM O-7 - Brigadier General (High Command)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/general
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_GENERAL
	rank = JOB_GENERAL
	paygrade = "MO7"
	role_comm_title = "GEN"
	minimum_age = 50
	skills = /datum/skills/general
	languages = ALL_HUMAN_LANGUAGES //Know your enemy.

	service_under = list(/obj/item/clothing/under/marine/officer/general, /obj/item/clothing/under/marine/officer/bridge)
	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/general, /obj/item/clothing/suit/storage/jacket/marine/service, /obj/item/clothing/suit/storage/jacket/marine/service/mp)
	service_gloves = list(/obj/item/clothing/gloves/black, /obj/item/clothing/gloves/marine/dress)
	service_hat = list(/obj/item/clothing/head/general, /obj/item/clothing/head/beret/marine/commander/black)

/datum/equipment_preset/uscm_event/general/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_event/general/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/general(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/general(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/dress/general(H), WEAR_JACKET)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/large/mateba/impact(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/general(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/cotablet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/mateba_case/general(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/flash, WEAR_IN_JACKET)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

/datum/equipment_preset/uscm_event/general/o7
		name = "USCM O-7 - Brigadier General (High Command)"
		paygrade = "MO7"

/datum/equipment_preset/uscm_event/general/o8
		name = "USCM O-8 - Major General (High Command)"
		paygrade = "MO8"

/datum/equipment_preset/uscm_event/general/o9
		name = "USCM O-9 - Lieutenant General (High Command)"
		paygrade = "MO9"

/datum/equipment_preset/uscm_event/general/o10
		name = "USCM O-10 - General (High Command)"
		paygrade = "MO10"

/datum/equipment_preset/uscm_event/general/o10c
		name = "USCM O-10C - Assistant Commandant of the Marine Corps (High Command)"
		paygrade = "MO10C"

/datum/equipment_preset/uscm_event/general/o10s
		name = "USCM O-10S - Commandant of the Marine Corps (High Command)"
		paygrade = "MO10S"

/*****************************************************************************************************/

/datum/equipment_preset/uscm_event/upp_spy
	name = "UPP Spy"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN)
	access = list(
		ACCESS_MARINE_ENGINEERING,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
	)
	assignment = JOB_ORDNANCE_TECH
	rank = "UPP"
	paygrade = "ME2"
	role_comm_title = "OT"
	skills = /datum/skills/spy

/datum/equipment_preset/uscm_event/upp_spy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi/OT(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/demo_scanner(H), WEAR_L_STORE)

	//TODO: preload all of those items before equipping the backpack
	//Otherwise, if you spawn the spy next to other people
	//they will see messages for them putting guns and explosives into their backpack...
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/c99/upp/tranq(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99/tranq(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99/tranq(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp(H.back), WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H.back), WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H.back), WEAR_IN_R_STORE)



/*****************************************************************************************************/

/datum/equipment_preset/uscm_event/provost
	name = "USCM Provost"

	idtype = /obj/item/card/id/provost
	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
		ACCESS_WY_CORPORATE,
	)
	skills = /datum/skills/provost

/datum/equipment_preset/uscm_event/provost/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/uscm_event/provost/enforcer
	name = "Provost Enforcer (ME5)"

	assignment = JOB_PROVOST_ENFORCER
	rank = "Provost Enforcer"
	paygrade = "ME5"
	role_comm_title = "PvE"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/provost/enforcer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/enforcer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost/enforcer(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/provost(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/riot(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/slug(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot(H), WEAR_L_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat(H), WEAR_J_STORE)

/datum/equipment_preset/uscm_event/provost/tml
	name = "Provost Team Leader (ME6)"
	skills = /datum/skills/CMP

	assignment = JOB_PROVOST_TML
	rank = "Provost Team Leader"
	paygrade = "ME6"
	role_comm_title = "PvTML"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/provost/tml/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/tml(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost/tml(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/provost/senior(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/riot(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/slug(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/box/nade_box/tear_gas(H), WEAR_R_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat(H), WEAR_J_STORE)


/datum/equipment_preset/uscm_event/provost/advisor
	name = "Provost Advisor (ME6)"
	skills = /datum/skills/CMP

	assignment = JOB_PROVOST_ADVISOR
	rank = "Provost Advisor"
	paygrade = "ME6"
	role_comm_title = "PvA"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/provost/advisor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/advisor(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost/advisor(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/provost/senior(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H), WEAR_IN_JACKET)

/datum/equipment_preset/uscm_event/provost/inspector
	name = "Provost Inspector (PvI)"
	skills = /datum/skills/CMP

	assignment = JOB_PROVOST_INSPECTOR
	rank = "Provost Inspector"
	paygrade = "PvI"
	role_comm_title = "PvI"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/provost/inspector/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/inspector(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost/inspector(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/provost/senior(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H), WEAR_IN_JACKET)


/datum/equipment_preset/uscm_event/provost/marshal
	name = "Provost Marshal (MO6)"
	minimum_age = 45
	skills = /datum/skills/general

	assignment = JOB_PROVOST_MARSHAL
	rank = "Provost Marshal"
	paygrade = "MO6"
	role_comm_title = "PvM"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/provost/marshal/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/marshal(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/impact(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost/marshal(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/mp/provost/marshal(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost/marshal(H.back), WEAR_IN_BACK)


/datum/equipment_preset/uscm_event/provost/marshal/sector
	name = "Provost Sector Marshal (MO7)"
	minimum_age = 50
	skills = /datum/skills/general

	assignment = JOB_PROVOST_SMARSHAL
	rank = "Provost Sector Marshal"
	paygrade = "MO7"
	role_comm_title = "PvSM"

/datum/equipment_preset/uscm_event/provost/marshal/sector/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/marshal(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/impact(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost/marshal(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/mp/provost/marshal(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost/marshal(H.back), WEAR_IN_BACK)


/datum/equipment_preset/uscm_event/provost/marshal/chief
	name = "Provost Chief Marshal (PvCM)"
	minimum_age = 60
	skills = /datum/skills/general

	assignment = JOB_PROVOST_CMARSHAL
	rank = "Provost Chief Marshal"
	paygrade = "PvCM"
	role_comm_title = "PvCM"

/datum/equipment_preset/uscm_event/provost/marshal/chief/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp/provost/marshal/chief(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/impact(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost/marshal/chief(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/mp/provost/marshal(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/provost/marshal/chief(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_event/uaac/tis
	name = "UAAC-TIS"

	idtype = /obj/item/card/id/provost
	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
		ACCESS_WY_CORPORATE,
	)
	skills = /datum/skills/provost

/datum/equipment_preset/uscm_event/uaac/tis/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/uscm_event/uaac/tis/io
	name = "UAAC-TIS Intelligence Officer (NO2)"
	minimum_age = 25
	skills = /datum/skills/intel

	assignment = JOB_TIS_IO
	rank = "UAAC-TIS Intelligence Officer"
	paygrade = "NO2"
	role_comm_title = "TIS-IO"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/uaac/tis/io/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/uaac/tis/io(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)

/datum/equipment_preset/uscm_event/uaac/tis/sa
	name = "UAAC-TIS Special Agent (NO5)"
	minimum_age = 30
	skills = /datum/skills/general

	assignment = JOB_TIS_SA
	rank = "UAAC-TIS Special Agent"
	paygrade = "NO5"
	role_comm_title = "TIS-SA"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm_event/uaac/tis/sa/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/uaac/tis(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/impact(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/uaac/tis/sa(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/tis(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_R_STORE)

/*****************************************************************************************************/

