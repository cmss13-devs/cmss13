

/obj/item/clothing/shoes/marine
	name = "marine combat boots"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "marine"
	item_state = "marine"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	siemens_coefficient = 0.7
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/action,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/tool/screwdriver,
		/obj/item/tool/surgery/scalpel,
		/obj/item/weapon/straight_razor,
	)
	drop_sound = "armorequip"

/obj/item/clothing/shoes/marine/update_icon()
	if(stored_item)
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = initial(icon_state)

/obj/item/clothing/shoes/marine/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/jungle
	icon_state = "marine_jungle"
	desc = "Don't go walkin' slow, the devil's on the loose."

/obj/item/clothing/shoes/marine/jungle/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/brown
	icon_state = "marine_brown"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time. These are brown."

/obj/item/clothing/shoes/marine/brown/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/grey
	icon_state = "marine_grey"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time. These are grey."

/obj/item/clothing/shoes/marine/grey/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/urban
	icon_state = "marine_grey_alt"
	desc = "Don't go walkin' slow, the devil's on the loose."

/obj/item/clothing/shoes/marine/urban/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/monkey
	name = "monkey combat boots"
	desc = "A sturdy pair of combat boots, the reflection of the polished leather reflects your true self."
	icon_state = "monkey_shoes"
	item_state = "monkey_shoes"
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/upp
	name = "military combat boots"
	icon_state = "marine_brown"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/shoes/marine/upp/knife
	spawn_item_type = /obj/item/attachable/bayonet/upp

/obj/item/clothing/shoes/marine/upp/black
	icon_state = "marine"
	item_state = "marine"

/obj/item/clothing/shoes/marine/upp/black/knife
	spawn_item_type = /obj/item/attachable/bayonet/upp

/obj/item/clothing/shoes/marine/joe
	name = "biohazard boots"
	desc = "A pair of somewhat cheaply made biohazard boots. Tomorrow, Together."
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "Pre-polished fancy dress shoes. You can see your reflection in them."
	icon_state = "laceups"
	flags_inventory = NOSLIPPING
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/dress/commander
	name = "commanding officer dress shoes"
	desc = "Has special soles for better trampling those underneath."
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/shoes/stompers
	name = "Reebok Stompers"
	desc = "A pair of sneakers designed to elicit a morale boosting response within anyone that witnesses them."
	icon_state = "stompers"
	flags_inventory = NOSLIPPING

/obj/item/clothing/shoes/veteran/pmc
	name = "polished shoes"
	desc = "The height of fashion, but these look to be woven with protective fiber."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	flags_inventory = FPRINT|NOSLIPPING
	siemens_coefficient = 0.6
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/action,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/weapon/straight_razor,
	)

/obj/item/clothing/shoes/veteran/pmc/update_icon()
	if(stored_item)
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = initial(icon_state)

/obj/item/clothing/shoes/veteran/pmc/knife
	spawn_item_type = /obj/item/attachable/bayonet/wy

/obj/item/clothing/shoes/veteran/pmc/commando
	name = "\improper W-Y commando boots"
	desc = "A pair of heavily armored, acid-resistant boots."

	armor_bio = CLOTHING_ARMOR_HIGH
	siemens_coefficient = 0.2
	unacidable = TRUE

/obj/item/clothing/shoes/veteran/pmc/commando/knife
	spawn_item_type = /obj/item/attachable/bayonet/wy

/obj/item/clothing/shoes/veteran/pmc/combat_android
	name = "\improper M7X greaves"
	desc = "A pair of heavily armored, acid-resistant boots, made to complete the M7X Apesuit."
	icon_state = "droid_boots"
	item_state = "droid_boots"
	armor_bio = CLOTHING_ARMOR_HIGH
	siemens_coefficient = 0.2
	unacidable = TRUE
	spawn_item_type = /obj/item/attachable/bayonet/wy

/obj/item/clothing/shoes/veteran/pmc/combat_android/dark
	name = "\improper M7X Mark II greaves"
	desc = "A pair of heavily armored, optical camouflaged, acid-resistant boots, made to complete the M7X Mark II Apesuit."
	icon_state = "invis_droid_boots"
	item_state = "invis_droid_boots"

/obj/item/clothing/shoes/veteran/pmc/van_bandolier
	name = "hiking boots"
	desc = "Over stone, over ice, through sun and sand, mud and snow, into raging water and hungry bog, these will never let you down."
	spawn_item_type = /obj/item/attachable/bayonet/van_bandolier

/obj/item/clothing/shoes/veteran/pmc/commando/cbrn
	name = "\improper M3 MOPP boots"
	desc = "M3 MOPP boots have been designed to protect the wearer from contact with any possible infection vectors or hazardous substances that may have contaminated the area of operations. This includes further enhancements in conjunction with the standard durability of M3 boots, reducing the probability of punctures or cuts as well as the effects of radiation."
	icon_state = "cbrn"
	item_state = "cbrn"
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/cbrn_non_armored
	name = "\improper M2 MOPP boots"
	desc = "M2 MOPP boots are designed to shield the wearer from contact with hazardous substances and potential infection vectors in contaminated environments. These older boots offer basic resistance to punctures and environmental threats, but lack the advanced durability and radiation shielding of later models. Users should inspect these boots regularly for signs of wear or damage."
	icon_state = "cbrn"
	item_state = "cbrn"
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/corporate
	name = "rugged boots"
	desc = "These synth-leather boots seem high quality when first worn, but quickly detoriate, especially in the environments the corporate security members these are issued to operate in. Still, better than nothing."

/obj/item/clothing/shoes/marine/corporate/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/cmb
	name = "rugged boots"
	desc = "Generic boots typically used by law enforcement types out on the frontier. Functional and stylish."

/obj/item/clothing/shoes/marine/cmb/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/ress
	name = "armored sandals"
	icon_state = "sandals"
	item_state = "sandals"
	allowed_items_typecache = null

/obj/item/clothing/shoes/hiking
	name = "hiking shoes"
	desc = "These rugged shoes are caked with mud and dirt. Designed for high-altitude hiking expeditions, they're sure to be helpful in any climate or environment."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	flags_inventory = FPRINT|NOSLIPPING
	siemens_coefficient = 0.6
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/action,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/weapon/straight_razor,
	)
	var/weed_slowdown_mult = 0.5

/obj/item/clothing/shoes/hiking/equipped(mob/user, slot, silent)
	. = ..()
	var/mob/living/carbon/human/human_user = user
	if(src != human_user.shoes)
		return
	RegisterSignal(user, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))

/obj/item/clothing/shoes/hiking/unequipped(mob/user, slot, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))

/obj/item/clothing/shoes/hiking/proc/handle_weed_slowdown(mob/user, list/slowdata)
	SIGNAL_HANDLER
	slowdata["movement_slowdown"] *= weed_slowdown_mult

//=ROYAL MARINES=\\

/obj/item/clothing/shoes/marine/royal_marine
	name = "\improper L10 pattern combat boots"
	desc = "Standard issue combat boots for combat scenarios or combat situations. Used by the three world empires royal marines commando units."
	icon_state = "rmc_boots"
	item_state = "rmc_boots"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	flags_inventory = FPRINT|NOSLIPPING
	siemens_coefficient = 0.6
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/action,
		/obj/item/weapon/gun/pistol/clfpistol,
	)
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/shoes/marine/royal_marine/knife
	spawn_item_type = /obj/item/attachable/bayonet/rmc

/obj/item/clothing/shoes/dress/rmc
	name = "\improper RMC dress shoes"
	desc = "Polished fancy dress shoes. You can see your reflection in them."
	icon_state = "rmc_laceups"
