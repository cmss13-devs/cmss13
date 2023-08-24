/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc
	name = "APC Transport Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base"
	pixel_x = -48
	pixel_y = -48
	spawn_type = /obj/vehicle/multitile/apc

/obj/effect/vehicle_spawner/apc/load_misc(obj/vehicle/multitile/V)
	. = ..()
	load_fpw(V)

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: only wheels
/obj/effect/vehicle_spawner/apc/wheels_only/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc/decrepit
	spawn_damaged = TRUE

/obj/vehicle/multitile/apc/nofpw
	interior_map = /datum/map_template/interior/apc_no_fpw

//PRESET: no FPWs, default hardpoints
/obj/effect/vehicle_spawner/apc/nofpw
	spawn_type = /obj/vehicle/multitile/apc/nofpw

/obj/effect/vehicle_spawner/apc/nofpw/load_fpw(obj/vehicle/multitile/apc/V)
	return

//PRESET: no FPWs, default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc/nofpw/decrepit
	spawn_damaged = TRUE

//PRESET: no FPWs, only wheels
/obj/effect/vehicle_spawner/apc/nofpw/wheels_only/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: no FPWs, no hardpoints
/obj/effect/vehicle_spawner/apc/nofpw/unarmed/load_hardpoints(obj/vehicle/multitile/V)
	return

//Installation of transport APC Firing Ports Weapons
/obj/effect/vehicle_spawner/apc/proc/load_fpw(obj/vehicle/multitile/apc/V)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	V.add_hardpoint(FPW)
	FPW.dir = turn(V.dir, 90)
	FPW.name = "Left "+ initial(FPW.name)
	FPW.origins = list(2, 0)
	FPW.muzzle_flash_pos = list(
		"1" = list(-18, 14),
		"2" = list(18, -42),
		"4" = list(34, 3),
		"8" = list(-32, -34)
	)

	FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	V.add_hardpoint(FPW)
	FPW.dir = turn(V.dir, -90)
	FPW.name = "Right "+ initial(FPW.name)
	FPW.origins = list(-2, 0)
	FPW.muzzle_flash_pos = list(
		"1" = list(16, 14),
		"2" = list(-18, -42),
		"4" = list(34, -34),
		"8" = list(-32, 2)
	)
