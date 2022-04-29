/obj/item/iff_tag
	name = "xenomorph IFF tag"
	desc = "A tag containing a small IFF computer that gets inserted into the carapace of a xenomorph. You can modify the IFF groups by using an access tuner on it, or on the xeno if it's already implanted."
	icon = 'icons/obj/items/xeno_tag.dmi'
	icon_state = "xeno_tag"
	var/list/faction_groups = list()

/obj/item/iff_tag/attack(mob/living/carbon/Xenomorph/xeno, mob/living/carbon/human/injector)
	if(isXeno(xeno))
		if(xeno.stat == DEAD)
			to_chat(injector, SPAN_WARNING("\The [xeno] is dead..."))
			return
		if(xeno.iff_tag)
			to_chat(injector, SPAN_WARNING("\The [xeno] already has a tag inside it."))
			return
		injector.visible_message(SPAN_NOTICE("[injector] starts forcing \the [src] into [xeno]'s carapace..."), SPAN_NOTICE("You start forcing \the [src] into [xeno]'s carapace..."))
		if(!do_after(injector, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, xeno, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		injector.visible_message(SPAN_NOTICE("[injector] forces \the [src] into [xeno]'s carapace!"), SPAN_NOTICE("You force \the [src] into [xeno]'s carapace!"))
		xeno.iff_tag = src
		injector.drop_inv_item_to_loc(src, xeno)
		return
	return ..()

/obj/item/iff_tag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) && ishuman(user))
		handle_reprogramming(user)
		return
	return ..()

/obj/item/iff_tag/proc/handle_reprogramming(var/mob/living/carbon/human/programmer, var/mob/living/carbon/Xenomorph/xeno)
	var/list/id_faction_groups = programmer.get_id_faction_group()
	var/option = tgui_alert(programmer, "The xeno tag's current IFF groups reads as: [english_list(faction_groups, "None")]\nYour ID's IFF group reads as: [english_list(id_faction_groups, "None")]", "Xenomorph IFF Tag", list("Overwrite", "Add", "Remove"))
	if(!option)
		return FALSE
	if(xeno)
		if(!xeno.iff_tag)
			to_chat(programmer, SPAN_WARNING("\The [src]'s tag got removed while you were reprogramming it!"))
			return FALSE
		if(!programmer.Adjacent(xeno))
			to_chat(programmer, SPAN_WARNING("You need to stay close to the xenomorph to reprogram the tag!"))
			return FALSE
	switch(option)
		if("Overwrite")
			faction_groups = id_faction_groups
		if("Add")
			faction_groups |= id_faction_groups
		if("Remove")
			faction_groups = list()
	to_chat(programmer, SPAN_NOTICE("You <b>[option]</b> the IFF group data, the IFF group on the tag now reads as: [english_list(faction_groups, "None")]"))
	return TRUE

/obj/item/iff_tag/pmc_handler
	faction_groups = FACTION_LIST_MARINE_WY


/obj/item/storage/xeno_tag_case
	name = "xenomorph tag case"
	desc = "A sturdy case designed to store and charge xenomorph IFF tags. Provided by the Wey-Yu Research and Data(TM) Division."
	icon = 'icons/obj/items/xeno_tag.dmi'
	icon_state = "tag_box"
	use_sound = "toolbox"
	storage_slots = 8
	can_hold = list(
		/obj/item/iff_tag,
		/obj/item/device/multitool
	)

/obj/item/storage/xeno_tag_case/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/iff_tag(src)
	new /obj/item/device/multitool(src)
