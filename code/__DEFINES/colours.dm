// tg port thing

//different types of atom colorations
/// Only used by rare effects like greentext coloring mobs and when admins varedit color
#define ADMIN_COLOR_PRIORITY 1
/// e.g. purple effect of the revenant on a mob, black effect when mob electrocuted
#define TEMPORARY_COLOR_PRIORITY 2
/// Color splashed onto an atom (e.g. paint on turf)
#define WASHABLE_COLOR_PRIORITY 3
/// Color inherent to the atom (e.g. blob color)
#define FIXED_COLOR_PRIORITY 4
///how many color priority levels there are.
#define COLOR_PRIORITY_AMOUNT 4

// BLACK AND WHITE COLOR DEFINE.

/// White	rgb(255, 255, 255)
#define COLOR_WHITE "#FFFFFF"
/// Black	rgb(0, 0, 0)
#define COLOR_BLACK "#000000"

// THE THREE PRIMARIES COLORS DEFINES.

/// Red		rgb(255, 0, 0)
#define COLOR_RED "#FF0000"
/// Green	rgb(0, 255, 0)
#define COLOR_GREEN "#00FF00"
/// Blue	rgb(0, 0, 255)
#define COLOR_BLUE "#0000FF"

//mix of two full primary colors

/// Cyan	rgb(0, 255, 255) B + G
#define COLOR_CYAN "#00FFFF"
/// Magenta	rgb(255, 0, 255) R+B
#define COLOR_MAGENTA "#FF00FF"
/// Yellow	rgb(255, 255, 0) R+G
#define COLOR_YELLOW "#FFFF00"

// colors define in use bellow

/// Olive	rgb(128, 128, 0)
#define COLOR_OLIVE "#808000"
/// Silver	rgb(192, 192, 192) shade of grey
#define COLOR_SILVER "#C0C0C0"
/// Gray	rgb(128, 128, 128)
#define COLOR_GRAY "#808080"

#define COLOR_FLOORTILE_GRAY "#8D8B8B"

#define COLOR_HALF_TRANSPARENT_BLACK "#0000007A"

#define COLOR_DARK_RED "#A50824"

/// Maroon	rgb(128, 0, 0) shade of red
#define COLOR_MAROON "#800000"

#define COLOR_VIVID_RED "#FF3232"
#define COLOR_LIGHT_GRAYISH_RED "#E4C7C5"
#define COLOR_SOFT_RED "#FA8282"

#define COLOR_VERY_SOFT_YELLOW "#FAE48E"

///light green rgb( 0, 128, 0)
#define COLOR_LIGHT_GREEN "#008000"
#define COLOR_DARK_MODERATE_LIME_GREEN "#44964A"

#define COLOR_TEAL "#008080"

#define COLOR_MODERATE_BLUE "#555CC2"
/// Purple	rgb( 128, 0, 128)
#define COLOR_PURPLE "#800080"
#define COLOR_STRONG_VIOLET "#6927c5"

#define LIGHT_BEIGE "#CEB689"
#define COLOR_DARK_MODERATE_ORANGE "#8B633B"

#define COLOR_BROWN "#BA9F6D"
#define COLOR_DARK_BROWN "#997C4F"

/**
 * Some defines to generalise Colors used in lighting.
 *
 * Important note: Colors can end up significantly different from the basic html picture, especially when saturated
 */

/// Bright but quickly dissipating neon green. rgb(100, 200, 100)
#define LIGHT_COLOR_GREEN   "#64C864"
/// Cold, diluted blue. rgb(100, 150, 250)
#define LIGHT_COLOR_BLUE    "#6496FA"
/// Light blueish green. rgb(125, 225, 175)
#define LIGHT_COLOR_BLUEGREEN  "#7DE1AF"
/// Diluted cyan. rgb(125, 225, 225)
#define LIGHT_COLOR_CYAN    "#7DE1E1"
/// More-saturated cyan. rgb(64, 206, 255)
#define LIGHT_COLOR_LIGHT_CYAN "#40CEFF"
/// Saturated blue. rgb(51, 117, 248)
#define LIGHT_COLOR_DARK_BLUE  "#3375F8"
/// Diluted, mid-warmth pink. rgb(225, 125, 225)
#define LIGHT_COLOR_PINK    "#E17DE1"
/// Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define LIGHT_COLOR_YELLOW  "#E1E17D"
/// Clear brown, mostly dim. rgb(150, 100, 50)
#define LIGHT_COLOR_BROWN   "#966432"
/// Mostly pure orange. rgb(250, 150, 50)
#define LIGHT_COLOR_ORANGE  "#FA9632"
/// Light Purple. rgb(149, 44, 244)
#define LIGHT_COLOR_PURPLE  "#952CF4"
/// Less-saturated light purple. rgb(155, 81, 255)
#define LIGHT_COLOR_LAVENDER   "#9B51FF"
///slightly desaturated bright yellow.
#define LIGHT_COLOR_HOLY_MAGIC "#FFF743"
/// deep crimson
#define LIGHT_COLOR_BLOOD_MAGIC "#D00000"
/// Warm red color rgb(250, 66, 66)
#define LIGHT_COLOR_RED "#ff3b3b"

/* These ones aren't a direct color like the ones above, because nothing would fit */
/// Warm orange color, leaning strongly towards yellow. rgb(250, 160, 25)
#define LIGHT_COLOR_FIRE    "#FAA019"
/// Very warm yellow, leaning slightly towards orange. rgb(196, 138, 24)
#define LIGHT_COLOR_LAVA    "#C48A18"
/// Very warm yellowish-white color for candlelight. rgb(255, 187, 110)
#define LIGHT_COLOR_CANDLE "#FFBB6E"
/// Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define LIGHT_COLOR_FLARE   "#FA644B"
/// Weird color, between yellow and green, very slimy. rgb(175, 200, 75)
#define LIGHT_COLOR_SLIME_LAMP "#AFC84B"
/// Incandascent warm white, for usage in lights. rgb(255, 239, 210)
#define LIGHT_COLOR_TUNGSTEN "#FFEFD2"
/// Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)
#define LIGHT_COLOR_HALOGEN "#F0FAFA"
/// Bluish cyan color for blue lights. rgb(210, 227, 236)
#define LIGHT_COLOR_XENON "#D2E3EC"

/// The default color for admin say, used as a fallback when the preference is not enabled

#define COLOR_MOSTLY_PURE_RED "#FF3300"
#define DEFAULT_ASAY_COLOR COLOR_MOSTLY_PURE_RED

#define DEFAULT_HEX_COLOR_LEN 6

// Color filters
/// Icon filter that creates ambient occlusion
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, border=4, color="#04080FAA")
/// Icon filter that creates gaussian blur
#define GAUSSIAN_BLUR(filter_size) filter(type="blur", size=filter_size)

//some colors coming from _math.dm

#define COLOR_ORANGE "#FF9900"
#define COLOR_OIL "#030303"

//Grass Colors coming from _math.dm

#define COLOR_G_ICE "#C7EDDE" //faded cyan
#define COLOR_G_DES "#FF7C1C" //bright orange
#define COLOR_G_JUNG "#64AA6E" //faded green

/// Gun muzzle colors
#define COLOR_LASER_RED "#FF8D8D"
#define COLOR_MUZZLE_BLUE "#2CB2E8"

