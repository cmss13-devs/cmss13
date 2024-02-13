/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by GLOB.world_view_size), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

#define ui_monkey_mask "WEST+4:14,1:5" //monkey
#define ui_monkey_back "WEST+5:14,1:5" //monkey

//Upper-middle right (damage indicators)
#define ui_predator_power "EAST-1:28,9:13"

#define ui_acti_alt  "EAST-1:28,1:5" //alternative intent switcher for when the interface is hidden (F12)

// Ghosts
#define ui_ghost_slot1 "SOUTH:6,CENTER-2:0"
#define ui_ghost_slot2 "SOUTH:6,CENTER-1:0"
#define ui_ghost_slot3 "SOUTH:6,CENTER:0"
#define ui_ghost_slot4 "SOUTH:6,CENTER+1:0"
#define ui_ghost_slot5 "SOUTH:6,CENTER+2:0"

//Upper-middle right (alerts)
#define ui_alert1 "EAST-1:28,CENTER+5:27"
#define ui_alert2 "EAST-1:28,CENTER+4:25"
#define ui_alert3 "EAST-1:28,CENTER+3:23"
#define ui_alert4 "EAST-1:28,CENTER+2:21"
#define ui_alert5 "EAST-1:28,CENTER+1:19"
