/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	icon = 'icons/obj/items/clothing/masks/gasmasks.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/gasmasks.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_righthand.dmi',
	)
	flags_inventory = COVERMOUTH|ALLOWINTERNALS
	flags_armor_protection = 0
	w_class = SIZE_SMALL
	gas_transfer_coefficient = 0.10

	var/hanging = 0

/obj/item/clothing/mask/breath/verb/toggle()
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	if(usr.is_mob_incapacitated())
		if(!src.hanging)
			src.hanging = !src.hanging
			gas_transfer_coefficient = 1 //gas is now escaping to the turf and vice versa
			flags_inventory &= ~(COVERMOUTH|ALLOWINTERNALS)
			icon_state = "breathdown"
			to_chat(usr, "Your mask is now hanging on your neck.")

		else
			src.hanging = !src.hanging
			gas_transfer_coefficient = 0.10
			flags_inventory |= COVERMOUTH|ALLOWINTERNALS
			icon_state = "breath"
			to_chat(usr, "You pull the mask up to cover your face.")
		update_clothing_icon()

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"

//REBREATHER

/obj/item/clothing/mask/rebreather
	name = "rebreather"
	desc = "A close-fitting device that instantly heats or cools down air when you inhale so it doesn't damage your lungs."
	icon_state = "rebreather"
	item_state = "rebreather"
	icon = 'icons/obj/items/clothing/masks/gasmasks.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/gasmasks.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_righthand.dmi',
	)
	w_class = SIZE_SMALL
	flags_armor_protection = 0
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDELOWHAIR

/obj/item/clothing/mask/rebreather/skull
	name = "skull balaclava"
	desc = "The face of your nightmares. Or at least that's how you imagined it'd be. Additionally protects against the cold."
	icon_state = "blue_skull_balaclava"
	item_state = "blue_skull_balaclava"
	icon = 'icons/obj/items/clothing/masks/balaclava.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/balaclava.dmi'
	)
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEALLHAIR|HIDEEARS|HIDEFACE
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/mask/rebreather/skull/black
	desc = "The face of your nightmares. Or at least that's how you imagined it'd be. Now in black!"
	icon_state = "black_skull_balaclava"
	item_state = "black_skull_balaclava"


/obj/item/clothing/mask/rebreather/scarf
	name = "heat absorbent coif"
	desc = "A close-fitting cap that covers the top, back, and sides of the head. Can also be adjusted to cover the lower part of the face so it keeps the user warm in harsh conditions."
	icon_state = "coif"
	item_state = "coif"
	icon = 'icons/obj/items/clothing/masks/balaclava.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/balaclava.dmi'
	)
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEALLHAIR|HIDEEARS|HIDEFACE
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	var/pulled = FALSE
	var/original_state = "coif"
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/mask/rebreather/scarf/ui_action_click()
	pull_down()

/obj/item/clothing/mask/rebreather/scarf/verb/pull_down()
	set name = "Pull Up/Down"
	set category = "Object"
	set src in usr
	if(usr.stat == DEAD)
		return
	flags_inv_hide ^= HIDEFACE
	pulled = !pulled
	if(pulled)
		to_chat(usr, SPAN_NOTICE("You pull \the [src] down."))
		icon_state += "_down"
	else
		to_chat(usr, SPAN_NOTICE("You pull \the [src] up."))
		icon_state = original_state

	update_clothing_icon(src) //Update the on-mob icon.



/obj/item/clothing/mask/rebreather/scarf/green
	name = "Green Balaclava"
	icon_state = "balaclava_green"
	item_state = "balaclava_green"
	original_state = "balaclava_green"

/obj/item/clothing/mask/rebreather/scarf/tan
	name = "Tan Balaclava"
	icon_state = "balaclava_tan"
	item_state = "balaclava_tan"
	original_state = "balaclava_tan"

/obj/item/clothing/mask/rebreather/scarf/gray
	name = "Gray Balaclava"
	icon_state = "balaclava_gray"
	item_state = "balacvlava_gray"
	original_state = "balaclava_gray"

