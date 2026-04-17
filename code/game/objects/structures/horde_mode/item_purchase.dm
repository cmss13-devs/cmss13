/obj/structure/item_purchase
	name = "\improper item purchase"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "case"
	density = TRUE
	breakable = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE

	var/obj/primary_purchase = /obj/item/weapon/gun/rifle/m41a
	var/obj/secondary_purchase
	var/obj/tertiary_purchase
	var/obj/quaternary_purchase
	var/primary_cost = 1500
	var/secondary_cost = 500
	var/tertiary_cost
	var/quaternary_cost
	var/has_post_purchase_effect = FALSE
	var/has_hover_effect = TRUE
	var/obj/effect/hovering_effect
	var/obj/custom_hovering_icon

/obj/structure/item_purchase/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to purchase \a <b>[primary_purchase.name]</b> for [primary_cost] points.")
	if(secondary_purchase)
		. += SPAN_NOTICE("Use <b>DISARM INTENT</b> to purchase \a <b>[secondary_purchase.name]</b> for [secondary_cost] points.")
	if(tertiary_purchase)
		. += SPAN_NOTICE("Use <b>GRAB INTENT</b> to purchase \a <b>[tertiary_purchase.name]</b> for [tertiary_cost] points.")
	if(quaternary_purchase)
		. += SPAN_NOTICE("Use <b>HARM INTENT</b> to purchase \a <b>[quaternary_purchase.name]</b> for [quaternary_cost] points.")

/obj/structure/item_purchase/Initialize(mapload, ...)
	. = ..()
	if(has_hover_effect)
		hovering_effect = new /obj/effect/item_purchase(loc)
		if(!custom_hovering_icon)
			hovering_effect.icon = primary_purchase.icon
			hovering_effect.icon_state = primary_purchase.icon_state
			hovering_effect.name = primary_purchase.name
			hovering_effect.desc = primary_purchase.desc
		else
			hovering_effect.icon = custom_hovering_icon.icon
			hovering_effect.icon_state = custom_hovering_icon.icon_state
			hovering_effect.name = custom_hovering_icon.name
			hovering_effect.desc = custom_hovering_icon.desc

/obj/structure/item_purchase/Destroy()
	. = ..()
	QDEL_NULL(hovering_effect)

/obj/structure/item_purchase/attack_hand(mob/user)
	var/obj/item/purchased_item

	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost))
			return
		purchased_item = new primary_purchase(loc)

	if(user.a_intent == INTENT_DISARM && !isnull(secondary_purchase))
		if(!SShorde_mode.handle_purchase(user, secondary_cost))
			return
		purchased_item = new secondary_purchase(loc)

	if(user.a_intent == INTENT_GRAB && !isnull(tertiary_purchase))
		if(!SShorde_mode.handle_purchase(user, tertiary_cost))
			return
		purchased_item = new tertiary_purchase(loc)

	if(user.a_intent == INTENT_HARM && !isnull(quaternary_purchase))
		if(!SShorde_mode.handle_purchase(user, quaternary_cost))
			return
		purchased_item = new quaternary_purchase(loc)

	if(isnull(purchased_item))
		return

	if(istype(purchased_item, /obj/item/weapon/gun))
		playsound(user.loc, 'sound/effects/horde_mode/purchase_weapon.ogg')
	else
		playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')
	if(has_post_purchase_effect)
		post_purchase_effect(purchased_item)
	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/proc/post_purchase_effect(purchased_item)
	return


////////////////////
// ITEM PURCHASES //
////////////////////
/obj/structure/item_purchase/m41a
	name = "\improper M41A pulse rifle MK2 case"
	secondary_purchase = /obj/item/ammo_magazine/rifle


/obj/structure/item_purchase/abr40
	name = "\improper ABR-40 hunting rifle case"
	primary_purchase = /obj/item/weapon/gun/rifle/l42a/abr40
	secondary_purchase = /obj/item/ammo_magazine/rifle/l42a/abr40
	primary_cost = 400
	secondary_cost = 300
	has_post_purchase_effect = TRUE

/obj/structure/item_purchase/abr40/post_purchase_effect(obj/item/weapon/gun/purchased_gun)
	if(istype(src, /obj/item/weapon/gun))
		purchased_gun.damage_mult = 1.5

/obj/structure/item_purchase/m39
	name = "\improper M39 submachinegun case"
	primary_purchase = /obj/item/weapon/gun/smg/m39
	secondary_purchase = /obj/item/ammo_magazine/smg/m39
	primary_cost = 1000
	secondary_cost = 400


/obj/structure/item_purchase/machete
	name = "\improper M2132 machete case"
	custom_hovering_icon = /obj/item/weapon/sword/machete
	primary_purchase = /obj/item/storage/large_holster/machete/full
	secondary_purchase = /obj/item/storage/pouch/machete/full
	primary_cost = 800
	secondary_cost = 1200
	has_post_purchase_effect = TRUE

