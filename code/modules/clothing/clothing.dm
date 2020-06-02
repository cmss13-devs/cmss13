/obj/item/clothing
	name = "clothing"
	var/eye_protection = 0 //used for headgear, masks, and glasses, to see how much they protect eyes from bright lights.
	var/armor_melee = 0
	var/armor_bullet = 0
	var/armor_laser = 0
	var/armor_energy = 0
	var/armor_bomb = 0
	var/armor_bio = 0
	var/armor_rad = 0
	var/armor_internaldamage = 0
	var/movement_compensation = 0
	var/list/accessories = list()
	var/list/valid_accessory_slots = list()
	var/list/restricted_accessory_slots = list()
	var/drag_unequip = FALSE
	var/blood_overlay_type = "" //which type of blood overlay to use on the mob when bloodied

/obj/item/clothing/get_examine_line()
	. = ..()
	var/list/ties = list()
	for(var/obj/item/clothing/accessory/accessory in accessories)
		if(accessory.high_visibility)
			ties += "\a [accessory.get_examine_line()]"
	if(ties.len)
		.+= " with [english_list(ties)] attached"
	if(accessories && accessories.len > ties.len)
		.+= ". <a href='?src=\ref[src];list_acc=1'>\[See accessories\]</a>"

/obj/item/clothing/Topic(href, href_list)
	if(href_list["list_acc"])
		if(accessories && accessories.len)
			var/list/ties = list()
			for(var/accessory in accessories)
				ties += "[htmlicon(accessory)] \a [accessory]"
			to_chat(usr, "Attached to \the [src] are [english_list(ties)].")
		return

/obj/item/clothing/attack_hand(mob/user as mob)
	if (drag_unequip && ishuman(usr) && src.loc == user)	//make it harder to accidentally undress yourself
		return

	..()

/obj/item/clothing/proc/get_armor(armortype)
	var/armor_total = 0
	var/armor_count = 0
	if(armortype & ARMOR_MELEE)
		armor_total += armor_melee
		armor_count++
	if(armortype & ARMOR_BULLET)
		armor_total += armor_bullet
		armor_count++
	if(armortype & ARMOR_LASER)
		armor_total += armor_laser
		armor_count++
	if(armortype & ARMOR_ENERGY)
		armor_total += armor_energy
		armor_count++
	if(armortype & ARMOR_BOMB)
		armor_total += armor_bomb
		armor_count++
	if(armortype & ARMOR_BIO)
		armor_total += armor_bio
		armor_count++
	if(armortype & ARMOR_RAD)
		armor_total += armor_rad
		armor_count++
	if(armortype & ARMOR_INTERNALDAMAGE)
		armor_total += armor_internaldamage
		armor_count++
	if(armor_count == 0)
		return 0
	return armor_total/armor_count

//Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

/obj/item/clothing/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()

	if(slot == WEAR_L_HAND || slot == WEAR_R_HAND)
		return ret

	if(blood_color && blood_overlay_type)
		var/image/bloodsies = overlay_image('icons/effects/blood.dmi', "[blood_overlay_type]_blood", blood_color, RESET_COLOR)
		bloodsies.appearance_flags |= NO_CLIENT_COLOR
		ret.overlays += bloodsies

	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			ret.overlays |= A.get_mob_overlay(user_mob, slot)
	return ret



//BS12: Species-restricted clothing check.
//CM Update : Restricting armor to specific uniform
/obj/item/clothing/mob_can_equip(M as mob, slot)
	//if we can't equip the item anyway, don't bother with further checks (cuts down on spam)
	if (!..())
		return 0

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/under/U = H.w_uniform

		//some clothes can only be worn when wearing specific uniforms
		if(uniform_restricted && (!is_type_in_list(U, uniform_restricted) || !U))
			to_chat(H, SPAN_WARNING("Your [U ? "[U.name]":"naked body"] doesn't allow you to wear this [name].")) //Note : Duplicate warning, commenting
			return 0

	return 1


///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = SIZE_TINY
	throwforce = 2
	flags_equip_slot = SLOT_EAR

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	flags_equip_slot = SLOT_EAR


///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/items/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	allowed = list(/obj/item/tank/emergency_oxygen)
	armor_melee = 0
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	flags_equip_slot = SLOT_OCLOTHING
	blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = SIZE_MEDIUM
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_0.dmi')

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()


/obj/item/clothing/suit/mob_can_equip(mob/M, slot, disable_warning = 0)
	//if we can't equip the item anyway, don't bother with other checks.
	if (!..())
		return 0

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/under/U = H.w_uniform
		//some uniforms prevent you from wearing any suits but certain types
		if(U && U.suit_restricted && !is_type_in_list(src, U.suit_restricted))
			to_chat(H, SPAN_WARNING("[src] can't be worn with [U]."))
			return 0
	return 1

