/datum/playing_card
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"
	var/sort_index = 0

/datum/playing_card/New(set_name, set_card_icon, set_back_icon, set_sort_index)
	..()
	if(set_name)
		name = set_name
	if(set_card_icon)
		card_icon = set_card_icon
	if(set_back_icon)
		back_icon = set_back_icon
	if(set_sort_index)
		sort_index = set_sort_index

/obj/item/toy/deck
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "deck"
	w_class = SIZE_TINY

	var/base_icon = "deck"
	var/max_cards = 52
	var/list/datum/playing_card/cards = list()

/obj/item/toy/deck/Initialize()
	. = ..()
	populate_deck()

/obj/item/toy/deck/Destroy(force)
	. = ..()
	QDEL_NULL_LIST(cards)

/obj/item/toy/deck/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("There are <b>[length(cards)]</b> cards remaining in the deck.")

/obj/item/toy/deck/proc/populate_deck()
	var/card_id = 1
	for(var/suit in list("spades", "clubs", "diamonds", "hearts"))
		for(var/number in list("ace", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king"))
			cards += new /datum/playing_card("[number] of [suit]", "[suit]_[number]", "back_[base_icon]", card_id++)

/obj/item/toy/deck/uno
	name = "deck of UNO cards"
	desc = "A simple deck of the Weyland-Yutani classic UNO playing cards."
	icon_state = "deck_uno"
	base_icon = "deck_uno"
	max_cards = 108

/obj/item/toy/deck/uno/populate_deck()
	var/card_id = 1
	//wild cards
	for(var/suit in list("wild", "wild-draw-four"))
		for(var/i = 1 to 4)
			cards += new /datum/playing_card("[suit]", "[suit]", "back_[base_icon]", card_id++)

	//color cards
	for(var/suit in list("red", "purple", "blue", "yellow"))
		//1 zero per color
		cards += new /datum/playing_card("[suit] zero", "[suit]_zero", "back_[base_icon]", card_id++)

		//2 of each 1-9, skip, draw 2, reverse per color
		for(var/i = 1 to 2)
			for(var/number in list("one","two","three","four","five","six","seven","eight","nine","skip","draw-two","reverse"))
				cards += new /datum/playing_card("[suit] [number]", "[suit]_[number]", "back_[base_icon]", card_id++)

/obj/item/toy/deck/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		handle_draw_cards(user)
		return
	return ..()

/obj/item/toy/deck/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/toy/handcard))
		var/obj/item/toy/handcard/H = O
		for(var/datum/playing_card/P as anything in H.cards)
			cards += P
			H.cards -= P
		update_icon()
		qdel(O)
		user.visible_message(SPAN_NOTICE("<b>[user]</b> places their cards on the bottom of \the [src]."), SPAN_NOTICE("You place your cards on the bottom of the deck."))
		return
	..()

/obj/item/toy/deck/update_icon()
	var/cards_length = length(cards)
	if(cards_length == max_cards) icon_state = base_icon
	else if(!cards_length) icon_state = "[base_icon]_empty"
	else icon_state = "[base_icon]_open"

/obj/item/toy/deck/verb/draw_card()
	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr))
		return

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in the deck."))
		return

	var/obj/item/toy/handcard/H = get_or_make_user_hand(user)
	var/datum/playing_card/P = cards[1]
	H.cards += P
	cards -= P
	H.update_icon()
	update_icon()
	user.visible_message(SPAN_NOTICE("\The [user] draws a card."), SPAN_NOTICE("You draw the <b>[P]</b>."))

/obj/item/toy/deck/verb/draw_cards()
	set category = "Object"
	set name = "Draw X Cards"
	set desc = "Draw amount cards from a deck."
	set src in view(1)

	handle_draw_cards(usr)

