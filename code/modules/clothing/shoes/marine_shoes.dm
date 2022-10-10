

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
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature
	siemens_coefficient = 0.7
	var/armor_stage = 0
	items_allowed = list(/obj/item/attachable/bayonet, /obj/item/weapon/melee/throwing_knife, /obj/item/weapon/gun/pistol/holdout, /obj/item/weapon/gun/pistol/m43pistol, /obj/item/tool/screwdriver)

/obj/item/clothing/shoes/marine/update_icon()
	if(stored_item && !armor_stage)
		icon_state = "[initial(icon_state)]-1"
	else
		if(!armor_stage)
			icon_state = initial(icon_state)

/obj/item/clothing/shoes/marine/knife/New()
	..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/marine/jungle
	icon_state = "marine_jungle"
	desc = "Don't go walkin' slow, the devil's on the loose."

/obj/item/clothing/shoes/marine/jungle/knife/New()
	..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/marine/monkey
	name = "monkey combat boots"
	desc = "A sturdy pair of combat boots, the reflection of the polished leather reflects your true self."
	icon_state = "monkey_shoes"
	item_state = "monkey_shoes"

// a monkey knife for a good monkey life
/obj/item/clothing/shoes/marine/monkey/Initialize(mapload, ...)
	. = ..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/marine/upp
	name = "military combat boots"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/shoes/marine/upp/New()
	..()
	stored_item = new /obj/item/attachable/bayonet/upp(src)
	update_icon()

/obj/item/clothing/shoes/marine/upp_knife/New()
	..()
	stored_item = new /obj/item/attachable/bayonet/upp(src)
	update_icon()


/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "Only a small amount of monkeys, kittens, and orphans were killed in making this."
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

/obj/item/clothing/shoes/veteran/PMC
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
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	flags_inventory = FPRINT|NOSLIPPING
	siemens_coefficient = 0.6
	items_allowed = list(/obj/item/attachable/bayonet, /obj/item/weapon/melee/throwing_knife, /obj/item/weapon/gun/pistol/holdout, /obj/item/weapon/gun/pistol/m43pistol)

/obj/item/clothing/shoes/veteran/PMC/update_icon()
	if(stored_item)
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = initial(icon_state)

/obj/item/clothing/shoes/veteran/PMC/knife/New()
	..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/veteran/PMC/commando
	name = "\improper PMC commando boots"
	desc = "A pair of heavily armored, acid-resistant boots."
	permeability_coefficient = 0.01
	armor_bio = CLOTHING_ARMOR_HIGH
	siemens_coefficient = 0.2
	unacidable = TRUE

/obj/item/clothing/shoes/veteran/PMC/commando/knife/New()
	..()
	stored_item = new /obj/item/attachable/bayonet(src)
	update_icon()

/obj/item/clothing/shoes/veteran/PMC/van_bandolier
	name = "hiking boots"
	desc = "Over stone, over ice, through sun and sand, mud and snow, into raging water and hungry bog, these will never let you down."

/obj/item/clothing/shoes/veteran/PMC/van_bandolier/New()
	..()
	var/obj/item/attachable/bayonet/upp/knife = new(src)
	knife.name = "\improper Fairbairn-Sykes fighting knife"
	knife.desc = "This isn't for dressing game or performing camp chores. It's almost certainly not an original. Almost."
	stored_item = knife
	update_icon()

/obj/item/clothing/shoes/marine/ress
	name = "armoured sandals"
	icon_state = "sandals"
	item_state = "sandals"
	items_allowed = null
