//Defines file for click related parameters
//this is mostly for ease of use and for finding all the things that use say RIGHT_CLICK rather then just searching "right"

//Mouse buttons held
#define RIGHT_CLICK "right"
#define MIDDLE_CLICK "middle"
#define LEFT_CLICK "left"

///Mouse button that was just clicked/released
///if(modifiers[BUTTON] == LEFT_CLICK)
#define BUTTON "button"

//Keys held down during the mouse action
#define CTRL_CLICK "ctrl"
#define ALT_CLICK "alt"
#define SHIFT_CLICK "shift"

//Cells involved if using a Grid control
#define DRAG_CELL "drag-cell"
#define DROP_CELL "drop-cell"

//The button used for dragging (only sent for unrelated mouse up/down messages during a drag)
#define DRAG "drag"

//If the mouse is over a link in maptext, or this event is related to clicking such a link
#define LINK "link"

//Pixel coordinates relative to the icon's position on screen
#define VIS_X "vis-x"
#define VIS_Y "vis-y"

//Pixel coordinates within the icon, in the icon's coordinate space
#define ICON_X "icon-x"
#define ICON_Y "icon-y"

//Pixel coordinates in screen_loc format ("[tile_x]:[pixel_x],[tile_y]:[pixel_y]")
#define SCREEN_LOC "screen-loc"

/// From /mob/proc/click_adjacent() : (atom/A, obj/item/W, mods) makes it so the affterattack proc isn't called
#define ATTACKBY_HINT_NO_AFTERATTACK (1 << 0) 
/// From /mob/proc/click_adjacent() : (atom/A, obj/item/W, mods) applies the click delay to next_move
#define ATTACKBY_HINT_UPDATE_NEXT_MOVE (1 << 1)
