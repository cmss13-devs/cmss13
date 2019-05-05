


//marine gloves

/obj/item/clothing/gloves/marine
	name = "marine combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'."
	icon_state = "gray"
	item_state = "graygloves"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05
	flags_cold_protection = HANDS
	flags_heat_protection = HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature
	flags_armor_protection = HANDS
	armor_melee = 60
	armor_bullet = 20
	armor_laser = 10
	armor_energy = 10
	armor_bomb = 10
	armor_bio = 25
	armor_rad = 0

/obj/item/clothing/gloves/marine/alpha
	name = "alpha squad gloves"
	icon_state = "red"
	item_state = "redgloves"

/obj/item/clothing/gloves/marine/alpha/insulated
	name = "insulated alpha squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0

/obj/item/clothing/gloves/marine/bravo
	name = "bravo squad gloves"
	icon_state = "yellow"
	item_state = "ygloves"

/obj/item/clothing/gloves/marine/bravo/insulated
	name = "insulated bravo squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0

/obj/item/clothing/gloves/marine/charlie
	name = "charlie squad gloves"
	icon_state = "purple"
	item_state = "purplegloves"

/obj/item/clothing/gloves/marine/charlie/insulated
	name = "insulated charlie squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0

/obj/item/clothing/gloves/marine/delta
	name = "delta squad gloves"
	icon_state = "blue"
	item_state = "bluegloves"

/obj/item/clothing/gloves/marine/delta/insulated
	name = "insulated delta squad gloves"
	desc = "Insulated marine tactical gloves that protects against electrical shocks."
	siemens_coefficient = 0

/obj/item/clothing/gloves/marine/officer
	name = "officer gloves"
	desc = "Shiny and impressive. They look expensive."
	icon_state = "black"
	item_state = "bgloves"

/obj/item/clothing/gloves/marine/officer/chief
	name = "chief officer gloves"
	desc = "Blood crusts are attached to its metal studs, which are slightly dented."

/obj/item/clothing/gloves/marine/techofficer
	name = "tech officer gloves"
	desc = "Sterile AND insulated! Why is not everyone issued with these?"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.01

/obj/item/clothing/gloves/marine/techofficer/commander
	name = "commanding officer's gloves"
	desc = "You may like these gloves, but THEY think you are unworthy of them."
	icon_state = "captain"
	item_state = "egloves"

/obj/item/clothing/gloves/marine/specialist
	name = "\improper B18 defensive gauntlets"
	desc = "A pair of heavily armored gloves."
	icon_state = "black"
	item_state = "bgloves"
	armor_melee = 90
	armor_bullet = 60
	armor_laser = 75
	armor_energy = 60
	armor_bomb = 40
	armor_bio = 35
	armor_rad = 15
	unacidable = 1

/obj/item/clothing/gloves/marine/M3G
	name = "\improper M3-G4 Grenadier gloves"
	desc = "A pair of plated, but nimble, gloves."
	icon_state = "black"
	item_state = "bgloves"
	armor_melee = 90
	armor_bullet = 60
	armor_laser = 75
	armor_energy = 60
	armor_bomb = 40
	armor_bio = 35
	armor_rad = 15
	unacidable = 1

/obj/item/clothing/gloves/marine/veteran/PMC
	name = "armored gloves"
	desc = "Armored gloves used in special operations. They are also insulated against electrical shock."
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0
	armor_melee = 60
	armor_bullet = 40
	armor_laser = 35
	armor_energy = 20
	armor_bomb = 10
	armor_bio = 25
	armor_rad = 0

/obj/item/clothing/gloves/marine/veteran/PMC/commando
	name = "\improper PMC commando gloves"
	desc = "A pair of heavily armored, insulated, acid-resistant gloves."
	icon_state = "brown"
	item_state = "browngloves"
	armor_melee = 90
	armor_bullet = 80
	armor_laser = 100
	armor_energy = 90
	armor_bomb = 20
	armor_bio = 30
	armor_rad = 30
	unacidable = 1