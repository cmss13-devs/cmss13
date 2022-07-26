/obj/effect/landmark/interior
	name = "interior marker"

/obj/effect/landmark/interior/proc/on_load(var/datum/interior/I)
	return

/*
	Spawner landmarks
*/

/obj/effect/landmark/interior/spawn
	name = "interior interactable spawner"

// Interiors will call this when they're created
/obj/effect/landmark/interior/spawn/on_load(var/datum/interior/I)
	qdel(src)

// Entrance & exit spawner
/obj/effect/landmark/interior/spawn/entrance
	name = "entrance marker"
	icon_state = "arrow"

	var/exit_type = /obj/structure/interior_exit

/obj/effect/landmark/interior/spawn/entrance/on_load(var/datum/interior/I)
	var/exit_path = exit_type
	if(!exit_path)
		return
	var/obj/structure/interior_exit/E = new exit_path(get_turf(src))

	E.interior = I
	E.entrance_id = tag
	E.setDir(dir)
	E.alpha = alpha
	E.update_icon()
	E.pixel_x = pixel_x
	E.pixel_y = pixel_y
	// Don't qdel this because it's used for entering as well

/obj/effect/landmark/interior/spawn/entrance/step_toward/on_load(var/datum/interior/I)
	var/exit_path = exit_type
	if(!exit_path)
		return
	var/obj/structure/interior_exit/E = new exit_path(get_step(src, dir))

	E.interior = I
	E.entrance_id = tag
	E.setDir(dir)
	E.alpha = alpha
	E.update_icon()
	E.pixel_x = pixel_x
	E.pixel_y = pixel_y

// Driver's seat spawner
/obj/effect/landmark/interior/spawn/vehicle_driver_seat
	name = "driver's seat spawner"
	icon = 'icons/obj/objects.dmi'
	icon_state = "comfychair"
	color = "red"

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/driver/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.required_skill = S.vehicle.required_skill
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

// Gunner's seat spawner
/obj/effect/landmark/interior/spawn/vehicle_gunner_seat
	name = "gunner's seat spawner"
	icon = 'icons/obj/objects.dmi'
	icon_state = "comfychair"
	color = "blue"

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/gunner/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/armor
	name = "armor driver's seat spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "armor_chair"
	color = "red"

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/armor/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/driver/armor/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.vehicle = I.exterior
	S.required_skill = S.vehicle.required_skill
	S.setDir(dir)
	S.update_icon()
	S.alpha = alpha
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/armor
	name = "armor gunner's seat spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "armor_chair"
	color = "blue"

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/armor/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/gunner/armor/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.vehicle = I.exterior
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/effect/landmark/interior/spawn/vehicle_support_gunner_seat
	name = "1st support gunner's seat spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "armor_chair"
	color = "#003300"

/obj/effect/landmark/interior/spawn/vehicle_support_gunner_seat/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/support_gunner/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.vehicle = I.exterior
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/effect/landmark/interior/spawn/vehicle_support_gunner_seat/second
	name = "2nd support gunner's seat spawner"
	color = "#333300"

/obj/effect/landmark/interior/spawn/vehicle_support_gunner_seat/second/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/support_gunner/second/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.vehicle = I.exterior
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/effect/landmark/interior/spawn/interior_camera
	name = "interior camera spawner"
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "vehicle_camera"
	color = "white"

/obj/effect/landmark/interior/spawn/interior_camera/on_load(var/datum/interior/I)

	var/obj/structure/machinery/camera/vehicle/CAM = new(loc)

	var/obj/vehicle/multitile/vehicle = I.exterior
	if(!istype(vehicle))
		return

	vehicle.camera_int = CAM
	CAM.setDir(dir)
	CAM.alpha = alpha
	CAM.update_icon()
	CAM.pixel_x = pixel_x
	CAM.pixel_y = pixel_y

	qdel(src)