/obj/structure/item_purchase/machete/post_purchase_effect(obj/item/purchased_item)
	for(var/obj/item/weapon/machete in purchased_item.contents)
		machete.force += MELEE_FORCE_WEAK

/obj/structure/item_purchase/sentry
	name = "\improper disposable UA 571-C sentry gun case"
	desc = "A deployable, disposable, semi-automated turret with AI targeting capabilities. Hits hard, but only contains 150 rounds of ammo. Once it runs dry, say goodbye."
	primary_purchase = /obj/item/defenses/handheld/sentry/horde_mode
	primary_cost = 2000

/obj/structure/item_purchase/sentry/attack_hand(mob/user)
	if(SShorde_mode.sentries_active >= SShorde_mode.max_sentries)
		to_chat(user, SPAN_WARNING("There are too many sentries in action!"))
		return
	. = ..()

/obj/structure/item_purchase/sentry/get_examine_text(mob/user)
	. = ..()
	. += SPAN_DANGER("Purchase limit: <b>[SShorde_mode.sentries_active]/[SShorde_mode.max_sentries]</b>")

/obj/structure/item_purchase/hedp
	name = "\improper M40 HEDP grenade crate"
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "nade_placeholder"
	primary_purchase = /obj/item/explosive/grenade/high_explosive
	primary_cost = 200
	pixel_x = -1

/obj/structure/item_purchase/gear
	name = "\improper gear case"
	icon_state = "closed_woodcrate"
	primary_purchase = /obj/item/clothing/accessory/storage/droppouch
	secondary_purchase = /obj/item/storage/pouch/magazine
	tertiary_purchase = /obj/item/storage/belt/marine
	quaternary_purchase = /obj/item/storage/pouch/shotgun
	primary_cost = 600
	secondary_cost = 400
	tertiary_cost = 600
	quaternary_cost = 500

/obj/structure/item_purchase/firstaid
	name = "\improper basic medical equipment"
	icon_state = "closed_medical"
	custom_hovering_icon = /obj/item/storage/firstaid
	primary_purchase = /obj/item/stack/medical/bruise_pack
	secondary_purchase = /obj/item/stack/medical/ointment
	tertiary_purchase =  /obj/item/reagent_container/hypospray/autoinjector/merabicard
	quaternary_purchase = /obj/item/reagent_container/hypospray/autoinjector/keloderm
	primary_cost = 200
	secondary_cost = 200
	tertiary_cost = 600
	quaternary_cost = 600

/obj/structure/item_purchase/firstaid_adv
	name = "\improper advanced medical equipment"
	icon_state = "closed_medical"
	custom_hovering_icon = /obj/item/storage/firstaid/adv
	primary_purchase = /obj/item/horde_mode/stim/injector/healing
	primary_cost = 600

/obj/structure/horde_mode_dump
	name = "trash cart"
	desc = "It seems bottomless, really."
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "open_trashcart"
	var/list/acceptable_items = list(/obj/item/weapon/gun, /obj/item/ammo_magazine, /obj/item/clothing/accessory/storage, /obj/item/storage/pouch/magazine, /obj/item/storage/belt/marine, /obj/item/storage/pouch/shotgun)

/obj/structure/horde_mode_dump/Initialize(mapload, ...)
	. = ..()
	add_filter("outline", 1, outline_filter(size = 1, color = COLOR_WHITE, flags = OUTLINE_SHARP))

/obj/structure/horde_mode_dump/attackby(obj/item/weapon, mob/user)
	if(user.a_intent != INTENT_HELP)
		return

	if(istype(weapon, /obj/item/ammo_magazine/handful) || !is_type_in_list(weapon, acceptable_items))
		to_chat(user, SPAN_WARNING("You can't dump that!"))
		return

	if(isgun(weapon))
		SShorde_mode.handle_purchase(user, -400)
	else
		SShorde_mode.handle_purchase(user, -200)
	to_chat(user, SPAN_NOTICE("You dump [weapon] into [src]."))
	qdel(weapon)
	playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')

/obj/structure/horde_mode_dump/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to sell unneeded weapons and magazines. Weapons are rewarded with 400 points, while magazines are rewarded with 200.")

///////////////
// OBSTACLES //
///////////////
/obj/structure/item_purchase/door
	name = "door"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	icon_state = "door_closed"
	has_hover_effect = FALSE
	primary_purchase = null
	primary_cost = 500
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	var/door_id = 0
	var/width = 1
	var/list/filler_turfs = list()
	var/unlock_area

/obj/structure/item_purchase/door/Initialize(mapload, ...)
	. = ..()
	handle_multidoor()

/obj/structure/item_purchase/door/attack_hand(mob/user)
	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost))
			return

		if(unlock_area)
			for(var/area/horde_mode/area_to_unlock in SShorde_mode.map_areas)
				if(!istype(area_to_unlock, unlock_area))
					continue
				area_to_unlock.unlocked = TRUE
				break

		for(var/obj/structure/item_purchase/door/doors_in_area in loc.loc)
			if(doors_in_area.door_id == door_id)
				var/obj/structure/prop/horde_mode/door_open/open = new(doors_in_area.loc)
				open.icon = icon
				open.dir = dir
				qdel(doors_in_area)

		playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')

