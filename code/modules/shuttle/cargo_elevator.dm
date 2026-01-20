/obj/docking_port/mobile/cargo_elevator
	name = "cargo elevator"
	width = 3
	height = 3
	dwidth = 1
	dheight = 1

	id = MOBILE_SHUTTLE_CARGO_ELEVATOR

	// Call and ""ignition"" times are set to line up with the sound effects.
	callTime = 0 SECONDS
	ignitionTime = 5 SECONDS

	ignition_sound = 'sound/machines/asrs_lowering.ogg'
	ambience_idle = null
	ambience_flight = null

	var/list/railings = list()
	var/list/gears = list()


/obj/docking_port/mobile/cargo_elevator/register()
	. = ..()
	SSshuttle.cargo_elevator = src

/obj/docking_port/stationary/cargo_elevator
	name = "Root Vehicle Elevator Dock"
	id = "root cargo"
	width = 3
	height = 3
	dwidth = 1
	dheight = 1

/obj/docking_port/stationary/cargo_elevator/lower
	id = "lower cargo"
	roundstart_template = /datum/map_template/shuttle/cargo

/obj/docking_port/stationary/cargo_elevator/upper
	id = "upper cargo"


/obj/structure/machinery/computer/cargo_elevator/attack_hand(mob/living/user)
	if(SSshuttle.cargo_elevator.mode != SHUTTLE_IDLE)
		return
	var/turf/lower_turf = get_turf(SSshuttle.getDock("lower cargo"))
	if(SSshuttle.cargo_elevator.z == lower_turf.z)
		SSshuttle.cargo_elevator.request(SSshuttle.getDock("upper cargo"))
	else
		SSshuttle.cargo_elevator.request(SSshuttle.getDock("lower cargo"))




/datum/map_template/shuttle/cargo
	shuttle_id = MOBILE_SHUTTLE_CARGO_ELEVATOR
	name = "Vehicle Elevator"


