
/datum/equipment_preset/fun
	name = "Fun"
	flags = EQUIPMENT_PRESET_STUB
	assignment = "Fun"

	skills = /datum/skills/civilian
	idtype = /obj/item/card/id

//*****************************************************************************************************/

/datum/equipment_preset/fun/pirate
	name = "Fun - Pirate"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_PIRATE

	skills = /datum/skills/pfc/crafty

/datum/equipment_preset/fun/pirate/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/pirate(H), WEAR_L_HAND)

	H.equip_to_slot(new /obj/item/attachable/bayonet(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/pirate/captain
	name = "Fun - Pirate Captain"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/SL
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/fun/pirate/captain/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/pirate(H), WEAR_L_HAND)

	H.equip_to_slot(new /obj/item/attachable/bayonet(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/clown
	name = "Fun - Clown"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/fun/clown/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), WEAR_FACE)

	H.equip_to_slot(new /obj/item/toy/bikehorn(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

//*****************************************************************************************************/
/datum/equipment_preset/fun/dutch
	name = JOB_DUTCH_RIFLEMAN
	paygrade = "DTC"
	assignment = JOB_DUTCH_RIFLEMAN
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_DUTCH

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/fun/dutch/New()
	..()
	rank = assignment

/datum/equipment_preset/fun/dutch/load_name(mob/living/carbon/human/H, randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_dutch)] [pick(last_names)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_dutch)] [pick(last_names)]"

	H.change_real_name(H, random_name)
	H.age = rand(25,35)
	H.r_hair = rand(10,30)
	H.g_hair = rand(10,30)
	H.b_hair = rand(20,50)
	H.r_eyes = rand(129,149)
	H.g_eyes = rand(52,72)
	H.b_eyes = rand(9,29)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/fun/dutch/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask in your leader's backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures, and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs. You have a very wide variety of skills, put them to use!"))

/datum/equipment_preset/fun/dutch/minigun
	name = JOB_DUTCH_MINIGUNNER
	paygrade = "DTCMG"
	assignment = JOB_DUTCH_MINIGUNNER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/fun/dutch/minigun/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask in your leader's backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/fun/dutch/flamer
	name = JOB_DUTCH_FLAMETHROWER
	paygrade = "DTCF"
	assignment = JOB_DUTCH_FLAMETHROWER
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmerc

/datum/equipment_preset/fun/dutch/flamer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	//jumpsuit
	var/obj/item/clothing/under/marine/veteran/dutch/DUTCH = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	DUTCH.attach_accessory(H, W)
	H.equip_to_slot_or_del(DUTCH, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	//---
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/m60, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/fuelpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/M240T(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/X(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/large/B(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask in your leader's backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/fun/dutch/medic
	name = JOB_DUTCH_MEDIC
	paygrade = "DTCM"
	assignment = JOB_DUTCH_MEDIC
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutchmedic

/datum/equipment_preset/fun/dutch/medic/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact_adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m16/ap(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	to_chat(H, SPAN_WARNING("You are a medic of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask in your leader's backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to help your team members hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/fun/dutch/arnie
	name = "Dutch's Dozen - Arnold"
	paygrade = "ARN"
	assignment = JOB_DUTCH_ARNOLD
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutch
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fun/dutch/arnie/load_name(mob/living/carbon/human/H, randomise)
	H.gender = MALE
	H.change_real_name(H, "Arnold 'Dutch' Schäfer")
	H.f_style = "5 O'clock Shadow"
	H.h_style = "Mulder"

	H.age = 38
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fun/dutch/arnie/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch/cap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/empproof(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja/hunter(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/arnold/full(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/dutch/m16/ap(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/emp_dutch(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/dutch(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)

	H.set_species("Human Hero") //Arnold is STRONG.

	to_chat(H, SPAN_WARNING("You are Dutch, the leader of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask on your face serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your pouch have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/fun/hefa
	name = "HEFA Knight"

	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE
	faction = FACTION_HEFA
	faction_group = list(FACTION_HEFA, FACTION_MARINE)

	// Cooperate!
	idtype = /obj/item/card/id/gold
	assignment = "Shrapnelsworn"
	rank = "Brother of the Order"
	paygrade = "Ser"
	role_comm_title = "OHEFA"

	skills = /datum/skills/specialist

/datum/equipment_preset/fun/hefa/load_skills(mob/living/carbon/human/H)
	..()
	H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)

/datum/equipment_preset/fun/hefa/load_name(mob/living/carbon/human/H, randomise)
	H.gender = MALE
	var/list/names = list(
		"Lancelot", "Gawain", "Geraint", "Percival", "Bors", "Lamorak", "Kay", "Gareth", "Bedivere", "Gaheris", "Galahad", "Tristan", "Palamedes",
		"Aban", "Abrioris", "Aglovale", "Agravain", "Aqiff", "Bagdemagus", "Baudwin", "Brastius", "Bredbeddle", "Breunor", "Caradoc", "Calogrenant",
		"Degore", "Daniel", "Dinadan", "Dornar", "Ector", "Elyan", "Galeshin", "Gingalain", "Griflet", "Lionel", "Lucan", "Mador", "Maleagant",
		"Mordred", "Morien", "Pelleas", "Pinel", "Sagramore", "Safir", "Segwarides", "Tor", "Ulfius", "Yvain", "Ywain"
	)

	var/new_name = pick(names) + " of the HEFA Order"
	H.change_real_name(H, new_name)
	H.f_style = "5 O'clock Shadow"

/datum/equipment_preset/fun/hefa/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/M = new(H)
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)

	H.equip_to_slot_or_del(M, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist/hefa(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	var/jacket_success = H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3G/hefa(H), WEAR_JACKET)
	var/satchel_success = H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	var/waist_success = H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large(H), WEAR_WAIST)
	var/pouch_r_success = H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(H), WEAR_R_STORE)
	var/gun_success = H.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/grenade/m92(H), WEAR_J_STORE)

	// Now pump /everything/ full of HEFAs

	// M92 launcher
	if(gun_success)
		var/obj/item/weapon/gun/launcher/grenade/m92/launcher = H.s_store
		launcher.name = "HEFA grenade launcher"
		launcher.internal_slots = 10 // big buff

		// give it a magharness
		var/obj/item/attachable/magnetic_harness/magharn = new(launcher)
		magharn.Attach(launcher)
		launcher.update_attachable(magharn.slot)

		// the M92 New() proc sleeps off into the background 1 second after it's called, so the nades aren't actually in at this point in execution
		spawn(5)
			// hefa only no stinky nades
			for(var/obj/item/explosive/grenade/G in launcher.cylinder)
				qdel(G)
			launcher.cylinder.storage_slots = launcher.internal_slots //need to adjust the internal storage as well.
			for(var/i = 1 to launcher.internal_slots)
				new /obj/item/explosive/grenade/high_explosive/frag(launcher.cylinder)
			launcher.fire_delay = FIRE_DELAY_TIER_4 //More HEFA per second, per second. Strictly speaking this is probably a nerf.

	// Satchel
	if(satchel_success)
		for(var/i in 1 to 7)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.back), WEAR_IN_BACK)

	// Belt
	if(waist_success)
		var/obj/item/storage/belt/grenade/large/belt = H.belt
		belt.name = "M42 HEFA rig Mk. XVII"
		for(var/i in 1 to belt.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.belt), WEAR_IN_BELT)

	// Armor/suit
	if(jacket_success)
		var/obj/item/clothing/suit/storage/marine/M3G/armor = H.wear_suit
		armor.name = "HEFA Knight armor"
		for(var/i in 1 to armor.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.wear_suit), WEAR_IN_JACKET)

	// Pouch
	if(pouch_r_success)
		var/obj/item/storage/pouch/explosive/pouch = H.r_store
		pouch.name = "HEFA pouch"
		for(var/i in 1 to pouch.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.r_store), WEAR_IN_R_STORE)

	// Webbing
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.back), WEAR_IN_ACCESSORY)

/datum/equipment_preset/fun/hefa/melee
	name = "HEFA Knight - Melee"

/datum/equipment_preset/fun/hefa/melee/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/M = new(H)
	M.name = "HEFA Knight uniform"
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)

	H.equip_to_slot_or_del(M, WEAR_BODY)
	var/shoes_success = H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist/hefa(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	var/jacket_success = H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3G/hefa(H), WEAR_JACKET)
	var/satchel_success = H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	var/waist_success = H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large(H), WEAR_WAIST)
	var/pouch_r_success = H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/hefa(H), WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/hefa(H), WEAR_IN_BACK)

	if(shoes_success)
		var/obj/item/clothing/shoes/marine/knife/shoes = H.shoes
		shoes.name = "HEFA Knight combat boots"

	// Now pump /everything/ full of HEFAs

	// Satchel
	if(satchel_success)
		var/obj/item/storage/backpack/marine/satchel = H.back
		satchel.name = "HEFA storage bag"
		for(var/i in 1 to 7)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.back), WEAR_IN_BACK)

	// Belt
	if(waist_success)
		var/obj/item/storage/belt/grenade/large/belt = H.belt
		belt.name = "M42 HEFA rig Mk. XVII"
		for(var/i in 1 to belt.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.belt), WEAR_IN_BELT)

	// Armor/suit
	if(jacket_success)
		var/obj/item/clothing/suit/storage/marine/M3G/armor = H.wear_suit
		armor.name = "HEFA Knight armor"
		for(var/i in 1 to armor.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.wear_suit), WEAR_IN_JACKET)

	// Pouches
	if(pouch_r_success)
		var/obj/item/storage/pouch/explosive/pouch = H.r_store
		pouch.name = "HEFA pouch"
		for(var/i in 1 to pouch.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.r_store), WEAR_IN_R_STORE)

	// Webbing
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H.back), WEAR_IN_ACCESSORY)

