/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/tank
	name = "Tank Spawner"
	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48
	spawn_type = /obj/vehicle/multitile/tank

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/tank/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	V.add_hardpoint(new /obj/item/hardpoint/armor/paladin)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/cannon)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola)
		break

//PRESET: only threads, empty turret
/obj/effect/vehicle_spawner/tank/plain/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/tank/decrepit
	spawn_damaged = TRUE

//PRESET: minigun kit
/obj/effect/vehicle_spawner/tank/minigun/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/weapons_sensor)
	V.add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/minigun)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/small_flamer)
		break

//PRESET: dragon flamer kit
/obj/effect/vehicle_spawner/tank/flamer/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	V.add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/flamer)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/grenade_launcher)
		break

//PRESET: autocannon kit
/obj/effect/vehicle_spawner/tank/autocannon/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	V.add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/autocannon)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/towlauncher)
		break
