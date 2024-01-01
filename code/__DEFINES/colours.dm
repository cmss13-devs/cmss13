// tg port thing

//different types of atom colorations
/// Only used by rare effects like greentext coloring mobs and when admins varedit color
#define CL_ADMIN_COLOR_PRIORITY 1
/// e.g. purple effect of the revenant on a mob, black effect when mob electrocuted
#define CL_TEMPORARY_COLOR_PRIORITY 2
/// Color splashed onto an atom (e.g. paint on turf)
#define CL_WASHABLE_COLOR_PRIORITY 3
/// Color inherent to the atom (e.g. blob color)
#define CL_FIXED_COLOR_PRIORITY 4
///how many color priority levels there are.
#define CL_COLOR_PRIORITY_AMOUNT 4

#define CL_COLOR_DARKMODE_BACKGROUND "#202020"
#define CL_COLOR_DARKMODE_DARKBACKGROUND "#171717"
#define CL_COLOR_DARKMODE_TEXT "#a4bad6"

#define CL_COLOR_WHITE "#FFFFFF"
#define CL_COLOR_VERY_LIGHT_GRAY "#EEEEEE"
#define CL_COLOR_SILVER "#C0C0C0"
#define CL_COLOR_GRAY "#808080"
#define CL_COLOR_FLOORTILE_GRAY "#8D8B8B"
#define CL_COLOR_DARK "#454545"
#define CL_COLOR_ALMOST_BLACK "#333333"
#define CL_COLOR_BLACK "#000000"
#define CL_COLOR_HALF_TRANSPARENT_BLACK "#0000007A"

#define CL_COLOR_RED "#FF0000"
#define CL_COLOR_MOSTLY_PURE_RED "#FF3300"
#define CL_COLOR_DARK_RED "#A50824"
#define CL_COLOR_RED_LIGHT "#FF3333"
#define CL_COLOR_MAROON "#800000"
#define CL_COLOR_VIVID_RED "#FF3232"
#define CL_COLOR_LIGHT_GRAYISH_RED "#E4C7C5"
#define CL_COLOR_SOFT_RED "#FA8282"
#define CL_COLOR_CULT_RED "#960000"
#define CL_COLOR_BUBBLEGUM_RED "#950A0A"

#define CL_COLOR_YELLOW "#FFFF00"
#define CL_COLOR_VIVID_YELLOW "#FBFF23"
#define CL_COLOR_VERY_SOFT_YELLOW "#FAE48E"

#define CL_COLOR_OLIVE "#808000"
#define CL_COLOR_VIBRANT_LIME "#00FF00"
#define CL_COLOR_LIME "#32CD32"
#define CL_COLOR_DARK_LIME "#00aa00"
#define CL_COLOR_VERY_PALE_LIME_GREEN "#DDFFD3"
#define CL_COLOR_VERY_DARK_LIME_GREEN "#003300"
#define CL_COLOR_GREEN "#008000"
#define CL_COLOR_DARK_MODERATE_LIME_GREEN "#44964A"

#define CL_COLOR_CYAN "#00FFFF"
#define CL_COLOR_DARK_CYAN "#00A2FF"
#define CL_COLOR_TEAL "#008080"
#define CL_COLOR_BLUE "#0000FF"
#define CL_COLOR_STRONG_BLUE "#1919c8"
#define CL_COLOR_BRIGHT_BLUE "#2CB2E8"
#define CL_COLOR_MODERATE_BLUE "#555CC2"
#define CL_COLOR_AMETHYST "#822BFF"
#define CL_COLOR_BLUE_LIGHT "#33CCFF"
#define CL_COLOR_NAVY "#000080"
#define CL_COLOR_BLUE_GRAY "#75A2BB"

#define CL_COLOR_PINK "#FFC0CB"
#define CL_COLOR_LIGHT_PINK "#ff3cc8"
#define CL_COLOR_MOSTLY_PURE_PINK "#E4005B"
#define CL_COLOR_BLUSH_PINK "#DE5D83"
#define CL_COLOR_MAGENTA "#FF00FF"
#define CL_COLOR_STRONG_MAGENTA "#B800B8"
#define CL_COLOR_PURPLE "#800080"
#define CL_COLOR_VIOLET "#B900F7"
#define CL_COLOR_STRONG_VIOLET "#6927c5"

