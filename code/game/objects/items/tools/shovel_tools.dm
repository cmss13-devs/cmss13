
//*****************************Shovels********************************/

/obj/item/tool/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items/tools.dmi'
	icon_state = "shovel"
	item_state = "shovel"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 8
	throwforce = 4
	w_class = SIZE_MEDIUM
	matter = list("metal" = 50)

	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	var/dirt_overlay = "shovel_overlay"
	var/folded = FALSE
	/// 0 for no dirt, 1 for brown dirt, 2 for snow, 3 for big red.
	var/dirt_type = NO_DIRT
	var/shovelspeed = 30
	var/dirt_amt = 0
	var/dirt_amt_per_dig = 6


/obj/item/tool/shovel/update_icon()
	var/image/I = image(icon,src,dirt_overlay)
	switch(dirt_type) // We can actually shape the color for what environment we dig up our dirt in.
		if(DIRT_TYPE_GROUND)
			I.color = "#512A09"
		if(DIRT_TYPE_MARS)
			I.color = "#FF5500"
		if(DIRT_TYPE_SNOW)
			I.color = "#EBEBEB"
		if(DIRT_TYPE_SAND)
			I.color = "#ab804b"
		if(DIRT_TYPE_SHALE)
			I.color = "#1c2142"
	overlays -= I
	if(dirt_amt)
		overlays += I
	else
		I = null



/obj/item/tool/shovel/get_examine_text(mob/user)
	. = ..()
	if(dirt_amt)
		var/dirt_name = dirt_type == DIRT_TYPE_SNOW ? "snow" : "dirt"
		. += "It holds [dirt_amt] layer\s of [dirt_name]."

/obj/item/tool/shovel/attack_self(mob/user)
	..()
	add_fingerprint(user)

	if(dirt_amt)
		to_chat(user, SPAN_NOTICE("You dump the [dirt_type == DIRT_TYPE_SNOW ? "snow" : "dirt"]!"))
		if(dirt_type == DIRT_TYPE_SNOW)
			var/turf/T = get_turf(user.loc)
			var/obj/item/stack/snow/S = locate() in T
			if(S && S.amount < S.max_amount)
				S.amount += dirt_amt
			else
				new /obj/item/stack/snow(T, dirt_amt)
		dirt_amt = 0

	update_icon()


