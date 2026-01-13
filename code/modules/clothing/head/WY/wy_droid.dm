//=============================//WY COMBAT DROIDS\\==================================\\
//=======================================================================\\


/obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid
	name = "\improper M7X helmet"
	desc = "A heavily armored helmet with retractable face plate, made to complete the M7X Apesuit."
	icon_state = "combat_android_helmet"
	item_state = "combat_android_helmet"
	unacidable = TRUE
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = FULL_DECAP_PROTECTION
	flags_inv_hide = null
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	actions_types = list(/datum/action/item_action/toggle)
	unacidable = TRUE
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	anti_hug = 100
	var/deactivated = TRUE
	var/activate_cooldown = 0 //cooldown for mask activation

/obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid/attack_self(mob/user)
	..()

	if(activate_cooldown > world.time)
		return

	toggle()

/obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid/verb/toggle()
	set category = "Object"
	set name = "Activate integrated face armor plate"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	if(deactivated)
		flags_armor_protection &= ~(BODY_FLAG_FACE|BODY_FLAG_EYES)
		flags_inventory &= ~(COVEREYES|COVERMOUTH|BLOCKSHARPOBJ)
		flags_inv_hide &= ~(HIDEEARS|HIDEEYES|HIDEFACE)
		icon_state = "[initial(icon_state)]_on"
		to_chat(usr, SPAN_NOTICE("You active integrated face armor plate."))
	else
		flags_armor_protection |= BODY_FLAG_FACE|BODY_FLAG_EYES
		flags_inventory |= COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT
		flags_inv_hide |= HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
		icon_state = initial(icon_state)
		to_chat(usr, SPAN_NOTICE("You deactivate integrated face armor plate."))
	deactivated = !deactivated
	activate_cooldown = world.time + 35
	playsound(loc, 'sound/items/rped.ogg', 25, FALSE)

	update_clothing_icon() //so our mob-overlays update

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/head/helmet/marine/veteran/pmc/combat_droid/dark
	name = "\improper M7X Mark II helmet"
	desc = "A heavily armored helmet with retractable face plate and optical camouflage technology, made to complete the M7X Mark II Apesuit."
	icon_state = "invis_android_helmet"
	item_state = "invis_android_helmet"
