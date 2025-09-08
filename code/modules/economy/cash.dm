/obj/item/spacecash
	name = "15 dollars"
	desc = "You have 15 dollars."
	gender = PLURAL
	icon = 'icons/obj/items/economy.dmi'
	icon_state = "spacecash1"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	force = 1
	throwforce = 1
	throw_speed = SPEED_FAST
	throw_range = 2
	w_class = SIZE_TINY
	var/worth = 15
	/// 'Counterfeit' bills cannot be inserted into the black market for dosh. Their worth is also quartered when entered into an ATM.
	var/counterfeit = FALSE

/obj/item/spacecash/Initialize(mapload, ...)
	. = ..()
	update_value()

/obj/item/spacecash/proc/update_value()
	if(counterfeit)
		return
	black_market_value = worth // While money can be inserted directly into the console, this will allow CTs to detect if the money is 'counterfeit' with their scanner.

/obj/item/spacecash/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/attack_cash = W
		if(istype(attack_cash, /obj/item/spacecash/ewallet))
			return FALSE
		if(attack_cash.counterfeit != src.counterfeit)
			to_chat(user, SPAN_NOTICE("These two stacks of money seem different, somehow..."))
			return

		var/obj/item/spacecash/bundle/bundle
		if(!istype(W, /obj/item/spacecash/bundle))
			var/obj/item/spacecash/cash = W
			user.temp_drop_inv_item(cash)
			bundle = new(src.loc)
			bundle.worth += cash.worth
			bundle.counterfeit = counterfeit
			bundle.update_value()
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_value()
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			h_user.temp_drop_inv_item(src)
			h_user.temp_drop_inv_item(bundle)
			h_user.put_in_hands(bundle)
		to_chat(user, SPAN_NOTICE("You add [src.worth] dollars worth of money to the bundles.<br>It holds [bundle.worth] dollars now."))
		qdel(src)

/obj/item/spacecash/bundle
	name = "stack of dollars"
	icon_state = ""
	desc = "They are worth 0 dollars."
	worth = 0

/obj/item/spacecash/bundle/update_icon()
	overlays.Cut()
	var/sum = worth
	var/num = 0
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items/economy.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			overlays += banknote
	if(num == 0) // Less than one thaler, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items/economy.dmi', "spacecash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		overlays += banknote
	desc = "They are worth [worth] dollars."

/obj/item/spacecash/bundle/attack_self(mob/user)
	..()
	var/oldloc = loc
	var/amount = tgui_input_number(user, "How many dollars do you want to take? (0 to [worth])", "Take Money", 0, worth, 0)
	amount = floor(clamp(amount, 0, worth))
	if(amount == 0)
		return
	if(QDELETED(src) || loc != oldloc)
		return

	worth -= amount
	update_icon()
	if(!worth)
		usr.temp_drop_inv_item(src)

	if(amount in list(1000,500,200,100,50,20,1))
		var/cashtype = text2path("/obj/item/spacecash/c[amount]")
		var/obj/item/spacecash/cash = new cashtype(usr.loc)
		cash.counterfeit = counterfeit
		user.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new(usr.loc)
		bundle.worth = amount
		bundle.counterfeit = counterfeit
		bundle.update_icon()
		user.put_in_hands(bundle)

	if(!worth)
		qdel(src)

/obj/item/spacecash/c1
	name = "1 dollar bill"
	icon_state = "spacecash1"
	desc = "A single US Government minted one dollar bill. It has a picture of George Washington printed on it. Makes most people of English origin cry, but isn't worth very much. Could probably get you half a hot-dog in some systems. "
	worth = 1

/obj/item/spacecash/c10
	name = "10 dollar bill"
	icon_state = "spacecash10"
	desc = "A single US Government minted ten-dollar bill. It has a picture of Alexander Hamilton on it, federal bank enthusiast, and victim of a terrible griefing incident. Could probably pay for a meal at a cheap restaurant, before tax and tip."
	worth = 10

/obj/item/spacecash/c20
	name = "20 dollar bill"
	icon_state = "spacecash20"
	desc = "A single US Government minted twenty-dollar bill. It has a picture of Andrew Jackson on it, famed hero of the War of 1812 and slayer of indigenous peoples everywhere. Could probably afford you a nice 2-course meal at the local colony steakhouse."
	worth = 20

/obj/item/spacecash/c50
	name = "50 dollar bill"
	icon_state = "spacecash50"
	desc = "A single US Government minted fifty-dollar bill. It has a picture of Ulysses S. Grant, a man known for expendable troop tactics in the civil war. You could probably buy the whole bar a beer with this, assuming there are 4 other people in the bar."
	worth = 50

/obj/item/spacecash/c100
	name = "100 dollar bill"
	icon_state = "spacecash100"
	desc = "A single US Government minted hundred-dollar bill. It has a picture of Ben Franklin, lightning kite extraordinaire. You could probably pay for an entire day of shore leave activities with this, provided you aren't careless. (which you are)"
	worth = 100

/obj/item/spacecash/c200
	name = "200 dollars"
	icon_state = "spacecash200"
	desc = "Two US Government minted hundred-dollar bills. They both have pictures of Ben Franklin on them. Both Bens look at you expectedly and passionately from different angles."
	worth = 200

/obj/item/spacecash/c500
	name = "500 dollars"
	icon_state = "spacecash500"
	desc = "Five US Government minted hundred-dollar bills. All of them have pictures of Ben Franklin on them. They all eagarly glare at you, making you feel as if you owe them something. "
	worth = 500

/obj/item/spacecash/c500/counterfeit
	// If you're going to slap down huge sums of cash in easily reachable spots for RP or flavor reasons, make them counterfeit, so they don't break the black market - they will be rejected.
	counterfeit = TRUE

/obj/item/spacecash/c1000
	name = "1000 dollars"
	icon_state = "spacecash1000"
	desc = "Ten US Government minted hundred-dollar bills. Every single damn one of them has Ben Fucking Franklin on them. The court of Bens sit impatiently, as if each one thought they alone belonged to you. This coven of angry Bens have all since learned about your relations with the other Bens, and they want answers."
	worth = 1000

/obj/item/spacecash/c1000/counterfeit
	// If you're going to slap down huge sums of cash in easily reachable spots for RP or flavor reasons, make them counterfeit, so they don't break the black market - they will be rejected.
	counterfeit = TRUE

/proc/spawn_money(sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(1000,500,200,100,50,20,10,1))
		var/cash_type = text2path("/obj/item/spacecash/c[sum]")
		var/obj/cash = new cash_type (usr.loc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new (spawnloc)
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/spacecash/ewallet
	name = "\improper Weyland-Yutani cash card"
	icon_state = "efundcard"
	desc = "A Weyland-Yutani backed cash card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/spacecash/ewallet/get_examine_text(mob/user)
	. = ..()
	if(user == loc)
		. += SPAN_NOTICE("Charge card's owner: [owner_name]. Dollars remaining: [worth].")
