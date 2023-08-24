/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/van
	name = "Van Spawner"
	icon = 'icons/obj/vehicles/van.dmi'
	icon_state = "van_base"
	pixel_x = -16
	pixel_y = -16
	spawn_type = /obj/vehicle/multitile/van

//PRESET: wheels
/obj/effect/vehicle_spawner/van/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)

//PRESET: wheels, destroyed
/obj/effect/vehicle_spawner/van/decrepit
	spawn_damaged = TRUE
