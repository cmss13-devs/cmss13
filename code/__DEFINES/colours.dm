// tg port thing

//different types of atom colourations
/// Only used by rare effects like greentext colouring mobs and when admins varedit colour
#define ADMIN_COLOUR_PRIORITY 1
/// e.g. purple effect of the revenant on a mob, black effect when mob electrocuted
#define TEMPORARY_COLOUR_PRIORITY 2
/// Colour splashed onto an atom (e.g. paint on turf)
#define WASHABLE_COLOUR_PRIORITY 3
/// Colour inherent to the atom (e.g. blob colour)
#define FIXED_COLOUR_PRIORITY 4
///how many colour priority levels there are.
#define COLOUR_PRIORITY_AMOUNT 4

#define COLOUR_DARKMODE_BACKGROUND "#202020"
#define COLOUR_DARKMODE_DARKBACKGROUND "#171717"
#define COLOUR_DARKMODE_TEXT "#a4bad6"

#define COLOUR_WHITE "#FFFFFF"
#define COLOUR_VERY_LIGHT_GRAY "#EEEEEE"
#define COLOUR_SILVER "#C0C0C0"
#define COLOUR_GRAY "#808080"
#define COLOUR_FLOORTILE_GRAY "#8D8B8B"
#define COLOUR_DARK "#454545"
#define COLOUR_ALMOST_BLACK "#333333"
#define COLOUR_BLACK "#000000"
#define COLOUR_HALF_TRANSPARENT_BLACK "#0000007A"

#define COLOUR_RED "#FF0000"
#define COLOUR_MOSTLY_PURE_RED "#FF3300"
#define COLOUR_DARK_RED "#A50824"
#define COLOUR_RED_LIGHT "#FF3333"
#define COLOUR_MAROON "#800000"
#define COLOUR_VIVID_RED "#FF3232"
#define COLOUR_LIGHT_GRAYISH_RED "#E4C7C5"
#define COLOUR_SOFT_RED "#FA8282"
#define COLOUR_CULT_RED "#960000"
#define COLOUR_BUBBLEGUM_RED "#950A0A"

#define COLOUR_YELLOW "#FFFF00"
#define COLOUR_VIVID_YELLOW "#FBFF23"
#define COLOUR_VERY_SOFT_YELLOW "#FAE48E"

#define COLOUR_OLIVE "#808000"
#define COLOUR_VIBRANT_LIME "#00FF00"
#define COLOUR_LIME "#32CD32"
#define COLOUR_DARK_LIME "#00aa00"
#define COLOUR_VERY_PALE_LIME_GREEN "#DDFFD3"
#define COLOUR_VERY_DARK_LIME_GREEN "#003300"
#define COLOUR_GREEN "#008000"
#define COLOUR_DARK_MODERATE_LIME_GREEN "#44964A"

#define COLOUR_CYAN "#00FFFF"
#define COLOUR_DARK_CYAN "#00A2FF"
#define COLOUR_TEAL "#008080"
#define COLOUR_BLUE "#0000FF"
#define COLOUR_STRONG_BLUE "#1919c8"
#define COLOUR_BRIGHT_BLUE "#2CB2E8"
#define COLOUR_MODERATE_BLUE "#555CC2"
#define COLOUR_AMETHYST "#822BFF"
#define COLOUR_BLUE_LIGHT "#33CCFF"
#define COLOUR_NAVY "#000080"
#define COLOUR_BLUE_GRAY "#75A2BB"

#define COLOUR_PINK "#FFC0CB"
#define COLOUR_LIGHT_PINK "#ff3cc8"
#define COLOUR_MOSTLY_PURE_PINK "#E4005B"
#define COLOUR_BLUSH_PINK "#DE5D83"
#define COLOUR_MAGENTA "#FF00FF"
#define COLOUR_STRONG_MAGENTA "#B800B8"
#define COLOUR_PURPLE "#800080"
#define COLOUR_VIOLET "#B900F7"
#define COLOUR_STRONG_VIOLET "#6927c5"

