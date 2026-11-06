/// A simple geometric shape for testing collisions and intersections. This one is a single point.
/datum/shape
	/// Horizontal position of the shape's center point.
	var/center_x = 0
	/// Vertical position of the shape's center point.
	var/center_y = 0
	/// Distance from the shape's leftmost to rightmost extent.
	var/bounds_x = 0
	/// Distance from the shape's topmost to bottommost extent.
	var/bounds_y = 0

/datum/shape/New(center_x, center_y)
	set_shape(center_x, center_y)

/// Assign shape variables.
/datum/shape/proc/set_shape(center_x, center_y)
	src.center_x = center_x
	src.center_y = center_y

/// Returns TRUE if the coordinates x, y are in or on the shape, otherwise FALSE.
/datum/shape/proc/contains_xy(x, y)
	return center_x == x && center_y == y

/// Returns TRUE if the coord datum is in or on the shape, otherwise FALSE.
/datum/shape/proc/contains_coords(datum/coords/coords)
	return contains_xy(coords.x_pos, coords.y_pos)

/// Returns TRUE if the atom is in or on the shape, otherwise FALSE.
/datum/shape/proc/contains_atom(atom/atom)
	return contains_xy(atom.x, atom.y)

/// Returns TRUE if this shape's bounding box intersects the provided shape's bounding box, otherwise FALSE. Generally faster than a full intersection test.
/datum/shape/proc/intersects_aabb(datum/shape/aabb)
	return (abs(src.center_x - aabb.center_x) <= (src.bounds_x + aabb.bounds_x) * 0.5) && (abs(src.center_y - aabb.center_y) <= (src.bounds_y + aabb.bounds_y) * 0.5)

/// Returns TRUE if this shape intersects the provided rectangle shape, otherwise FALSE.
/datum/shape/proc/intersects_rect(datum/shape/rectangle/rect)
	return rect.contains_xy(src.center_x, src.center_y)

/// A simple geometric shape for testing collisions and intersections. This one is an axis-aligned rectangle.
/datum/shape/rectangle
	/// Distance from the shape's leftmost to rightmost extent.
	var/width = 0
	/// Distance from the shape's topmost to bottommost extent.
	var/height = 0

/datum/shape/rectangle/New(center_x, center_y, width, height)
	set_shape(center_x, center_y, width, height)

/datum/shape/rectangle/set_shape(center_x, center_y, width, height)
	..()
	src.bounds_x = width
	src.bounds_y = height
	src.width = width
	src.height = height

/datum/shape/rectangle/contains_xy(x, y)
	return (abs(center_x - x) <= width * 0.5) && (abs(center_y - y) <= height * 0.5)

/datum/shape/rectangle/intersects_rect(datum/shape/rectangle/rect)
	return intersects_aabb(rect)

/// A simple geometric shape for testing collisions and intersections. This one is an axis-aligned square.
/datum/shape/rectangle/square
	/// Distance between the shape's opposing extents.
	var/length = 0

/datum/shape/rectangle/square/New(center_x, center_y, length)
	set_shape(center_x, center_y, length)

/datum/shape/rectangle/square/set_shape(center_x, center_y, length)
	..(center_x, center_y, length, length)
	src.length = length
