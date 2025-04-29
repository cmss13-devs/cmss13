/*
 * Tunnels
 */

#define TUNNEL_COLLAPSING_TIME (60 SECONDS)

/obj/structure/tunnel
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "hole"

	density = FALSE
	opacity = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = RESIN_STRUCTURE_LAYER
	plane = FLOOR_PLANE

	var/tunnel_desc = "" //description added by the hivelord.

	var/hivenumber = XENO_HIVE_NORMAL
	var/datum/hive_status/hive

	health = 140
	var/id = null //For mapping

/obj/structure/tunnel/Initialize(mapload, h_number)
	. = ..()
	var/turf/L = get_turf(src)
	tunnel_desc = L.loc.name + " ([loc.x], [loc.y]) [pick(GLOB.greek_letters)]"//Default tunnel desc is the <area name> (x, y) <Greek letter>

	if(h_number && GLOB.hive_datum[h_number])
		hivenumber = h_number
		hive = GLOB.hive_datum[h_number]

		set_hive_data(src, h_number)

		hive.tunnels += src

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

		hive.tunnels += src

	var/obj/effect/alien/resin/trap/resin_trap = locate() in L
	if(resin_trap)
		qdel(resin_trap)

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	SSminimaps.add_marker(src, get_minimap_flag_for_faction(hivenumber), image('icons/UI_icons/map_blips.dmi', null, "xenotunnel", VERY_HIGH_FLOAT_LAYER))

/obj/structure/tunnel/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hive.tunnels -= src
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)
		hive = GLOB.hive_datum[XENO_HIVE_FORSAKEN]
		hive.tunnels += src

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/obj/structure/tunnel/Destroy()
	if(hive)
		hive.tunnels -= src

	for(var/mob/living/carbon/xenomorph/X in contents)
		X.forceMove(loc)
		to_chat(X, SPAN_DANGER("[src] suddenly collapses, forcing you out!"))
	. = ..()

/obj/structure/tunnel/proc/isfriendly(mob/target)
	var/mob/living/carbon/C = target
	if(istype(C) && C.ally_of_hivenumber(hivenumber))
		return TRUE

	return FALSE

/obj/structure/tunnel/get_examine_text(mob/user)
	. = ..()
	if(tunnel_desc && (isfriendly(user) || isobserver(user)))
		. += SPAN_INFO("The pheromone scent reads: \'[tunnel_desc]\'")

/obj/structure/tunnel/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] suddenly collapses!"))
		qdel(src)

/obj/structure/tunnel/bullet_act(obj/projectile/Proj)
	return FALSE

/obj/structure/tunnel/ex_act(severity)
	health -= severity/2
	healthcheck()

/obj/structure/tunnel/attackby(obj/item/W as obj, mob/user as mob)
	if(!isxeno(user))
		if(istype(W, /obj/item/tool/shovel))
			var/obj/item/tool/shovel/destroying_shovel = W

			if(destroying_shovel.folded)
				return

			playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)

			user.visible_message(SPAN_NOTICE("[user] starts to collapse [src]!"), SPAN_NOTICE("You start collapsing [src]!"))

			if(user.action_busy || !do_after(user, TUNNEL_COLLAPSING_TIME * ((100 - destroying_shovel.shovelspeed) * 0.01), INTERRUPT_ALL, BUSY_ICON_BUILD))
				return

			playsound(loc, 'sound/effects/tunnel_collapse.ogg', 50)

			visible_message(SPAN_NOTICE("[src] collapses in on itself."))

			qdel(src)

		return ..()
	return attack_alien(user)

/obj/structure/tunnel/verb/use_tunnel()
	set name = "Use Tunnel"
	set category = "Object"
	set src in view(1)

	if(isxeno(usr) && isfriendly(usr) && (usr.loc == src))
		pick_tunnel(usr)
	else
		to_chat(usr, "You stare into the dark abyss" + "[length(contents) ? ", making out what appears to be two little lights... almost like something is watching." : "."]")

