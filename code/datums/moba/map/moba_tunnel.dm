/obj/structure/tunnel/moba
	desc = "A tunnel entrance that can be used to return to your base."
	tunnel_desc = ""
	hivenumber = null

	var/map_id = 0
	var/force_tunnel_desc

/obj/structure/tunnel/moba/Initialize(mapload, h_number)
	. = ..()
	if(force_tunnel_desc)
		tunnel_desc = force_tunnel_desc

/obj/structure/tunnel/moba/isfriendly(mob/target)
	return TRUE

/obj/structure/tunnel/moba/pick_tunnel(mob/living/carbon/xenomorph/X)
	return FALSE

//Used for controling tunnel exiting and returning
/obj/structure/tunnel/moba/clicked(mob/user, list/mods)
	mods -= "ctrl"
	mods -= "alt"
	return ..()

/obj/structure/tunnel/moba/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M) || M.is_mob_incapacitated(TRUE))
		return XENO_NO_DELAY_ACTION

	if(M.anchored)
		to_chat(M, SPAN_XENOWARNING("We can't climb through a tunnel while immobile."))
		return XENO_NO_DELAY_ACTION

	var/tunnel_time = TUNNEL_ENTER_XENO_DELAY * 1.5

	if(M.mob_size >= MOB_SIZE_BIG)
		tunnel_time = TUNNEL_ENTER_BIG_XENO_DELAY * 0.75
		M.visible_message(SPAN_XENONOTICE("[M] begins heaving their huge bulk down into [src]."),
			SPAN_XENONOTICE("We begin heaving our monstrous bulk into [src] (<i>[tunnel_desc]</i>)."))
	else
		M.visible_message(SPAN_XENONOTICE("[M] begins crawling down into [src]."),
			SPAN_XENONOTICE("We begin crawling down into [src] (<i>[tunnel_desc]</i>)."))

	xeno_attack_delay(M)
	if(!do_after(M, tunnel_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Our crawling was interrupted!"))
		return XENO_NO_DELAY_ACTION

	SEND_SIGNAL(M, COMSIG_XENO_USED_TUNNEL, src)
	return XENO_NO_DELAY_ACTION
