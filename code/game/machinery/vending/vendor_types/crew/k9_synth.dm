/obj/structure/machinery/cm_vending/clothing/k9_synth
	name = "\improper Wey-Yu Synthetic K9 Equipment Requisitions"
	desc = "An automated equipment vendor for Synthetic K9s."
	show_points = FALSE
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH_K9)

/obj/structure/machinery/cm_vending/clothing/k9_synth/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_k9_synth

//------------GEAR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_k9_synth, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/synth, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("K9 Serial ID Tags", 0, /obj/item/clothing/under/rank/synthetic/synth_k9, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Name Changer", 0, /obj/item/k9_name_changer/, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_MANDATORY),

		list("HANDLER KIT (CHOOSE 1)", 0, null, null, null),
		list("Squad Corpsman -> K9 Handler", 0, /obj/item/storage/box/kit/k9_handler/corpsman, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("Military Police -> K9 Handler", 0, /obj/item/storage/box/kit/k9_handler/mp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("CARRYPACK (CHOOSE 1)", 0, null, null, null),
		list("Medical Carry Harness", 0, /obj/item/storage/backpack/marine/k9_synth/medicalpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Cargo Carry Harness", 0, /obj/item/storage/backpack/marine/k9_synth/cargopack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("MP Carry Harness", 0, /obj/item/storage/backpack/marine/k9_synth/mppack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

	))
