/datum/tech/droppod/item/combat_implants
	name = "Combat Implants"
	desc = "Marines get access to combat implants to improve their ability to function."
	icon_state = "implants"
	droppod_name = "Implants"

	flags = TREE_FLAG_MARINE

	required_points = 25
	tier = /datum/tier/three/additional

	droppod_input_message = "Choose a combat implant to retrieve from the droppod."
	options_to_give = 2

/datum/tech/droppod/item/combat_implants/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Rejuvenation Implant"] = /obj/item/device/implanter/rejuv
	.["Agility Implant"] = /obj/item/device/implanter/agility
	.["Subdermal Armor"] = /obj/item/device/implanter/subdermal_armor
	.["Bone Hardening"] = /obj/item/device/implanter/bone_hardening

/datum/tech/droppod/item/combat_implants/get_items_to_give(mob/living/carbon/human/H, obj/structure/droppod/D)
	var/list/chosen_options = ..()

	if(!chosen_options)
		return

	var/obj/item/storage/box/implant/B = new()
	B.storage_slots = options_to_give
	for(var/i in chosen_options)
		new i(B)

	return list(B)


/obj/item/device/implanter/bone_hardening
	name = "bone hardening implant"
	desc = "Этот имплант улучшит структуру ваших костей, позволяя реже получать переломы и раздробления."
	implant_type = /obj/item/device/internal_implant/bone_hardening
	implant_string = "Вы чувствуете боль в суставах... Надеюсь, это не на всю жизнь."

/obj/item/device/internal_implant/bone_hardening
	var/bone_break_mult = 0.25

/obj/item/device/internal_implant/bone_hardening/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_BONEBREAK_PROBABILITY, PROC_REF(handle_bonebreak))

/obj/item/device/internal_implant/bone_hardening/proc/handle_bonebreak(mob/living/M, list/bonedata)
	SIGNAL_HANDLER
	bonedata["bonebreak_probability"] *= bone_break_mult