/obj/item/tool/shovel/afterattack(atom/target, mob/user, proximity)
	if(!proximity || folded || !isturf(target))
		return

	if(user.action_busy)
		return

	if(!dirt_amt)
		var/turf/T = target
		var/turfdirt = T.get_dirt_type()
		if(turfdirt)
			to_chat(user, SPAN_NOTICE("You start digging."))
			playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)
			if(!do_after(user, shovelspeed * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(user, SPAN_NOTICE("You stop digging."))
				return

			var/transfer_amount = dirt_amt_per_dig
			if(istype(T,/turf/open))
				var/turf/open/OT = T
				if(OT.bleed_layer)
					transfer_amount = min(OT.bleed_layer, dirt_amt_per_dig)
					if(istype(T, /turf/open/auto_turf))
						var/turf/open/auto_turf/AT = T
						AT.changing_layer(AT.bleed_layer - transfer_amount)
					else
						OT.bleed_layer -= transfer_amount
						OT.update_icon(1,0)
			to_chat(user, SPAN_NOTICE("You dig up some [dirt_type_to_name(turfdirt)]."))
			dirt_amt = transfer_amount
			dirt_type = turfdirt
			update_icon()

			var/digmore = FALSE
			var/sandbagcheck = FALSE
			while(dirt_amt > 0) // loop to check for leftover dirt and use it on nearby sandbags
				var/obj/item/stack/sandbags_empty/SB = user.get_inactive_hand()
				if(!istype(SB, /obj/item/stack/sandbags_empty)) // If no sandbag in off hand, checks around the user
					for(var/obj/item/stack/sandbags_empty/sandbags in range(1, user))
						SB = sandbags
						break

				if(!istype(SB, /obj/item/stack/sandbags_empty)) // Checks sandbag a second time to confirm, if none are found, cancels everything
					to_chat(user, SPAN_NOTICE("There are no sandbags nearby to fill up."))
					break

				if(sandbagcheck == FALSE)
					sandbagcheck = TRUE
					to_chat(user, SPAN_NOTICE("You begin filling the sandbags with [dirt_type_to_name(turfdirt)]."))
					if(!do_after(user, shovelspeed / 2, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) // Sandbag filling speed faster than normal, no skillchecks required since filling bags is almost instant
						to_chat(user, SPAN_NOTICE("You stop filling the sandbags with [dirt_type_to_name(turfdirt)]."))
						return

				if(get_dist(user, SB) > 1) // check if sandbag still beside them
					break

				if(SB.amount < 0) // check if sandbag is used by someone else
					SB = null
					continue

				if(dirt_amt <= 0) // check if the user has already used all the dirt
					continue

				var/dirttransfer_amount = min(SB.amount, dirt_amt)
				dirt_amt -= dirttransfer_amount
				update_icon()
				var/obj/item/stack/sandbags/new_bags = new(user.loc)
				new_bags.amount = dirttransfer_amount
				new_bags.add_to_stacks(user)
				var/replace = (user.get_inactive_hand() == SB)
				playsound(user.loc, "rustle", 30, 1, 6)
				SB.use(dirttransfer_amount)
				if(!SB && replace)
					user.put_in_hands(new_bags)

				if(dirt_amt <= 0) // Ends the loop when no dirt is left
					digmore = TRUE
					break
			if(digmore)
				afterattack(target, user, proximity)
// auto repeat ends

	else
		dump_shovel(target, user)

/obj/item/tool/shovel/proc/dump_shovel(atom/target, mob/user)
	var/turf/T = target
	to_chat(user, SPAN_NOTICE("You dump the [dirt_type_to_name(dirt_type)]!"))
	playsound(user.loc, "rustle", 30, 1, 6)
	if(dirt_type == DIRT_TYPE_SNOW)
		var/obj/item/stack/snow/S = locate() in T
		if(S && S.amount + dirt_amt < S.max_amount)
			S.amount += dirt_amt
		else
			new /obj/item/stack/snow(T, dirt_amt)
	dirt_amt = 0
	update_icon()

/obj/item/tool/shovel/proc/dirt_type_to_name(dirt_type)
	switch(dirt_type)
		if(DIRT_TYPE_GROUND)
			return "dirt"
		if(DIRT_TYPE_MARS)
			return "red sand"
		if(DIRT_TYPE_SNOW)
			return "snow"
		if(DIRT_TYPE_SAND)
			return "sand"
		if(DIRT_TYPE_SHALE)
			return "loam"

/obj/item/tool/shovel/proc/check_dirt_type()
	if(dirt_amt <= 0)
		dirt_type = NO_DIRT
	return dirt_type

/obj/item/tool/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_righthand.dmi',
	)
	icon_state = "spade"
	item_state = "spade"
	force = 5
	throwforce = 7
	w_class = SIZE_SMALL
	dirt_overlay = "spade_overlay"
	shovelspeed = 60
	dirt_amt_per_dig = 1

/obj/item/tool/shovel/spade/yautja
	icon = 'icons/obj/structures/props/hunter/32x32_hunter_props.dmi'

//Snow Shovel----------
/obj/item/tool/shovel/snow
	name = "snow shovel"
	desc = "I had enough winter for this year!"
	w_class = SIZE_LARGE
	force = 5
	throwforce = 3




// Entrenching tool.
/obj/item/tool/shovel/etool
	name = "entrenching tool"
	desc = "Used to dig holes and bash heads in. Folds in to fit in small spaces."
	icon = 'icons/obj/items/tools.dmi'
	icon_state = "etool"
	item_state = "etool"
	force = 30
	throwforce = 2
	w_class = SIZE_LARGE

	dirt_overlay = "etool_overlay"
	dirt_amt_per_dig = 5
	shovelspeed = 50


/obj/item/tool/shovel/etool/update_icon()
	if(folded)
		icon_state = "etool_c"
		item_state = "etool_c"
	else
		icon_state = "etool"
		item_state = "etool"
	..()


/obj/item/tool/shovel/etool/attack_self(mob/user as mob)
	folded = !folded
	if(folded)
		w_class = SIZE_SMALL
		force = 2
	else
		w_class = SIZE_LARGE
		force = 30
	..()

/obj/item/tool/shovel/etool/folded
	folded = TRUE
	w_class = SIZE_SMALL
	force = 2
	icon_state = "etool_c"
	item_state = "etool_c"
