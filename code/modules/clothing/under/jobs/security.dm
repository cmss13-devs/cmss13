/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden"
	item_state = "r_suit"
	armor_melee = 10
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "security"
	item_state = "r_suit"
	armor_melee = 10
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	armor_melee = 10
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	flags_armor_protection = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt2"
	item_state = "r_suit"
	armor_melee = 10
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	siemens_coefficient = 0.9
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	rollable_sleeves = FALSE

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	armor_melee = 10
	armor_bullet = 5
	armor_laser = 5
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	siemens_coefficient = 0.9

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "hard-worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	armor_melee = 10
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	siemens_coefficient = 0.9

/obj/item/clothing/under/det/black
	icon_state = "detective2"

/obj/item/clothing/under/det/slob
	icon_state = "polsuit"
	rollable_sleeves = TRUE


/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hosred"
	item_state = "r_suit"
	armor_melee = 10
	armor_bullet = 0
	armor_laser = 0
	armor_energy = 0
	armor_bomb = 0
	armor_bio = 0
	armor_rad = 0
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corporate"
	rollable_sleeves = FALSE

//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	item_state = "jensen"
	siemens_coefficient = 0.6
	rollable_sleeves = FALSE

/*
 * Navy uniforms
 */

/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes"
	item_state = "officerblueclothes"
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hosblueclothes"
	item_state = "hosblueclothes"
	rollable_sleeves = FALSE

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "wardenblueclothes"
	item_state = "wardenblueclothes"
	rollable_sleeves = FALSE
