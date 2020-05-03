/obj/vehicle/multitile/apc
	name = "\improper M577 Armored Personnel Carrier"
	desc = "A giant piece of armor with four big wheels, you know what to do. Entrance on the sides."

	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = "apc"
	interior_capacity = 10
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0)
	)

	movement_sound = 'sound/ambience/tank_driving.ogg'

	luminosity = 7

	hardpoints_allowed = list(
		/obj/item/hardpoint/gun/dualcannon,
		/obj/item/hardpoint/gun/frontalcannon,
		/obj/item/hardpoint/gun/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

/obj/vehicle/multitile/apc/add_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	M.client.verbs += /obj/vehicle/multitile/proc/get_status_info
	M.client.verbs += /obj/vehicle/multitile/proc/open_controls_guide
	if(seat == VEHICLE_DRIVER)
		M.client.verbs += /obj/vehicle/multitile/proc/toggle_door_lock
	else if(seat == VEHICLE_GUNNER)
		M.client.verbs += /obj/vehicle/multitile/proc/switch_hardpoint
		M.client.verbs += /obj/vehicle/multitile/proc/cycle_hardpoint
		M.client.verbs += /obj/vehicle/multitile/proc/toggle_shift_click

/obj/vehicle/multitile/apc/remove_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	M.client.verbs -= /obj/vehicle/multitile/proc/get_status_info
	M.client.verbs -= /obj/vehicle/multitile/proc/open_controls_guide
	if(seat == VEHICLE_DRIVER)
		M.client.verbs -= /obj/vehicle/multitile/proc/toggle_door_lock
	else if(seat == VEHICLE_GUNNER)
		M.client.verbs -= /obj/vehicle/multitile/proc/switch_hardpoint
		M.client.verbs -= /obj/vehicle/multitile/proc/cycle_hardpoint
		M.client.verbs -= /obj/vehicle/multitile/proc/toggle_shift_click

/obj/structure/interior_wall/apc
	name = "\improper APC interior wall"
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "apc_right_1"

/obj/structure/interior_exit/vehicle/apc
	name = "APC door"
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "exit_door"

/*
** PRESETS
*/

//apc spawner that spawns in an apc that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/apc/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/gun/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/gun/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract") //OOF.ogg
	take_damage_type(1e8, "abstract") //OOF.ogg

/obj/vehicle/multitile/apc/medical
	name = "\improper M577-MED Armored Personnel Carrier"
	desc = "A giant piece of armor with four big wheels and advanced medical equipment inside, you know what to do. Entrance on the sides."

	icon_state = "apc_base_med"

	interior_map = "apc_med"
	interior_capacity = 5

/obj/vehicle/multitile/apc/medical/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/gun/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/medical/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract") //OOF.ogg
	take_damage_type(1e8, "abstract") //OOF.ogg

/obj/vehicle/multitile/apc/medical/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/gun/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/command
	name = "\improper M577-CMD Armored Personnel Carrier"
	desc = "A giant piece of armor with four big wheels and a command station inside, you know what to do. Entrance on the sides."

	interior_map = "apc_command"
	interior_capacity = 5

/obj/vehicle/multitile/apc/command/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/gun/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/command/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract") //OOF.ogg
	take_damage_type(1e8, "abstract") //OOF.ogg

/obj/vehicle/multitile/apc/command/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/gun/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/gun/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)