/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate
	name = "\improper M1 pattern corporate security armor"
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This is commonly worn by low-level guards protecting Weyland-Yutani facilities."
	icon_state = "armor"
	item_state = "armor"
	slowdown = SLOWDOWN_ARMOR_LIGHT

	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST
	item_state_slots = list(WEAR_JACKET = "armor")
	lamp_icon = "lamp"
	lamp_light_color = LIGHT_COLOR_TUNGSTEN
	light_color = LIGHT_COLOR_TUNGSTEN

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/medic
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This variant has a red badge, denoting the medical purpose of the wearer. At least in theory."
	icon_state = "med_armor"
	item_state = "med_armor"
	item_state_slots = list(WEAR_JACKET = "med_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This variant is worn by low-level guards that have elevated in rank due to 'good conduct in the field', also known as corporate bootlicking."
	icon_state = "lead_armor"
	item_state = "lead_armor"
	item_state_slots = list(WEAR_JACKET = "lead_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth/corporate
	name = "\improper M1 pattern corporate synthetic armor"
	desc = "A basic synthetic personnel vest with a Weyland-Yutani badge on the right breast. This is a rare sight, as low-level security units often aren't afforded the luxury of an accompanying synthetic. It has all of the armor inserts removed."
	icon_state = "armor"
	item_state = "armor"
	storage_slots = 2
	item_state_slots = list(WEAR_JACKET = "armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/ppo
	desc = "A basic vest with a Weyland-Yutani badge on the right breast. This variant is worn by Personal Protection Officers protecting Weyland-Yutani employees, as denoted by the blue badge."
	icon_state = "ppo_armor"
	item_state = "ppo_armor"
	item_state_slots = list(WEAR_JACKET = "ppo_armor")
	uniform_restricted = null
	storage_slots = 1

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/ppo/strong
	name = "\improper M4 pattern PPO armor"
	desc = "A modification of the standard Armat Systems M3 armor. This variant is worn by Personal Protection Officers protecting Weyland-Yutani employees, as denoted by the blue detailing. Has some armor plating removed for extra mobility."
	icon_state = "ppo_armor_strong"
	item_state_slots = list(WEAR_JACKET = "ppo_armor_strong")
	storage_slots = 2

	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT

