/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/structures/props/furniture/display_case.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = TRUE
	anchored = TRUE
	unacidable = FALSE
	health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(50))
				src.health -= 5
				src.healthcheck()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/displaycase/deconstruct(disassembled = TRUE)
	if(!disassembled)
		new /obj/item/shard(src.loc)
	if (occupied)
		occupied = 0
	return ..()

/obj/structure/displaycase/bullet_act(obj/projectile/Proj)
	health -= Proj.ammo.damage
	..()
	src.healthcheck()
	return 1

/obj/structure/displaycase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = FALSE
			src.destroyed = 1
			new /obj/item/shard( src.loc )
			playsound(src, "windowshatter", 25, 1)
			update_icon()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return

/obj/structure/displaycase/update_icon()
	if(src.destroyed)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"
	return


/obj/structure/displaycase/attackby(obj/item/W as obj, mob/user as mob)
	src.health -= W.force * W.demolition_mod
	src.healthcheck()
	. = ..()
	return

/obj/structure/displaycase/attack_hand(mob/user as mob)
	if (src.destroyed && src.occupied)
		to_chat(user, "\b You deactivate the hover field built into the case.")
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	else
		to_chat(user, SPAN_NOTICE("You kick the display case."))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, SPAN_DANGER("[user] kicks the display case."))
		src.health -= 2
		healthcheck()
		return

//Quick destroyed case.
/obj/structure/displaycase/destroyed
	icon_state = "glassboxb0"
	unslashable = TRUE
	health = 0
	occupied = 0
	destroyed = 1
