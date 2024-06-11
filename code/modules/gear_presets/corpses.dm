
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

	// These two values matter because they are checked on death for weed_food
	new_human.undefibbable = TRUE
	if(xenovictim)
		new_human.chestburst = 2

	new_human.death(create_cause_data("existing"), TRUE) //Kills the new mob
	new_human.apply_damage(100, BRUTE)
	new_human.apply_damage(100, BRUTE)
	new_human.apply_damage(100, BRUTE)
	if(xenovictim)
		var/datum/internal_organ/organ
		var/i
		for(i in list("heart","lungs"))
			organ = new_human.internal_organs_by_name[i]
			new_human.internal_organs_by_name -= i
			new_human.internal_organs -= organ
		new_human.update_burst()
		//buckle to nest
		var/obj/structure/bed/nest/nest = locate() in get_turf(src)
		if(nest)
			new_human.buckled = nest
			new_human.setDir(nest.dir)
			nest.buckled_mob = new_human
			nest.afterbuckle(new_human)
	new_human.spawned_corpse = TRUE
	new_human.updatehealth()
	new_human.pulse = PULSE_NONE

/datum/equipment_preset/corpse/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	add_random_survivor_equipment(new_human)
	add_survivor_weapon_pistol(new_human)

//*****************************************************************************************************/


//*****************************************************************************************************/
// Civilians

/datum/equipment_preset/corpse/prisoner
	name = "Corpse - Prisoner"
	assignment = "Prisoner"

/datum/equipment_preset/corpse/prisoner/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/chef
	name = "Corpse - Chef"
	assignment = "Chef"
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/corpse/chef/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/doctor
	name = "Corpse - Doctor"
	assignment = "Doctor"
	idtype = /obj/item/card/id/silver/clearance_badge
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/doctor/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic/medical(new_human), WEAR_JACKET)
	add_random_survivor_medical_gear(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/engineer
	name = "Corpse - Engineer"
	assignment = "Engineer"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/corpse/engineer/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/scientist
	name = "Corpse - Scientist"
	assignment = "Scientist"
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/scientist/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/miner
	name = "Corpse - Shaft Miner"
	assignment = "Shaft Miner"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/corpse/miner/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/security
	name = "Corpse - Security"
	assignment = "Security Officer"
	xenovictim = TRUE
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/corpse/security/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
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

/datum/equipment_preset/corpse/security/cmb
	name = "Corpse - Colonial Marshal Deputy"
	rank = JOB_CMB
	paygrade = PAY_SHORT_CMBD
	idtype = /obj/item/card/id/deputy
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

/datum/equipment_preset/corpse/security/cmb/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/heavy(new_human), WEAR_WAIST)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/corpse/liaison
	name = "Corpse - Corporate Liaison"
	assignment = JOB_EXECUTIVE
	rank = JOB_EXECUTIVE
	faction_group = FACTION_LIST_WY
	paygrade = PAY_SHORT_WYC3
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	xenovictim = TRUE
	access = list(
		ACCESS_WY_COLONIAL,
		ACCESS_WY_EXEC,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/liaison/load_gear(mob/living/carbon/human/new_human)
	var/random = rand(1,4)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	add_random_cl_survivor_loot(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)

	switch(random)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/corporate_formal(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)

	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/corpse/prison_guard
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

/datum/equipment_preset/corpse/prison_guard/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)

//*****************************************************************************************************/
								/////////////////Officers//////////////////////

/datum/equipment_preset/corpse/manager
	name = "Corpse - Colony Division Manager"
	assignment = "Colonial Division Manager"
	rank = JOB_DIVISION_MANAGER
	faction_group = FACTION_LIST_WY
	paygrade = PAY_SHORT_WYC8
	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_ENGINEERING,
		ACCESS_WY_FLIGHT,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_EXEC,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/manager/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/corpse/administrator
	name = "Corpse - Colony Administrator"
	assignment = "Colonial Administrator"
	rank = JOB_DIRECTOR
	faction_group = FACTION_LIST_WY
	paygrade = PAY_SHORT_WYC10
	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_ENGINEERING,
		ACCESS_WY_FLIGHT,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_EXEC,
		ACCESS_WY_PMC,
		ACCESS_WY_PMC_TL,
		ACCESS_WY_ARMORY,
		ACCESS_WY_SECRETS,
		ACCESS_WY_LEADERSHIP,
		ACCESS_WY_SENIOR_LEAD,
	)