/obj/structure/item_purchase/door/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to clear the way for [primary_cost] points.")


/// Also refreshes filler_turfs list.
/obj/structure/item_purchase/door/proc/change_filler_opacity(new_opacity)
	// I have no idea why do we null opacity first before... changing it
	for(var/turf/filler_turf as anything in filler_turfs)
		filler_turf.set_opacity(null)

	filler_turfs = list()
	for(var/turf/filler as anything in locate_filler_turfs())
		filler.set_opacity(new_opacity)
		filler_turfs += filler

/// Updates collision box and opacity of multi_tile airlocks.
/obj/structure/item_purchase/door/proc/handle_multidoor()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size
		change_filler_opacity(opacity)

/// Finds turfs which should be filler ones.
/obj/structure/item_purchase/door/proc/locate_filler_turfs()
	var/turf/filler_temp
	var/list/located_turfs = list()

	for(var/i in 1 to width - 1)
		if (dir in list(EAST, WEST))
			filler_temp = locate(x + i, y, z)
		else
			filler_temp = locate(x, y + i, z)
		if (filler_temp)
			located_turfs += filler_temp
	return located_turfs

/obj/structure/item_purchase/door/wide
	icon = 'icons/obj/structures/doors/2x1personaldoor.dmi'
	width = 2

/obj/structure/prop/horde_mode/door_open
	name = "door"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	icon_state = "door_open"

/obj/structure/prop/horde_mode/door_open/Initialize(mapload, ...)
	. = ..()
	playsound(loc, 'sound/machines/airlock.ogg', 25, 0)
	animate(src, icon_state = "door_opening", time = 0.5 SECONDS)
	animate(icon_state = "door_open", time = 0.5 SECONDS)

/////////////////////
// REFILL STATIONS //
/////////////////////
/obj/structure/item_purchase/injector_refill
	name = "weymed refill station"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "wallmed"
	custom_hovering_icon = /obj/item/storage/firstaid
	primary_purchase = null
	primary_cost = 300
	has_hover_effect = FALSE

/obj/structure/item_purchase/injector_refill/Initialize(mapload, ...)
	. = ..()
	add_filter("outline", 1, outline_filter(size = 1, color = COLOR_WHITE, flags = OUTLINE_SHARP))

/obj/structure/item_purchase/injector_refill/attackby(obj/item/injector, mob/user)
	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector))
		to_chat(user, SPAN_WARNING("You can't refill this!"))
		return
	if(injector.reagents.total_volume == injector.reagents.maximum_volume)
		to_chat(user, SPAN_WARNING("[injector] is already full!"))
		return

	var/obj/item/purchased_item

	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost))
			return
		purchased_item = new injector.type(loc)
		playsound(src, 'sound/effects/refill.ogg', 25, 1, 3)
		qdel(injector)

	to_chat(user, SPAN_NOTICE("You refill [purchased_item]."))
	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/injector_refill/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to refill your autoinjector for [primary_cost] points	.")

/obj/structure/item_purchase/injector_refill/attack_hand(mob/user)
	return

/obj/structure/item_purchase/ammo_refill
	name = "ammo dump"
	desc = "There's a bunch of ammo sitting here. Shotgun shells, rifle, submachinegun and pistol rounds, flamer tanks... You could probably make use of it."
	icon_state = "closed_green"
	custom_hovering_icon = /obj/item/ammo_box/rounds
	primary_purchase = null
	primary_cost = 300 // RIFLES
	secondary_cost = 250 // SMGS
	tertiary_cost = 200 // PISTOLS
	quaternary_cost = 600 // everything else

/obj/structure/item_purchase/ammo_refill/Initialize(mapload, ...)
	. = ..()
	hovering_effect.overlays += image(icon = 'icons/obj/items/weapons/guns/ammo_boxes/handfuls.dmi', icon_state = "rounds_reg")

