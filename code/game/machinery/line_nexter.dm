
/obj/structure/machinery/line_nexter
	name = "Turnstile"
	desc = "a one-way barrier combined with a bar to pull people out of line."
	icon = 'icons/obj/structures/barricades.dmi'
	density = TRUE
	icon_state = "turnstile"
	anchored = TRUE
	flags_atom = ON_BORDER
	dir = WEST
	var/last_use
	var/id

/obj/structure/machinery/line_nexter/Initialize()
	. = ..()
	last_use = world.time

/obj/structure/machinery/line_nexter/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_THROUGH|PASS_UNDER

/obj/structure/machinery/line_nexter/ex_act(severity)
	return

/obj/structure/machinery/line_nexter/BlockedExitDirs(atom/movable/O, target_dir)
	if(iscarbon(O))
		var/mob/living/carbon/mob = O
		if(mob.pulledby)
			if(!mob.is_mob_incapacitated())
				return BLOCKED_MOVEMENT
	return NO_BLOCKED_MOVEMENT

/obj/structure/machinery/line_nexter/proc/next()
	//if((last_use + 20) > world.time) // 20 seconds
	for(var/mob/living/carbon/human/human in loc)
		step(human,dir)
	last_use = world.time

/obj/structure/machinery/line_nexter_control
	name = "Next Button"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "doorctrl0"
	var/id

/obj/structure/machinery/line_nexter_control/verb/push_button()
	set name = "Push Button"
	set category = "Object"
	if(isliving(usr))
		var/mob/living/mob = usr
		attack_hand(mob)

/obj/structure/machinery/line_nexter_control/attack_hand(mob/living/user)
	add_fingerprint(user)
	if(istype(user,/mob/living/carbon/xenomorph))
		return

	icon_state = "doorctrl1"
	add_fingerprint(user)

	for(var/obj/structure/machinery/line_nexter/turnstile in machines)
		if(id == turnstile.id)
			turnstile.next()

	addtimer(VARSET_CALLBACK(src, icon_state, "doorctrl0"), 1.5 SECONDS)
