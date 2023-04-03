//*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/items/items.dmi'
	name = "Coin"
	icon_state = "coin"
	flags_atom = FPRINT|CONDUCT
	force = 0
	throwforce = 0
	w_class = SIZE_TINY
	black_market_value = 10
	var/string_attached
	var/sides = 2

/obj/item/coin/Initialize()
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/coin/gold
	name = "gold coin"
	desc = "A coin of the purest gold."
	icon_state = "coin_gold"
	black_market_value = 30

/obj/item/coin/silver
	name = "silver coin"
	desc = "A coin of the purest silver."
	icon_state = "coin_silver"
	black_market_value = 25

/obj/item/coin/copper
	name = "gold coin"
	desc = "A familiar, but cheap form of currency."
	icon_state = "coin_copper"
	black_market_value = 30

/obj/item/coin/diamond
	name = "diamond coin"
	desc = "A coin of the most flawless diamond."
	icon_state = "coin_diamond"
	black_market_value = 35

/obj/item/coin/iron
	name = "iron coin"
	desc = "You fear this might get rusty."
	icon_state = "coin_iron"
	black_market_value = 15

/obj/item/coin/phoron
	name = "solid phoron coin"
	desc = "There are better uses for phoron."
	icon_state = "coin_phoron"
	black_market_value = 35

/obj/item/coin/uranium
	name = "uranium coin"
	desc = "Don't touch it!"
	icon_state = "coin_uranium"
	black_market_value = 35

/obj/item/coin/platinum
	name = "platinum coin"
	desc = "This is quite valuable."
	icon_state = "coin_platinum"
	black_market_value = 35

/obj/item/coin/marine/synth
	name = "synthetic experimental tool redemption token"
	desc = "Insert this into a synthetic experimental tools vendor in order to access a variety of experimental support tools."
	icon_state = "coin_synth"
	black_market_value = 0

/obj/item/coin/chitin
	name = "chitin coin"
	desc = "Durable chitin pressed into a coin. Why would anyone make this?"
	icon_state = "coin_chitin"
	black_market_value = 35

/obj/item/coin/clown
	name = "clown coin"
	desc = "Smells like bananas. A miniature clown pressed his face lovingly into every one of these. HONK!"
	icon_state = "coin_clown"
	black_market_value = 35

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, SPAN_NOTICE("There already is a string attached to this coin."))
			return
		if (CC.use(1))
			overlays += image('icons/obj/items/items.dmi',"coin_string_overlay")
			string_attached = 1
			to_chat(user, SPAN_NOTICE("You attach a string to the coin."))
		else
			to_chat(user, SPAN_NOTICE("This cable coil appears to be empty."))
		return
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.updateicon()
		overlays = list()
		string_attached = null
		to_chat(user, SPAN_NOTICE(" You detach the string from the coin."))
	else ..()

/obj/item/coin/attack_self(mob/user)
	..()
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(SPAN_NOTICE("[user] has thrown \the [src]. It lands on [comment]! "), \
						SPAN_NOTICE("You throw \the [src]. It lands on [comment]! "))
