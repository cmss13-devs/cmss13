/**
 * Get the turf that `A` resides in, regardless of any containers.
 *
 * Use in favor of `A.loc` or `src.loc` so that things work correctly when
 * stored inside an inventory, locker, or other container.
 */
#define get_turf(A) get_step(A, 0)

#define CARDINAL_DIRS 		list(1,2,4,8)
#define CARDINAL_ALL_DIRS 	list(1,2,4,5,6,8,9,10)

//some colors
#define COLOR_RED 		"#FF0000"
#define COLOR_GREEN 	"#00FF00"
#define COLOR_BLUE 		"#0000FF"
#define COLOR_CYAN 		"#00FFFF"
#define COLOR_PINK 		"#FF00FF"
#define COLOR_YELLOW 	"#FFFF00"
#define COLOR_ORANGE 	"#FF9900"
#define COLOR_WHITE 	"#FFFFFF"
#define COLOR_BLACK 	"#000000"

//Grass Colors
#define COLOR_G_ICE     "#C7EDDE" //faded cyan
#define COLOR_G_DES     "#FF7C1C" //bright orange
#define COLOR_G_JUNG    "#64AA6E" //faded green

#define LEFT 1
#define RIGHT 2

#define CEILING(x, y) ( -round(-(x) / (y)) * (y) )

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR(x, y) ( round((x) / (y)) * (y) )

// Real modulus that handles decimals
#define MODULUS(x, y) ( (x) - (y) * round((x) / (y)) )
