/*
Taking a hint from goon, I thought I'd start our own animation library. These are stock animations you can use for anything.
Just make sure to add animations that you make here so that they may be re-used. Please document how the animation
functions so that other people won't have to wonder what it actually does.
*/

/*
This is something like a gun spin, where the user spins it in the hand.
Instead of being uniform, it starts out a littler slower, goes fast in the middle, then slows down again.
4 ticks * 5 = 2 seconds. Doesn't loop on default, and spins right.
*/
/proc/animation_wrist_flick(atom/A, direction = 1, loop_num = 0) //-1 for a left spin.
	animate(A, transform = matrix(120 * direction, MATRIX_ROTATE), time = 1, loop = loop_num, easing = SINE_EASING|EASE_IN)
	animate(transform = matrix(240 * direction, MATRIX_ROTATE), time = 1)
	animate(transform = null, time = 2, easing = SINE_EASING|EASE_OUT)

/proc/animation_move_up_slightly(atom/A, loop_num = 0)
	animate(A, transform = matrix(330, MATRIX_ROTATE), time = 1, loop = loop_num, easing = SINE_EASING|EASE_IN)
	animate(transform = matrix(330, MATRIX_ROTATE), time = 1)
	animate(transform = null, time = 2, easing = SINE_EASING|EASE_OUT)

//Makes it look like the user threw something in the air (north) and then caught it.
/proc/animation_toss_snatch(atom/A)
	A.transform *= 0.75
	animate(A, alpha = 185, pixel_x = rand(-4,4), pixel_y = 18, pixel_z = 0, time = 3)
	animate(pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)

//Combines the flick and the toss to have the item spin in the air.
/proc/animation_toss_flick(atom/A, direction = 1)
	A.transform *= 0.75
	animate(A, transform = matrix(120 * direction, MATRIX_ROTATE), alpha = 185, pixel_x = rand(-4,4), pixel_y = 18, time = 3, easing = SINE_EASING|EASE_IN)
	animate(transform = matrix(240 * direction, MATRIX_ROTATE), pixel_x = 0, pixel_y = 0, time = 2)

//This does a fade out drop from a direction, like a hit of some kind.
/proc/animation_strike(atom/A, direction = 1)
	A.transform *= 0.75
	switch(direction)
		if(1)
			A.pixel_y += 18
		if(2)
			A.pixel_y -= 18
		if(4)
			A.pixel_x += 18
		if(8)
			A.pixel_x -= 18

	animate(A, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)

//Flashes a color, then goes back to regular.
/proc/animation_flash_color(atom/A, flash_color = COLOR_RED, speed = 3) //Flashes red on default.
	var/oldcolor = A.color
	animate(A, color = flash_color, time = speed, flags = ANIMATION_PARALLEL)
	animate(color = oldcolor, time = speed)

/* fuck this, only halloween uses this -spookydonut
//Gives it a spooky overlay and animation. Same as above, mostly, only adds a cool overlay effect.
/proc/animation_horror_flick(atom/A, flash_color = COLOR_BLACK, speed = 4)
	animate(A, color = flash_color, time = speed)
	animate(color = COLOR_WHITE, time = speed)
	var/image/I = image('icons/mob/mob.dmi',A,"spook")
	I.flick_overlay(A,7)

/proc/animation_blood_spatter(atom/A, flash_color = "#8A0707", speed = 4)
	animate(A, color = flash_color, time = speed)
	animate(color = COLOR_WHITE, time = speed)
	var/image/I = image('icons/mob/mob.dmi',A,"blood_spatter")
	if(prob(50))
		I.transform = matrix(rand(0,45), MATRIX_ROTATE)
		I.pixel_x += rand(0,5)
		I.pixel_y += rand(0,5)
	else
		I.transform = matrix(-1,1, MATRIX_SCALE)
		I.transform = matrix(A.transform, rand(0,-45), MATRIX_ROTATE)
		I.pixel_x += rand(0,-5)
		I.pixel_y += rand(0,-5)
	I.layer = ABOVE_MOB_LAYER
	I.flick_overlay(A,7)*/

/proc/animatation_displace_reset(atom/A, x_n = 2, y_n = 2, speed = 3)
	var/x_o = initial(A.pixel_x)
	var/y_o = initial(A.pixel_y)
	animate(A, pixel_x = x_o+rand(-x_n, x_n), pixel_y = y_o+rand(-y_n, y_n), time = speed, easing = ELASTIC_EASING|EASE_IN)
	animate(pixel_x = x_o, pixel_y = y_o, time = speed, easing = CIRCULAR_EASING|EASE_OUT)

//Basic megaman-like animation. No bells or whistles, but looks nice. Could work for Predator relay device, for example.
/proc/animation_teleport_quick_out(atom/A, speed = 10)
	animate(A, transform = matrix(0, 4, MATRIX_SCALE), alpha = 0, time = speed, easing = BACK_EASING)
	return speed