/datum/equipment_preset/fun/santa
	name = "Fun - Santa"
	paygrade = "C"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	assignment = "Santa"

	skills = null
	idtype = /obj/item/card/id/general

/datum/equipment_preset/fun/santa/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/fun/santa/load_name(mob/living/carbon/human/H, randomise)
	H.gender = MALE
	H.change_real_name(H, "Santa")

	H.age = 270 //he is old
	H.r_hair = 0
	H.g_hair = 0
	H.b_hair = 0

/datum/equipment_preset/fun/santa/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/santabag(H), WEAR_BACK)
	//pack filled with gifts
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pj/red(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/santa(H), WEAR_JACKET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), WEAR_L_STORE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/santahat(H), WEAR_HEAD)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/santa(H), WEAR_WAIST)

	H.set_species("Human Hero") //Santa is STRONG.
	ADD_TRAIT(H, TRAIT_SANTA, TRAIT_SOURCE_ADMIN)

/datum/equipment_preset/upp/ivan
	name = "Fun - Ivan"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	assignment = "UPP Armsmaster"
	rank = "UPP Armsmaster"
	role_comm_title = null

/datum/equipment_preset/upp/ivan/load_name(mob/living/carbon/human/H, randomise)
	H.gender = MALE
	H.change_real_name(H, "Ivan")
	H.f_style = "Shaved"
	H.h_style = "Shaved Head"
	H.ethnicity = "Scandinavian"
	H.r_hair = 165
	H.g_hair = 42
	H.b_hair = 42

