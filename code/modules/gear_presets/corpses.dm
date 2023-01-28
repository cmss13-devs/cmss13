
/datum/equipment_preset/corpse
	name = "Corpse"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_COLONIST
	rank = JOB_COLONIST
	faction = FACTION_COLONIST
	languages = list()
	access = list(ACCESS_CIVILIAN_PUBLIC)
	skills = /datum/skills/civilian
	idtype = /obj/item/card/id/lanyard
	var/xenovictim = FALSE //Set to true to make the corpse spawn as a victim of a xeno burst

/datum/equipment_preset/corpse/load_languages(mob/living/carbon/human/H)
	return

/datum/equipment_preset/corpse/load_status(mob/living/carbon/human/H)
	. = ..(H)
	H.death(create_cause_data("existing"), TRUE) //Kills the new mob
	H.apply_damage(100, BRUTE)
	H.apply_damage(100, BRUTE)
	H.apply_damage(100, BRUTE)
	if(xenovictim)
		var/datum/internal_organ/O
		var/i
		for(i in list("heart","lungs"))
			O = H.internal_organs_by_name[i]
			H.internal_organs_by_name -= i
			H.internal_organs -= O
		H.chestburst = 2
		H.update_burst()
		//buckle to nest
		var/obj/structure/bed/nest/N = locate() in get_turf(src)
		if(N)
			H.buckled = N
			H.setDir(N.dir)
			H.update_canmove()
			N.buckled_mob = H
			N.afterbuckle(H)
	H.undefibbable = TRUE
	H.spawned_corpse = TRUE
	H.updatehealth()
	H.pulse = PULSE_NONE

/datum/equipment_preset/corpse/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	add_random_survivor_equipment(H)
	add_survivor_weapon(H)
	add_survivor_weapon_pistol(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/realpirate
	name = "Corpse - Pirate"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_ILLEGAL_PIRATE,
	)

/datum/equipment_preset/corpse/realpirate/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), WEAR_HEAD)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/realpirate/ranged
	name = "Corpse - Pirate Gunner"

/datum/equipment_preset/corpse/realpirate/ranged/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(H), WEAR_HEAD)
	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/corpse/russian
	name = "Corpse - Russian"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/russian

/datum/equipment_preset/corpse/russian/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/veteran/soviet_uniform_01(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/soviet(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	if(prob(25))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/bearpelt(H), WEAR_HEAD)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)

//*****************************************************************************************************/
// Civilians

/datum/equipment_preset/corpse/prisoner
	name = "Corpse - Prisoner"
	assignment = "Prisoner"

/datum/equipment_preset/corpse/prisoner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/chef
	name = "Corpse - Chef"
	assignment = "Chef"
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/corpse/chef/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/doctor
	name = "Corpse - Doctor"
	assignment = "Medical Doctor"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/doctor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), WEAR_JACKET)
	add_random_survivor_medical_gear(H)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/engineer
	name = "Corpse - Engineer"
	assignment = "Station Engineer"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/corpse/engineer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)


	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H.back), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/clown
	name = "Corpse - Clown"
	assignment = "Clown"
	uses_special_name = TRUE

/datum/equipment_preset/corpse/clown/New()
	. = ..()
	//As a joke, clown has all access so they can clown everywhere...
	access = get_all_accesses()

/datum/equipment_preset/corpse/clown/load_name(mob/living/carbon/human/H, randomise)
	. = ..() //To load gender, randomise appearance, etc.
	H.change_real_name(H, pick(clown_names)) //Picking a proper clown name!

/datum/equipment_preset/corpse/clown/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/toy/bikehorn(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(H), WEAR_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/scientist
	name = "Corpse - Scientist"
	assignment = "Scientist"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/scientist/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/green(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(H), WEAR_IN_JACKET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/miner
	name = "Corpse - Shaft Miner"
	assignment = "Shaft Miner"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/corpse/miner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/security
	name = "Corpse - Security"
	assignment = "Deputy"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/corpse/security/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)


//*****************************************************************************************************/

/datum/equipment_preset/corpse/security/marshal
	name = "Corpse - Colonial Marshal"
	assignment = "Colonial Marshal"
	xenovictim = TRUE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/security/marshal/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/heavy(H), WEAR_WAIST)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)

	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/corpse/security/liaison
	name = "Corpse - Corporate Liaison"
	assignment = "Corporate Liaison"
	xenovictim = TRUE
	paygrade = "WYC2"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/security/liaison/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	add_random_cl_survivor_loot(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/corpse/prison_security
	name = "Corpse - Prison Guard"
	assignment = "Prison Guard"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/prison_security/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

//*****************************************************************************************************/
								/////////////////Officers//////////////////////

/datum/equipment_preset/corpse/bridgeofficer
	name = "Corpse - Staff Officer"
	idtype = /obj/item/card/id/general
	assignment = "Staff Officer"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/bridgeofficer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

//*****************************************************************************************************/
/datum/equipment_preset/corpse/bridgeofficer/johnson
	name = "Corpse - Mr. Johnson Telovin"
	idtype = /obj/item/card/id/general
	assignment = "Bridge Officer"
	uses_special_name = TRUE
	paygrade = "WYC2"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_PMC_GREEN,
		ACCESS_WY_PMC_ORANGE,
		ACCESS_WY_PMC_RED,
		ACCESS_WY_PMC_BLACK,
		ACCESS_WY_PMC_WHITE,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/bridgeofficer/johnson/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/waiter(H), WEAR_BODY)
	. = ..()

