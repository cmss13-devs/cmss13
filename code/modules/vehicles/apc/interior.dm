// APC interior stuff

//wall

/obj/structure/interior_wall/apc
	name = "\improper APC interior wall"
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "apc_right_1"

/obj/structure/interior_exit/vehicle/apc
	name = "APC side door"
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "exit_door"

/obj/structure/interior_exit/vehicle/apc/rear
	name = "APC rear hatch"
	icon_state = "door_rear_center"

/obj/structure/interior_exit/vehicle/apc/rear/left
	icon_state = "door_rear_left"

/obj/structure/interior_exit/vehicle/apc/rear/right
	icon_state = "door_rear_right"

/obj/structure/prop/vehicle
	name = "Generic vehicle prop"
	desc = "Adds more flavour to vehicle interior."

	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = ""

	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE
	indestructible = TRUE

/obj/structure/prop/vehicle/firing_port_weapon
	name = "M56 FPW handle"
	desc = "A control handle for a modified M56B Smartgun installed on the sides of M577 Armored Personnel Carrier as a Firing Port Weapon. \
	Used by support gunners to cover friendly infantry entering or exiting APC via side doors. \
	Do not be mistaken however, this is not a piece of an actual weapon, but a joystick made in a familiar to marines form."

	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "m56_FPW"

	density = FALSE

/obj/structure/prop/vehicle/sensor_equipment
	name = "Data Analyzing Nexus"
	desc = "This machinery collects and analyzes data from the M577 CMD APC's sensors cluster and then feeds the results to Almayer's tactical map display network. Better not touch it."

	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "sensors_equipment"