/datum/equipment_preset/upp/ivan/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/ivan, WEAR_BACK)
	//back filled with random guns, it's awesome
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//body + webbing
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/jacket/ivan, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/m60, WEAR_J_STORE)
	//webbing
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full, WEAR_R_STORE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ivanberet, WEAR_HEAD)
	//limb
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/ivan, WEAR_WAIST)
	//belt filled with random magazines, it's cool

	H.set_species("Human Hero") //Ivan is STRONG.


/datum/equipment_preset/fun/van_bandolier
	name = "Fun - Big Game Hunter"
	paygrade = "CCMO"
	uses_special_name = TRUE
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	assignment = "Huntsman"
	rank = "Huntsman"
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fun/van_bandolier/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/fun/van_bandolier/load_name(mob/living/carbon/human/H, randomise)
	H.gender = MALE
	H.change_real_name(H, "Van Bandolier")
	H.age = 55
	H.r_hair = 153 //Light brown hair.
	H.g_hair = 102
	H.b_hair = 51
	H.r_facial = 153
	H.g_facial = 102
	H.b_facial = 51
	H.h_style = "Mullet"
	H.f_style = "Full English"
	H.ethnicity = "Anglo"
	H.r_eyes = 102 //Brown eyes.
	H.g_eyes = 51
	H.b_eyes = 0

