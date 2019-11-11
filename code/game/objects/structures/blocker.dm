/obj/structure/blocker
    name = "blocker"
    flags_can_pass_all = NO_FLAGS


/obj/structure/blocker/invisible_wall
	name = "invisible wall"
	desc = "You cannot go this way."
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "x4"
	anchored = TRUE
	density = 1
	opacity = 0
	unacidable = TRUE
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
	anchored = TRUE
	density = 1
	opacity = 1
	unacidable = TRUE

/obj/structure/blocker/fog/New()
    ..()
    dir  = pick(CARDINAL_DIRS)

/obj/structure/blocker/fog/attack_hand(mob/M)
    to_chat(M, SPAN_NOTICE("You peer through the fog, but it's impossible to tell what's on the other side..."))

/obj/structure/blocker/fog/attack_alien(M)
    return attack_hand(M)