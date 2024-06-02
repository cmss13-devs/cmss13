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
	ground_offset_x = 8
	ground_offset_y = 4

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

//CO coin
/obj/item/coin/silver/falcon
	name = "falling falcons challenge coin"
	desc = "A small coin, bearing the falling falcons insignia."

/obj/item/coin/copper
	name = "copper coin"
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
	desc = "A coin made of sturdy iron. You fear this might become rusty."
	icon_state = "coin_iron"
	black_market_value = 15

/obj/item/coin/phoron
	name = "solid phoron coin"
	desc = "There are better uses for phoron."
	icon_state = "coin_phoron"
	black_market_value = 35

/obj/item/coin/uranium
	name = "uranium coin"
	desc = "A radioactive coin. Don't touch it!"
	icon_state = "coin_uranium"
	black_market_value = 35

/obj/item/coin/platinum
	name = "platinum coin"
	desc = "A coin made of shiny platinum. It is quite valuable."
	icon_state = "coin_platinum"
	black_market_value = 35

/obj/item/coin/chitin
	name = "chitin coin"
	desc = "Durable alien chitin pressed into a coin. There are much better uses for chitin..."
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


/obj/item/coin/marine
	name = "marine equipment token"
	desc = "I wonder what it does?"
	icon_state = "coin_copper"
	black_market_value = 0
	/// What is the token for?
	var/token_type = VEND_TOKEN_VOID

/obj/item/coin/marine/attackby(obj/item/W as obj, mob/user as mob) //To remove attaching a string functionality
	return

/obj/item/coin/marine/engineer
	name = "marine engineer support token"
	desc = "Insert this into an engineer vendor in order to access a support weapon."
	icon_state = "coin_gold"
	token_type = VEND_TOKEN_ENGINEER

/obj/item/coin/marine/specialist
	name = "marine specialist weapon token"
	desc = "Insert this into a USCM equipment vendor in order to access a single highly dangerous weapon."
	icon_state = "coin_diamond"
	token_type = VEND_TOKEN_SPEC

/obj/item/coin/marine/synth
	name = "synthetic experimental tool redemption token"
	desc = "Insert this into a synthetic experimental tools vendor in order to access a variety of experimental support tools."
	icon_state = "coin_synth"
	token_type = VEND_TOKEN_SYNTH
