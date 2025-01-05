/obj/structure/closet/phonebox
	name = "phonebox"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. As reliable as they are, it seems the line is down."
	icon = 'icons/obj/structures/props/phonebox.dmi'
	icon_state = "phonebox_on_empty_closed"
	density = TRUE
	bound_width = 32
	bound_height = 64
	material = MATERIAL_METAL
	anchored = TRUE
	layer = BETWEEN_OBJECT_ITEM_LAYER
	exit_stun = 1
	health = 750

	open_sound = 'sound/effects/metal_door_open.ogg'
	close_sound = 'sound/effects/metal_door_close.ogg'

/obj/structure/closet/phonebox/update_icon()
	icon_state = "phonebox_on_open"
	if(!opened)
		icon_state = "phonebox_on_empty_closed"
		for(var/mob/M in src)
			icon_state = "phonebox_on_full_closed"

/obj/structure/closet/phonebox/off
	name = "phonebox"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. As reliable as they are, the bulb has been smashed and it seems the line is down."
	icon = 'icons/obj/structures/props/phonebox.dmi'
	icon_state = "phonebox_off_empty_closed"
	density = TRUE
	bound_width = 32
	bound_height = 64
	material = MATERIAL_METAL
	anchored = TRUE
	layer = BETWEEN_OBJECT_ITEM_LAYER
	exit_stun = 1
	health = 250

	open_sound = 'sound/effects/metal_door_open.ogg'
	close_sound = 'sound/effects/metal_door_close.ogg'

/obj/structure/closet/phonebox/off/update_icon()
	icon_state = "phonebox_off_open"
	if(!opened)
		icon_state = "phonebox_off_empty_closed"
		for(var/mob/M in src)
			icon_state = "phonebox_off_full_closed"

/obj/structure/closet/phonebox/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/closet/phonebox/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/closet/phonebox/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/closet/phonebox/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// Not currently working fully (don't use)
/obj/structure/machinery/phonebox
	name = "phonebox"
	icon = 'icons/obj/structures/props/phonebox.dmi'
	icon_state = "phonebox_off_empty_closed"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. As reliable as they are, it seems the line is down."
	bound_width = 32
	bound_height = 64
	density = TRUE
	anchored = TRUE
	use_power = 0
	can_buckle = TRUE
	/// the borg inside
	var/mob/living/occupant = null
	var/icon_update_tick = 0
	///stun time upon exiting, if at all
	var/exit_stun = 1
	var/open = TRUE

/obj/structure/machinery/phonebox/Initialize(mapload, ...)
	. = ..()
	update_icon()
	flags_atom |= USES_HEARING

/obj/structure/machinery/phonebox/Destroy()
	if(occupant)
		to_chat(occupant, SPAN_NOTICE(" <B>[name] colapses around you.</B>"))
		go_out()
	return ..()

/obj/structure/machinery/phonebox/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/phonebox/process()
	update_icon()

/obj/structure/machinery/phonebox/stop_processing()
	update_icon()

/obj/structure/machinery/phonebox/allow_drop()
	return FALSE

/obj/structure/machinery/phonebox/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/structure/machinery/phonebox/update_icon()
	..()
	if(stat & NOPOWER)
		if(!open)
			icon_state = "phonebox_off_empty_closed"
			if(occupant)
				icon_state = "phonebox_off_full_closed"
		else
			icon_state = "phonebox_off_open"
	else
		if(!open)
			icon_state = "phonebox_on_empty_closed"
			if(occupant)
				icon_state = "phonebox_on_full_closed"
		else
			icon_state =  "phonebox_on_open"

/obj/structure/machinery/phonebox/proc/go_out()
	if(!occupant)
		return
	var/mob/living/synth = occupant
	if(synth.client)
		synth.client.eye = synth.client.mob
		synth.client.perspective = MOB_PERSPECTIVE

	synth.forceMove(loc)
	if(exit_stun)
		synth.Stun(exit_stun) //Action delay when going out of a closet
	if(synth.mobility_flags & MOBILITY_MOVE)
		synth.visible_message(SPAN_WARNING("[synth] suddenly gets out of [src]!"), SPAN_WARNING("You get out of [src] and get your bearings!"))

	occupant = null
	open = TRUE
	update_icon()

/obj/structure/machinery/phonebox/do_buckle(mob/target, mob/user)
	return move_mob_inside(target)

/obj/structure/machinery/phonebox/verb/move_mob_inside(mob/living/M)
	if(!open)
		return FALSE
	if (occupant)
		return FALSE
	M.stop_pulling()
	if(M && M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	occupant = M
	start_processing()
	add_fingerprint(usr)
	open = FALSE
	update_icon()
	return TRUE

/obj/structure/machinery/phonebox/verb/move_eject()
	set category = "Object"
	set name = "Eject"

	set src in oview(1)
	if (usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/structure/machinery/phonebox/attack_hand(mob/living/user)
	if(open)
		open = FALSE
	else
		open = TRUE
	go_out()
	update_icon()



#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/phonebox/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH
