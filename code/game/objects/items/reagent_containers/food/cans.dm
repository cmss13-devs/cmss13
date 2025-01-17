/obj/item/reagent_container/food/drinks/cans
	var/canopened = FALSE
	var/crushed = FALSE
	gulp_size = 10
	icon = 'icons/obj/items/food/drinkcans.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/food_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/food_righthand.dmi'
	)

/obj/item/reagent_container/food/drinks/cans/attack_self(mob/user)
	..()

	if(crushed)
		return

	if (!canopened)
		playsound(src.loc,'sound/effects/canopen.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("You open the drink with an audible pop!"))
		canopened = TRUE

/obj/item/reagent_container/food/drinks/cans/attack_hand(mob/user)
	if(crushed)
		return ..()

	if (canopened && !reagents.total_volume)
		if(user.a_intent == INTENT_HARM)
			if(isturf(loc))
				if(user.zone_selected == "r_foot" || user.zone_selected == "l_foot" )
					crush_can(user)
					return FALSE
			else if(loc == user && src == user.get_inactive_hand())
				crush_can(user)
				return FALSE
	return ..()

/obj/item/reagent_container/food/drinks/cans/attack(mob/M, mob/user)
	if(crushed)
		return

	if(!canopened)
		to_chat(user, SPAN_NOTICE("You need to open the drink!"))
		return
	var/datum/reagents/R = src.reagents

	if(!R.total_volume || !R)
		if(M == user && M.a_intent == INTENT_HARM && M.zone_selected == "head")
			crush_can(M)
			return
		to_chat(user, SPAN_DANGER("The [src.name] is empty!"))
		return 0

	if(M == user)
		to_chat(M, SPAN_NOTICE("You swallow a gulp of [src]."))
		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return 1
	else if( istype(M, /mob/living/carbon/human) )
		if (!canopened)
			to_chat(user, SPAN_NOTICE("You need to open the drink!"))
			return

		user.affected_message(M,
			SPAN_HELPFUL("You <b>start feeding</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] starts feeding [user == M ? "themselves" : "[M]"] [src]."))
		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M)) return
		user.affected_message(M,
			SPAN_HELPFUL("You <b>fed</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>fed</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] fed [user == M ? "themselves" : "[M]"] [src]."))

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return 1

	return 0


/obj/item/reagent_container/food/drinks/cans/afterattack(obj/target, mob/user, proximity)
	if(crushed || !proximity) return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if (!canopened)
			to_chat(user, SPAN_NOTICE("You need to open the drink!"))
			return


	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if (!canopened)
			to_chat(user, SPAN_NOTICE("You need to open the drink!"))
			return

		if (istype(target, /obj/item/reagent_container/food/drinks/cans))
			var/obj/item/reagent_container/food/drinks/cans/cantarget = target
			if(!cantarget.canopened)
				to_chat(user, SPAN_NOTICE("You need to open the drink you want to pour into!"))
				return

	return ..()

/obj/item/reagent_container/food/drinks/cans/proc/crush_can(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/message
	var/obj/limb/L
	L = H.get_limb(H.zone_selected)

	if(src == H.get_inactive_hand())
		message = "between [user.gender == MALE ? "his" : "her"] hands"
		to_chat(user, SPAN_NOTICE("You start crushing the [name] between your hands!"))
		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC)) //crushing with hands takes great effort and might
			return
	else
		switch(user.zone_selected)
			if("head")
				if(!L)
					to_chat(user, SPAN_WARNING("You don't have a [H.zone_selected], can't crush yer can on nothing!"))
					return
				message = "against [user.gender == MALE ? "his" : "her"] head!"
				L.take_damage(brute = 3) //ouch! but you're a tough badass so it barely hurts
				H.UpdateDamageIcon()
			if("l_foot" , "r_foot")
				if(!L)
					to_chat(user, SPAN_WARNING("You don't have a [H.zone_selected], can't crush yer can under nothing!"))
					return
				message = "under [user.gender == MALE ? "his" : "her"] foot!"

	crushed = TRUE
	flags_atom &= ~OPENCONTAINER
	desc += "\nIts been crushed! A badass must have been through here..."
	icon_state = "[icon_state]_crushed"
	user.visible_message(SPAN_BOLDNOTICE("[user] crushed the [name] [message]"), null, null, CHAT_TYPE_FLUFF_ACTION)
	playsound(src,"sound/items/can_crush.ogg", 20, FALSE, 15)

//SODA

