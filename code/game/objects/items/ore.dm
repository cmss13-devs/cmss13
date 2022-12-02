/obj/item/ore
	name = "rock"
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "ore2"
	black_market_value = BLACK_MARKET_VALUE_CRAP
	var/oretag

/obj/item/ore/uranium
	name = "pitchblende"
	icon_state = "Uranium ore"

	oretag = "uranium"
	black_market_value = BLACK_MARKET_VALUE_EXCELLENT

/obj/item/ore/iron
	name = "hematite"
	icon_state = "Iron ore"

	oretag = "hematite"
	black_market_value = BLACK_MARKET_VALUE_GOOD

/obj/item/ore/coal
	name = "carbonaceous rock"
	icon_state = "Coal ore"

	oretag = "coal"
	black_market_value = BLACK_MARKET_VALUE_MEH

/obj/item/ore/glass
	name = "impure silicates"
	icon_state = "Glass ore"

	oretag = "sand"
	black_market_value = BLACK_MARKET_VALUE_MEH

/obj/item/ore/phoron
	name = "phoron crystals"
	icon_state = "Phoron ore"

	oretag = "phoron"
	black_market_value = BLACK_MARKET_VALUE_GOOD

/obj/item/ore/silver
	name = "native silver ore"
	icon_state = "Silver ore"

	oretag = "silver"
	black_market_value = BLACK_MARKET_VALUE_GOOD

/obj/item/ore/gold
	name = "native gold ore"
	icon_state = "Gold ore"

	oretag = "gold"
	black_market_value = BLACK_MARKET_VALUE_GREAT

/obj/item/ore/diamond
	name = "diamonds"
	icon_state = "Diamond ore"

	oretag = "diamond"
	black_market_value = BLACK_MARKET_VALUE_GREAT

/obj/item/ore/osmium
	name = "raw platinum"
	icon_state = "Platinum ore"
	oretag = "platinum"
	black_market_value = BLACK_MARKET_VALUE_GREAT

/obj/item/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "Phazon"
	oretag = "hydrogen"
	black_market_value = BLACK_MARKET_VALUE_AVERAGE

/obj/item/ore/slag
	name = "Slag"
	desc = "Completely useless"
	icon_state = "slag"
	oretag = "slag"
	black_market_value = BLACK_MARKET_VALUE_DEFAULT

/obj/item/ore/Initialize()
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8
