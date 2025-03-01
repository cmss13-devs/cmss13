#define CALCULATING_PATH(X) (X in SSpathfinding.hash_path)

#define DIRECTION_CHANGE_PENALTY 2
#define NO_WEED_PENALTY 2
#define DISTANCE_PENALTY 1
#define ASTAR_COST_FUNCTION(n) (abs(n.x - target.x)+abs(n.y - target.y))

#define OPEN_TURF_PENALTY 1
#define DOOR_PENALTY 3
#define HUMAN_PENALTY 4
#define XENO_PENALTY 20
#define OBJECT_PENALTY 20
#define FIRE_PENALTY 25
#define SENTRY_PENALTY 25
#define VEHICLE_PENALTY 25
#define LOCKED_DOOR_PENALTY 25
#define WINDOW_FRAME_PENALTY 25
#define BARRICADE_PENALTY 50
#define WALL_PENALTY 100

/*
PROBABILITY CALCULATIONS ARE HERE
*/

#define XENO_SLASH 80

#define XENO_DOOR_BUILDING_CHANCE 40

#define PLASMA_RETREAT_PERCENTAGE 10
#define HEALTH_RETREAT_PERCENTAGE 20

#define LURKING_IGNORE_SHOT_CHANCE 75

// Warrior

/// How likely should it be that you lunge when off cooldown?
#define WARRIOR_LUNGE 40
/// How far should the warrior be before they attempt to lunge?
#define WARRIOR_LUNGE_RANGE 7
/// How likely should it be that you punch when off cooldown?
#define WARRIOR_PUNCH 15
/// How likely should it be that you fling when off cooldown?
#define WARRIOR_FLING 25

// Spitter

#define SPITTER_SPIT 90
#define SPITTER_FRENZY 20
#define SPITTER_SPRAY 80
#define SPITTER_SPRAY_SPIT_PERIOD 3 SECONDS

// Sentinel

#define SENTINEL_SPIT 90

// Runner

#define RUNNER_POUNCE 75
#define RUNNER_POUNCE_RANGE 7
#define RUNNER_GRAB 100

// Lurker

#define LURKER_POUNCE 75
#define LURKER_POUNCE_RANGE 7
#define LURKER_INVISIBLE 100
#define LURKER_POWER_SLASH 100

// Defender

#define DEFENDER_TAILWHIP 40
#define DEFENDER_HEADBUTT 75

// Crusher

/// How often is the crusher going to stomp whilst they're standing over you
#define CRUSHER_STOMP 100
/// How often will a crusher stomp after a charge
#define CRUSHER_STOMP_CHARGE 40
#define CRUSHER_POUNCE_RANGE 7
#define CRUSHER_POUNCE 75
#define CRUSHER_SHIELD 100
/// At what health percentage to proc crusher's shield.
#define CRUSHER_SHIELD_HEALTH_PROC 0.25

// Praetorian

#define PRAETORIAN_DASH 100
#define PRAETORIAN_SPIT 80
#define PRAETORIAN_SPRAY 80


/// Special blockers for pathfinding or obstacle handling
#define AI_SPECIAL_BLOCKERS list(/obj/flamer_fire, /mob/living, /obj/vehicle/multitile, /turf/open/space, /turf/open/gm/river)

// Friend-or-foe universal check
#define IS_SAME_HIVENUMBER(A,B) (A.hivenumber == B.hivenumber)
