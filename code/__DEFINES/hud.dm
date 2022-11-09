#define HUD_MIDNIGHT "midnight"
#define HUD_DARK "dark"
#define HUD_BRONZE "bronze"
#define HUD_GLASS "glass"
#define HUD_GREEN "green"
#define HUD_GREY "grey"
#define HUD_HOLO "holographic"
#define HUD_OLD "old"
#define HUD_ORANGE "orange"
#define HUD_RED "red"
#define HUD_WHITE "white"
#define HUD_ALIEN "alien"
#define HUD_ROBOT "robot"

// Consider these images/atoms as part of the UI/HUD (apart of the appearance_flags)
/// Used for progress bars and chat messages
#define APPEARANCE_UI_IGNORE_ALPHA (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA|PIXEL_SCALE)
/// Used for HUD objects
#define APPEARANCE_UI (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE)
