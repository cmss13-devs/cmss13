/obj/item/device/camera_bug
	name = "camera bug"
	icon_state = "flash"
	w_class = SIZE_TINY
	item_state = "electronic"
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/device/camera_bug/attack_self(mob/usr as mob)
	var/list/cameras = new/list()
	for (var/obj/structure/machinery/camera/C in cameranet.cameras)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		to_chat(usr, SPAN_DANGER("No bugged functioning cameras found."))
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/structure/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = tgui_input_list(usr, "Select the camera to observe", "Camera to Observe", friendly_cameras)
	if (!target)
		return
	for (var/obj/structure/machinery/camera/C in cameras)
		if (C.c_tag == target)
			target = C
			break
	if (usr.stat == 2) return

	usr.client.eye = target
