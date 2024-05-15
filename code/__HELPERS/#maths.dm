// Credits to Nickr5 for the useful procs I've taken from his library resource.

// List of square roots for the numbers 1-100.
GLOBAL_LIST_INIT(sqrtTable, list(1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5,
						  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7,
						  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
						  8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10))

// MATH DEFINES

#define CLAMP01(x) (clamp((x), 0, 1))

// cotangent
#define Cot(x) (1 / tan(x))

// cosecant
#define Csc(x) (1 / sin(x))

#define Default(a, b) ((a) ? (a) : (b))

// Greatest Common Divisor - Euclid's algorithm
#define Gcd(a, b) ((b) ? Gcd((b), (a) % (b)) : (a))

#define Inverse(x) (1 / (x))
#define IsEven(x) ((x) % 2 == 0)

#define IsInteger(x) (floor(x) == (x))
#define IsOdd(x) (!IsEven(x))
#define IsMultiple(x, y) ((x) % (y) == 0)

// Least Common Multiple
#define Lcm(a, b) (abs(a) / Gcd((a), (b)) * abs(b))

// Returns the nth root of x.
#define NRoot(n, x) ((x) ** (1 / (n)))

// secant
#define Sec(x) (1 / cos(x))

// 57.2957795 = 180 / Pi
#define ToDegrees(radians) ((radians) * 57.2957795)

// 0.0174532925 = Pi / 180
#define ToRadians(degrees) ((degrees) * 0.0174532925)

// min is inclusive, max is exclusive
#define WRAP(val, min, max) clamp(( (min) == (max) ? (min) : (val) - (floor(((val) - (min))/((max) - (min))) * ((max) - (min))) ),(min),(max))


// MATH PROCS

// Rotates a point around the given axis by a given amount of degrees
// You may want to round the result of this, it's very susceptible to floating point errors
/proc/RotateAroundAxis(point, axis, degrees)
	// Find the coordinates of the point relative to the axis.
	// That way we can work from the origin, which is much easier

	var/list/relative_coords = list(point[1] - axis[1], point[2] - axis[2])

	// Convert to polar coordinates
	var/radius = sqrt(relative_coords[1]**2 + relative_coords[2]**2)
	var/phi = arctan(relative_coords[1], relative_coords[2])

	// Rotate the point around the axis
	phi += degrees

	// Convert back to cartesian coordiantes
	var/list/rotated_point = list(radius * cos(phi), radius * sin(phi))
	// Translate the rotated point back to its absolute coordinates
	rotated_point[1] = rotated_point[1] + axis[1]
	rotated_point[2] = rotated_point[2] + axis[2]

	return rotated_point

///Format a power value in W, kW, MW, or GW.
/proc/display_power(powerused)
	if(powerused < 1000) //Less than a kW
		return "[powerused] W"
	else if(powerused < 1000000) //Less than a MW
		return "[round((powerused * 0.001),0.01)] kW"
	else if(powerused < 1000000000) //Less than a GW
		return "[round((powerused * 0.000001),0.001)] MW"
	return "[round((powerused * 0.000000001),0.0001)] GW"

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
	number = floor(number)
	switch(number)
		if(0)
			return "empty tuple"
		if(1 to 9)
			return one_to_nine[number]
		if(10 to 19)
			return "[units_prefix[(number%10)+1]]decuple"
		if(20 to 99)
			return "[units_prefix[(number%10)+1]][tens_prefix[floor((number % 100)/10)+1]]tuple"
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

