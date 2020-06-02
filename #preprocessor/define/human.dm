//Life variables
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS 1 //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 3 ticks.

///////////////////HUMAN BLOODTYPES///////////////////
#define HUMAN_BLOODTYPES list("O-","O+","A-","A+","B-","B+","AB-","AB+")

#define HUMAN_MAX_PALENESS	30 //this is added to human skin tone to get value of pale_max variable

#define HUMAN_STRIP_DELAY 40 //takes 40ds = 4s to strip someone.
#define POCKET_STRIP_DELAY 20

///////////////////LIMB DEFINES///////////////////
#define LIMB_BROKEN 1
#define LIMB_DESTROYED 2 //limb is missing
#define LIMB_ROBOT 4
#define LIMB_SPLINTED 8
#define LIMB_MUTATED 16 //limb is deformed by mutations
#define LIMB_AMPUTATED 32 //limb was amputated cleanly or destroyed limb was cleaned up, thus causing no pain
#define LIMB_REPAIRED 64 //we just repaired the bone, stops the gelling after setting

///////////////SURGERY DEFINES///////////////
#define SPECIAL_SURGERY_INVALID	"special_surgery_invalid"

#define HEMOSTAT_MIN_DURATION 40
#define HEMOSTAT_MAX_DURATION 60

#define BONESETTER_MIN_DURATION 60
#define BONESETTER_MAX_DURATION 80

#define BONEGEL_REPAIR_MIN_DURATION 40
#define BONEGEL_REPAIR_MAX_DURATION 60

#define FIXVEIN_MIN_DURATION 60
#define FIXVEIN_MAX_DURATION 80

#define FIX_ORGAN_MIN_DURATION 60
#define FIX_ORGAN_MAX_DURATION 80

#define RETRACTOR_MIN_DURATION 30
#define RETRACTOR_MAX_DURATION 40

#define CIRCULAR_SAW_MIN_DURATION 60
#define CIRCULAR_SAW_MAX_DURATION 80

#define INCISION_MANAGER_MIN_DURATION 60
#define INCISION_MANAGER_MAX_DURATION 80

#define SCALPEL_MIN_DURATION 40
#define SCALPEL_MAX_DURATION 60

#define CAUTERY_MIN_DURATION 60
#define CAUTERY_MAX_DURATION 80

#define AMPUTATION_MIN_DURATION 90
#define AMPUTATION_MAX_DURATION 110

#define SURGICAL_DRILL_MIN_DURATION 90
#define SURGICAL_DRILL_MAX_DURATION 110

#define IMPLANT_MIN_DURATION 60
#define IMPLANT_MAX_DURATION 80

#define REMOVE_OBJECT_MIN_DURATION 60
#define REMOVE_OBJECT_MAX_DURATION 80

#define BONECHIPS_MAX_DAMAGE 20

#define LIMB_PRINTING_TIME 550
#define LIMB_METAL_AMOUNT 125

// Surgery chance modifiers
#define SURGERY_MULTIPLIER_SMALL 	0.10
#define SURGERY_MULTIPLIER_MEDIUM 	0.20
#define SURGERY_MULTIPLIER_LARGE	0.40
#define SURGERY_MULTIPLIER_HUGE 	0.60

// ORDERS
#define COMMAND_ORDER_RANGE		7
#define COMMAND_ORDER_COOLDOWN 	800
#define COMMAND_ORDER_MOVE 		"move"
#define COMMAND_ORDER_FOCUS 	"focus"
#define COMMAND_ORDER_HOLD 		"hold"

//Human Overlays Indexes used in update_icons/////////
#define UNDERWEAR_LAYER			37
#define UNDERSHIRT_LAYER		36
#define MUTANTRACE_LAYER		35
#define DAMAGE_LAYER			34
#define UNIFORM_LAYER			33
#define TAIL_LAYER				32	//bs12 specific. this hack is probably gonna come back to haunt me
#define ID_LAYER				31
#define SHOES_LAYER				30
#define GLOVES_LAYER			29
#define MEDICAL_LAYER			28	//For splint and gauze overlays
#define SUIT_LAYER				27
#define SUIT_GARB_LAYER			26
#define SUIT_SQUAD_LAYER		25
#define GLASSES_LAYER			24
#define BELT_LAYER				23
#define SUIT_STORE_LAYER		22
#define BACK_LAYER				21
#define HAIR_LAYER				20
#define FACIAL_LAYER			19
#define EARS_LAYER				18
#define FACEMASK_LAYER			17
#define HEAD_LAYER				16
#define HEAD_SQUAD_LAYER		15
#define HEAD_GARB_LAYER_2		14	// These actual defines are unused but this space within the overlays list is
#define HEAD_GARB_LAYER_3		13	//  |
#define HEAD_GARB_LAYER_4		12	//  |
#define HEAD_GARB_LAYER_5		11	// End here
#define HEAD_GARB_LAYER			10
#define COLLAR_LAYER			9
#define HANDCUFF_LAYER			8
#define LEGCUFF_LAYER			7
#define L_HAND_LAYER			6
#define R_HAND_LAYER			5
#define BURST_LAYER				4	//Chestburst overlay
#define TARGETED_LAYER			3	//for target sprites when held at gun point, and holo cards.
#define FIRE_LAYER				2	//If you're on fire		//BS12: Layer for the target overlay from weapon targeting system
#define EFFECTS_LAYER			1  //If you're hit by an acid DoT
#define TOTAL_LAYERS			37
//////////////////////////////////