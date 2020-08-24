/obj/item/device/agents/tracking_device
	name = "tracking device"
	desc = "a suspicious looking device, this can't be doing any good."
	icon_state = "tracking_device"
	item_state = "tracking_device"

	var/deployment_time = 50
	var/planted = FALSE

/obj/item/device/agents/tracking_device/examine(mob/user)
	. = ..()
	
	if(planted)
		to_chat(user, SPAN_INFO("It looks firmly planted. A multitool could disarm it."))

/obj/item/device/agents/tracking_device/update_icon()
	overlays.Cut()

	if(planted)
		overlays += "+planted"

/obj/item/device/agents/tracking_device/attack_self(mob/user)
	plant_tracker(user)
	return

/obj/item/device/agents/tracking_device/proc/plant_tracker(var/mob/user)
	var/turf/T = user.loc

	var/blocked = FALSE
	for(var/obj/O in T)
		if(O.density)
			blocked = TRUE
			break

	if(istype(T, /turf/closed))
		blocked = TRUE

	if(blocked)
		to_chat(usr, SPAN_WARNING("You need a clear, open area to place [src], something is blocking the way!"))
		return

	user.visible_message(SPAN_NOTICE("[user] starts deploying [src]."), SPAN_NOTICE("You start deploying [src]."))
	if(!do_after(user, deployment_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_NOTICE("You stop deploying [src]."))
		return

	to_chat(user, SPAN_NOTICE("You finish deploying [src]."))

	planted = TRUE
	anchored = TRUE
	user.drop_held_item(src)
	playsound(src, 'sound/mecha/mechmove01.ogg', 30, 1)

	update_icon()

	raiseEvent(GLOBAL_EVENT, EVENT_TRACKING_PLANTED + "\ref[src]")

/obj/item/device/agents/tracking_device/attackby(obj/item/W, mob/living/user)
	if(ismultitool(W) && planted)

		user.visible_message(SPAN_NOTICE("[user] starts deploying [src]."), SPAN_NOTICE("You start deploying [src]."))
		if(!do_after(user, deployment_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_NOTICE("You stop deploying [src]."))
			return

		to_chat(user, SPAN_NOTICE("You finish deploying [src]."))

		planted = FALSE
		anchored = FALSE
		playsound(src, 'sound/mecha/mechmove01.ogg', 30, 1)

		update_icon()

		raiseEvent(GLOBAL_EVENT, EVENT_TRACKING_PLANTED + "\ref[src]")
	else
		..()