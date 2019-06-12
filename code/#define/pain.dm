// Pain

// Multipliers to apply to each damagetype to get the applied traumatic shock
#define OXY_TRAUMA_MULTIPLIER 1.0
#define TOX_TRAUMA_MULTIPLIER 1.0
#define BRUTE_TRAUMA_MULTILPLIER 1.2
#define FIRE_TRAUMA_MULTIPLIER 1.2
#define CLONE_TRAUMA_MULTIPLIER 1.5

// traumatic shock levels 
#define TRAUMA_VERYLOW  40	// ~ 10 damage
#define TRAUMA_LOW  	80 	// ~ 60 damage
#define TRAUMA_LOWMED  	100 // ~ 90 damage 
#define TRAUMA_MED  	140 // ~ 110 damage
#define TRAUMA_HIGHMED	170	// ~ 140 damage 
#define TRAUMA_HIGH 	200	// ~ 160+ damage 

// Movespeed levels
#define PAIN_SPEED_VERYSLOW  5.75
#define PAIN_SPEED_SLOW      4.5
#define PAIN_SPEED_MED       3.25
#define PAIN_SPEED_LOWMED    2.25
#define PAIN_SPEED_LOW       1.25

// Shock gain rates - effectively, how quickly pain nasty effects apply
#define SHOCK_GAIN_RATE_HIGH 9
#define SHOCK_GAIN_RATE_MED  6
#define SHOCK_GAIN_RATE_LOW  3
#define SHOCK_GAIN_RATE_VLOW 1

// Damage thresholds that cap shock stages
// and decide how much shock stage we pick up per tick
#define HEALTH_THRESHOLD_VERYLOWSHOCK 	60		 // Hey, this tickles! used to make pain less bipolar mostly 
#define HEALTH_THRESHOLD_LOWSHOCK       40 		 // We've taken 60 damage, time to at least apply SOME pain effects 
#define HEALTH_THRESHOLD_MEDSHOCK  		10		 // We've taken 90 damage. Time to turn up the heat 
#define HEALTH_THRESHOLD_HIGHSHOCK 	    -20		 // We are seriously injured (-120 damage)
#define HEALTH_THRESHOLD_VERYHIGHSHOCK  -50		 // We are about to die (-150 damage)

// Max shock levels - these map DIRECTLY to the above defines and 
// define the maximum shock_stage we can accrue with the given amount of damage
#define MAXSHOCK_VERYLOW    29    
#define MAXSHOCK_LOW        59
#define MAXSHOCK_MED        79
#define MAXSHOCK_HIGH       119
#define MAXSHOCK_VERYHIGH   200 // Global max

// How slow we go from losing a limb
#define MOVE_REDUCTION_LIMB_DESTROYED 4.0
#define MOVE_REDUCTION_LIMB_BROKEN    1.5
#define MOVE_REDUCTION_LIMB_SPLINTED  0.5

// Traumatic shock reduction for different reagents
#define PAIN_REDUCTION_VERY_LIGHT	-15  //alkysine
#define PAIN_REDUCTION_LIGHT		-20  //inaprovaline
#define PAIN_REDUCTION_MEDIUM		-30  //synaptizine
#define PAIN_REDUCTION_HEAVY		-40  //paracetamol
#define PAIN_REDUCTION_VERY_HEAVY	-60  //tramadol
#define PAIN_REDUCTION_FULL			-200 //oxycodone, neuraline