/obj/item/toy/deck/proc/handle_draw_cards(mob/mob)
	if(mob.stat || !ishuman(mob) || !Adjacent(mob))
		return

	var/mob/living/carbon/human/user = usr

	var/cards_length = length(cards)
	if(!cards_length)
		to_chat(user, SPAN_WARNING("There are no cards in the deck."))
		return

	var/num_cards = tgui_input_number(user, "How many cards do you want to draw? ([cards_length] remaining)", "Card Drawing", 1, cards_length, 1)
	cards_length = length(cards)
	if(!cards_length)
		to_chat(user, SPAN_WARNING("There are no cards in the deck."))
		return
	if(!num_cards || num_cards <= 0)
		return
	num_cards = min(num_cards, cards_length)

	if(num_cards==1)
		user.visible_message(SPAN_NOTICE("\The [user] draws a card."), SPAN_NOTICE("You draw a card."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] draws [num_cards] cards."), SPAN_NOTICE("You draw [num_cards] cards."))

	var/obj/item/toy/handcard/H = get_or_make_user_hand(user)

	var/chat_message = ""
	for(var/i = 1 to num_cards)
		var/datum/playing_card/P = cards[1]
		H.cards += P
		cards -= P
		num_cards--
		chat_message += "[P]; "

	H.update_icon()
	update_icon()

	to_chat(user, SPAN_NOTICE("You've drawn: [chat_message]"))

/obj/item/toy/deck/verb/draw_pile()
	set name = "Draw Pile (Concealed)"
	set desc = "Draw a concealed pile from the deck."
	set category = "Object"
	set src in view(1)

	if(usr.stat || !ishuman(usr) || !Adjacent(usr))
		return

	var/mob/living/carbon/human/user = usr

	var/cards_length = length(cards)
	if(!cards_length)
		to_chat(user, SPAN_WARNING("There are no cards in the deck."))
		return

	var/obj/item/toy/handcard/H = new(get_turf(src))
	user.put_in_hands(H)

	H.concealed = TRUE
	H.pile_state = TRUE

	user.visible_message(SPAN_NOTICE("\The [user] draws a concealed pile of cards."), SPAN_NOTICE("You draw a concealed pile of cards."))

	H.cards = cards.Copy()
	cards = list()
	H.update_icon()
	update_icon()

/obj/item/toy/deck/verb/deal_card()
	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr))
		return

	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in the deck."))
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player

	var/mob/living/M = tgui_input_list(usr, "Who do you wish to deal a card?", "Deal card", players)
	if(!usr || QDELETED(src) || !Adjacent(usr) || !M || QDELETED(M))
		return

	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in the deck."))
		return

	if(get_dist(usr, M) < 4)
		deal_at(usr, M)

