#define WRAP_STAFF_LOG(X, M) "[key_name(X)] [M]"

#define DMM_COORDINATE_COMMAND "//coord"

#define COORD(src) "[src ? src.Admin_Coordinates_Readable() : "nonexistent location"]"

/atom/proc/Admin_Coordinates_Readable(area_name, admin_jump_ref)
	var/turf/T = get_turf(src)
	return T ? "[area_name ? "[get_area_name(T, TRUE)] " : " "]([T.x],[T.y],[T.z])" : "nonexistent location"

///Max length of a keypress command before it's considered to be a forged packet/bogus command
#define MAX_KEYPRESS_COMMANDLENGTH 16
///Maximum keys that can be bound to one button
#define MAX_COMMANDS_PER_KEY 5
///Maximum keys per keybind
#define MAX_KEYS_PER_KEYBIND 3
///Max amount of keypress messages per second over two seconds before client is autokicked
#define MAX_KEYPRESS_AUTOKICK 75
///Length of held key buffer
#define HELD_KEY_BUFFER_LENGTH 15
