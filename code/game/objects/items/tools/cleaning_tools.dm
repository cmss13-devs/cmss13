/obj/item/tool/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_righthand.dmi',
	)
	icon_state = "mop"
	force = 3
	attack_speed = 4
	throwforce = 10
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	w_class = SIZE_MEDIUM
	matter = list("metal" = 110)

	var/max_reagent_volume = 15
	var/mop_speed = 1.5 SECONDS
	var/mop_count = 0


/obj/item/tool/mop/Initialize()
	. = ..()
	create_reagents(max_reagent_volume)

/obj/item/tool/mop/attack(mob/living/M, mob/living/user)
	. = ..()
	if(.)
		user.next_move = world.time + 1 SECONDS

/obj/item/tool/mop/update_icon(cut_if_empty)
	if(cut_if_empty)
		if(!reagents.total_volume)
			overlays.Cut()
		return
	overlays.Cut()
	if(reagents.total_volume)
		var/reagent_color = mix_color_from_reagents(reagents.reagent_list)
		var/image/reagent_overlay = image(icon, null, "mop_overlay", layer + 0.01)
		reagent_overlay.color = reagent_color
		overlays += reagent_overlay

/turf/proc/clean_cleanables()
	for(var/i in cleanables)
		var/obj/effect/decal/cleanable/C = cleanables[i]
		C.cleanup_cleanable()

/turf/proc/clean(atom/source)
	if(source.reagents.has_reagent("water", 1))
		clean_cleanables()
	source.reagents.reaction(src, TOUCH, 10) //10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	source.reagents.remove_any(1) //reaction() doesn't use up the reagents


/obj/item/tool/mop/afterattack(atom/A, mob/living/user, proximity)
	if(!proximity)
		return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("Your mop is dry!"))
			return

		var/cleaning_duration = 1.5 SECONDS * user.get_skill_duration_multiplier(SKILL_DOMESTIC)

		var/turf/cleaning_turf = get_turf(A)
		user.visible_message(SPAN_WARNING("[user] begins to clean \the [cleaning_turf]."))
		user.animation_attack_on(cleaning_turf)
		user.flick_attack_overlay(cleaning_turf, "cleaning_sparkles", cleaning_duration)

		if(do_after(user, cleaning_duration, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(cleaning_turf)
				cleaning_turf.clean(src)
				update_icon(TRUE)
			to_chat(user, SPAN_NOTICE("You have finished mopping!"))


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/mop) || istype(I, /obj/item/tool/soap))
		return
	. = ..()








/obj/item/tool/wet_sign
	name = "wet floor sign"
	desc = "Caution! Wet Floor!"
	icon_state = "caution"
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_righthand.dmi',
	)
	force = 1
	throwforce = 3
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/tool/warning_cone
	name = "warning cone"
	desc = "This cone is trying to warn you of something!"
	icon_state = "cone"
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/objects.dmi',
	)
	force = 1
	throwforce = 3
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("warned", "cautioned", "smashed")
	flags_equip_slot = SLOT_HEAD
	flags_inv_hide = HIDEEARS|HIDETOPHAIR




/obj/item/tool/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_righthand.dmi',
	)
	icon_state = "soap"
	w_class = SIZE_TINY
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/tool/soap/Crossed(atom/movable/AM)
	if (iscarbon(AM))
		var/mob/living/carbon/C =AM
		C.slip("soap", 3, 2)

/obj/item/tool/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity)
		return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, SPAN_NOTICE("You need to take that [target.name] off before cleaning it."))
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
		qdel(target)
	else if(isturf(target))
		var/turf/T = target
		T.clean_cleanables()
		to_chat(user, SPAN_NOTICE("You scrub all dirt out of \the [target.name]."))
	else
		to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
		target.clean_blood()


/obj/item/tool/soap/attack(mob/target, mob/user)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_selected == "mouth" )
		user.visible_message(SPAN_DANGER("\the [user] washes \the [target]'s mouth out with soap!"))
		return
	..()

/obj/item/tool/soap/weyland_yutani
	desc = "A Weyland-Yutani brand bar of soap. Smells of phoron."
	icon_state = "soapnt"
	item_state = "soapnt"

/obj/item/tool/soap/deluxe
	icon_state = "soapdeluxe"
	item_state = "soapdeluxe"

/obj/item/tool/soap/deluxe/Initialize()
	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/tool/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"
	item_state = "soapsyndie"
