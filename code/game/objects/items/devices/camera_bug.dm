/obj/item/device/camera_bug
	name = "camera bug"
	icon_state = "flash"
	w_class = SIZE_TINY
	item_state = "electronic"
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/device/camera_bug/attack_self(mob/usr as mob)
	..()

	var/list/cameras = new/list()
	for (var/obj/structure/machinery/camera/cam_bug in cameranet.cameras)
		if (cam_bug.bugged && cam_bug.status)
			cameras.Add(cam_bug)
	if (length(cameras) == 0)
		to_chat(usr, SPAN_DANGER("No bugged functioning cameras found."))
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/structure/machinery/camera/cam_bug in cameras)
		friendly_cameras.Add(cam_bug.c_tag)

	var/target = tgui_input_list(usr, "Select the camera to observe", "Camera to Observe", friendly_cameras)
	if (!target)
		return
	for (var/obj/structure/machinery/camera/cam_bug in cameras)
		if (cam_bug.c_tag == target)
			target = cam_bug
			break
	if (usr.stat == 2) return

	usr.client.eye = target
