//unsorted miscellaneous temporary visuals
GLOBAL_LIST_EMPTY(blood_particles)
/particles/splatter
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 20
	spawning = 20
	lifespan = 0.5 SECONDS
	fade = 0.7 SECONDS
	grow = 0.1
	scale = 0.2
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.5)
	position = generator(GEN_CIRCLE, 6, 6)

/particles/splatter/New(set_color)
	..()
	if(set_color != "red") // we're already red colored by default
		color = set_color

/obj/effect/temp_visual/dir_setting/bloodsplatter
	icon = 'icons/effects/blood.dmi'
	duration = 5
	randomdir = FALSE
	layer = ABOVE_XENO_LAYER
	var/splatter_type = "splatter"

/obj/effect/temp_visual/dir_setting/bloodsplatter/Initialize(mapload, angle, fx_duration, color_override)
	if(color_override)
		color = color_override
	var/x_component = sin(angle) * -15
	var/y_component = cos(angle) * -15
	if(!GLOB.blood_particles[color])
		GLOB.blood_particles[color] = new /particles/splatter(color)
	particles = GLOB.blood_particles[color]
	particles.velocity = list(x_component, y_component)
	icon_state = "[splatter_type][pick(1, 2, 3, 4, 5, 6)]"
	. = ..()
	if(fx_duration)
		duration = fx_duration
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(round(angle))
		if(0, 360)
			target_pixel_x = 0
			target_pixel_y = 8
		if(1 to 44)
			target_pixel_x = round(4 * ((angle) / 45))
			target_pixel_y = 8
		if(45)
			target_pixel_x = 8
			target_pixel_y = 8
		if(46 to 89)
			target_pixel_x = 8
			target_pixel_y = round(4 * ((90 - angle) / 45))
		if(90)
			target_pixel_x = 8
			target_pixel_y = 0
		if(91 to 134)
			target_pixel_x = 8
			target_pixel_y = round(-3 * ((angle - 90) / 45))
		if(135)
			target_pixel_x = 8
			target_pixel_y = -6
		if(136 to 179)
			target_pixel_x = round(4 * ((180 - angle) / 45))
			target_pixel_y = -6
		if(180)
			target_pixel_x = 0
			target_pixel_y = -6
		if(181 to 224)
			target_pixel_x = round(-6 * ((angle - 180) / 45))
			target_pixel_y = -6
		if(225)
			target_pixel_x = -6
			target_pixel_y = -6
		if(226 to 269)
			target_pixel_x = -6
			target_pixel_y = round(-6 * ((270 - angle) / 45))
		if(270)
			target_pixel_x = -6
			target_pixel_y = 0
		if(271 to 314)
			target_pixel_x = -6
			target_pixel_y = round(8 * ((angle - 270) / 45))
		if(315)
			target_pixel_x = -6
			target_pixel_y = 8
		if(316 to 359)
			target_pixel_x = round(-6 * ((360 - angle) / 45))
			target_pixel_y = 8
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)

/obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter
	splatter_type = "xsplatter"
	color = BLOOD_COLOR_XENO

/obj/effect/temp_visual/dir_setting/bloodsplatter/human
	splatter_type = "csplatter"
	color = BLOOD_COLOR_HUMAN

/obj/effect/temp_visual/dir_setting/bloodsplatter/hellhound
	splatter_type = "csplatter"
	color = BLOOD_COLOR_YAUTJA

/obj/effect/temp_visual/dir_setting/bloodsplatter/yautjasplatter
	splatter_type = "csplatter"
	color = BLOOD_COLOR_YAUTJA_DARK

/obj/effect/temp_visual/dir_setting/bloodsplatter/synthsplatter
	splatter_type = "csplatter"
	color = BLOOD_COLOR_SYNTHETIC

/obj/effect/temp_visual/shockwave
	icon = 'icons/effects/light_overlays/shockwave.dmi'
	icon_state = "shockwave"
	plane = DISPLACEMENT_PLATE_RENDER_LAYER
	pixel_x = -496
	pixel_y = -496

/obj/effect/temp_visual/shockwave/Initialize(mapload, radius, speed, easing_type = LINEAR_EASING, y_offset, x_offset)
	. = ..()
	if(!speed)
		speed = 1
	if(y_offset)
		pixel_y += y_offset
	if(x_offset)
		pixel_x += x_offset
	deltimer(timerid)
	timerid = QDEL_IN(src, 0.5 * radius * speed)
	transform = matrix().Scale(32 / 1024, 32 / 1024)
	animate(src, time = 0.5 * radius * speed, transform=matrix().Scale((32 / 1024) * radius * 1.5, (32 / 1024) * radius * 1.5), easing = easing_type)
