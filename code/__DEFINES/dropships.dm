// Legacy identifiers of dropship hardpoint/equipment types
#define DROPSHIP_WEAPON "dropship_weapon"
#define DROPSHIP_CREW_WEAPON "dropship_crew_weapon"
#define DROPSHIP_ELECTRONICS "dropship_electronics"
#define DROPSHIP_FUEL_EQP "dropship_fuel_equipment"
#define DROPSHIP_COMPUTER "dropship_computer"

//Automated transport
#define DROPSHIP_MAX_AUTO_DELAY 60 SECONDS
#define DROPSHIP_MIN_AUTO_DELAY 10 SECONDS
#define DROPSHIP_AUTO_RETRY_COOLDOWN 20 SECONDS
#define DROPSHIP_MEDEVAC_COOLDOWN 20 SECONDS

//Hatches states
#define SHUTTLE_DOOR_BROKEN -1
#define SHUTTLE_DOOR_UNLOCKED 0
#define SHUTTLE_DOOR_LOCKED 1

//Turbulence for dropships
#define DROPSHIP_TURBULENCE_FREEFALL_PERIOD 15 SECONDS // tied to the 'sound/effects/dropship_flight_start.ogg' sfx
#define DROPSHIP_TURBULENCE_START_PERIOD 10 SECONDS
#define DROPSHIP_TURBULENCE_PERIOD 5 SECONDS
#define DROPSHIP_TURBULENCE_THROWFORCE_MULTIPLIER 4
#define DROPSHIP_TURBULENCE_GRIPLOSS_PROBABILITY 25 // performed every move
#define DROPSHIP_TURBULENCE_PROBABILITY 50
#define DROPSHIP_TURBULENCE_BONEBREAK_PROBABILITY 10

//Dropship Airlocks
#define DROPSHIP_AIRLOCK_OUTER_AIRLOCK_ACCESS_GRACE_PERIOD 120 SECONDS
#define DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD 14 SECONDS // !!! MUST BE THE MAXIMUM TIME VALUE (ASIDE FROM AUTOMATIC DELAY) BELOW. RECOMMENDED YOU SET IT 5 SECONDS AHEAD DUE TO SYNCING REASONS
#define DROPSHIP_AIRLOCK_DECLAMP_PERIOD 3 SECONDS // tied to the 'sound/effects/dropship_flight_airlocked_start.ogg' sfx
#define DROPSHIP_AIRLOCK_HEIGHT_TRANSITION 9 SECONDS // tied to 'sound/machines/asrs_lowering.ogg' & 'sound/machines/asrs_raising.ogg' sfx
#define DROPSHIP_AIRLOCK_FLOODLIGHT_TRANSITION 1.5 SECONDS // quickly compounded by the amount of floodlights
#define DROPSHIP_AIRLOCK_DOOR_PERIOD 5 SECONDS // tied to ''sound/machines/centrifuge.ogg' & the animations of the dropship airlocks
#define DROPSHIP_AIRLOCK_AUTOMATIC_DELAY 5 SECONDS
#define DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECT x + -7, y + -12, z// for readability
#define DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_NE_BOUND x - -7, y - -12, z // for readability
#define DROPSHIP_AIRLOCK_BOUNDS locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_EFFECT), locate(DROPSHIP_AIRLOCK_FROM_DOCKPORT_TO_NE_BOUND) // for readability
#define DROPSHIP_AIRLOCK_GO_DOWN "down" // automated process command
#define DROPSHIP_AIRLOCK_GO_UP "up" // automated process command

//Bitflags for checking which automated docks are airlocks
#define DROPSHIP_HANGAR_DOCK_IS_AIRLOCK (1<<0)
#define DROPSHIP_LZ_DOCK_IS_AIRLOCK (1<<1)

//Dropship Airlock Ids
#define ALMAYER_HANGAR_AIRLOCK_ONE "almayer-hangar-airlock-one"
#define ALMAYER_HANGAR_AIRLOCK_TWO "almayer-hangar-airlock-two"
