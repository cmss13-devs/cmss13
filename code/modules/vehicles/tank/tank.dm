/obj/vehicle/multitile/tank
	name = "M34A2 Longstreet Light Tank"
	desc = "A giant piece of armor with a big gun, you know what to do. Entrance in the back."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = /datum/map_template/interior/tank

	//tank always has 2 crewmen slot reserved and 1 general slot for other roles.
	passengers_slots = 1
	//this is done in case VCs die inside the tank, so that someone else can come in and take them out.
	revivable_dead_slots = 2
	xenos_slots = 4

	entrances = list(
		"back" = list(0, 2)
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_3_ambulence.ogg'

	required_skill = SKILL_VEHICLE_LARGE

	vehicle_flags = VEHICLE_CLASS_MEDIUM

	move_max_momentum = 3
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

	vehicle_light_range = 7

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
		/obj/item/hardpoint/locomotion/treads/robust,
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	actions_list = list(
		"global" = list(
			/obj/vehicle/multitile/proc/get_status_info,
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/open_controls_guide,
			/obj/vehicle/multitile/proc/name_vehicle,
		),
		VEHICLE_DRIVER = list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/use_megaphone,
		),
		VEHICLE_GUNNER = list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_gyrostabilizer,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		)
	)

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.5, // Acid melts the tank
		"slash" = 0.7, // Slashing a massive, solid chunk of metal does very little except leave scratches
		"bullet" = 0.4,
		"explosive" = 0.8,
		"blunt" = 0.8,
		"abstract" = 1,
	)

	explosive_resistance = 400

/obj/vehicle/multitile/tank/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M34A2 \"[nickname]\" Tank" //this fluff allows it to be at the start of cams list
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior" //this fluff allows it to be at the start of cams list
	else
		camera.c_tag = "#[rand(1,100)] M34A2 Tank"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior" //this fluff allows it to be at the start of cams list

/obj/vehicle/multitile/tank/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_TANK_CREW, JOB_WO_CREWMAN, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

/obj/vehicle/multitile/tank/load_hardpoints()
	add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)

/obj/vehicle/multitile/tank/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, actions_list["global"])
	add_verb(M.client, actions_list[seat])

/obj/vehicle/multitile/tank/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, actions_list["global"])
	remove_verb(M.client, actions_list[seat])
	SStgui.close_user_uis(M, src)

//Called when players try to move vehicle
//Another wrapper for try_move()
/obj/vehicle/multitile/tank/relaymove(mob/user, direction)
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

	if(direction == GLOB.reverse_dir[T.dir] || direction == T.dir)
		return FALSE

	T.user_rotation(user, turning_angle(T.dir, direction))
	update_icon()

	return TRUE

/obj/vehicle/multitile/tank/MouseDrop_T(mob/dropped, mob/user)
	. = ..()
	if((dropped != user) || !isxeno(user))
		return

	if(health > 0)
		to_chat(user, SPAN_XENO("We can't jump over [src] until it is destroyed!"))
		return

	var/turf/current_turf = get_turf(user)
	var/dir_to_go = get_dir(current_turf, src)
	for(var/i in 1 to 3)
		current_turf = get_step(current_turf, dir_to_go)
		if(!(current_turf in locs))
			break

		if(current_turf.density)
			to_chat(user, SPAN_XENO("The path over [src] is obstructed!"))
			return

	// Now we check to make sure the turf on the other side of the tank isn't dense too
	current_turf = get_step(current_turf, dir_to_go)
	if(current_turf.density)
		to_chat(user, SPAN_XENO("The path over [src] is obstructed!"))
		return

	to_chat(user, SPAN_XENO("We begin to jump over [src]..."))
	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_XENO("We stop jumping over [src]."))
		return

	user.forceMove(current_turf)
	to_chat(user, SPAN_XENO("We jump to the other side of [src]."))
/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/tank
	name = "Tank Spawner"
	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48

	vehicle_type = /obj/vehicle/multitile/tank

	hardpoints = list(
		/obj/item/hardpoint/holder/tank_turret,
	)

	var/list/turret_hardpoints = list()

//PRESET: turret, no hardpoints (not the one without turret for convenience, you still expect to have turret when you spawn "no hardpoints tank")
/obj/effect/vehicle_spawner/tank/spawn_vehicle(obj/vehicle/multitile/spawning)
	load_misc(spawning)
	load_hardpoints(spawning)
	handle_direction(spawning)
	spawning.update_icon()

/obj/effect/vehicle_spawner/tank/load_hardpoints(obj/vehicle/multitile/spawning)
	. = ..()
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in spawning.hardpoints
	if(turret)
		for(var/obj in turret_hardpoints)
			turret.add_hardpoint(new obj)

//PRESET: turret, treads installed
/obj/effect/vehicle_spawner/tank/plain
	hardpoints = list(
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/locomotion/treads,
	)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/tank/hull
	hardpoints = list()

//Just the hull and it's broken TOO, you get the full experience
/obj/effect/vehicle_spawner/tank/hull/broken/spawn_vehicle(obj/vehicle/multitile/spawning)
	load_damage(spawning)
	spawning.update_icon()

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/tank/decrepit
	hardpoints = list(
		/obj/item/hardpoint/support/artillery_module,
		/obj/item/hardpoint/armor/paladin,
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/locomotion/treads,
	)

	turret_hardpoints = list(
		/obj/item/hardpoint/primary/cannon,
		/obj/item/hardpoint/secondary/m56cupola,
	)

/obj/effect/vehicle_spawner/tank/decrepit/spawn_vehicle(obj/vehicle/multitile/spawning)
	load_misc(spawning)
	handle_direction(spawning)
	load_hardpoints(spawning)
	load_damage(spawning)
	spawning.update_icon()

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/tank/fixed
	hardpoints = list(
		/obj/item/hardpoint/support/artillery_module,
		/obj/item/hardpoint/armor/paladin,
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/locomotion/treads,
	)

	turret_hardpoints = list(
		/obj/item/hardpoint/primary/cannon,
		/obj/item/hardpoint/secondary/m56cupola,
	)

//PRESET: minigun kit
/obj/effect/vehicle_spawner/tank/fixed/minigun
	hardpoints = list(
		/obj/item/hardpoint/support/weapons_sensor,
		/obj/item/hardpoint/armor/ballistic,
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/locomotion/treads,
	)

	turret_hardpoints = list(
		/obj/item/hardpoint/primary/minigun,
		/obj/item/hardpoint/secondary/small_flamer,
	)

//PRESET: dragon flamer kit
/obj/effect/vehicle_spawner/tank/fixed/flamer
	hardpoints = list(
		/obj/item/hardpoint/support/overdrive_enhancer,
		/obj/item/hardpoint/armor/ballistic,
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/locomotion/treads,
	)

	turret_hardpoints = list(
		/obj/item/hardpoint/primary/flamer,
		/obj/item/hardpoint/secondary/grenade_launcher,
	)

//PRESET: autocannon kit
/obj/effect/vehicle_spawner/tank/fixed/autocannon
	hardpoints = list(
		/obj/item/hardpoint/support/artillery_module,
		/obj/item/hardpoint/armor/ballistic,
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/locomotion/treads,
	)

	turret_hardpoints = list(
		/obj/item/hardpoint/primary/autocannon,
		/obj/item/hardpoint/secondary/towlauncher,
	)
