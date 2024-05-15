#define RANGE_TURFS(RADIUS, CENTER) \
	block( \
		(CENTER).x-(RADIUS), (CENTER).y-(RADIUS), (CENTER).z, \
		(CENTER).x+(RADIUS), (CENTER).y+(RADIUS), (CENTER).z \
	)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
		(CENTER).x-(H_RADIUS), (CENTER).y-(V_RADIUS), (CENTER).z, \
		(CENTER).x+(H_RADIUS), (CENTER).y+(V_RADIUS), (CENTER).z \
	)

///Returns all turfs in a zlevel
#define Z_TURFS(ZLEVEL) block(1, 1, (ZLEVEL), world.maxx, world.maxy, (ZLEVEL))

/// Returns a list of turfs in the rectangle specified by BOTTOM LEFT corner and height/width
#define CORNER_BLOCK(corner, width, height) CORNER_BLOCK_OFFSET(corner, width, height, 0, 0)

/// Returns a list of turfs similar to CORNER_BLOCK but with offsets
#define CORNER_BLOCK_OFFSET(corner, width, height, offset_x, offset_y) \
	block( \
		(corner).x + (offset_x), (corner).y + (offset_y), (corner).z, \
		(corner).x + ((width) - 1) + (offset_x), (corner).y + ((height) - 1) + (offset_y), (corner).z \
	)

/// Returns an outline (neighboring turfs) of the given block
#define CORNER_OUTLINE(corner, width, height) ( \
	CORNER_BLOCK_OFFSET(corner, width + 2, 1, -1, -1) + \
	CORNER_BLOCK_OFFSET(corner, width + 2, 1, -1, height) + \
	CORNER_BLOCK_OFFSET(corner, 1, height, -1, 0) + \
	CORNER_BLOCK_OFFSET(corner, 1, height, width, 0))

#define TURF_FROM_COORDS_LIST(List) (locate(List[1], List[2], List[3]))
