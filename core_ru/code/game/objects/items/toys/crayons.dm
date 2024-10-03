/obj/item/toy/suspicious
	name = "suspicious crayon"
	desc = "There's something off about this crayon..."
	icon = 'core_ru/code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "sus_crayon"
	var/uses = 10

/obj/item/toy/suspicious/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(istype(target, /turf/open/floor))
		if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			new /obj/effect/decal/cleanable/sus_crayon(target)
			to_chat(user, SPAN_NOTICE("You finish drawing."))
			target.add_fingerprint(user) // Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, SPAN_DANGER("You used up your crayon!"))
					qdel(src)

/obj/item/toy/suspicious/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, SPAN_NOTICE("You take a bite of the crayon and swallow it."))
		user.nutrition += 5
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user, SPAN_DANGER("You ate your crayon!"))
				qdel(src)
	else
		..()

/obj/effect/decal/cleanable/sus_crayon
	name = "suspicious rune"
	desc = "A rune drawn in crayon."
	icon = 'core_ru/code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "sus_crayon_rune"
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
