
/datum/equipment_preset/corpse
	name = "Corpse"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_COLONIST
	rank = JOB_COLONIST
	faction = FACTION_COLONIST

	access = list(ACCESS_CIVILIAN_PUBLIC)
	skills = /datum/skills/civilian
	idtype = /obj/item/card/id/lanyard
	var/xenovictim = FALSE //Set to true to make the corpse spawn as a victim of a xeno burst

/datum/equipment_preset/corpse/load_status(mob/living/carbon/human/H)
	. = ..(H)
	H.death("existing", 1) //Kills the new mob
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
			H.dir = N.dir
			H.update_canmove()
			N.buckled_mob = H
			N.afterbuckle(H)
	H.undefibbable = TRUE
	H.spawned_corpse = TRUE

/datum/equipment_preset/corpse/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/realpirate
	name = "Corpse - Pirate"
	
/datum/equipment_preset/corpse/realpirate/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), WEAR_HEAD)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/realpirate/ranged
	name = "Corpse - Pirate Gunner"

/datum/equipment_preset/corpse/realpirate/ranged/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(H), WEAR_HEAD)
	. = ..()

/*****************************************************************************************************/

/datum/equipment_preset/corpse/russian
	name = "Corpse - Russian"

/datum/equipment_preset/corpse/russian

/datum/equipment_preset/corpse/russian/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	if(prob(25))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/bearpelt(H), WEAR_HEAD)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)

/*****************************************************************************************************/
                                 ///////////Civilians//////////////////////

/datum/equipment_preset/corpse/prisoner
	name = "Corpse - Prisoner"
	assignment = "Prisoner"

/datum/equipment_preset/corpse/prisoner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/chef
	name = "Corpse - Chef"
	assignment = "Chef"

/datum/equipment_preset/corpse/chef/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/doctor
	name = "Corpse - Doctor"
	assignment = "Medical Doctor"
	xenovictim = TRUE

/datum/equipment_preset/corpse/doctor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/medic(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/engineer
	name = "Corpse - Engineer"
	assignment = "Station Engineer"
	xenovictim = TRUE

/datum/equipment_preset/corpse/engineer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), WEAR_HEAD)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/clown
	name = "Corpse - Clown"
	assignment = "Clown"
	uses_special_name = TRUE

/datum/equipment_preset/corpse/clown/load_name(mob/living/carbon/human/H, var/randomise)
	. = ..() //To load gender, randomise appearance, etc.
	H.change_real_name(H, pick(clown_names)) //Picking a proper clown name!

/datum/equipment_preset/corpse/clown/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/toy/bikehorn(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(H), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/scientist
	name = "Corpse - Scientist"
	assignment = "Scientist"
	xenovictim = TRUE

/datum/equipment_preset/corpse/scientist/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/miner
	name = "Corpse - Shaft Miner"
	assignment = "Shaft Miner"
	xenovictim = TRUE

/datum/equipment_preset/corpse/miner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/security
	name = "Corpse - Security"
	assignment = "Deputy"
	xenovictim = TRUE

/datum/equipment_preset/corpse/security/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/security/marshal
	name = "Corpse - Marshal"
	assignment = "Marshal"
	xenovictim = TRUE

/datum/equipment_preset/corpse/security/marshal/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(H), WEAR_JACKET)
	. = ..()

/*****************************************************************************************************/

/datum/equipment_preset/corpse/security/lawyer
	name = "Corpse - Lawyer"
	assignment = "Lawyer"
	xenovictim = TRUE
	paygrade = "WY1"

/datum/equipment_preset/corpse/security/lawyer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/bluesuit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/internalaffairs(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	. = ..()

/*****************************************************************************************************/

/datum/equipment_preset/corpse/prison_security
	name = "Corpse - Prison Guard"
	assignment = "Prison Guard"

/datum/equipment_preset/corpse/prison_security/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)

/*****************************************************************************************************/
                                /////////////////Officers//////////////////////

/datum/equipment_preset/corpse/bridgeofficer
	name = "Corpse - Staff Officer"
	idtype = /obj/item/card/id/admiral
	assignment = "Staff Officer"

/datum/equipment_preset/corpse/bridgeofficer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

/*****************************************************************************************************/
/datum/equipment_preset/corpse/bridgeofficer/johnson
	name = "Corpse - Mr. Johnson Telovin"
	idtype = /obj/item/card/id/admiral
	assignment = "Bridge Officer"
	uses_special_name = TRUE
	paygrade = "WY1"

/datum/equipment_preset/corpse/bridgeofficer/johnson/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/waiter(H), WEAR_BODY)
	. = ..()

/datum/equipment_preset/corpse/bridgeofficer/johnson/load_name(mob/living/carbon/human/H, var/randomise)
	H.change_real_name(H, "Johnson Telovin")

/*****************************************************************************************************/

/datum/equipment_preset/corpse/commander
	name = "Corpse - Commanding Officer"
	idtype = /obj/item/card/id/admiral
	assignment = "Commanding Officer"

/datum/equipment_preset/corpse/commander/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/cohiba(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/centhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/corpse/PMC
	name = "Corpse - Private Security Officer"
	idtype = /obj/item/card/id/pmc
	assignment = "Private Security Officer"

/datum/equipment_preset/corpse/PMC/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo(H), WEAR_R_STORE)
