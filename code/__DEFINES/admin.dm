#define WRAP_STAFF_LOG(X, M) "[key_name(X)] [M]"

#define DMM_COORDINATE_COMMAND "//coord"

#define COORD(src) "[src ? src.Admin_Coordinates_Readable() : "nonexistent location"]"

/atom/proc/Admin_Coordinates_Readable(area_name, admin_jump_ref)
	var/turf/T = get_turf(src)
	return T ? "[area_name ? "[get_area_name(T, TRUE)] " : " "]([T.x],[T.y],[T.z])" : "nonexistent location"