/obj/item/clothing/mask/rebreather/scarf/tacticalmask
	name = "tactical wrap"
	desc = "A tactical wrap used by soldiers to conceal their face."
	icon_state = "scarf_gray"
	item_state = "scarf_gray"
	icon = 'icons/obj/items/clothing/masks/scarves.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/scarves.dmi'
	)
	original_state = "scarf_gray"
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEFACE
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/red
	icon_state = "scarf_red"
	item_state = "scarf_red"
	original_state = "scarf_red"

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/green
	icon_state = "scarf_green"
	item_state = "scarf_green"
	original_state = "scarf_green"

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan
	icon_state = "scarf_tan"
	item_state = "scarf_tan"
	original_state = "scarf_tan"

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/black
	icon_state = "scarf_black"
	item_state = "scarf_black"
	original_state = "scarf_black"

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad
	var/dummy_icon_state = "scarf_%SQUAD%"
	item_state = "scarf_%SQUAD%"
	original_state = "scarf_%SQUAD%"


	var/static/list/valid_icon_states

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad/Initialize(mapload, ...)
	. = ..()
	if(!valid_icon_states)
		valid_icon_states = icon_states(icon)
	adapt_to_squad()

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad/update_clothing_icon()
	adapt_to_squad()
	return ..()

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad/pickup(mob/user, silent)
	. = ..()
	adapt_to_squad()

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad/equipped(mob/user, slot, silent)
	RegisterSignal(user, COMSIG_SET_SQUAD, PROC_REF(update_clothing_icon), TRUE)
	adapt_to_squad()
	return ..()

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_SET_SQUAD)

/obj/item/clothing/mask/rebreather/scarf/tacticalmask/squad/proc/adapt_to_squad()
	var/squad_color = "gray"
	var/mob/living/carbon/human/wearer = loc
	if(istype(wearer) && wearer.assigned_squad)
		var/squad_name = lowertext(wearer.assigned_squad.name)
		if("scarf_[squad_name]" in valid_icon_states)
			squad_color = squad_name
	icon_state = replacetext("[initial(dummy_icon_state)][pulled ? "_down" : ""]", "%SQUAD%", squad_color)
	item_state = replacetext("[initial(item_state)][pulled ? "_down" : ""]", "%SQUAD%", squad_color)


/obj/item/clothing/mask/tornscarf
	name = "tactical scarf"
	desc = "A tactical scarf used to keep warm in the cold."
	icon_state = "torn_scarf_classic"
	item_state = "torn_scarf_classic"
	icon = 'icons/obj/items/clothing/masks/scarves.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/scarves.dmi'
	)
	w_class = SIZE_SMALL
	flags_inventory = ALLOWCPR
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/mask/tornscarf/green
	icon_state = "torn_scarf_green"
	item_state = "torn_scarf_green"

/obj/item/clothing/mask/tornscarf/snow
	icon_state = "torn_scarf_snow"
	item_state = "torn_scarf_snow"

/obj/item/clothing/mask/tornscarf/desert
	icon_state = "torn_scarf_desert"
	item_state = "torn_scarf_desert"

/obj/item/clothing/mask/tornscarf/urban
	icon_state = "torn_scarf_urban"
	item_state = "torn_scarf_urban"

/obj/item/clothing/mask/tornscarf/black
	icon_state = "torn_scarf_black"
	item_state = "torn_scarf_black"

/obj/item/clothing/mask/owlf_mask
	name = "\improper OWLF gas mask"
	desc = "A close-fitting mask that can be connected to an air supply."
	icon_state = "owlf_mask"
	item_state = "owlf_mask"
	icon = 'icons/obj/items/clothing/masks/gasmasks.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/gasmasks.dmi'
	)
	flags_inventory = COVERMOUTH|ALLOWINTERNALS
	flags_armor_protection = 0
	w_class = SIZE_SMALL
	gas_transfer_coefficient = 0.10

