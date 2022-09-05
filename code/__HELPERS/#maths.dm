// Credits to Nickr5 for the useful procs I've taken from his library resource.

var/const/E		= 2.71828183
var/const/Sqrt2	= 1.41421356

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
/proc/RotateAroundAxis(var/point, var/axis, var/degrees)
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
proc/n_ceil(var/num)
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
