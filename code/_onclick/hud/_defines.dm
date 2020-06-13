/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world_view_size), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

#define ui_monkey_mask "WEST+4:14,1:5"	//monkey
#define ui_monkey_back "WEST+5:14,1:5"	//monkey

//Upper-middle right (damage indicators)
#define ui_predator_power "EAST-1:28,9:13"

#define ui_acti_alt  "EAST-1:28,1:5" //alternative intent switcher for when the interface is hidden (F12)