/obj/structure/tunnel/verb/exit_tunnel_verb()
	set name = "Exit Tunnel"
	set category = "Object"
	set src in view(0)

	if(isxeno(usr) && (usr.loc == src))
		exit_tunnel(usr)

/obj/structure/tunnel/proc/pick_tunnel(mob/living/carbon/xenomorph/X)
	. = FALSE //For peace of mind when it comes to dealing with unintended proc failures
	if(!istype(X) || X.is_mob_incapacitated(TRUE) || !isfriendly(X) || !hive)
		return FALSE
	if(X in contents)
		var/list/input_tunnels = list()

		var/list/sorted_tunnels = sort_list_dist(hive.tunnels, get_turf(X))
		for(var/obj/structure/tunnel/T in sorted_tunnels)
			if(T == src)
				continue
			if(!is_ground_level(T.z))
				continue

			input_tunnels += list(T.tunnel_desc = T)
		var/pick = tgui_input_list(usr, "Which tunnel would you like to move to?", "Tunnel", input_tunnels, theme="hive_status")
		if(!pick)
			return FALSE

		if(!(X in contents))
			//Xeno moved out of the tunnel before they picked a destination
			//No teleporting!
			return FALSE

		to_chat(X, SPAN_XENONOTICE("We begin moving to our destination."))

		var/tunnel_time = TUNNEL_MOVEMENT_XENO_DELAY

		if(X.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
			tunnel_time = TUNNEL_MOVEMENT_BIG_XENO_DELAY
		else if(islarva(X)) //Larva can zip through near-instantly, they are wormlike after all
			tunnel_time = TUNNEL_MOVEMENT_LARVA_DELAY

		if(!do_after(X, tunnel_time, INTERRUPT_NO_NEEDHAND, 0))
			return FALSE

		var/obj/structure/tunnel/T = input_tunnels[pick]

		if(length(T.contents) > 2)// max 3 xenos in a tunnel
			to_chat(X, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
			return FALSE
		if(!T.loc)
			to_chat(X, SPAN_WARNING("The tunnel has collapsed before we reached its exit!"))
			return FALSE

		X.forceMove(T)
		to_chat(X, SPAN_XENONOTICE("We have reached our destination."))
		return TRUE

/obj/structure/tunnel/proc/exit_tunnel(mob/living/carbon/xenomorph/X)
	. = FALSE //For peace of mind when it comes to dealing with unintended proc failures
	if(X in contents)
		X.forceMove(loc)
		visible_message(SPAN_XENONOTICE("\The [X] pops out of the tunnel!"),
		SPAN_XENONOTICE("We pop out through the other side!"))
		return TRUE

//Used for controling tunnel exiting and returning
/obj/structure/tunnel/clicked(mob/user, list/mods)
	if(!isxeno(user))
		return ..()

	var/mob/living/carbon/xenomorph/xeno_user = user

	if(!isfriendly(user))
		if(mods[ALT_CLICK] && exit_tunnel(xeno_user))
			return TRUE
		return ..()

	if(mods[CTRL_CLICK] && pick_tunnel(xeno_user))//Returning to original tunnel
		return TRUE
	else if(mods[ALT_CLICK] && exit_tunnel(xeno_user))//Exiting the tunnel
		return TRUE

	return ..()

/obj/structure/tunnel/attack_larva(mob/living/carbon/xenomorph/M)
	. = attack_alien(M)

/obj/structure/tunnel/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M) || M.is_mob_incapacitated(TRUE))
		return XENO_NO_DELAY_ACTION

	if(M.hivenumber != hivenumber)
		if(M.mob_size < MOB_SIZE_BIG)
			to_chat(M, SPAN_XENOWARNING("We aren't large enough to collapse this tunnel!"))
			return XENO_NO_DELAY_ACTION

		M.visible_message(SPAN_XENODANGER("[M] begins to fill [src] with dirt."),
		SPAN_XENONOTICE("We begin to fill [src] with dirt using our massive claws."), max_distance = 3)
		xeno_attack_delay(M)

		if(!do_after(M, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL_OUT_OF_RANGE, max_dist = 1))
			to_chat(M, SPAN_XENOWARNING("We decide not to cave the tunnel in."))
			return XENO_NO_DELAY_ACTION

		src.visible_message(SPAN_XENODANGER("[src] caves in!"), max_distance = 3)
		qdel(src)

		return XENO_NO_DELAY_ACTION

	if(M.anchored)
		to_chat(M, SPAN_XENOWARNING("We can't climb through a tunnel while immobile."))
		return XENO_NO_DELAY_ACTION

	if(!length(hive.tunnels))
		to_chat(M, SPAN_WARNING("[src] doesn't seem to lead anywhere."))
		return XENO_NO_DELAY_ACTION

	if(length(contents) > 2)
		to_chat(M, SPAN_WARNING("The tunnel is too crowded, wait for others to exit!"))
		return XENO_NO_DELAY_ACTION

	var/tunnel_time = TUNNEL_ENTER_XENO_DELAY

	if(M.banished)
		return

	if(M.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = TUNNEL_ENTER_BIG_XENO_DELAY
	else if(islarva(M)) //Larva can zip through near-instantly, they are wormlike after all
		tunnel_time = TUNNEL_ENTER_LARVA_DELAY

	if(M.mob_size >= MOB_SIZE_BIG)
		M.visible_message(SPAN_XENONOTICE("[M] begins heaving their huge bulk down into [src]."),
			SPAN_XENONOTICE("We begin heaving our monstrous bulk into [src] (<i>[tunnel_desc]</i>)."))
	else
		M.visible_message(SPAN_XENONOTICE("[M] begins crawling down into [src]."),
			SPAN_XENONOTICE("We begin crawling down into [src] (<i>[tunnel_desc]</i>)."))

	xeno_attack_delay(M)
	if(!do_after(M, tunnel_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Our crawling was interrupted!"))
		return XENO_NO_DELAY_ACTION

	if(length(hive.tunnels)) //Make sure other tunnels exist
		M.forceMove(src) //become one with the tunnel
		to_chat(M, SPAN_HIGHDANGER("Alt + Click the tunnel to exit, Ctrl + Click to choose a destination."))
		pick_tunnel(M)
	else
		to_chat(M, SPAN_WARNING("[src] ended unexpectedly, so we return back up."))
	return XENO_NO_DELAY_ACTION

/obj/structure/tunnel/maint_tunnel
	name = "\improper Maintenance Hatch"
	desc = "An entrance to a maintenance tunnel. You can see bits of slime and resin within. Pieces of debris keep you from getting a closer look."
	icon = 'icons/obj/structures/ladders.dmi'
	icon_state = "hatchclosed"

/obj/structure/tunnel/maint_tunnel/no_xeno_desc
	desc = "An entrance to a maintenance tunnel. Pieces of debris keep you from getting a closer look."

// Hybrisa tunnels
/obj/structure/tunnel/maint_tunnel/hybrisa
	name = "\improper Maintenance Hatch"
	desc = "An entrance to a maintenance tunnel. You can see bits of slime and resin within. Pieces of debris keep you from getting a closer look."
	icon = 'icons/obj/structures/ladders.dmi'
	icon_state = "maintenancehatch_alt"

/obj/structure/tunnel/maint_tunnel/hybrisa/no_xeno_desc
	desc = "An entrance to a maintenance tunnel. Pieces of debris keep you from getting a closer look."

/obj/structure/tunnel/maint_tunnel/hybrisa/grate
	name = "\improper Sewer Manhole"
	desc = "An entrance to a sewage maintenance tunnel. You can see bits of slime and resin within. Pieces of debris keep you from getting a closer look."
	icon = 'icons/obj/structures/ladders.dmi'
	icon_state = "wymanhole"

/obj/structure/tunnel/maint_tunnel/hybrisa/grate/no_xeno_desc
	desc = "An entrance to a sewage maintenance tunnel. Pieces of debris keep you from getting a closer look."
