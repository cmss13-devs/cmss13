#define BLOCKED_MOVEMENT (NORTH|SOUTH|EAST|WEST)
#define NO_BLOCKED_MOVEMENT 0

#define LOW_LAUNCH      0
#define NORMAL_LAUNCH   1
#define HIGH_LAUNCH     2

// Speed = [1/(MOVE_DELAY + 0.5)]*10
#define SPEED_INSTANT       20
#define SPEED_VERY_FAST     10
#define SPEED_FAST          6.67
#define SPEED_AVERAGE       5
#define SPEED_SLOW          4
#define SPEED_VERY_SLOW     3.33
#define MAX_SPEED           20
#define MIN_SPEED           1

#define MINIMAL_MOVEMENT_INTERVAL 0.1 SECONDS