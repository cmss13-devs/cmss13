
/datum/equipment_preset/dust_raider
	name = "Dust Raider"

/datum/equipment_preset/dust_raider/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))

/datum/equipment_preset/dust_raider/load_name(mob/living/carbon/human/H)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance_for(H)
	H.real_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.name = H.real_name
	H.age = rand(21,45)

/*****************************************************************************************************/

/datum/equipment_preset/dust_raider/private
	name = "Dust Raider Private"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/dust_raider/private/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.registered_name = H.real_name
	W.assignment = "Squad Marine"
	W.rank = "Squad Marine"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Pfc"
		H.mind.assigned_role = "Squad Marine"

/datum/equipment_preset/dust_raider/private/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc/crafty)

/datum/equipment_preset/dust_raider/private/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	call(/datum/game_mode/whiskey_outpost/proc/generate_random_marine_primary)(H)
	call(/datum/game_mode/whiskey_outpost/proc/add_common_equipment)(H)

/*****************************************************************************************************/

/datum/equipment_preset/dust_raider/leader
	name = "Dust Raider Squad Leader"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/dust_raider/leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.registered_name = H.real_name
	W.assignment = "Squad Leader"
	W.rank = "Squad Leader"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "Squad Leader"
		H.mind.role_comm_title = "SL"

/datum/equipment_preset/dust_raider/leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL)

/datum/equipment_preset/dust_raider/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/map/whiskey_outpost_map(H), WEAR_IN_BACK)
	call(/datum/game_mode/whiskey_outpost/proc/add_common_equipment)(H)

/*****************************************************************************************************/

/datum/equipment_preset/dust_raider/smartgunner
	name = "Dust Raider Smartgunner"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/dust_raider/smartgunner/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.registered_name = H.real_name
	W.assignment = "Squad Smartgunner"
	W.rank = "Squad Smartgunner"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "Squad Smartgunner"
		H.mind.role_comm_title = "LCpl"

/datum/equipment_preset/dust_raider/smartgunner/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/smartgunner)

/datum/equipment_preset/dust_raider/smartgunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	call(/datum/game_mode/whiskey_outpost/proc/add_common_equipment)(H)
	//Backup SMG Weapon
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/dust_raider/engineer
	name = "Dust Raider Engineer"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/dust_raider/engineer/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.registered_name = H.real_name
	W.assignment = 	"Squad Engineer"
	W.rank = "Squad Engineer"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "Squad Engineer"
		H.mind.role_comm_title = "Eng"

/datum/equipment_preset/dust_raider/engineer/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/combat_engineer)

/datum/equipment_preset/dust_raider/engineer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/tactical/range(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	call(/datum/game_mode/whiskey_outpost/proc/generate_random_marine_primary)(H)
	call(/datum/game_mode/whiskey_outpost/proc/add_common_equipment)(H)

/*****************************************************************************************************/

/datum/equipment_preset/dust_raider/medic
	name = "Dust Raider Medic"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/dust_raider/medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.registered_name = H.real_name
	W.assignment = "Squad Medic"
	W.rank = "Squad Medic"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "Squad Medic"
		H.mind.role_comm_title = "Med"

/datum/equipment_preset/dust_raider/medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/combat_medic)

/datum/equipment_preset/dust_raider/medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/combatLifesaver(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(H), WEAR_L_STORE)
	call(/datum/game_mode/whiskey_outpost/proc/generate_random_marine_primary)(H)
	call(/datum/game_mode/whiskey_outpost/proc/add_common_equipment)(H)

/*****************************************************************************************************/

/datum/equipment_preset/dust_raider/specialist
	name = "Dust Raider Specialist"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/dust_raider/specialist/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.registered_name = H.real_name
	W.assignment = "Squad Specialist"
	W.rank = "Squad Specialist"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "Squad Specialist"
		H.mind.role_comm_title = "Spc"

/datum/equipment_preset/dust_raider/specialist/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/specialist)

/datum/equipment_preset/dust_raider/specialist/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/tie/storage/webbing(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
	call(/datum/game_mode/whiskey_outpost/proc/add_common_equipment)(H)
