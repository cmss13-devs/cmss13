
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

/obj/structure/machinery/line_nexter/med
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "turnstile_med"

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
		var/mob/living/carbon/C = O
		if(C.pulledby)
			if(!C.is_mob_incapacitated())
				return BLOCKED_MOVEMENT
	return NO_BLOCKED_MOVEMENT

/obj/structure/machinery/line_nexter/proc/next()
	//if((last_use + 20) > world.time) // 20 seconds
	for(var/mob/living/carbon/human/H in loc)
		step(H,dir)
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
		var/mob/living/L = usr
		attack_hand(L)

/obj/structure/machinery/line_nexter_control/attack_hand(mob/living/user)
	add_fingerprint(user)
	if(istype(user,/mob/living/carbon/xenomorph))
		return

	icon_state = "doorctrl1"
	add_fingerprint(user)

	for(var/obj/structure/machinery/line_nexter/L in GLOB.machines)
		if(id == L.id)
			L.next()

	addtimer(VARSET_CALLBACK(src, icon_state, "doorctrl0"), 1.5 SECONDS)