/obj/item/toy/deck/proc/deal_at(mob/user, mob/target)
	var/obj/item/toy/handcard/H = new(get_step(user, user.dir))

	H.cards += cards[1]
	cards -= cards[1]
	H.concealed = 1
	H.update_icon()
	update_icon()
	if(user == target)
		user.visible_message(SPAN_NOTICE("\The [user] deals a card to \himself."), SPAN_NOTICE("You deal a card to yourself."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] deals a card to \the [target]."), SPAN_NOTICE("You deal a card to \the [target]."))
	H.throw_atom(get_step(target,target.dir), 10, SPEED_VERY_FAST, H)

/obj/item/toy/deck/attack_self(mob/user)
	..()
	var/list/newcards = list()
	for(var/i = 1 to length(cards))
		var/datum/playing_card/P = pick_n_take(cards)
		newcards += P
	cards = newcards
	user.visible_message(SPAN_NOTICE("\The [user] shuffles \the [src]."), SPAN_NOTICE("You shuffle \the [src]."))

/obj/item/toy/deck/MouseDrop(atom/over)
	if(!usr || !over)
		return

	if(!ishuman(over) || get_dist(usr, over) > 3)
		return

	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in the deck."))
		return

	deal_at(usr, over)

/obj/item/toy/handcard
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "empty"
	w_class = SIZE_TINY
	flags_obj = parent_type::flags_obj|OBJ_IS_HELMET_GARB

	var/concealed = FALSE
	var/pile_state = FALSE
	var/list/datum/playing_card/cards = list()

/obj/item/toy/handcard/get_examine_line(mob/user)
	. = ..()
	if(!concealed)
		. += " ([length(cards)] card\s)"

/obj/item/toy/handcard/Destroy(force)
	. = ..()
	QDEL_NULL_LIST(cards)

/obj/item/toy/handcard/aceofspades
	icon_state = "spades_ace"
	desc = "An Ace of Spades"

/obj/item/toy/handcard/uno_reverse_red
	icon_state = "red_reverse"
	desc = "Always handy to have one or three of these up your sleeve."

/obj/item/toy/handcard/uno_reverse_blue
	icon_state = "blue_reverse"
	desc = "Always handy to have one or three of these up your sleeve."

/obj/item/toy/handcard/uno_reverse_yellow
	icon_state = "yellow_reverse"
	desc = "Always handy to have one or three of these up your sleeve."

/obj/item/toy/handcard/uno_reverse_purple
	icon_state = "purple_reverse"
	desc = "Always handy to have one or three of these up your sleeve."

/obj/item/toy/handcard/verb/toggle_discard_state()
	set name = "Toggle Pile State"
	set desc = "Set or Unset this hand as a pile. Try not having multiple discard piles nearby."
	set category = "Object"
	set src in usr

	if(usr.stat || !ishuman(usr))
		return

	pile_state = !pile_state
	usr.visible_message(SPAN_NOTICE("\The [usr] [pile_state ? "sets" : "unsets"] a pile."), SPAN_NOTICE("You [pile_state ? "set" : "unset"] a pile."))
	update_icon()

/obj/item/toy/handcard/verb/sort_cards()
	set category = "Object"
	set name = "Sort Hand"
	set desc = "Sort this hand by deck's initial order."
	set src in usr

	if(usr.stat || !ishuman(usr))
		return

	//fuck any qsorts and merge sorts. This needs to be brutally easy
	var/cards_length = length(cards)
	if(cards_length >= 200)
		to_chat(usr, SPAN_WARNING("Your hand is too big to sort. Remove some cards."))
		return
	for(var/i = 1 to cards_length)
		for(var/k = 2 to cards_length)
			if(cards[i].sort_index > cards[k].sort_index)
				var/crd = cards[i]
				cards[i] = cards[k]
				cards[k] = crd

	update_icon()
	usr.visible_message(SPAN_NOTICE("\The [usr] sorts \his hand."), SPAN_NOTICE("You sort your hand."))

/obj/item/toy/handcard/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/toy/handcard))
		var/obj/item/toy/handcard/H = O
		var/cards_length = length(H.cards)
		for(var/datum/playing_card/P in H.cards)
			cards += P
			H.cards -= P
		qdel(O)
		if(pile_state)
			if(concealed)
				user.visible_message(SPAN_NOTICE("\The [user] adds [cards_length > 1 ? "their hand" : "a card"] to \the [src]."), SPAN_NOTICE("You add [cards_length > 1 ? "your hand" : "<b>[cards[length(cards)].name]</b>"] to the \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [user] adds [cards_length > 1 ? "their hand" : "<b>[cards[length(cards)].name]</b>"] to \the [src]."), SPAN_NOTICE("You add [cards_length > 1 ? "your hand" : "<b>[cards[length(cards)].name]</b>"] to \the [src]."))
		else
			if(loc != user)
				if(isstorage(loc))
					var/obj/item/storage/storage = loc
					storage.remove_from_storage(src)
				user.put_in_hands(src)
		update_icon()
		return
	..()

/obj/item/toy/handcard/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		var/list/to_pick_up = list()
		for(var/datum/playing_card/P as anything in cards)
			to_pick_up[P.name] = P

		var/picking_up = tgui_input_list(user, "Which card do you wish to pick up?", "Take a card", to_pick_up)
		if(!picking_up || !user || QDELETED(src))
			return

		var/datum/playing_card/card = to_pick_up[picking_up]
		if(QDELETED(card) || !(card in cards))
			return

		var/obj/item/toy/handcard/H = get_or_make_user_hand(user, src)
		H.cards += card
		cards -= card
		H.update_icon()
		if(!length(cards))
			qdel(src)
		else
			update_icon()
		return
	else if(pile_state)
		var/obj/item/toy/handcard/H = get_or_make_user_hand(user, src)
		var/datum/playing_card/P = cards[length(cards)]
		H.cards += P
		cards -= P
		H.update_icon()
		user.visible_message(SPAN_NOTICE("<b>[user]</b> draws a card from \the [src]."), SPAN_NOTICE("You draw <b>[P.name]</b> from \the [src]."))
		if(!length(cards))
			qdel(src)
		else
			update_icon()
		return
	return ..()

