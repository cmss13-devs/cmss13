//Alphabetical order of civilian jobs.

/obj/item/clothing/under/rank
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/rank/bartender
	desc = "It looks like it could use some more flair."
	name = "bartender's uniform"
	icon_state = "ba_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/cargo
	name = "quartermaster's jumpsuit"
	desc = "It's a jumpsuit worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon_state = "qm"
	item_state = "lb_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/cargo.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/cargo.dmi',
	)
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/cargotech
	name = "cargo technician's jumpsuit"
	desc = "Shooooorts! They're comfy and easy to wear!"
	icon_state = "cargotech"
	item_state = "lb_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/cargo.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/cargo.dmi',
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/under/rank/chaplain
	desc = "It's a black jumpsuit, often worn by religious folk."
	name = "chaplain's jumpsuit"
	icon_state = "chaplain"
	item_state = "chaplain"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
	)
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/chaplain/cultist
	name = "cultist jumpsuit"

/obj/item/clothing/suit/priest_robe
	name = "priest robes"
	desc = "A long dress with a purple scarf, often worn by religious folk."
	icon_state = "priest_robe"
	item_state = "priest_robe"
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
	)

/obj/item/clothing/under/rank/worker_overalls
	name = "worker overalls"
	desc = "An outfit fit for the hard-working man."
	icon_state = "worker_overalls"
	item_state = "bl_suit"
	icon = 'icons/obj/items/clothing/uniforms/workwear.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/workwear.dmi',
	)
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/chef
	desc = "It's an apron which is given only to the most <b>hardcore</b> chefs in space."
	name = "chef's uniform"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	icon_state = "chef"

/obj/item/clothing/under/rank/clown
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	icon_state = "clown"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	flags_jumpsuit = FALSE
	black_market_value = 25

/obj/item/clothing/under/rank/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon_state = "hydroponics"
	item_state = "g_suit"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
	)

/obj/item/clothing/under/rank/janitor
	desc = "It's the official uniform of the station's janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon_state = "janitor"
	icon = 'icons/obj/items/clothing/uniforms/uniforms_by_department/service.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/uniforms_by_department/service.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "Lawyer suit"
	icon = 'icons/obj/items/clothing/uniforms/formal_uniforms.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/formal_uniforms.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)
	flags_jumpsuit = FALSE

/obj/item/clothing/under/lawyer/black
	name = "black Lawyer suit"
	icon_state = "lawyer_black"

/obj/item/clothing/under/lawyer/female
	name = "black Lawyer suit"
	icon_state = "black_suit_fem"

/obj/item/clothing/under/lawyer/red
	name = "red Lawyer suit"
	icon_state = "lawyer_red"

/obj/item/clothing/under/lawyer/blue
	name = "blue Lawyer suit"
	icon_state = "lawyer_blue"

/obj/item/clothing/under/lawyer/bluesuit
	name = "Blue Suit"
	desc = "A classy suit and tie"
	icon_state = "bluesuit"

/obj/item/clothing/under/lawyer/purpsuit
	name = "Purple Suit"
	icon_state = "lawyer_purp"

/obj/item/clothing/under/lawyer/oldman
	name = "Old Man's Suit"
	desc = "A classic suit for the older gentleman with built in back support."
	icon_state = "oldman"

/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	icon = 'icons/obj/items/clothing/uniforms/formal_uniforms.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/formal_uniforms.dmi',
	)
	flags_jumpsuit = FALSE

