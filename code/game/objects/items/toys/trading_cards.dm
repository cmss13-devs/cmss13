/obj/item/toy/trading_card
	name = "WeyYu Military Trading Card"
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "trading_red"
	w_class = SIZE_TINY

	var/trading_card_number = "1"
	var/picture_description = "barrel charger"
	var/collection_color = "red"
	var/is_front = FALSE
	var/back_name = "Red WeyYu Military Trading Card"
	var/front_name = "Red WeyYu Military Trading Card Number One"
	var/back_description = "The back of a red trading card with the text: WeyYu Military Trading Cards! GOTTA COLLECT EM ALL!"
	var/front_description = "A red trading card with a picture of a barrel charger emblazoned on it. It is number one out of the five red cards."
	var/back_icon_state = "trading_red"
	var/front_icon_state = "trading_red_one"
	var/picture_descriptions = list("5" = list("red" = "red dot sight", "green" = "protein bar", "blue" = "m2c ammo box"),
									"4" = list("red" = "suppressor", "green" = "onigiri", "blue" = "m37 shotgun buckshot"),
									"3" = list("red" = "magnetic harness", "green" = "sushi roll", "blue" = "m4ra magazine"),
									"2" = list("red" = "angled grip", "green" = "chicken ribs", "blue" = "m4a1 magazine"),
									"1" = list("red" = "barrel charger", "green" = "burger", "blue" = "m39 hollowpoint magazine")
									)

/obj/item/toy/trading_card/Initialize()
	. = ..()

	if(istype(src.loc, /obj/item/storage/fancy/trading_card))
		var/obj/item/storage/fancy/trading_card/packet = src.loc
		collection_color = packet.collection_color

	if(!collection_color)
		collection_color = pick("red", "green", "blue")
	trading_card_number = pick_weight(list("5" = 2, "4" = 2, "3" = 2, "2" = 2, "1" = 1))
	picture_description = picture_descriptions[trading_card_number][collection_color]

	name = "[capitalize(collection_color)] WeyYu Military Trading Card"
	back_name = "[capitalize(collection_color)] WeyYu Military Trading Card"
	front_name = "[capitalize(collection_color)] WeyYu Military Trading Card #[trading_card_number]"

	desc = "The back of a [collection_color] trading card with the text: WeyYu Military Trading Cards! GOTTA COLLECT EM ALL!"
	back_description = "The back of a [collection_color] trading card with the text: WeyYu Military Trading Cards! GOTTA COLLECT EM ALL!"
	front_description = "A [collection_color] trading card with a picture of a [picture_description] emblazoned on it. It is #[trading_card_number] out of the five [collection_color] cards."

	icon_state = "trading_[collection_color]"
	back_icon_state = "trading_[collection_color]"
	front_icon_state = "trading_[collection_color]_[trading_card_number]"

/obj/item/toy/trading_card/attack_self(mob/user)
	if(loc == user)
		if(is_front)
			name = back_name
			desc = back_description
			icon_state = back_icon_state
			is_front = FALSE
		else
			to_chat(user, "<span>You reveal the card. It has a picture of a [picture_description] on it!</span>")
			name = front_name
			desc = front_description
			icon_state = front_icon_state
			is_front = TRUE
	. = ..()
