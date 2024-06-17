

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

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/box_van/pizza_van/spawn_vehicle()

//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/box_van/pizza_van/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/box_van/pizza_van/PIZZA = new (loc)

	load_misc(PIZZA)
	load_hardpoints(PIZZA)
	handle_direction(PIZZA)
	load_damage(PIZZA)
	PIZZA.update_icon()

/obj/effect/vehicle_spawner/box_van/pizza_van/decrepit/load_hardpoints(obj/vehicle/multitile/box_van/pizza_van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)

//PRESET: wheels installed
/obj/effect/vehicle_spawner/box_van/pizza_van/fixed/spawn_vehicle()
	var/obj/vehicle/multitile/box_van/pizza_van/PIZZA = new (loc)

	load_misc(PIZZA)
	load_hardpoints(PIZZA)
	handle_direction(PIZZA)
	PIZZA.update_icon()

/obj/effect/vehicle_spawner/box_van/pizza_van/fixed/load_hardpoints(obj/vehicle/multitile/box_van/pizza_van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)
