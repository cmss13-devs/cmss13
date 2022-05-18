/obj/structure/machinery/computer/teleporter
	name = "Teleporter"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_state = "teleport"
	circuit = /obj/item/circuitboard/computer/teleporter
	dir = EAST
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set src.locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/structure/machinery/computer/teleporter/Initialize()
	. = ..()
	src.id = "[rand(1000, 9999)]"
	underlays.Cut()
	underlays += image('icons/obj/structures/props/stationobjs.dmi', icon_state = "telecomp-wires")
	return

/obj/structure/machinery/computer/teleporter/Initialize()
	. = ..()
	var/obj/structure/machinery/teleport/station/station = locate(/obj/structure/machinery/teleport/station, get_step(src, dir))
	var/obj/structure/machinery/teleport/hub/hub
	if(station)
		hub = locate(/obj/structure/machinery/teleport/hub, get_step(station, dir))

	if(istype(station))
		station.com = hub
		station.setDir(dir)

	if(istype(hub))
		hub.com = src
		hub.setDir(dir)

/obj/structure/machinery/computer/teleporter/attackby(I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/card/data/))
		var/obj/item/card/data/C = I
		if(inoperable() & (C.function != "teleporter"))
			src.attack_hand()

		var/obj/L = null

		for(var/i in GLOB.teleporter_landmarks)
			var/obj/effect/landmark/sloc = i
			if(sloc.name != C.data) continue
			if(locate(/mob/living) in sloc.loc) continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*[C.data]") // use old stype


		if(istype(L, /obj/effect/landmark/) && istype(L.loc, /turf))
			to_chat(usr, "You insert the coordinates into the machine.")
			to_chat(usr, "A message flashes across the screen reminding the traveller that the nuclear authentication disk is to remain on the station at all times.")
			user.drop_held_item()
			qdel(I)

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_message(SPAN_DANGER("Incoming hyperspace portal detected, unable to lock in."), 2)

				for(var/obj/structure/machinery/teleport/hub/H in range(1))
					var/amount = rand(2,5)
					for(var/i=0;i<amount;i++)
						new /mob/living/simple_animal/hostile/carp(get_turf(H))
				//
			else
				for(var/mob/O in hearers(src, null))
					O.show_message(SPAN_NOTICE("Locked In"), 2)
				src.locked = L
				one_time_use = 1

			src.add_fingerprint(usr)
	else
		..()

	return

/obj/structure/machinery/teleport/station/attack_remote()
	src.attack_hand()

/obj/structure/machinery/computer/teleporter/attack_hand()
	if(inoperable())
		return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/i in GLOB.radio_beacon_list)
		var/obj/item/device/radio/beacon/R = i
		var/turf/T = get_turf(R)
		if (!T)
			continue
		if(is_admin_level(T.z))
			continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for (var/j in GLOB.tracking_implant_list)
		var/obj/item/implant/tracking/I = j
		if (!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if (M.stat == 2)
				if (M.timeofdeath + 6000 < world.time)
					continue
			var/turf/T = get_turf(M)
			if(T)	continue
			if(is_admin_level(T.z))	continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I

	var/desc = tgui_input_list(usr, "Please select a location to lock in.", "Locking Computer", L)
	if(!desc)
		return
	if(get_dist(src, usr) > 1 && !isRemoteControlling(usr))
		return

	src.locked = L[desc]
	for(var/mob/O in hearers(src, null))
		O.show_message(SPAN_NOTICE("Locked In"), 2)
	src.add_fingerprint(usr)
	return

/obj/structure/machinery/computer/teleporter/verb/set_id(t as text)
	set category = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Tag:"

	if(inoperable() || !istype(usr,/mob/living))
		return
	if (t)
		src.id = t
	return

/proc/find_loc(obj/R as obj)
	if (!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/obj/structure/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	density = 1
	anchored = 1.0
	var/lockeddown = 0


/obj/structure/machinery/teleport/hub
	name = "teleporter hub"
	desc = "It's the hub of a teleporting machine."
	icon_state = "tele0"
	dir = EAST
	var/accurate = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/structure/machinery/computer/teleporter/com

/obj/structure/machinery/teleport/hub/Initialize(mapload, ...)
	. = ..()
	underlays.Cut()
	underlays += image('icons/obj/structures/props/stationobjs.dmi', icon_state = "tele-wires")

/obj/structure/machinery/teleport/hub/Collided(atom/movable/AM)
	spawn()
		if (src.icon_state == "tele1")
			teleport(AM)
			use_power(5000)
	return

/obj/structure/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj)
	if (!com)
		return
	if (!com.locked)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_DANGER("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix."))
		return
	if (istype(M, /atom/movable))
		if(prob(5) && !accurate) //oh dear a problem, put em in deep space
			do_teleport(M, locate(rand((2*TRANSITIONEDGE), world.maxx - (2*TRANSITIONEDGE)), rand((2*TRANSITIONEDGE), world.maxy - (2*TRANSITIONEDGE)), 3), 2)
		else
			do_teleport(M, com.locked) //dead-on precision

		if(com.one_time_use) //Make one-time-use cards only usable one time!
			com.one_time_use = 0
			com.locked = null
	else
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		accurate = 1
		spawn(5 MINUTES)	accurate = 0 //Accurate teleporting for 5 minutes
		for(var/mob/B in hearers(src, null))
			B.show_message(SPAN_NOTICE("Test fire completed."))
	return
