
//marine gloves

/obj/item/clothing/gloves/marine
	name = "marine combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'."
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0.6

	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_HANDS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	var/adopts_squad_color = TRUE
	/// The dmi where the grayscale squad overlays are contained
	var/squad_overlay_icon = 'icons/mob/humans/onmob/clothing/hands_garb.dmi'

/obj/item/clothing/gloves/marine/get_mob_overlay(mob/living/carbon/human/current_human, slot, default_bodytype = "Default")
	var/image/ret = ..()
	if(!adopts_squad_color || !(current_human?.assigned_squad?.equipment_color))
		return ret
	var/image/glove_overlay = image(squad_overlay_icon, icon_state = "std-gloves")
	glove_overlay.alpha = current_human.assigned_squad.armor_alpha
	glove_overlay.color = current_human.assigned_squad.equipment_color
	ret.overlays += glove_overlay
	return ret

/obj/item/clothing/gloves/marine/insulated
	name = "marine insulated gloves"
	desc = "These gloves will protect the wearer from electric shock."
	icon_state = "insulated"
	item_state = "insulated"
	siemens_coefficient = 0

/obj/item/clothing/gloves/marine/insulated/black
	name = "marine insulated black gloves"
	desc = "These marine gloves will protect the wearer from electric shocks and shrapnal. Standard issue for properly-equipped Marines."
	icon_state = "yellow"
	item_state = "black"
	item_state_slots = list(WEAR_HANDS = "black")
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/black
	name = "marine black combat gloves"
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/brown
	name = "marine brown combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'. These are brown instead of the classic black."
	icon_state = "brown"
	item_state = "brown"
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/grey
	name = "marine grey combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'. These are a shade of grey instead of the classic black."
	icon_state = "marine_grey"
	item_state = "marine_grey"
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/medical
	name = "marine medical combat gloves"
	desc = "Standard issue marine sterile gloves, offers regular protection whilst offering the user a better grip when performing medical work."
	icon_state = "latex"
	item_state = "latex"
	adopts_squad_color = FALSE


/obj/item/clothing/gloves/marine/officer
	name = "officer gloves"
	desc = "Shiny and impressive. They look expensive."
	icon_state = "black"
	item_state = "bgloves"
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/officer/chief
	name = "chief officer gloves"
	desc = "Blood crusts are attached to its metal studs, which are slightly dented."

/obj/item/clothing/gloves/marine/techofficer
	name = "tech officer gloves"
	desc = "Sterile AND insulated! Why is not everyone issued with these?"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0

	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/techofficer/fancy
	name = "deluxe combat gloves"
	desc = "Combat gloves finished in an almost golden-looking fabric. Insulated, fashionable, and capable of protecting the soft hands it's likely wrapped around."
	icon_state = "captain"
	item_state = "captain"

/obj/item/clothing/gloves/marine/specialist
	name = "\improper B18 defensive gauntlets"
	desc = "A pair of heavily armored gloves."
	icon_state = "black"
	item_state = "bgloves"
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/M3G
	name = "\improper M3-G4 Grenadier gloves"
	desc = "A pair of plated, but nimble, gloves."
	icon_state = "grenadier"
	item_state = "grenadier"
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGH
	unacidable = TRUE
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/veteran
	name = "armored gloves"
	desc = "Non-standard kevlon fiber gloves. They're insulated and heavily armored."
	icon_state = "veteran"
	item_state = "veteran"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/veteran/upp
	icon_state = "brown"
	item_state = "brown"

/obj/item/clothing/gloves/marine/veteran/insulated
	name = "insulated armored gloves"
	desc = "Non-standard kevlon fiber gloves. These are apparently ESPECIALLY insulated."
	icon_state = "insulated"
	item_state = "insulated"

/obj/item/clothing/gloves/marine/veteran/pmc
	name = "\improper WY PMC gloves"
	desc = "Standard issue kevlon fiber gloves manufactured for and by Weyland-Yutani PMC dispatch division. They are insulated against electrical shock."
	icon_state = "pmc"
	item_state = "pmc"