/datum/equipment_preset/corpse/administrator/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/cohiba(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo/executive(new_human), WEAR_R_STORE)
	add_random_cl_survivor_loot(new_human)

/datum/equipment_preset/corpse/administrator/burst
	name = "Corpse - Burst Colony Administrator"
	xenovictim = TRUE

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
		ACCESS_WY_SECURITY,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_GENERAL,
	)

/datum/equipment_preset/corpse/wysec/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

//Colonists

/datum/equipment_preset/corpse/colonist
	name = "Corpse - Colonist"

/datum/equipment_preset/colonist/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/colonist/burst
	name = "Corpse - Burst Colonist"
	xenovictim = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/corpse/colonist/random
	name = "Corpse - Colonist Random"

/datum/equipment_preset/corpse/colonist/random/load_gear(mob/living/carbon/human/new_human)
	var/random_surv_type = pick(SSmapping.configs[GROUND_MAP].survivor_types)
	var/datum/equipment_preset/survivor/surv_equipment = new random_surv_type
	surv_equipment.load_gear(new_human)

/datum/equipment_preset/corpse/colonist/random/burst
	name = "Corpse - Burst Colonist Random"
	xenovictim = TRUE

//*****************************************************************************************************/

/datum/equipment_preset/corpse/colonist/kutjevo
	name = "Corpse - Colonist Kutjevo"

/datum/equipment_preset/corpse/colonist/kutjevo/load_gear(mob/living/carbon/human/new_human)

	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	add_random_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/colonist/kutjevo/burst
	name = "Corpse - Burst Colonist Kutjevo"
	xenovictim = TRUE

//*****************************************************************************************************/

//UA Riot Control Officer

/datum/equipment_preset/corpse/ua_riot
	name = "Corpse - UA Officer"
	assignment = "United Americas Riot Officer"
	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/corpse/ua_riot/load_gear(mob/living/carbon/human/new_human)
	var/random = rand(1,5)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/classic_baton(new_human), WEAR_WAIST)

	switch(random)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human), WEAR_IN_BACK)


/datum/equipment_preset/corpse/ua_riot/burst
	name = "Corpse - Burst UA Officer"
	xenovictim = TRUE

//*****************************************************************************************************/

//Colonial Supervisor

/datum/equipment_preset/corpse/wy/manager
	name = "Corpse - Corporate Supervisor"
	assignment = "Colony Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = PAY_SHORT_WYC6
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	faction_group = FACTION_LIST_WY
	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_LEADERSHIP,
		ACCESS_WY_SECURITY,
		ACCESS_WY_EXEC,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_ENGINEERING,
		ACCESS_WY_MEDICAL,
		ACCESS_ILLEGAL_PIRATE,
	)

/datum/equipment_preset/corpse/wy/manager/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/manager(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	add_random_cl_survivor_loot(new_human)

/datum/equipment_preset/corpse/wy/manager/burst
	name = "Corpse - Burst Corporate Supervisor"
	xenovictim = TRUE

//*****************************************************************************************************/

//Faction Specific Corpses

//CLF

/datum/equipment_preset/corpse/clf
	name = "Corpse - Colonial Liberation Front Soldier"
	assignment = JOB_CLF
	idtype = /obj/item/card/id/data
	rank = JOB_CLF
	faction = FACTION_CLF

/datum/equipment_preset/corpse/clf/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE) + get_access(ACCESS_LIST_COLONIAL_ALL)

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

//*****************************************************************************************************/

//UPP

/datum/equipment_preset/corpse/upp
	name = "Corpse - Union of Progressive Peoples Soldier"
	assignment = JOB_UPP
	idtype = /obj/item/card/id/dogtag
	paygrade = PAY_SHORT_UE2
	rank = JOB_UPP
	faction = FACTION_UPP

/datum/equipment_preset/corpse/upp/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE) + get_access(ACCESS_LIST_COLONIAL_ALL)

/datum/equipment_preset/corpse/upp/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	add_random_survivor_equipment(new_human)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/corpse/upp/burst
	name = "Corpse - Burst Union of Progressive Peoples Soldier"
	xenovictim = TRUE

