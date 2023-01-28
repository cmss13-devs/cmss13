/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	item_state = "hardhat0_yellow"
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	var/hardhat_color = "yellow" //Determines used sprites: hardhat[on]_[hardhat_color]
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

/obj/item/clothing/head/hardhat/attack_self(mob/user)
	..()

	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in [user.loc]") //To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "hardhat[on]_[hardhat_color]"
	item_state = "hardhat[on]_[hardhat_color]"

	if(on) user.SetLuminosity(brightness_on, FALSE, src)
	else user.SetLuminosity(0, FALSE, src)

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/head/hardhat/pickup(mob/user)
	if(on)
		user.SetLuminosity(brightness_on, FALSE, src)
		SetLuminosity(0)
	..()

/obj/item/clothing/head/hardhat/dropped(mob/user)
	if(on)
		user.SetLuminosity(0, FALSE, src)
		SetLuminosity(brightness_on)
	..()

/obj/item/clothing/head/hardhat/Destroy()
	if(ismob(src.loc))
		src.loc.SetLuminosity(0, FALSE, src)
	else
		SetLuminosity(0)
	return ..()


/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	hardhat_color = "orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	hardhat_color = "red"
	name = "firefighter helmet"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
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