/obj/item/clothing/gloves/marine/veteran/pmc/commando
	name = "\improper W-Y Commando gloves"
	desc = "Standard issue kevlon fiber gloves manufactured for and by Weyland-Yutani Commandos. They are insulated against electrical shock."
	icon_state = "pmc_elite"
	item_state = "pmc_elite"
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/gloves/marine/veteran/pmc/commando/leader
	icon_state = "pmc_elite_leader"
	item_state = "pmc_elite_leader"

/obj/item/clothing/gloves/marine/veteran/pmc/apesuit
	name = "\improper M5X gauntlets"
	desc = "A pair of heavily armored gloves made to pair up the M5X Apesuit system."
	icon_state = "gauntlets"
	item_state = "bgloves"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_VERYHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/veteran/pmc/combat_droid
	name = "\improper M7X gauntlets"
	desc = "A pair of heavily armored gloves made to pair up the M7X Apesuit system."
	icon_state = "combat_android_gloves"
	item_state = "bgloves"
	item_state_slots = list(WEAR_HANDS = "marine_grey")
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/dress
	name = "dress gloves"
	desc = "A pair of fashionable white gloves, worn by marines in dress."
	icon_state = "marine_white"
	item_state = "marine_white"
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/veteran/souto
	name = "\improper Souto Man gloves"
	desc = "The gloves worn by Souto Man. A grip stronger than the taste of Souto Cherry!"
	icon_state = "souto_man"
	item_state = "souto_man"
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
	adopts_squad_color = FALSE

/obj/item/clothing/gloves/marine/veteran/insulated/van_bandolier
	name = "custom shooting gloves"
	desc = "Highly protective against injury, temperature, and electric shock. Cool in the summer, warm in the winter, and a secure grip on any surface. You could buy a lot for the price of these, and they're worth every penny."

/obj/item/clothing/gloves/marine/joe
	name = "Seegson hazardous gloves"
	desc = "Special Synthetic gloves made for touching and interacting with extremely hazardous materials. Resistant to biohazard liquids, corrosive materials and more. SEEGSON is proudly displayed on the back, along with a biohazard symbol. Tomorrow, Together."
	icon_state = "working_joe"
	item_state = "working_joe"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	unacidable = TRUE
	adopts_squad_color = FALSE

//=ROYAL MARINES=\\

/obj/item/clothing/gloves/marine/veteran/royal_marine
	name = "\improper L6 pattern combat gloves"
	desc = "Standard issue tactical gloves used by the royal marines."
	icon_state = "rmc_gloves"
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN

/obj/item/clothing/gloves/marine/veteran/royal_marine/medical
	name = "\improper L6 pattern combat medic gloves"
	desc = "Standard issue tactical gloves used by the royal marines combat medics. Sterile and still efficient for combat use."
	icon_state = "latex"
	item_state = "latex"
	adopts_squad_color = FALSE
	armor_bio = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/gloves/marine/veteran/cbrn
	name = "\improper M3 MOPP gloves"
	desc = "M3 MOPP gloves are made of treated venlar designed to protect the user’s hands against contamination whilst working in CBRN environments. Special care has been taken to give the user’s hands enough dexterity to fully service a rifle or utilize most handheld tools, while circular adhesive patterns on the fingers provide the user with enhanced grips. Standard CBRN protocol dictates that the gloves are expected to have a lifespan of maximum effectiveness of around twenty-four hours once exposed to moderate levels of contamination and that users are recommended to discard and replace them afterwards."
	icon_state = "cbrn"
	item_state = "cbrn"
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS

/obj/item/clothing/gloves/marine/cbrn_non_armored
	name = "\improper M2 MOPP gloves"
	desc = "These older-generation M2 MOPP gloves are constructed from treated venlar and offer basic protection against contamination in CBRN environments. While they provide decent dexterity for operating small tools and weapons, they lack the advanced grip enhancements and durability of the newer models. Typically, these gloves remain effective for up to 12 hours of moderate exposure before they must be replaced."
	icon_state = "cbrn"
	item_state = "cbrn"
