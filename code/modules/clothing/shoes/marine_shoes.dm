

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
	var/armor_stage = 0
	items_allowed = list(/obj/item/attachable/bayonet, /obj/item/weapon/melee/throwing_knife, /obj/item/weapon/gun/pistol/holdout, /obj/item/weapon/gun/pistol/m43pistol, /obj/item/tool/screwdriver)
	var/knife_type

/obj/item/clothing/shoes/marine/Initialize(mapload, ...)
	. = ..()
	if(knife_type)
		stored_item = new knife_type(src)
	update_icon()

/obj/item/clothing/shoes/marine/update_icon()
	if(stored_item && !armor_stage)
		icon_state = "[initial(icon_state)]-1"
	else
		if(!armor_stage)
			icon_state = initial(icon_state)

/obj/item/clothing/shoes/marine/knife
	knife_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/jungle
	icon_state = "marine_jungle"
	desc = "Don't go walkin' slow, the devil's on the loose."

/obj/item/clothing/shoes/marine/jungle/knife
	knife_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/monkey
	name = "monkey combat boots"
	desc = "A sturdy pair of combat boots, the reflection of the polished leather reflects your true self."
	icon_state = "monkey_shoes"
	item_state = "monkey_shoes"
	knife_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/upp
	name = "military combat boots"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	knife_type = /obj/item/attachable/bayonet/upp

/obj/item/clothing/shoes/marine/upp_knife
	knife_type = /obj/item/attachable/bayonet/upp

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
	items_allowed = list(/obj/item/attachable/bayonet, /obj/item/weapon/melee/throwing_knife, /obj/item/weapon/gun/pistol/holdout, /obj/item/weapon/gun/pistol/m43pistol)

/obj/item/clothing/shoes/veteran/pmc/update_icon()
	if(stored_item)
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = initial(icon_state)

/obj/item/clothing/shoes/veteran/pmc/knife/Initialize(mapload, ...)
	. = ..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/veteran/pmc/commando
	name = "\improper PMC commando boots"
	desc = "A pair of heavily armored, acid-resistant boots."
	permeability_coefficient = 0.01
	armor_bio = CLOTHING_ARMOR_HIGH
	siemens_coefficient = 0.2
	unacidable = TRUE

/obj/item/clothing/shoes/veteran/pmc/commando/knife/Initialize(mapload, ...)
	. = ..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/veteran/pmc/van_bandolier
	name = "hiking boots"
	desc = "Over stone, over ice, through sun and sand, mud and snow, into raging water and hungry bog, these will never let you down."

/obj/item/clothing/shoes/veteran/pmc/van_bandolier/New()
	..()
	var/obj/item/attachable/bayonet/upp/knife = new(src)
	knife.name = "\improper Fairbairn-Sykes fighting knife"
	knife.desc = "This isn't for dressing game or performing camp chores. It's almost certainly not an original. Almost."
	stored_item = knife
	update_icon()

/obj/item/clothing/shoes/marine/corporate
	name = "rugged boots"
	desc = "These synth-leather boots seem high quality when first worn, but quickly detoriate, especially in the environments the corporate security members these are issued to operate in. Still, better than nothing."
	knife_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/ress
	name = "armoured sandals"
	icon_state = "sandals"
	item_state = "sandals"
	items_allowed = null

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
	items_allowed = list(/obj/item/attachable/bayonet, /obj/item/weapon/melee/throwing_knife, /obj/item/weapon/gun/pistol/holdout, /obj/item/weapon/gun/pistol/m43pistol)
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