#define CL_COLOR_ORANGE "#FF9900"
#define CL_COLOR_MOSTLY_PURE_ORANGE "#ff8000"
#define CL_COLOR_TAN_ORANGE "#FF7B00"
#define CL_COLOR_BRIGHT_ORANGE "#E2853D"
#define CL_COLOR_LIGHT_ORANGE "#ffc44d"
#define CL_COLOR_PALE_ORANGE "#FFBE9D"
#define CL_COLOR_BEIGE "#CEB689"
#define CL_COLOR_DARK_ORANGE "#C3630C"
#define CL_COLOR_DARK_MODERATE_ORANGE "#8B633B"

#define CL_COLOR_BROWN "#BA9F6D"
#define CL_COLOR_DARK_BROWN "#997C4F"
#define CL_COLOR_ORANGE_BROWN "#a9734f"

//Color defines used by the soapstone (based on readability against grey tiles)
#define CL_COLOR_SOAPSTONE_PLASTIC "#a19d94"
#define CL_COLOR_SOAPSTONE_IRON "#b2b2b2"
#define CL_COLOR_SOAPSTONE_BRONZE "#FE8001"
#define CL_COLOR_SOAPSTONE_SILVER "#FFFFFF"
#define CL_COLOR_SOAPSTONE_GOLD "#FFD900"
#define CL_COLOR_SOAPSTONE_DIAMOND "#00ffee"

#define CL_COLOR_GREEN_GRAY    "#99BB76"
#define CL_COLOR_RED_GRAY  "#B4696A"
#define CL_COLOR_PALE_BLUE_GRAY   "#98C5DF"
#define CL_COLOR_PALE_GREEN_GRAY  "#B7D993"
#define CL_COLOR_PALE_RED_GRAY "#D59998"
#define CL_COLOR_PALE_PURPLE_GRAY "#CBB1CA"
#define CL_COLOR_PURPLE_GRAY   "#AE8CA8"

//Color defines used by the assembly detailer.
#define CL_COLOR_ASSEMBLY_BLACK   "#545454"
#define CL_COLOR_ASSEMBLY_BGRAY   "#9497AB"
#define CL_COLOR_ASSEMBLY_WHITE   "#E2E2E2"
#define CL_COLOR_ASSEMBLY_RED  "#CC4242"
#define CL_COLOR_ASSEMBLY_ORANGE  "#E39751"
#define CL_COLOR_ASSEMBLY_BEIGE   "#AF9366"
#define CL_COLOR_ASSEMBLY_BROWN   "#97670E"
#define CL_COLOR_ASSEMBLY_GOLD "#AA9100"
#define CL_COLOR_ASSEMBLY_YELLOW  "#CECA2B"
#define CL_COLOR_ASSEMBLY_GURKHA  "#999875"
#define CL_COLOR_ASSEMBLY_LGREEN  "#789876"
#define CL_COLOR_ASSEMBLY_GREEN   "#44843C"
#define CL_COLOR_ASSEMBLY_LBLUE   "#5D99BE"
#define CL_COLOR_ASSEMBLY_BLUE "#38559E"
#define CL_COLOR_ASSEMBLY_PURPLE  "#6F6192"

///Colors for xenobiology vatgrowing
#define CL_COLOR_SAMPLE_YELLOW "#c0b823"
#define CL_COLOR_SAMPLE_PURPLE "#342941"
#define CL_COLOR_SAMPLE_GREEN "#98b944"
#define CL_COLOR_SAMPLE_BROWN "#91542d"
#define CL_COLOR_SAMPLE_GRAY "#5e5856"

///Main Colors for UI themes
#define CL_COLOR_THEME_MIDNIGHT "#6086A0"
#define CL_COLOR_THEME_PLASMAFIRE "#FFB200"
#define CL_COLOR_THEME_RETRO "#24CA00"
#define CL_COLOR_THEME_SLIMECORE "#4FB259"
#define CL_COLOR_THEME_OPERATIVE "#B8221F"
#define CL_COLOR_THEME_GLASS "#75A4C4"
#define CL_COLOR_THEME_CLOCKWORK "#CFBA47"

///Colors for eigenstates
#define CL_COLOR_PERIWINKLEE "#9999FF"
/**
 * Some defines to generalise Colors used in lighting.
 *
 * Important note: Colors can end up significantly different from the basic html picture, especially when saturated
 */

