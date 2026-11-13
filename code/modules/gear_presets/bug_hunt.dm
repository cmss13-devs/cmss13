/datum/equipment_preset/uscm_co/bug_hunt
	name = "Bug Hunt Platoon Commander"
	assignment = JOB_PLATOON_COMMANDER
	job_title = JOB_CO
	manifest_title = JOB_PLATOON_COMMANDER
	paygrades = list(PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/sl_pve/bug_hunt
	role_comm_title = "PlatCo"
	hud_icon = "wo_co"
	hud_color = "#32CD32"
	minimap_icon = "co_wo"
	dress_extra = null
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm_co/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm_co/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.rank_override = "wo_co"
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm_co/bug_hunt/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW)

/datum/equipment_preset/uscm_ship/xo/bug_hunt
	name = "Bug Hunt Operations Officer"
	assignment = JOB_OPERATIONS_OFFICER
	job_title = JOB_XO
	manifest_title = JOB_OPERATIONS_OFFICER
	paygrades = list(PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/sl_pve/bug_hunt
	role_comm_title = "Ops"
	hud_icon = "wo_xo"
	hud_color = "#32CD32"
	minimap_icon = "xo_wo"
	dress_extra = null
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm_ship/xo/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm_ship/xo/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.rank_override = "wo_xo"
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm_ship/xo/bug_hunt/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW)

/datum/equipment_preset/uscm/pfc/bug_hunt
	name = "Bug Hunt Reconnaissance Rifleman"
	assignment = JOB_RECON_RIFLEMAN
	job_title = JOB_SQUAD_MARINE
	manifest_title = JOB_RECON_RIFLEMAN
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/rifleman_pve/bug_hunt
	hud_icon = "grunt"
	hud_color = "#32CD32"
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm/pfc/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm/pfc/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm/leader/bug_hunt
	name = "Bug Hunt Platoon Sergeant"
	assignment = JOB_PLATOON_SERGEANT
	job_title = JOB_SQUAD_LEADER
	manifest_title = JOB_PLATOON_SERGEANT
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME8 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/sl_pve/bug_hunt
	role_comm_title = "PSG"
	hud_color = "#32CD32"
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm/leader/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm/leader/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm/tl/bug_hunt
	name = "Bug Hunt Reconnaissance Section Leader"
	assignment = JOB_RECON_SECTION_LEADER
	job_title = JOB_SQUAD_TEAM_LEADER
	manifest_title = JOB_RECON_SECTION_LEADER
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME6 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/tl_pve/bug_hunt
	role_comm_title = "SL"
	hud_color = "#32CD32"
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm/tl/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm/tl/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm/medic/bug_hunt
	name = "Bug Hunt Reconnaissance Corpsman"
	assignment = JOB_RECON_CORPSMAN
	job_title = JOB_SQUAD_MEDIC
	manifest_title = JOB_RECON_CORPSMAN
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/combat_medic_pve/bug_hunt
	hud_color = "#32CD32"
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm/medic/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm/medic/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm/engineer/bug_hunt
	name = "Bug Hunt Reconnaissance Engineer"
	assignment = JOB_RECON_ENGINEER
	job_title = JOB_SQUAD_ENGI
	manifest_title = JOB_RECON_ENGINEER
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/rifleman_pve/bug_hunt
	hud_color = "#32CD32"
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm/engineer/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm/engineer/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm/sg/bug_hunt
	name = "Bug Hunt Reconnaissance Smartgunner"
	assignment = JOB_RECON_SMARTGUNNER
	job_title = JOB_SQUAD_SMARTGUN
	manifest_title = JOB_RECON_SMARTGUNNER
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/smartgunner_pve/bug_hunt
	hud_color = "#32CD32"
	utility_under = list(/obj/item/clothing/under/marine)

/datum/equipment_preset/uscm/sg/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/uscm/sg/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/synth/uscm/bug_hunt
	name = "Bug Hunt Reconnaissance Synthetic"
	assignment = JOB_RECON_SYNTHETIC
	job_title = JOB_SYNTH
	manifest_title = JOB_RECON_SYNTHETIC
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	hud_icon = "syn"
	hud_color = "#32CD32"

/datum/equipment_preset/synth/uscm/bug_hunt/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/synth/uscm/bug_hunt/load_gear(mob/living/carbon/human/new_human)
	new_human.rank_override = "syn"
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/forecon/bug_hunt(new_human), WEAR_L_EAR)

/datum/equipment_preset/proc/load_bug_hunt_equipment(mob/living/carbon/human/new_human, head_type = /obj/item/clothing/head/helmet/marine, armor_type = /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, back_type = /obj/item/storage/backpack/marine/satchel, uniform_type = /obj/item/clothing/under/marine)
	var/obj/item/clothing/under/marine/uniform = new uniform_type(new_human)
	uniform.add_forecon_patches(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new head_type(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new armor_type(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new back_type(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	var/obj/item/card/id/id = new_human.get_idcard()
	var/rank_type = get_rank_pins(id.paygrade)
	if(rank_type && !(locate(/obj/item/clothing/accessory/ranks) in new_human.w_uniform.accessories))
		new_human.w_uniform.attach_accessory(new_human, new rank_type, TRUE)

/datum/equipment_preset/uscm_co/bug_hunt/equipped
	name = "Bug Hunt Platoon Commander (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm_co/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human, head_type = /obj/item/clothing/head/helmet/marine/leader/CO, armor_type = /obj/item/clothing/suit/storage/marine/CIC/CO)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm_ship/xo/bug_hunt/equipped
	name = "Bug Hunt Operations Officer (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm_ship/xo/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human, head_type = /obj/item/clothing/head/helmet/marine/MP/SO, armor_type = /obj/item/clothing/suit/storage/marine/CIC, uniform_type = /obj/item/clothing/under/marine/officer/bridge)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm/leader/bug_hunt/equipped
	name = "Bug Hunt Platoon Sergeant (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/leader/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human, head_type = /obj/item/clothing/head/helmet/marine/leader, armor_type = /obj/item/clothing/suit/storage/marine/medium/leader)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/extended(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/extended(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm/tl/bug_hunt/equipped
	name = "Bug Hunt Reconnaissance Section Leader (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/tl/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/forecon(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm/medic/bug_hunt/equipped
	name = "Bug Hunt Reconnaissance Corpsman (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/medic/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human, head_type = /obj/item/clothing/head/helmet/marine/medic)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/forecon(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/surgical_case/regular(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm/engineer/bug_hunt/equipped
	name = "Bug Hunt Reconnaissance Engineer (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/engineer/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human, head_type = /obj/item/clothing/head/helmet/marine/tech)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/forecon(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm/sg/bug_hunt/equipped
	name = "Bug Hunt Reconnaissance Smartgunner (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/sg/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human, head_type = /obj/item/clothing/head/helmet/marine, armor_type = /obj/item/clothing/suit/storage/marine/smartgunner, back_type = /obj/item/storage/large_holster/machete/smartgunner/full)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large(new_human), WEAR_L_STORE)

/datum/equipment_preset/uscm/pfc/bug_hunt/equipped
	name = "Bug Hunt Reconnaissance Rifleman (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/pfc/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	load_bug_hunt_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/forecon(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)

/datum/equipment_preset/synth/uscm/bug_hunt/equipped
	name = "Bug Hunt Reconnaissance Synthetic (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/synth/uscm/bug_hunt/equipped/load_gear(mob/living/carbon/human/new_human)
	..()
	var/obj/item/clothing/under/marine/officer/engi/uniform = new(new_human)
	uniform.add_forecon_patches(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
