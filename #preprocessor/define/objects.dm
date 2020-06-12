// Doors!
#define DOOR_CRUSH_DAMAGE 10

/*
	Atmos Machinery
*/
#define MAX_SIPHON_FLOWRATE		2500	//L/s	This can be used to balance how fast a room is siphoned. Anything higher than CELL_VOLUME has no effect.
#define MAX_SCRUBBER_FLOWRATE	200		//L/s	Max flow rate when scrubbing from a turf.

//These balance how easy or hard it is to create huge pressure gradients with pumps and filters. Lower values means it takes longer to create large pressures differences.
//Has no effect on pumping gasses from high pressure to low, only from low to high. Must be between 0 and 1.
#define ATMOS_PUMP_EFFICIENCY	2.5
#define ATMOS_FILTER_EFFICIENCY	2.5

//will not bother pumping or filtering if the gas source as fewer than this amount of moles, to help with performance.
#define MINUMUM_MOLES_TO_PUMP	0.01
#define MINUMUM_MOLES_TO_FILTER	0.1

//The flow rate/effectiveness of various atmos devices is limited by their internal volume, so for many atmos devices these will control maximum flow rates in L/s
#define ATMOS_DEFAULT_VOLUME_PUMP	200	//L
#define ATMOS_DEFAULT_VOLUME_FILTER	200	//L
#define ATMOS_DEFAULT_VOLUME_MIXER	200	//L
#define ATMOS_DEFAULT_VOLUME_PIPE	70	//L

// channel numbers for power
#define POWER_CHANNEL_EQUIP		1
#define POWER_CHANNEL_LIGHT		2
#define POWER_CHANNEL_ENVIRON	3
#define POWER_CHANNEL_ONEOFF  	4   //One-off power usage
#define POWER_CHANNEL_TOTAL		5	//for total power used only

// bitflags for machine stat variable
#define FULLY_REPAIRED			0
#define WORKING					0
#define REPAIR_STEP_FOUR		1 // Generic step names to allow for less than four repair steps
#define REPAIR_STEP_THREE		2
#define REPAIR_STEP_TWO			4
#define REPAIR_STEP_ONE			8
#define BROKEN					16
#define NOPOWER					32
#define POWEROFF				64		// tbd
#define MAINT					128		// under maintaince
#define EMPED					256		// temporary broken by EMP pulse
#define MACHINE_DO_NOT_PROCESS 	32768 //Do not added these to processing queue.

//bitflags for door switches.
#define OPEN	1
#define IDSCAN	2
#define BOLTS	4
#define SHOCK	8
#define SAFE	16

//metal, glass, rod stacks
#define MAX_STACK_AMOUNT_METAL	50
#define MAX_STACK_AMOUNT_GLASS	50
#define MAX_STACK_AMOUNT_RODS	60

#define GAS_O2 	(1 << 0)
#define GAS_N2	(1 << 1)
#define GAS_PL	(1 << 2)
#define GAS_CO2	(1 << 3)
#define GAS_N2O	(1 << 4)

var/list/liftable_structures = list(
	/obj/structure/machinery/autolathe,
	/obj/structure/machinery/constructable_frame,
	/obj/structure/machinery/portable_atmospherics/hydroponics,
	/obj/structure/machinery/computer,
	/obj/structure/machinery/optable,
	/obj/structure/dispenser,
	/obj/structure/machinery/gibber,
	/obj/structure/machinery/microwave,
	/obj/structure/machinery/vending,
	/obj/structure/machinery/seed_extractor,
	/obj/structure/machinery/space_heater,
	/obj/structure/machinery/recharge_station,
	/obj/structure/machinery/flasher,
	/obj/structure/bed/stool,
	/obj/structure/closet,
	/obj/structure/machinery/photocopier,
	/obj/structure/filingcabinet,
	/obj/structure/reagent_dispensers,
	/obj/structure/machinery/portable_atmospherics/canister)

//Pulse levels, very simplified
#define PULSE_NONE		0	//so !M.pulse checks would be possible
#define PULSE_SLOW		1	//<60 bpm
#define PULSE_NORM		2	//60-90 bpm
#define PULSE_FAST		3	//90-120 bpm
#define PULSE_2FAST		4	//>120 bpm
#define PULSE_THREADY	5	//occurs during hypovolemic shock
//feel free to add shit to lists below
var/list/tachycardics = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine")	//increase heart rate
var/list/bradycardics = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")					//decrease heart rate
var/list/heartstopper = list("potassium_phorochloride", "zombie_powder") //this stops the heart
var/list/cheartstopper = list("potassium_chloride") //this stops the heart when overdose is met -- c = conditional

//proc/get_pulse methods
#define GETPULSE_HAND	0	//less accurate (hand)
#define GETPULSE_TOOL	1	//more accurate (med scanner, sleeper, etc)

var/list/RESTRICTED_CAMERA_NETWORKS = list( //Those networks can only be accessed by preexisting terminals. AIs and new terminals can't use them.
	"thunder",
	"ERT",
	"NUKE",
	"LADDER"
	)

#define STASIS_IN_BAG 		1
#define STASIS_IN_CRYO_CELL 2


// How diagonal movement is checked
#define DIAG_MOVE_DEFAULT	0 // Diagonal movement checks obstacles on the sides
#define DIAG_MOVE_OLD		1 // Diagonal movement just check start turf and destination turf

// Shuttle defines

#define SHUTTLE_OPTIMIZE_FACTOR_RECHARGE 0.75
#define SHUTTLE_OPTIMIZE_FACTOR_TRAVEL 0.5
#define SHUTTLE_COOLING_FACTOR_RECHARGE 0.5
#define SHUTTLE_FUEL_ENHANCE_FACTOR_TRAVEL 0.75


//sharp item defines
#define IS_SHARP_ITEM_SIMPLE 		1 //not easily usable to cut or slice. e.g. shard, wirecutters, spear
#define IS_SHARP_ITEM_ACCURATE		2 //knife, scalpel
#define IS_SHARP_ITEM_BIG			3 //fireaxe, hatchet, energy sword


//pry capable item defines
#define IS_PRY_CAPABLE_SIMPLE		1
#define IS_PRY_CAPABLE_CROWBAR		2 //actual crowbar
#define IS_PRY_CAPABLE_FORCE		3 //can force open even powered airlocks


#define SELF_DESTRUCT_MACHINE_INACTIVE 0
#define SELF_DESTRUCT_MACHINE_ACTIVE 1
#define SELF_DESTRUCT_MACHINE_ARMED 2


#define SELF_DESTRUCT_ROD_STARTUP_TIME 12000

// Flamer fire shapes
#define FLAMESHAPE_DEFAULT 			1
#define FLAMESHAPE_STAR				2
#define FLAMESHAPE_MINORSTAR		3
#define FLAMESHAPE_IRREGULAR		4

#define DIRT_SPLATTER "splatter" //Blood, vomit, oil 
#define DIRT_JUNK "junk" //Gibs, Robot debris, etcetera
#define DIRT_MISC "misc" //Anything else

//For nuke announcements
#define NUKE_SHOW_TIMER_TEN_SEC	1
#define NUKE_SHOW_TIMER_MINUTE	2
#define NUKE_SHOW_TIMER_HALF	4
#define NUKE_SHOW_TIMER_ALL		(NUKE_SHOW_TIMER_TEN_SEC|NUKE_SHOW_TIMER_MINUTE|NUKE_SHOW_TIMER_HALF)