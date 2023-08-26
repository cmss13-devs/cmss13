/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc/med
	name = "APC MED Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base_med"
	pixel_x = -48
	pixel_y = -48
	spawn_type = /obj/vehicle/multitile/apc/medical

/obj/effect/vehicle_spawner/apc/med/load_fpw(obj/vehicle/multitile/apc/V)
	return

//PRESET: only wheels
/obj/effect/vehicle_spawner/apc/med/wheels_only/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc/med/decrepit
	spawn_damaged = TRUE
