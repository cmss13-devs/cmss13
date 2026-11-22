/obj/item/storage/gum
	name = "Generic Brand Gum"
	desc = "This is a pack of generic gum, who manufactured this!?"
	icon = 'icons/obj/items/food/gum.dmi'
	icon_state = "generic"
	flags_obj = parent_type::flags_obj|OBJ_IS_HELMET_GARB
	storage_flags = STORAGE_DISABLE_USE_EMPTY
	w_class = SIZE_TINY
	max_w_class = SIZE_TINY
	throwforce = 1
	storage_slots = 7
	foldable = FALSE
	can_hold = list(
		/obj/item/reagent_container/food/gum,
		/obj/item/paper/wrapper,
	)
	var/list/reagents_per_stick = list(
		"sugar" = 4
	)
	var/gum_type = /obj/item/reagent_container/food/gum
	var/gum_color = "#e58a9a"
	var/packaging_opened = FALSE
	var/uses_unique_exmaine = FALSE


/obj/item/storage/gum/fill_preset_inventory()
	. = ..()
	flags_atom |= NOREACT
	for(var/i = 1 to storage_slots)
		var/obj/item/reagent_container/food/gum/gum = new gum_type(src)
		gum.gum_color = gum_color
		for(var/reag in reagents_per_stick)
			gum.reagents.add_reagent(reag, reagents_per_stick[reag])


/obj/item/storage/gum/update_icon()
	. = ..()
	var/gum_left = 0
	for(var/obj/item/reagent_container/food/gum in contents)
		gum_left++
	if(packaging_opened)
		if(gum_left > storage_slots/2)
			icon_state = "[initial(icon_state)]_o"
		else if(gum_left)
			icon_state = "[initial(icon_state)]_l"
		else
			icon_state = "[initial(icon_state)]_e"
	else
		icon_state = initial(icon_state)


/obj/item/storage/gum/get_examine_text(mob/user)
	. = ..()
	if(!uses_unique_exmaine)
		var/tally = 0
		for(var/obj/item/reagent_container/food/gum/gum in contents)
			tally++
		. += SPAN_NOTICE("It looks like it has [tally] sticks left.")


/obj/item/storage/gum/attack_self(mob/user)
	. = ..()
	if(!packaging_opened)
		to_chat(user, SPAN_NOTICE("You pull the tab at the end of the pack around itself, opening the fresh pack of gum!"))
		packaging_opened = TRUE
		update_icon()
	else
		var/obj/item/reagent_container/food/gum/gum = locate() in src
		if(gum && isnull(user.get_inactive_hand()))
			remove_from_storage(gum, get_turf(user))
			user.put_in_inactive_hand(gum)
			to_chat(user, SPAN_NOTICE("You take a stick of gum out of the pack with you other hand."))
			update_icon()

/obj/item/storage/gum/open(mob/user)
	if(packaging_opened)
		return ..()
	to_chat(user, SPAN_INFO("The pack is still sealed, pull the tab to open it first!"))

