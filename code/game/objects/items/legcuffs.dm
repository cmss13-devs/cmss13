/obj/item/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "handcuff"
	flags_atom = FPRINT|CONDUCT
	throwforce = 0
	w_class = SIZE_MEDIUM
	
	var/breakouttime = SECONDS_15

/obj/item/legcuffs/beartrap
	name = "bear trap"
	throw_speed = SPEED_FAST
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	var/armed = 0

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





//PREDATOR LEGCUFFS

/obj/item/legcuffs/yautja
	name = "hunting trap"
	throw_speed = SPEED_FAST
	throw_range = 2
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "yauttrap0"
	desc = "A bizarre Yautja device used for trapping and killing prey."
	var/armed = 0
	layer = LOWER_ITEM_LAYER

	dropped(var/mob/living/carbon/human/mob) //Changes to "camouflaged" icons based on where it was dropped.
		if(armed)
			if(isturf(mob.loc))
				if(istype(mob.loc,/turf/open/gm/dirt))
					icon_state = "yauttrapdirt"
				else if (istype(mob.loc,/turf/open/gm/grass))
					icon_state = "yauttrapgrass"
				else
					icon_state = "yauttrap1"
		..()

/obj/item/legcuffs/yautja/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.is_mob_restrained())
		if(!do_after(user, rand(10, 30), INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return
		armed =TRUE
		anchored = TRUE
		icon_state = "yauttrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now armed."))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has armed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has armed \a [src] at [get_location_in_text(user)].")
		user.drop_held_item()

/obj/item/legcuffs/yautja/attack_hand(mob/living/carbon/human/user)
	if(isYautja(user))
		armed = 0
		anchored = 0
		icon_state = "yauttrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now disarmed."))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has disarmed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has disarmed \a [src] at [get_location_in_text(user)].")
	//Humans and synths don't know how to handle those traps!
	if(isHumanSynthStrict(user))
		if(armed)
			to_chat(user, "You foolishly reach out for \the [src]...")
			trapMob(user)
			return
	. = ..()

/obj/item/legcuffs/yautja/proc/trapMob(var/mob/living/carbon/H)
	if(armed)
		armed = 0
		anchored = 0
		icon_state = "yauttrap0"
		H.legcuffed = src
		H.recalculate_move_delay = TRUE
		src.forceMove(H)
		H.legcuff_update()
		playsound(H,'sound/weapons/tablehit1.ogg', 25, 1)
		to_chat(H, "[htmlicon(src, H)] \red <B>You get caught in \the [src]!</B>")
		H.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(H)] was caught in \a [src] at [get_location_in_text(H)].</font>")
		log_attack("[key_name(H)] was caught in \a [src] at [get_location_in_text(H)].")
		H.KnockDown(4)
		if(ishuman(H))
			H.emote("pain")

/obj/item/legcuffs/yautja/Crossed(atom/movable/AM)
	if(armed)
		if(ismob(AM))
			var/mob/M = AM
			if(!M.buckled)
				if(iscarbon(AM))
					if(isturf(src.loc))
						var/mob/living/carbon/H = AM
						if(isYautja(H))
							to_chat(H, SPAN_NOTICE("You carefully avoid stepping on the trap."))
							return
						trapMob(H)
						for(var/mob/O in viewers(H, null))
							if(O == H)
								continue
							O.show_message(SPAN_WARNING("[htmlicon(src, O)] <B>[H] gets caught in \the [src].</B>"), 1)
				if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot))
					armed = 0
					var/mob/living/simple_animal/SA = AM
					SA.health -= 20
	..()


