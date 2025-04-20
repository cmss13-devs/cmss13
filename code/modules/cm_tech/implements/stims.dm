
/obj/item/storage/pouch/stimulant_injector
	name = "stimulant pouch"
	desc = "A pouch that holds stimulant injectors."
	icon = 'icons/obj/items/clothing/pouches.dmi'
	icon_state = "stimulant"
	w_class = SIZE_LARGE //does not fit in backpack
	max_w_class = SIZE_SMALL
	flags_equip_slot = SLOT_STORE
	storage_slots = 3
	storage_flags = STORAGE_FLAGS_POUCH
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector/stimulant)
	var/stimulant_type

/obj/item/storage/pouch/stimulant_injector/fill_preset_inventory()
	if(!stimulant_type)
		return

	for(var/i in 1 to storage_slots)
		new stimulant_type(src)

/obj/item/storage/pouch/stimulant_injector/speed
	desc = "A pouch that holds speed stimulant injectors."
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant

/obj/item/storage/pouch/stimulant_injector/brain
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant
	desc = "A pouch that holds brain stimulant injectors."

/obj/item/storage/pouch/stimulant_injector/redemption
	desc = "A pouch that holds redemption stimulant injectors."
	storage_slots = 1
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant

/obj/item/reagent_container/hypospray/autoinjector/stimulant
	icon_state = "stimpack"
	// 5 minutes per injection
	amount_per_transfer_from_this = 5
	// maximum of 15 minutes per injector, has an OD of 15
	volume = 5
	uses_left = 1

/obj/item/reagent_container/hypospray/autoinjector/stimulant/update_icon()
	overlays.Cut()
	if(!uses_left)
		icon_state = "stimpack0"
		return

	icon_state = "stimpack"
	var/datum/reagent/R = GLOB.chemical_reagents_list[chemname]

	if(!R)
		return
	var/image/I = image(icon, src, icon_state="+stimpack_custom")
	I.color = R.color
	overlays += I

/obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant
	name = "speed stimulant autoinjector"
	chemname = "speed_stimulant"
	desc = "A stimpack loaded with an experimental performance enhancement stimulant. Extremely muscle-stimulating. Lasts 5 minutes."

/obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant
	name = "brain stimulant stimpack"
	chemname = "brain_stimulant"
	desc = "A stimpack loaded with an experimental CNS stimulant. Extremely nerve-stimulating. Lasts 5 minutes."

/obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant
	amount_per_transfer_from_this = 5
	volume = 5
	name = "redemption stimulant autoinjector"
	chemname = "redemption_stimulant"
	desc = "A stimpack loaded with an experimental bone, organ and muscle stimulant. Significantly increases what a human can take before they go down. Lasts 5 minutes."
