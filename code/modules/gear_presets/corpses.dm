
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

/datum/equipment_preset/corpse/load_languages(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/corpse/load_status(mob/living/carbon/human/new_human)
	. = ..(new_human)
	new_human.death(create_cause_data("existing"), TRUE) //Kills the new mob
	new_human.apply_damage(100, BRUTE)
	new_human.apply_damage(100, BRUTE)
	new_human.apply_damage(100, BRUTE)
	if(xenovictim)
		var/datum/internal_organ/O
		var/i
		for(i in list("heart","lungs"))
			O = new_human.internal_organs_by_name[i]
			new_human.internal_organs_by_name -= i
			new_human.internal_organs -= O
		new_human.chestburst = 2
		new_human.update_burst()
		//buckle to nest
		var/obj/structure/bed/nest/N = locate() in get_turf(src)
		if(N)
			new_human.buckled = N
			new_human.setDir(N.dir)
			new_human.update_canmove()
			N.buckled_mob = new_human
			N.afterbuckle(new_human)
	new_human.undefibbable = TRUE
	new_human.spawned_corpse = TRUE
	new_human.updatehealth()
	new_human.pulse = PULSE_NONE

/datum/equipment_preset/corpse/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	add_random_survivor_equipment(new_human)
	add_survivor_weapon_civilian(new_human)
	add_survivor_weapon_pistol(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)

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

/datum/equipment_preset/corpse/realpirate/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(new_human), WEAR_HEAD)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/realpirate/ranged
	name = "Corpse - Pirate Gunner"

/datum/equipment_preset/corpse/realpirate/ranged/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(new_human), WEAR_HEAD)
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

/datum/equipment_preset/corpse/russian/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/veteran/soviet_uniform_01(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/soviet(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	if(prob(25))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bearpelt(new_human), WEAR_HEAD)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(new_human), WEAR_HEAD)

//*****************************************************************************************************/
// Civilians

/datum/equipment_preset/corpse/prisoner
	name = "Corpse - Prisoner"
	assignment = "Prisoner"

/datum/equipment_preset/corpse/prisoner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/chef
	name = "Corpse - Chef"
	assignment = "Chef"
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/corpse/chef/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/doctor
	name = "Corpse - Doctor"
	assignment = "Medical Doctor"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/doctor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(new_human), WEAR_JACKET)
	add_random_survivor_medical_gear(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/engineer
	name = "Corpse - Engineer"
	assignment = "Station Engineer"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/corpse/engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)


	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/clown
	name = "Corpse - Clown"
	assignment = "Clown"
	uses_special_name = TRUE

/datum/equipment_preset/corpse/clown/New()
	. = ..()
	//As a joke, clown has all access so they can clown everywhere...
	access = get_all_accesses()

/datum/equipment_preset/corpse/clown/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..() //To load gender, randomise appearance, etc.
	new_human.change_real_name(new_human, pick(clown_names)) //Picking a proper clown name!

/datum/equipment_preset/corpse/clown/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/toy/bikehorn(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(new_human), WEAR_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/scientist
	name = "Corpse - Scientist"
	assignment = "Scientist"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/scientist/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/green(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(new_human), WEAR_IN_JACKET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/miner
	name = "Corpse - Shaft Miner"
	assignment = "Shaft Miner"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/corpse/miner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/security
	name = "Corpse - Security"
	assignment = "Deputy"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/corpse/security/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)


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

/datum/equipment_preset/corpse/security/marshal/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/heavy(new_human), WEAR_WAIST)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

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

/datum/equipment_preset/corpse/security/liaison/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	add_random_cl_survivor_loot(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(new_human), WEAR_FEET)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
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

/datum/equipment_preset/corpse/prison_security/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)

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

/datum/equipment_preset/corpse/bridgeofficer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)

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

/datum/equipment_preset/corpse/bridgeofficer/johnson/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/waiter(new_human), WEAR_BODY)
	. = ..()

/datum/equipment_preset/corpse/bridgeofficer/johnson/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.change_real_name(new_human, "Johnson Telovin")

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

/datum/equipment_preset/corpse/commander/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/cohiba(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/centhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(new_human), WEAR_R_STORE)
	add_random_cl_survivor_loot(new_human)

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

/datum/equipment_preset/corpse/wysec/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/formal/servicedress(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)


/////Actually specific colonists

/datum/equipment_preset/corpse/colonist
	name = "Corpse - Colonist"
	assignment = JOB_COLONIST
	xenovictim = FALSE
	rank = JOB_COLONIST
	faction = FACTION_COLONIST
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id/lanyard

/datum/equipment_preset/colonist/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)

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

/datum/equipment_preset/corpse/colonist/random/load_gear(mob/living/carbon/human/new_human)
	var/random_surv_type = pick(SSmapping.configs[GROUND_MAP].survivor_types)
	var/datum/equipment_preset/survivor/surv_equipment = new random_surv_type
	surv_equipment.load_gear(new_human)

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

/datum/equipment_preset/corpse/colonist/kutjevo/load_gear(mob/living/carbon/human/new_human)

	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	add_random_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)

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

/datum/equipment_preset/corpse/ua_riot/load_gear(mob/living/carbon/human/new_human)
	var/random = rand(1,5)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/classic_baton(new_human), WEAR_WAIST)

	switch(random)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/security, WEAR_EYES)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human), WEAR_IN_BACK)


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
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY,
	)

/datum/equipment_preset/corpse/wy/manager/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/manager(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	add_random_cl_survivor_loot(new_human)


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

/datum/equipment_preset/corpse/clf/load_gear(mob/living/carbon/human/new_human)

	spawn_rebel_uniform(new_human)
	spawn_rebel_suit(new_human)
	spawn_rebel_helmet(new_human)
	spawn_rebel_shoes(new_human)
	spawn_rebel_gloves(new_human)
	spawn_rebel_belt(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	add_random_survivor_equipment(new_human)
	add_pmc_survivor_weapon(new_human)
	add_survivor_weapon_pistol(new_human)

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

/datum/equipment_preset/corpse/upp/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	add_random_survivor_equipment(new_human)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

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

/datum/equipment_preset/corpse/pmc/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/hvh, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	add_random_survivor_equipment(new_human)

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

/datum/equipment_preset/corpse/pmc/goon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

/datum/equipment_preset/corpse/pmc/goon/lead
	name = "Corpse - Weyland-Yutani Corporate Security Lead (Goon Lead)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrade = "WEY-GOON-L"

/datum/equipment_preset/corpse/pmc/goon/lead/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/lead, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

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

/datum/equipment_preset/corpse/freelancer/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	spawn_merc_helmet(new_human)

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

/datum/equipment_preset/corpse/dutchrifle/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	spawn_merc_helmet(new_human)

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

/datum/equipment_preset/corpse/pizza/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pizza, WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/margherita, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/vegetable, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/mushroom, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/meat, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/thirteenloko, WEAR_IN_BACK)

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

/datum/equipment_preset/corpse/gladiator/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(new_human)
	lantern.name = "Beacon of Holy Light"

/datum/equipment_preset/corpse/gladiator/burst
	name = "Corpse - Burst Gladiator"
	xenovictim = TRUE