/obj/item/clothing/suit/proc/get_collar()
	var/icon/C = new('icons/mob/humans/onmob/collar.dmi')
	if(icon_state in C.IconStates())
		var/image/I = image(C, icon_state)
		I.color = color
		return I

/////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = SIZE_SMALL
	icon = 'icons/obj/items/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/cell/cell = 0
	flags_armor_protection = BODY_FLAG_HANDS
	flags_equip_slot = SLOT_HANDS
	attack_verb = list("challenged")
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/hands_monkey.dmi')
	blood_overlay_type = "hands"
	var/gloves_blood_amt = 0 //taken from blood.dm

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
		if(cell.reliability != 100 && prob(50/severity))
			cell.reliability -= 10 / severity
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()


//////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/items/clothing/masks.dmi'
	flags_equip_slot = SLOT_FACE
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	blood_overlay_type = "mask"
	var/anti_hug = 0

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/verb/toggle_internals()
	set category = "Object"
	set name = "Toggle Internals"
	set src in usr

	if(!(flags_inventory & ALLOWINTERNALS))
		to_chat(usr, SPAN_NOTICE("This mask doesnt support internals."))
		return

	if(!iscarbon(usr))
		return

	var/mob/living/carbon/C = usr
	if(C.is_mob_incapacitated())
		return
	
	if(C.internal)
		C.internal = null
		to_chat(C, SPAN_NOTICE("No longer running on internals."))
	else
		var/list/nicename = null
		var/list/tankcheck = null
		var/breathes = "oxygen"    //default, we'll check later
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			breathes = H.species.breath_type
			nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
			tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
		else
			nicename = list("Right Hand", "Left Hand", "Back")
			tankcheck = list(C.r_hand, C.l_hand, C.back)
		var/best = 0
		var/bestpressure = 0
		for(var/i=1, i<tankcheck.len+1, ++i)
			if(istype(tankcheck[i], /obj/item/tank))
				var/obj/item/tank/t = tankcheck[i]
				var/goodtank
				if(t.gas_type == GAS_TYPE_N2O) //anesthetic
					goodtank = TRUE
				else
					switch(breathes)
						if("nitrogen")
							if(t.gas_type == GAS_TYPE_NITROGEN)
								goodtank = TRUE
						if ("oxygen")
							if(t.gas_type == GAS_TYPE_OXYGEN || t.gas_type == GAS_TYPE_AIR)
								goodtank = TRUE
						if ("carbon dioxide")
							if(t.gas_type == GAS_TYPE_CO2)
								goodtank = TRUE
				if(goodtank)
					if(t.pressure >= 20 && t.pressure > bestpressure)
						best = i
						bestpressure = t.pressure
		//We've determined the best container now we set it as our internals
		if(best)
			to_chat(C, SPAN_NOTICE("You are now running on internals from [tankcheck[best]] on your [nicename[best]]."))
			C.internal = tankcheck[best]
		if(!C.internal)
			to_chat(C, SPAN_NOTICE("You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ",breathes)] tank."))
	return TRUE


//some gas masks modify the air that you breathe in.
/obj/item/clothing/mask/proc/filter_air(list/air_info)
	if(flags_inventory & ALLOWREBREATH)
		air_info[2] = T20C //heats/cools air to be breathable

	return air_info



////////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/items/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	flags_armor_protection = BODY_FLAG_FEET
	flags_equip_slot = SLOT_FEET
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	blood_overlay_type = "feet"
	var/obj/item/stored_item
	var/list/items_allowed
	var/shoes_blood_amt = 0
	
/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/Dispose()
	if(stored_item)
		qdel(stored_item)
		stored_item = null
	. = ..()

/obj/item/clothing/shoes/attack_hand(var/mob/living/M)
	if(stored_item && src.loc == M && !M.is_mob_incapacitated()) //Only allow someone to take out the stored_item if it's being worn or held. So you can pick them up off the floor
		if(M.put_in_active_hand(stored_item))
			to_chat(M, SPAN_NOTICE("You slide [stored_item] out of [src]."))
			playsound(M, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, 1)
			stored_item = 0
			update_icon()
			desc = initial(desc)
		return
	..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/living/M)
	if(items_allowed && items_allowed.len)
		for (var/i in items_allowed)
			if(istype(I, i))
				if(stored_item)	return
				M.drop_held_item()
				stored_item = I
				I.loc = src
				to_chat(M, "<div class='notice'>You slide the [I] into [src].</div>")
				playsound(M, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, 1)
				update_icon()
				desc = initial(desc) + "It is storing \a [stored_item]."
				break

/obj/item/clothing/equipped(mob/user, slot)
	if(slot != WEAR_L_HAND && slot != WEAR_R_HAND && equip_sounds.len)
		playsound_client(user.client, pick(equip_sounds), null, ITEM_EQUIP_VOLUME)
	..()	