/obj/item/storage/pouch/autoinjector/full/skillless/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)

/obj/item/storage/pouch/medkit/attackby(obj/item/storage/firstaid/medkit, mob/user)
	if(!istype(medkit, /obj/item/storage/firstaid))
		return ..()
	if(user.action_busy)
		return
	if(user.skills?.get_skill_level(SKILL_MEDICAL) < SKILL_MEDICAL_TRAINED)
		to_chat(user, SPAN_WARNING("You untrained to do this."))
		return
	if(!medkit.contents.len)
		to_chat(user, SPAN_WARNING("[medkit] is empty."))
		return
	if(!has_room(medkit.contents[1]))
		to_chat(user, SPAN_WARNING("[src] is full."))
		return
	to_chat(user, SPAN_NOTICE("You start refilling [src] with [medkit]."))
	if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return
	for(var/obj/item/transfered_item in medkit)
		if(!has_room(transfered_item))
			break
		medkit.remove_from_storage(transfered_item)
		handle_item_insertion(transfered_item, TRUE, user)
		transfered_item.update_icon()
	playsound(user.loc, "rustle", 15, TRUE, 6)
	return TRUE
