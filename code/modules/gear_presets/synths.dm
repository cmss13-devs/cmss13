
/datum/equipment_preset/synth
	name = "Synth"

/datum/equipment_preset/synth/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian", "Tradeband", "Sainja", "Xenomorph"))

/datum/equipment_preset/synth/load_race(mob/living/carbon/human/H)
	H.set_species("Early Synthetic")

/*****************************************************************************************************/

/datum/equipment_preset/synth/combat_smartgunner
	name = "USCM Combat Synth (Smartgunner)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/synth/combat_smartgunner/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card (Combat Synth)"
	W.access = list()
	W.assignment = "Squad Smartgunner"
	W.rank = "Squad Smartgunner"
	W.registered_name = H.real_name
	W.paygrade = "E3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "LCpl"
		H.mind.assigned_role = "Squad Smartgunner"
		H.mind.set_cm_skills(/datum/skills/smartgunner)

/datum/equipment_preset/synth/combat_smartgunner/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc/crafty)

/datum/equipment_preset/synth/combat_smartgunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	var/obj/item/clothing/under/marine/J = new(H)
	J.icon_state = ""
	H.equip_to_slot_or_del(J, WEAR_BODY)
	var/obj/item/clothing/head/helmet/specrag/L = new(H)
	L.icon_state = ""
	L.name = "synth faceplate"
	L.flags_inventory |= NODROP
	L.anti_hug = 99

	H.equip_to_slot_or_del(L, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/combat_knife(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)