/obj/item/reagent_container/food/drinks/cans/classcola
	name = "\improper Classic Cola"
	desc = "A classic cola with a taste that's been around for centuries. Nobody can beat it."
	icon_state = "cola"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/classcola/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

/obj/item/reagent_container/food/drinks/cans/space_mountain_wind
	name = "\improper Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent("spacemountainwind", 30)

/obj/item/reagent_container/food/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "Consumption of Thirteen Loko may result in seizures, blindness, drunkenness, or even death. Please Drink Responsibly."
	desc_lore = "A rarity among modern markets, Thirteen Loko is an all-Earth original. With a name coined by the general consensus that only the mildly insane willing to imbibe it, this energy drink has garnered a notorious reputation for itself and a sizeable cult following to match it. After a series of legal proceedings by Weyland-Yutani, denatured cobra venom was removed from the recipe, much to the disappointment of the drink's consumers."
	icon_state = "thirteen_loko"
	center_of_mass = "x=16;y=8"

/obj/item/reagent_container/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent("thirteenloko", 30)

/obj/item/reagent_container/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors of chemicals that you can't pronounce."
	icon_state = "dr_gibb"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent("dr_gibb", 30)

/obj/item/reagent_container/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent("cola", 15)
	reagents.add_reagent("orangejuice", 15)

/obj/item/reagent_container/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent("space_up", 30)

/obj/item/reagent_container/food/drinks/cans/lemon_lime
	name = "lemon-lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent("lemon_lime", 30)

/obj/item/reagent_container/food/drinks/cans/iced_tea
	name = "iced tea can"
	desc = "Just like the squad redneck's grandmother used to buy."
	icon_state = "ice_tea_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent("icetea", 30)

/obj/item/reagent_container/food/drinks/cans/grape_juice
	name = "grape juice"
	desc = "A can of probably not grape juice."
	icon_state = "purple_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent("grapejuice", 30)

/obj/item/reagent_container/food/drinks/cans/tonic
	name = "tonic water"
	desc = "Step One: Tonic. Check. Step Two: Gin."
	icon_state = "tonic"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent("tonic", 30)

/obj/item/reagent_container/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Tap water's more refreshing cousin...according to those Europe-folk."
	icon_state = "sodawater"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 30)

//BODA

/obj/item/reagent_container/food/drinks/cans/boda
	name = "\improper Boda"
	desc = "State regulated soda beverage. Enjoy comrades."
	desc_lore = "Designed back in 2159, the advertising campaign for BODA started out as an attempt by the UPP to win the hearts and minds of colonists and settlers across the galaxy. Soon after, the ubiquitous cyan vendors and large supplies of the drink began to crop up in UA warehouses with seemingly no clear origin. Despite some concerns, after initial testing determined that the stored products were safe for consumption and surprisingly popular when blind-tested with focus groups, the strange surplus of BODA was authorized for usage within the UA-associated colonies. Subsequently, it enjoyed a relative popularity before falling into obscurity in the coming decades as supplies dwindled."
	icon_state = "boda"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/boda/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 30)

/obj/item/reagent_container/food/drinks/cans/bodaplus
	name = "\improper Boda-Plyus"
	desc = "State regulated soda beverage, now with added surplus flavoring. Enjoy comrades."
	icon_state = "blank_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/bodaplus/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

//WEYLAND-YUTANI

/obj/item/reagent_container/food/drinks/cans/cola
	name = "\improper Fruit-Beer"
	desc = "In theory, Mango flavored root beer sounds like a pretty good idea. Weyland-Yutani has disproved yet another theory with its latest line of cola. Canned by the Weyland-Yutani Corporation."
	icon_state = "fruit_beer"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent("fruit_beer", 30)

/obj/item/reagent_container/food/drinks/cans/waterbottle
	name = "\improper Weyland-Yutani Bottled Spring Water"
	desc = "Overpriced 'Spring' water. Bottled by the Weyland-Yutani Corporation."
	icon_state = "wy_water"
	center_of_mass = "x=15;y=8"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_righthand.dmi',
	)

/obj/item/reagent_container/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/reagent_container/food/drinks/cans/beer
	name = "\improper Weyland-Yutani Lite"
	desc = "Beer. You've dialed in your target. Time to fire for effect."
	icon_state = "beer"
	center_of_mass = "x=16;y=12"

/obj/item/reagent_container/food/drinks/cans/beer/Initialize()
	. = ..()
	reagents.add_reagent("beer", 30)

