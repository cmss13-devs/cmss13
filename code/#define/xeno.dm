#define TUNNEL_MOVEMENT_XENO_DELAY 20
#define TUNNEL_MOVEMENT_BIG_XENO_DELAY 60
#define TUNNEL_MOVEMENT_LARVA_DELAY 5

#define TUNNEL_ENTER_XENO_DELAY 40
#define TUNNEL_ENTER_BIG_XENO_DELAY 120
#define TUNNEL_ENTER_LARVA_DELAY 10

#define RESIN_WALL 1
#define RESIN_DOOR 2
#define RESIN_MEMBRANE 4
#define RESIN_NEST 8
#define RESIN_STICKY 16
#define RESIN_FAST 32

#define XENO_ACTION_CLICK  0 // Just select the action (base). Toggles can use this too
#define XENO_ACTION_ACTIVATE 1 // Actually use the action SHOULD ONLY BE USED ON ACTIVABLE ACTIONS OR ELSE WILL NOT WORK
#define XENO_ACTION_QUEUE 2 // Tell the action handler to queue the action for next click

#define XENO_MAXOVERHEAL_OF_MAXHEALTH 0.9 //Determines the max overheal of xenos, based on a procentage of max health.
#define XENO_ENEMIES_FOR_MAXOVERHEAL 6 //Amount of enemies required to get max overheal