//We want to make sure to reset color here as it can be changed by other animations.
/proc/animation_teleport_quick_in(atom/A, speed = 10)
	A.transform = matrix(0, 4, MATRIX_SCALE)
	A.alpha = 0 //Start with transparency, just in case.
	animate(A, alpha = 255, transform = null, color = COLOR_WHITE, time = speed, easing = BACK_EASING)

/*A magical teleport animation, for when the person is transported with some magic. Good for Halloween type events.
Can look good elsewhere as well.*/
/*proc/animation_teleport_magic_out(atom/A, speed = 6)
	animate(A, transform = matrix(1.5, 0, MATRIX_SCALE), time = speed, easing = BACK_EASING)
	animate(transform = matrix(0, 4, MATRIX_SCALE) * matrix(0, 6, MATRIX_TRANSLATE), color = COLOR_YELLOW, time = speed, alpha = 100, easing = BOUNCE_EASING|EASE_IN)
	animate(alpha = 0, time = speed)
	var/image/I = image('icons/effects/effects.dmi',A,"sparkle")
	I.flick_overlay(A,9)
	return speed*3

/proc/animation_teleport_magic_in(atom/A, speed = 6)
	A.transform = matrix(0,3.5, MATRIX_SCALE)
	A.alpha = 0
	animate(A, alpha = 255, color = COLOR_YELLOW, time = speed, easing = BACK_EASING)
	animate(transform = matrix(1.5, 0, MATRIX_SCALE), color = COLOR_WHITE, time = speed, easing = CIRCULAR_EASING|EASE_OUT)
	animate(transform = null, time = speed-1)
	var/image/I = image('icons/effects/effects.dmi',A,"sparkle")
	I.flick_overlay(A,10)

//A spooky teleport for evil dolls, horrors, and whatever else. Halloween type stuff.
/proc/animation_teleport_spooky_out(atom/A, speed = 6, sleep_duration = 0)
	animate(A, transform = matrix() * 1.5, color = "#551a8b", time = speed, easing = BACK_EASING)
	animate(transform = matrix() * 0.2, alpha = 100, color = COLOR_BLACK, time = speed, easing = BACK_EASING)
	animate(alpha = 0, time = speed)
	var/image/I = image('icons/effects/effects.dmi',A,"spooky")
	I.flick_overlay(A,9,RESET_COLOR|RESET_ALPHA|TILE_BOUND)
	return speed*3

/proc/animation_teleport_spooky_in(atom/A, speed = 4)
	A.transform *= 1.2
	A.alpha = 0
	animate(A, alpha = 255, color = "#551a8b", time = speed)
	animate(transform = null, color = COLOR_WHITE, time = speed, easing = QUAD_EASING|EASE_OUT)
	var/image/I = image('icons/effects/effects.dmi',A,"spooky")
	I.flick_overlay(A,10)*/

//Regular fadeout disappear, for most objects.
/proc/animation_destruction_fade(atom/A, speed = 12)
	A.flags_atom |= NOINTERACT
	A.mouse_opacity = MOUSE_OPACITY_TRANSPARENT //We don't want them to click this while the animation is still playing.
	A.density = FALSE //So it doesn't block anything.
	var/i = 1 + (0.1 * rand(1,5))
	animate(A, transform = matrix() * i, color = COLOR_GRAY, time = speed, easing = SINE_EASING)
	animate(alpha = 0, time = speed)
	return speed

//Fadeout when something gets hit. Not completely done yet, as offset doesn't want to cooperate.
/proc/animation_destruction_knock_fade(atom/A, speed = 7, x_n = rand(10,18), y_n = rand(10,18))
	A.flags_atom |= NOINTERACT
	A.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	A.density = FALSE
	var/x_o = initial(A.pixel_x)
	var/y_o = initial(A.pixel_y)
	animate(A, transform = matrix() * 1.2,  alpha = 100, pixel_x = x_o + pick(x_n,-x_n), pixel_y = y_o + pick(y_n,-y_n), time = speed, easing = QUAD_EASING|EASE_IN)
	animate(transform = matrix(rand(45,90) * pick(1,-1), MATRIX_ROTATE), alpha = 0, time = speed, easing = SINE_EASING|EASE_OUT)
	return speed*2

