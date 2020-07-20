
/obj/structure/machinery/line_nexter
	name = "Turnstile"
	desc = "a one way barrier combined with a bar to pull people out of line."
	icon = 'icons/obj/structures/barricades.dmi'
	density = 1
	icon_state = "turnstile"
	anchored = 1
	flags_atom = ON_BORDER
	dir = 8
	var/last_use
	var/id

/obj/structure/machinery/line_nexter/New()
	..()
	last_use = world.time

/obj/structure/machinery/line_nexter/initialize_pass_flags()
	..()
	flags_can_pass_all = SETUP_LIST_FLAGS(PASS_OVER, PASS_THROUGH, PASS_UNDER)

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
	for(var/mob/living/carbon/human/H in locate(x,y,z))
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
	if(istype(user,/mob/living/carbon/Xenomorph))
		return

	icon_state = "doorctrl1"
	add_fingerprint(user)

	for(var/obj/structure/machinery/line_nexter/L in machines)
		if(id == L.id)
			L.next()

	spawn(15)
		icon_state = "doorctrl0"