/*
/proc/do_teleport(atom/movable/M as mob|obj, atom/destination, precision)
	if(istype(M, /obj/effect))
		qdel(M)
		return
	if (istype(M, /obj/item/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		for(var/mob/O in viewers(M, null))
			O.show_message(text(SPAN_DANGER("<B>The [] bounces off of the portal!</B>"), M.name), 1)
		return
	if (istype(M, /mob/living))
		var/mob/living/MM = M
		if(MM.check_contents_for(/obj/item/disk/nuclear))
			to_chat(MM, SPAN_WARNING("Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through."))
			return
	var/disky = 0
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if (istype(O, /obj/item/storage) || istype(O, /obj/item/gift))
			for (var/obj/OO in O.contents)
				if (istype(OO, /obj/item/storage) || istype(OO, /obj/item/gift))
					for (var/obj/OOO in OO.contents)
						if (istype(OOO, /obj/item/disk/nuclear))
							disky = 1
				if (istype(OO, /obj/item/disk/nuclear))
					disky = 1
		if (istype(O, /obj/item/disk/nuclear))
			disky = 1
		if (istype(O, /mob/living))
			var/mob/living/MM = O
			if(MM.check_contents_for(/obj/item/disk/nuclear))
				disky = 1
	if (disky)
		for(var/mob/P in viewers(M, null))
			P.show_message(text(SPAN_DANGER("<B>The [] bounces off of the portal!</B>"), M.name), 1)
		return

//Bags of Holding cause bluespace teleportation to go funky. --NeoFite
	if (istype(M, /mob/living))
		var/mob/living/MM = M
		if(MM.check_contents_for(/obj/item/storage/backpack/holding))
			to_chat(MM, SPAN_WARNING("The Bluespace interface on your Bag of Holding interferes with the teleport!"))
			precision = rand(1,100)
	if (istype(M, /obj/item/storage/backpack/holding))
		precision = rand(1,100)
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if (istype(O, /obj/item/storage) || istype(O, /obj/item/gift))
			for (var/obj/OO in O.contents)
				if (istype(OO, /obj/item/storage) || istype(OO, /obj/item/gift))
					for (var/obj/OOO in OO.contents)
						if (istype(OOO, /obj/item/storage/backpack/holding))
							precision = rand(1,100)
				if (istype(OO, /obj/item/storage/backpack/holding))
					precision = rand(1,100)
		if (istype(O, /obj/item/storage/backpack/holding))
			precision = rand(1,100)
		if (istype(O, /mob/living))
			var/mob/living/MM = O
			if(MM.check_contents_for(/obj/item/storage/backpack/holding))
				precision = rand(1,100)


	var/turf/destturf = get_turf(destination)

	var/tx = destturf.x + rand(precision * -1, precision)
	var/ty = destturf.y + rand(precision * -1, precision)

	var/tmploc

	if (ismob(destination.loc)) //If this is an implant.
		tmploc = locate(tx, ty, destturf.z)
	else
		tmploc = locate(tx, ty, destination.z)

	if(tx == destturf.x && ty == destturf.y && (istype(destination.loc, /obj/structure/closet) || istype(destination.loc, /obj/structure/closet/secure_closet)))
		tmploc = destination.loc

	if(tmploc==null)
		return

	M.forceMove(tmploc)
	sleep(2)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, M)
	s.start()
	return
*/

/obj/structure/machinery/teleport/station
	name = "station"
	desc = "It's the station thingy of a teleport thingy." //seriously, wtf.
	icon_state = "controller"
	dir = EAST
	var/active = 0
	var/engaged = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/structure/machinery/teleport/hub/com

/obj/structure/machinery/teleport/station/Initialize(mapload, ...)
	. = ..()
	overlays.Cut()
	overlays += image('icons/obj/structures/props/stationobjs.dmi', icon_state = "controller-wires")

/obj/structure/machinery/teleport/station/attackby(var/obj/item/W)
	src.attack_hand()

/obj/structure/machinery/teleport/station/attack_remote()
	src.attack_hand()

/obj/structure/machinery/teleport/station/attack_hand()
	if(engaged)
		src.disengage()
	else
		src.engage()

/obj/structure/machinery/teleport/station/proc/engage()
	if(inoperable())
		return

	if (com)
		com.icon_state = "tele1"
		use_power(5000)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter engaged!"), 2)
	src.add_fingerprint(usr)
	src.engaged = 1
	return

/obj/structure/machinery/teleport/station/proc/disengage()
	if(inoperable())
		return

	if (com)
		com.icon_state = "tele0"
		com.accurate = 0
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter disengaged!"), 2)
	src.add_fingerprint(usr)
	src.engaged = 0
	return

/obj/structure/machinery/teleport/station/verb/testfire()
	set name = "Test Fire Teleporter"
	set category = "Object"
	set src in oview(1)

	if(inoperable() || !istype(usr,/mob/living))
		return

	if (com && !active)
		active = 1
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Test firing!"), 2)
		com.teleport()
		use_power(5000)

		addtimer(VARSET_CALLBACK(src, active, FALSE), 3 SECONDS)

	src.add_fingerprint(usr)
	return

/obj/structure/machinery/teleport/station/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "controller-p"

		if(com)
			com.icon_state = "tele0"
	else
		icon_state = "controller"




/obj/effect/laser
	name = "laser"
	desc = "IT BURNS!!!"
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	var/damage = 0.0
	var/range = 10.0


/obj/effect/laser/Collide(atom/A)
	src.range--
	return

/obj/effect/laser/Move()
	src.range--
	return

/atom/proc/laserhit(L as obj)
	return 1
