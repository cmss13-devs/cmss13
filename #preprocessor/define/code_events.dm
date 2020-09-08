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

// Raised when a mob is revived
// Args:
//	n/a
#define EVENT_REVIVED "revived"


// *----------------------* //
// 		Agent related
// *----------------------* //

// Raised when a wall is destroyed/built and by who, it goes EVENT_WALL_DESTROYED+\ref(mob)
// Args:
//	the type of wall destroyed/built
#define EVENT_WALL_DESTROYED "wall_destroyed"
#define EVENT_WALL_BUILT "wall_built"

// Raised when an airlock is destroyed and by who, it goes EVENT_AIRLOCK_DESTROYED+\ref(mob)
// Args:
//	the type of airlock destroyed
#define EVENT_AIRLOCK_DESTROYED "airlock_destroyed"

// Raised when a window frame is destroyed and by who, it goes EVENT_W_FRAME_DESTROYED+\ref(mob)
// Args:
//	the type of window frame destroyed
#define EVENT_W_FRAME_DESTROYED "w_frame_destroyed"

// Raised when a window is destroyed/built and by who, it goes EVENT_WINDOW_DESTROYED+\ref(mob)
// Args:
//	the type of window destroyed/built
#define EVENT_WINDOW_DESTROYED "window_destroyed"
#define EVENT_WINDOW_BUILT "window_built"

// Raised when a tracking device is planted by agents
// Args:
//	n/a
#define EVENT_TRACKING_PLANTED "tracking_planted"

// Raised when a propangda poster is planted by agents
// Args:
//	the area its placed at
#define EVENT_PROPAGANDA_PLANTED "propaganda_planted"

// Raised when poison is ate
// Args:
//	the job of eater
#define EVENT_POISON_EATEN "poison_eaten"

// Raised when an apc is disabled
// Args:
//	the area its disabled at
#define EVENT_APC_DISABLED "aps_disabled"

// Raised when a floppy disk is inserted into a computer
// Args:
//	n/a
#define EVENT_DISK_INSERTED "disk_inserted"