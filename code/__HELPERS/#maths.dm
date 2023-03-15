// Credits to Nickr5 for the useful procs I've taken from his library resource.

var/const/E = 2.71828183
var/const/Sqrt2 = 1.41421356

// List of square roots for the numbers 1-100.
var/list/sqrtTable = list(1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5,
						  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7,
						  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
						  8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10)

// MATH DEFINES

#define Atan2(x, y) (!x && !y ? 0 : \
						(y >= 0 ? \
							arccos(x / sqrt(x*x + y*y)) : \
							-(arccos(x / sqrt(x*x + y*y))) \
						) \
					)
#define Ceiling(x) (-round(-x))
#define Clamp(val, min_val, max_val) (max(min_val, min(val, max_val)))
#define CLAMP01(x) (clamp(x, 0, 1))

// cotangent
#define Cot(x) (1 / Tan(x))

// cosecant
#define Csc(x) (1 / sin(x))

#define Default(a, b) (a ? a : b)
#define Floor(x) (round(x))

//Finds nearest integer to x, above or below
//something.5 or higher, round up, else round down
#define roundNearest(x) (((Ceiling(x) - x) <= (x - Floor(x))) ? Ceiling(x) : Floor(x))

// Greatest Common Divisor - Euclid's algorithm
#define Gcd(a, b) (b ? Gcd(b, a % b) : a)

#define Inverse(x) (1 / x)
#define IsEven(x) (x % 2 == 0)

// Returns true if val is from min to max, inclusive.
#define IsInRange(val, min, max) (min <= val && val <= max)

#define IsInteger(x) (Floor(x) == x)
#define IsOdd(x) (!IsEven(x))
#define IsMultiple(x, y) (x % y == 0)

// Least Common Multiple
#define Lcm(a, b) (abs(a) / Gcd(a, b) * abs(b))

// Returns the nth root of x.
#define Root(n, x) (x ** (1 / n))

// secant
#define Sec(x) (1 / cos(x))

// tangent
#define Tan(x) (sin(x) / cos(x))

// 57.2957795 = 180 / Pi
#define ToDegrees(radians) (radians * 57.2957795)

// 0.0174532925 = Pi / 180
#define ToRadians(degrees) (degrees * 0.0174532925)

// min is inclusive, max is exclusive
#define WRAP(val, min, max) clamp(( min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) ),min,max)


// MATH PROCS

// Rotates a point around the given axis by a given amount of degrees
// You may want to round the result of this, it's very susceptible to floating point errors
/proc/RotateAroundAxis(point, axis, degrees)
	// Find the coordinates of the point relative to the axis.
	// That way we can work from the origin, which is much easier

	var/list/relative_coords = list(point[1] - axis[1], point[2] - axis[2])

	// Convert to polar coordinates
	var/radius = sqrt(relative_coords[1]**2 + relative_coords[2]**2)
	var/phi = Atan2(relative_coords[1], relative_coords[2])

	// Rotate the point around the axis
	phi += degrees

	// Convert back to cartesian coordiantes
	var/list/rotated_point = list(radius * cos(phi), radius * sin(phi))
	// Translate the rotated point back to its absolute coordinates
	rotated_point[1] = rotated_point[1] + axis[1]
	rotated_point[2] = rotated_point[2] + axis[2]

	return rotated_point

// Round up
/proc/n_ceil(num)
	if(isnum(num))
		return round(num)+1

///Format a power value in W, kW, MW, or GW.
/proc/display_power(powerused)
	if(powerused < 1000) //Less than a kW
		return "[powerused] W"
	else if(powerused < 1000000) //Less than a MW
		return "[round((powerused * 0.001),0.01)] kW"
	else if(powerused < 1000000000) //Less than a GW
		return "[round((powerused * 0.000001),0.001)] MW"
	return "[round((powerused * 0.000000001),0.0001)] GW"

