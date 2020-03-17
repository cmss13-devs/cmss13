


//marine gloves

/obj/item/clothing/gloves/marine
	name = "marine combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'."
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature
	flags_armor_protection = BODY_FLAG_HANDS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/gloves/marine/insulated
	name = "marine insulated gloves"
	desc = "These gloves will protect the wearer from electric shock."
	icon_state = "lightbrown"
	item_state = "lightbrowngloves"
	siemens_coefficient = 0

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
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/M3G
	name = "\improper M3-G4 Grenadier gloves"
	desc = "A pair of plated, but nimble, gloves."
	icon_state = "black"
	item_state = "bgloves"
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGH
	unacidable = TRUE
	flags_item = MOB_LOCK_ON_EQUIP

/obj/item/clothing/gloves/marine/veteran/PMC
	name = "armored gloves"
	desc = "Armored gloves used in special operations. They are also insulated against electrical shock."
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/gloves/marine/veteran/PMC/commando
	name = "\improper M5X gauntlets"
	desc = "A pair of heavily armored gloves made to complete the M5X exoskeleton armor"
	icon_state = "gauntlets"
	item_state = "bgloves"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/dress
	name = "dress gloves"
	desc = "A pair of fashionable white gloves, worn by marines in dress."
	icon_state = "latex"
	item_state = "lgloves"

/obj/item/clothing/gloves/marine/veteran/souto
	name = "\improper Souto Man gloves"
	desc = "The gloves worn by Souto Man. White as sugar."
	icon_state = "souto_man"
	item_state = "souto_man"
	flags_item = NODROP|DELONDROP
	flags_inventory = CANTSTRIP
	armor_melee = CLOTHING_ARMOR_HARDCORE
	armor_bullet = CLOTHING_ARMOR_HARDCORE
	armor_laser = CLOTHING_ARMOR_HARDCORE
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_bomb = CLOTHING_ARMOR_HARDCORE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	unacidable = TRUE