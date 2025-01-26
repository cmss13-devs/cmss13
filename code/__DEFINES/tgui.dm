/// Green eye; fully interactive
#define UI_INTERACTIVE 2
/// Orange eye; updates but is not interactive
#define UI_UPDATE 1
/// Red eye; disabled, does not update
#define UI_DISABLED 0
/// UI Should close
#define UI_CLOSE -1

/// Maximum number of windows that can be suspended/reused
#define TGUI_WINDOW_SOFT_LIMIT 5
/// Maximum number of open windows
#define TGUI_WINDOW_HARD_LIMIT 9

/// Maximum ping timeout allowed to detect zombie windows
#define TGUI_PING_TIMEOUT 4 SECONDS
/// Used for rate-limiting to prevent DoS by excessively refreshing a TGUI window
#define TGUI_REFRESH_FULL_UPDATE_COOLDOWN 2 SECONDS

/// Window does not exist
#define TGUI_WINDOW_CLOSED 0
/// Window was just opened, but is still not ready to be sent data
#define TGUI_WINDOW_LOADING 1
/// Window is free and ready to receive data
#define TGUI_WINDOW_READY 2

/// Get a window id based on the provided pool index
#define TGUI_WINDOW_ID(index) "tgui-window-[index]"
/// Get a pool index of the provided window id
#define TGUI_WINDOW_INDEX(window_id) text2num(copytext(window_id, 13))

/// Creates a message packet for sending via output()
// This is {"type":type,"payload":payload}, but pre-encoded. This is much faster
// than doing it the normal way.
// To ensure this is correct, this is unit tested in tgui_create_message.
#define TGUI_CREATE_MESSAGE(type, payload) ( \
	"%7b%22type%22%3a%22[type]%22%2c%22payload%22%3a[url_encode(json_encode(payload))]%7d" \
)

/// Creates a message packet for sending via output() specifically for opening tgsay using an embedded winget
// This is {"type":"open","payload":{"channel":channel,"mapfocus":[[map.focus]],"lobyfocus":[[lobby_browser.focus]]}}, but pre-encoded.
#define TGUI_CREATE_OPEN_MESSAGE(channel) ( \
	"%7b%22type%22%3a%22open%22%2c%22payload%22%3a%7b%22channel%22%3a%22[channel]%22%2c%22mapfocus%22%3a\[\[map.focus\]\]%2c%22lobbyfocus%22%3a\[\[lobby_browser.focus\]\]%7d%7d" \
)

/*
*Defines for the TGUI health analyser interface
*The higher the level, the more information you can see
*/

#define DETAIL_LEVEL_HEALTHANALYSER 0
#define DETAIL_LEVEL_BODYSCAN 1
#define DETAIL_LEVEL_FULL 2

#define UI_MODE_MINIMAL 1
#define UI_MODE_CLASSIC 0
