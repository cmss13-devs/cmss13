/obj/item/xeno_piece
	name = "unknown organ"
	desc = "Looking at it makes you want to vomit."
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "biomass"
	black_market_value = 50
	//For all of them for now, until we have specific organs/more techs

/obj/item/xeno_piece/resin
	name = "alien resin"
	desc = "A piece of alien resin."
	icon_state = "biomass"


/obj/item/xeno_piece/chitin
	name = "alien chitin"
	desc = "A chunk of alien chitin."
	icon_state = "chitin-chunk"


/obj/item/xeno_piece/blood
	name = "vial of alien blood"
	desc = "A sample of alien blood."
	icon_state = "blood-vial"








// ======== ITEMS YOU CAN MAKE THAT ARE BADASS ======== //

/obj/item/xeno_item
	name = "Strange Item"
	desc = "Some sort of fucked up item from the Weyland-Yutani brand 3D Biometric Printer...  Probably should make a bug report if you got this..."
	icon_state = "chitin-chunk"
	icon = 'icons/obj/items/Marine_Research.dmi'

/obj/item/xeno_item/resin_paste
	name = "Resin Paste"
	desc = "This resin paste will fix a broken helmet.  (Use by clicking the glue with the armor)."
	icon_state = "resin-glue"
	icon = 'icons/obj/items/Marine_Research.dmi'

/obj/item/xeno_item/resin_paste/afterattack(obj/item/clothing/head/helmet/marine/A as obj, mob/user as mob)
	if (!istype(A) || !istype(usr))
		to_chat(usr, "Doesn't work that way")
		return
	if (A.anti_hug >= 1)
		usr <<"This Helmet can't be further reinforced."
		return
	to_chat(usr, "You reinforce the Helmet...")
	A.anti_hug++
	user.temp_drop_inv_item(src)
	qdel(src)
	..()
	return

/obj/item/xeno_item/chitin_plate
	name = "Chitin Plate"
	desc = "A plate of Chitin Armor that can be attached to your Marine Armor to make it stronger, but will also slow you down.  (Use by clicking the plate with the armor)."
	icon_state = "chitin-armor"
	icon = 'icons/obj/items/Marine_Research.dmi'

/obj/item/xeno_item/chitin_plate/afterattack(obj/item/clothing/suit/storage/marine/A as obj, mob/user as mob)
	if (!istype(A) || !istype(usr))
		to_chat(usr, "Doesn't work that way...")
		return
	if (A.flags_marine_armor & ARMOR_IS_REINFORCED)
		usr <<"This armor is already reinforced."
		return
	to_chat(usr, "You reinforce the armor with some Chitin Plating...")
	A.armor_melee = 70
	A.armor_bullet = 90
	A.armor_laser = 7
	A.armor_energy = 40
	A.armor_bomb = 50
	A.armor_bio = 40
	A.armor_rad = 20
	A.slowdown++
	A.flags_marine_armor |= ARMOR_IS_REINFORCED
	user.temp_drop_inv_item(src)
	qdel(src)
	..()
	return


/obj/item/xeno_item/anti_acid
	name = "Anti-Acid Spray"
	desc = "A spray that makes whatever it's used on unacidable.  Single use."
	icon_state = "anti-acid"
	icon = 'icons/obj/items/Marine_Research.dmi'


/obj/item/xeno_item/anti_acid/afterattack(obj/A as obj, mob/user as mob, proximity)
	if (!isobj(A))
		to_chat(usr, "Doesn't work that way...")
		return
	if (A.unacidable == 1)
		to_chat(usr, "It's already resistant to acid...")
		return
	if (istype(A, /obj/structure/machinery/door))
		to_chat(usr, "It doesn't work on doors...")
		return
	to_chat(usr, "You spray [A] with the Anti-Acid spray making it unacidable...")
	A.unacidable = TRUE
	user.temp_drop_inv_item(src)
	qdel(src)
	..()
	return
