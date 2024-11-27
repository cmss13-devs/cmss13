/obj/effect/landmark/interior
	name = "interior marker"
	var/datum/interior/parent

/obj/effect/landmark/interior/proc/on_load(datum/interior/I)
	return

/*
	Spawner landmarks
*/

/obj/effect/landmark/interior/spawn
	name = "interior interactable spawner"

// Interiors will call this when they're created
/obj/effect/landmark/interior/spawn/on_load(datum/interior/I)
	qdel(src)

// Entrance & exit spawner
/obj/effect/landmark/interior/spawn/entrance
	name = "entrance marker"
	icon_state = "arrow"

	var/exit_type = /obj/structure/interior_exit

/obj/effect/landmark/interior/spawn/entrance/on_load(datum/interior/I)
	var/exit_path = exit_type
	if(!exit_path)
		return
	var/obj/structure/interior_exit/E = new exit_path(get_turf(src))

	if(name != initial(name))
		E.name = name
	if(desc != initial(desc))
		E.desc = desc
	E.interior = I
	E.entrance_id = tag
	E.setDir(dir)
	E.alpha = alpha
	E.update_icon()
	E.pixel_x = pixel_x
	E.pixel_y = pixel_y
	// Don't qdel this because it's used for entering as well

/obj/effect/landmark/interior/spawn/entrance/step_toward/on_load(datum/interior/I)
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
	icon = 'icons/obj/structures/props/furniture/chairs.dmi'
	icon_state = "comfychair"
	color = "red"

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/on_load(datum/interior/I)
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
	icon = 'icons/obj/structures/props/furniture/chairs.dmi'
	icon_state = "comfychair"
	color = "blue"

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/on_load(datum/interior/I)
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

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/armor/on_load(datum/interior/I)
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

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/armor/on_load(datum/interior/I)
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
	color = "#00ad00"

/obj/effect/landmark/interior/spawn/vehicle_support_gunner_seat/on_load(datum/interior/I)
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
	color = "#b1b100"

/obj/effect/landmark/interior/spawn/vehicle_support_gunner_seat/second/on_load(datum/interior/I)
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
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "vehicle_camera"
	color = "#00c5cc"

/obj/effect/landmark/interior/spawn/interior_camera/on_load(datum/interior/I)

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

/obj/effect/landmark/interior/spawn/telephone
	name = "telephone spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "wall_phone"
	color = "yellow"

/obj/effect/landmark/interior/spawn/telephone/on_load(datum/interior/I)
	var/obj/structure/transmitter/Phone = new(loc)

	Phone.icon = icon
	Phone.icon_state = icon_state
	Phone.layer = layer
	Phone.setDir(dir)
	Phone.alpha = alpha
	Phone.update_icon()
	Phone.pixel_x = pixel_x
	Phone.pixel_y = pixel_y
	Phone.phone_category = "Vehicles"
	Phone.phone_id = replacetext(Phone.phone_id, "\improper", "") // this has to be done because phone IDs need to be the same as their display name (\improper doesn't display, obviously)

	qdel(src)

// Landmark for spawning the reloader
/obj/effect/landmark/interior/spawn/weapons_loader
	name = "vehicle weapons reloader spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "weapons_loader"
	color = "#00920c"

/obj/effect/landmark/interior/spawn/weapons_loader/on_load(datum/interior/I)
	var/obj/structure/weapons_loader/R = new(loc)

	R.icon = icon
	R.icon_state = icon_state
	R.layer = layer
	R.pixel_x = pixel_x
	R.pixel_y = pixel_y
	R.vehicle = I.exterior
	R.setDir(dir)
	R.update_icon()

	qdel(src)

//This one spawns armored vehicles version of viewport
/obj/effect/landmark/interior/spawn/interior_viewport
	name = "armored vehicle viewport spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport"
	layer = INTERIOR_DOOR_LAYER
	color = "#009cb8"

/obj/effect/landmark/interior/spawn/interior_viewport/on_load(datum/interior/I)
	var/obj/structure/interior_viewport/V = new(loc)

	V.dir = dir
	V.vehicle = I.exterior
	V.pixel_x = pixel_x
	V.pixel_y = pixel_y
	V.layer = layer
	V.alpha = alpha
	V.update_icon()

	qdel(src)

//Landmark for spawning windows
/obj/effect/landmark/interior/spawn/interior_viewport/simple
	name = "simple vehicle viewport spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport_simple"
	layer = INTERIOR_DOOR_LAYER
	color = "#009cb8"

/obj/effect/landmark/interior/spawn/interior_viewport/simple/on_load(datum/interior/I)
	var/obj/structure/interior_viewport/simple/V = new(loc)

	V.vehicle = I.exterior
	V.pixel_x = pixel_x
	V.pixel_y = pixel_y
	V.layer = layer
	V.alpha = alpha

	qdel(src)

//Landmark for van's windshield
/obj/effect/landmark/interior/spawn/interior_viewport/simple/windshield
	name = "windshield viewport spawner"
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "windshield_viewport_top"
	layer = INTERIOR_DOOR_LAYER
	color = "#009cb8"
	alpha = 80

/obj/effect/landmark/interior/spawn/interior_viewport/simple/windshield/on_load(datum/interior/I)
	var/obj/structure/interior_viewport/simple/windshield/V = new(loc)

	V.vehicle = I.exterior
	V.pixel_x = pixel_x
	V.pixel_y = pixel_y
	V.alpha = alpha
	V.icon = icon

	qdel(src)
