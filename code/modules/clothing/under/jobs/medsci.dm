/*
 * Science
 */

/obj/item/clothing/under/rank/rd
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer is a Research Director."
	name = "research director's uniform"
	icon_state = "rdalt_s"
	worn_state = "rdalt_s"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/research.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/research.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/rdalt
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer is a Research Director."
	name = "research director's jumpsuit"
	icon_state = "rdalt"
	icon = 'icons/obj/items/clothing/uniforms/synthetic_uniforms.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/synthetic_uniforms.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon_state = "science"
	item_state = "w_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/research.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/research.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/*
 * Medical
 */
/obj/item/clothing/under/rank/cmo
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon_state = "cmo"
	item_state = "w_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	item_state = "w_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/nursesuit
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon_state = "nursesuit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/nurse
	desc = "A dress commonly worn by the nursing staff in the medical department."
	name = "nurse's dress"
	icon_state = "nurse"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/medical
	desc = "They're made of a special fiber that provides minor protection against biohazards. They have a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's uniform"
	icon_state = "medical"
	item_state = "w_suit"
	icon = 'icons/obj/items/clothing/uniforms/jumpsuits.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/jumpsuits.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	item_state_slots = list(WEAR_BODY = "medical")

/obj/item/clothing/under/rank/medical/lightblue
	name = "nurse's medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Associated with nurses, these are in a calming sky blue."
	icon_state = "scrubslightblue"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubslightblue")

/obj/item/clothing/under/rank/medical/blue
	name = "doctor's medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Doctors without specialties wear these. These remind you of blueberries."
	icon_state = "scrubsblue"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsblue")

/obj/item/clothing/under/rank/medical/green
	name = "surgeon's medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. These are worn by doctors specializing in surgery, represented by jade green."
	icon_state = "scrubsgreen"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsgreen")

/obj/item/clothing/under/rank/medical/purple
	name = "purple medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Fancy doctors like to wear these wine-colored scrubs."
	icon_state = "scrubspurple"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubspurple")

/obj/item/clothing/under/rank/medical/olive
	name = "olive green medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Doctors without specialties wear these to calm and ground patients. These are in olive green."
	icon_state = "scrubsolive"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsolive")

/obj/item/clothing/under/rank/medical/grey
	name = "grey medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Doctors without specialties wear these to calm patients and to keep professional. These are neutral grey."
	icon_state = "scrubsgrey"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsgrey")

/obj/item/clothing/under/rank/medical/brown
	name = "brown medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Doctors without specialties wear these to calm and ground patients. These are a ruddy brown."
	icon_state = "scrubsbrown"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsbrown")

/obj/item/clothing/under/rank/medical/morgue
	name = "morgue medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. They're worn by doctors who are making autopsies. These are black as coal. Morbid."
	icon_state = "scrubsblack"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsblack")

/obj/item/clothing/under/rank/medical/white
	name = "white medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Cherished by all doctors who enjoy cleanliness, these are white as snow."
	icon_state = "scrubswhite"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubswhite")

/obj/item/clothing/under/rank/medical/orange
	name = "brig medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. These are in prisoner orange."
	icon_state = "scrubsorange"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsorange")

/obj/item/clothing/under/rank/medical/pharmacist
	name = "pharmaceutical physician's medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. Doctors with a specialty in pharmaceuticals wear these. These are white with orange shoulder stripes."
	icon_state = "scrubspharm"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubspharm")

/obj/item/clothing/under/rank/medical/cmo
	name = "chief medical officer's medical scrubs"
	desc = "They're made of a special fiber that provides minor protection against biohazards. These are jade green and adorned with peach stripes that denote the wearer is the Chief Medical Officer."
	icon_state = "scrubscmo"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/medical.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/medical.dmi',
	)
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubscmo")
