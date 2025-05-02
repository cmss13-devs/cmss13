//shuttle mode defines
#define SHUTTLE_IDLE    "idle"
#define SHUTTLE_IGNITING   "igniting"
#define SHUTTLE_RECALL  "recalled"
#define SHUTTLE_CALL    "called"
#define SHUTTLE_DOCKED  "docked"
#define SHUTTLE_STRANDED   "stranded"
#define SHUTTLE_CRASHED   "crashed"
#define SHUTTLE_ESCAPE  "escape"
#define SHUTTLE_ENDGAME "endgame: game over"
#define SHUTTLE_RECHARGING "recharging"
#define SHUTTLE_PREARRIVAL "pre-arrival"

#define EMERGENCY_IDLE_OR_RECALLED (SSshuttle.emergency && ((SSshuttle.emergency.mode == SHUTTLE_IDLE) || (SSshuttle.emergency.mode == SHUTTLE_RECALL)))
#define EMERGENCY_ESCAPED_OR_ENDGAMED (SSshuttle.emergency && ((SSshuttle.emergency.mode == SHUTTLE_ESCAPE) || (SSshuttle.emergency.mode == SHUTTLE_ENDGAME)))
#define EMERGENCY_AT_LEAST_DOCKED (SSshuttle.emergency && SSshuttle.emergency.mode != SHUTTLE_IDLE && SSshuttle.emergency.mode != SHUTTLE_RECALL && SSshuttle.emergency.mode != SHUTTLE_CALL)

// Shuttle return values
#define SHUTTLE_CAN_DOCK "can_dock"
#define SHUTTLE_NOT_A_DOCKING_PORT "not a docking port"
#define SHUTTLE_DWIDTH_TOO_LARGE "docking width too large"
#define SHUTTLE_WIDTH_TOO_LARGE "width too large"
#define SHUTTLE_DHEIGHT_TOO_LARGE "docking height too large"
#define SHUTTLE_HEIGHT_TOO_LARGE "height too large"
#define SHUTTLE_ALREADY_DOCKED "we are already docked"
#define SHUTTLE_SOMEONE_ELSE_DOCKED "someone else docked"

//Launching Shuttles to CentCom - used for escape shuttle code
#define NOLAUNCH -1
#define UNLAUNCHED 0
#define ENDGAME_LAUNCHED 1
#define EARLY_LAUNCHED 2
#define ENDGAME_TRANSIT 3

/// shuttle is immune to gamemode timer restrictions
#define GAMEMODE_IMMUNE (1<<0)

// Ripples, effects that signal a shuttle's arrival
#define SHUTTLE_RIPPLE_TIME 5 SECONDS

#define TRANSIT_REQUEST 1
#define TRANSIT_READY 2

#define SHUTTLE_TRANSIT_BORDER 16

#define PARALLAX_LOOP_TIME 25
#define HYPERSPACE_END_TIME 5

#define HYPERSPACE_WARMUP 1
#define HYPERSPACE_LAUNCH 2
#define HYPERSPACE_END 3

#define CALL_SHUTTLE_REASON_LENGTH 12

//Engine related
#define ENGINE_COEFF_MIN 0.5
#define ENGINE_COEFF_MAX 2
#define ENGINE_DEFAULT_MAXSPEED_ENGINES 5

//Docking error flags
#define DOCKING_SUCCESS   0
#define DOCKING_BLOCKED   (1<<0)
#define DOCKING_IMMOBILIZED   (1<<1)
#define DOCKING_AREA_EMPTY    (1<<2)
#define DOCKING_NULL_DESTINATION (1<<3)
#define DOCKING_NULL_SOURCE   (1<<4)

//Docking turf movements
#define MOVE_TURF  1
#define MOVE_AREA  2
#define MOVE_CONTENTS 4

//Rotation params
#define ROTATE_DIR 1
#define ROTATE_SMOOTH 2
#define ROTATE_OFFSET 4

#define SHUTTLE_DOCKER_LANDING_CLEAR 1
#define SHUTTLE_DOCKER_BLOCKED_BY_HIDDEN_PORT 2
#define SHUTTLE_DOCKER_BLOCKED 3

//Shuttle defaults
#define SHUTTLE_DEFAULT_SHUTTLE_AREA_TYPE /area/shuttle
#define SHUTTLE_DEFAULT_UNDERLYING_AREA /area/space