#define COLOUR_ORANGE "#FF9900"
#define COLOUR_MOSTLY_PURE_ORANGE "#ff8000"
#define COLOUR_TAN_ORANGE "#FF7B00"
#define COLOUR_BRIGHT_ORANGE "#E2853D"
#define COLOUR_LIGHT_ORANGE "#ffc44d"
#define COLOUR_PALE_ORANGE "#FFBE9D"
#define COLOUR_BEIGE "#CEB689"
#define COLOUR_DARK_ORANGE "#C3630C"
#define COLOUR_DARK_MODERATE_ORANGE "#8B633B"

#define COLOUR_BROWN "#BA9F6D"
#define COLOUR_DARK_BROWN "#997C4F"
#define COLOUR_ORANGE_BROWN "#a9734f"

//Colour defines used by the soapstone (based on readability against grey tiles)
#define COLOUR_SOAPSTONE_PLASTIC "#a19d94"
#define COLOUR_SOAPSTONE_IRON "#b2b2b2"
#define COLOUR_SOAPSTONE_BRONZE "#FE8001"
#define COLOUR_SOAPSTONE_SILVER "#FFFFFF"
#define COLOUR_SOAPSTONE_GOLD "#FFD900"
#define COLOUR_SOAPSTONE_DIAMOND "#00ffee"

#define COLOUR_GREEN_GRAY    "#99BB76"
#define COLOUR_RED_GRAY  "#B4696A"
#define COLOUR_PALE_BLUE_GRAY   "#98C5DF"
#define COLOUR_PALE_GREEN_GRAY  "#B7D993"
#define COLOUR_PALE_RED_GRAY "#D59998"
#define COLOUR_PALE_PURPLE_GRAY "#CBB1CA"
#define COLOUR_PURPLE_GRAY   "#AE8CA8"

//Colour defines used by the assembly detailer.
#define COLOUR_ASSEMBLY_BLACK   "#545454"
#define COLOUR_ASSEMBLY_BGRAY   "#9497AB"
#define COLOUR_ASSEMBLY_WHITE   "#E2E2E2"
#define COLOUR_ASSEMBLY_RED  "#CC4242"
#define COLOUR_ASSEMBLY_ORANGE  "#E39751"
#define COLOUR_ASSEMBLY_BEIGE   "#AF9366"
#define COLOUR_ASSEMBLY_BROWN   "#97670E"
#define COLOUR_ASSEMBLY_GOLD "#AA9100"
#define COLOUR_ASSEMBLY_YELLOW  "#CECA2B"
#define COLOUR_ASSEMBLY_GURKHA  "#999875"
#define COLOUR_ASSEMBLY_LGREEN  "#789876"
#define COLOUR_ASSEMBLY_GREEN   "#44843C"
#define COLOUR_ASSEMBLY_LBLUE   "#5D99BE"
#define COLOUR_ASSEMBLY_BLUE "#38559E"
#define COLOUR_ASSEMBLY_PURPLE  "#6F6192"

///Colours for xenobiology vatgrowing
#define COLOUR_SAMPLE_YELLOW "#c0b823"
#define COLOUR_SAMPLE_PURPLE "#342941"
#define COLOUR_SAMPLE_GREEN "#98b944"
#define COLOUR_SAMPLE_BROWN "#91542d"
#define COLOUR_SAMPLE_GRAY "#5e5856"

///Main colours for UI themes
#define COLOUR_THEME_MIDNIGHT "#6086A0"
#define COLOUR_THEME_PLASMAFIRE "#FFB200"
#define COLOUR_THEME_RETRO "#24CA00"
#define COLOUR_THEME_SLIMECORE "#4FB259"
#define COLOUR_THEME_OPERATIVE "#B8221F"
#define COLOUR_THEME_GLASS "#75A4C4"
#define COLOUR_THEME_CLOCKWORK "#CFBA47"

///Colours for eigenstates
#define COLOUR_PERIWINKLEE "#9999FF"
/**
 * Some defines to generalise colours used in lighting.
 *
 * Important note: colours can end up significantly different from the basic html picture, especially when saturated
 */
