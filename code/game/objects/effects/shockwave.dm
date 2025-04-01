//------------------------------------------
//Shockwaves
//------------------------------------------


/obj/effect/shockwave
	icon = 'icons/effects/light_overlays/shockwave.dmi'
	icon_state = "shockwave"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = DISPLACEMENT_PLATE_RENDER_LAYER
	pixel_x = -496
	pixel_y = -496
	vis_flags = 0

/obj/effect/shockwave/Initialize(mapload, radius, speed, easing_type = LINEAR_EASING, y_offset, x_offset)
	. = ..()
	if(!speed)
		speed = 1
	if(y_offset)
		pixel_y += y_offset
	if(x_offset)
		pixel_x += x_offset
	AddElement(/datum/element/temporary, 0.5 * radius * speed)
	transform = matrix().Scale(32 / 1024, 32 / 1024)
	animate(src, time = 0.5 * radius * speed, transform=matrix().Scale((32 / 1024) * radius * 1.5, (32 / 1024) * radius * 1.5), easing = easing_type)
