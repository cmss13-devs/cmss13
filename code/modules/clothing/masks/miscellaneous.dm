/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	flags_inventory = COVERMOUTH
	flags_armor_protection = 0
	w_class = SIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = SIZE_SMALL
	flags_inventory = COVERMOUTH
	flags_armor_protection = 0
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.3
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv_hide = HIDEFACE
	flags_armor_protection = 0

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv_hide = HIDEFACE
	flags_armor_protection = 0

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEFACE|HIDEALLHAIR|HIDEEYES|HIDEEARS
	w_class = SIZE_SMALL
	siemens_coefficient = 0.9
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "A basic single eye-hole balaclava, available in almost every sporting goods, outdoor supply, or military surplus store in existence, protects your face from the cold almost as well as it conceals it. This one is in a standard black color."
	icon_state = "balaclava"
	item_state = "balaclava"
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEFACE|HIDEALLHAIR|HIDEEARS
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	w_class = SIZE_SMALL

/obj/item/clothing/mask/balaclava/tactical
	name = "green balaclava"
	desc = "A basic single eye-hole balaclava, available in almost every sporting goods, outdoor supply, or military surplus store in existence, protects your face from the cold almost as well as it conceals it. This one is in a non-standard green color."
	icon_state = "swatclava"
	item_state = "swatclava"

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags_inv_hide = HIDEFACE|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE
	w_class = SIZE_SMALL
	siemens_coefficient = 3

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchar"
	item_state = "luchar"
