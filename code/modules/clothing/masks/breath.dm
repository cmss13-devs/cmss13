/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	flags_inventory = COVERMOUTH|ALLOWINTERNALS
	flags_armor_protection = 0
	w_class = SIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

	var/hanging = 0

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.is_mob_restrained())
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
	permeability_coefficient = 0.01



//REBREATHER

/obj/item/clothing/mask/rebreather
	name = "rebreather"
	desc = "A close-fitting device that instantly heats or cools down air when you inhale so it doesn't damage your lungs."
	icon_state = "rebreather"
	item_state = "rebreather"
	w_class = SIZE_SMALL
	flags_armor_protection = 0
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDELOWHAIR

/obj/item/clothing/mask/rebreather/scarf
	name = "heat absorbent coif"
	desc = "A close-fitting cap that covers the top, back, and sides of the head. Can also be adjusted to cover the lower part of the face so it keeps the user warm in harsh conditions."
	icon_state = "coif"
	item_state = "coif"
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEALLHAIR|HIDEEARS
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	var/pulled = FALSE
	var/original_state = "coif"

/obj/item/clothing/mask/rebreather/scarf/verb/pull_down()
	set name = "Pull Up/Down"
	set category = "Object"

	if(usr.stat == DEAD)
		return

	flags_inv_hide ^= HIDEFACE|HIDELOWHAIR
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
	name = "tactical bandana"
	desc = "A tactical bandana used by soldiers to conceal their face."
	icon_state = "scarf_gray"
	item_state = "scarf_gray"
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEFACE|HIDELOWHAIR
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature

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