#define HIJACK_STATE_NORMAL "hijack_state_normal"
#define HIJACK_STATE_CALLED_DOWN "hijack_state_called_down"
#define HIJACK_STATE_QUEEN_LOCKED "hijack_state_queen_locked"
#define HIJACK_STATE_CRASHING "hijack_state_crashing"

#define LOCKDOWN_TIME 6 MINUTES
#define GROUND_LOCKDOWN_TIME 3 MINUTES

#define MOBILE_SHUTTLE_ID_ERT1 "ert_response_shuttle"
#define MOBILE_SHUTTLE_ID_ERT2 "ert_pmc_shuttle"
#define MOBILE_SHUTTLE_ID_ERT3 "ert_upp_shuttle"
#define MOBILE_SHUTTLE_ID_ERT4 "ert_twe_shuttle"
#define MOBILE_SHUTTLE_ID_ERT_SMALL "ert_small_shuttle_north"
#define MOBILE_SHUTTLE_ID_ERT_BIG "ert_shuttle_big"

#define MOBILE_TRIJENT_ELEVATOR "trijentshuttle2"
#define STAT_TRIJENT_EMPTY "trijent_empty"
#define STAT_TRIJENT_OCCUPIED "trijent_occupied"
#define STAT_TRIJENT_LZ1 "trijent_lz1"
#define STAT_TRIJENT_LZ2 "trijent_lz2"
#define STAT_TRIJENT_ENGI "trijent_engineering"
#define STAT_TRIJENT_OMEGA "trijent_omega"

#define MOBILE_SHUTTLE_LIFEBOAT_PORT "lifeboat-port"
#define MOBILE_SHUTTLE_LIFEBOAT_STARBOARD "lifeboat-starboard"
#define MOBILE_SHUTTLE_LIFEBOAT_ROSTOCK "lifeboat-rostock"
#define MOBILE_SHUTTLE_VEHICLE_ELEVATOR "vehicle_elevator"

#define DROPSHIP_ALAMO "dropship_alamo"
#define DROPSHIP_NORMANDY "dropship_normandy"
#define DROPSHIP_SAIPAN "dropship_saipan"
#define DROPSHIP_MORANA "dropship_morana"
#define DROPSHIP_DEVANA "dropship_devana"

#define ALMAYER_DROPSHIP_LZ1 "almayer-hangar-lz1"
#define ALMAYER_DROPSHIP_LZ2 "almayer-hangar-lz2"

#define UPP_DROPSHIP_LZ1 "upp-hangar-lz1"
#define UPP_DROPSHIP_LZ2 "upp-hangar-lz2"

#define DROPSHIP_FLYBY_ID "special_flight"
#define DROPSHIP_LZ1 "dropship-lz1"
#define DROPSHIP_LZ2 "dropship-lz2"

#define ESCAPE_SHUTTLE "escape-shuttle"
#define ESCAPE_SHUTTLE_EAST "escape_shuttle_e"
#define ESCAPE_SHUTTLE_EAST_CL "escape_shuttle_e_cl"
#define ESCAPE_SHUTTLE_WEST "escape_shuttle_w"
#define ESCAPE_SHUTTLE_NORTH "escape_shuttle_n"
#define ESCAPE_SHUTTLE_SOUTH "escape_shuttle_s"

#define ESCAPE_SHUTTLE_WEST_PREFIX "escape_shuttle_w"
#define ESCAPE_SHUTTLE_EAST_PREFIX "escape_shuttle_e"
#define ESCAPE_SHUTTLE_NORTH_PREFIX "escape_shuttle_n"
#define ESCAPE_SHUTTLE_SOUTH_PREFIX "escape_shuttle_s"

#define ESCAPE_SHUTTLE_DOCK_PREFIX "almayer-hangar-escape-shuttle-"

#define ERT_SHUTTLE_DEFAULT_RECHARGE 90 SECONDS

#define ADMIN_LANDING_PAD_1 "base-ert1"
#define ADMIN_LANDING_PAD_2 "base-ert2"
#define ADMIN_LANDING_PAD_3 "base-ert3"
#define ADMIN_LANDING_PAD_4 "base-ert4"
#define ADMIN_LANDING_PAD_5 "base-ert5"
#define ADMIN_LANDING_PAD_6 "base-ert6"
