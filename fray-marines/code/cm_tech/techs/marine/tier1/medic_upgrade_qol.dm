/datum/tech/droppod/item/medic_czsp
	name = "Squad Medic Combat Zone Support Package"
	desc = "Gives medics to use powerful tools to heal marines."
	icon_state = "medic_qol"
	droppod_name = "Medic CZSP"

	flags = TREE_FLAG_MARINE

	required_points = 15
	tier = /datum/tier/one

/datum/tech/droppod/item/medic_czsp/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()
	if(!H || !D)
		return
	if(H.job == JOB_SQUAD_MEDIC)
		.["Medical CZSP"] = /obj/item/storage/box/combat_zone_support_package
	else
		var/type_to_add = /obj/item/stack/medical/bruise_pack
		if(prob(50))
			type_to_add = /obj/item/stack/medical/ointment

		if(prob(5))
			type_to_add = /obj/item/device/healthanalyzer

		.["Random Medical Item"] = type_to_add

/obj/item/storage/box/combat_zone_support_package
	name = "medical czsp"
	storage_slots = 3

/obj/item/storage/box/combat_zone_support_package/Initialize()
	. = ..()
	new/obj/item/storage/box/medic_upgraded_kits(src)
	new/obj/item/stack/medical/splint/nano(src)
	new /obj/item/weapon/gun/pill(src)

/obj/item/storage/box/medic_upgraded_kits
	name = "medical upgrade kit"
	max_w_class = SIZE_MEDIUM

	storage_slots = 2

/obj/item/storage/box/medic_upgraded_kits/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)
