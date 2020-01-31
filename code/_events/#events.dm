/*
	Put your defines for code events here.

	It's also much appreciated if you write documentation about which arguments
	will be given to the listeners when the event is raised.
*/

// Raised on clients when LMB is pressed. Args:
//   Atom that was clicked
//   Click parameters
#define EVENT_LMBDOWN "lmbdown"

// Raised on clients when LMB is released. Args:
//   Atom under the cursor when the mouse was released
//   Click parameters
#define EVENT_LMBUP   "lmbup"

// Raised on clients when LMB is held and dragged over something. Args:
//   The atom the drag started at
//   The atom under the cursor
//   Click parameters
#define EVENT_LMBDRAG "lmbdrag"