/obj/structure/item_purchase/ammo_refill/attackby(obj/item/ammo_magazine/magazine, mob/user)
	if(!istype(magazine, /obj/item/ammo_magazine) || istype(magazine, /obj/item/ammo_magazine/handful))
		to_chat(user, SPAN_WARNING("You can't refill this!"))
		return
	if(magazine.current_rounds == magazine.max_rounds && !istype(magazine, /obj/item/ammo_magazine/flamer_tank))
		to_chat(user, SPAN_WARNING("[magazine] is already full!"))
		return
	if(istype(magazine, /obj/item/ammo_magazine/flamer_tank))
		var/obj/item/ammo_magazine/flamer_tank/tank = src
		if(length(tank.reagents.reagent_list) >= tank.max_rounds)
			to_chat(user, SPAN_WARNING("[tank] is already full!"))
			return

	var/magazine_type
	if(istype(magazine, /obj/item/ammo_magazine/pistol))
		magazine_type = "pistol"
	else if(istype(magazine, /obj/item/ammo_magazine/rifle))
		magazine_type = "rifle"
	else if(istype(magazine, /obj/item/ammo_magazine/smg))
		magazine_type = "smg"
	else
		magazine_type = "other"

	var/actual_cost
	switch(magazine_type)
		if("rifle")
			actual_cost = primary_cost
		if("smg")
			actual_cost = secondary_cost
		if("pistol")
			actual_cost = tertiary_cost
		if("other")
			actual_cost = quaternary_cost

	var/obj/item/purchased_item
	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, actual_cost))
			return
		purchased_item = new magazine.type(loc)
		if(istype(purchased_item, /obj/item/ammo_magazine/flamer_tank))
			playsound(src, 'sound/effects/refill.ogg', 50, 1, 3)
		else
			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 50 , 1)
		qdel(magazine)

	to_chat(user, SPAN_NOTICE("You refill [purchased_item]."))
	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/ammo_refill/attack_hand(mob/user)
	return

/obj/structure/item_purchase/ammo_refill/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += desc
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to refill your magazine: \n<b>rifle magazine</b> - [primary_cost] points\n<b>SMG magazine</b> - [secondary_cost] points\n<b>pistol magazine</b> - [tertiary_cost] points\n<b>other magazines</b> - [quaternary_cost] points")


///////////////////
// PERK MACHINES //
///////////////////
/obj/structure/item_purchase/perk_machine
	name = "Juggernaut Souto machine"
	desc = "This drink is infused with special protein chains that decrease prostaglandin production, along with enhancing the downstream of nitric oxide pathways inside the body. This ultimately leads to a weaker pain response and a stronger blood flow, allowing for the user to stay standing for a longer period of time. It's cranberry flavour, too!"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "Cola_Machine"
	primary_cost = 3500
	primary_purchase = /obj/item/perk_bottle
	pixel_x = -1
	var/image/soda_overlay
	var/soda_overlay_color = "#fd5656" //no fitting predefined color, sadly

/obj/structure/item_purchase/perk_machine/Initialize(mapload, ...)
	. = ..()
	set_light(2, 1, soda_overlay_color)
	hovering_effect.pixel_y = 24
	soda_overlay = image(icon, icon_state = "+Cola_Machine_overlay")
	soda_overlay.color = soda_overlay_color
	overlays += soda_overlay

/obj/item/perk_bottle
	name = "\improper Juggernaut Souto"
	desc = "When you need some help to get by, something to make you big and strong..."
	icon = 'icons/obj/items/food/drinkcans.dmi'
	icon_state = "souto_cranberry"
	var/perk_trait = TRAIT_PERK_JUGGERNAUT

/obj/item/perk_bottle/attack_self(mob/user)
	. = ..()
	drink(user)

/obj/item/perk_bottle/attack(mob/attacked_mob, mob/user)
	. = ..()
	if(attacked_mob == user)
		drink(user)

/obj/item/perk_bottle/interact(mob/user)
	. = ..()
	drink(user)

