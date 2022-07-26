/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	flags_inventory = NOSLIPPING
	
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = NOSLIPPING
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat"
	icon_state = "swat"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = NOSLIPPING
	siemens_coefficient = 0.6

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature

/obj/item/clothing/shoes/space_ninja
	name = "ninja shoes"
	desc = "A pair of running shoes. Excellent for running and even better for smashing skulls."
	icon_state = "s-ninja"
	permeability_coefficient = 0.01
	flags_inventory = NOSLIPPING
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	siemens_coefficient = 0.2

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	flags_armor_protection = 0

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	flags_armor_protection = BODY_FLAG_FEET

/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots"
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	flags_inventory = NOSLIPPING
	slowdown = SHOES_SLOWDOWN+1

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	var/footstep = 1	//used for squeeks whilst walking

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	item_state = "jackboots"
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	item_state = "cult"
	siemens_coefficient = 0.7

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	w_class = SIZE_SMALL

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	w_class = SIZE_SMALL

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	flags_inventory = NOSLIPPING
	slowdown = SHOES_SLOWDOWN+1


/obj/item/clothing/shoes/snow
	name = "snow boots"
	desc = "When you feet are as cold as your heart"
	icon_state = "swat"
	siemens_coefficient = 0.6
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_min_cold_protection_temperature
	max_heat_protection_temperature = SHOE_max_heat_protection_temperature

/obj/item/clothing/shoes/souto
	name = "\improper Souto Man's boots. Harder than the kick of Souto Red."
	desc = "Souto Man boots"
	icon_state = "souto_man"
	item_state = "souto_man"
	flags_inventory = CANTSTRIP|NOSLIPPING
	armor_melee = CLOTHING_ARMOR_HARDCORE
	armor_bullet = CLOTHING_ARMOR_HARDCORE
	armor_laser = CLOTHING_ARMOR_HARDCORE
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_bomb = CLOTHING_ARMOR_HARDCORE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = CANTSTRIP|NOSLIPPING
	unacidable = TRUE
