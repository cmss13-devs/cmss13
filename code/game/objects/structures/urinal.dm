/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = I
		if(isliving(G.grabbed_thing))
			var/mob/living/GM = G.grabbed_thing
			if(user.grab_level > GRAB_PASSIVE)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the urinal."))
					return
				user.visible_message(SPAN_DANGER("[user] slams [GM.name] into [src]!"), SPAN_NOTICE("You slam [GM.name] into [src]!"))
				GM.apply_damage(8, BRUTE)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))
