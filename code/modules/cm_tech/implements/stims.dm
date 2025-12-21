
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

/obj/item/storage/pouch/stimulant_injector/update_icon()
	. = ..()

	if(storage_slots > 0 && length(contents) <= storage_slots)
		var/number = length(contents)
		overlays += "+[storage_slots]_slot_[number]"

/obj/item/storage/pouch/stimulant_injector/speed
	name = "speed stimulant pouch"
	desc = "A pouch that can hold up to 3 speed stimulant injectors."
	icon_state = "stimulant_speed"
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector/speed_stimulant)

/obj/item/storage/pouch/stimulant_injector/brain
	name = "brain stimulant pouch"
	icon_state = "stimulant_brain"
	desc = "A pouch that can hold up to 3 brain stimulant injectors."
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector/brain_stimulant)

/obj/item/storage/pouch/stimulant_injector/redemption
	name = "redemption stimulant pouch"
	desc = "A pouch that holds one redemption stimulant injector at a time."
	icon_state = "stimulant_redemption"
	storage_slots = 1
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector/redemption_stimulant)

/obj/item/reagent_container/hypospray/autoinjector/stimulant
	icon_state = "stimpack"
	// 5 minutes per injection
	amount_per_transfer_from_this = 5
	// maximum of 15 minutes per injector, has an OD of 15
	volume = 5
	uses_left = 1
	display_maptext = TRUE

/obj/item/reagent_container/hypospray/autoinjector/stimulant/update_icon()
	overlays.Cut()
	if(!uses_left)
		icon_state = "stimpack0"
		return

	icon_state = "stimpack"
	var/datum/reagent/Reagent = GLOB.chemical_reagents_list[chemname]

	if(!Reagent)
		return
	var/image/Image = image(icon, src, icon_state="+stimpack_custom")
	Image.color = Reagent.color
	overlays += Image

/obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant
	name = "speed stimulant autoinjector"
	chemname = "speed_stimulant"
	desc = "A stimpack loaded with an experimental performance enhancement stimulant. Extremely muscle-stimulating. Lasts 5 minutes."
	maptext_label = "StSp"

/obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant
	name = "brain stimulant autoinjector"
	chemname = "brain_stimulant"
	desc = "A stimpack loaded with an experimental CNS stimulant. Extremely nerve-stimulating. Lasts 5 minutes."
	maptext_label = "StBr"

/obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant
	name = "redemption stimulant autoinjector"
	chemname = "redemption_stimulant"
	desc = "A stimpack loaded with an experimental bone, organ and muscle stimulant. Significantly increases what a human can take before they go down. Lasts 5 minutes."
	maptext_label = "StRe"
