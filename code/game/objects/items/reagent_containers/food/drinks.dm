////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_container/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = null
	flags_atom = FPRINT|OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,25)
	volume = 50

/obj/item/reagent_container/food/drinks/on_reagent_change()
	if (gulp_size < 5) gulp_size = 5
	else gulp_size = max(round(reagents.total_volume / 5), 5)

/obj/item/reagent_container/food/drinks/attack(mob/M, mob/user)
	var/datum/reagents/R = src.reagents
	var/fillevel = gulp_size

	if(!R.total_volume || !R)
		to_chat(user, SPAN_DANGER("The [src.name] is empty!"))
		return FALSE

	if(M == user)
		to_chat(M, SPAN_NOTICE(" You swallow a gulp from \the [src]."))
		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)

		user.affected_message(M,
			SPAN_HELPFUL("You <b>start feeding</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] starts feeding [user == M ? "themselves" : "[M]"] [src]."))

		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M))
			return FALSE
		user.affected_message(M,
			SPAN_HELPFUL("You <b>fed</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>fed</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] fed [user == M ? "themselves" : "[M]"] [src]."))

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			bro.cell.use(30)
			var/refill = R.get_master_reagent_id()
			spawn(1 MINUTES)
				R.add_reagent(refill, fillevel)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return TRUE

	return FALSE


/obj/item/reagent_container/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to fill [src] with reagents from [target]."))
			return

		to_chat(user, SPAN_NOTICE(" You fill [src] with [trans] units of the contents of [target]."))

	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[target] is full."))
			return



		var/datum/reagent/refill
		var/datum/reagent/refillName
		if(isrobot(user))
			refill = reagents.get_master_reagent_id()
			refillName = reagents.get_master_reagent_name()

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the solution to [target]."))

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			var/chargeAmount = max(30,4*trans)
			bro.cell.use(chargeAmount)
			to_chat(user, "Now synthesizing [trans] units of [refillName]...")


			spawn(30 SECONDS)
				reagents.add_reagent(refill, trans)
				to_chat(user, "Cyborg [src] refilled.")

	return ..()

/obj/item/reagent_container/food/drinks/get_examine_text(mob/user)
	. = ..()
	if (get_dist(user, src) > 1 && user != loc)
		return
	if(!reagents || reagents.total_volume==0)
		. += SPAN_NOTICE("\The [src] is empty!")
	else if (reagents.total_volume<=src.volume/4)
		. += SPAN_NOTICE("\The [src] is almost empty!")
	else if (reagents.total_volume<=src.volume*0.66)
		. += SPAN_NOTICE("\The [src] is half full!")
	else if (reagents.total_volume<=src.volume*0.90)
		. += SPAN_NOTICE("\The [src] is almost full!")
	else
		. += SPAN_NOTICE("\The [src] is full!")


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = SIZE_LARGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags_atom = FPRINT|CONDUCT|OPENCONTAINER

/obj/item/reagent_container/food/drinks/golden_cup/tournament_26_06_2011
	desc = "A golden cup. It will be presented to a winner of tournament 26 June and name of the winner will be graved on it."


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/reagent_container/food/drinks/milk
	name = "Space Milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_container/food/drinks/milk/Initialize()
	. = ..()
	reagents.add_reagent("milk", 50)

/* Flour is no longer a reagent
/obj/item/reagent_container/food/drinks/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "flour"
	item_state = "flour"

/obj/item/reagent_container/food/drinks/flour/Initialize()
		..()
		reagents.add_reagent("flour", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)
*/

/obj/item/reagent_container/food/drinks/soymilk
	name = "soy milk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_container/food/drinks/soymilk/Initialize()
	. = ..()
	reagents.add_reagent("soymilk", 50)

/obj/item/reagent_container/food/drinks/coffee
	name = "\improper Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = "x=15;y=10"

/obj/item/reagent_container/food/drinks/coffee/Initialize()
	. = ..()
	reagents.add_reagent("coffee", 20)

/obj/item/reagent_container/food/drinks/tea
	name = "\improper Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "tea"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"

/obj/item/reagent_container/food/drinks/tea/Initialize()
	. = ..()
	reagents.add_reagent("tea", 30)

/obj/item/reagent_container/food/drinks/ice
	name = "ice cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee_nolid"
	item_state = "coffee"
	center_of_mass = "x=15;y=10"

