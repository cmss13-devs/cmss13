// Slot Machines
// Original code by Glloyd
// CM port by Cuberound

#define SPIN_PRICE 10
#define SMALL_PRIZE 100
#define BIG_PRIZE 500
#define JACKPOT 5000
#define SPIN_TIME (6.5 SECONDS)
#define REEL_DEACTIVATE_DELAY (7 DECISECONDS)
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
	icon = 'icons/obj/structures/props/furniture/slot_machines.dmi'
	icon_state = "slotmachine"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	layer = BIG_XENO_LAYER
	health = 450
	idle_power_usage = 50
	circuit = null //lets hope null works
	light_color = LIGHT_COLOR_BROWN
	/// How much money it has CONSUMED
	var/prize_money = 3000
	/// How many times it has been rolled
	var/plays = 0
	/// Whether it is currently rolling
	var/rolling = FALSE
	/// How much money is in the machine, ready to be CONSUMED
	var/balance = 0
	/// Counter of how many jackpots have been won so far
	var/jackpots = 0
	/// The current state of the reels
	var/list/reels = list(list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0)
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

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/Initialize(mapload)
	. = ..()
	jackpots = rand(1, 4) //false hope
	plays = rand(75, 200)

	toggle_reel_spin_sync(1) //The reels won't spin unless we activate them

	var/list/reel = reels[1]
	for(var/i in 1 to length(reel)) //Populate the reels.
		randomize_reels()

	toggle_reel_spin_sync(0)

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/Destroy()
	if(balance)
		dispense(balance)
	return ..()

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/process(seconds_per_tick)
	. = ..() //Sanity checks.
	if(!.)
		return .

	prize_money += round(seconds_per_tick / 2, 1) //SPESSH MAJICKS

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/update_icon()
	..()
	if(stat & BROKEN)
		icon_state = "slotmachine_broken"
		return
	if(stat & NOPOWER)
		icon_state = "slotmachine_off"
		return
	if(rolling)
		icon_state = "slotmachine_working"
	else
		icon_state = "slotmachine_idle"

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/attackby(obj/item/inserted, mob/user)
	if((stat & NOPOWER) || (stat & BROKEN))
		return

	if(istype(inserted, /obj/item/coin))
		var/obj/item/coin/inserted_coin = inserted
		if(!user.drop_inv_item_on_ground(inserted_coin))
			return
		to_chat(user, SPAN_WARNING("Coin insterted."))
		balance += inserted_coin.black_market_value
		qdel(inserted_coin)
		return

	if(istype(inserted, /obj/item/spacecash))
		var/obj/item/spacecash/inserted_cash = inserted
		if(!user.drop_inv_item_on_ground(inserted_cash))
			return
		to_chat(user, SPAN_WARNING("Cash insterted."))
		balance += inserted_cash.worth
		qdel(inserted_cash)
		return

	return ..()

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/attack_hand(mob/living/user)
	. = ..()
	if(!.) //not broken or unpowered
		tgui_interact(user)
		return TRUE

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SlotMachine", name)
		ui.open()

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/ui_static_data(mob/user)
	var/list/data = list()
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
	data["prize_money"] = prize_money
	data["plays"] = plays
	data["jackpots"] = jackpots
	return data

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("spin")
			if(get_turf(ui.user) != get_step(src, dir))
				to_chat(ui.user, SPAN_WARNING("You aren't close enough to the lever to spin [src]!"))
				return FALSE
			if(balance >= SPIN_PRICE)
				spin_slots(ui.user)
				return TRUE
		if("payout")
			if(get_turf(ui.user) != get_step(src, dir))
				to_chat(ui.user, SPAN_WARNING("You aren't close enough to [src]!"))
				return FALSE
			if(balance > 0)
				dispense(balance, ui.user)
				balance = 0
				return TRUE

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/spin_slots(mob/user)
	if(!can_spin(user))
		return

	user.visible_message(SPAN_WARNING("[user] pulls the lever and [src] starts spinning!"), max_distance = 1)

	balance -= SPIN_PRICE
	prize_money += SPIN_PRICE
	plays++
	rolling = TRUE
	playsound(src, 'sound/machines/slotmachine/rolling-slotmachine.ogg', 50)

	toggle_reel_spin(1)
	update_icon()
	var/spin_loop = addtimer(CALLBACK(src, PROC_REF(do_spin)), 2 DECISECONDS, TIMER_LOOP|TIMER_STOPPABLE)

	addtimer(CALLBACK(src, PROC_REF(finish_spinning), spin_loop, user), SPIN_TIME - (REEL_DEACTIVATE_DELAY * length(reels)))
	//WARNING: no sanity checking for user since it's not needed and would complicate things (machine should still spin even if user is gone), be wary of this if you're changing this code.

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/do_spin()
	randomize_reels()
	use_power(active_power_usage)

