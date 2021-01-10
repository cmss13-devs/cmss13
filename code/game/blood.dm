//to add blood from a mob onto something, and transfer their dna info and blood color
/atom/proc/add_mob_blood(mob/living/M)
	var/b_color = M.get_blood_color()
	if(!b_color)
		return 0

	return add_blood(b_color)

/////// add_blood ///////////////////
//to add blood onto something, with blood dna info to include.
/atom/proc/add_blood(b_color = "#830303")
	return FALSE

/turf/add_blood(b_color = "#830303")
	new /obj/effect/decal/cleanable/blood/splatter(src, b_color)
	return TRUE //we bloodied the floor


/obj/item/add_blood(b_color = "#830303")
	if(flags_atom & NOBLOODY)
		return 0
	var/cur_blood_col = blood_color
	blood_color = b_color

	if(!cur_blood_col && !blood_overlay)//apply the blood-splatter overlay if it isn't already in there
		generate_blood_overlay(b_color)
		overlays += blood_overlay

	else if(blood_overlay && b_color && blood_overlay.color != b_color)
		blood_overlay.color = b_color
	return TRUE //we applied blood to the item

/obj/item/proc/generate_blood_overlay(b_color)
	var/icon/I = new /icon('icons/effects/blood.dmi', "itemblood")
	blood_overlay = image(I)
	blood_overlay.blend_mode = BLEND_INSET_OVERLAY
	blood_overlay.color = b_color

/mob/living/carbon/human/add_blood(b_color = "#830303", blood_flags = BLOOD_ALL)
	if(blood_flags & BLOOD_BODY)
		if(wear_suit)
			wear_suit.add_blood(b_color)
			update_inv_wear_suit()
		else if(w_uniform)
			w_uniform.add_blood(b_color)
			update_inv_w_uniform()
	if(blood_flags & BLOOD_HANDS)
		if(gloves)
			var/obj/item/clothing/gloves/G = gloves
			G.add_blood(b_color)
		else
			hands_blood_color = b_color
			hands_blood_amt = rand(2, 4)
		update_inv_gloves() // Adds blood overlays for gloves or hands
	if(blood_flags & BLOOD_FEET)
		if(shoes)
			var/obj/item/clothing/shoes/S = shoes
			S.add_blood(b_color)
		else
			feet_blood_color = b_color
		update_inv_shoes() // Adds blood overlays for shoes or feet
	return TRUE


/atom/proc/clean_blood()
	return FALSE

/turf/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in src)
		qdel(B)
		. = 1

/obj/item/clean_blood()
	if(!blood_color)
		return 0
	blood_color = null
	if(blood_overlay)
		overlays.Remove(blood_overlay)
	return 1

/obj/item/clothing/gloves/clean_blood()
	. = ..()
	gloves_blood_amt = 0

/obj/item/clothing/shoes/clean_blood()
	. = ..()
	shoes_blood_amt = 0

/mob/living/carbon/human/clean_blood(clean_feet)
	if(gloves)
		if(gloves.clean_blood())
			update_inv_gloves()
			. = 1

	else if(hands_blood_color)
		hands_blood_color = null
		hands_blood_amt = 0
		update_inv_gloves()
		. = 1

	if(clean_feet && !shoes && feet_blood_color)
		feet_blood_color = null
		update_inv_shoes()
		return 1