/obj/item/storage/gum/attack(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	if(!istype(target, /mob))
		return

	if(target == user && user.zone_selected == "mouth" && length(contents) > 0 && !user.wear_mask)
		var/obj/item/reagent_container/food/gum/gum = locate() in src
		if(gum)
			remove_from_storage(gum, get_turf(user))
			if(user.a_intent != INTENT_HARM)
				gum.unwrap(user, TRUE)
				to_chat(user, SPAN_NOTICE("You take a stick of gum out of the pack with your mouth, deftly seperating and removing its wrapper."))
			else
				to_chat(user, SPAN_NOTICE("You take a stick of gum out of the pack with your mouth, wrapper and all!"))
			user.equip_to_slot_if_possible(gum, WEAR_FACE)
	else if(length(contents) && tgui_alert(target, "[user] offers you a stick of gum, looks like its [src].", "Gum Offer", list("Take it", "Refuse")) == "Take it")
		if(!user.Adjacent(target)) // they may have moved while the prompt was open
			to_chat(target, SPAN_WARNING("You are too far away now!"))
			to_chat(user, SPAN_WARNING("[target] wanted one, but is too far away now"))
			return ..()
		var/obj/item/reagent_container/food/gum/gum = locate() in src
		if(gum)
			remove_from_storage(gum, get_turf(user))
			target.put_in_hands(gum)
			target.visible_message(SPAN_NOTICE("You take a stick of gum out of the pack offered by [user]."), SPAN_NOTICE("[target] took a stick of gum from the pack offered by [user]."))
	else
		..()


/obj/item/storage/gum/remove_from_storage(obj/item/W, atom/new_location, mob/user)
	. = ..()
	if(!length(contents))
		qdel(src)
	update_icon()


/obj/item/storage/gum/wridleys/spearmint
	name = "Wridley's Spearmint Gum"
	desc = "Sweet cool mint. Delictably green!"
	icon_state = "wridleys_spear"
	gum_color = "#73d188"
	reagents_per_stick = list(
		"sugar" = 4,
		"spearmint" = 4,
	)

/obj/item/storage/gum/wridleys/peppermint
	name = "Wridley's Peppermint Gum"
	desc = "Sweet & Spicy mint! Just like Christmas!"
	icon_state = "wridleys_pepp"
	gum_color = "#ff9898"
	reagents_per_stick = list(
		"sugar" = 4,
		"peppermint" = 4,
	)

/obj/item/storage/gum/wridleys/jucyfruit
	name = "Wridley's Jucy Fruit Gum"
	desc = "Sweet refreshingly unique fruity flavor!"
	icon_state = "wridleys_jucy"
	gum_color = "#f8f536"
	reagents_per_stick = list(
		"sugar" = 4,
		"jucyfruit" = 4,
	)

/obj/item/storage/gum/wridleys/bigred
	name = "Wridley's Big Red Gum"
	desc = "Spicy cinnamon gum, to tantilize the taste buds. WARNING: May contain dust."
	icon_state = "wridleys_red"
	gum_color = "#ff4f38"
	reagents_per_stick = list(
		"sugar" = 4,
		"cinnamon" = 4,
		"capsaicin" = 4,
	)

/obj/item/storage/gum/wridleys/usa
	name = "Wridley's USA hard gum"
	desc = "The most patriotic gum, for liberty lovers everywhere."
	icon_state = "wridleys_USA"
	gum_color = "#eed4ae"
	reagents_per_stick = list(
		"sugar" = 4,
		"freedom" = 4,
	)


/obj/item/storage/gum/obannons/classic
	name = "O'bannon's Classic Gum"
	desc = "Sweet classic strawberry flavor, sugarfree!"
	icon_state = "obannons"
	gum_color = "#ff75ba"
	reagents_per_stick = list(
		"saccharin" = 4,
		"strawberry" = 4,
	)

/obj/item/storage/gum/obannons/frost
	name = "O'bannon's Frost Gum"
	desc = "Dangerously cold, sure to refresh! Sugarfree!"
	icon_state = "obannons_frost"
	gum_color = "#35edf3"
	reagents_per_stick = list(
		"saccharin" = 4,
		"frostoil" = 4,
	)

/obj/item/storage/gum/obannons/apple
	name = "O'bannon's Sour Apple Gum"
	desc = "Tastefully sour green apple, to tantilize the tastebuds! Sugarfree!"
	icon_state = "obannons_apple"
	gum_color = "#72fd57"
	reagents_per_stick = list(
		"saccharin" = 4,
		"greenapple" = 4,
	)

/obj/item/storage/gum/obannons/berry
	name = "O'bannon's Mixed Berry Gum"
	desc = "Sweet and ripe mixed berry, taste the combination! Sugarfree!"
	icon_state = "obannons_berry"
	gum_color = "#a03875"
	reagents_per_stick = list(
		"saccharin" = 4,
		"berryjuice" = 4,
	)

/obj/item/storage/gum/obannons/citrus
	name = "O'bannon's Citrus Gum"
	desc = "A sweet delectable assortment of your favorite citrus flavors, sugarfree!"
	icon_state = "obannons_citrus"
	gum_color = "#ffca69"
	reagents_per_stick = list(
		"saccharin" = 4,
		"citrus" = 4,
	)


/obj/item/storage/gum/medichew/caffeine
	name = "MediChew Caffeine Gum"
	desc = "A sweet pickme up, for the sleep deprived service member. Mint flavor!"
	icon_state = "medichew_caff"
	gum_color = "#ffffff"
	reagents_per_stick = list(
		"sugar" = 2,
		"coffee" = 10,
		"toothpaste" = 2,
	)

/obj/item/storage/gum/medichew/nicotine
	name = "MediChew Nicotine Gum"
	desc = "Kick your habit, chew gum instead! Mint flavor!"
	icon_state = "medichew_nicot"
	gum_color = "#ffffff"
	reagents_per_stick = list(
		"sugar" = 2,
		"nicotine" = 10,
		"toothpaste" = 2,
	)

/obj/item/storage/gum/medichew/marijuana
	name = "MediChew Marijuana Gum"
	desc = "A special dose for those with unique medical needs. WARNING: unliscened redistribution is prohibited and could result in serious jailtime."
	icon_state = "medichew_marij"
	gum_color = "#ffffff"
	reagents_per_stick = list(
		"sugar" = 2,
		"space_drugs" = 15,
		"bicaridine" = 8,
		"kelotane" = 1,
	)


/obj/item/storage/gum/bigbubba/chew
	name = "Big Bubba Chew!"
	desc = "Specialty gum strips packed with flavor, for the big league players!"
	icon_state = "big_bubba_chew"
	gum_type = /obj/item/reagent_container/food/gum/chew
	storage_slots = 10
	uses_unique_exmaine = TRUE
	reagents_per_stick = list(
		"sugar" = 6,
		"gum" = 6,
	)

/obj/item/storage/gum/bigbubba/chew/get_examine_text(mob/user)
	. = ..()
	var/tally = 0
	for(var/obj/item/reagent_container/food/gum/gum in contents)
		tally++
	. += SPAN_NOTICE("It looks like it has [tally] handfulls left.")

/obj/item/storage/gum/bigbubba/hubba
	name = "Big Bubba Hubba Gum!"
	desc = "Large portions of Big Bubba's classic gum flavor, best for blowing bubbles!"
	icon_state = "big_bubba_hubba"
	gum_type = /obj/item/reagent_container/food/gum/cube
	storage_slots = 10
	uses_unique_exmaine = TRUE
	reagents_per_stick = list(
		"sugar" = 6,
		"gum" = 6,
	)

/obj/item/storage/gum/bigbubba/hubba/get_examine_text(mob/user)
	. = ..()
	var/tally = 0
	for(var/obj/item/reagent_container/food/gum/gum in contents)
		tally++
	. += SPAN_NOTICE("It looks like it has [tally] bits left.")

/obj/item/storage/gum/souto/classic
	name = "Souto Classic Gum"
	desc = "Souto's classic tangerine flavor, just like the drink!"
	icon_state = "souto_classic"
	gum_color = "#d64112"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_classic" = 6,
	)

