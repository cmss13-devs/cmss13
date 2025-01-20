

//Trucks
//Read the documentation in multitile.dm before trying to decipher this stuff

/obj/vehicle/multitile/box_van/pizza_van
	name = "\improper box-van"
	icon = 'icons/obj/vehicles/pizza_van.dmi'

	interior_map = /datum/map_template/interior/pizza_van


/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/box_van/pizza_van
	name = "Pizza-Galaxy Van Spawner"
	icon = 'icons/obj/vehicles/pizza_van.dmi'
	icon_state = "van_base"

	vehicle_type = /obj/vehicle/multitile/box_van/pizza_van

/obj/effect/vehicle_spawner/box_van/pizza_van/spawn_vehicle(obj/vehicle/multitile/spawning)
	load_misc(spawning)
	load_hardpoints(spawning)
	handle_direction(spawning)
	spawning.update_icon()

//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/box_van/decrepit/pizza_van
	name = "Pizza-Galaxy Van Spawner"
	icon = 'icons/obj/vehicles/pizza_van.dmi'
	icon_state = "van_base"

	vehicle_type = /obj/vehicle/multitile/box_van/pizza_van
	hardpoints = list(
		/obj/item/hardpoint/locomotion/van_wheels,
	)

//PRESET: wheels installed
/obj/effect/vehicle_spawner/box_van/fixed/pizza_van
	name = "Pizza-Galaxy Van Spawner"
	icon = 'icons/obj/vehicles/pizza_van.dmi'
	icon_state = "van_base"

	vehicle_type = /obj/vehicle/multitile/box_van/pizza_van
	hardpoints = list(
		/obj/item/hardpoint/locomotion/van_wheels,
	)
