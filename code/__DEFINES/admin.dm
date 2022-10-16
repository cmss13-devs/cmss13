#define WRAP_STAFF_LOG(X, M) "[key_name(X)] [M]"

#define DMM_COORDINATE_COMMAND "//coord"

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

///This note is used by staff for disciplinary record keeping.
#define NOTE_ADMIN			1
///This note is used by staff for positive record keeping.
#define NOTE_MERIT			2
///These notes are used by respective whitelist councils for record keeping.
#define NOTE_COMMANDER		3
#define NOTE_SYNTHETIC		4
#define NOTE_YAUTJA			5
///Note categories in text form, in order of their numerical #defines.
var/global/list/note_categories = list("Admin", "Merit", "Commanding Officer", "Synthetic", "Yautja")

#define ADMIN_FLW(user) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservefollow=[REF(user)]'>FLW</a>)"
#define ADMIN_PP(user) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=[REF(user)]'>PP</a>)"
#define ADMIN_VV(atom) "(<a href='?_src_=vars;[HrefToken(forceGlobal = TRUE)];Vars=[REF(atom)]'>VV</a>)"
#define ADMIN_SM(user) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=[REF(user)]'>SM</a>)"
#define ADMIN_KICK(user) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];boot2=[REF(user)]'>KICK</a>)"
#define ADMIN_SC(user) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminspawncookie=[REF(user)]'>SC</a>)"
#define ADMIN_LOOKUP(user) "[key_name_admin(user)][ADMIN_QUE(user)]"
#define ADMIN_LOOKUPFLW(user) "[key_name_admin(user)][ADMIN_QUE(user)] [ADMIN_FLW(user)]"
#define ADMIN_FULLMONTY_NONAME(user) "[ADMIN_PP(user)] [ADMIN_VV(user)] [ADMIN_SM(user)] [ADMIN_FLW(user)]"
#define ADMIN_FULLMONTY(user) "[key_name_admin(user)] [ADMIN_FULLMONTY_NONAME(user)]"
#define ADMIN_JMP(src) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)"
#define COORD(src) "[src ? src.Admin_Coordinates_Readable() : "nonexistent location"]"
#define AREACOORD(src) "[src ? src.Admin_Coordinates_Readable(TRUE) : "nonexistent location"]"
#define ADMIN_COORDJMP(src) "[src ? src.Admin_Coordinates_Readable(FALSE, TRUE) : "nonexistent location"]"
#define ADMIN_VERBOSEJMP(src) "[src ? src.Admin_Coordinates_Readable(TRUE, TRUE) : "nonexistent location"]"
#define ADMIN_INDIVIDUALLOG(user) "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];individuallog=[REF(user)]'>LOGS</a>)"
#define ADMIN_TAG(datum) "(<A href='?src=[REF(src)];[HrefToken(forceGlobal = TRUE)];tag_datum=[REF(datum)]'>TAG</a>)"

/// for [/proc/check_asay_links], if there are any actionable refs in the asay message, this index in the return list contains the new message text to be printed
#define ASAY_LINK_NEW_MESSAGE_INDEX "!asay_new_message"
/// for [/proc/check_asay_links], if there are any admin pings in the asay message, this index in the return list contains a list of admins to ping
#define ASAY_LINK_PINGED_ADMINS_INDEX "!pinged_admins"

#define AHELP_ACTIVE 1
#define AHELP_CLOSED 2
#define AHELP_RESOLVED 3

/// Disables antigrief entirely: Anyone can activate explosives at any time on the Almayer.
#define ANTIGRIEF_DISABLED 0
/// Enables antigrief on the Almayer, but only for new players: Those who've had less than 10 total human hours.
#define ANTIGRIEF_NEW_PLAYERS 1
/// Enables antigrief entirely: Nobody can activate explosives on the Almayer, unless the ship crashed.
#define ANTIGRIEF_ENABLED 2