/obj/item/reagent_container/food/drinks/cans/ale
	name = "\improper Weyland-Yutani IPA"
	desc = "Beer's misunderstood cousin."
	icon_state = "ale"
	item_state = "beer"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/ale/Initialize()
	. = ..()
	reagents.add_reagent("ale", 30)

//SOUTO

/obj/item/reagent_container/food/drinks/cans/souto
	name = "\improper Souto Can"
	desc = "Canned in Havana."
	icon_state = "souto_classic"
	item_state = "souto_classic"
	center_of_mass = "x=16;y=10"
	embeddable = 1

/obj/item/reagent_container/food/drinks/cans/souto/diet
	name = "\improper Diet Souto"
	desc = "Now with 0% fruit juice! Canned in Havana"
	icon_state = "souto_diet_classic"
	item_state = "souto_diet_classic"

/obj/item/reagent_container/food/drinks/cans/souto/diet/Initialize()
	. = ..()
	reagents.add_reagent("water", 25)

/obj/item/reagent_container/food/drinks/cans/souto/classic
	name = "\improper Souto Classic"
	desc = "The can boldly proclaims it to be tangerine flavored. You can't help but think that's a lie. Canned in Havana."
	icon_state = "souto_classic"
	item_state = "souto_classic"

/obj/item/reagent_container/food/drinks/cans/souto/classic/Initialize()
	. = ..()
	reagents.add_reagent("souto_classic", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/classic
	name = "\improper Diet Souto"
	desc = "Now with 0% fruit juice! Canned in Havana"
	icon_state = "souto_diet_classic"
	item_state = "souto_diet_classic"

/obj/item/reagent_container/food/drinks/cans/souto/diet/classic/Initialize()
	. = ..()
	reagents.add_reagent("souto_classic", 25)

/obj/item/reagent_container/food/drinks/cans/souto/cherry
	name = "\improper Cherry Souto"
	desc = "Now with more artificial flavors! Canned in Havana"
	icon_state = "souto_cherry"
	item_state = "souto_cherry"

/obj/item/reagent_container/food/drinks/cans/souto/cherry/Initialize()
	. = ..()
	reagents.add_reagent("souto_cherry", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry
	name = "\improper Diet Cherry Souto"
	desc = "It's neither diet nor cherry flavored. Canned in Havanna."
	icon_state = "souto_diet_cherry"
	item_state = "souto_diet_cherry"

/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry/Initialize()
	. = ..()
	reagents.add_reagent("souto_cherry", 25)

/obj/item/reagent_container/food/drinks/cans/souto/lime
	name = "\improper Lime Souto"
	desc = "It's not bad. It's not good either, but it's not bad. Canned in Havana."
	icon_state = "souto_lime"
	item_state = "souto_lime"

/obj/item/reagent_container/food/drinks/cans/souto/lime/Initialize()
	. = ..()
	reagents.add_reagent("souto_lime", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/lime
	name = "\improper Diet Lime Souto"
	desc = "Ten kinds of acid, two cups of fake sugar, almost a full tank of carbon dioxide, and about 210 kPa all crammed into an aluminum can. What's not to love? Canned in Havana."
	icon_state = "souto_diet_lime"
	item_state = "souto_diet_lime"

/obj/item/reagent_container/food/drinks/cans/souto/diet/lime/Initialize()
	. = ..()
	reagents.add_reagent("souto_lime", 25)

/obj/item/reagent_container/food/drinks/cans/souto/grape
	name = "\improper Grape Souto"
	desc = "An old standby for soda flavors. This, however, tastes like grape flavored cough syrup. Canned in Havana."
	icon_state = "souto_grape"
	item_state = "souto_grape"

/obj/item/reagent_container/food/drinks/cans/souto/grape/Initialize()
	. = ..()
	reagents.add_reagent("souto_grape", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/grape
	name = "\improper Diet Grape Souto"
	desc = "You're fairly certain that this is just grape cough syrup and carbonated water. Canned in Havana."
	icon_state = "souto_diet_grape"
	item_state = "souto_diet_grape"

/obj/item/reagent_container/food/drinks/cans/souto/diet/grape/Initialize()
	. = ..()
	reagents.add_reagent("souto_grape", 25)

/obj/item/reagent_container/food/drinks/cans/souto/blue
	name = "\improper Blue Raspberry Souto"
	desc = "It tastes like the color blue. Technology really is amazing. Canned in Havana."
	icon_state = "souto_blueraspberry"
	item_state = "souto_blueraspberry"
	black_market_value = 10 //mendoza likes blue souto

/obj/item/reagent_container/food/drinks/cans/souto/blue/Initialize()
	. = ..()
	reagents.add_reagent("souto_blueraspberry", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/blue
	name = "\improper Diet Blue Raspberry Souto"
	desc = "WHAT A SCAM! It doesn't even taste like blue! At best, it tastes like cyan. Canned in Havana."
	icon_state = "souto_diet_blueraspberry"
	item_state = "souto_diet_blueraspberry"

/obj/item/reagent_container/food/drinks/cans/souto/diet/blue/Initialize()
	. = ..()
	reagents.add_reagent("souto_blueraspberry", 25)

/obj/item/reagent_container/food/drinks/cans/souto/peach
	name = "\improper Peach Souto"
	desc = "On one hand, it tastes pretty good. On the other hand, you think you can hear a peach pit rattling on the inside. Canned in Havana."
	icon_state = "souto_peach"
	item_state = "souto_peach"

/obj/item/reagent_container/food/drinks/cans/souto/peach/Initialize()
	. = ..()
	reagents.add_reagent("souto_peach", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/peach
	name = "\improper Diet Peach Souto"
	desc = "On one hand, it tastes pretty good. On the other hand, you think you can hear half of a peach pit rattling on the inside. Canned in Havana."
	icon_state = "souto_diet_peach"
	item_state = "souto_diet_peach"

/obj/item/reagent_container/food/drinks/cans/souto/diet/peach/Initialize()
	. = ..()
	reagents.add_reagent("souto_peach", 25)

/obj/item/reagent_container/food/drinks/cans/souto/cranberry
	name = "\improper Cranberry Souto"
	desc = "On closer inspection, the can reads, 'CRAMberry Souto.' What the Hell is a Cramberry? Canned in Havana."
	icon_state = "souto_cranberry"
	item_state = "souto_cranberry"

/obj/item/reagent_container/food/drinks/cans/souto/cranberry/Initialize()
	. = ..()
	reagents.add_reagent("souto_cranberry", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry
	name = "\improper Diet Cranberry Souto"
	desc = "This tastes more like prunes than cranberries. It's not bad; it's just wrong. Canned in Havana."
	icon_state = "souto_diet_cranberry"
	item_state = "souto_diet_cranberry"

/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry/Initialize()
	. = ..()
	reagents.add_reagent("souto_cranberry", 25)
	reagents.add_reagent("water", 25)

/obj/item/reagent_container/food/drinks/cans/souto/vanilla
	name = "\improper Vanilla Souto"
	desc = "When most soft drinks say 'vanilla,' they really mean their classic flavor with a bit of vanilla added. NOT THE SOUTO CORPORATION, BABY! This bad boy is filled to the brim with 100% pure carbonated vanilla extract! It tastes terrible. Canned in Havana."
	icon_state = "souto_vanilla"
	item_state = "souto_vanilla"

/obj/item/reagent_container/food/drinks/cans/souto/vanilla/Initialize()
	. = ..()
	reagents.add_reagent("souto_vanilla", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla
	name = "\improper Diet Vanilla Souto"
	desc = "This is a can of watery bitter vanilla extract. You can't possibly imagine who would greenlight such a concept. Canned in Havana."
	icon_state = "souto_diet_vanilla"
	item_state = "souto_diet_vanilla"

/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla/Initialize()
	. = ..()
	reagents.add_reagent("souto_vanilla", 25)
	reagents.add_reagent("water", 25)

/obj/item/reagent_container/food/drinks/cans/souto/pineapple
	name = "\improper Pineapple Souto"
	desc = "This tastes like battery acid with a full cup of sugar mixed in. Canned in Havana."
	icon_state = "souto_pineapple"
	item_state = "souto_pineapple"

/obj/item/reagent_container/food/drinks/cans/souto/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("souto_pineapple", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple
	name = "\improper Diet Pineapple Souto"
	desc = "This tastes like battery acid with a half cup of sugar mixed in. Canned in Havana."
	icon_state = "souto_diet_pineapple"
	item_state = "souto_diet_pineapple"

/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("souto_pineapple", 25)
	reagents.add_reagent("water", 25)

//ASPEN

/obj/item/reagent_container/food/drinks/cans/aspen
	name = "\improper Weyland-Yutani Aspen Beer"
	desc = "Pretty good when you get past the fact that it tastes like piss. Canned by the Weyland-Yutani Corporation."
	icon_state = "6_pack_1"
	item_state = "6_pack_1"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/aspen/Initialize()
	. = ..()
	reagents.add_reagent("beer", 50)