/// Bright but quickly dissipating neon green. rgb(100, 200, 100)
#define LIGHT_COLOUR_GREEN   "#64C864"
/// Electric green. rgb(0, 255, 0)
#define LIGHT_COLOUR_ELECTRIC_GREEN   "#00FF00"
/// Cold, diluted blue. rgb(100, 150, 250)
#define LIGHT_COLOUR_BLUE    "#6496FA"
/// Light blueish green. rgb(125, 225, 175)
#define LIGHT_COLOUR_BLUEGREEN  "#7DE1AF"
/// Diluted cyan. rgb(125, 225, 225)
#define LIGHT_COLOUR_CYAN    "#7DE1E1"
/// Electric cyan rgb(0, 255, 255)
#define LIGHT_COLOUR_ELECTRIC_CYAN "#00FFFF"
/// More-saturated cyan. rgb(64, 206, 255)
#define LIGHT_COLOUR_LIGHT_CYAN "#40CEFF"
/// Saturated blue. rgb(51, 117, 248)
#define LIGHT_COLOUR_DARK_BLUE  "#6496FA"
/// Diluted, mid-warmth pink. rgb(225, 125, 225)
#define LIGHT_COLOUR_PINK    "#E17DE1"
/// Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define LIGHT_COLOUR_YELLOW  "#E1E17D"
/// Clear brown, mostly dim. rgb(150, 100, 50)
#define LIGHT_COLOUR_BROWN   "#966432"
/// Mostly pure orange. rgb(250, 150, 50)
#define LIGHT_COLOUR_ORANGE  "#FA9632"
/// Light Purple. rgb(149, 44, 244)
#define LIGHT_COLOUR_PURPLE  "#952CF4"
/// Less-saturated light purple. rgb(155, 81, 255)
#define LIGHT_COLOUR_LAVENDER   "#9B51FF"
///slightly desaturated bright yellow.
#define LIGHT_COLOUR_HOLY_MAGIC "#FFF743"
/// deep crimson
#define LIGHT_COLOUR_BLOOD_MAGIC "#D00000"

/* These ones aren't a direct colour like the ones above, because nothing would fit */
/// Warm orange colour, leaning strongly towards yellow. rgb(250, 160, 25)
#define LIGHT_COLOUR_FIRE    "#FAA019"
/// Very warm yellow, leaning slightly towards orange. rgb(196, 138, 24)
#define LIGHT_COLOUR_LAVA    "#C48A18"
/// Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define LIGHT_COLOUR_FLARE   "#FA644B"
/// Weird colour, between yellow and green, very slimy. rgb(175, 200, 75)
#define LIGHT_COLOUR_SLIME_LAMP "#AFC84B"
/// Extremely diluted yellow, close to skin colour (for some reason). rgb(250, 225, 175)
#define LIGHT_COLOUR_TUNGSTEN   "#FAE1AF"
/// Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)
#define LIGHT_COLOUR_HALOGEN "#F0FAFA"

//The GAGS greyscale_colours for each department's computer/machine circuits
#define CIRCUIT_COLOUR_GENERIC "#1A7A13"
#define CIRCUIT_COLOUR_COMMAND "#1B4594"
#define CIRCUIT_COLOUR_SECURITY "#9A151E"
#define CIRCUIT_COLOUR_SCIENCE "#BC4A9B"
#define CIRCUIT_COLOUR_SERVICE "#92DCBA"
#define CIRCUIT_COLOUR_MEDICAL "#00CCFF"
#define CIRCUIT_COLOUR_ENGINEERING "#F8D700"
#define CIRCUIT_COLOUR_SUPPLY "#C47749"

/// The default colour for admin say, used as a fallback when the preference is not enabled
#define DEFAULT_ASAY_COLOUR COLOUR_MOSTLY_PURE_RED

#define DEFAULT_HEX_COLOUR_LEN 6

// Colour filters
/// Icon filter that creates ambient occlusion
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, border=4, color="#04080FAA")
/// Icon filter that creates gaussian blur
#define GAUSSIAN_BLUR(filter_size) filter(type="blur", size=filter_size)