/obj/item/reagent_container/food/drinks/ice/Initialize()
	. = ..()
	reagents.add_reagent("ice", 30)

/obj/item/reagent_container/food/drinks/h_chocolate
	name = "\improper Dutch hot coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = "x=15;y=13"

/obj/item/reagent_container/food/drinks/h_chocolate/Initialize()
	. = ..()
	reagents.add_reagent("hot_coco", 30)

/obj/item/reagent_container/food/drinks/dry_ramen
	name = "cup ramen"
	desc = "Just add 10ml water, self-heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"

/obj/item/reagent_container/food/drinks/dry_ramen/Initialize()
	. = ..()
	reagents.add_reagent("dry_ramen", 30)


/obj/item/reagent_container/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = "x=16;y=12"

/obj/item/reagent_container/food/drinks/sillycup/Initialize()
	. = ..()

/obj/item/reagent_container/food/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/reagent_container/food/drinks/cup
	name = "plastic cup"
	desc = "A generic red cup. Beer pong, anyone?"
	icon = 'icons/obj/items/cup.dmi'
	icon_state = "solocup"
	throwforce = 0
	w_class = SIZE_TINY
	matter = list("plastic" = 5)
	attack_verb = list("bludgeoned", "whacked", "slapped")

/obj/item/reagent_container/food/drinks/cup/attack_self(mob/user)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		user.visible_message(SPAN_WARNING("[user] crushes \the [src]!"), SPAN_WARNING("You crush \the [src]!"))
		if(reagents.total_volume > 0)
			reagents.clear_reagents()
			playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1, 3)
			to_chat(user, SPAN_WARNING("The contents of \the [src] spill!"))
		qdel(src)
		var/obj/item/trash/crushed_cup/C = new /obj/item/trash/crushed_cup(user)
		user.equip_to_slot_if_possible(C, (user.hand ? WEAR_L_HAND : WEAR_R_HAND))

/obj/item/trash/crushed_cup
	name = "crushed cup"
	desc = "A sad crushed and destroyed cup. It's now useless trash. What a waste."
	icon = 'icons/obj/items/cup.dmi'
	icon_state = "crushed_solocup"
	throwforce = 0
	w_class = SIZE_TINY
	matter = list("plastic" = 5)
	attack_verb = list("bludgeoned", "whacked", "slapped")

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_container/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 100
	center_of_mass = "x=17;y=10"

/obj/item/reagent_container/food/drinks/flask
	name = "metal flask"
	desc = "A metal flask with a decent liquid capacity."
	icon_state = "flask"
	volume = 60
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/marine
	name = "\improper USCM flask"
	desc = "A metal flask embossed with the USCM logo and probably filled with a slurry of water, motor oil, and medicinal alcohol."
	icon_state = "flask_uscm"
	volume = 60
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/marine/Initialize()
	. = ..()
	reagents.add_reagent("water", 59)
	reagents.add_reagent("hooch", 1)

/obj/item/reagent_container/food/drinks/flask/weylandyutani
	name = "\improper Weyland-Yutani flask"
	desc = "A metal flask embossed with Weyland-Yutani's signature logo. A nifty little corporate souvenir if you like the company."
	icon_state = "flask_wy"
	volume = 60
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/detflask
	name = "detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = "x=17;y=7"

/obj/item/reagent_container/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = "x=15;y=4"

/obj/item/reagent_container/food/drinks/coffeecup
	name = "coffee mug"
	desc = "A ceramic coffee mug. Practically guaranteed to fall and spill scalding-hot drink onto your brand-new shirt. Ouch."
	icon_state = "coffeecup"
	volume = 30
	center_of_mass = "x=15;y=13"

/obj/item/reagent_container/food/drinks/coffeecup/uscm
	name = "USCM coffee mug"
	desc = "A red, white and blue coffee mug depicting the emblem of the USCM. Patriotic and bold, and commonly seen among veterans as a novelty."
	icon_state = "uscmcup"

/obj/item/reagent_container/food/drinks/coffeecup/wy
	name = "Weyland-Yutani coffee mug"
	desc = "A matte gray coffee mug bearing the Weyland-Yutani logo on its front. Either issued as corporate standard, or bought as a souvenir for people who love the Company oh so dearly. Probably the former."
	icon_state = "wycup"

