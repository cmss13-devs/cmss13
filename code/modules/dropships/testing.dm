/client/verb/dstesting()
	set name = "DROPSHIP TESTING"
	set category = "Debug.AAAA"

	var/turf/T = get_turf(usr)
	new /obj/vehicle/powerloader(locate(T.x, T.y - 2, T.z))
	new /obj/structure/ship_ammo/heavygun(T)
	new /obj/structure/dropship_equipment/weapon/heavygun(T)
	var/atom/box = new /obj/item/storage/box/m94/signal(T)
	for(var/obj/item/device/flashlight/flare/signal/S in box)
		S.fuel = 39939391
	for(var/obj/structure/machinery/computer/shuttle_control/S in world)
		S.skip_time_lock = TRUE
