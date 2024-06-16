// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colorful flags."
	singular_name = "flag"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/structures/props/mining.dmi'
	stack_id = "flags"
	var/upright = FALSE
	var/base_state

/obj/item/stack/flag/Initialize()
	. = ..()
	base_state = icon_state

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"

/obj/item/stack/flag/blue
	name = "blue flags"
	singular_name = "blue flag"
	icon_state = "blueflag"

/obj/item/stack/flag/purple
	name = "purple flags"
	singular_name = "purple flag"
	icon_state = "purpleflag"

/obj/item/stack/flag/attackby(obj/item/W, mob/user)
	if(upright && istype(W,src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(user)
	if(upright)
		upright = 0
		icon_state = base_state
		anchored = FALSE
		src.visible_message("<b>[user]</b> knocks down [src].")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user)
	..()

	var/turf/T = get_turf(src)
	if(!T)
		to_chat(user, "The flag won't stand up in this terrain.")
		return

	var/obj/item/stack/flag/F = locate() in get_turf(src)
	if(F && F.upright)
		to_chat(user, "There is already a flag here.")
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = TRUE
	newflag.anchored = TRUE
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
	src.use(1)


/// PLANTABLE FLAG

/obj/structure/flag/plantable
	name = "flag"
	desc = "A flag of something. This one looks like you could dismantle it."
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "yellowflag"
	layer = ABOVE_MOB_LAYER

/obj/structure/flag/attack_hand(mob/user)
	if(user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts taking [src] down..."), SPAN_NOTICE("You start taking [src] down..."))
	if(!do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	playsound(user, 'sound/effects/flag_raised.ogg', 30)
	new /obj/item/flag/plantable/ua(src.loc)
	qdel(src)

/obj/structure/flag/plantable/ua
	name = "\improper United Americas flag"
	desc = "A flag of the United Americas. This one looks like you could take it down."
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_ua"

/obj/item/flag/plantable
	name = "plantable flag"
	desc = "A flag of something. This one looks ready to be planted into the ground."
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "yellowflag"
	var/flag_type = /obj/structure/flag/plantable
	var/obj/structure/flag/plantable/planted_flag
	var/play_warcry = FALSE
	var/warcry_sound = null

/obj/item/flag/plantable/proc/plant_flag(mob/user, play_warcry = FALSE, warcry_type)
	if(user.action_busy)
		return

	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("There's no way to plant [src] in here!"))
		return

	var/turf/turf_to_plant = get_step(user, user.dir)
	for(var/obj/object in turf_to_plant)
		if(object.density)
			to_chat(usr, SPAN_WARNING("You need a clear, open area to plant [src], something is blocking the way in front of you!"))
			return

	playsound(user, 'sound/effects/flag_raising.ogg', 30)
	user.visible_message(SPAN_NOTICE("[user] starts planting [src] into the ground..."), SPAN_NOTICE("You start planting [src] into the ground..."))
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	playsound(user, 'sound/effects/flag_raised.ogg', 30)
	if(play_warcry)
		playsound(user, warcry_sound)

	user.visible_message(SPAN_NOTICE("[user] plants [src] into the ground!"), SPAN_NOTICE("You plant [src] into the ground!"))
	planted_flag = new flag_type(turf_to_plant)
	planted_flag.pixel_x += 9
	qdel(src)

/obj/item/flag/plantable/attack_self(mob/user)
	..()
	plant_flag(user, play_warcry, warcry_sound)

/obj/item/flag/plantable/attack(mob/user)
	..()
	plant_flag(user, play_warcry, warcry_sound)

/obj/item/flag/plantable/ua
	name = "\improper United Americas flag"
	desc = "A flag of the United Americas. This one looks ready to be planted into the ground."
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "yellowflag"
	flag_type = /obj/structure/flag/plantable/ua
	play_warcry = TRUE
	warcry_sound = 'sound/effects/flag_warcry_ua.ogg'
