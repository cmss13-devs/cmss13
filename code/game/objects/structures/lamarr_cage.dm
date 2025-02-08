/obj/structure/lamarr
	name = "Lab Cage"
	icon = 'icons/obj/structures/props/furniture/display_case.dmi'
	icon_state = "labcage1"
	desc = "A glass lab container for storing interesting creatures."
	density = TRUE
	anchored = TRUE
	unacidable = FALSE
	health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/structure/lamarr/ex_act(severity)
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
			new /obj/item/shard( src.loc )
			Break()
			deconstruct(FALSE)


/obj/structure/lamarr/bullet_act(obj/projectile/Proj)
	health -= Proj.damage
	..()
	src.healthcheck()
	return 1

/obj/structure/lamarr/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = FALSE
			src.destroyed = 1
			new /obj/item/shard( src.loc )
			playsound(src, "shatter", 25, 1)
			Break()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return

/obj/structure/lamarr/update_icon()
	if(src.destroyed)
		src.icon_state = "labcageb[src.occupied]"
	else
		src.icon_state = "labcage[src.occupied]"
	return


/obj/structure/lamarr/attackby(obj/item/W as obj, mob/user as mob)
	health -= W.force * W.demolition_mod
	healthcheck()
	. = ..()
	return

/obj/structure/lamarr/attack_hand(mob/user as mob)
	if (src.destroyed)
		return
	else
		to_chat(user, SPAN_NOTICE("You kick the lab cage."))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, SPAN_DANGER("[user] kicks the lab cage."))
		src.health -= 2
		healthcheck()
		return

/obj/structure/lamarr/proc/Break()
	if(occupied)
		new /obj/item/clothing/mask/facehugger/lamarr(src.loc)
		occupied = 0
	update_icon()
	return

/obj/item/clothing/mask/facehugger/lamarr
	name = "Lamarr"
	desc = "The worst she might do is attempt to... couple with your head."//hope we don't get sued over a harmless reference, rite?
	sterile = TRUE
	gender = FEMALE
	black_market_value = 50

/obj/item/clothing/mask/facehugger/lamarr/die()
	if(stat == DEAD)
		return

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	visible_message("[icon2html(src, viewers(src))] <span class='danger'>\The [src] curls up into a ball!</span>")
	playsound(src.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)

	if(ismob(loc)) //Make it fall off the person so we can update their icons. Won't update if they're in containers thou
		var/mob/M = loc
		M.drop_inv_item_on_ground(src)

	layer = BELOW_MOB_LAYER //so dead hugger appears below live hugger if stacked on same tile.
	//override function prevents Lamarr from decaying like other huggers so you can keep it in your helmet, otherwise the code is identical.
