/client/verb/dstesting()
	set name = "1 - Dropship PREP"
	set category = "Debug.AAAA"

	var/turf/T = get_turf(usr)
	new /obj/vehicle/powerloader(locate(T.x, T.y - 2, T.z))
	new /obj/structure/ship_ammo/heavygun(T)
	new /obj/structure/dropship_equipment/weapon/heavygun(T)
	new /obj/structure/ship_ammo/minirocket/incendiary(locate(T.x + 1, T.y, T.z))
	new /obj/structure/dropship_equipment/weapon/minirocket_pod(locate(T.x + 1, T.y, T.z))
	for(var/obj/structure/machinery/computer/shuttle_control/S in world)
		S.skip_time_lock = TRUE

/client/verb/dstesting2()
	set name = "2 - Target PREP"
	set category = "Debug.AAAA"
	var/atom/box = new /obj/item/storage/box/m94/signal(usr.loc)
	for(var/obj/item/device/flashlight/flare/signal/S in box)
		S.fuel = 39939391
		S.indestructible = TRUE
	usr.put_in_hands(box)
	usr.forceMove(locate(131, 69, 3))

/client/verb/dstesting3()
	set name = "3 - TELEPORT BACK"
	set category = "Debug.AAAA"

	usr.forceMove(locate(114, 58, 4))