/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/finish_spinning(spin_loop, mob/user)
	toggle_reel_spin(0, REEL_DEACTIVATE_DELAY)
	rolling = FALSE
	deltimer(spin_loop)
	give_prizes(user)
	update_icon()

/// Check if the machine can be spun
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/can_spin(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("[src] isn't powered!"))
		return FALSE
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("[src] is broken!"))
		return FALSE
	if(rolling)
		to_chat(user, SPAN_WARNING("[src] is already spinning!"))
		return FALSE
	if(balance < SPIN_PRICE)
		to_chat(user, SPAN_WARNING("[src] flashes insufficient balance!"))
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
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/give_prizes(mob/user)
	var/linelength = get_lines()

	if(check_jackpot(JACKPOT_SEVENS))
		var/prize = prize_money + JACKPOT
		visible_message(SPAN_WARNING("<b>[src]</b> says, 'JACKPOT! You win [prize] dollars!'"))
		jackpots++
		give_money(prize)
		prize_money = 0
		playsound(src, 'sound/machines/slotmachine/jackpot-slotmachine.ogg', 50)
		return

	switch(linelength)
		if(5)
			visible_message(SPAN_WARNING("<b>[src]</b> says, 'Big Winner! You win five hundred dollars!'"))
			give_money(BIG_PRIZE)
			playsound(src, 'sound/machines/slotmachine/bigwin-slotmachine.ogg', 45)

		if(4)
			visible_message(SPAN_WARNING("<b>[src]</b> says, 'Winner! You win one hundred dollars!'"))
			give_money(SMALL_PRIZE)
			playsound(src, 'sound/machines/slotmachine/smallwin-slotmachine.ogg', 50)

		if(3)
			to_chat(user, SPAN_WARNING("You win three free games!"))
			balance += SPIN_PRICE * 3
			playsound(src, 'sound/machines/slotmachine/bonus-slotmachine.ogg', 50)

		else
			to_chat(user, SPAN_WARNING("No luck!"))
			playsound(src, 'sound/machines/slotmachine/lose-slotmachine.ogg', 50)


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
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/give_money(amount, mob/living/target)
	var/amount_to_give = min(amount, prize_money)
	dispense(amount_to_give, target)
	prize_money -= amount_to_give
	balance += amount - amount_to_give

/// Dispense the given amount to the target if they are adjacent
/obj/structure/machinery/computer/hybrisa/misc/slotmachine/proc/dispense(amount, mob/living/target)
	var/turf/location
	if(!target || !Adjacent(target))
		location = get_step(src, dir)
		target = null // to not put it in their hands
	else
		location = get_turf(target)

	while(amount > 0)
		var/obj/item/spacecash/bundle/bundle = new(location)
		bundle.worth = min(amount, rand(10,100))
		bundle.update_icon()
		if(istype(target))
			target.put_in_hands(bundle)
		amount -= bundle.worth

#undef SPIN_PRICE
#undef SMALL_PRIZE
#undef BIG_PRIZE
#undef JACKPOT
#undef SPIN_TIME
#undef REEL_DEACTIVATE_DELAY
#undef JACKPOT_SEVENS
#undef FA_ICON_LEMON
#undef FA_ICON_STAR
#undef FA_ICON_BOMB
#undef FA_ICON_BIOHAZARD
#undef FA_ICON_APPLE_WHOLE
#undef FA_ICON_7
#undef FA_ICON_DOLLAR_SIGN