//*****************************************************************************************************/

//PMC

/datum/equipment_preset/corpse/pmc
	name = "Corpse - Weyland-Yutani PMC (Standard)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_PMC_STANDARD
	faction = FACTION_PMC
	faction_group = FACTION_LIST_WY
	rank = JOB_PMC_STANDARD
	paygrade = PAY_SHORT_PMC_OP
	idtype = /obj/item/card/id/pmc
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_PMC,
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

//*****************************************************************************************************/

//Goon

/datum/equipment_preset/corpse/pmc/goon
	name = "Corpse - Weyland-Yutani Corporate (Goon)"
	languages = list(LANGUAGE_ENGLISH)
	assignment = JOB_WY_GOON
	rank = JOB_WY_GOON
	paygrade = PAY_SHORT_CPO

/datum/equipment_preset/corpse/pmc/goon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
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

//*****************************************************************************************************/

//Lead Goon

/datum/equipment_preset/corpse/pmc/goon/lead
	name = "Corpse - Weyland-Yutani Corporate Security Lead (Goon Lead)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrade = PAY_SHORT_CSPO

/datum/equipment_preset/corpse/pmc/goon/lead/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
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

/datum/equipment_preset/corpse/pmc/goon/lead/burst
	name = "Corpse - Burst Weyland-Yutani Corporate Security Lead (Goon Lead)"
	xenovictim = TRUE

//*****************************************************************************************************/

//Freelancer

/datum/equipment_preset/corpse/freelancer
	name = "Corpse - Freelancer"
	paygrade = PAY_SHORT_FL_S
	rank = FACTION_FREELANCER
	idtype = /obj/item/card/id/data
	faction = FACTION_FREELANCER

/datum/equipment_preset/corpse/freelancer/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE) + get_access(ACCESS_LIST_COLONIAL_ALL)

/datum/equipment_preset/corpse/freelancer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	spawn_merc_helmet(new_human)

/datum/equipment_preset/corpse/freelancer/burst
	name = "Corpse - Burst Freelancer"
	xenovictim = TRUE

//*****************************************************************************************************/

//Fun Faction Corpses

//Pirates

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

//Russian(?)

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
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	if(prob(25))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bearpelt(new_human), WEAR_HEAD)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(new_human), WEAR_HEAD)

//*****************************************************************************************************/

//Dutch Dozen

/datum/equipment_preset/corpse/dutchrifle
	name = "Corpse - Dutch Dozen Rifleman"
	assignment = "Dutch Dozen Rifleman"
	idtype = /obj/item/card/id/silver
	faction = FACTION_DUTCH
	xenovictim = FALSE

/datum/equipment_preset/corpse/dutchrifle/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE) + get_access(ACCESS_LIST_COLONIAL_ALL)

/datum/equipment_preset/corpse/dutchrifle/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	spawn_merc_helmet(new_human)

/datum/equipment_preset/corpse/dutchrifle/burst
	name = "Corpse - Burst Dutch Dozen Rifleman"
	xenovictim = TRUE

//*****************************************************************************************************/

//Pizza Planet

/datum/equipment_preset/corpse/pizza
	name = "Corpse - Pizza Deliverer"
	assignment = "Pizza Deliverer"
	idtype = /obj/item/card/id/silver
	faction = FACTION_PIZZA
	xenovictim = FALSE

/datum/equipment_preset/corpse/pizza/New()
	. = ..()
	access = get_access(ACCESS_LIST_DELIVERY)

/datum/equipment_preset/corpse/pizza/load_gear(mob/living/carbon/human/new_human)
	add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pizza, WEAR_BODY)
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

//*****************************************************************************************************/

//Gladiator

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
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(new_human)
	lantern.name = "Beacon of Holy Light"

/datum/equipment_preset/corpse/gladiator/burst
	name = "Corpse - Burst Gladiator"
	xenovictim = TRUE

//*****************************************************************************************************/

//FORECON

/datum/equipment_preset/corpse/forecon_spotter
	name = "Corpse - USCM Reconnaissance Spotter"
	assignment = "Reconnaissance Spotter"
	xenovictim = FALSE
	paygrade = PAY_SHORT_ME5
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "FORECON"
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
	)

/datum/equipment_preset/corpse/forecon_spotter/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
