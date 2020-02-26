

/obj/item
	var/blood_color = "" //color of the blood on us if there's any.
	appearance_flags = KEEP_TOGETHER


/mob/living/carbon/human
	var/hands_blood_color = "" //color of the blood on our hands if there's any.
	var/hands_blood_amt = 0
	var/feet_blood_color = "" //color of the blood on our feet if there's any
	var/feet_blood_amt = 0

/obj/item/clothing/gloves
	var/gloves_blood_amt = 0

/obj/item/clothing/shoes
	var/shoes_blood_amt = 0




//to add blood from a mob onto something, and transfer their dna info and blood color
/atom/proc/add_mob_blood(mob/living/M)
	var/b_color = M.get_blood_color()
	if(!b_color)
		return 0

	return add_blood(b_color)




/////// add_blood ///////////////////

/obj/item
	var/global/list/blood_overlay_cache = list()

//to add blood onto something, with blood dna info to include.
/atom/proc/add_blood(b_color = "#830303")
	return 0

/turf/add_blood(b_color = "#830303")
	var/obj/effect/decal/cleanable/blood/splatter/B = locate() in src
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(src, b_color)
	return 1 //we bloodied the floor


/obj/item/add_blood(b_color = "#830303")
	if(flags_atom & NOBLOODY)
		return 0
	var/cur_blood_col = blood_color
	blood_color = b_color

	if(!cur_blood_col && !blood_overlay)//apply the blood-splatter overlay if it isn't already in there
		generate_blood_overlay(b_color)
		overlays += blood_overlay

	else if(blood_overlay && b_color && blood_overlay.color != b_color)
		overlays -= blood_overlay
		blood_overlay.color = b_color
		overlays += blood_overlay
	return 1 //we applied blood to the item

/obj/item/proc/generate_blood_overlay(b_color)
	var/icon/I = new /icon('icons/effects/blood.dmi', "itemblood")
	blood_overlay = image(I)
	blood_overlay.blend_mode = BLEND_INSET_OVERLAY
	blood_overlay.color = b_color

/mob/living/carbon/human/add_blood(b_color = "#830303")
	if(wear_suit)
		wear_suit.add_blood(b_color)
		update_inv_wear_suit()
	else if(w_uniform)
		w_uniform.add_blood(b_color)
		update_inv_w_uniform()
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		G.add_blood(b_color)
	else
		hands_blood_color = b_color
	hands_blood_amt = rand(2, 4)

	update_inv_gloves()	//handles bloody hands overlays and updating
	return 1


/atom/proc/clean_blood()
	return 0

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
