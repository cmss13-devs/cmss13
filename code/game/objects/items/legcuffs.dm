/obj/item/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "handcuff"
	flags_atom = FPRINT|CONDUCT
	throwforce = 0
	w_class = SIZE_MEDIUM

	var/breakouttime = 15 SECONDS

/obj/item/legcuffs/beartrap
	name = "bear trap"
	throw_speed = SPEED_FAST
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	var/armed = FALSE

/obj/item/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.is_mob_restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now [armed ? "armed" : "disarmed"]"))

/obj/item/legcuffs/beartrap/Crossed(atom/movable/AM)
	if(armed)
		if(ismob(AM))
			var/mob/M = AM
			if(!M.buckled)
				if(ishuman(AM))
					if(isturf(src.loc))
						var/mob/living/carbon/H = AM
						if(!H.legcuffed)
							H.legcuffed = src
							forceMove(H)
							H.legcuff_update()
						armed = 0
						icon_state = "beartrap0"
						playsound(loc, 'sound/effects/snap.ogg', 25, 1)
						to_chat(H, SPAN_DANGER("<B>You step on \the [src]!</B>"))
						for(var/mob/O in viewers(H, null))
							if(O == H)
								continue
							O.show_message(SPAN_DANGER("<B>[H] steps on \the [src].</B>"), 1)
				if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot))
					armed = 0
					var/mob/living/simple_animal/SA = AM
					SA.health -= 20
	..()
