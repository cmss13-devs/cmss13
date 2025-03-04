//The fortune

/obj/item/paper/fortune
	name = "fortune"
	icon_state = "fortune"

/obj/item/paper/fortune/premade

/obj/item/paper/fortune/premade/proc/assign_fortunes()
	var/list/fortunelist = file2list("strings/fortunes.txt")
	return(pick(fortunelist))

/obj/item/paper/fortune/premade/proc/get_lucky_numbers()
	var/num1 = rand(1,99)
	var/num2 = rand(1,99)
	var/num3 = rand(1,99)
	var/num4 = rand(1,99)
	var/num5 = rand(1,99)
	var/luckynumbers = "[num1], [num2], [num3], [num4], and [num5]"
	return luckynumbers

/obj/item/paper/fortune/premade/Initialize(mapload, message = "Random", numbers = "Random")
	. = ..()
	switch(message)
		if("None")
			message = null
		if("Random")
			message = assign_fortunes()
	if(numbers == "None")
		numbers = null
	else
		numbers = "Your lucky numbers are [numbers == "Random" ? get_lucky_numbers() : numbers]."
	if(message || numbers)
		info = "<p style=\"text-align: center;\"><span style=\"text-align: center; color: #0000ff;\"><b>[message]</b><br/>[numbers]</p></span>"
	else
		error("Fortune cookie code broke! Fortune does not smile upon you today.")

//The cookie

/obj/item/reagent_container/food/snacks/fortunecookie
	name = "fortune cookie"
	desc = "A golden brown fortune cookie. Some say the paper inside even has the ability to predict the future, whatever that means."
	icon_state = "fortune_cookie"
	icon = 'icons/obj/items/food/mre_food/USCM.dmi'
	filling_color = "#E8E79E"
	//If the cookie has been broken open
	var/cookie_broken = FALSE
	//The fortune inside the cookie
	var/cookiefortune

/obj/item/reagent_container/food/snacks/fortunecookie/update_icon()
	. = ..()
	if(cookie_broken)
		icon_state = "fortune_cookie_open"
	else
		icon_state = "fortune_cookie"

/obj/item/reagent_container/food/snacks/fortunecookie/get_examine_text(mob/user)
	. = ..()
	if(cookie_broken)
		. += SPAN_WARNING("It's cracked open!")
	else
		if(cookiefortune)
			. += SPAN_NOTICE("It has a fortune inside it already.")
		else
			. += SPAN_NOTICE("It's empty.")

/obj/item/reagent_container/food/snacks/fortunecookie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fortunecookie/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper))
		if(cookie_broken)
			to_chat(user,SPAN_WARNING("[src] is cracked open! How are you gonna slip something in that?"))
		else
			if(!cookiefortune)
				to_chat(user, SPAN_NOTICE("You slip the paper into [src]."))
				cookiefortune = W
				user.drop_inv_item_to_loc(W, src)
			else
				to_chat(user,SPAN_WARNING("[src] already has a fortune inside it!"))

//Break open the cookie first before eating it (with use)
/obj/item/reagent_container/food/snacks/fortunecookie/attack_self(mob/user)
	if(!cookie_broken)
		cookie_broken = TRUE
		playsound(user,'sound/effects/pillbottle.ogg',10,TRUE)
		name = "broken fortune cookie"
		update_icon()
		if(cookiefortune)
			to_chat(user,SPAN_NOTICE("You break open the fortune cookie, revealing a fortune inside!"))
			user.put_in_hands(cookiefortune)
			cookiefortune = null
		else
			to_chat(user, SPAN_WARNING("You break open the fortune cookie, but there's no fortune inside! Oh no!"))
	else
		. = ..()

//Override for clicking on yourself too
/obj/item/reagent_container/food/snacks/fortunecookie/attack(mob/M, mob/user)
	if(!cookie_broken)
		cookie_broken = TRUE
		playsound(user,'sound/effects/pillbottle.ogg',10,TRUE)
		name = "broken fortune cookie"
		update_icon()
		if(cookiefortune)
			to_chat(user,SPAN_NOTICE("You break open the fortune cookie, revealing a fortune inside!"))
			user.put_in_hands(cookiefortune)
			cookiefortune = null
		else
			to_chat(user, SPAN_WARNING("You break open the fortune cookie, but there's no fortune inside! Oh no!"))
	else
		. = ..()

/obj/item/reagent_container/food/snacks/fortunecookie/on_stored_atom_del(atom/movable/AM)
	if(AM == cookiefortune)
		cookiefortune = null

/obj/item/reagent_container/food/snacks/fortunecookie/prefilled/Initialize(mapload, fortune, numbers)
	. = ..()
	cookiefortune = new /obj/item/paper/fortune/premade(src, fortune, numbers)
