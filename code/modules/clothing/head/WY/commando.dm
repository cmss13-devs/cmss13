//=============================//WY COMMANDOS\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/commando
	name = "\improper W-Y Commando helmet"
	desc = "A standard enclosed helmet utilized by Weyland-Yutani Commandos."
	icon_state = "commando_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGH
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	anti_hug = 6
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/advanced)
	start_down_visor_type = /obj/item/device/helmet_visor/medical/advanced

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/commando/damaged
	name = "damaged W-Y Commando helmet"
	desc = "A standard enclosed helmet utilized by Weyland-Yutani Commandos. Has been through a lot of wear and tear."
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	anti_hug = 0

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/commando/sg
	icon_state = "commando_helmet_sg"

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/commando/leader
	name = "\improper W-Y Commando Leader helmet"
	desc = "A standard enclosed helmet utilized by Weyland-Yutani Commandos. This one is worn by a high ranking corporate officer."
	icon_state = "commando_helmet_leader"

/obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit
	name = "\improper M5X Apesuit helmet"
	desc = "A fully enclosed, armored helmet made to complete the M5X exoskeleton armor."
	icon_state = "apesuit_helmet"
	item_state = "apesuit_helmet"
	unacidable = TRUE
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGHPLUS
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_VERYHIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT|FULL_DECAP_PROTECTION
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	unacidable = TRUE
	anti_hug = 100
	actions_types = list(/datum/action/item_action/toggle/apesuit_visor)
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/advanced)
	var/deactivated = TRUE
	var/activate_cooldown = 0 //cooldown for mask activation
	var/has_visor = TRUE

/obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit/attack_self(mob/user)
	..()

	if(activate_cooldown > world.time)
		return

	if(!has_visor)
		return

	toggle()

/obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit/verb/toggle()
	set category = "Object"
	set name = "Flip helmet visor"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	if(deactivated)
		icon_state = "[initial(icon_state)]_open"
		to_chat(usr, SPAN_NOTICE("You flip helmet visor up."))
	else
		icon_state = initial(icon_state)
		to_chat(usr, SPAN_NOTICE("You flip helmet visor down."))
	deactivated = !deactivated
	activate_cooldown = world.time + 10

	update_clothing_icon() //so our mob-overlays update

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit/dogcatcher
	name = "\improper M5X Dogcatcher Apesuit helmet"
	icon_state = "apesuit_helmet_cage"
	has_visor = FALSE
	actions_types = null