/obj/item/perk_bottle/proc/drink(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, perk_trait))
		to_chat(user, SPAN_WARNING("You've already drank this Souto!"))
		return

	playsound(user.loc, 'sound/effects/canopen.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE("You start gulping down [src]..."))
	if(!do_after(user, 4 SECONDS, INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC))
		return

	playsound(user.loc, 'sound/items/drink.ogg', 15, 1)
	ADD_TRAIT(user, perk_trait, PERK_TRAIT)
	to_chat(user, SPAN_NOTICE("You douse your thirst with [src]. That hits the spot!"))
	qdel(src)

/obj/structure/item_purchase/perk_machine/speed
	name = "Speed Souto machine"
	desc = "This drink is infused with chemicals that put the body's adrenal glands into overdrive, making them constantly pump out small amounts of adrenaline at a steady pace. The adrenal medulla is enhanced, allowing it to regulate epinephrine's effect on the body even more-so than before, which helps the heart handle the increased rush. It's pineapple flavour, too!"
	primary_cost = 3000
	primary_purchase = /obj/item/perk_bottle/speed
	soda_overlay_color = COLOR_YELLOW

/obj/item/perk_bottle/speed
	name = "\improper Speed Souto"
	desc = "When you need some extra running, when you need some extra time..."
	icon = 'icons/obj/items/food/drinkcans.dmi'
	icon_state = "souto_pineapple"
	perk_trait = TRAIT_PERK_SPEED

/obj/structure/item_purchase/perk_machine/explosive_resistance
	name = "Boom Souto machine"
	desc = "This drink is infused with specialized myoblasts, which heighten the framework of connective tissue found around the muscles of the body. This leads to a strengthened muscle tissue, especially against shockwaves and blasts. It's grape flavour, too!"
	primary_cost = 2500
	primary_purchase = /obj/item/perk_bottle/explosive_resistance
	soda_overlay_color = LIGHT_COLOR_PINK

/obj/item/perk_bottle/explosive_resistance
	name = "\improper Boom Souto"
	desc = "Everybody needs some more, of your lovin', your explosive lovin'..."
	icon = 'icons/obj/items/food/drinkcans.dmi'
	icon_state = "souto_grape"
	perk_trait = TRAIT_PERK_EXPLOSIVE_RESISTANCE

/obj/structure/item_purchase/perk_machine/revive
	name = "Revive Souto machine"
	desc = "This drink contains cardiostabilizing lymphatic cells that immediately kickstart the user's heart again if it ceases function. It's raspberry flavour, too!"
	primary_cost = 2000
	primary_purchase = /obj/item/perk_bottle/revive
	soda_overlay_color = "#7da8fd"

/obj/item/perk_bottle/revive
	name = "\improper Revive Souto"
	desc = "When everything's been dragging you down, grabbed you by the hair and pulled you to the ground..."
	icon = 'icons/obj/items/food/drinkcans.dmi'
	icon_state = "souto_blueraspberry"
	perk_trait = TRAIT_PERK_REVIVE

/obj/structure/item_purchase/perk_machine/gunnut
	name = "Gun Nut Souto machine"
	desc = "A collaborative effort between ARMAT and the Souto company, this drink promises to increase your effectiveness with firearms by twofold. Or even more! How does it work? You have no idea, and neither do they... Supposedly tastes like root beer."
	primary_cost = 2000
	primary_purchase = /obj/item/perk_bottle/gunnut
	soda_overlay_color = "#E97256"

/obj/item/perk_bottle/gunnut
	name = "\improper Gun Nut Souto"
	desc = "When you need some help, reach for the root beer shelf..."
	icon = 'icons/obj/items/food/drinkcans.dmi'
	icon_state = "souto_diet_peach"
	perk_trait = TRAIT_PERK_GUNNUT

/////////////////
// MYSTERY BOX //
/////////////////
/obj/structure/mystery_purchase
	name = "mystery box"
	icon = 'icons/obj/structures/crates.dmi'
	desc = "Do you feel lucky?"
	icon_state = "closed_woodcrate"
	density = TRUE
	breakable = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/obj/effect/hovering_effect
	var/list/high_tier_gear = list(/obj/item/weapon/gun/flamer/m240)
	var/list/med_tier_gear = list(/obj/item/weapon/gun/shotgun/combat/buckshot)
	var/list/low_tier_gear = list(/obj/item/weapon/gun/rifle/m4ra)
	var/cost = 750
	var/obj/item/picked_item
	var/mob/living/last_used_by
	var/is_spinning = FALSE
	var/can_refund = TRUE
	var/cost_increase = 1
	///The proper icon_state for the object. Uses the icons in crates.dmi without the closed_ or open_ prefix.
	var/crate_variant = "woodcrate"

/obj/structure/mystery_purchase/Initialize(mapload, ...)
	. = ..()
	hovering_effect = new /obj/effect/item_purchase/mystery(loc)
	icon_state = "closed_[crate_variant]"

/obj/structure/mystery_purchase/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to get a random item for [round(cost * cost_increase, 5)] points.")
	if(can_refund)
		. += SPAN_NOTICE("Don't like the item? Use <b>DISARM INTENT</b> to get half of your points back.")
	else
		. += SPAN_DANGER("Don't like the item? Too bad. Suck it up.")

/obj/structure/mystery_purchase/attack_hand(mob/user)
	if(is_spinning)
		return

	if(picked_item)
		if(user.a_intent == INTENT_HELP)
			pick_up_item(user)
			return
		if(user.a_intent == INTENT_DISARM && can_refund)
			refund_item(user)
			return

	if(!SShorde_mode.handle_purchase(user, round(cost * cost_increase, 5)) || user.a_intent != INTENT_HELP)
		return

	last_used_by = user
	picked_item = handle_mystery_item()
	mystery_purchase_effect()

/obj/structure/mystery_purchase/proc/mystery_purchase_effect()
	is_spinning = TRUE
	playsound(loc, 'sound/effects/horde_mode/mystery_purchase.ogg')
	sleep(0.25 SECONDS)
	icon_state = "open_[crate_variant]"
	sleep(0.25 SECONDS)
	for(var/i = 0, i < 16, i++)
		var/obj/item/random_item = pick(pick(low_tier_gear), pick(med_tier_gear), pick(high_tier_gear))
		hovering_effect.icon = random_item.icon
		hovering_effect.icon_state = random_item.icon_state
		sleep(0.3 SECONDS)

	is_spinning = FALSE
	hovering_effect.name = picked_item.name
	hovering_effect.desc = picked_item.desc
	hovering_effect.icon = picked_item.icon
	hovering_effect.icon_state = picked_item.icon_state
	hovering_effect.transition_filter("outline", list(color = COLOR_YELLOW), 0.25 SECONDS, QUAD_EASING)
	INVOKE_ASYNC(src, PROC_REF(blink_effect))

/obj/structure/mystery_purchase/proc/pick_up_item(mob/user)
	if(last_used_by != user)
		to_chat(user, SPAN_WARNING("That's not yours!"))
		return

	var/obj/item/purchased_item = new picked_item(loc)
	user.put_in_hands(purchased_item)
	reset_hovering_effect()
	picked_item = null

/obj/structure/mystery_purchase/proc/refund_item(mob/user)
	if(last_used_by != user)
		to_chat(user, SPAN_WARNING("That's not yours!"))
		return

	SShorde_mode.handle_purchase(user, -(cost/2))
	playsound(loc, 'sound/effects/horde_mode/purchase_weapon.ogg')
	reset_hovering_effect()
	picked_item = null

/obj/structure/mystery_purchase/proc/blink_effect()
	if(is_spinning)
		return
	sleep(4 SECONDS)
	for(var/i = 0, i < 20, i++)
		if(is_spinning || !picked_item)
			return
		hovering_effect.alpha = 0
		sleep((0.5 - i / 10) SECONDS)
		hovering_effect.alpha = 255
		sleep((0.5 - i / 10) SECONDS)
	reset_hovering_effect()
	picked_item = null

/obj/structure/mystery_purchase/proc/reset_hovering_effect()
	hovering_effect.name = initial(hovering_effect.name)
	hovering_effect.desc = initial(hovering_effect.desc)
	hovering_effect.icon = initial(hovering_effect.icon)
	hovering_effect.icon_state = initial(hovering_effect.icon_state)
	hovering_effect.alpha = 255
	hovering_effect.overlays = null
	hovering_effect.transition_filter("outline", list(color = COLOR_WHITE), 0.25 SECONDS, QUAD_EASING)
	icon_state = "closed_[crate_variant]"

/obj/structure/mystery_purchase/proc/handle_mystery_item()
	if(prob(10 + SShorde_mode.round))
		return pick(high_tier_gear)
	return pick(pick(med_tier_gear), pick(low_tier_gear))


// Goodie box
/////////////////////

/obj/structure/mystery_purchase/goodies
	name = "mystery goodies box"
	desc = "They're not weapons, but they could be just as good as guns."
	icon_state = "closed_ammo_alt"
	crate_variant = "ammo_alt"
	high_tier_gear = list(/obj/item/horde_mode/stim/cipher, /obj/item/weapon/shield/riot/metal, /obj/item/stack/medical/advanced/ointment/upgraded, /obj/item/stack/medical/advanced/bruise_pack/upgraded, /obj/item/horde_mode/stim/injector/stat_mod/speed, /obj/item/horde_mode/stim/injector/stat_mod/health)
	med_tier_gear = list(/obj/item/horde_mode/stim/injector/speed, /obj/item/horde_mode/stim/injector/max_health)
	low_tier_gear = list(/obj/item/horde_mode/stim/injector/healing, /obj/item/stack/medical/advanced/bruise_pack, /obj/item/stack/medical/advanced/ointment)
	cost = 500

/obj/structure/mystery_purchase/goodies/get_examine_text(mob/user)
	. = ..()
	. += SPAN_BOLDWARNING("The price of opening this box will increase by 10% points every time you pick up an item.")

/obj/structure/mystery_purchase/goodies/mystery_purchase_effect()
	is_spinning = TRUE
	playsound(loc, 'sound/effects/horde_mode/mystery_purchase.ogg')
	sleep(0.25 SECONDS)
	icon_state = "open_[crate_variant]"
	sleep(0.25 SECONDS)
	for(var/i = 0, i < 16, i++)
		var/obj/item/random_item = pick(pick(low_tier_gear), pick(med_tier_gear), pick(high_tier_gear))
		hovering_effect.overlays = null
		hovering_effect.icon = random_item.icon
		hovering_effect.icon_state = random_item.icon_state
		set_item_overlay(random_item)
		sleep(0.3 SECONDS)

	is_spinning = FALSE
	hovering_effect.overlays = null
	hovering_effect.name = picked_item.name
	hovering_effect.desc = picked_item.desc
	hovering_effect.icon = picked_item.icon
	hovering_effect.icon_state = picked_item.icon_state
	hovering_effect.transition_filter("outline", list(color = COLOR_YELLOW), 0.25 SECONDS, QUAD_EASING)
	set_item_overlay(picked_item)
	INVOKE_ASYNC(src, PROC_REF(blink_effect))

/obj/structure/mystery_purchase/goodies/proc/set_item_overlay(obj/item/random_item)
	if(ispath(random_item, /obj/item/horde_mode/stim))
		var/obj/item/horde_mode/stim/picked_stim = random_item
		var/image/reagent_image = image(picked_stim.icon)
		hovering_effect.overlays += reagent_image

/obj/structure/mystery_purchase/goodies/pick_up_item(mob/user)
	. = ..()
	cost_increase += 0.1

// Weapon mystery box
/////////////////////
/obj/structure/mystery_purchase/weapons
	high_tier_gear = list(/obj/item/weapon/gun/flamer/m240, /obj/item/weapon/gun/rifle/m46c/horde_mode, /obj/item/weapon/gun/shotgun/combat/marsoc, /obj/item/weapon/gun/rifle/m41aMK1)
	med_tier_gear = list(/obj/item/weapon/gun/lever_action/r4t, /obj/item/weapon/gun/shotgun/combat/buckshot, /obj/item/weapon/gun/rifle/mar40/lmg, /obj/item/weapon/gun/rifle/m41a, /obj/item/weapon/gun/rifle/type71/carbine, /obj/item/weapon/gun/rifle/lmg, /obj/item/weapon/gun/rifle/xm177)
	low_tier_gear = list(/obj/item/weapon/gun/rifle/m4ra, /obj/item/weapon/gun/smg/mp5, /obj/item/weapon/gun/smg/fp9000, /obj/item/weapon/gun/rifle/mar40/lmg, /obj/item/weapon/gun/rifle/mar40/carbine)

/obj/structure/mystery_purchase/weapons/pick_up_item(mob/user)
	if(last_used_by != user)
		to_chat(user, SPAN_WARNING("That's not yours!"))
		return

	var/obj/item/weapon/gun/purchased_gun = new picked_item(loc)
	var/ammo_to_give = purchased_gun.current_mag.type
	var/amount_to_give

	if(picked_item in high_tier_gear)
		amount_to_give = 1
	if(picked_item in med_tier_gear)
		amount_to_give = 2
	else
		amount_to_give = 3

	if(istype(purchased_gun, /obj/item/weapon/gun/shotgun))
		ammo_to_give = /obj/item/ammo_magazine/shotgun/buckshot
		amount_to_give = 1
		purchased_gun.set_fire_delay(purchased_gun.get_fire_delay() * 0.6)
	if(istype(purchased_gun, /obj/item/weapon/gun/rifle/lmg))
		amount_to_give = 1
		purchased_gun.add_firemode(GUN_FIREMODE_AUTOMATIC)
		purchased_gun.flags_gun_features &= ~GUN_SUPPORT_PLATFORM
	if(istype(purchased_gun, /obj/item/weapon/gun/lever_action))
		ammo_to_give = /obj/item/ammo_magazine/lever_action
		purchased_gun.flags_gun_features &= ~DANGEROUS_TO_ONEHAND_LEVER
		amount_to_give = 1

	for(amount_to_give, amount_to_give > 0, amount_to_give--)
		new ammo_to_give(loc)
	user.put_in_hands(purchased_gun)
	reset_hovering_effect()
	picked_item = null

/////////////////////
// PACK-A-PUNCH //
/////////////////////

/obj/structure/upgrade_station
	name = "upgrade station"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "case"
	density = TRUE
	breakable = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/upgrade_station/attackby(obj/item/weapon/gun/item_to_upgrade, mob/user)
	var/weapon_path = item_to_upgrade.type
	var/outline_color = "#b1007c"
	var/alpha = 70
	outline_color += num2text(alpha, 2, 16)

	item_to_upgrade.add_filter("outline", 1, outline_filter(size = 2, color = outline_color))

	//Yes, almost all of these are references to random pieces of media/famous people.
	switch(weapon_path)
		if(/obj/item/weapon/gun/flamer/m240)
			item_to_upgrade.name = "\proper Meltdown"
			item_to_upgrade.desc = SPAN_DANGER("Things are going to be pretty hot in here soon.")
			item_to_upgrade.set_fire_delay(FIRE_DELAY_TIER_7)
			item_to_upgrade.gun_firemode_list |= GUN_FIREMODE_AUTOMATIC
			new /obj/item/ammo_magazine/flamer_tank/high_combustion(loc)

		if(/obj/item/weapon/gun/rifle/m4ra)
			item_to_upgrade.name = "\proper Recon"
			item_to_upgrade.desc = SPAN_DANGER("The last thing they'll ever see.")
			item_to_upgrade.damage_mult += 0.15
			item_to_upgrade.ammo_override = /datum/ammo/bullet/rifle/ap/penetrating
			if(item_to_upgrade.in_chamber)
				item_to_upgrade.ready_in_chamber()

		if(/obj/item/weapon/gun/rifle/m46c/horde_mode)
			item_to_upgrade.name = "\proper Primas"
			item_to_upgrade.desc = SPAN_DANGER("I lead the way.")
			item_to_upgrade.ammo_override = /datum/ammo/bullet/rifle/incendiary/napalmx
			item_to_upgrade.damage_mult += 0.6
			if(item_to_upgrade.in_chamber)
				item_to_upgrade.ready_in_chamber()

		if(/obj/item/weapon/gun/lever_action/r4t)
			item_to_upgrade.name = "\proper Judgement Day"
			item_to_upgrade.desc = SPAN_DANGER("They forgot to say please.")
			item_to_upgrade.ammo_override = /datum/ammo/bullet/rifle/explosive/light
			item_to_upgrade.recoil_unwielded -= RECOIL_AMOUNT_TIER_2
			item_to_upgrade.accuracy_mult_unwielded += HIT_ACCURACY_MULT_TIER_10
			item_to_upgrade.scatter_unwielded -= SCATTER_AMOUNT_TIER_5
			item_to_upgrade.movement_onehanded_acc_penalty_mult -= 4

		if(/obj/item/weapon/gun/rifle/l42a/abr40)
			item_to_upgrade.name = "\proper Old Glory"
			item_to_upgrade.desc = SPAN_DANGER("It has ever been my staunch companion and protection.")
			item_to_upgrade.damage_mult += 1.5
			item_to_upgrade.accuracy_mult += HIT_ACCURACY_MULT_TIER_7

		if(/obj/item/weapon/gun/rifle/m41a)
			item_to_upgrade.name = "\proper Recompense"
			item_to_upgrade.desc = SPAN_DANGER("Forgive your enemies, but never forget their names.")
			item_to_upgrade.modify_fire_delay(-0.5)
			item_to_upgrade.damage_mult += 0.5
			item_to_upgrade.chance_to_keep_ammo = 33

		if(/obj/item/weapon/gun/rifle/m41aMK1)
			item_to_upgrade.name = "\proper THIS MACHINE"
			item_to_upgrade.desc = SPAN_DANGER("KILLS UPP.")
			item_to_upgrade.set_burst_delay(1)
			item_to_upgrade.do_toggle_firemode(user, GUN_FIREMODE_BURSTFIRE)
			item_to_upgrade.remove_firemode(GUN_FIREMODE_SEMIAUTO, user)
			item_to_upgrade.remove_firemode(GUN_FIREMODE_AUTOMATIC, user)

		if(/obj/item/weapon/gun/shotgun/combat/marsoc)
			item_to_upgrade.name = "\proper Adjudicator"
			item_to_upgrade.desc = SPAN_DANGER("Delivering justice one shell at a time.")
			item_to_upgrade.damage_mult += 0.8
			item_to_upgrade.accuracy_mult += HIT_ACCURACY_MULT_TIER_10
			item_to_upgrade.scatter -= SCATTER_AMOUNT_TIER_8
			item_to_upgrade.ammo_override = /datum/ammo/bullet/shotgun/flechette
			item_to_upgrade.set_fire_delay(FIRE_DELAY_TIER_10)
			item_to_upgrade.chance_to_keep_ammo = 50
			if(item_to_upgrade.in_chamber)
				item_to_upgrade.ready_in_chamber()

		if(/obj/item/weapon/gun/pistol/m4a3)
			item_to_upgrade.name = "\proper FUBAR"
			item_to_upgrade.desc = SPAN_DANGER("You wanna explain the math of this to me?")
			item_to_upgrade.ammo_override = /datum/ammo/grenade_container/rifle
			if(item_to_upgrade.in_chamber)
				item_to_upgrade.ready_in_chamber()

		if(/obj/item/weapon/gun/smg/m39)
			item_to_upgrade.name = "\proper Big Trouble"
			item_to_upgrade.desc = SPAN_DANGER("God, aren't you even gonna kiss her goodbye?")
			item_to_upgrade.modify_fire_delay(-0.25)
			item_to_upgrade.modify_burst_delay(-0.5)
			item_to_upgrade.damage_mult += 0.25
			item_to_upgrade.chance_to_keep_ammo = 50
			item_to_upgrade.burst_scatter_mult -= 2

		if(/obj/item/weapon/gun/smg/mp5)
			item_to_upgrade.name = "\proper Detective's Sidearm"
			item_to_upgrade.desc = SPAN_DANGER("Now you have a machine gun. Ho, ho, ho.")
			item_to_upgrade.set_fire_delay(FIRE_DELAY_TIER_12)
			item_to_upgrade.set_burst_delay(FIRE_DELAY_TIER_12)
			item_to_upgrade.chance_to_keep_ammo = 66
			item_to_upgrade.burst_scatter_mult -= 2

/////////////////////
// HOVERING EFFECT //
/////////////////////
/obj/effect/item_purchase
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/assault_rifles.dmi'
	icon_state = "m41a"
	pixel_y = 14
	layer = ABOVE_XENO_LAYER

/obj/effect/item_purchase/Initialize(mapload, ...)
	. = ..()
	add_filter("outline", 1, outline_filter(size = 1, color = COLOR_WHITE, flags = OUTLINE_SHARP))

/obj/effect/item_purchase/mystery
	name = "mystery item"
	desc = "What are you going to get?"
	icon = 'icons/effects/techtree/tech.dmi'
	icon_state = "unknown"
