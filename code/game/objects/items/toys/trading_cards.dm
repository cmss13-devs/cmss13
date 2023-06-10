/obj/item/toy/trading_card
	icon = 'icons/obj/items/playing_cards.dmi'
	var/trading_card_number = "1"
	var/picture_description = "Barrel Charger"
	var/collection_colour = "Red"

	name = " [collection_colour] WeyYu Trading Card #[trading_card_number]"

	desc = "The back of a [collection_colour] trading card with the text: WeyYu Trading Cards! GOTTA COLLECT EM ALL!"
	flipped_description = "A [collection_colour] trading card with a picture of a [picture_description] emblazoned on it. It is number [trading_card_number] out of the five [collection_colour] cards."

	icon_state = "trading_[collection_colour]"
	flipped_icon_state = "trading_[collection_colour]_[trading_card_number]"