/datum/equipment_preset/fun/van_bandolier/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/double/twobore(H), WEAR_BACK)

	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)

	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/van_bandolier(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/van_bandolier(H), WEAR_JACKET)

	//suit storage
	H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/van_bandolier(H), WEAR_J_STORE)

	//suit pockets
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/civ(H.wear_suit), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint(H.wear_suit), WEAR_IN_JACKET)

	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), WEAR_R_STORE)

	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/van_bandolier(H), WEAR_HEAD)

	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated/van_bandolier(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/van_bandolier(H), WEAR_FEET)

	//hands
	H.equip_to_slot_or_del(new /obj/item/storage/box/twobore(H), WEAR_L_HAND)

	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/webley/full(H), WEAR_WAIST)

	H.set_species("Human Hero") //Van Bandolier is not easily subdued.
	//But he isn't completely unstoppable, either. Reenables slow, knockout, daze, stun and permanent (organ dam, IB etc.) damage.
	//Stuns and knockdowns are shorter but he's not completely immune.
	H.status_flags &= ~NO_PERMANENT_DAMAGE
	H.status_flags |= STATUS_FLAGS_DEBILITATE
	ADD_TRAIT(H, TRAIT_TWOBORE_TRAINING, TRAIT_SOURCE_ADMIN) //Means he can handle his gun and speak its hit lines.


/datum/equipment_preset/fun/monkey
	name = "Fun - Monkey"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MONKEY

	uses_special_name = TRUE

	skills = /datum/skills/pfc/crafty // about equivalent to a marine

	assignment = "Monkey"
	rank = "Monkey"
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/fun/monkey/load_race(mob/living/carbon/human/H, client/mob_client)
	H.set_species(SPECIES_MONKEY)

/datum/equipment_preset/fun/monkey/load_name(mob/living/carbon/human/H, randomise, client/mob_client)
	H.gender = pick(60;MALE,40;FEMALE)
	var/random_name = get_random_name(H)
	H.change_real_name(H, random_name)
	H.age = rand(1, 40)

/datum/equipment_preset/fun/monkey/proc/get_random_name(mob/living/carbon/human/H)
	return pick(monkey_names)

/datum/equipment_preset/fun/monkey/marine
	name = "Fun - Monkey Marine"

	assignment = "Monkey Marine"
	rank = "Monkey Marine"
	paygrade = "ME2"

/datum/equipment_preset/fun/monkey/marine/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/monkey(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(H), WEAR_IN_JACKET)

/datum/equipment_preset/fun/monkey/soldier
	name = "Fun - Monkey Soldier"

	assignment = "Monkey Soldier"
	rank = "Monkey Soldier"
	paygrade = "UE1"

/datum/equipment_preset/fun/monkey/soldier/get_random_name(mob/living/carbon/human/H)
	return H.gender == MALE ? pick(first_names_male_upp) : pick(first_names_female_upp)

/datum/equipment_preset/fun/monkey/soldier/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/monkey(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/rifleman(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp(H), WEAR_IN_JACKET)
