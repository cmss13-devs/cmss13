/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"
	var/sort_index = 0

/obj/item/toy/deck
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "deck"
	var/base_icon = "deck"
	var/max_cards = 52
	w_class = SIZE_TINY

	var/list/cards = list()

/obj/item/toy/deck/New()
	..()
	populate_deck()

/obj/item/toy/deck/proc/populate_deck()
	var/datum/playingcard/P
	var/card_id = 1
	for(var/suit in list("spades","clubs","diamonds","hearts"))
		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[suit]_[number]"
			P.back_icon = "back_[base_icon]"
			P.sort_index = card_id++
			cards += P

/obj/item/toy/deck/uno
	name = "deck of UNO cards"
	desc = "A simple deck of the Weston-Yamada classic UNO playing cards."
	icon_state = "deck_uno"
	base_icon = "deck_uno"
	max_cards = 108

/obj/item/toy/deck/uno/populate_deck()
	var/datum/playingcard/P
	var/card_id = 1
	//wild cards
	
	for(var/suit in list("wild","wild-draw-four"))
		for(var/i = 1 to 4)
			P = new()
			P.name = "[suit]"
			P.card_icon = "[suit]"
			P.back_icon = "back_[base_icon]"
			P.sort_index = card_id++
			cards += P

	//color cards
	for(var/suit in list("red","purple","blue","yellow"))
		//1 zero per color
		P = new()
		P.name = "[suit] zero"
		P.card_icon = "[suit]_zero"
		P.back_icon = "back_[base_icon]"
		P.sort_index = card_id++
		cards += P

		//2 of each 1-9, skip, draw 2, reverse per color
		for(var/i = 1 to 2)
			for(var/number in list("one","two","three","four","five","six","seven","eight","nine","skip","draw-two","reverse"))
				P = new()
				P.name = "[suit] [number]"
				P.card_icon = "[suit]_[number]"
				P.back_icon = "back_[base_icon]"
				P.sort_index = card_id++
				cards += P

/obj/item/toy/deck/attackby(obj/item/O, mob/user)
	if(istype(O,/obj/item/toy/handcard))
		var/obj/item/toy/handcard/H = O
		for(var/datum/playingcard/P in H.cards)
			cards += P
		update_icon()
		qdel(O)
		to_chat(user, "You place your cards on the bottom of the deck.")
		return
	..()

/obj/item/toy/deck/update_icon()
	if(cards.len == max_cards) icon_state = base_icon
	else if(cards.len == 0) icon_state = "[base_icon]_empty"
	else icon_state = "[base_icon]_open"

/obj/item/toy/deck/verb/draw_card()
	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	var/obj/item/toy/handcard/H
	if(user.l_hand && istype(user.l_hand,/obj/item/toy/handcard))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/toy/handcard))
		H = user.r_hand
	else
		H = new(get_turf(src))
		user.put_in_hands(H)

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.update_icon()
	update_icon()
	user.visible_message("\The [user] draws a card.")
	to_chat(user, "It's the [P].")

/obj/item/toy/deck/verb/draw_cards()
	set category = "Object"
	set name = "Draw N Cards"
	set desc = "Draw amount cards from a deck."
	set src in view(1)

	if(usr.stat || !ishuman(usr) || !Adjacent(usr)) return

	var/mob/living/carbon/human/user = usr

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	var/obj/item/toy/handcard/H
	if(user.l_hand && istype(user.l_hand,/obj/item/toy/handcard))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/toy/handcard))
		H = user.r_hand
	else
		H = new(get_turf(src))
		user.put_in_hands(H)

	var/num_cards_text = stripped_input(usr, "How many cards?", "Draw Cards" , "1", 5)
	var/num_cards = text2num(num_cards_text)
	if(!num_cards || num_cards < 0)
		to_chat(usr, SPAN_WARNING("Incorrect input format."))
		return

	if(cards.len<num_cards)
		to_chat(usr, SPAN_WARNING("Not enough cards in the deck."))
		return
	
	if(num_cards==1)
		user.visible_message("\The [user] draws a card.")
	else
		user.visible_message("\The [user] draws [num_cards] cards.")

	var/chat_message = ""
	while(num_cards>0)
		var/datum/playingcard/P = cards[1]
		H.cards += P
		cards -= P
		H.update_icon()
		update_icon()
		num_cards--
		chat_message += "[P]; "
	
	to_chat(user, "You've drawn: [chat_message]")

