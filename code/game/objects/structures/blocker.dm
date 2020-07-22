// Impenetrable and invincible barriers
/obj/structure/blocker
	name = "blocker"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/blocker/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = list()

/obj/structure/blocker/ex_act(severity)
	return

/obj/structure/blocker/invisible_wall
	name = "invisible wall"
	desc = "You cannot go this way."
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "x4"
	opacity = 0
	layer = ABOVE_FLY_LAYER + 0.1 //to make it visible in the map editor
	mouse_opacity = 0

/obj/structure/blocker/invisible_wall/Collided(atom/movable/AM)
	to_chat(AM, SPAN_WARNING("You cannot go this way."))

/obj/structure/blocker/invisible_wall/New()
	..()
	icon_state = null


/obj/structure/blocker/fog
	name = "dense fog"
	desc = "It looks way too dangerous to traverse. Best wait until it has cleared up."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	opacity = 1

/obj/structure/blocker/fog/New()
    ..()
    dir  = pick(CARDINAL_DIRS)

/obj/structure/blocker/fog/attack_hand(mob/M)
    to_chat(M, SPAN_NOTICE("You peer through the fog, but it's impossible to tell what's on the other side..."))

/obj/structure/blocker/fog/attack_alien(M)
    return attack_hand(M)