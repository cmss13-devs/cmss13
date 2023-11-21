/obj/item/hardpoint/locomotion/truck
	icon = 'icons/obj/vehicles/hardpoints/truck.dmi'
	icon_state = "truck_tires"
	slot = HDPT_WHEELS


	//TRUCK Wheels
/obj/item/hardpoint/locomotion/truck/wheels
	name = "military wheels"
	desc = "Integral to the movement of the military truck."
	icon_state = "Military_wheels"
	disp_icon = "truck"
	disp_icon_state = "miltruckwheels"

	health = 250

	move_delay = VEHICLE_SPEED_VERYFAST

/obj/item/hardpoint/locomotion/truck/wheels/civtruck
	name = "civilian truck wheels"
	desc = "Integral to the movement of the civilian trucks."
	icon_state = "Civilian_truck_wheels"
	disp_icon = "truck"
	disp_icon_state = "civtruckwheels"

/obj/item/hardpoint/locomotion/truck/wheels/civvan
	name = "civilian van wheels"
	desc = "Integral to the movement of the civilian van."
	icon_state = "Civilian_van_wheels"
	disp_icon = "truck"
	disp_icon_state = "civvanwheels"


	//TRUCK Treads
/obj/item/hardpoint/locomotion/truck/treads
	name = "light treads"
	desc = "Integral to the movement of the military truck."
	icon_state = "Light_treads"
	disp_icon = "truck"
	disp_icon_state = "miltrucktreads"

	health = 500

	//with this settings, takes 3 tiles to reach top speed
	move_delay = 3.8
	move_max_momentum = 3
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

/obj/item/hardpoint/locomotion/truck/treads/crane
	name = "crane treads"
	desc = "Integral to the movement of the crane."
	icon_state = "Crane_treads"
	disp_icon = "truck"
	disp_icon_state = "cranetreads"
