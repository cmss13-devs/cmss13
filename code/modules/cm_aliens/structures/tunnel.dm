/*
 * Tunnels
 */

/obj/structure/tunnel
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon_state = "hole"

	density = 0
	opacity = 0
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	layer = RESIN_STRUCTURE_LAYER

	var/tunnel_desc = "" //description added by the hivelord.

	var/hivenumber = XENO_HIVE_NORMAL
	var/datum/hive_status/hive

	health = 140
	var/id = null //For mapping

/obj/structure/tunnel/Initialize(mapload, var/h_number)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_effects))
	var/turf/L = get_turf(src)
	tunnel_desc = L.loc.name + " ([loc.x], [loc.y]) [pick(greek_letters)]"//Default tunnel desc is the <area name> (x, y) <Greek letter>

	if(h_number && GLOB.hive_datum[h_number])
		hivenumber = h_number
		hive = GLOB.hive_datum[h_number]

		set_hive_data(src, h_number)

		hive.tunnels += src

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

		hive.tunnels += src


/obj/structure/tunnel/Destroy()
	if(hive)
		hive.tunnels -= src

	for(var/mob/living/carbon/Xenomorph/X in contents)
		X.forceMove(loc)
		to_chat(X, SPAN_DANGER("[src] suddenly collapses, forcing you out!"))
	. = ..()

/obj/structure/tunnel/proc/isfriendly(var/mob/target)
	var/mob/living/carbon/C = target
	if(istype(C) && C.ally_of_hivenumber(hivenumber))
		return TRUE

	return FALSE

/obj/structure/tunnel/examine(mob/user)
	..()
	if(tunnel_desc && (isfriendly(user) || isobserver(user)))
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

	if(isXeno(usr) && isfriendly(usr) && (usr.loc == src))
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
	if(!istype(X) || X.stat || X.lying || !isfriendly(X) || !hive)
		return FALSE
	if(X in contents)
		var/list/tunnels = list()
		for(var/obj/structure/tunnel/T in hive.tunnels)
			if(T == src)
				continue
			if(!is_ground_level(T.z))
				continue

			tunnels += list(T.tunnel_desc = T)
		var/pick = input("Which tunnel would you like to move to?") as null|anything in tunnels
		if(!pick)
			return FALSE

		if(!(X in contents))
			//Xeno moved out of the tunnel before they picked a destination
			//No teleporting!
			return FALSE

		to_chat(X, SPAN_XENONOTICE("You begin moving to your destination."))

		var/tunnel_time = TUNNEL_MOVEMENT_XENO_DELAY

		if(X.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
			tunnel_time = TUNNEL_MOVEMENT_BIG_XENO_DELAY
		else if(isXenoLarva(X)) //Larva can zip through near-instantly, they are wormlike after all
			tunnel_time = TUNNEL_MOVEMENT_LARVA_DELAY

		if(!do_after(X, tunnel_time, INTERRUPT_NO_NEEDHAND, 0))
			return FALSE

		var/obj/structure/tunnel/T = tunnels[pick]

		if(T.contents.len > 2)// max 3 xenos in a tunnel
			to_chat(X, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
			return FALSE
		if(!T.loc)
			to_chat(X, SPAN_WARNING("The tunnel has collapsed before you reached its exit!"))
			return FALSE

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
	if(!isXeno(user) || !isfriendly(user))
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

	if(!isfriendly(M))
		if(M.mob_size < MOB_SIZE_BIG)
			to_chat(M, SPAN_XENOWARNING("You aren't large enough to collapse this tunnel!"))
			return

		M.visible_message(SPAN_XENODANGER("[M] begins to fill [src] with dirt."),\
		SPAN_XENONOTICE("You begin to fill [src] with dirt using your massive claws."), max_distance = 3)

		if(!do_after(M, SECONDS_10, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL_OUT_OF_RANGE, max_dist = 1))
			to_chat(M, SPAN_XENOWARNING("You decide not to cave the tunnel in."))
			return

		src.visible_message(SPAN_XENODANGER("[src] caves in!"), max_distance = 3)
		qdel(src)

		return

	if(M.anchored)
		to_chat(M, SPAN_XENOWARNING("You can't climb through a tunnel while immobile."))
		return FALSE

	if(!hive.tunnels.len)
		to_chat(M, SPAN_WARNING("\The [src] doesn't seem to lead anywhere."))
		return FALSE

	if(contents.len > 2)
		to_chat(M, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
		return FALSE

	var/tunnel_time = TUNNEL_ENTER_XENO_DELAY

	if(M.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = TUNNEL_ENTER_BIG_XENO_DELAY
	else if(isXenoLarva(M)) //Larva can zip through near-instantly, they are wormlike after all
		tunnel_time = TUNNEL_ENTER_LARVA_DELAY

	if(M.mob_size >= MOB_SIZE_BIG)
		M.visible_message(SPAN_XENONOTICE("[M] begins heaving their huge bulk down into \the [src]."), \
		SPAN_XENONOTICE("You begin heaving your monstrous bulk into \the [src]</b>."))
	else
		M.visible_message(SPAN_XENONOTICE("\The [M] begins crawling down into \the [src]."), \
		SPAN_XENONOTICE("You begin crawling down into \the [src]</b>."))

	if(!do_after(M, tunnel_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Your crawling was interrupted!"))
		return

	if(hive.tunnels.len) //Make sure other tunnels exist
		M.forceMove(src) //become one with the tunnel
		to_chat(M, SPAN_HIGHDANGER("Alt + Click the tunnel to exit, Ctrl + Click to choose a destination."))
		pick_tunnel(M)
	else
		to_chat(M, SPAN_WARNING("\The [src] ended unexpectedly, so you return back up."))
