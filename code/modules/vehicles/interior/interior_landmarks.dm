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
	E.update_icon()
	// Don't qdel this because it's used for entering as well

/obj/effect/landmark/interior/spawn/entrance/step_toward/on_load(var/datum/interior/I)
	var/exit_path = exit_type
	if(!exit_path)
		return
	var/obj/structure/interior_exit/E = new exit_path(get_step(src, dir))

	E.interior = I
	E.entrance_id = tag
	E.setDir(dir)
	E.update_icon()

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
	S.setDir(dir)
	S.update_icon()

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
	S.update_icon()

	qdel(src)
