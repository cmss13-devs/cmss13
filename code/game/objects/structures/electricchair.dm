/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair1"
	var/last_time = 1

/obj/item/device/e_switch
	name = "electrical switch"
	desc = "An electrical switch used to activate the current of an electric chair"
	icon_state = "multitool_old"
	var/obj/structure/bed/chair/e_chair/linked_chair = null

/obj/item/device/e_switch/attack_self()
	if(!linked_chair)
		to_chat(usr, SPAN_WARNING("The switch is not connected to anything"))
	else
		to_chat(usr, SPAN_WARNING("You start to slowly pull the electrical switch"))
		if(do_after(usr, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(usr, SPAN_NOTICE("You flip the switch and activate the chair"))
			linked_chair.shock()
			return
	. = ..()

/obj/structure/bed/chair/e_chair/New()
	..()
	overlays += image('icons/obj/objects.dmi', src, "echair_over", MOB_LAYER + 1, dir)

/obj/structure/bed/chair/e_chair/Initialize()
	var/obj/item/device/e_switch/swichy = new /obj/item/device/e_switch(loc)
	swichy.linked_chair = src
	. = ..()

/obj/structure/bed/chair/e_chair/rotate()
	..()
	overlays.Cut()
	overlays += image('icons/obj/objects.dmi', src, "echair_over", MOB_LAYER + 1, dir) //there's probably a better way of handling this, but eh. -Pete
	return

/obj/structure/bed/chair/e_chair/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/e_switch))
		var/obj/item/device/e_switch/switchy = W
		switchy.linked_chair = src
		to_chat(usr, SPAN_NOTICE("You connect the electrical switch to [src]"))
		return
	. = ..()

/obj/structure/bed/chair/e_chair/proc/shock()
	if(last_time + 50 > world.time)
		visible_message(SPAN_DANGER("The electric chair is recharging!"))
		return
	last_time = world.time

	// special power handling
	var/area/A = get_area(src)
	if(!isarea(A))
		return
	if(!A.powered(POWER_CHANNEL_EQUIP))
		return
	A.use_power(5000)
	var/light = A.power_light
	A.updateicon()

	flick("echair1", src)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(12, 1, src)
	s.start()
	if(buckled_mob)
		buckled_mob.burn_skin(85)
		to_chat(buckled_mob, SPAN_DANGER("You feel a deep shock course through your body!"))
		sleep(1)
		buckled_mob.burn_skin(85)
		buckled_mob.apply_effect(20, STUN)
		buckled_mob.make_jittery(200)
	visible_message(SPAN_DANGER("The electric chair went off!"), SPAN_DANGER("You hear a deep sharp shock!"))

	A.power_light = light
	A.updateicon()
	return
