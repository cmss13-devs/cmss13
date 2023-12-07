#define RANGE_TURFS(RADIUS, CENTER) \
block( \
	locate(max(CENTER.x-(RADIUS),1),   max(CENTER.y-(RADIUS),1),   CENTER.z), \
	locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
	locate(max((CENTER).x-(H_RADIUS),1), max((CENTER).y-(V_RADIUS),1), (CENTER).z), \
	locate(min((CENTER).x+(H_RADIUS),world.maxx), min((CENTER).y+(V_RADIUS),world.maxy), (CENTER).z) \
	)

///Returns all turfs in a zlevel
#define Z_TURFS(ZLEVEL) block(locate(1,1,ZLEVEL), locate(world.maxx, world.maxy, ZLEVEL))