/datum/equipment_preset/corpse/bridgeofficer/johnson/load_name(mob/living/carbon/human/H, randomise)
	H.change_real_name(H, "Johnson Telovin")

//*****************************************************************************************************/

/datum/equipment_preset/corpse/commander
	name = "Corpse - Commanding Officer"
	idtype = /obj/item/card/id/general
	assignment = "Commanding Officer"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/commander/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/cohiba(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/centhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_R_STORE)
	add_random_cl_survivor_loot(H)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/wysec
	name = "Corpse - Weyland-Yutani Corporate Security Guard"
	idtype = /obj/item/card/id/pmc
	assignment = "Weyland-Yutani Corporate Security Guard"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_PMC_GREEN,
		ACCESS_WY_PMC_ORANGE,
		ACCESS_WY_PMC_RED,
		ACCESS_WY_PMC_BLACK,
		ACCESS_WY_PMC_WHITE,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/wysec/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/formal/servicedress(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)


/////Actually specific colonists

/datum/equipment_preset/corpse/colonist
	name = "Corpse - Colonist"
	assignment = JOB_COLONIST
	xenovictim = FALSE
	rank = JOB_COLONIST
	faction = FACTION_COLONIST
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id/lanyard

/datum/equipment_preset/colonist/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)

/datum/equipment_preset/corpse/colonist/burst
	name = "Corpse - Burst Colonist"
	xenovictim = TRUE

/datum/equipment_preset/corpse/colonist/random
	name = "Corpse - Colonist Random"
	assignment = JOB_COLONIST
	xenovictim = FALSE
	rank = JOB_COLONIST
	faction = FACTION_COLONIST
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id/lanyard

/datum/equipment_preset/corpse/colonist/random/load_gear(mob/living/carbon/human/H)
	var/random_surv_type = pick(SSmapping.configs[GROUND_MAP].survivor_types)
	var/datum/equipment_preset/survivor/surv_equipment = new random_surv_type
	surv_equipment.load_gear(H)

/datum/equipment_preset/corpse/colonist/random/burst
	name = "Corpse - Burst Colonist Random"
	xenovictim = TRUE

/datum/equipment_preset/corpse/colonist/kutjevo
	name = "Corpse - Colonist Kutjevo"
	assignment = JOB_COLONIST
	xenovictim = FALSE
	rank = JOB_COLONIST
	faction = FACTION_COLONIST
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id/lanyard

/datum/equipment_preset/corpse/colonist/kutjevo/load_gear(mob/living/carbon/human/H)

	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	add_random_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)

/datum/equipment_preset/corpse/colonist/kutjevo/burst
	name = "Corpse - Burst Colonist Kutjevo"
	xenovictim = TRUE

//UA riot control dudes
/datum/equipment_preset/corpse/ua_riot
	name = "Corpse - UA Officer"
	assignment = "United Americas Riot Officer"
	idtype = /obj/item/card/id/silver
	xenovictim = FALSE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/ua_riot/load_gear(mob/living/carbon/human/H)
	var/random = rand(1,5)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton(H), WEAR_WAIST)

	switch(random)
		if(1)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/security, WEAR_EYES)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(H), WEAR_EYES)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
		if(5)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(H), WEAR_IN_BACK)


/datum/equipment_preset/corpse/ua_riot/burst
	name = "Corpse - Burst UA Officer"
	xenovictim = TRUE

//Colonial Supervisor Corpse

/datum/equipment_preset/corpse/wy/manager
	name = "Corpse - Corporate Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WYC7"
	assignment = "Colony Supervisor"
	role_comm_title = "Supervisor"
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	faction_group = FACTION_LIST_WY
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	access = list(
		ACCESS_WY_CORPORATE,
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY,
	)

