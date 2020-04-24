/obj/item/tool/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3.0
	throwforce = 10.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	w_class = SIZE_MEDIUM
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	var/mopping = 0
	var/mopcount = 0


/obj/item/tool/mop/New()
	. = ..()
	create_reagents(5)

/turf/proc/clean_dirt()
	for(var/i in dirt_overlays)
		overlays -= dirt_overlays[i]
		dirt_overlays[i] = null	

/turf/proc/clean(atom/source)
	if(source.reagents.has_reagent("water", 1))
		for(var/i in dirt_overlays)
			overlays -= dirt_overlays[i]
			dirt_overlays[i] = null

	source.reagents.reaction(src, TOUCH, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	source.reagents.remove_any(1)				//reaction() doesn't use up the reagents


/obj/item/tool/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("Your mop is dry!"))
			return

		user.visible_message(SPAN_WARNING("[user] begins to clean \the [get_turf(A)]."))

		if(do_after(user, 40, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			var/turf/T = get_turf(A)
			if(T)
				T.clean(src)
			to_chat(user, SPAN_NOTICE("You have finished mopping!"))


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/mop) || istype(I, /obj/item/tool/soap))
		return
	..()








/obj/item/tool/wet_sign
	name = "wet floor sign"
	desc = "Caution! Wet Floor!"
	icon_state = "caution"
	icon = 'icons/obj/janitor.dmi'
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
	force = 1
	throwforce = 3
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("warned", "cautioned", "smashed")





/obj/item/tool/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
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
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, SPAN_NOTICE("You need to take that [target.name] off before cleaning it."))
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
		qdel(target)
	else if(isturf(target))
		var/turf/T = target
		T.clean_dirt()
		to_chat(user, SPAN_NOTICE("You scrub all dirt out of \the [target.name]."))
	else
		to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
		target.clean_blood()


/obj/item/tool/soap/attack(mob/target, mob/user)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_selected == "mouth" )
		user.visible_message(SPAN_DANGER("\the [user] washes \the [target]'s mouth out with soap!"))
		return
	..()

/obj/item/tool/soap/nanotrasen
	desc = "A Weston-Yamada brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

/obj/item/tool/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/tool/soap/deluxe/New()
	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/tool/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"
