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
	entrances = list(
		"back" = list(0, 2)
	)

	movement_sound = 'sound/ambience/tank_driving.ogg'

	max_momentum = 2

	luminosity = 7

	// Rest (all the guns) is handled by the tank turret hardpoint
	hardpoints_allowed = list(
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/gun/smoke_launcher,
		/obj/item/hardpoint/buff/support/weapons_sensor,
		/obj/item/hardpoint/buff/support/overdrive_enhancer,
		/obj/item/hardpoint/artillery_module,
		/obj/item/hardpoint/buff/armor/ballistic,
		/obj/item/hardpoint/buff/armor/caustic,
		/obj/item/hardpoint/buff/armor/concussive,
		/obj/item/hardpoint/buff/armor/paladin,
		/obj/item/hardpoint/buff/armor/snowplow,
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
		"all" = 0.95,
		"acid" = 1.5, // Acid melts the tank
		"slash" = 0.5, // Slashing a massive, solid chunk of metal does very little except leave scratches
		"bullet" = 0.9,
		"explosive" = 0.9,
		"blunt" = 1.1,
		"abstract" = 1.0
	)

	explosive_resistance = 400

/obj/vehicle/multitile/tank/load_hardpoints()
	add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)

/obj/vehicle/multitile/tank/add_seated_verbs(var/mob/living/M, var/seat)
	if(seat == VEHICLE_DRIVER)
		M.client.verbs += /obj/vehicle/multitile/proc/toggle_door_lock
	else if(seat == VEHICLE_GUNNER)
		M.client.verbs += /obj/vehicle/multitile/proc/switch_hardpoint
		M.client.verbs += /obj/vehicle/multitile/proc/cycle_hardpoint
		M.client.verbs += /obj/vehicle/multitile/tank/proc/toggle_gyrostabilizer

/obj/vehicle/multitile/tank/remove_seated_verbs(var/mob/living/M, var/seat)
	if(seat == VEHICLE_DRIVER)
		M.client.verbs -= /obj/vehicle/multitile/proc/toggle_door_lock
	else if(seat == VEHICLE_GUNNER)
		M.client.verbs -= /obj/vehicle/multitile/proc/switch_hardpoint
		M.client.verbs -= /obj/vehicle/multitile/proc/cycle_hardpoint
		M.client.verbs -= /obj/vehicle/multitile/tank/proc/toggle_gyrostabilizer

/obj/vehicle/multitile/tank/proc/toggle_gyrostabilizer()
	set category = "Vehicle"
	set name = "Toggle Turret Gyrostabilizer"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in V.hardpoints
	if(!T)
		return
	T.toggle_gyro()

//Called when players try to move vehicle
//Another wrapper for try_move()
/obj/vehicle/multitile/tank/relaymove(var/mob/user, var/direction)
	if(user == seats[VEHICLE_DRIVER])
		return ..()

	if(user != seats[VEHICLE_GUNNER])
		return FALSE

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
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

	add_hardpoint(new /obj/item/hardpoint/buff/support/overdrive_enhancer)
	add_hardpoint(new /obj/item/hardpoint/buff/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/gun/cannon)
	T.add_hardpoint(new /obj/item/hardpoint/gun/m56cupola)

//Tank spawner that spawns in a tank that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/tank/fixed_minigun/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/buff/support/overdrive_enhancer)
	//add_hardpoint(new /obj/item/hardpoint/buff/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/gun/minigun)
	T.add_hardpoint(new /obj/item/hardpoint/gun/grenade_launcher)

/obj/vehicle/multitile/tank/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/gun/smoke_launcher)
	add_hardpoint(new /obj/item/hardpoint/buff/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/gun/cannon)
	T.add_hardpoint(new /obj/item/hardpoint/gun/m56cupola)

/obj/vehicle/multitile/tank/decrepit/load_damage(var/obj/vehicle/multitile/R)
	// once to break the hardpoints
	take_damage_type(1e8, "abstract") //OOF.ogg
	// once more to break the frame
	take_damage_type(1e8, "abstract")

/obj/vehicle/multitile/tank/plain/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
