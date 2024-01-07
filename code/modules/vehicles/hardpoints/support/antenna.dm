/obj/item/hardpoint/support/arc_antenna
	name = "\improper U-56 Radar Antenna"
	desc = "A heavy-duty antenna built for the ARC."
	icon = 'icons/obj/vehicles/hardpoints/arc.dmi'

	icon_state = "antenna"
	disp_icon = "arc"
	disp_icon_state = "antenna"

	damage_multiplier = 0.1

	health = 500

	/// How long the antenna deploy/retract animation is, keep accurate to the sprite in the dmi
	var/deploy_animation_time = 1.7 SECONDS

/obj/item/hardpoint/support/arc_antenna/proc/deploy_antenna()
	set waitfor = FALSE

	disp_icon_state = ""
	if(owner)
		owner.update_icon()
		var/obj/dummy_obj = new()
		dummy_obj.icon = 'icons/obj/vehicles/arc.dmi'
		dummy_obj.icon_state = "antenna_cover_0"
		dummy_obj.dir = owner.dir
		dummy_obj.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		owner.vis_contents += dummy_obj
		flick("antenna_extending", dummy_obj)
		sleep(deploy_animation_time)
		qdel(dummy_obj)
	disp_icon_state = initial(disp_icon_state)

/obj/item/hardpoint/support/arc_antenna/proc/retract_antenna()
	set waitfor = FALSE

	disp_icon_state = ""
	if(owner)
		owner.update_icon()
		var/obj/dummy_obj = new()
		dummy_obj.icon = 'icons/obj/vehicles/arc.dmi'
		dummy_obj.icon_state = "antenna_cover_0"
		dummy_obj.dir = owner.dir
		dummy_obj.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		owner.vis_contents += dummy_obj
		flick("antenna_retracting", dummy_obj)
		sleep(deploy_animation_time)
		qdel(dummy_obj)
	disp_icon_state = initial(disp_icon_state)

/obj/item/hardpoint/support/arc_antenna/get_icon_image(x_offset, y_offset, new_dir)
	var/is_broken = health <= 0
	var/antenna_extended = FALSE
	if(istype(owner, /obj/vehicle/multitile/arc))
		var/obj/vehicle/multitile/arc/arc_owner = owner
		antenna_extended = arc_owner.antenna_deployed

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[antenna_extended ? "extended" : "cover"]_[is_broken ? "1" : "0"]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)
	switch(round((health / initial(health)) * 100))
		if(0 to 20)
			I.color = "#4e4e4e"
		if(21 to 40)
			I.color = "#6e6e6e"
		if(41 to 60)
			I.color = "#8b8b8b"
		if(61 to 80)
			I.color = "#bebebe"
		else
			I.color = null
	return I
