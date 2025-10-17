//Ported from TGMC.

/matrix/proc/TurnTo(old_angle, new_angle)
	. = new_angle - old_angle
	Turn(.) //BYOND handles cases such as -270, 360, 540 etc. DOES NOT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT

/atom/proc/SpinAnimation(speed = 10, loops = -1, clockwise = 1, segments = 3, parallel = TRUE)
	if(!segments)
		return
	var/segment = 360 / segments
	if(!clockwise)
		segment = -segment
	var/list/matrices = list()
	for(var/i in 1 to segments - 1)
		var/matrix/M = matrix(transform)
		M.Turn(segment * i)
		matrices += M
	var/matrix/last = matrix(transform)
	matrices += last

	speed /= segments

	if(parallel)
		animate(src, transform = matrices[1], time = speed, loops , flags = ANIMATION_PARALLEL)
	else
		animate(src, transform = matrices[1], time = speed, loops)
	for(var/i in 2 to segments) //2 because 1 is covered above
		animate(transform = matrices[i], time = speed)
		//doesn't have an object argument because this is "Stacking" with the animate call above
		//3 billion% intentional

//Dumps the matrix data in format a-f
/matrix/proc/tolist()
	. = list()
	. += a
	. += b
	. += c
	. += d
	. += e
	. += f


//Dumps the matrix data in a matrix-grid format
/*
a d 0
b e 0
c f 1
*/
/matrix/proc/togrid()
	. = list()
	. += a
	. += d
	. += 0
	. += b
	. += e
	. += 0
	. += c
	. += f
	. += 1


//The X pixel offset of this matrix
/matrix/proc/get_x_shift()
	. = c


//The Y pixel offset of this matrix
/matrix/proc/get_y_shift()
	. = f


/matrix/proc/get_x_skew()
	. = b


/matrix/proc/get_y_skew()
	. = d


//Skews a matrix in a particular direction
//Missing arguments are treated as no skew in that direction

//As Rotation is defined as a scale+skew, these procs will break any existing rotation
//Unless the result is multiplied against the current matrix
/matrix/proc/set_skew(x = 0, y = 0)
	b = x
	d = y


/////////////////////
// COLOUR MATRICES //
/////////////////////

/* Documenting a couple of potentially useful color matrices here to inspire ideas
// Greyscale - indentical to saturation @ 0
list(LUMA_R,LUMA_R,LUMA_R,0, LUMA_G,LUMA_G,LUMA_G,0, LUMA_B,LUMA_B,LUMA_B,0, 0,0,0,1, 0,0,0,0)

// Color inversion
list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

// Sepiatone
list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0)
*/

//word of warning: using a matrix like this as a color value will simplify it back to a string after being set
/proc/color_hex2color_matrix(string)
	var/length = length(string)
	if((length != 7 && length != 9) || length != length_char(string))
		return COLOR_MATRIX_IDENTITY
	var/r = hex2num(copytext(string, 2, 4))/255
	var/g = hex2num(copytext(string, 4, 6))/255
	var/b = hex2num(copytext(string, 6, 8))/255
	var/a = 1
	if(length == 9)
		a = hex2num(copytext(string, 8, 10))/255
	if(!isnum(r) || !isnum(g) || !isnum(b) || !isnum(a))
		return COLOR_MATRIX_IDENTITY
	return list(r,0,0,0, 0,g,0,0, 0,0,b,0, 0,0,0,a, 0,0,0,0)

///Converts a hex color string to a color matrix.
/proc/color_matrix_from_string(string)
	if(!string || !istext(string))
		return COLOR_MATRIX_IDENTITY

	var/string_r = hex2num(copytext(string, 2, 4)) / 255
	var/string_g = hex2num(copytext(string, 4, 6)) / 255
	var/string_b = hex2num(copytext(string, 6, 8)) / 255

	return list(string_r,0,0,0, 0,string_g,0,0, 0,0,string_b,0, 0,0,0,1, 0,0,0,0)

//Adds/subtracts overall lightness
//0 is identity, 1 makes everything white, -1 makes everything black
/proc/color_matrix_lightness(power)
	return list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, power,power,power,0)


//Changes distance hues have from grey while maintaining the overall lightness. Greys are unaffected.
//1 is identity, 0 is greyscale, >1 oversaturates colors
/proc/color_matrix_saturation(value)
	var/inv = 1 - value
	var/R = round(LUMA_R * inv, 0.001)
	var/G = round(LUMA_G * inv, 0.001)
	var/B = round(LUMA_B * inv, 0.001)

	return list(R + value,R,R,0, G,G + value,G,0, B,B,B + value,0, 0,0,0,1, 0,0,0,0)


