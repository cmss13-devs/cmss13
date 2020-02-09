/*
	Put your defines for code events here.

	It's also much appreciated if you write documentation about which arguments
	will be given to the listeners when the event is raised.
*/

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
