// PRESETS

// EMP

/obj/structure/machinery/camera/emp_proof/New()
	..()
	upgradeEmpProof()

// X-RAY

/obj/structure/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/structure/machinery/camera/xray/New()
	..()
	upgradeXRay()

// MOTION

/obj/structure/machinery/camera/motion/New()
	..()
	upgradeMotion()

//used by the laser camera dropship equipment
/obj/structure/machinery/camera/laser_cam
	name = "laser camera"
	invuln = TRUE
	icon_state = ""
	mouse_opacity = 0
	network = list("laser targets")
	unslashable = TRUE
	unacidable = TRUE

	New(loc, laser_name)
		..()
		if(!c_tag && laser_name)
			var/area/A = get_area(src)
			c_tag = "[laser_name] ([A.name])"

	emp_act(severity)
		return //immune to EMPs, just in case

	ex_act()
		return


// ALL UPGRADES

/obj/structure/machinery/camera/all/New()
	..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// VEHICLE CAMERA

/obj/structure/machinery/camera/vehicle
	name = "military-grade vehicle camera"
	icon_state = "camera_vehicle"
	network = list("vehicle")

/obj/structure/machinery/camera/vehicle/toggle_cam_status(var/on = FALSE)
	if(on)
		status = TRUE
	else
		status = FALSE
	kick_viewers()

// AUTONAME

/obj/structure/machinery/camera/autoname
	var/number = 0 //camera number in area

//This camera type automatically sets it's name to whatever the area that it's in is called.
/obj/structure/machinery/camera/autoname/New()
	..()
	spawn(10)
		number = 1
		var/area/A = get_area(src)
		if(A)
			for(var/obj/structure/machinery/camera/autoname/C in machines)
				if(C == src) continue
				var/area/CA = get_area(C)
				if(CA.type == A.type)
					if(C.number)
						number = max(number, C.number+1)
			c_tag = "[A.name] #[number]"

//cameras installed inside the dropships, accessible via both cockpit monitor and Almayer camera computers
/obj/structure/machinery/camera/autoname/almayer/dropship_one
	network = list("almayer", "dropship1")

/obj/structure/machinery/camera/autoname/almayer/dropship_two
	network = list("almayer", "dropship2")

/obj/structure/machinery/camera/autoname/almayer
	name = "military-grade camera"
	network = list("almayer")

/obj/structure/machinery/camera/autoname/almayer/containment
	name = "containment camera"
	unslashable = TRUE
	unacidable = TRUE
	network = list("almayer", "containment")
	
/obj/structure/machinery/camera/autoname/almayer/containment/attack_alien(mob/living/carbon/Xenomorph/M)
	return

//used by the landing camera dropship equipment. Do not place them right under where the dropship lands.
//Should place them near each corner of your LZs.
/obj/structure/machinery/camera/autoname/lz_camera
	name = "landing zone camera"
	invuln = TRUE
	icon_state = ""
	mouse_opacity = 0
	network = list("landing zones")

	emp_act(severity)
		return //immune to EMPs, just in case

	ex_act()
		return



// CHECKS

/obj/structure/machinery/camera/proc/isEmpProof()
	var/O = locate(/obj/item/stack/sheet/mineral/osmium) in assembly.upgrades
	return O

/obj/structure/machinery/camera/proc/isXRay()
	var/obj/item/stock_parts/scanning_module/O = locate(/obj/item/stock_parts/scanning_module) in assembly.upgrades
	if (O && O.rating >= 2)
		return O
	return null

/obj/structure/machinery/camera/proc/isMotion()
	var/O = locate(/obj/item/device/assembly/prox_sensor) in assembly.upgrades
	return O

// UPGRADE PROCS

/obj/structure/machinery/camera/proc/upgradeEmpProof()
	assembly.upgrades.Add(new /obj/item/stack/sheet/mineral/osmium(assembly))
	setPowerUsage()

/obj/structure/machinery/camera/proc/upgradeXRay()
	assembly.upgrades.Add(new /obj/item/stock_parts/scanning_module/adv(assembly))
	setPowerUsage()

// If you are upgrading Motion, and it isn't in the camera's New(), add it to the machines list.
/obj/structure/machinery/camera/proc/upgradeMotion()
	assembly.upgrades.Add(new /obj/item/device/assembly/prox_sensor(assembly))
	setPowerUsage()

/obj/structure/machinery/camera/proc/setPowerUsage()
	var/mult = 1
	if (isXRay())
		mult++
	if (isMotion())
		mult++
	active_power_usage = mult*initial(active_power_usage)

//Simulator camera
/obj/structure/machinery/camera/simulation
	network = list("simulation")
	invuln = TRUE
	view_range = 14
	use_power = FALSE
	invisibility = INVISIBILITY_MAXIMUM

//Desert Dam camera networks

/obj/structure/machinery/camera/autoname/dam/laboratory_cameras
	network = list("laboratory_cameras")

/obj/structure/machinery/camera/autoname/dam/dam_interior_cameras
	network = list("dam_interior_cameras")

/obj/structure/machinery/camera/autoname/dam/security_cameras
	network = list("security_cameras")

/obj/structure/machinery/camera/autoname/dam/medical_cameras
	network = list("medical_cameras")