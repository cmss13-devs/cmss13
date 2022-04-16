/obj/item/iff_tag
	name = "xenomorph IFF tag"
	desc = "A tag containing a small IFF computer that gets inserted into the carapace of a xenomorph."
	icon_state = "lipstick_purple"
	var/list/faction_groups = list()

/obj/item/iff_tag/attack(mob/living/carbon/Xenomorph/X, mob/living/carbon/human/user)
	if(isXeno(X))
		user.visible_message(SPAN_NOTICE("[user] starts forcing \the [src] into [X]'s carapace..."), SPAN_NOTICE("You start forcing \the [src] into [X]'s carapace..."))
		var/list/id_faction_groups = user.get_id_faction_group()
		if(isnull(id_faction_groups) && !length(faction_groups))
			to_chat(user, SPAN_WARNING("The tag you're inserting doesn't have an IFF group set, remember that it reads off your ID slot."))
		if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, X, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		user.visible_message(SPAN_NOTICE("[user] forces \the [src] into [X]'s carapace!"), SPAN_NOTICE("You force \the [src] into [X]'s carapace!"))
		faction_groups = id_faction_groups
		X.iff_tag = src
		user.drop_inv_item_to_loc(src, X)
		return
	return ..()

/obj/item/iff_tag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		if(!length(faction_groups))
			to_chat(user, SPAN_NOTICE("\The [src] has no IFF groups set by default, it will take the IFF groups from your ID."))
			return
		to_chat(user, SPAN_NOTICE("\The [src]'s IFF groups is as follows: [english_list(faction_groups)]. This will be overridden if you keep your ID in its slot upon implanting the xenomorph."))
		return
	return ..()

/obj/item/iff_tag/pmc_handler
	faction_groups = FACTION_LIST_MARINE_WY