/datum/equipment_preset/corpse/wy/manager/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/manager(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	add_random_cl_survivor_loot(H)


/datum/equipment_preset/corpse/wy/manager/burst
	name = "Corpse - Burst Corporate Supervisor"
	xenovictim = TRUE

//Faction Specific Corpses

/datum/equipment_preset/corpse/clf
	name = "Corpse - Colonial Liberation Front Soldier"
	assignment = "Colonial Liberation Front Soldier"
	idtype = /obj/item/card/id/silver
	xenovictim = FALSE
	faction = FACTION_UPP
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/clf/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	add_random_survivor_equipment(H)
	add_survivor_weapon(H)
	add_survivor_weapon_pistol(H)

/datum/equipment_preset/corpse/clf/burst
	name = "Corpse - Burst Colonial Liberation Front Soldier"
	xenovictim = TRUE

// UPP
/datum/equipment_preset/corpse/upp
	name = "Corpse - Union of Progressive Peoples Soldier"
	assignment = "Union of Progressive Peoples Soldier"
	idtype = /obj/item/card/id/silver
	xenovictim = FALSE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/upp/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	add_random_survivor_equipment(H)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/corpse/upp/burst
	name = "Corpse - Burst Union of Progressive Peoples Soldier"
	xenovictim = TRUE

// PMC

/datum/equipment_preset/corpse/pmc
	name = "Corpse - Weyland-Yutani PMC (Standard)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = "Weyland-Yutani PMC (Standard)"
	faction = FACTION_PMC
	faction_group = FACTION_LIST_WY
	rank = JOB_PMC
	paygrade = "PMC-OP"
	idtype = /obj/item/card/id/pmc
	skills = /datum/skills/civilian/survivor/pmc
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_WY_CORPORATE,
		ACCESS_CIVILIAN_LOGISTICS,
	)

/datum/equipment_preset/corpse/pmc/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/hvh, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	add_random_survivor_equipment(H)

/datum/equipment_preset/corpse/pmc/burst
	name = "Corpse - Burst Weyland-Yutani PMC (Standard)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/pmc/goon
	name = "Corpse - Weyland-Yutani Corporate (Goon)"
	languages = list(LANGUAGE_ENGLISH)
	assignment = JOB_WY_GOON
	rank = JOB_WY_GOON
	paygrade = "WEY-GOON"
	skills = /datum/skills/MP

/datum/equipment_preset/corpse/pmc/goon/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88_near_empty, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

/datum/equipment_preset/corpse/pmc/goon/lead
	name = "Corpse - Weyland-Yutani Corporate Security Lead (Goon Lead)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrade = "WEY-GOON-L"

/datum/equipment_preset/corpse/pmc/goon/lead/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/lead, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88_near_empty, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

// Freelancer

/datum/equipment_preset/corpse/freelancer
	name = "Corpse - Freelancer Mercenary"
	assignment = "Freelancer Mercenary"
	idtype = /obj/item/card/id/silver
	xenovictim = FALSE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/freelancer/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	spawn_merc_helmet(H)

/datum/equipment_preset/corpse/freelancer/burst
	name = "Corpse - Burst Freelancer Mercenary"
	xenovictim = TRUE

// Fun Faction Corpse

// Dutch Dozen

/datum/equipment_preset/corpse/dutchrifle
	name = "Corpse - Dutch Dozen Rifleman"
	assignment = "Dutch Dozen Rifleman"
	idtype = /obj/item/card/id/silver
	faction = FACTION_DUTCH
	xenovictim = FALSE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/dutchrifle/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(H), WEAR_FEET)
	spawn_merc_helmet(H)

/datum/equipment_preset/corpse/dutchrifle/burst
	name = "Corpse - Burst Dutch Dozen Rifleman"
	xenovictim = TRUE

// Pizza Planet

/datum/equipment_preset/corpse/pizza
	name = "Corpse - Pizza Deliverer"
	assignment = "Pizza Deliverer"
	idtype = /obj/item/card/id/silver
	faction = FACTION_PIZZA
	xenovictim = FALSE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/pizza/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/pizza, WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/red, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/margherita, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/vegetable, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/mushroom, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/meat, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/thirteenloko, WEAR_IN_BACK)

/datum/equipment_preset/corpse/pizza/burst
	name = "Corpse - Burst Pizza Deliverer"
	xenovictim = TRUE

// Gladiator

/datum/equipment_preset/corpse/gladiator
	name = "Corpse - Gladiator"
	assignment = "Gladiator"
	idtype = /obj/item/card/id/dogtag
	faction = FACTION_GLADIATOR
	xenovictim = FALSE
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_MARINE_MAINT,
		ACCESS_WY_CORPORATE,
	)

/datum/equipment_preset/corpse/gladiator/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

/datum/equipment_preset/corpse/gladiator/burst
	name = "Corpse - Burst Gladiator"
	xenovictim = TRUE
