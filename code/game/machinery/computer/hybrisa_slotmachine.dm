/*******************************\
|   Slot Machines |
|   Original code by Glloyd |
|   Tgstation port by Miauw |
\*******************************/

#define SPIN_PRICE 5
#define SMALL_PRIZE 400
#define BIG_PRIZE 1000
#define JACKPOT 10000
#define SPIN_TIME 65 //As always, deciseconds.
#define REEL_DEACTIVATE_DELAY 7
#define JACKPOT_SEVENS "space-shuttle"
#define FA_ICON_LEMON "lemon"
#define FA_ICON_STAR "star"
#define FA_ICON_BOMB "bomb"
#define FA_ICON_BIOHAZARD "biohazard"
#define FA_ICON_APPLE_WHOLE "apple-alt"
#define FA_ICON_7 "space-shuttle"
#define FA_ICON_DOLLAR_SIGN "fas fa-dollar-sign"

/obj/structure/machinery/computer/hybrisa/misc/slotmachine
	name = "slot machine"
	desc = "A slot machine."
	icon = 'icons/obj/structures/props/64x64_hybrisarandomprops.dmi'
	icon_state = "slotmachine"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	layer = WINDOW_LAYER
	health = 450
	var/icon_keyboard = null //ADDED REMOVE
	var/icon_screen = "slots_screen"
	idle_power_usage = 50
	circuit = null //lets hope null works
	light_color = LIGHT_COLOR_BROWN
	var/money = 3000 //How much money it has CONSUMED
	var/plays = 0
	var/rolling = FALSE
	var/balance = 0 //How much money is in the machine, ready to be CONSUMED.
	var/jackpots = 0
	var/paymode = 2 //toggles between HOLOCHIP/COIN, defined above
	var/cointype = /obj/item/coin/iron //default cointype
	/// Icons that can be displayed by the slot machine.
	var/static/list/icons = list(
		FA_ICON_LEMON = list("value" = 2, "colour" = "yellow"),
		FA_ICON_STAR = list("value" = 2, "colour" = "yellow"),
		FA_ICON_BOMB = list("value" = 2, "colour" = "black"),
		FA_ICON_BIOHAZARD = list("value" = 2, "colour" = "green"),
		FA_ICON_APPLE_WHOLE = list("value" = 2, "colour" = "red"),
		FA_ICON_7 = list("value" = 1, "colour" = "orange"),
		FA_ICON_DOLLAR_SIGN = list("value" = 2, "colour" = "green"),
	)

	var/static/list/coinvalues
	var/list/reels = list(list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0)

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/Initialize(mapload)
	. = ..()
	jackpots = rand(1, 4) //false hope
	plays = rand(75, 200)

	toggle_reel_spin_sync(1) //The reels won't spin unless we activate them

	var/list/reel = reels[1]
	for(var/i in 1 to reel.len) //Populate the reels.
		randomize_reels()

	toggle_reel_spin_sync(0)

	if (isnull(coinvalues))
		coinvalues = list()

		for(cointype in typesof(/obj/item/coin))
			var/obj/item/coin/C = new cointype
			coinvalues["[cointype]"] = C.black_market_value
			qdel(C)

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/Destroy()
	if(balance)
		give_payout(balance)
	return ..()

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/process(seconds_per_tick)
	. = ..() //Sanity checks.
	if(!.)
		return .

	money += round(seconds_per_tick / 2) //SPESSH MAJICKS

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/update_icon()
	if(stat & BROKEN)
		icon_state = "slots_broken"
	else
		if(stat & NOPOWER)
			icon_state = "slotmachine_off"
		else
			icon_state = "slotsmachine"


