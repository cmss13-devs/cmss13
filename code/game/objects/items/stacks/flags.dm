// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colourful flags."
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
	anchored = TRUE
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
	src.use(1)
