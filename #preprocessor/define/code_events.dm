/*
	Put your defines for code events here.

	It's also much appreciated if you write documentation about which arguments
	will be given to the listeners when the event is raised.
*/

#define HALTED -1

// Raised when LMB is pressed. Args:
//   Atom that was clicked
//   Click parameters
//   The client that clicked
#define EVENT_LMBDOWN "lmbdown"

// Raised when LMB is released. Args:
//   Atom under the cursor when the mouse was released
//   Click parameters
//   The client that un-clicked
#define EVENT_LMBUP   "lmbup"

// Raised when LMB is held and dragged over something. Args:
//   The atom the drag started at
//   The atom under the cursor
//   Click parameters
//   The client that dragged their mouse
#define EVENT_LMBDRAG "lmbdrag"

// Raised when the crewmen orders a vehicle. Args:
//   The vehicle that was ordered
#define EVENT_VEHICLE_ORDERED "vehicle_ordered"

// Raised when a mob is about to be ignited or receive burn stacks (to check if getting ignited or receiving burn stacks is a valid).
// Args:
//	n/a
#define EVENT_PREIGNITION_CHECK "preignition_check"

// Raised when a mob is about to receive burn damage from fire (to check if receiving fire damage is valid).
// Args:
//	n/a
#define EVENT_PRE_FIRE_BURNED_CHECK "pre_fire_burned_check"

// Raised when a gun is dropped
// Args:
//	The mob who dropped the gun
#define EVENT_GUN_DROPPED "gun_dropped"

// Raised when an atom is about to be launched (to check if launch is valid)
// Args:
//	n/a
#define EVENT_LAUNCH_CHECK "launch_check"

// Raised when a client is reading key presses and a key is pressed
// Args:
//	The key pressed
#define EVENT_READ_KEY_DOWN "read_key_down"

// Raised when a client is reading key releases and a key is released
// Args:
//	The key released
#define EVENT_READ_KEY_UP "read_key_up"