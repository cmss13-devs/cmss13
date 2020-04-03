/obj/item/defenses/handheld
	name = "Don't see this."
	desc = "A compact version of the USCM defenses. Designed for quick deployment of the associated type in the field."
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	icon_state = "uac_sentry_handheld"
	
	force = 5
	throwforce = 5
	throw_speed = SPEED_SLOW
	throw_range = 5
	w_class = SIZE_MEDIUM

	indestructible = TRUE
	var/defense_type = /obj/structure/machinery/defenses

/obj/item/defenses/handheld/examine(mob/user)
	. = ..()

	to_chat(user, SPAN_INFO("It is ready for deployment."))

/obj/item/defenses/handheld/attack_self(var/mob/living/carbon/human/user)
	if(!istype(user))
		return

	deploy_handheld(user)

/obj/item/defenses/handheld/proc/deploy_handheld(var/mob/living/carbon/human/user)
	var/turf/T = get_step(user, user.dir)
	var/direction = user.dir

	var/blocked = FALSE
	for(var/obj/O in T)
		if(O.density)
			blocked = TRUE
			break

	for(var/mob/M in T)
		blocked = TRUE
		break

	if(istype(T, /turf/closed))
		blocked = TRUE

	if(blocked)
		to_chat(usr, SPAN_WARNING("You need a clear, open area to build \a [src], something is blocking the way in front of you!"))
		return

	if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return

	var/obj/structure/machinery/defenses/D = new defense_type(T, user.faction)
	D.dir = direction
	playsound(T, 'sound/mecha/mechmove01.ogg', 30, 1)
	qdel(src)


/obj/item/defenses/handheld/sentry
	name = "handheld UA 571-C sentry gun"
	icon_state = "uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry

/obj/item/defenses/handheld/sentry/flamer
	name = "handheld UA 42-F sentry flamer"
	icon_state = "uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer

/obj/item/defenses/handheld/tesla_coil
	name = "handheld 21S tesla coil"
	icon_state = "tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil

/obj/item/defenses/handheld/bell_tower
	name = "handheld R-1NG bell tower"
	icon_state = "bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower

/obj/item/defenses/handheld/planted_flag
	name = "handheld JIMA planted flag"
	icon_state = "planted_flag_handheld"
	defense_type = /obj/structure/machinery/defenses/planted_flag