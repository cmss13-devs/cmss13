/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc/cmd
	name = "APC CMD Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base_com"
	pixel_x = -48
	pixel_y = -48
	spawn_type = /obj/vehicle/multitile/apc/command

/obj/effect/vehicle_spawner/apc/cmd/load_fpw(obj/vehicle/multitile/apc/V)
	return

//PRESET: only wheels
/obj/effect/vehicle_spawner/apc/cmd/wheels_only/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc/cmd/decrepit
	spawn_damaged = TRUE