/obj/item/storage/gum/souto/cherry
	name = "Souto Cherry Gum"
	desc = "Souto sweet tart cherry flavor, just like the drink!"
	icon_state = "souto_cherry"
	gum_color = "#9b1010"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_cherry" = 6,
	)

/obj/item/storage/gum/souto/lime
	name = "Souto Lime Gum"
	desc = "Souto tart lime flavor, just like the drink!"
	icon_state = "souto_lime"
	gum_color = "#5a9c1b"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_lime" = 6,
	)

/obj/item/storage/gum/souto/grape
	name = "Souto Grape Gum"
	desc = "Souto sweet ripe grape flavor, just like the drink!"
	icon_state = "souto_grape"
	gum_color = "#7a2e8a"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_grape" = 6,
	)

/obj/item/storage/gum/souto/blueraspberry
	name = "Souto Blueraspberry Gum"
	desc = "Souto blue raspberry flavor, just like the drink!"
	icon_state = "souto_blue"
	gum_color = "#4c8cd1"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_blueraspberry" = 6,
	)

/obj/item/storage/gum/souto/peach
	name = "Souto Peach Gum"
	desc = "Souto sweet peach flavor, just like the drink!"
	icon_state = "souto_peach"
	gum_color = "#ef9984"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_peach" = 6,
	)

/obj/item/storage/gum/souto/cranberry
	name = "Souto Cranberry Gum"
	desc = "Souto tart cranberry flavor, just like the drink!"
	icon_state = "souto_cran"
	gum_color = "#c73333"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_cranberry" = 6,
	)

/obj/item/storage/gum/souto/vanilla
	name = "Souto Vanilla Gum"
	desc = "Souto sweet aromatic vanilla flavor, just like the drink!"
	icon_state = "souto_vanilla"
	gum_color = "#ccb996"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_vanilla" = 6,
	)

/obj/item/storage/gum/souto/pineapple
	name = "Souto Pineapple Gum"
	desc = "Souto sweet tropical pineapple flavor, just like the drink!"
	icon_state = "souto_pine"
	gum_color = "#c7bb2a"
	reagents_per_stick = list(
		"sugar" = 2,
		"souto_pineapple" = 6,
	)

/obj/item/storage/gum/souto/special
	name = "Souto Special"
	desc = "A special mix of all your favorite Souto flavors, just like the drinks!"
	icon_state = "souto_special"
	gum_color = "#5f442d"
	reagents_per_stick = list(
		"sugar" = 1,
		"souto_classic" = 1,
		"souto_cherry" = 1,
		"souto_lime" = 1,
		"souto_grape" = 1,
		"souto_blueraspberry" = 1,
		"souto_peach" = 1,
		"souto_cranberry" = 1,
		"souto_vanilla" = 1,
		"souto_pineapple" = 1,
	)