/// Full white. rgb(255, 255, 255)
#define LIGHT_COLOR_WHITE "#FFFFFF"
/// Bright but quickly dissipating neon green. rgb(100, 200, 100)
#define CL_LIGHT_COLOR_GREEN   "#64C864"
/// Electric green. rgb(0, 255, 0)
#define CL_LIGHT_COLOR_ELECTRIC_GREEN   "#00FF00"
/// Cold, diluted blue. rgb(100, 150, 250)
#define CL_LIGHT_COLOR_BLUE    "#6496FA"
/// Light blueish green. rgb(125, 225, 175)
#define CL_LIGHT_COLOR_BLUEGREEN  "#7DE1AF"
/// Diluted cyan. rgb(125, 225, 225)
#define CL_LIGHT_COLOR_CYAN    "#7DE1E1"
/// Electric cyan rgb(0, 255, 255)
#define CL_LIGHT_COLOR_ELECTRIC_CYAN "#00FFFF"
/// More-saturated cyan. rgb(64, 206, 255)
#define CL_LIGHT_COLOR_LIGHT_CYAN "#40CEFF"
/// Saturated blue. rgb(51, 117, 248)
#define CL_LIGHT_COLOR_DARK_BLUE  "#6496FA"
/// Diluted, mid-warmth pink. rgb(225, 125, 225)
#define CL_LIGHT_COLOR_PINK    "#E17DE1"
/// Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define CL_LIGHT_COLOR_YELLOW  "#E1E17D"
/// Clear brown, mostly dim. rgb(150, 100, 50)
#define CL_LIGHT_COLOR_BROWN   "#966432"
/// Mostly pure orange. rgb(250, 150, 50)
#define CL_LIGHT_COLOR_ORANGE  "#FA9632"
/// Light Purple. rgb(149, 44, 244)
#define CL_LIGHT_COLOR_PURPLE  "#952CF4"
/// Less-saturated light purple. rgb(155, 81, 255)
#define CL_LIGHT_COLOR_LAVENDER   "#9B51FF"
///slightly desaturated bright yellow.
#define CL_LIGHT_COLOR_HOLY_MAGIC "#FFF743"
/// deep crimson
#define CL_LIGHT_COLOR_BLOOD_MAGIC "#D00000"

/* These ones aren't a direct color like the ones above, because nothing would fit */
/// Warm orange color, leaning strongly towards yellow. rgb(250, 160, 25)
#define CL_LIGHT_COLOR_FIRE    "#FAA019"
/// Very warm yellow, leaning slightly towards orange. rgb(196, 138, 24)
#define CL_LIGHT_COLOR_LAVA    "#C48A18"
/// Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define CL_LIGHT_COLOR_FLARE   "#FA644B"
/// Weird color, between yellow and green, very slimy. rgb(175, 200, 75)
#define CL_LIGHT_COLOR_SLIME_LAMP "#AFC84B"
/// Extremely diluted yellow, close to skin color (for some reason). rgb(250, 225, 175)
#define CL_LIGHT_COLOR_TUNGSTEN   "#FAE1AF"
/// Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)
#define CL_LIGHT_COLOR_HALOGEN "#F0FAFA"

//The GAGS greyscale_colors for each department's computer/machine circuits
#define CL_CIRCUIT_COLOR_GENERIC "#1A7A13"
#define CL_CIRCUIT_COLOR_COMMAND "#1B4594"
#define CL_CIRCUIT_COLOR_SECURITY "#9A151E"
#define CL_CIRCUIT_COLOR_SCIENCE "#BC4A9B"
#define CL_CIRCUIT_COLOR_SERVICE "#92DCBA"
#define CL_CIRCUIT_COLOR_MEDICAL "#00CCFF"
#define CL_CIRCUIT_COLOR_ENGINEERING "#F8D700"
#define CL_CIRCUIT_COLOR_SUPPLY "#C47749"

/// The default color for admin say, used as a fallback when the preference is not enabled
#define DEFAULT_ASAY_COLOR CL_COLOR_MOSTLY_PURE_RED

#define DEFAULT_HEX_COLOR_LEN 6

// Color filters
/// Icon filter that creates ambient occlusion
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, border=4, color="#04080FAA")
/// Icon filter that creates gaussian blur
#define GAUSSIAN_BLUR(filter_size) filter(type="blur", size=filter_size)

/* TEMPORARY COMMENT UNTIL WE CAN SAFELY REMOVE THE CL_ MARK WITHOUT CAUSING ANY ISSUES.

For part one i don't want to touch files not currently link to colours.dm seem safer and easier

starting to list all the files and their defines that may cause conflicts bellow

File that are already defining  COLORS that are in colours.dm and will enter into conflict..?
	_math.dm (COLOR_RED,COLOR_RED,COLOR_RED,COLOR_CYAN,COLOR_PINK,COLOR_YELLOW,COLOR_ORANGE,COLOR_WHITE,COLOR_BLACK,)

their is also a bunch of scater place where colours are define shouldn't we have every color being define here
maybe seperated into section if needed?

*/
