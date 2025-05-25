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
