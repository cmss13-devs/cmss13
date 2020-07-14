/*
 * Tunnels
 */

/obj/structure/tunnel
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "hole"

	density = 0
	opacity = 0
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	layer = RESIN_STRUCTURE_LAYER

	var/tunnel_desc = "" //description added by the hivelord.

	health = 140
	var/id = null //For mapping

var/list/obj/structure/tunnel/global_tunnel_list = list()

/obj/structure/tunnel/New()
	..()
	var/turf/L = get_turf(src)
	tunnel_desc = L.loc.name + " ([loc.x], [loc.y]) [pick(greek_letters)]"//Default tunnel desc is the <area name> (x, y) <Greek letter>
	global_tunnel_list |= src

/obj/structure/tunnel/Dispose()
	global_tunnel_list -= src
	for(var/mob/living/carbon/Xenomorph/X in contents)
		X.forceMove(loc)
		to_chat(X, SPAN_DANGER("[src] suddenly collapses, forcing you out!"))
	. = ..()

/obj/structure/tunnel/examine(mob/user)
	..()
	if(!isXeno(user) && !isobserver(user))
		return

	if(tunnel_desc)
		to_chat(user, SPAN_INFO("The pheromone scent reads: \'[tunnel_desc]\'"))

/obj/structure/tunnel/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] suddenly collapses!"))
		qdel(src)

/obj/structure/tunnel/bullet_act(var/obj/item/projectile/Proj)
	return FALSE

/obj/structure/tunnel/ex_act(severity)
	health -= severity/2
	healthcheck()

/obj/structure/tunnel/attackby(obj/item/W as obj, mob/user as mob)
	if(!isXeno(user))
		return ..()
	return attack_alien(user)

/obj/structure/tunnel/verb/use_tunnel()
	set name = "Use Tunnel"
	set category = "Object"
	set src in view(1)

	if(isXeno(usr) && (usr.loc == src))
		pick_tunnel(usr)
	else
		to_chat(usr, "You stare into the dark abyss" + "[contents.len ? ", making out what appears to be two little lights... almost like something is watching." : "."]")

/obj/structure/tunnel/verb/exit_tunnel_verb()
	set name = "Exit Tunnel"
	set category = "Object"
	set src in view(0)

	if(isXeno(usr) && (usr.loc == src))
		exit_tunnel(usr)

/obj/structure/tunnel/proc/pick_tunnel(mob/living/carbon/Xenomorph/X)
	. = FALSE	//For peace of mind when it comes to dealing with unintended proc failures
	if(!istype(X) || X.stat || X.lying)
		return FALSE
	if(X in contents)
		var/list/tunnels = list()
		for(var/obj/structure/tunnel/T in global_tunnel_list)
			if(T == src)
				continue
			tunnels += T.tunnel_desc
		var/pick = input("Which tunnel would you like to move to?") as null|anything in tunnels
		if(!pick)
			return FALSE

		if(!(X in contents))
			//Xeno moved out of the tunnel before they picked a destination
			//No teleporting!
			return FALSE

		to_chat(X, SPAN_XENONOTICE("You begin moving to your destination."))

		var/tunnel_time = TUNNEL_MOVEMENT_XENO_DELAY

		if(X.mob_size == MOB_SIZE_BIG) //Big xenos take WAY longer
			tunnel_time = TUNNEL_MOVEMENT_BIG_XENO_DELAY
		else if(isXenoLarva(X)) //Larva can zip through near-instantly, they are wormlike after all
			tunnel_time = TUNNEL_MOVEMENT_LARVA_DELAY

		if(!do_after(X, tunnel_time, INTERRUPT_NO_NEEDHAND, 0))
			return FALSE

		for(var/obj/structure/tunnel/T in global_tunnel_list)
			if(T.tunnel_desc != pick)
				continue
			if(T.contents.len > 2)// max 3 xenos in a tunnel
				to_chat(X, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
				return FALSE
			else
				X.forceMove(T)
				to_chat(X, SPAN_XENONOTICE("You have reached your destination."))
				return TRUE

/obj/structure/tunnel/proc/exit_tunnel(mob/living/carbon/Xenomorph/X)
	. = FALSE //For peace of mind when it comes to dealing with unintended proc failures
	if(X in contents)
		X.forceMove(loc)
		visible_message(SPAN_XENONOTICE("\The [X] pops out of the tunnel!"), \
		SPAN_XENONOTICE("You pop out through the other side!"))
		return TRUE

//Used for controling tunnel exiting and returning
/obj/structure/tunnel/clicked(var/mob/user, var/list/mods)
	if(!isXeno(user))
		return ..()
	var/mob/living/carbon/Xenomorph/X = user
	if(mods["ctrl"] && pick_tunnel(X))//Returning to original tunnel
		return TRUE
	else if(mods["alt"] && exit_tunnel(X))//Exiting the tunnel
		return TRUE
	. = ..()

/obj/structure/tunnel/attack_larva(mob/living/carbon/Xenomorph/M)
	. = attack_alien(M)

/obj/structure/tunnel/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!istype(M) || M.stat || M.lying)
		return FALSE

	if(M.anchored)
		to_chat(M, SPAN_XENOWARNING("You can't climb through a tunnel while immobile."))
		return FALSE

	if(!global_tunnel_list.len)
		to_chat(M, SPAN_WARNING("\The [src] doesn't seem to lead anywhere."))
		return FALSE

	if(contents.len > 2)
		to_chat(M, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
		return FALSE

	var/tunnel_time = TUNNEL_ENTER_XENO_DELAY

	if(M.mob_size == MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = TUNNEL_ENTER_BIG_XENO_DELAY
	else if(isXenoLarva(M)) //Larva can zip through near-instantly, they are wormlike after all
		tunnel_time = TUNNEL_ENTER_LARVA_DELAY

	if(M.mob_size == MOB_SIZE_BIG)
		M.visible_message(SPAN_XENONOTICE("[M] begins heaving their huge bulk down into \the [src]."), \
		SPAN_XENONOTICE("You begin heaving your monstrous bulk into \the [src]</b>."))
	else
		M.visible_message(SPAN_XENONOTICE("\The [M] begins crawling down into \the [src]."), \
		SPAN_XENONOTICE("You begin crawling down into \the [src]</b>."))

	if(!do_after(M, tunnel_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Your crawling was interrupted!"))
		return

	if(global_tunnel_list.len) //Make sure other tunnels exist
		M.forceMove(src) //become one with the tunnel
		to_chat(M, SPAN_HIGHDANGER("Alt + Click the tunnel to exit, Ctrl + Click to choose a destination."))
		pick_tunnel(M)
	else
		to_chat(M, SPAN_WARNING("\The [src] ended unexpectedly, so you return back up."))