//Changes distance colors have from rgb(127,127,127) grey
//1 is identity. 0 makes everything grey >1 blows out colors and greys
/proc/color_matrix_contrast(value)
	var/add = (1 - value) / 2
	return list(value,0,0,0, 0,value,0,0, 0,0,value,0, 0,0,0,1, add,add,add,0)


//Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting greys
//0 is identity, 120 moves reds to greens, 240 moves reds to blues
/proc/color_matrix_rotate_hue(angle)
	var/sin = sin(angle)
	var/cos = cos(angle)
	var/cos_inv_third = 0.333*(1-cos)
	var/sqrt3_sin = sqrt(3)*sin
	return list(
round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), 0,
round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), 0,
round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), 0,
0,0,0,1,
0,0,0,0)


//These next three rotate values about one axis only
//x is the red axis, y is the green axis, z is the blue axis.
/proc/color_matrix_rotate_x(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(1,0,0,0, 0,cosval,sinval,0, 0,-sinval,cosval,0, 0,0,0,1, 0,0,0,0)


/proc/color_matrix_rotate_y(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,0,-sinval,0, 0,1,0,0, sinval,0,cosval,0, 0,0,0,1, 0,0,0,0)


/proc/color_matrix_rotate_z(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,sinval,0,0, -sinval,cosval,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)


//Returns a matrix addition of A with B
/proc/color_matrix_add(list/A, list/B)
	if(!istype(A) || !istype(B))
		return COLOR_MATRIX_IDENTITY
	if(length(A) != 20 || length(B) != 20)
		return COLOR_MATRIX_IDENTITY
	var/list/output = list()
	output.len = 20
	for(var/value in 1 to 20)
		output[value] = A[value] + B[value]
	return output


//Returns a matrix multiplication of A with B
/proc/color_matrix_multiply(list/A, list/B)
	if(!istype(A) || !istype(B))
		return COLOR_MATRIX_IDENTITY
	if(length(A) != 20 || length(B) != 20)
		return COLOR_MATRIX_IDENTITY
	var/list/output = list()
	output.len = 20
	var/x = 1
	var/y = 1
	var/offset = 0
	for(y in 1 to 5)
		offset = (y-1)*4
		for(x in 1 to 4)
			output[offset+x] = round(A[offset+1]*B[x] + A[offset+2]*B[x+4] + A[offset+3]*B[x+8] + A[offset+4]*B[x+12]+(y==5?B[x+16]:0), 0.001)
	return output


/**Creates a matrix to re-paint a sprite, replacing pure red, green, and blue with 3 different shades. Doesn't work with mixed tones of RGB or whites or greys
-- *must* be pure. R/G/B 255 becomes the new color, darker shades become correspondingly darker.
The arg is a list of hex colours, for ex "list("#d4c218", "#b929f7", "#339933"".
if you want variations of the same color, color_matrix_recolor_red() is simpler.**/
/proc/color_matrix_recolor_rgb(list/replacement_shades)
	var/list/final_matrix = COLOR_MATRIX_IDENTITY

	if(length(replacement_shades) != 3)
		CRASH("color_matrix_recolor_rgb() called with less than 3 replacement colours.")

	var/spacer //We're after the 1st through 3rd, 5th through 7th, and 9th through 11th entries in the matrix we're working on.

	for(var/I in 1 to 3)
		if(!istext(replacement_shades[I]))
			CRASH("color_matrix_recolor_rgb() called with a replacement color that wasn't a hex string.")

		var/list/current_replacer = color_matrix_from_string(replacement_shades[I])
		final_matrix[1 + spacer] = current_replacer[1]
		final_matrix[2 + spacer] = current_replacer[6]
		final_matrix[3 + spacer] = current_replacer[11]
		spacer += 4

	return final_matrix


/**Creates a matrix to re-paint a sprite, replacing shades of red with corresponding shades of a new color. In the base sprite, Hue must always be pure red.
Saturation and Lightness can be anything. Arg is a hex string for a color. Proc is by Lummox JR, www.byond.com/forum/post/2209545
color_matrix_recolor_rgb is more complex, but gives more precise control over the palette, at least if using 3 or fewer colours.**/
/proc/color_matrix_recolor_red(new_color)
	var/image/I = new
	var/list/M
	// create the matrix via short form
	I.color = list(new_color, "#fff0", "#0000", null, null)
	// get the long-form copy
	M = I.color
	// adjust the green row
	M[5] -= M[1]
	M[6] -= M[2]
	M[7] -= M[3]
	return M
