

/obj/item/clothing/shoes/marine
	name = "marine combat boots"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "marine"
	item_state = "marine"
	armor_melee = 60
	armor_bullet = 40
	armor_laser = 10
	armor_energy = 10
	armor_bomb = 10
	armor_bio = 30
	armor_rad = 0
	flags_cold_protection = FEET
	flags_heat_protection = FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature
	siemens_coefficient = 0.7
	var/armor_stage = 0
	items_allowed = list( /obj/item/weapon/combat_knife, /obj/item/weapon/throwing_knife, /obj/item/weapon/gun/pistol/holdout)

/obj/item/clothing/shoes/marine/update_icon()
	if(stored_item && !armor_stage)
		icon_state = "marine-1"
	else
		if(!armor_stage)
			icon_state = initial(icon_state)


/obj/item/clothing/shoes/marine/knife/New()
	..()
	stored_item = new /obj/item/weapon/combat_knife(src)
	update_icon()

/obj/item/clothing/shoes/marinechief
	name = "chief officer shoes"
	desc = "Only a small amount of monkeys, kittens, and orphans were killed in making this."
	icon_state = "laceups"
	armor_melee = 50
	armor_bullet = 50
	armor_laser = 25
	armor_energy = 25
	armor_bomb = 20
	armor_bio = 40
	armor_rad = 10
	flags_inventory = NOSLIPPING
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/marinechief/commander
	name = "commanding officer shoes"
	desc = "Has special soles for better trampling those underneath."


/obj/item/clothing/shoes/veteran

/obj/item/clothing/shoes/veteran/PMC
	name = "polished shoes"
	desc = "The height of fashion, but these look to be woven with protective fiber."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor_melee = 60
	armor_bullet = 40
	armor_laser = 10
	armor_energy = 10
	armor_bomb = 10
	armor_bio = 30
	armor_rad = 0
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature
	flags_cold_protection = FEET
	flags_heat_protection = FEET
	flags_inventory = FPRINT|NOSLIPPING
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/veteran/PMC/commando
	name = "\improper PMC commando boots"
	desc = "A pair of heavily armored, acid-resistant boots."
	icon_state = "commando_boots"
	permeability_coefficient = 0.01
	armor_melee = 90
	armor_bullet = 120
	armor_laser = 100
	armor_energy = 90
	armor_bomb = 20
	armor_bio = 50
	armor_rad = 30
	siemens_coefficient = 0.2
	unacidable = 1
