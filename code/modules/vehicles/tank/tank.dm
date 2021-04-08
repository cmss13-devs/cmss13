/obj/vehicle/multitile/tank
	name = "\improper M34A2 Longstreet Light Tank"
	desc = "A giant piece of armor with a big gun, you know what to do. Entrance in the back."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = "tank"

	//tank always has 1 crewmen slot reserved and 1 general slot for other roles.
	passengers_slots = 1
	xenos_slots = 4

	entrances = list(
		"back" = list(0, 2)
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_3_ambulence.ogg'

	required_skill = SKILL_VEHICLE_LARGE

	max_momentum = 3

	luminosity = 7

	// Rest (all the guns) is handled by the tank turret hardpoint
	hardpoints_allowed = list(
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/support/weapons_sensor,
		/obj/item/hardpoint/support/overdrive_enhancer,
		/obj/item/hardpoint/support/artillery_module,
		/obj/item/hardpoint/armor/ballistic,
		/obj/item/hardpoint/armor/caustic,
		/obj/item/hardpoint/armor/concussive,
		/obj/item/hardpoint/armor/paladin,
		/obj/item/hardpoint/armor/snowplow,
		/obj/item/hardpoint/locomotion/treads,
		/obj/item/hardpoint/locomotion/treads/robust
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.5, // Acid melts the tank
		"slash" = 0.7, // Slashing a massive, solid chunk of metal does very little except leave scratches
		"bullet" = 0.4,
		"explosive" = 0.8,
		"blunt" = 0.8,
		"abstract" = 1.0
	)

	explosive_resistance = 400

/obj/vehicle/multitile/tank/initialize_cameras(var/change_tag = FALSE)
	if(!camera_int)
		camera_int = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera_int.c_tag = "#[rand(1,100)] M34A2 \"[nickname]\" Tank" //this fluff allows it to be at the start of cams list
	else
		camera_int.c_tag = "#[rand(1,100)] M34A2 Tank"

/obj/vehicle/multitile/tank/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_UPP_CREWMAN)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/tank/load_hardpoints()
	add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)

/obj/vehicle/multitile/tank/add_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
		))
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_gyrostabilizer,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))


/obj/vehicle/multitile/tank/remove_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/proc/switch_hardpoint,
	))
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
		))
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_gyrostabilizer,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))

//Called when players try to move vehicle
//Another wrapper for try_move()
/obj/vehicle/multitile/tank/relaymove(var/mob/user, var/direction)
	if(user == seats[VEHICLE_DRIVER])
		return ..()

	if(user != seats[VEHICLE_GUNNER])
		return FALSE

	var/obj/item/hardpoint/holder/tank_turret/T = null
	for(var/obj/item/hardpoint/holder/tank_turret/TT in hardpoints)
		T = TT
		break
	if(!T)
		return FALSE

	if(direction == reverse_dir[T.dir] || direction == T.dir)
		return FALSE

	T.user_rotation(user, turning_angle(T.dir, direction))
	update_icon()

	return TRUE

/*
** PRESETS
*/

//Tank spawner that spawns in a tank that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/tank/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/primary/cannon)
	T.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola)

//Tank spawner that spawns in a tank that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/tank/fixed_minigun/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/primary/minigun)
	T.add_hardpoint(new /obj/item/hardpoint/secondary/grenade_launcher)

/obj/vehicle/multitile/tank/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/primary/cannon)
	T.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola)

/obj/vehicle/multitile/tank/decrepit/load_damage(var/obj/vehicle/multitile/R)
	// once to break the hardpoints
	take_damage_type(1e8, "abstract")
	// once more to break the frame
	take_damage_type(1e8, "abstract")
	healthcheck()

/obj/vehicle/multitile/tank/plain/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