/obj/item/toy/deck/verb/deal_card()
	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr

	var/mob/living/M = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || disposed || !Adjacent(usr) || !M || M.disposed) return

	if(!cards.len)
		return

	for(var/mob/living/L in viewers(3))
		if(L == M)
			deal_at(usr, M)
			break

/obj/item/toy/deck/proc/deal_at(mob/user, mob/target)
	var/obj/item/toy/handcard/H = new(get_step(user, user.dir))

	H.cards += cards[1]
	cards -= cards[1]
	H.concealed = 1
	H.update_icon()
	update_icon()
	if(user == target)
		user.visible_message("\The [user] deals a card to \himself.")
	else
		user.visible_message("\The [user] deals a card to \the [target].")
	H.throw_atom(get_step(target,target.dir), 10, SPEED_VERY_FAST, H)

/obj/item/toy/deck/attack_self(var/mob/user as mob)
	var/list/newcards = list()
	while(cards.len)
		var/datum/playingcard/P = pick(cards)
		newcards += P
		cards -= P
	cards = newcards
	user.visible_message("\The [user] shuffles [src].")

/obj/item/toy/deck/MouseDrop(atom/over)
	if(!usr || !over) return

	if(!ishuman(over) || !(over in viewers(3))) return

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	deal_at(usr, over)

/obj/item/toy/handcard
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "empty"
	w_class = SIZE_TINY

	var/concealed = 0
	var/discard_pile = FALSE
	var/list/cards = list()

/obj/item/toy/handcard/aceofspades
	icon_state = "spades_ace"
	desc = "An Ace of Spades"

/obj/item/toy/handcard/uno_reverse_red
	icon_state = "red_reverse"
	desc = "Always handy to have one or three of these up your sleeve.."

/obj/item/toy/handcard/uno_reverse_blue
	icon_state = "blue_reverse"
	desc = "Always handy to have one or three of these up your sleeve.."

/obj/item/toy/handcard/uno_reverse_yellow
	icon_state = "yellow_reverse"
	desc = "Always handy to have one or three of these up your sleeve.."

/obj/item/toy/handcard/uno_reverse_purple
	icon_state = "purple_reverse"
	desc = "Always handy to have one or three of these up your sleeve.."

/obj/item/toy/handcard/attackby(obj/item/O, mob/user)
	if(istype(O,/obj/item/toy/handcard))
		var/obj/item/toy/handcard/H = O
		for(var/datum/playingcard/P in H.cards)
			cards += P
		src.concealed = H.concealed
		qdel(O)
		if(loc != user)
			user.put_in_hands(src)
		update_icon()
		return
	..()

/obj/item/toy/handcard/verb/toggle_discard_state()
	set category = "Object"
	set name = "Toggle Discard State"
	set desc = "Set or Unset this pile as a discard pile. Try not having multiple discard piles nearby"

	if(usr.stat || !ishuman(usr) || !Adjacent(usr)) return

	discard_pile = !discard_pile
	usr.visible_message("\The [usr] [discard_pile ? "sets" : "unsets"] a discard pile.")

/obj/item/toy/handcard/verb/sort_cards()
	set category = "Object"
	set name = "Sort Hand"
	set desc = "Sort this hand by deck's initial order"

	if(usr.stat || !ishuman(usr) || !Adjacent(usr)) return

	//fuck any qsorts and merge sorts. This needs to be brutally easy
	for(var/i=1, i<=cards.len, i++)
		for(var/k=i+1, k<=cards.len, k++)
			if(cards[i].sort_index > cards[k].sort_index)
				var/crd = cards[i]
				cards[i] = cards[k]
				cards[k] = crd

	src.update_icon()
	usr.visible_message("\The [usr] sorts his hand.")