/obj/structure/machinery/computer/hybrisa/misc/slotmachine/attackby(obj/item/inserted, mob/user)
	if((stat & NOPOWER) || (stat & BROKEN))
		return
	if(istype(inserted, /obj/item/coin))
		var/obj/item/coin/inserted_coin = inserted
		if(!user.drop_inv_item_on_ground(inserted_coin))
			return
		to_chat(user,SPAN_WARNING("coin insterted"))
		balance += inserted_coin.black_market_value
		qdel(inserted_coin)

	if(istype(inserted, /obj/item/spacecash))
		var/obj/item/spacecash/inserted_cash = inserted
		if(!user.drop_inv_item_on_ground(inserted_cash))
			return
		to_chat(user,SPAN_WARNING("cash insterted"))
		balance += inserted_cash.worth
		qdel(inserted_cash)
	else
		return ..()
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/attack_hand(mob/living/user)
	. = ..()
	tgui_interact(user)

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/tgui_interact(mob/living/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SlotMachine", name)
		ui.open()

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/ui_static_data(mob/user)
	var/list/data = list()
	data["icons"] = list()
	for(var/icon_name in icons)
		var/list/icon = icons[icon_name]
		icon += list("icon" = icon_name)
		data["icons"] += list(icon)
	data["cost"] = SPIN_PRICE
	data["jackpot"] = JACKPOT

	return data

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/ui_data(mob/user)
	var/list/data = list()
	var/list/reel_states = list()
	for(var/reel_state in reels)
		reel_states += list(reel_state)
	data["state"] = reel_states
	data["balance"] = balance
	data["rolling"] = rolling
	data["money"] = money
	data["plays"] = plays
	data["jackpots"] = jackpots
	data["paymode"] = paymode
	return data


/obj/structure/machinery/computer/hybrisa/misc/slotmachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("spin")
			spin_slots(ui.user)
			return TRUE
		if("payout")
			if(balance > 0)
				give_payout(balance)
				balance = 0
				return TRUE

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/spin_slots(mob/user)
	if(!can_spin(user))
		return

	var/the_name
	if(user)
		the_name = user.real_name
		to_chat(user,SPAN_WARNING("[user] pulls the lever and the slot machine starts spinning!"))
	else
		the_name = "Exaybachay"

	balance -= SPIN_PRICE
	money += SPIN_PRICE
	plays += 1
	rolling = TRUE

	toggle_reel_spin(1)
	update_icon()
	var/spin_loop = addtimer(CALLBACK(src, PROC_REF(do_spin)), 2, TIMER_LOOP|TIMER_STOPPABLE)

	addtimer(CALLBACK(src, PROC_REF(finish_spinning), spin_loop, user, the_name), SPIN_TIME - (REEL_DEACTIVATE_DELAY * reels.len))
	//WARNING: no sanity checking for user since it's not needed and would complicate things (machine should still spin even if user is gone), be wary of this if you're changing this code.

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/do_spin()
	randomize_reels()
	use_power(active_power_usage)

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/finish_spinning(spin_loop, mob/user, the_name)
	toggle_reel_spin(0, REEL_DEACTIVATE_DELAY)
	rolling = FALSE
	deltimer(spin_loop)
	give_prizes(the_name, user)
	update_icon()

/// Check if the machine can be spun
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/can_spin(mob/user)
	if(stat & NOPOWER)
		to_chat(user,SPAN_WARNING( "no power!"))
		return FALSE
	if(stat & BROKEN)
		to_chat(user,SPAN_WARNING( "machine broken!"))
		return FALSE
	if(rolling)
		to_chat(user,SPAN_WARNING( "already spinning!"))
		return FALSE
	if(balance < SPIN_PRICE)
		to_chat(user,SPAN_WARNING( "insufficient balance!"))
		return FALSE
	return TRUE

/// Sets the spinning states of all reels to value, with a delay between them
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/toggle_reel_spin(value, delay = 0) //value is 1 or 0 aka on or off
	for(var/list/reel in reels)
		//if(!value)
			//playsound(src, 'sound/machines/ding_short.ogg', 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		reels[reel] = value
		if(delay)
			sleep(delay)

/// Same as toggle_reel_spin, but without the delay and runs synchronously
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/toggle_reel_spin_sync(value)
	for(var/list/reel in reels)
		reels[reel] = value

/// Randomize the states of all reels
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/randomize_reels()

	for(var/reel in reels)
		if(reels[reel])
			reel[3] = reel[2]
			reel[2] = reel[1]
			var/chosen = pick(icons)
			reel[1] = icons[chosen] + list("icon_name" = chosen)

/// Checks if any prizes have been won, and pays them out
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/give_prizes(usrname, mob/user)
	var/linelength = get_lines()

	if(check_jackpot(JACKPOT_SEVENS))
		var/prize = money + JACKPOT
		to_chat(user,SPAN_WARNING("<b>[src]</b> says, 'JACKPOT! You win [prize] dollars!'"))
		jackpots += 1
		give_money(prize)
		money = 0

	else if(linelength == 5)
		to_chat(user,SPAN_WARNING("<b>[src]</b> says, 'Big Winner! You win a thousand dollars!'"))
		give_money(BIG_PRIZE)

	else if(linelength == 4)
		to_chat(user,SPAN_WARNING("<b>[src]</b> says, 'Winner! You win four hundred dollars!'"))
		give_money(SMALL_PRIZE)

	else if(linelength == 3)
		to_chat(user, SPAN_WARNING("You win three free games!"))
		balance += SPIN_PRICE * 4

	else
		to_chat(user,SPAN_WARNING( "no luck!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50)


/// Checks for a jackpot (5 matching icons in the middle row) with the given icon name
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/check_jackpot(name)
	return reels[1][2]["icon_name"] + reels[2][2]["icon_name"] + reels[3][2]["icon_name"] + reels[4][2]["icon_name"] + reels[5][2]["icon_name"] == "[name][name][name][name][name]"

/// Finds the largest number of consecutive matching icons in a row
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/get_lines()
	var/amountthesame

	for(var/i in 1 to 3)
		var/inputtext = reels[1][i]["icon_name"] + reels[2][i]["icon_name"] + reels[3][i]["icon_name"] + reels[4][i]["icon_name"] + reels[5][i]["icon_name"]
		for(var/icon in icons)
			var/j = 3 //The lowest value we have to check for.
			var/symboltext = icon + icon + icon
			while(j <= 5)
				if(findtext(inputtext, symboltext))
					amountthesame = max(j, amountthesame)
				j++
				symboltext += icon

			if(amountthesame)
				break

	return amountthesame

/// Give the specified amount of money. If the amount is greater than the amount of prize money available, add the difference as balance
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/give_money(amount)
	var/amount_to_give = min(amount, money)
	var/surplus = amount - give_payout(amount_to_give)
	money -= amount_to_give
	balance += surplus

/// Pay out the specified amount in either coins or holochips
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/give_payout(amount)
	var/mob/living/target = locate() in range(2, src)
	amount = dispense(amount, target)
	return amount

/// Dispense the given amount. If machine is set to use coins, will use the specified coin type.
/// If throwit and target are set, will launch the payment at the target
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/dispense(amount = 0, mob/living/target)
	while(amount > 0)
		var/obj/item/spacecash/bundle/bundle = new (target.loc)
		bundle.worth = min(amount, rand(10,100))
		bundle.update_icon()
		if(target)
			target.put_in_hands(bundle)
		amount -= bundle.worth
	return amount

#undef BIG_PRIZE
#undef JACKPOT
#undef REEL_DEACTIVATE_DELAY
#undef JACKPOT_SEVENS
#undef SMALL_PRIZE
#undef SPIN_PRICE
#undef SPIN_TIME