/*
//Work in progress animation. Needs byond 511 parallel animation to look nice.
/proc/animation_destruction_long_fade(atom/A, speed = 4, x_n = 4, y_n = 4)
	A.flags_atom |= NOINTERACT
	A.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	A.density = FALSE
	var/x_o = initial(A.pixel_x)
	var/y_o = initial(A.pixel_y)
	animate(A, pixel_x = x_o+rand(-x_n, x_n), pixel_y = y_o+rand(-y_n, y_n), time = speed, easing = ELASTIC_EASING|EASE_IN)
	animate(pixel_x = x_o, pixel_y = y_o, time = speed, easing = CIRCULAR_EASING|EASE_OUT)
	animate(alpha = 200, matrix(rand(45,90) * pick(1,-1), MATRIX_ROTATE), time = speed)
	animate(pixel_x = x_o+rand(-x_n, x_n), pixel_y = y_o+rand(-y_n, y_n), time = speed, easing = ELASTIC_EASING|EASE_IN)
	animate(pixel_x = x_o, pixel_y = y_o, time = speed, easing = CIRCULAR_EASING|EASE_OUT)
	animate(alpha = 100, matrix(rand(45,90) * pick(1,-1), MATRIX_ROTATE), time = speed)
	animate(pixel_x = x_o+rand(-x_n, x_n), pixel_y = y_o+rand(-y_n, y_n), time = speed, easing = ELASTIC_EASING|EASE_IN)
	animate(pixel_x = x_o, pixel_y = y_o, time = speed, easing = CIRCULAR_EASING|EASE_OUT)
	animate(alpha = 0, color = COLOR_GRAY, time = speed)
	var/image/I = image('icons/effects/effects.dmi',A,"red_particles")
	I.flick_overlay(A,25)
	return speed*9*/



/mob/living/proc/animation_attack_on(atom/A, pixel_offset = 8)
	if(A.clone)
		if(src.Adjacent(A.clone))
			A = A.clone
	if(buckled || anchored) return //it would look silly.
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	pixel_offset = floor(pixel_offset) // Just to be safe
	switch(direction)
		if(NORTH)
			pixel_y_diff = pixel_offset
		if(SOUTH)
			pixel_y_diff = -pixel_offset
		if(EAST)
			pixel_x_diff = pixel_offset
		if(WEST)
			pixel_x_diff = -pixel_offset
		if(NORTHEAST)
			pixel_x_diff = pixel_offset
			pixel_y_diff = pixel_offset
		if(NORTHWEST)
			pixel_x_diff = -pixel_offset
			pixel_y_diff = pixel_offset
		if(SOUTHEAST)
			pixel_x_diff = pixel_offset
			pixel_y_diff = -pixel_offset
		if(SOUTHWEST)
			pixel_x_diff = -pixel_offset
			pixel_y_diff = -pixel_offset
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2, flags = ANIMATION_PARALLEL)
	animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)


/atom/proc/animation_spin(speed = 5, loop_amount = -1, clockwise = TRUE, sections = 3, angular_offset = 0, pixel_fuzz = 0)
	if(!sections)
		return
	var/section = 360/sections
	if(!clockwise)
		section = -section
	if(angular_offset)
		var/matrix/initial_matrix = matrix(transform)
		initial_matrix.Turn(angular_offset)
		apply_transform(initial_matrix)
	var/dx = 0
	var/dy = 0
	if(pixel_fuzz)
		dx = (rand()-0.5)*pixel_fuzz / sections
		dy = (rand()-0.5)*pixel_fuzz / sections
	var/list/matrix_list = list()
	for(var/i in 1 to sections-1)
		var/matrix/M = matrix(transform)
		M.Turn(section*i + angular_offset)
		matrix_list += M
	var/matrix/last = matrix(transform)
	matrix_list += last
	speed /= sections
	animate(src, transform = matrix_list[1], pixel_x = pixel_x + dx, pixel_y = pixel_y + dy, time = speed, loop_amount)
	for(var/i in 2 to sections)
		animate(transform = matrix_list[i], pixel_x = pixel_x + dx*i, pixel_y = pixel_y + dy*i, time = speed)

/atom/proc/animation_cancel()
	animate(src)

/atom/proc/sway_jitter(times = 3, steps = 3, strength = 3, sway = 5)
	var/sway_dir = 1 //left to right
	animate(src, transform = turn(matrix(transform), sway * (sway_dir *= -1)), pixel_x = rand(-strength,strength), pixel_y = rand(-strength/3,strength/3), time = times, easing = JUMP_EASING, flags = ANIMATION_PARALLEL)
	for(var/i in 1 to steps)
		animate(transform = turn(matrix(transform), sway*2 * (sway_dir *= -1)), pixel_x = rand(-strength,strength), pixel_y = rand(-strength/3,strength/3), time = times, easing = JUMP_EASING)

	animate(transform = turn(matrix(transform), sway * (sway_dir *= -1)), pixel_x = 0, pixel_y = 0, time = 0)//ease it back

/mob/living/carbon/human/proc/animation_rappel()
	var/pre_rappel_alpha = alpha
	alpha = 20
	dir = WEST
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	var/matrix/initial_matrix = matrix()
	initial_matrix.Turn(45)
	apply_transform(initial_matrix)
	pixel_y = 8
	var/matrix/reset_matrix = matrix()
	animate(src, 3, transform = reset_matrix, pixel_y = 0, alpha = pre_rappel_alpha, flags = ANIMATION_PARALLEL)
	sleep(3)
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