/obj/item/toy/handcard/attack_self(mob/user)
	..()
	concealed = !concealed
	update_icon()
	user.visible_message(SPAN_NOTICE("\The [user] [concealed ? "conceals" : "reveals"] their hand."), SPAN_NOTICE("You [concealed ? "conceal" : "reveal"] your hand."))

/obj/item/toy/handcard/MouseDrop(atom/over)
	if(usr != over || !Adjacent(usr))
		return
	if(ismob(loc))
		return

	if(isstorage(loc))
		var/obj/item/storage/storage = loc
		storage.remove_from_storage(src)
	usr.put_in_hands(src)

/obj/item/toy/handcard/get_examine_text(mob/user)
	. = ..()
	if(length(cards))
		. += SPAN_NOTICE("It has <b>[length(cards)]</b> cards.")
		if(pile_state)
			if(!concealed)
				. += SPAN_NOTICE("The top card is <b>[cards[length(cards)].name]</b>.")
		else if(loc == user)
			var/card_names = list()
			for(var/datum/playing_card/P as anything in cards)
				card_names += P.name
			. += SPAN_NOTICE("The cards are: [english_list(card_names)]")


/obj/item/toy/handcard/update_icon(direction = 0)
	var/cards_length = length(cards)
	if(pile_state)
		if(concealed)
			name = "draw pile"
			desc = "A pile of cards to draw from."
		else
			name = "discard pile"
			desc = "A pile of cards you can discard to."
	else
		if(cards_length > 1)
			name = "hand of cards"
			desc = "Some playing cards."
		else
			name = "a playing card"
			desc = "A playing card."

	if(length(cards) >= 200)
		// BYOND will flat out choke when using thousands of cards for some unknown reason,
		// possibly due to the transformed overlay stacking below. Nobody's gonna see the
		// difference past 40 or so anyway.
		return

	overlays.Cut()

	if(!cards_length)
		return

	if(cards_length == 1 || pile_state)
		var/datum/playing_card/P = cards[cards_length]
		var/image/I = new(src.icon, (concealed ? P.back_icon : P.card_icon))
		overlays += I
		return

	var/offset = floor(80/cards_length)

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Translate(0, 0)
			if(SOUTH)
				M.Translate(0, 4)
			if(WEST)
				M.Turn(90)
				M.Translate(3, 0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2, 0)
	var/i = 0
	for(var/datum/playing_card/P as anything in cards)
		var/image/I = new(src.icon, (concealed ? P.back_icon : P.card_icon))
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8 - floor(offset*i/4)
			if(WEST)
				I.pixel_y = -6 + floor(offset*i/4)
			if(EAST)
				I.pixel_y = 8 - floor(offset*i/4)
			else
				I.pixel_x = -7 + floor(offset*i/4)
		I.transform = M
		overlays += I
		i++

/obj/item/toy/handcard/dropped(mob/user)
	..()
	if(locate(/obj/structure/surface/table, loc))
		update_icon(user.dir)
	else
		update_icon()

/obj/item/toy/handcard/pickup(mob/user)
	. = ..()
	update_icon()


/proc/get_or_make_user_hand(mob/living/user, obj/item/toy/handcard/ignore_hand)
	var/obj/item/toy/handcard/H
	if(istype(user.l_hand, /obj/item/toy/handcard) && user.l_hand != ignore_hand)
		H = user.l_hand
	else if(istype(user.r_hand, /obj/item/toy/handcard) && user.r_hand != ignore_hand)
		H = user.r_hand
	else
		H = new(get_turf(user))
		usr.put_in_hands(H)
	return H
