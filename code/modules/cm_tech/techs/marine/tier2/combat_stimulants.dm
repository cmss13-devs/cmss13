/datum/tech/droppod/item/combat_stimulants
	name = "Combat Stimulants"
	desc = "Marines get access to combat stimulants to assist them in their activities."

	droppod_name = "Stimulants"
	flags = TREE_FLAG_MARINE

	required_points = 25
	tier = /datum/tier/two

	droppod_input_message = "Choose a stimulant to retrieve from the droppod."

/datum/tech/droppod/item/combat_stimulants/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Speed Stimulant"] = /obj/item/storage/pouch/stimulant_injector/speed
	.["Endurance Stimulant"] = /obj/item/storage/pouch/stimulant_injector/endurance
	.["Brain Stimulant"] = /obj/item/storage/pouch/stimulant_injector/brain

/obj/item/storage/pouch/stimulant_injector
	name = "stimulant pouch"
	desc = "Holds stimulant injectors."
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
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant

/obj/item/storage/pouch/stimulant_injector/brain
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant

/obj/item/storage/pouch/stimulant_injector/endurance
	stimulant_type = /obj/item/reagent_container/hypospray/autoinjector/stimulant/endurance_stimulant

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
	var/datum/reagent/R = chemical_reagents_list[chemname]

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

/obj/item/reagent_container/hypospray/autoinjector/stimulant/endurance_stimulant
	name = "endurance stimulant autoinjector"
	chemname = "endurance_stimulant"
	desc = "A stimpack loaded with an experimental bone, organ and muscle stimulant. Significantly increases what a human can take before they go down. Lasts 5 minutes."

/datum/reagent/stimulant
	reagent_state = LIQUID
	custom_metabolism = AMOUNT_PER_TIME(1, 1 MINUTES) // Consumes 1 unit per minute.
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	flags = REAGENT_SCANNABLE | REAGENT_TYPE_STIMULANT

/datum/reagent/stimulant/on_mob_life(mob/living/M, alien)
	. = ..()
	// Stimulants drain faster for each stimulant in the drug.
	// Having 2 stimulants means the duration will be 2x shorter, having 3 will be 3x shorter, etc
	for(var/i in holder.reagent_list)
		if(i == src)
			continue

		var/datum/reagent/R = i
		if(R.flags & REAGENT_TYPE_STIMULANT)
			holder.remove_reagent(R, custom_metabolism)

/datum/reagent/stimulant/speed_stimulant
	name = "Speed Stimulant"
	id = "speed_stimulant"
	description = "A highly experimental performance enhancement stimulant. Not as strong as ultrazine, however, it is not addictive."
	color = "#ffff00"
	properties = list(
		PROPERTY_MUSCLESTIMULATING = 30,
		PROPERTY_PAINKILLING = 3
	)

/datum/reagent/stimulant/brain_stimulant
	name = "Brain Stimulant"
	id = "brain_stimulant"
	description = "A highly experimental CNS stimulant."
	color = "#a800ff"
	properties = list(
		PROPERTY_NERVESTIMULATING = 30,
		PROPERTY_PAINKILLING = 6,
		PROPERTY_NEUROSHIELDING = 1
	)

/datum/reagent/stimulant/endurance_stimulant
	name = "Endurance Stimulant"
	id = "endurance_stimulant"
	description = {"\
		A highly experimental bone, organ and muscle stimulant.\
		Increases the durability of skin and bones as well as nullifying any pain.\
		Pain is impossible to feel whilst this drug is in your system.\
		During the metabolism of this drug, dysfunctional organs will work normally."}
	color = "#00ffa8"
	properties = list(
		PROPERTY_NERVESTIMULATING = 5,
		PROPERTY_MUSCLESTIMULATING = 5,
		PROPERTY_PAINKILLING = 100,
		PROPERTY_HYPERDENSIFICATING = 1,
		PROPERTY_ORGANSTABILIZE = 1
	)