/obj/item/toy/handcard/verb/discard()
	set category = "Object"
	set name = "Discard"
	set desc = "Place a card from your hand in front of you or onto a discard pile."

	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/discarding = input("Which card do you wish to put down?") as null|anything in to_discard

	if(!discarding || !usr || disposed || loc != usr) return

	var/datum/playingcard/card = to_discard[discarding]
	if(card.disposed)
		return
	var/found = FALSE
	for(var/datum/playingcard/P in cards)
		if(P == card)
			found = TRUE
			break
	if(!found)
		return
	qdel(to_discard)
	
	cards -= card
	if(!cards.len)
		qdel(src)

	usr.visible_message("\The [usr] plays \the [discarding].")

	for(var/obj/item/toy/handcard/hc in orange(1, usr))
		if(hc && hc.discard_pile)
			hc.cards += card
			hc.update_icon()
			if(src)
				src.update_icon()
			return

	var/obj/item/toy/handcard/H = new(src.loc)
	H.cards += card
	H.concealed = 0
	H.discard_pile = discard_pile
	H.update_icon()
	H.loc = get_step(usr,usr.dir)
	if(src)
		src.update_icon()

/obj/item/toy/handcard/verb/take_top_card()
	set category = "Object"
	set name = "Take a Card"
	set desc = "Pick a card and add it to your hand"
	set src in view(1)

	if(!ishuman(usr)) return

	var/list/to_pick_up = list()
	for(var/datum/playingcard/P in cards)
		to_pick_up[P.name] = P
	var/picking_up = input("Which card do you wish to pick up?") as null|anything in to_pick_up

	if(!picking_up || !usr || disposed) return
	
	var/mob/living/carbon/human/user = usr

	var/datum/playingcard/card = to_pick_up[picking_up]
	if(card.disposed)
		return
	var/found = FALSE
	for(var/datum/playingcard/P in cards)
		if(P == card)
			found = TRUE
			break
	if(!found)
		return
	qdel(to_pick_up)
	
	cards -= card
	if(!cards.len)
		qdel(src)

	usr.visible_message("\The [user] takes \the [picking_up].")

	var/obj/item/toy/handcard/H
	if(user.l_hand && istype(user.l_hand,/obj/item/toy/handcard))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/toy/handcard))
		H = user.r_hand
	else
		H = new(get_turf(src))
		usr.put_in_hands(H)

	var/datum/playingcard/P = card
	H.cards += P
	cards -= P
	H.update_icon()
	if(src)
		src.update_icon()


/obj/item/toy/handcard/attack_self(var/mob/user as mob)
	concealed = !concealed
	update_icon()
	user.visible_message("\The [user] [concealed ? "conceals" : "reveals"] their hand.")

/obj/item/toy/handcard/examine(mob/user)
	..()
	if(cards.len)
		to_chat(user, "It has [cards.len] cards.")
		if((!concealed || loc == user))
			to_chat(user, "The cards are: ")
			for(var/datum/playingcard/P in cards)
				to_chat(user, "A [P.name].")

/obj/item/toy/handcard/update_icon(var/direction = 0)
	if(cards.len > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else
		name = "a playing card"
		desc = "A playing card."

	overlays.Cut()

	if(!cards.len)
		return

	if(cards.len == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? P.back_icon : P.card_icon))
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		overlays += I
		return

	var/offset = Floor(80/cards.len)

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
	for(var/datum/playingcard/P in cards)
		var/image/I = new(src.icon, (concealed ? P.back_icon : P.card_icon))
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8 - Floor(offset*i/4)
			if(WEST)
				I.pixel_y = -6 + Floor(offset*i/4)
			if(EAST)
				I.pixel_y = 8 - Floor(offset*i/4)
			else
				I.pixel_x = -7 + Floor(offset*i/4)
		I.transform = M
		overlays += I
		i++

/obj/item/toy/handcard/dropped(mob/user as mob)
	..()
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)
	else
		update_icon()

/obj/item/toy/handcard/pickup(mob/user as mob)
	src.update_icon()