///Calculate the angle between two movables and the west|east coordinate
/proc/get_angle(atom/movable/start, atom/movable/end)//For beams.
	if(!start || !end)
		return 0
	var/dy =(32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
	var/dx =(32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/// Angle between two arbitrary points and horizontal line same as [/proc/get_angle]
/proc/get_angle_raw(start_x, start_y, start_pixel_x, start_pixel_y, end_x, end_y, end_pixel_x, end_pixel_y)
	var/dy = (32 * end_y + end_pixel_y) - (32 * start_y + start_pixel_y)
	var/dx = (32 * end_x + end_pixel_x) - (32 * start_x + start_pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

///for getting the angle when animating something's pixel_x and pixel_y
/proc/get_pixel_angle(y, x)
	if(!y)
		return (x >= 0) ? 90 : 270
	. = arctan(x/y)
	if(y < 0)
		. += 180
	else if(x < 0)
		. += 360

/**
 * Get a list of turfs in a line from `starting_atom` to `ending_atom`.
 *
 * Uses the ultra-fast [Bresenham Line-Drawing Algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
 */
/proc/get_line(atom/starting_atom, atom/ending_atom)
	var/current_x_step = starting_atom.x//start at x and y, then add 1 or -1 to these to get every turf from starting_atom to ending_atom
	var/current_y_step = starting_atom.y
	var/starting_z = starting_atom.z

	var/list/line = list(get_turf(starting_atom))//get_turf(atom) is faster than locate(x, y, z)

	var/x_distance = ending_atom.x - current_x_step //x distance
	var/y_distance = ending_atom.y - current_y_step

	var/abs_x_distance = abs(x_distance)//Absolute value of x distance
	var/abs_y_distance = abs(y_distance)

	var/x_distance_sign = SIGN(x_distance) //Sign of x distance (+ or -)
	var/y_distance_sign = SIGN(y_distance)

	var/x = abs_x_distance >> 1 //Counters for steps taken, setting to distance/2
	var/y = abs_y_distance >> 1 //Bit-shifting makes me l33t.  It also makes get_line() unnessecarrily fast.

	if(abs_x_distance >= abs_y_distance) //x distance is greater than y
		for(var/distance_counter in 0 to (abs_x_distance - 1))//It'll take abs_x_distance steps to get there
			y += abs_y_distance

			if(y >= abs_x_distance) //Every abs_y_distance steps, step once in y direction
				y -= abs_x_distance
				current_y_step += y_distance_sign

			current_x_step += x_distance_sign //Step on in x direction
			line += locate(current_x_step, current_y_step, starting_z)//Add the turf to the list
	else
		for(var/distance_counter in 0 to (abs_y_distance - 1))
			x += abs_x_distance

			if(x >= abs_y_distance)
				x -= abs_y_distance
				current_x_step += x_distance_sign

			current_y_step += y_distance_sign
			line += locate(current_x_step, current_y_step, starting_z)
	return line


///chances are 1:value. anyprob(1) will always return true
/proc/anyprob(value)
	return (rand(1,value)==value)

///counts the number of bits in Byond's 16-bit width field, in constant time and memory!
/proc/bit_count(bit_field)
	var/temp = bit_field - ((bit_field >> 1) & 46811) - ((bit_field >> 2) & 37449) //0133333 and 0111111 respectively
	temp = ((temp + (temp >> 3)) & 29127) % 63 //070707
	return temp

/// Returns the name of the mathematical tuple of same length as the number arg (rounded down).
/proc/make_tuple(number)
	var/static/list/units_prefix = list("", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem")
	var/static/list/tens_prefix = list("", "decem", "vigin", "trigin", "quadragin", "quinquagin", "sexagin", "septuagin", "octogin", "nongen")
	var/static/list/one_to_nine = list("monuple", "double", "triple", "quadruple", "quintuple", "sextuple", "septuple", "octuple", "nonuple")
	number = round(number)
	switch(number)
		if(0)
			return "empty tuple"
		if(1 to 9)
			return one_to_nine[number]
		if(10 to 19)
			return "[units_prefix[(number%10)+1]]decuple"
		if(20 to 99)
			return "[units_prefix[(number%10)+1]][tens_prefix[round((number % 100)/10)+1]]tuple"
		if(100)
			return "centuple"
		else //It gets too tedious to use latin prefixes from here.
			return "[number]-tuple"

/// Takes a value, and a threshold it has to at least match
/// returns the correctly signed value max'd to the threshold
/proc/at_least(new_value, threshold)
	var/sign = SIGN(new_value)
	// SIGN will return 0 if the value is 0, so we just go to the positive threshold
	if(!sign)
		return threshold
	if(sign == 1)
		return max(new_value, threshold)
	if(sign == -1)
		return min(new_value, threshold * -1)

