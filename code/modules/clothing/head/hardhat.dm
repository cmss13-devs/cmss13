/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	item_state = "hardhat0_yellow"
	icon = 'icons/obj/items/clothing/hats/hardhats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hardhats.dmi'
	)
	light_range = 4
	light_power = 2
	var/hardhat_color = "yellow" //Determines used sprites: hardhat[on]_[hardhat_color]
	var/toggleable = TRUE
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	actions_types = list(/datum/action/item_action/toggle)
	siemens_coefficient = 0.9
	flags_inventory = BLOCKSHARPOBJ

	/// Can it be be broken by xenomorphs?
	var/can_be_broken = TRUE
	/// The sound it makes when broken by a xenomorph.
	var/breaking_sound = 'sound/handling/click_2.ogg'

/obj/item/clothing/head/hardhat/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/head/hardhat/update_icon()
	. = ..()
	if(light_on)
		icon_state = "hardhat[light_on]_[hardhat_color]"
		item_state = "hardhat[light_on]_[hardhat_color]"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

/obj/item/clothing/head/hardhat/attack_self(mob/user)
	. = ..()

	if(!toggleable)
		to_chat(user, SPAN_WARNING("You cannot toggle [src] on or off."))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You cannot turn the light [light_on ? "off" : "on"] while in [user.loc].")) //To prevent some lighting anomalies.
		return FALSE

	turn_light(user, !light_on)

/obj/item/clothing/head/hardhat/turn_light(mob/user, toggle_on)

	. = ..()
	if(. != CHECKS_PASSED)
		return

	set_light_on(toggle_on)

	update_icon()

	if(user == loc)
		user.update_inv_head()

	for(var/datum/action/current_action as anything in actions)
		current_action.update_button_icon()

/obj/item/clothing/head/hardhat/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
	if(!can_be_broken)
		return

	if(turn_light(attacking_xeno, toggle_on = FALSE) != CHECKS_PASSED)
		return

	if(!breaking_sound)
		return

	playsound(loc, breaking_sound, 25, 1)

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	hardhat_color = "orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	hardhat_color = "red"
	name = "firefighter helmet"
	gas_transfer_coefficient = 0.01

	flags_inventory = NOPRESSUREDMAGE|BLOCKSHARPOBJ|COVERMOUTH|ALLOWINTERNALS|COVEREYES|BLOCKGASEFFECT|ALLOWREBREATH|ALLOWCPR
	flags_heat_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_cold_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROT
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	hardhat_color = "white"
	flags_inventory = NOPRESSUREDMAGE|BLOCKSHARPOBJ
	flags_heat_protection = BODY_FLAG_HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROT

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat0_dblue"
	hardhat_color = "dblue"

/obj/item/clothing/head/hardhat/red/kelland
	icon_state = "hardhat0_red"
	hardhat_color = "red"
	name = "kelland-mining hard hat"
