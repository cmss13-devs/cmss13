/datum/test_environment/tank_gallery
	environment_string = {"
		HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFaFFFFbFFFFcFFFFdFFFFeFFFFfFFFFgFFFFhFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFFFFFFFFFFFFFFFFFFFMFFFFFFFFFFFFFFFFFFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFiFFFFjFFFFkFFFFlFFFFmFFFFnFFFFoFFFFpFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFH
		HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
	"}

	var/mob/curator = null

/datum/test_environment/tank_gallery/populate(char, char_turf)
	new /turf/open/floor/almayer(char_turf)

	if(char == "M")
		curator = new /mob/living/carbon/human(char_turf)
		return

	var/list/dirs = list("a" = 1, "b" = 2, "c" = 1, "d" = 2, "e" = 1, "f" = 2, "g" = 1, "h" = 2, "i" = 4, "j" = 8, "k" = 4, "l" = 8, "m" = 4, "n" = 8, "o" = 4, "p" = 8)

	var/list/dir2rotation = list(
		"1" = 180,
		"2" = 0,
		"4" = 90,
		"8" = 270
	)

	var/obj/vehicle/multitile/tank/plain/tank = new /obj/vehicle/multitile/tank/plain(char_turf)
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in tank.hardpoints
	switch(char)
		if("a", "b", "i", "j")
			tank.add_hardpoint(new /obj/item/hardpoint/buff/support/overdrive_enhancer)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/autocannon)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/m56cupola)
		if("c", "d", "k", "l")
			tank.add_hardpoint(new /obj/item/hardpoint/gun/smoke_launcher)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/flamer)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/small_flamer)
		if("e", "f", "m", "n")
			tank.add_hardpoint(new /obj/item/hardpoint/artillery_module)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/cannon)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/grenade_launcher)
		if("g", "h", "o", "p")
			tank.add_hardpoint(new /obj/item/hardpoint/buff/support/weapons_sensor)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/minigun)
			turret.add_hardpoint(new /obj/item/hardpoint/gun/towlauncher)

	turret.rotate(dir2rotation["[dirs[char]]"])
	tank.update_icon()

// Key into the mob
/datum/test_environment/tank_gallery/insert_actors()
	set waitfor = FALSE

	// Wait for a client to key in
	while(!length(clients))
		sleep(10)

	for(var/client/C in clients)
		var/datum/mind/M = C.mob.mind
		M.transfer_to(curator)

		// Equip the mob as a VC
		arm_equipment(curator, "USCM Vehicle Crewman (CRMN)", TRUE, TRUE)

		break
