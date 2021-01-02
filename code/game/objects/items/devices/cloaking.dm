//chameleon projector

/obj/item/device/chameleon
	name = "chameleon-projector"
	desc = "Use this to become invisible to the human eyesocket."
	icon_state = "shield0"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	var/chameleon_on = FALSE
	var/datum/effect_system/spark_spread/spark_system
	var/chameleon_cooldown

/obj/item/device/chameleon/New()
	..()
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/device/chameleon/Destroy()
	if(spark_system)
		qdel(spark_system)
		spark_system = null
	. = ..()

/obj/item/device/chameleon/dropped(mob/user)
	disrupt(user)
	..()

/obj/item/device/chameleon/equipped(mob/user, slot)
	. = ..()
	disrupt(user)

/obj/item/device/chameleon/attack_self(mob/user)
	toggle(user)

/obj/item/device/chameleon/proc/toggle(mob/user)
	if(chameleon_cooldown >= world.time) return
	if(!ishuman(user)) return
	playsound(get_turf(src), 'sound/effects/pop.ogg', 25, 1, 3)
	chameleon_on = !chameleon_on
	chameleon_cooldown = world.time + 20
	src.add_fingerprint(user)
	if(chameleon_on)
		user.alpha = 25
		to_chat(user, SPAN_NOTICE("You activate the [src]."))
		spark_system.start()
		src.icon_state = "shield1"
	else
		user.alpha = initial(user.alpha)
		to_chat(user, SPAN_NOTICE("You deactivate the [src]."))
		src.icon_state = "shield0"
		spark_system.start()

/obj/item/device/chameleon/proc/disrupt(mob/user)
	if(chameleon_on)
		spark_system.start()
		user.alpha = initial(user.alpha)
		chameleon_cooldown = world.time + 50
		chameleon_on = FALSE
		src.icon_state = "shield0"
